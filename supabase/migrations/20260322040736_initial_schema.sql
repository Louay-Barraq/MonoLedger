-- 1. Profiles table
create table public.profiles (
  id uuid references auth.users on delete cascade primary key,
  display_name text,
  avatar_url text,
  updated_at timestamp with time zone default now()
);

-- 2. Sessions table
create table public.sessions (
  id uuid default gen_random_uuid() primary key,
  session_code text unique not null,
  host_id uuid references public.profiles(id) not null,
  config jsonb not null default '{}'::jsonb,
  status text not null default 'ACTIVE',
  created_at timestamp with time zone default now()
);

-- 3. Players table
create table public.players (
  id uuid default gen_random_uuid() primary key,
  session_id uuid references public.sessions(id) on delete cascade not null,
  user_id uuid references public.profiles(id) not null,
  balance numeric not null default 0,
  status text not null default 'ACTIVE',
  created_at timestamp with time zone default now(),
  unique(session_id, user_id)
);

-- 4. Transactions table
create table public.transactions (
  id uuid default gen_random_uuid() primary key,
  session_id uuid references public.sessions(id) on delete cascade not null,
  sender_id uuid references public.players(id),
  receiver_id uuid references public.players(id),
  amount numeric not null,
  description text,
  created_at timestamp with time zone default now()
);

-- 5. Atomic transfer function
create or replace function public.perform_transfer(
  p_session_id uuid,
  p_sender_id uuid,
  p_receiver_id uuid,
  p_amount numeric,
  p_description text default null
) returns void as $$
declare
  v_sender_balance numeric;
begin
  -- If sender_id is null, it's a "Bank to Player" transaction (infinite minting)
  -- Otherwise, check balance
  if p_sender_id is not null then
    select balance into v_sender_balance from public.players where id = p_sender_id for update;
    
    if v_sender_balance < p_amount then
      raise exception 'Insufficient balance';
    end if;
    
    update public.players set balance = balance - p_amount where id = p_sender_id;
  end if;

  -- If receiver_id is null, it's a "Player to Bank" transaction (burning)
  if p_receiver_id is not null then
    update public.players set balance = balance + p_amount where id = p_receiver_id;
  end if;

  insert into public.transactions (session_id, sender_id, receiver_id, amount, description)
  values (p_session_id, p_sender_id, p_receiver_id, p_amount, p_description);
end;
$$ language plpgsql security definer;
;
