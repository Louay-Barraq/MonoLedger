-- First drop the old ones to avoid confusion and overloading issues
DROP FUNCTION IF EXISTS public.join_session_by_code(TEXT);
DROP FUNCTION IF EXISTS public.join_session_by_code(TEXT, TEXT);

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
    v_session public.sessions%ROWTYPE;
    v_starting_balance NUMERIC;
    v_user_id UUID;
BEGIN
    v_user_id := auth.uid();
    IF v_user_id IS NULL THEN
        RAISE EXCEPTION 'Not authenticated';
    END IF;

    -- 1. Find the session
    SELECT * INTO v_session
    FROM public.sessions
    WHERE session_code = p_session_code 
      AND (status = 'open' OR status = 'ACTIVE');

    IF v_session.id IS NULL THEN
        RAISE EXCEPTION 'invalid_session';
    END IF;

    v_starting_balance := COALESCE((v_session.config->>'starting_balance')::NUMERIC, 1500);

    -- 2. Add as player (or update name if exists)
    INSERT INTO public.players (session_id, user_id, name, is_banker, balance)
    VALUES (v_session.id, v_user_id, p_player_name, FALSE, v_starting_balance)
    ON CONFLICT (session_id, user_id) 
    DO UPDATE SET name = EXCLUDED.name;

    -- 3. Return full session row as JSONB
    RETURN row_to_json(v_session)::jsonb;
END;
$$;
;
