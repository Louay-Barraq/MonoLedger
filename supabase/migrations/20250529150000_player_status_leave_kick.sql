-- Mark kicked/left players with status (not DELETE) for reliable realtime + UI filtering.

CREATE OR REPLACE FUNCTION public.kick_player(
  p_session_id UUID,
  p_target_player_id UUID
)
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_is_banker BOOLEAN;
BEGIN
  SELECT is_banker INTO v_is_banker
  FROM public.players
  WHERE session_id = p_session_id AND user_id = auth.uid() AND status = 'ACTIVE';

  IF v_is_banker IS NOT TRUE THEN
    RAISE EXCEPTION 'only_banker_can_transfer';
  END IF;

  UPDATE public.players
  SET status = 'KICKED', is_banker = FALSE
  WHERE id = p_target_player_id
    AND session_id = p_session_id
    AND status = 'ACTIVE';
END;
$$;

CREATE OR REPLACE FUNCTION public.leave_session(p_session_id UUID)
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
BEGIN
  UPDATE public.players
  SET status = 'LEFT', is_banker = FALSE
  WHERE session_id = p_session_id AND user_id = auth.uid() AND status = 'ACTIVE';

  IF NOT EXISTS (
    SELECT 1 FROM public.players
    WHERE session_id = p_session_id AND status = 'ACTIVE'
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
  v_was_departure BOOLEAN;
BEGIN
  v_was_departure := (
    TG_OP = 'DELETE'
    OR (TG_OP = 'UPDATE' AND OLD.status = 'ACTIVE' AND NEW.status IN ('LEFT', 'KICKED'))
  );

  IF NOT v_was_departure OR NOT OLD.is_banker THEN
    IF TG_OP = 'DELETE' THEN
      RETURN OLD;
    END IF;
    RETURN NEW;
  END IF;

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

  IF TG_OP = 'DELETE' THEN
    RETURN OLD;
  END IF;
  RETURN NEW;
END;
$$;

DROP TRIGGER IF EXISTS trigger_banker_inheritance ON public.players;

CREATE TRIGGER trigger_banker_inheritance
  AFTER UPDATE OF status ON public.players
  FOR EACH ROW
  EXECUTE FUNCTION public.handle_banker_inheritance();

CREATE TRIGGER trigger_banker_inheritance_delete
  AFTER DELETE ON public.players
  FOR EACH ROW
  EXECUTE FUNCTION public.handle_banker_inheritance();
