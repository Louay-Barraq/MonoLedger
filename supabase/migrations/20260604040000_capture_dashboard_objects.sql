-- Objects that exist on the live project but were created outside migrations.
-- Copied verbatim from production on 2026-11-26 so a fresh database matches it.
-- On the live project this is a no-op (same definitions).

CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS trigger
LANGUAGE plpgsql
SECURITY DEFINER
AS $function$
BEGIN
  INSERT INTO public.profiles (id, display_name, avatar_url)
  VALUES (new.id, 'Anonymous', null);
  RETURN new;
END;
$function$;

DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;
CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE FUNCTION public.handle_new_user();

CREATE OR REPLACE FUNCTION public.is_session_host(session_uuid uuid)
RETURNS boolean
LANGUAGE sql
SECURITY DEFINER
SET search_path TO 'public'
AS $function$
  SELECT EXISTS (
    SELECT 1 FROM sessions
    WHERE id = session_uuid
    AND host_id = auth.uid()
  );
$function$;

-- Read policies: production replaced the original (recursive) ones by hand.
DROP POLICY IF EXISTS "Players are viewable by session participants." ON public.players;
DROP POLICY IF EXISTS "Players SELECT" ON public.players;
CREATE POLICY "Players SELECT" ON public.players
  FOR SELECT TO anon, authenticated
  USING ((user_id = auth.uid()) OR public.is_session_host(session_id) OR public.is_session_participant(session_id));

DROP POLICY IF EXISTS "Sessions are viewable by host or participants." ON public.sessions;
DROP POLICY IF EXISTS "Sessions are viewable by participants." ON public.sessions;
DROP POLICY IF EXISTS "Sessions SELECT" ON public.sessions;
CREATE POLICY "Sessions SELECT" ON public.sessions
  FOR SELECT TO anon, authenticated
  USING ((host_id = auth.uid()) OR public.is_session_participant(id));
