CREATE OR REPLACE FUNCTION join_session_by_code(p_session_code TEXT)
RETURNS jsonb
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  v_session RECORD;
  v_starting_balance NUMERIC;
BEGIN
  -- 1. Find the session
  SELECT * INTO v_session
  FROM public.sessions
  WHERE session_code = p_session_code;

  IF v_session.id IS NULL THEN
    RAISE EXCEPTION 'invalid_session';
  END IF;
  
  -- Support either ACTIVE or open status
  IF v_session.status != 'open' AND v_session.status != 'ACTIVE' THEN
    RAISE EXCEPTION 'session_closed';
  END IF;

  v_starting_balance := COALESCE((v_session.config->>'starting_balance')::NUMERIC, 1500);

  -- 2. Check if player already exists
  IF NOT EXISTS (
    SELECT 1 FROM public.players 
    WHERE session_id = v_session.id AND user_id = auth.uid()
  ) THEN
    -- 3. Insert the player
    INSERT INTO public.players (session_id, user_id, balance)
    VALUES (v_session.id, auth.uid(), v_starting_balance);
  END IF;

  -- Return the session as JSON so the client can use it
  RETURN row_to_json(v_session)::jsonb;
END;
$$;;
