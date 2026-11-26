-- Banker reversals and GO requests from departed players.
begin;
create extension if not exists pgtap with schema extensions;
select plan(8);

insert into auth.users (id, email) values
  ('00000000-0000-0000-0000-0000000000b2', 'banker2@test.local'),
  ('00000000-0000-0000-0000-0000000000a2', 'player2@test.local');

insert into public.sessions (id, session_code, host_id, status, config) values (
  '00000000-0000-0000-0000-00000000006e', 'TST002',
  '00000000-0000-0000-0000-0000000000b2', 'open',
  '{"currency":"$","starting_balance":1500,"go_amount":200}'
);
delete from public.players where session_id = '00000000-0000-0000-0000-00000000006e';
insert into public.players (id, session_id, user_id, name, balance, status, is_banker) values
  ('00000000-0000-0000-0000-0000000000d1', '00000000-0000-0000-0000-00000000006e',
   '00000000-0000-0000-0000-0000000000b2', 'Bank', 1500, 'ACTIVE', true),
  ('00000000-0000-0000-0000-0000000000d2', '00000000-0000-0000-0000-00000000006e',
   '00000000-0000-0000-0000-0000000000a2', 'Pat', 500, 'ACTIVE', false);

-- Player pays the bank 100, then tries to undo it themselves.
set local role authenticated;
select set_config('request.jwt.claims',
  '{"sub":"00000000-0000-0000-0000-0000000000a2","role":"authenticated"}', true);
create temp table paid on commit drop as
  select (public.pay_bank('00000000-0000-0000-0000-00000000006e', 100)).id as tx_id;

select throws_ok(
  $$ select public.reverse_transaction((select tx_id from paid)) $$,
  'P0001', 'only_banker', 'a player cannot reverse transactions');

-- Banker reverses it.
select set_config('request.jwt.claims',
  '{"sub":"00000000-0000-0000-0000-0000000000b2","role":"authenticated"}', true);
create temp table reversal on commit drop as
  select (public.reverse_transaction((select tx_id from paid))).id as tx_id;

reset role;
select is(
  (select balance from public.players where id = '00000000-0000-0000-0000-0000000000d2'),
  500::numeric, 'reversal gives the player their money back');
select is(
  (select type from public.transactions where id = (select tx_id from reversal)),
  'from_bank', 'reversal of a bank payment is a bank payout');

set local role authenticated;
select throws_ok(
  $$ select public.reverse_transaction((select tx_id from paid)) $$,
  'P0001', 'already_reversed', 'a transaction can be reversed only once');
select throws_ok(
  $$ select public.reverse_transaction((select tx_id from reversal)) $$,
  'P0001', 'cannot_reverse_reversal', 'a reversal cannot be reversed');

-- Player asks for GO, then leaves before the Banker answers.
select set_config('request.jwt.claims',
  '{"sub":"00000000-0000-0000-0000-0000000000a2","role":"authenticated"}', true);
create temp table go_req on commit drop as
  select (public.request_collect_go('00000000-0000-0000-0000-00000000006e')).id as req_id;
select lives_ok(
  $$ select public.leave_session('00000000-0000-0000-0000-00000000006e') $$,
  'the player leaves with a pending GO request');

reset role;
select is(
  (select status from public.go_salary_requests where id = (select req_id from go_req)),
  'rejected', 'leaving closes the pending GO request');

set local role authenticated;
select set_config('request.jwt.claims',
  '{"sub":"00000000-0000-0000-0000-0000000000b2","role":"authenticated"}', true);
select throws_ok(
  $$ select public.resolve_collect_go((select req_id from go_req), true) $$,
  'P0001', 'go_request_not_pending', 'the Banker cannot pay a closed request');

reset role;
select * from finish();
rollback;
