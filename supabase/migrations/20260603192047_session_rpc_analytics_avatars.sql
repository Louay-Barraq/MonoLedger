-- Session lifecycle RPCs, player avatar colors, session analytics & history

ALTER TABLE public.players
  ADD COLUMN IF NOT EXISTS avatar_color INTEGER NOT NULL DEFAULT 0
  CHECK (avatar_color >= 0 AND avatar_color <= 9);

-- Pick lowest unused color index 1..9 for non-bankers; banker uses 0.
CREATE OR REPLACE FUNCTION public.next_avatar_color(p_session_id UUID)
RETURNS INTEGER
LANGUAGE sql
STABLE
SECURITY DEFINER
SET search_path = public
AS $$
  SELECT COALESCE(
    (
      SELECT MIN(gs.i)
      FROM generate_series(1, 9) AS gs(i)
      WHERE gs.i NOT IN (
        SELECT p.avatar_color
        FROM public.players p
        WHERE p.session_id = p_session_id
          AND p.status = 'ACTIVE'
      )
    ),
    (
      SELECT (COUNT(*)::INTEGER % 9) + 1
      FROM public.players p
      WHERE p.session_id = p_session_id
    )
  );
$$;

CREATE OR REPLACE FUNCTION public.generate_unique_session_code()
RETURNS TEXT
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_code TEXT;
  v_chars TEXT := 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
  v_attempt INTEGER := 0;
BEGIN
  LOOP
    v_code := '';
    FOR i IN 1..6 LOOP
      v_code := v_code || substr(v_chars, 1 + floor(random() * length(v_chars))::INTEGER, 1);
    END LOOP;
    EXIT WHEN NOT EXISTS (
      SELECT 1 FROM public.sessions WHERE session_code = v_code
    );
    v_attempt := v_attempt + 1;
    IF v_attempt > 50 THEN
      RAISE EXCEPTION 'session_code_generation_failed';
    END IF;
  END LOOP;
  RETURN v_code;
END;
$$;

CREATE OR REPLACE FUNCTION public.create_session(
  p_config JSONB,
  p_banker_name TEXT DEFAULT 'Banker'
)
RETURNS JSONB
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_user_id UUID;
  v_session_id UUID;
  v_code TEXT;
  v_config JSONB;
BEGIN
  v_user_id := auth.uid();
  IF v_user_id IS NULL THEN
    RAISE EXCEPTION 'not_authenticated';
  END IF;

  v_config := COALESCE(p_config, '{}'::jsonb);
  v_config := v_config || jsonb_build_object(
    'banker_name', COALESCE(NULLIF(trim(p_banker_name), ''), 'Banker')
  );

  v_code := public.generate_unique_session_code();

  INSERT INTO public.sessions (session_code, host_id, status, config)
  VALUES (v_code, v_user_id, 'open', v_config)
  RETURNING id INTO v_session_id;

  UPDATE public.players
  SET avatar_color = 0
  WHERE session_id = v_session_id AND user_id = v_user_id;

  RETURN public.session_payload(v_session_id);
END;
$$;

CREATE OR REPLACE FUNCTION public.end_session(p_session_id UUID)
RETURNS JSONB
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_banker UUID;
BEGIN
  PERFORM public.assert_session_open(p_session_id);
  v_banker := public.current_banker_in_session(p_session_id);
  IF v_banker IS NULL THEN
    RAISE EXCEPTION 'only_banker';
  END IF;

  UPDATE public.sessions
  SET status = 'ended', updated_at = now()
  WHERE id = p_session_id;

  RETURN public.session_payload(p_session_id);
END;
$$;

CREATE OR REPLACE FUNCTION public.create_banker_player_for_new_session()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_starting_balance NUMERIC;
  v_banker_name TEXT;
BEGIN
  v_starting_balance := COALESCE((NEW.config->>'starting_balance')::NUMERIC, 1500);
  v_banker_name := COALESCE(NULLIF(trim(NEW.config->>'banker_name'), ''), 'Banker');

  INSERT INTO public.players (
    session_id,
    user_id,
    name,
    balance,
    is_banker,
    status,
    avatar_color
  ) VALUES (
    NEW.id,
    NEW.host_id,
    v_banker_name,
    v_starting_balance,
    TRUE,
    'ACTIVE',
    0
  )
  ON CONFLICT (session_id, user_id) DO UPDATE
  SET
    name = EXCLUDED.name,
    balance = EXCLUDED.balance,
    is_banker = TRUE,
    status = 'ACTIVE',
    avatar_color = 0;

  RETURN NEW;
