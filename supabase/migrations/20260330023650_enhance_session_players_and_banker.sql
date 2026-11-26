-- Add columns to players
ALTER TABLE players ADD COLUMN IF NOT EXISTS name TEXT;
ALTER TABLE players ADD COLUMN IF NOT EXISTS is_banker BOOLEAN DEFAULT FALSE;

-- Update join_session_by_code
-- First, handle existing data for name if missing (use display_name from profiles if available)
UPDATE players p
SET name = pr.display_name
FROM profiles pr
WHERE p.user_id = pr.id AND p.name IS NULL;

-- Update join_session_by_code RPC
CREATE OR REPLACE FUNCTION join_session_by_code(p_session_code TEXT, p_player_name TEXT)
RETURNS jsonb
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  v_session_id UUID;
  v_user_id UUID;
  v_starting_balance NUMERIC;
BEGIN
  v_user_id := auth.uid();
  IF v_user_id IS NULL THEN
    RAISE EXCEPTION 'Not authenticated';
  END IF;

  SELECT id, (config->>'starting_balance')::NUMERIC INTO v_session_id, v_starting_balance
  FROM sessions
  WHERE session_code = p_session_code AND (status = 'open' OR status = 'ACTIVE');

  IF v_session_id IS NULL THEN
    RAISE EXCEPTION 'Session not found or not open';
  END IF;

  INSERT INTO players (session_id, user_id, name, is_banker, balance)
  VALUES (v_session_id, v_user_id, p_player_name, FALSE, v_starting_balance)
  ON CONFLICT (session_id, user_id) 
  DO UPDATE SET name = EXCLUDED.name;

  RETURN (SELECT jsonb_build_object(
    'id', s.id, 
    'session_code', s.session_code, 
    'status', s.status, 
    'config', s.config)
    FROM sessions s WHERE s.id = v_session_id);
END;
$$;

-- Trigger to handle Banker reassignment on player removal
CREATE OR REPLACE FUNCTION handle_banker_inheritance() 
RETURNS TRIGGER 
LANGUAGE plpgsql 
SECURITY DEFINER
AS $$
DECLARE
  v_new_banker_id UUID;
BEGIN
  -- If the deleted player was a banker
  IF OLD.is_banker THEN
    -- Find another player in the same session
    SELECT id INTO v_new_banker_id
    FROM players
    WHERE session_id = OLD.session_id AND id != OLD.id AND status = 'ACTIVE'
    ORDER BY random()
    LIMIT 1;

    -- Reassign banker role if someone else is available
    IF v_new_banker_id IS NOT NULL THEN
      UPDATE players
      SET is_banker = TRUE
      WHERE id = v_new_banker_id;
    END IF;
  END IF;
  RETURN OLD;
END;
$$;

DROP TRIGGER IF EXISTS trigger_banker_inheritance ON players;
CREATE TRIGGER trigger_banker_inheritance
BEFORE DELETE ON players
FOR EACH ROW
EXECUTE FUNCTION handle_banker_inheritance();

-- Ensure creator is added as player when session is created
CREATE OR REPLACE FUNCTION add_host_as_player() 
RETURNS TRIGGER 
LANGUAGE plpgsql 
SECURITY DEFINER
AS $$
BEGIN
  INSERT INTO players (session_id, user_id, name, is_banker, balance)
  VALUES (NEW.id, NEW.host_id, COALESCE(NEW.config->>'banker_name', 'Banker'), TRUE, (NEW.config->>'starting_balance')::NUMERIC);
  RETURN NEW;
END;
$$;

DROP TRIGGER IF EXISTS trigger_add_host_as_player ON sessions;
CREATE TRIGGER trigger_add_host_as_player
AFTER INSERT ON sessions
FOR EACH ROW
EXECUTE FUNCTION add_host_as_player();

-- RPC for Banker Transfer
CREATE OR REPLACE FUNCTION transfer_banker(p_session_id UUID, p_new_banker_player_id UUID)
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  v_caller_player_id UUID;
BEGIN
  -- Check if caller is the current banker for this session
  SELECT id INTO v_caller_player_id
  FROM players
  WHERE session_id = p_session_id AND user_id = auth.uid() AND is_banker = TRUE;

  IF v_caller_player_id IS NULL THEN
    RAISE EXCEPTION 'Only the Banker can transfer the role';
  END IF;

  -- Reset all bankers in session
  UPDATE players SET is_banker = FALSE WHERE session_id = p_session_id;
  
  -- Set new banker
  UPDATE players SET is_banker = TRUE WHERE id = p_new_banker_player_id;
END;
$$;

-- RPC for Kicking Player
CREATE OR REPLACE FUNCTION kick_player(p_session_id UUID, p_target_player_id UUID)
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  v_is_banker BOOLEAN;
BEGIN
  -- Check if caller is banker
  SELECT is_banker INTO v_is_banker
  FROM players
  WHERE session_id = p_session_id AND user_id = auth.uid();

  IF v_is_banker IS NOT TRUE THEN
    RAISE EXCEPTION 'Only the Banker can kick players';
  END IF;

  -- "Kick" by deleting the player record or marking as inactive
  -- User requested "kick players", usually means remove them.
  DELETE FROM players WHERE id = p_target_player_id AND session_id = p_session_id;
END;
$$;
;
