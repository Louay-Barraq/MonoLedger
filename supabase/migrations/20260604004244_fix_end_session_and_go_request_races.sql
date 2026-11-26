-- Fix end_session banker validation and harden GO request deduplication.

-- Ensure only one pending GO request per player/session even under rapid repeated taps.
CREATE UNIQUE INDEX IF NOT EXISTS idx_go_requests_one_pending_per_player
ON public.go_salary_requests (session_id, requester_player_id)
WHERE status = 'pending';

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
BEGIN
  PERFORM public.assert_session_open(p_session_id);
  v_player := public.current_player_in_session(p_session_id);

  SELECT COALESCE((config->>'go_amount')::NUMERIC, 200)
  INTO v_go_amount
  FROM public.sessions
  WHERE id = p_session_id;

  IF v_player.is_banker THEN
    UPDATE public.players
    SET balance = balance + v_go_amount
    WHERE id = v_player.id;

    INSERT INTO public.transactions (
      session_id,
      type,
      from_player_id,
      to_player_id,
      amount,
      memo,
      created_by
    ) VALUES (
      p_session_id,
      'collect_go',
      NULL,
      v_player.id,
      v_go_amount,
      'PASSED GO',
      auth.uid()
    );

    INSERT INTO public.go_salary_requests (
      session_id,
      requester_player_id,
      amount,
      status,
      resolved_at,
      resolved_by_player_id
    ) VALUES (
      p_session_id,
      v_player.id,
      v_go_amount,
      'approved',
      now(),
      v_player.id
    )
    RETURNING * INTO v_row;

    RETURN v_row;
  END IF;

  BEGIN
    INSERT INTO public.go_salary_requests (session_id, requester_player_id, amount, status)
    VALUES (p_session_id, v_player.id, v_go_amount, 'pending')
    RETURNING * INTO v_row;
  EXCEPTION
    WHEN unique_violation THEN
      RAISE EXCEPTION 'go_request_pending';
  END;

  RETURN v_row;
END;
$$;

CREATE OR REPLACE FUNCTION public.end_session(p_session_id UUID)
RETURNS JSONB
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
BEGIN
  PERFORM public.assert_session_open(p_session_id);
  PERFORM public.current_banker_in_session(p_session_id);

  UPDATE public.sessions
  SET status = 'ended', updated_at = now()
  WHERE id = p_session_id;

  RETURN public.session_payload(p_session_id);
END;
$$;

GRANT EXECUTE ON FUNCTION public.request_collect_go(UUID) TO authenticated;
GRANT EXECUTE ON FUNCTION public.end_session(UUID) TO authenticated;;
