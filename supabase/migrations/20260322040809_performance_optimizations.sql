-- 1. Add missing indexes for foreign keys
create index if not exists idx_players_user_id on public.players(user_id);
create index if not exists idx_sessions_host_id on public.sessions(host_id);
create index if not exists idx_transactions_session_id on public.transactions(session_id);
create index if not exists idx_transactions_sender_id on public.transactions(sender_id);
create index if not exists idx_transactions_receiver_id on public.transactions(receiver_id);

-- 2. Optimize RLS policies by using (select auth.uid())
-- Profiles
drop policy if exists "Users can insert their own profile." on public.profiles;
create policy "Users can insert their own profile." on public.profiles
  for insert with check ((select auth.uid()) = id);

drop policy if exists "Users can update own profile." on public.profiles;
create policy "Users can update own profile." on public.profiles
  for update using ((select auth.uid()) = id);

-- Sessions
drop policy if exists "Sessions are viewable by participants." on public.sessions;
create policy "Sessions are viewable by participants." on public.sessions
  for select using (
    exists (
      select 1 from public.players
      where players.session_id = sessions.id
      and players.user_id = (select auth.uid())
    )
    or host_id = (select auth.uid())
  );

drop policy if exists "Hosts can update sessions." on public.sessions;
create policy "Hosts can update sessions." on public.sessions
  for update using (host_id = (select auth.uid()));

drop policy if exists "Users can create sessions as host." on public.sessions;
create policy "Users can create sessions as host." on public.sessions
  for insert with check ((select auth.uid()) = host_id);

-- Players
drop policy if exists "Players are viewable by session participants." on public.players;
create policy "Players are viewable by session participants." on public.players
  for select using (
    exists (
      select 1 from public.players p
      where p.session_id = players.session_id
      and p.user_id = (select auth.uid())
    )
  );

drop policy if exists "Authenticated users can join sessions." on public.players;
create policy "Authenticated users can join sessions." on public.players
  for insert with check ((select auth.uid()) = user_id);

-- Transactions
drop policy if exists "Transactions are viewable by session participants." on public.transactions;
create policy "Transactions are viewable by session participants." on public.transactions
  for select using (
    exists (
      select 1 from public.players
      where players.session_id = transactions.session_id
      and players.user_id = (select auth.uid())
    )
  );
;
