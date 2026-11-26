-- Add sessions.updated_at for history and lifecycle timestamps.

ALTER TABLE public.sessions
  ADD COLUMN IF NOT EXISTS updated_at TIMESTAMPTZ;

UPDATE public.sessions
SET updated_at = created_at
WHERE updated_at IS NULL;

ALTER TABLE public.sessions
  ALTER COLUMN updated_at SET DEFAULT now();

ALTER TABLE public.sessions
  ALTER COLUMN updated_at SET NOT NULL;

CREATE OR REPLACE FUNCTION public.set_updated_at()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
  NEW.updated_at = now();
  RETURN NEW;
END;
$$;

DROP TRIGGER IF EXISTS trigger_sessions_updated_at ON public.sessions;
CREATE TRIGGER trigger_sessions_updated_at
  BEFORE UPDATE ON public.sessions
  FOR EACH ROW
  EXECUTE FUNCTION public.set_updated_at();;