END;
$$;

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
    v_color := public.next_avatar_color(v_session_id);
    INSERT INTO public.players (
      session_id,
      user_id,
      name,
      balance,
      status,
      is_banker,
      avatar_color
    ) VALUES (
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

CREATE OR REPLACE FUNCTION public.get_session_analytics(p_session_id UUID)
RETURNS JSONB
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_user_id UUID;
  v_total_volume NUMERIC;
  v_bank_in NUMERIC;
  v_bank_out NUMERIC;
  v_go_count INTEGER;
  v_go_sum NUMERIC;
  v_started TIMESTAMPTZ;
  v_ended TIMESTAMPTZ;
  v_duration_seconds BIGINT;
  v_biggest_spender JSONB;
  v_biggest_earner JSONB;
  v_most_active JSONB;
BEGIN
  v_user_id := auth.uid();
  IF v_user_id IS NULL THEN
    RAISE EXCEPTION 'not_authenticated';
  END IF;

  IF NOT public.is_session_participant(p_session_id) THEN
    RAISE EXCEPTION 'not_in_session';
  END IF;

  SELECT COALESCE(SUM(amount), 0) INTO v_total_volume
  FROM public.transactions WHERE session_id = p_session_id;

  SELECT COALESCE(SUM(amount), 0) INTO v_bank_in
  FROM public.transactions
  WHERE session_id = p_session_id AND type = 'pay_bank';

  SELECT COALESCE(SUM(amount), 0) INTO v_bank_out
  FROM public.transactions
  WHERE session_id = p_session_id AND type IN ('from_bank', 'collect_go');

  SELECT COUNT(*), COALESCE(SUM(amount), 0)
  INTO v_go_count, v_go_sum
  FROM public.transactions
  WHERE session_id = p_session_id AND type = 'collect_go';

  SELECT MIN(created_at), MAX(created_at)
  INTO v_started, v_ended
  FROM public.transactions
  WHERE session_id = p_session_id;

  IF v_started IS NULL THEN
    SELECT created_at, updated_at INTO v_started, v_ended
    FROM public.sessions WHERE id = p_session_id;
  END IF;

  v_duration_seconds := GREATEST(
    0,
    EXTRACT(EPOCH FROM (COALESCE(v_ended, now()) - COALESCE(v_started, now())))::BIGINT
  );

  SELECT jsonb_build_object(
    'player_id', sub.player_id,
    'player_name', sub.player_name,
    'amount', sub.outgoing
  )
  INTO v_biggest_spender
  FROM (
    SELECT
      COALESCE(from_player_id, to_player_id) AS player_id,
      COALESCE(from_player_name, to_player_name, 'Unknown') AS player_name,
      SUM(amount) AS outgoing
    FROM public.transactions
    WHERE session_id = p_session_id
      AND type IN ('player_to_player', 'pay_bank')
      AND from_player_id IS NOT NULL
    GROUP BY 1, 2
    ORDER BY outgoing DESC
    LIMIT 1
  ) sub;

  SELECT jsonb_build_object(
    'player_id', sub.player_id,
    'player_name', sub.player_name,
    'amount', sub.incoming
  )
  INTO v_biggest_earner
  FROM (
    SELECT
      COALESCE(to_player_id, from_player_id) AS player_id,
      COALESCE(to_player_name, from_player_name, 'Unknown') AS player_name,
      SUM(amount) AS incoming
    FROM public.transactions
    WHERE session_id = p_session_id
      AND type IN ('player_to_player', 'from_bank', 'collect_go')
      AND to_player_id IS NOT NULL
    GROUP BY 1, 2
    ORDER BY incoming DESC
    LIMIT 1
  ) sub;

  SELECT jsonb_build_object(
    'player_id', sub.player_id,
    'player_name', sub.player_name,
    'count', sub.cnt
  )
  INTO v_most_active
  FROM (
    SELECT
      pid AS player_id,
      MAX(pname) AS player_name,
      COUNT(*) AS cnt
    FROM (
      SELECT from_player_id AS pid, from_player_name AS pname FROM public.transactions
      WHERE session_id = p_session_id AND from_player_id IS NOT NULL
      UNION ALL
      SELECT to_player_id, to_player_name FROM public.transactions
      WHERE session_id = p_session_id AND to_player_id IS NOT NULL
    ) t
    GROUP BY pid
    ORDER BY cnt DESC
    LIMIT 1
  ) sub;

  RETURN jsonb_build_object(
    'total_volume', v_total_volume,
    'bank_inflow', v_bank_in,
    'bank_outflow', v_bank_out,
    'go_collections_count', v_go_count,
    'go_collections_sum', v_go_sum,
    'duration_seconds', v_duration_seconds,
    'biggest_spender', COALESCE(v_biggest_spender, '{}'::jsonb),
    'biggest_earner', COALESCE(v_biggest_earner, '{}'::jsonb),
    'most_active_trader', COALESCE(v_most_active, '{}'::jsonb)
  );
END;
$$;

CREATE OR REPLACE FUNCTION public.list_my_ended_sessions(
  p_limit INTEGER DEFAULT 20,
  p_offset INTEGER DEFAULT 0
)
RETURNS JSONB
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_user_id UUID;
BEGIN
  v_user_id := auth.uid();
  IF v_user_id IS NULL THEN
    RAISE EXCEPTION 'not_authenticated';
  END IF;

  RETURN COALESCE(
    (
      SELECT jsonb_agg(row_data ORDER BY ended_at DESC)
      FROM (
        SELECT jsonb_build_object(
          'session_id', s.id,
          'session_code', s.session_code,
          'ended_at', s.updated_at,
          'player_name', p.name,
          'final_balance', p.balance,
          'was_banker', p.is_banker,
          'rank', (
            SELECT COUNT(*) + 1
            FROM public.players p2
            WHERE p2.session_id = s.id
              AND p2.status != 'KICKED'
              AND p2.balance > p.balance
          )
        ) AS row_data,
        s.updated_at AS ended_at
        FROM public.sessions s
        INNER JOIN public.players p
          ON p.session_id = s.id AND p.user_id = v_user_id
        WHERE s.status = 'ended'
        ORDER BY s.updated_at DESC
        LIMIT GREATEST(p_limit, 1)
        OFFSET GREATEST(p_offset, 0)
      ) sub
    ),
    '[]'::jsonb
  );
END;
$$;

CREATE OR REPLACE FUNCTION public.get_user_statistics()
RETURNS JSONB
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_user_id UUID;
  v_games INTEGER;
  v_wins INTEGER;
  v_banker_games INTEGER;
  v_total_volume NUMERIC;
  v_avg_balance NUMERIC;
BEGIN
  v_user_id := auth.uid();
  IF v_user_id IS NULL THEN
    RAISE EXCEPTION 'not_authenticated';
  END IF;

  SELECT COUNT(DISTINCT s.id)
  INTO v_games
  FROM public.sessions s
  INNER JOIN public.players p ON p.session_id = s.id AND p.user_id = v_user_id
  WHERE s.status = 'ended';

  SELECT COUNT(*)
  INTO v_wins
  FROM (
    SELECT s.id
    FROM public.sessions s
    INNER JOIN public.players p ON p.session_id = s.id AND p.user_id = v_user_id
    WHERE s.status = 'ended'
      AND p.status != 'KICKED'
      AND NOT EXISTS (
        SELECT 1 FROM public.players p2
        WHERE p2.session_id = s.id
          AND p2.status != 'KICKED'
          AND p2.balance > p.balance
      )
  ) w;

  SELECT COUNT(*)
  INTO v_banker_games
  FROM public.sessions s
  INNER JOIN public.players p ON p.session_id = s.id AND p.user_id = v_user_id
  WHERE s.status = 'ended' AND p.is_banker;

  SELECT COALESCE(SUM(t.amount), 0)
  INTO v_total_volume
  FROM public.transactions t
  INNER JOIN public.players p ON p.session_id = t.session_id AND p.user_id = v_user_id
  INNER JOIN public.sessions s ON s.id = t.session_id AND s.status = 'ended';

  SELECT COALESCE(AVG(p.balance), 0)
  INTO v_avg_balance
  FROM public.players p
  INNER JOIN public.sessions s ON s.id = p.session_id
  WHERE p.user_id = v_user_id AND s.status = 'ended' AND p.status != 'KICKED';

  RETURN jsonb_build_object(
    'games_played', COALESCE(v_games, 0),
    'wins', COALESCE(v_wins, 0),
    'banker_games', COALESCE(v_banker_games, 0),
    'total_volume', COALESCE(v_total_volume, 0),
    'average_final_balance', COALESCE(v_avg_balance, 0)
  );
END;
$$;

GRANT EXECUTE ON FUNCTION public.create_session(JSONB, TEXT) TO authenticated;
GRANT EXECUTE ON FUNCTION public.end_session(UUID) TO authenticated;
GRANT EXECUTE ON FUNCTION public.get_session_analytics(UUID) TO authenticated;
GRANT EXECUTE ON FUNCTION public.list_my_ended_sessions(INTEGER, INTEGER) TO authenticated;
GRANT EXECUTE ON FUNCTION public.get_user_statistics() TO authenticated;;
