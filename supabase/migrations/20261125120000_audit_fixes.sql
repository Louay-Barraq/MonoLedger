-- Audit fixes (written against the live schema pulled on 2026-11-25).
-- Clients change money, roles and sessions only through the RPCs below.

-- 1. Only the Banker may take money from the bank.
CREATE OR REPLACE FUNCTION public.receive_from_bank(
  p_session_id UUID,
  p_amount NUMERIC,
  p_memo TEXT DEFAULT NULL
)
RETURNS public.transactions
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_to public.players;
  v_tx public.transactions;
BEGIN
  PERFORM public.assert_session_open(p_session_id);
  v_to := public.current_banker_in_session(p_session_id); -- raises only_banker

  UPDATE public.players SET balance = balance + p_amount WHERE id = v_to.id;

  INSERT INTO public.transactions (session_id, type, from_player_id, to_player_id, amount, memo, created_by)
  VALUES (p_session_id, 'from_bank', NULL, v_to.id, p_amount, COALESCE(p_memo, 'FROM BANK'), auth.uid())
  RETURNING * INTO v_tx;

  RETURN v_tx;
END;
$$;

-- 2. Pre-approval GO function: the earlier REVOKE FROM authenticated left the
--    PUBLIC grant, so anyone could still call it. perform_transfer is legacy
--    (writes columns that no longer exist) and trusts a caller-supplied sender.
DROP FUNCTION IF EXISTS public.collect_go_salary(UUID);
DROP FUNCTION IF EXISTS public.perform_transfer(UUID, UUID, UUID, NUMERIC, TEXT);

-- 3. GO requests are created only through request_collect_go.
DROP POLICY IF EXISTS go_requests_insert_own ON public.go_salary_requests;

-- 7. Debit atomically so concurrent payments cannot overdraw.
CREATE OR REPLACE FUNCTION public.transfer_to_player(
  p_session_id UUID,
  p_to_player_id UUID,
  p_amount NUMERIC,
  p_memo TEXT DEFAULT NULL
)
RETURNS public.transactions
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_from public.players;
  v_to public.players;
  v_tx public.transactions;
BEGIN
  PERFORM public.assert_session_open(p_session_id);
  v_from := public.current_player_in_session(p_session_id);

  SELECT * INTO v_to FROM public.players
  WHERE id = p_to_player_id AND session_id = p_session_id AND status = 'ACTIVE';

  IF v_to.id IS NULL THEN
    RAISE EXCEPTION 'player_not_found';
  END IF;

  IF v_from.id = v_to.id THEN
    RAISE EXCEPTION 'cannot_pay_self';
  END IF;

  UPDATE public.players SET balance = balance - p_amount
  WHERE id = v_from.id AND balance >= p_amount;
  IF NOT FOUND THEN
    RAISE EXCEPTION 'insufficient_funds';
  END IF;

  UPDATE public.players SET balance = balance + p_amount WHERE id = v_to.id;

  INSERT INTO public.transactions (session_id, type, from_player_id, to_player_id, amount, memo, created_by)
  VALUES (p_session_id, 'player_to_player', v_from.id, v_to.id, p_amount, COALESCE(p_memo, 'TRANSFER'), auth.uid())
  RETURNING * INTO v_tx;

  RETURN v_tx;
END;
$$;

CREATE OR REPLACE FUNCTION public.pay_bank(
  p_session_id UUID,
  p_amount NUMERIC,
  p_memo TEXT DEFAULT NULL
)
RETURNS public.transactions
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_from public.players;
  v_tx public.transactions;
BEGIN
  PERFORM public.assert_session_open(p_session_id);
  v_from := public.current_player_in_session(p_session_id);

  UPDATE public.players SET balance = balance - p_amount
  WHERE id = v_from.id AND balance >= p_amount;
  IF NOT FOUND THEN
    RAISE EXCEPTION 'insufficient_funds';
  END IF;

  INSERT INTO public.transactions (session_id, type, from_player_id, to_player_id, amount, memo, created_by)
  VALUES (p_session_id, 'pay_bank', v_from.id, NULL, p_amount, COALESCE(p_memo, 'PAY BANK'), auth.uid())
  RETURNING * INTO v_tx;

  RETURN v_tx;
END;
$$;

-- 4. Rejoining after leaving keeps the balance the player left with.
CREATE OR REPLACE FUNCTION public.join_session_by_code(
  p_session_code TEXT,
  p_player_name TEXT
)
RETURNS JSONB
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_session_id UUID;
  v_session_status TEXT;
  v_starting_balance NUMERIC;
  v_existing public.players%ROWTYPE;
  v_user_id UUID;
  v_color INTEGER;
