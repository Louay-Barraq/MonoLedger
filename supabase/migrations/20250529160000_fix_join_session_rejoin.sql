-- Allow players who LEFT to rejoin (status -> ACTIVE).
-- Block players who were KICKED from rejoining.
-- Applied to project kmceonhtubcrrzfpoxra as migration fix_join_session_rejoin

DROP FUNCTION IF EXISTS public.join_session_by_code(text, text);
DROP FUNCTION IF EXISTS public.reactivate_left_player(uuid, text);

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
  WHERE session_id = v_session_id AND user_id = v_user_id;

  IF FOUND THEN
    IF v_existing.status = 'KICKED' THEN
      RAISE EXCEPTION 'player_kicked';
    END IF;

    IF v_existing.status = 'LEFT' THEN
      UPDATE public.players
      SET
        status = 'ACTIVE',
        name = COALESCE(NULLIF(trim(p_player_name), ''), v_existing.name),
        balance = v_starting_balance,
        is_banker = FALSE
      WHERE id = v_existing.id;
    ELSIF v_existing.status = 'ACTIVE' THEN
      UPDATE public.players
      SET name = COALESCE(NULLIF(trim(p_player_name), ''), v_existing.name)
      WHERE id = v_existing.id;
    ELSE
      RAISE EXCEPTION 'player_not_eligible';
    END IF;
  ELSE
    INSERT INTO public.players (session_id, user_id, name, balance, status, is_banker)
    VALUES (
      v_session_id,
      v_user_id,
      trim(p_player_name),
      v_starting_balance,
      'ACTIVE',
      FALSE
    );
  END IF;

  RETURN (
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
    WHERE s.id = v_session_id
  );
END;
$$;

GRANT EXECUTE ON FUNCTION public.join_session_by_code(TEXT, TEXT) TO authenticated;

-- Fallback RPC used by the app if join returns a LEFT row before migration is applied everywhere.
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
  v_starting_balance NUMERIC;
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

  SELECT COALESCE((config->>'starting_balance')::NUMERIC, 1500)
  INTO v_starting_balance
  FROM public.sessions
  WHERE id = p_session_id;

  UPDATE public.players
  SET
    status = 'ACTIVE',
    name = COALESCE(NULLIF(trim(p_player_name), ''), v_existing.name),
    balance = v_starting_balance,
    is_banker = FALSE
  WHERE id = v_existing.id;

  RETURN (
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
    WHERE s.id = p_session_id
  );
END;
$$;

GRANT EXECUTE ON FUNCTION public.reactivate_left_player(UUID, TEXT) TO authenticated;
