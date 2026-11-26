-- Replace legacy transactions schema (sender_id/receiver_id) with typed ledger + RPCs
DROP TABLE IF EXISTS public.transactions CASCADE;

CREATE TABLE public.transactions (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  session_id UUID NOT NULL REFERENCES public.sessions(id) ON DELETE CASCADE,
  type TEXT NOT NULL CHECK (type IN ('player_to_player', 'pay_bank', 'from_bank', 'collect_go')),
  from_player_id UUID REFERENCES public.players(id) ON DELETE SET NULL,
  to_player_id UUID REFERENCES public.players(id) ON DELETE SET NULL,
  amount NUMERIC NOT NULL CHECK (amount > 0),
  memo TEXT,
  created_by UUID REFERENCES auth.users(id),
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX idx_transactions_session_id ON public.transactions(session_id);
CREATE INDEX idx_transactions_created_at ON public.transactions(session_id, created_at DESC);

ALTER TABLE public.transactions ENABLE ROW LEVEL SECURITY;

CREATE POLICY transactions_select_session_members ON public.transactions
  FOR SELECT
  USING (
    EXISTS (
      SELECT 1 FROM public.players p
      WHERE p.session_id = transactions.session_id
        AND p.user_id = auth.uid()
        AND p.status = 'ACTIVE'
    )
  );

CREATE POLICY transactions_no_direct_insert ON public.transactions
  FOR INSERT
  WITH CHECK (false);

CREATE OR REPLACE FUNCTION public.current_player_in_session(p_session_id UUID)
RETURNS public.players
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_player public.players;
BEGIN
  SELECT * INTO v_player
  FROM public.players
  WHERE session_id = p_session_id
    AND user_id = auth.uid()
    AND status = 'ACTIVE'
  LIMIT 1;

  IF v_player.id IS NULL THEN
    RAISE EXCEPTION 'not_in_session';
  END IF;

  RETURN v_player;
END;
$$;

CREATE OR REPLACE FUNCTION public.assert_session_open(p_session_id UUID)
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_status TEXT;
BEGIN
  SELECT status INTO v_status FROM public.sessions WHERE id = p_session_id;
  IF v_status IS NULL THEN
    RAISE EXCEPTION 'session_not_found';
  END IF;
  IF v_status != 'open' THEN
    RAISE EXCEPTION 'session_closed';
  END IF;
END;
$$;

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

  IF v_from.balance < p_amount THEN
    RAISE EXCEPTION 'insufficient_funds';
  END IF;

  UPDATE public.players SET balance = balance - p_amount WHERE id = v_from.id;
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

  IF v_from.balance < p_amount THEN
    RAISE EXCEPTION 'insufficient_funds';
  END IF;

  UPDATE public.players SET balance = balance - p_amount WHERE id = v_from.id;

  INSERT INTO public.transactions (session_id, type, from_player_id, to_player_id, amount, memo, created_by)
  VALUES (p_session_id, 'pay_bank', v_from.id, NULL, p_amount, COALESCE(p_memo, 'PAY BANK'), auth.uid())
  RETURNING * INTO v_tx;

  RETURN v_tx;
END;
$$;

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
  v_to := public.current_player_in_session(p_session_id);

  UPDATE public.players SET balance = balance + p_amount WHERE id = v_to.id;

  INSERT INTO public.transactions (session_id, type, from_player_id, to_player_id, amount, memo, created_by)
  VALUES (p_session_id, 'from_bank', NULL, v_to.id, p_amount, COALESCE(p_memo, 'FROM BANK'), auth.uid())
  RETURNING * INTO v_tx;

  RETURN v_tx;
END;
$$;

CREATE OR REPLACE FUNCTION public.collect_go_salary(p_session_id UUID)
RETURNS public.transactions
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_to public.players;
  v_go_amount NUMERIC;
  v_tx public.transactions;
BEGIN
  PERFORM public.assert_session_open(p_session_id);
  v_to := public.current_player_in_session(p_session_id);

  SELECT COALESCE((config->>'go_amount')::NUMERIC, 200) INTO v_go_amount
  FROM public.sessions WHERE id = p_session_id;

  UPDATE public.players SET balance = balance + v_go_amount WHERE id = v_to.id;

  INSERT INTO public.transactions (session_id, type, from_player_id, to_player_id, amount, memo, created_by)
  VALUES (p_session_id, 'collect_go', NULL, v_to.id, v_go_amount, 'PASSED GO', auth.uid())
  RETURNING * INTO v_tx;

  RETURN v_tx;
END;
$$;

GRANT EXECUTE ON FUNCTION public.transfer_to_player(UUID, UUID, NUMERIC, TEXT) TO authenticated;
GRANT EXECUTE ON FUNCTION public.pay_bank(UUID, NUMERIC, TEXT) TO authenticated;
GRANT EXECUTE ON FUNCTION public.receive_from_bank(UUID, NUMERIC, TEXT) TO authenticated;
GRANT EXECUTE ON FUNCTION public.collect_go_salary(UUID) TO authenticated;

ALTER PUBLICATION supabase_realtime ADD TABLE public.transactions;;