BEGIN
  v_user_id := auth.uid();
  IF v_user_id IS NULL THEN
    RAISE EXCEPTION 'not_authenticated';
  END IF;

  SELECT id, status
  INTO v_session_id, v_session_status
  FROM public.sessions
  WHERE upper(trim(session_code)) = upper(trim(p_session_code));

  IF v_session_id IS NULL THEN
    RAISE EXCEPTION 'invalid_session';
  END IF;

  IF v_session_status IS DISTINCT FROM 'open' THEN
    RAISE EXCEPTION 'session_closed';
  END IF;

  SELECT COALESCE((config->>'starting_balance')::NUMERIC, 1500)
  INTO v_starting_balance
  FROM public.sessions
  WHERE id = v_session_id;

  SELECT * INTO v_existing
  FROM public.players
  WHERE session_id = v_session_id
    AND user_id = v_user_id;

  IF FOUND THEN
    IF v_existing.status = 'KICKED' THEN
      RAISE EXCEPTION 'player_kicked';
    END IF;

    IF v_existing.status IN ('LEFT', 'ACTIVE') THEN
      UPDATE public.players
      SET
        status = 'ACTIVE',
        name = COALESCE(NULLIF(trim(p_player_name), ''), v_existing.name)
      WHERE id = v_existing.id;
    ELSE
      RAISE EXCEPTION 'player_not_eligible';
    END IF;
  ELSE
    v_color := public.next_avatar_color(v_session_id);
    INSERT INTO public.players (session_id, user_id, name, balance, status, is_banker, avatar_color)
    VALUES (
      v_session_id,
      v_user_id,
      COALESCE(NULLIF(trim(p_player_name), ''), 'Player'),
      v_starting_balance,
      'ACTIVE',
      FALSE,
      v_color
    );
  END IF;

  RETURN public.session_payload(v_session_id);
END;
$$;

CREATE OR REPLACE FUNCTION public.reactivate_left_player(
  p_session_id UUID,
  p_player_name TEXT
)
RETURNS JSONB
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_existing public.players%ROWTYPE;
BEGIN
  SELECT * INTO v_existing
  FROM public.players
  WHERE session_id = p_session_id AND user_id = auth.uid();

  IF NOT FOUND THEN
    RAISE EXCEPTION 'player_not_found';
  END IF;

  IF v_existing.status = 'KICKED' THEN
    RAISE EXCEPTION 'player_kicked';
  END IF;

  IF v_existing.status <> 'LEFT' THEN
    RAISE EXCEPTION 'player_not_left';
  END IF;

  PERFORM public.assert_session_open(p_session_id);

  UPDATE public.players
  SET
    status = 'ACTIVE',
    name = COALESCE(NULLIF(trim(p_player_name), ''), v_existing.name)
  WHERE id = v_existing.id;

  RETURN public.session_payload(p_session_id);
END;
$$;

-- 10. Kick reports the right error.
CREATE OR REPLACE FUNCTION public.kick_player(
  p_session_id UUID,
  p_target_player_id UUID
)
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
BEGIN
  PERFORM public.current_banker_in_session(p_session_id); -- raises only_banker

  UPDATE public.players
  SET status = 'KICKED', is_banker = FALSE
  WHERE id = p_target_player_id
    AND session_id = p_session_id
    AND status = 'ACTIVE';
END;
$$;

-- 6. No direct writes from clients. The live policies let any signed-in user
--    insert a players row into any session (any balance, is_banker = true) and
--    let hosts rewrite their session. Every legitimate write goes through a
--    SECURITY DEFINER function or trigger, which runs as the owner and keeps working:
--    create_session (+ add_host_as_player trigger), join_session_by_code,
--    end_session, kick_player, transfer_banker, leave_session, money RPCs.
DROP POLICY IF EXISTS "Authenticated users can join sessions." ON public.players;
DROP POLICY IF EXISTS "Hosts can update sessions." ON public.sessions;
DROP POLICY IF EXISTS "Users can create sessions as host." ON public.sessions;

REVOKE INSERT, UPDATE, DELETE, TRUNCATE ON public.players            FROM PUBLIC, anon, authenticated;
REVOKE INSERT, UPDATE, DELETE, TRUNCATE ON public.sessions           FROM PUBLIC, anon, authenticated;
REVOKE INSERT, UPDATE, DELETE, TRUNCATE ON public.transactions       FROM PUBLIC, anon, authenticated;
REVOKE INSERT, UPDATE, DELETE, TRUNCATE ON public.go_salary_requests FROM PUBLIC, anon, authenticated;

-- Functions: nobody without a session token, and internal helpers not at all.
-- (Trigger functions need no EXECUTE grant to fire. RLS policies call
-- is_session_host / is_session_participant, so those stay granted.)
REVOKE EXECUTE ON ALL FUNCTIONS IN SCHEMA public FROM PUBLIC, anon;
ALTER DEFAULT PRIVILEGES IN SCHEMA public REVOKE EXECUTE ON FUNCTIONS FROM PUBLIC, anon;

REVOKE EXECUTE ON FUNCTION
  public.assert_session_open(UUID),
  public.current_player_in_session(UUID),
  public.current_banker_in_session(UUID),
  public.session_payload(UUID),
  public.generate_unique_session_code(),
  public.next_avatar_color(UUID),
  public.add_host_as_player(),
  public.create_banker_player_for_new_session(),
  public.handle_banker_inheritance(),
  public.handle_new_user(),
  public.set_updated_at()
FROM authenticated;
