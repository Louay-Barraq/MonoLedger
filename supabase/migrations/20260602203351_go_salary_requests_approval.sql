-- Banker-approved GO salary: pending requests + resolve RPCs.

CREATE TABLE IF NOT EXISTS public.go_salary_requests (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  session_id UUID NOT NULL REFERENCES public.sessions(id) ON DELETE CASCADE,
  requester_player_id UUID NOT NULL REFERENCES public.players(id) ON DELETE CASCADE,
  amount NUMERIC NOT NULL CHECK (amount > 0),
  status TEXT NOT NULL DEFAULT 'pending'
    CHECK (status IN ('pending', 'approved', 'rejected')),
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  resolved_at TIMESTAMPTZ,
  resolved_by_player_id UUID REFERENCES public.players(id) ON DELETE SET NULL
);

CREATE INDEX IF NOT EXISTS idx_go_salary_requests_session_status
  ON public.go_salary_requests (session_id, status);

ALTER TABLE public.go_salary_requests ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS go_requests_select_session_members ON public.go_salary_requests;
CREATE POLICY go_requests_select_session_members ON public.go_salary_requests
  FOR SELECT TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM public.players p
      WHERE p.session_id = go_salary_requests.session_id
        AND p.user_id = auth.uid()
        AND p.status = 'ACTIVE'
    )
  );

DROP POLICY IF EXISTS go_requests_insert_own ON public.go_salary_requests;
CREATE POLICY go_requests_insert_own ON public.go_salary_requests
  FOR INSERT TO authenticated
  WITH CHECK (
    requester_player_id IN (
      SELECT id FROM public.players
      WHERE session_id = go_salary_requests.session_id
        AND user_id = auth.uid()
        AND status = 'ACTIVE'
    )
    AND status = 'pending'
  );

DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_publication_tables
    WHERE pubname = 'supabase_realtime' AND tablename = 'go_salary_requests'
  ) THEN
    ALTER PUBLICATION supabase_realtime ADD TABLE public.go_salary_requests;
  END IF;
END $$;

CREATE OR REPLACE FUNCTION public.request_collect_go(p_session_id UUID)
RETURNS public.go_salary_requests
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_player public.players;
  v_go_amount NUMERIC;
  v_row public.go_salary_requests;
  v_tx public.transactions;
BEGIN
  PERFORM public.assert_session_open(p_session_id);
  v_player := public.current_player_in_session(p_session_id);

  SELECT COALESCE((config->>'go_amount')::NUMERIC, 200)
  INTO v_go_amount
  FROM public.sessions WHERE id = p_session_id;

  IF v_player.is_banker THEN
    UPDATE public.players SET balance = balance + v_go_amount WHERE id = v_player.id;
    INSERT INTO public.transactions (session_id, type, from_player_id, to_player_id, amount, memo, created_by)
    VALUES (p_session_id, 'collect_go', NULL, v_player.id, v_go_amount, 'PASSED GO', auth.uid())
    RETURNING * INTO v_tx;

    INSERT INTO public.go_salary_requests (
      session_id, requester_player_id, amount, status, resolved_at, resolved_by_player_id
    ) VALUES (
      p_session_id, v_player.id, v_go_amount, 'approved', now(), v_player.id
    ) RETURNING * INTO v_row;
    RETURN v_row;
  END IF;

  IF EXISTS (
    SELECT 1 FROM public.go_salary_requests
    WHERE session_id = p_session_id
      AND requester_player_id = v_player.id
      AND status = 'pending'
  ) THEN
    RAISE EXCEPTION 'go_request_pending';
  END IF;

  INSERT INTO public.go_salary_requests (session_id, requester_player_id, amount, status)
  VALUES (p_session_id, v_player.id, v_go_amount, 'pending')
  RETURNING * INTO v_row;

  RETURN v_row;
END;
$$;

CREATE OR REPLACE FUNCTION public.resolve_collect_go(
  p_request_id UUID,
  p_approve BOOLEAN
)
RETURNS public.go_salary_requests
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_req public.go_salary_requests;
  v_banker public.players;
BEGIN
  SELECT * INTO v_req FROM public.go_salary_requests WHERE id = p_request_id FOR UPDATE;
  IF NOT FOUND THEN
    RAISE EXCEPTION 'go_request_not_found';
  END IF;

  IF v_req.status <> 'pending' THEN
    RAISE EXCEPTION 'go_request_not_pending';
  END IF;

  SELECT * INTO v_banker
  FROM public.players
  WHERE session_id = v_req.session_id
    AND user_id = auth.uid()
    AND status = 'ACTIVE'
    AND is_banker = TRUE;

  IF NOT FOUND THEN
    RAISE EXCEPTION 'only_banker';
  END IF;

  IF p_approve THEN
    UPDATE public.players
    SET balance = balance + v_req.amount
    WHERE id = v_req.requester_player_id;

    INSERT INTO public.transactions (
      session_id, type, from_player_id, to_player_id, amount, memo, created_by
    ) VALUES (
      v_req.session_id, 'collect_go', NULL, v_req.requester_player_id,
      v_req.amount, 'PASSED GO', auth.uid()
    );
  END IF;

  UPDATE public.go_salary_requests
  SET
    status = CASE WHEN p_approve THEN 'approved' ELSE 'rejected' END,
    resolved_at = now(),
    resolved_by_player_id = v_banker.id
  WHERE id = p_request_id
  RETURNING * INTO v_req;

  RETURN v_req;
END;
$$;

REVOKE EXECUTE ON FUNCTION public.collect_go_salary(UUID) FROM authenticated;

GRANT EXECUTE ON FUNCTION public.request_collect_go(UUID) TO authenticated;
GRANT EXECUTE ON FUNCTION public.resolve_collect_go(UUID, BOOLEAN) TO authenticated;;
