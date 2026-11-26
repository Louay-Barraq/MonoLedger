CREATE OR REPLACE FUNCTION public.session_payload(p_session_id UUID)
RETURNS JSONB
LANGUAGE sql
SECURITY DEFINER
SET search_path = public
AS $$
  SELECT jsonb_build_object(
    'id', s.id,
    'status', s.status,
    'host_id', s.host_id,
    'session_code', s.session_code,
    'created_at', s.created_at,
    'config', s.config,
    'players', COALESCE(
      (
        SELECT jsonb_agg(to_jsonb(p) ORDER BY p.created_at)
        FROM public.players p
        WHERE p.session_id = s.id
      ),
      '[]'::jsonb
    )
  )
  FROM public.sessions s
  WHERE s.id = p_session_id;
$$;

CREATE OR REPLACE FUNCTION public.current_banker_in_session(p_session_id UUID)
RETURNS public.players
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_banker public.players;
BEGIN
  SELECT * INTO v_banker
  FROM public.players
  WHERE session_id = p_session_id
    AND user_id = auth.uid()
    AND status = 'ACTIVE'
    AND is_banker = TRUE
  LIMIT 1;

  IF v_banker.id IS NULL THEN
    RAISE EXCEPTION 'only_banker';
  END IF;

  RETURN v_banker;
END;
$$;

GRANT EXECUTE ON FUNCTION public.session_payload(UUID) TO authenticated;
GRANT EXECUTE ON FUNCTION public.current_banker_in_session(UUID) TO authenticated;;
