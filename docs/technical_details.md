# Technical Details

This document summarizes how MonoLedger is built and how the main app flows connect to the backend.

## Architecture Summary

MonoLedger is a Flutter application organized by feature. The code follows a practical clean architecture structure:

- Presentation layer: pages, widgets, BLoCs, and cubits.
- Domain layer: entities and repository interfaces.
- Data layer: models, repository implementations, and remote/local data sources.

The main app composition happens in `lib/main.dart`, while dependency registration happens in `lib/init_dependencies.dart`.

## Technology Stack

- Flutter and Dart
- Supabase Flutter
- Supabase Auth for anonymous sign-in
- Supabase Postgres for sessions, players, transactions, and GO salary requests
- Supabase RPCs for server-authoritative money movement
- Supabase Realtime for live updates
- `flutter_bloc` for state management
- `get_it` for dependency injection
- `go_router` for route management
- `shared_preferences` for local settings
- `equatable` for value-based state and entity comparison
- `qr_flutter` for QR code generation
- `mobile_scanner` for QR code scanning

## Feature Layout

```text
lib/features/auth/
  Anonymous authentication and auth state.

lib/features/splash/
  Splash screen and onboarding screens.

lib/features/home/
  Session entity, player entity, session repository, and session BLoC.

lib/features/session/
  Create session, join method, join code, and QR scan pages.

lib/features/dashboard/
  Wallet tab, ledger tab, players tab, payment pad, game settings, and end summary.

lib/features/transactions/
  Transaction entities, transaction BLoC, GO request BLoC, repositories, and data sources.

lib/features/settings/
  Locale, haptics preference, help page, and about page.
```

## App Startup

Startup flow:

1. Flutter bindings are initialized.
2. SharedPreferences is loaded.
3. Supabase is initialized from `AppConfig`.
4. Feature dependencies are registered with `get_it`.
5. `MonoLedgerApp` starts with shared BLoC providers.

The router starts at `/splash`. The splash screen checks authentication status and routes users to either `/home` or `/onboarding`.

## State Management

The app uses BLoC/Cubit classes for the main stateful flows:

- `AuthBloc`: checks auth, signs in anonymously, signs out.
- `SessionBloc`: creates, joins, resumes, watches, leaves, kicks, transfers Banker role, and handles removal.
- `TransactionBloc`: submits transfers and watches the transaction list.
- `GoRequestBloc`: creates and resolves GO salary requests.
- `LocaleCubit`: stores locale and haptics preferences.

## Routing

Routes are defined with `go_router`:

- `/splash`
- `/onboarding`
- `/home`
- `/create-session`
- `/join-session`
- `/join-session/code`
- `/join-session/scan`
- `/dashboard`
- `/payment-pad`
- `/game-settings`
- `/end-summary`
- `/settings`
- `/settings/help`
- `/settings/about`

Some routes receive domain objects or structured arguments through `state.extra`, especially payment pad, game settings, and end summary.

## Supabase Data Flow

### Authentication

The app uses anonymous auth through `signInAnonymously()`. The current Supabase user ID is used to associate a device/user with a player row in a session.

### Sessions

The session data source can:

- Insert a new session.
- Join a session by calling `join_session_by_code`.
- Fetch a session by join code.
- Watch a session and its players.
- End a session.
- Kick a player.
- Transfer Banker role.
- Leave a session.

Session config is stored as JSON and includes values such as currency, starting balance, GO amount, and Banker name.

### Transactions

Money movement is handled through Supabase RPCs:

- `transfer_to_player`
- `pay_bank`
- `receive_from_bank`
- `collect_go_salary` in older flow
- `request_collect_go` in the current Banker approval flow
- `resolve_collect_go`

The important design choice is that balance updates happen on the server. The client submits an intent, and Supabase updates player balances and inserts transaction rows.

### Realtime Updates

The app watches:

- `sessions`
- `players`
- `transactions`
- `go_salary_requests`

When realtime events arrive, the app refetches the relevant state. This avoids relying on partial event payloads for critical balance display.

## Database Migrations

The `supabase/migrations/` folder includes migrations for:

- Transaction table and money movement RPCs.
- Banker transfer and leave-session behavior.
- Player status handling for active, left, and kicked players.
- Rejoin behavior for players who voluntarily left.
- Banker-approved GO salary requests.

Important setup note: the included migrations expect a base Supabase schema with `sessions` and `players` already available. A brand-new Supabase project needs that base schema before these migrations can be applied successfully.

## Security Model

The database layer uses Row Level Security policies and RPCs to protect session data.

Expected rules:

- Only active session members can read session transactions and GO requests.
- Transactions should not be inserted directly by clients.
- Balance-changing operations should go through security-definer RPCs.
- Banker-only actions should verify the caller is an active Banker.
- Kicked players should not be able to rejoin the same session.

## Local Settings

Local preferences are stored with `shared_preferences`:

- Selected language
- Haptics enabled/disabled preference

The haptics preference is present in settings, while broader haptic behavior can be expanded in future UI interactions.

## Testing

The project includes tests for:

- Amount pad input
- Currency formatting
- Join-code parsing
- Locale cubit behavior
- Session BLoC behavior
- Transaction BLoC behavior
- Basic widget startup behavior

Run all tests with:

```bash
flutter test
```

## Known Implementation Notes

- The app depends on a correctly configured Supabase project for full end-to-end behavior.
- Session creation currently inserts into `sessions`; host player creation may depend on existing database-side behavior outside the visible migrations.
- Some screens are fully custom UI and use direct widget composition rather than a large shared component library.
- Localization exists for core settings/home copy, but several gameplay screens still use hard-coded English strings.
