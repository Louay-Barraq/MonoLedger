-- Fix transfer_banker: remove reference to non-existent to_player_name column.

CREATE OR REPLACE FUNCTION public.transfer_banker(
  p_session_id UUID,
  p_new_banker_player_id UUID
)
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_caller_player_id UUID;
  v_new_banker_user_id UUID;
  v_pending_go public.go_salary_requests;
BEGIN
  SELECT id INTO v_caller_player_id
  FROM public.players
  WHERE session_id = p_session_id
    AND user_id = auth.uid()
    AND is_banker = TRUE;

  IF v_caller_player_id IS NULL THEN
    RAISE EXCEPTION 'only_banker_can_transfer';
  END IF;

  SELECT user_id INTO v_new_banker_user_id
  FROM public.players
  WHERE id = p_new_banker_player_id
    AND session_id = p_session_id
    AND status = 'ACTIVE';

  IF v_new_banker_user_id IS NULL THEN
    RAISE EXCEPTION 'player_not_found';
  END IF;

  SELECT * INTO v_pending_go
  FROM public.go_salary_requests
  WHERE session_id = p_session_id
    AND requester_player_id = p_new_banker_player_id
    AND status = 'pending'
  ORDER BY created_at DESC
  LIMIT 1;

  UPDATE public.players
  SET is_banker = FALSE
  WHERE session_id = p_session_id;

  UPDATE public.players
  SET is_banker = TRUE
  WHERE id = p_new_banker_player_id;

  UPDATE public.sessions
  SET host_id = v_new_banker_user_id
  WHERE id = p_session_id;

  IF v_pending_go.id IS NOT NULL THEN
    UPDATE public.players
    SET balance = balance + v_pending_go.amount
    WHERE id = p_new_banker_player_id;

    INSERT INTO public.transactions (
      session_id,
      type,
      to_player_id,
      amount,
      memo,
      created_by
    ) VALUES (
      p_session_id,
      'collect_go',
      p_new_banker_player_id,
      v_pending_go.amount,
      'PASSED GO',
      auth.uid()
    );

    UPDATE public.go_salary_requests
    SET
      status = 'approved',
      resolved_at = now(),
      resolved_by_player_id = p_new_banker_player_id
    WHERE id = v_pending_go.id;
  END IF;
END;
$$;

GRANT EXECUTE ON FUNCTION public.transfer_banker(UUID, UUID) TO authenticated;;
