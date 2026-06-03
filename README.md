# MonoLedger

A Flutter app for digital board-game money management. Host or join a session, track balances in real time, and record payments with a tactile "slide to pay" flow.

## Features

- Anonymous auth via Supabase
- Create / join sessions with a 6-character code or QR
- Live player balances and session sync
- Pay the bank, receive from the bank, collect GO salary, and player-to-player transfers
- Shared transaction ledger with realtime updates

## Requirements

- Flutter SDK ^3.11
- A Supabase project with the schema from `supabase/migrations/`

## Setup

1. Install dependencies:

```bash
flutter pub get
```

2. Apply database migrations in the Supabase SQL editor (in order):

   - Existing project RPCs (`join_session_by_code`, etc.) must already be present
   - Run migrations in order under `supabase/migrations/` (including `20250529160000_fix_join_session_rejoin.sql` and `20250529170000_go_salary_requests.sql` for banker-approved GO collect)

3. Run the app (optional custom credentials):

```bash
flutter run \
  --dart-define=SUPABASE_URL=https://your-project.supabase.co \
  --dart-define=SUPABASE_ANON_KEY=your-anon-key
```

Defaults are embedded for the shared dev project; override for production.

See [`.env.example`](.env.example) for variable names.

## Architecture

Clean architecture by feature: `auth`, `home` (sessions), `transactions`, `dashboard` (UI). State: `flutter_bloc`. DI: `get_it`. Routing: `go_router`.

## Tests

```bash
flutter test
```

## Docs

- [`docs/functionalities_rules.md`](docs/functionalities_rules.md) — product rules
- [`docs/technical_details.md`](docs/technical_details.md) — stack and layers
