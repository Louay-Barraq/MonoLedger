-- Transfer host ownership with banker role; close empty sessions on leave.

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
BEGIN
  SELECT id INTO v_caller_player_id
  FROM public.players
  WHERE session_id = p_session_id AND user_id = auth.uid() AND is_banker = TRUE;

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

  UPDATE public.players SET is_banker = FALSE WHERE session_id = p_session_id;
  UPDATE public.players SET is_banker = TRUE WHERE id = p_new_banker_player_id;

  UPDATE public.sessions
  SET host_id = v_new_banker_user_id
  WHERE id = p_session_id;
END;
$$;

CREATE OR REPLACE FUNCTION public.leave_session(p_session_id UUID)
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
BEGIN
  DELETE FROM public.players
  WHERE session_id = p_session_id AND user_id = auth.uid();

  IF NOT EXISTS (
    SELECT 1 FROM public.players WHERE session_id = p_session_id
  ) THEN
    UPDATE public.sessions SET status = 'ended' WHERE id = p_session_id;
  END IF;
END;
$$;

CREATE OR REPLACE FUNCTION public.handle_banker_inheritance()
RETURNS trigger
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_new_banker_id UUID;
  v_new_banker_user_id UUID;
BEGIN
  IF OLD.is_banker THEN
    SELECT id INTO v_new_banker_id
    FROM public.players
    WHERE session_id = OLD.session_id
      AND id != OLD.id
      AND status = 'ACTIVE'
    ORDER BY random()
    LIMIT 1;

    IF v_new_banker_id IS NOT NULL THEN
      SELECT user_id INTO v_new_banker_user_id
      FROM public.players WHERE id = v_new_banker_id;

      UPDATE public.players SET is_banker = TRUE WHERE id = v_new_banker_id;

      UPDATE public.sessions
      SET host_id = v_new_banker_user_id
      WHERE id = OLD.session_id;
    END IF;
  END IF;

  RETURN OLD;
END;
$$;;
