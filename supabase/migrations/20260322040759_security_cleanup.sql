-- 1. Fix function search path
alter function public.perform_transfer(uuid, uuid, uuid, numeric, text) 
set search_path = public;

-- 2. Tighten RLS for sessions insert (must be host)
drop policy if exists "Anyone can insert a session." on public.sessions;
create policy "Users can create sessions as host." on public.sessions
  for insert with check (auth.uid() = host_id);

-- 3. Tighten RLS for players insert (must be joining as authenticated user)
drop policy if exists "Anyone can join a session." on public.players;
create policy "Authenticated users can join sessions." on public.players
  for insert with check (auth.uid() = user_id);
;
