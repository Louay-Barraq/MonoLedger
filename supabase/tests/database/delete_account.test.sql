-- Deleting an account keeps shared ledgers intact.
begin;
create extension if not exists pgtap with schema extensions;
select plan(6);

insert into auth.users (id, email) values
  ('00000000-0000-0000-0000-0000000000b3', 'banker3@test.local'),
  ('00000000-0000-0000-0000-0000000000a3', 'player3@test.local');
insert into public.sessions (id, session_code, host_id, status, config) values (
  '00000000-0000-0000-0000-00000000007e', 'TST003',
  '00000000-0000-0000-0000-0000000000b3', 'open', '{"starting_balance":1500}');
delete from public.players where session_id = '00000000-0000-0000-0000-00000000007e';
insert into public.players (id, session_id, user_id, name, balance, status, is_banker) values
  ('00000000-0000-0000-0000-0000000000e1', '00000000-0000-0000-0000-00000000007e',
   '00000000-0000-0000-0000-0000000000b3', 'Bank', 1500, 'ACTIVE', true),
  ('00000000-0000-0000-0000-0000000000e2', '00000000-0000-0000-0000-00000000007e',
   '00000000-0000-0000-0000-0000000000a3', 'Pat', 1500, 'ACTIVE', false);

-- The Banker pays Pat, then deletes their account.
set local role authenticated;
select set_config('request.jwt.claims',
  '{"sub":"00000000-0000-0000-0000-0000000000b3","role":"authenticated"}', true);
select public.transfer_to_player('00000000-0000-0000-0000-00000000007e',
  '00000000-0000-0000-0000-0000000000e2', 100);
select lives_ok($$ select public.delete_my_account() $$, 'a user can delete their account');

reset role;
select is((select count(*)::int from auth.users where id = '00000000-0000-0000-0000-0000000000b3'),
  0, 'the auth account is gone');
select is((select name from public.players where id = '00000000-0000-0000-0000-0000000000e1'),
  'Deleted player', 'their player row is anonymised');
select is((select user_id from public.players where id = '00000000-0000-0000-0000-0000000000e1'),
  null, 'their player row no longer points at an account');
select is((select is_banker from public.players where id = '00000000-0000-0000-0000-0000000000e2'),
  true, 'the remaining player becomes Banker');
select is((select count(*)::int from public.transactions where session_id = '00000000-0000-0000-0000-00000000007e'),
  1, 'the shared ledger is kept');

select * from finish();
rollback;
