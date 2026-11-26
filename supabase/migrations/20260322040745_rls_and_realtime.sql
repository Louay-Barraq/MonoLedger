-- 1. Enable RLS
alter table public.profiles enable row level security;
alter table public.sessions enable row level security;
alter table public.players enable row level security;
alter table public.transactions enable row level security;

-- 2. Profiles Policies
create policy "Public profiles are viewable by everyone." on public.profiles
  for select using (true);

create policy "Users can insert their own profile." on public.profiles
  for insert with check (auth.uid() = id);

create policy "Users can update own profile." on public.profiles
  for update using (auth.uid() = id);

-- 3. Sessions Policies
create policy "Sessions are viewable by participants." on public.sessions
  for select using (
    exists (
      select 1 from public.players
      where players.session_id = sessions.id
      and players.user_id = auth.uid()
    )
    or host_id = auth.uid()
  );

create policy "Hosts can update sessions." on public.sessions
  for update using (host_id = auth.uid());

create policy "Anyone can insert a session." on public.sessions
  for insert with check (true);

-- 4. Players Policies
create policy "Players are viewable by session participants." on public.players
  for select using (
    exists (
      select 1 from public.players p
      where p.session_id = players.session_id
      and p.user_id = auth.uid()
    )
  );

create policy "Anyone can join a session." on public.players
  for insert with check (true);

-- 5. Transactions Policies
create policy "Transactions are viewable by session participants." on public.transactions
  for select using (
    exists (
      select 1 from public.players
      where players.session_id = transactions.session_id
      and players.user_id = auth.uid()
    )
  );

-- 6. Enable Real-time
begin;
  -- remove the publication if it exists
  drop publication if exists supabase_realtime;
  -- create the publication
  create publication supabase_realtime for table 
    public.sessions, 
    public.players, 
    public.transactions;
commit;
;
