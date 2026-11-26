-- Follow-ups to the audit:
--  * GO requests from players who left or were kicked never get paid.
--  * profiles are private to their owner.
--  * The Banker can reverse a transaction (writes the opposite entry once).

-- GO: approving needs an open session and an ACTIVE requester; a stale request
-- is closed as rejected instead of lingering in the Banker's banner.
CREATE OR REPLACE FUNCTION public.resolve_collect_go(p_request_id UUID, p_approve BOOLEAN)
RETURNS public.go_salary_requests
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_req public.go_salary_requests;
  v_banker public.players;
  v_requester_active BOOLEAN;
BEGIN
  SELECT * INTO v_req FROM public.go_salary_requests WHERE id = p_request_id FOR UPDATE;
  IF NOT FOUND THEN
    RAISE EXCEPTION 'go_request_not_found';
  END IF;

  IF v_req.status <> 'pending' THEN
    RAISE EXCEPTION 'go_request_not_pending';
  END IF;

  PERFORM public.assert_session_open(v_req.session_id);
  v_banker := public.current_banker_in_session(v_req.session_id); -- raises only_banker

  SELECT status = 'ACTIVE' INTO v_requester_active
  FROM public.players WHERE id = v_req.requester_player_id;

  IF p_approve AND v_requester_active THEN
    UPDATE public.players
    SET balance = balance + v_req.amount
    WHERE id = v_req.requester_player_id;

    INSERT INTO public.transactions (session_id, type, from_player_id, to_player_id, amount, memo, created_by)
    VALUES (v_req.session_id, 'collect_go', NULL, v_req.requester_player_id, v_req.amount, 'PASSED GO', auth.uid());
  END IF;

  UPDATE public.go_salary_requests
  SET
    status = CASE WHEN p_approve AND v_requester_active THEN 'approved' ELSE 'rejected' END,
    resolved_at = now(),
    resolved_by_player_id = v_banker.id
  WHERE id = p_request_id
  RETURNING * INTO v_req;

  RETURN v_req;
END;
$$;

-- Close a departing player's pending GO requests (leave or kick).
CREATE OR REPLACE FUNCTION public.reject_pending_go_on_departure()
RETURNS trigger
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
BEGIN
  IF OLD.status = 'ACTIVE' AND NEW.status IN ('LEFT', 'KICKED') THEN
    UPDATE public.go_salary_requests
    SET status = 'rejected', resolved_at = now()
    WHERE requester_player_id = NEW.id AND status = 'pending';
  END IF;
  RETURN NEW;
END;
$$;

DROP TRIGGER IF EXISTS trigger_reject_pending_go_on_departure ON public.players;
CREATE TRIGGER trigger_reject_pending_go_on_departure
  AFTER UPDATE OF status ON public.players
  FOR EACH ROW
  EXECUTE FUNCTION public.reject_pending_go_on_departure();

-- Requests already orphaned before this migration.
UPDATE public.go_salary_requests r
SET status = 'rejected', resolved_at = now()
FROM public.players p
WHERE r.requester_player_id = p.id
  AND r.status = 'pending'
  AND p.status <> 'ACTIVE';

-- profiles: readable and editable only by their owner (the app does not use them).
DROP POLICY IF EXISTS "Public profiles are viewable by everyone." ON public.profiles;
DROP POLICY IF EXISTS "Users can view own profile." ON public.profiles;
CREATE POLICY "Users can view own profile." ON public.profiles
  FOR SELECT TO authenticated
  USING (id = (SELECT auth.uid()));
REVOKE ALL ON public.profiles FROM anon;
REVOKE DELETE, TRUNCATE ON public.profiles FROM authenticated;

-- Reversal: one opposite entry per transaction, never a reversal of a reversal.
ALTER TABLE public.transactions
  ADD COLUMN IF NOT EXISTS reverses_tx_id UUID UNIQUE REFERENCES public.transactions(id) ON DELETE SET NULL;

CREATE OR REPLACE FUNCTION public.reverse_transaction(p_tx_id UUID)
RETURNS public.transactions
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_orig public.transactions;
  v_tx public.transactions;
  v_debit_player UUID;   -- player who gives the money back (NULL = bank)
  v_credit_player UUID;  -- player who gets it back (NULL = bank)
  v_type TEXT;
BEGIN
  SELECT * INTO v_orig FROM public.transactions WHERE id = p_tx_id FOR UPDATE;
  IF NOT FOUND THEN
    RAISE EXCEPTION 'transaction_not_found';
  END IF;

  PERFORM public.assert_session_open(v_orig.session_id);
  PERFORM public.current_banker_in_session(v_orig.session_id); -- raises only_banker

  IF v_orig.reverses_tx_id IS NOT NULL THEN
    RAISE EXCEPTION 'cannot_reverse_reversal';
  END IF;
  IF EXISTS (SELECT 1 FROM public.transactions WHERE reverses_tx_id = p_tx_id) THEN
    RAISE EXCEPTION 'already_reversed';
  END IF;

  v_debit_player := v_orig.to_player_id;
  v_credit_player := v_orig.from_player_id;
  v_type := CASE v_orig.type
    WHEN 'player_to_player' THEN 'player_to_player'
    WHEN 'pay_bank' THEN 'from_bank'
    ELSE 'pay_bank' -- from_bank, collect_go
  END;

  IF (v_orig.type = 'player_to_player' AND (v_debit_player IS NULL OR v_credit_player IS NULL))
     OR (v_orig.type = 'pay_bank' AND v_credit_player IS NULL)
     OR (v_orig.type IN ('from_bank', 'collect_go') AND v_debit_player IS NULL) THEN
    RAISE EXCEPTION 'player_not_found';
  END IF;

  IF v_debit_player IS NOT NULL THEN
    UPDATE public.players SET balance = balance - v_orig.amount
    WHERE id = v_debit_player AND balance >= v_orig.amount;
    IF NOT FOUND THEN
      RAISE EXCEPTION 'insufficient_funds';
    END IF;
  END IF;

  IF v_credit_player IS NOT NULL THEN
    UPDATE public.players SET balance = balance + v_orig.amount WHERE id = v_credit_player;
  END IF;

  INSERT INTO public.transactions (
    session_id, type, from_player_id, to_player_id, amount, memo, created_by, reverses_tx_id
  ) VALUES (
    v_orig.session_id, v_type, v_debit_player, v_credit_player, v_orig.amount, 'REVERSAL', auth.uid(), p_tx_id
  )
  RETURNING * INTO v_tx;

  RETURN v_tx;
END;
$$;

REVOKE EXECUTE ON FUNCTION public.reverse_transaction(UUID) FROM PUBLIC, anon;
GRANT EXECUTE ON FUNCTION public.reverse_transaction(UUID) TO authenticated;
REVOKE EXECUTE ON FUNCTION public.reject_pending_go_on_departure() FROM PUBLIC, anon, authenticated;
