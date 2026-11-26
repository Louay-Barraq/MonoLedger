-- Account deletion (Google Play requires an in-app way to delete an account).
-- The user's auth account and profile are deleted. Their rows in shared games
-- stay, so other players' ledgers still add up, but are renamed "Deleted player"
-- and no longer point at any account.

ALTER TABLE public.players ALTER COLUMN user_id DROP NOT NULL;
ALTER TABLE public.players DROP CONSTRAINT IF EXISTS players_user_id_fkey;
ALTER TABLE public.players
  ADD CONSTRAINT players_user_id_fkey
  FOREIGN KEY (user_id) REFERENCES public.profiles(id) ON DELETE SET NULL;

ALTER TABLE public.sessions ALTER COLUMN host_id DROP NOT NULL;
ALTER TABLE public.sessions DROP CONSTRAINT IF EXISTS sessions_host_id_fkey;
ALTER TABLE public.sessions
  ADD CONSTRAINT sessions_host_id_fkey
  FOREIGN KEY (host_id) REFERENCES public.profiles(id) ON DELETE SET NULL;

ALTER TABLE public.transactions DROP CONSTRAINT IF EXISTS transactions_created_by_fkey;
ALTER TABLE public.transactions
  ADD CONSTRAINT transactions_created_by_fkey
  FOREIGN KEY (created_by) REFERENCES auth.users(id) ON DELETE SET NULL;

CREATE OR REPLACE FUNCTION public.delete_my_account()
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_user_id UUID := auth.uid();
  v_session_id UUID;
BEGIN
  IF v_user_id IS NULL THEN
    RAISE EXCEPTION 'not_authenticated';
  END IF;

  -- Leave every open game first: hands the Banker role on, closes pending GO
  -- requests and ends games nobody is left in (same rules as leave_session).
  FOR v_session_id IN
    SELECT session_id FROM public.players
    WHERE user_id = v_user_id AND status = 'ACTIVE'
  LOOP
    UPDATE public.players
    SET status = 'LEFT', is_banker = FALSE
    WHERE session_id = v_session_id AND user_id = v_user_id;

    IF NOT EXISTS (
      SELECT 1 FROM public.players WHERE session_id = v_session_id AND status = 'ACTIVE'
    ) THEN
      UPDATE public.sessions SET status = 'ended' WHERE id = v_session_id;
    END IF;
  END LOOP;

  UPDATE public.players SET name = 'Deleted player' WHERE user_id = v_user_id;

  -- Cascades to profiles; players.user_id, sessions.host_id and
  -- transactions.created_by become NULL.
  DELETE FROM auth.users WHERE id = v_user_id;
END;
$$;

REVOKE EXECUTE ON FUNCTION public.delete_my_account() FROM PUBLIC, anon;
GRANT EXECUTE ON FUNCTION public.delete_my_account() TO authenticated;
