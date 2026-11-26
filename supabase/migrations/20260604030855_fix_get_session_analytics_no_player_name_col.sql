-- Fix get_session_analytics: remove references to non-existent from_player_name / to_player_name columns.
-- Resolve player names via JOIN on the players table instead.

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
      t.from_player_id AS player_id,
      p.name AS player_name,
      SUM(t.amount) AS outgoing
    FROM public.transactions t
    INNER JOIN public.players p ON p.id = t.from_player_id
    WHERE t.session_id = p_session_id
      AND t.type IN ('player_to_player', 'pay_bank')
    GROUP BY t.from_player_id, p.name
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
      t.to_player_id AS player_id,
      p.name AS player_name,
      SUM(t.amount) AS incoming
    FROM public.transactions t
    INNER JOIN public.players p ON p.id = t.to_player_id
    WHERE t.session_id = p_session_id
      AND t.type IN ('player_to_player', 'from_bank', 'collect_go')
    GROUP BY t.to_player_id, p.name
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
      t.pid AS player_id,
      p.name AS player_name,
      COUNT(*) AS cnt
    FROM (
      SELECT from_player_id AS pid FROM public.transactions
      WHERE session_id = p_session_id AND from_player_id IS NOT NULL
      UNION ALL
      SELECT to_player_id AS pid FROM public.transactions
      WHERE session_id = p_session_id AND to_player_id IS NOT NULL
    ) t
    INNER JOIN public.players p ON p.id = t.pid
    GROUP BY t.pid, p.name
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

GRANT EXECUTE ON FUNCTION public.get_session_analytics(UUID) TO authenticated;;
