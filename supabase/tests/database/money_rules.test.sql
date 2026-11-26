-- Money rules that must hold no matter what the client sends.
-- Run with: supabase test db
begin;
create extension if not exists pgtap with schema extensions;
select plan(15);

-- Fixtures (as postgres, bypassing RLS).
insert into auth.users (id, email) values
  ('00000000-0000-0000-0000-0000000000b1', 'banker@test.local'),
  ('00000000-0000-0000-0000-0000000000a1', 'player@test.local');

insert into public.sessions (id, session_code, host_id, status, config) values (
  '00000000-0000-0000-0000-00000000005e', 'TST001',
  '00000000-0000-0000-0000-0000000000b1', 'open',
  '{"currency":"$","starting_balance":1500,"go_amount":200,"banker_name":"Bank"}'
);

-- A trigger may already have created the banker row; start from a known state.
delete from public.players where session_id = '00000000-0000-0000-0000-00000000005e';
insert into public.players (id, session_id, user_id, name, balance, status, is_banker) values
  ('00000000-0000-0000-0000-0000000000c1', '00000000-0000-0000-0000-00000000005e',
   '00000000-0000-0000-0000-0000000000b1', 'Bank', 1500, 'ACTIVE', true),
  ('00000000-0000-0000-0000-0000000000c2', '00000000-0000-0000-0000-00000000005e',
   '00000000-0000-0000-0000-0000000000a1', 'Pat', 100, 'ACTIVE', false);

select hasnt_function('public', 'collect_go_salary', array['uuid'],
  'pre-approval GO function is gone');
select hasnt_function('public', 'perform_transfer',
  array['uuid', 'uuid', 'uuid', 'numeric', 'text'],
  'legacy transfer with caller-supplied sender is gone');

-- Act as the non-banker player.
set local role authenticated;
select set_config('request.jwt.claims',
  '{"sub":"00000000-0000-0000-0000-0000000000a1","role":"authenticated"}', true);

select throws_ok(
  $$ select public.receive_from_bank('00000000-0000-0000-0000-00000000005e', 1000) $$,
  'P0001', 'only_banker', 'a player cannot take money from the bank');

select throws_ok(
  $$ insert into public.go_salary_requests (session_id, requester_player_id, amount)
     values ('00000000-0000-0000-0000-00000000005e', '00000000-0000-0000-0000-0000000000c2', 1000000) $$,
  '42501', null, 'a player cannot write GO requests directly');

select throws_ok(
  $$ update public.players set balance = 999999 where id = '00000000-0000-0000-0000-0000000000c2' $$,
  '42501', null, 'a player cannot edit balances directly');

select throws_ok(
  $$ insert into public.players (session_id, user_id, name, balance, status, is_banker)
     values ('00000000-0000-0000-0000-00000000005e', '00000000-0000-0000-0000-0000000000a1',
             'Pat again', 1000000, 'ACTIVE', true) $$,
  '42501', null, 'a player cannot insert player rows directly');

select throws_ok(
  $$ update public.sessions set config = '{"go_amount":100000}'
     where id = '00000000-0000-0000-0000-00000000005e' $$,
  '42501', null, 'nobody can rewrite a session directly');

select throws_ok(
  $$ select public.session_payload('00000000-0000-0000-0000-00000000005e') $$,
  '42501', null, 'internal helpers are not callable by clients');

select throws_ok(
  $$ select public.end_session('00000000-0000-0000-0000-00000000005e') $$,
  'P0001', 'only_banker', 'a player cannot end the game');

select lives_ok(
  $$ select public.pay_bank('00000000-0000-0000-0000-00000000005e', 80) $$,
  'a player can pay within their balance');

select throws_ok(
  $$ select public.pay_bank('00000000-0000-0000-0000-00000000005e', 80) $$,
  'P0001', 'insufficient_funds', 'a player cannot overdraw');

select lives_ok(
  $$ select public.leave_session('00000000-0000-0000-0000-00000000005e') $$,
  'a player can leave');

select lives_ok(
  $$ select public.join_session_by_code('TST001', 'Pat') $$,
  'a player who left can rejoin');

reset role;
select is(
  (select balance from public.players where id = '00000000-0000-0000-0000-0000000000c2'),
  20::numeric, 'rejoining keeps the balance the player left with');

-- Act as the banker.
set local role authenticated;
select set_config('request.jwt.claims',
  '{"sub":"00000000-0000-0000-0000-0000000000b1","role":"authenticated"}', true);

select lives_ok(
  $$ select public.receive_from_bank('00000000-0000-0000-0000-00000000005e', 50) $$,
  'the banker can take money from the bank');

reset role;
select * from finish();
rollback;
