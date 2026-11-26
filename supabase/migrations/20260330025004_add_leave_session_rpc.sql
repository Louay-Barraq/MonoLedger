CREATE OR REPLACE FUNCTION leave_session(p_session_id UUID)
RETURNS VOID AS $$
BEGIN
  DELETE FROM players 
  WHERE session_id = p_session_id AND user_id = auth.uid();
  
  -- If no players left, we could optionally close the session here.
  -- But for now we just let the trigger handle banker reassignment.
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;
;
