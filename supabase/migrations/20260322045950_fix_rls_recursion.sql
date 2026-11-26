-- Create a security definer function to check participation without triggering RLS recursion
CREATE OR REPLACE FUNCTION is_session_participant(session_uuid uuid) 
RETURNS boolean 
SECURITY DEFINER 
SET search_path = public
LANGUAGE sql 
AS $$
  SELECT EXISTS (
    SELECT 1 FROM players 
    WHERE session_id = session_uuid 
    AND user_id = auth.uid()
  );
$$;

-- Drop existing problematic policies
DROP POLICY IF EXISTS "Sessions are viewable by host or participants." ON sessions;
DROP POLICY IF EXISTS "Players are viewable by session participants." ON players;

-- Recreate session policies
CREATE POLICY "Sessions are viewable by host or participants." ON sessions
FOR SELECT USING (
  host_id = auth.uid() 
  OR 
  is_session_participant(id)
);

-- Recreate player policies
CREATE POLICY "Players are viewable by session participants." ON players
FOR SELECT USING (
  user_id = auth.uid() 
  OR 
  session_id IN (SELECT id FROM sessions WHERE host_id = auth.uid())
  OR
  is_session_participant(session_id)
);
;
