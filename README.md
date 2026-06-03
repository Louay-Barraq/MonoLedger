# MonoLedger

MonoLedger is a Flutter app that replaces board-game paper money with a live digital ledger. It is built for games such as Monopoly, The Game of Life, and any table game where players need fast balance tracking, bank payments, and transparent transaction history.

Players can host or join a session, share a short code or QR code, pay each other, pay the bank, collect GO salary, and review every transaction in real time.

## What It Does

- Creates multiplayer game sessions with custom currency, starting capital, and GO salary.
- Lets players join with a 6-character code or a QR scan.
- Keeps every player's balance synced through Supabase realtime updates.
- Supports player-to-player transfers, bank payments, bank payouts, and GO salary.
- Uses a slide-to-confirm payment pad to reduce accidental transfers.
- Gives the Banker extra controls for GO approvals, player removal, banker transfer, and ending the session.
- Shows a shared ledger so disputes can be resolved from the transaction history.
- Ends games with standings, winner display, and session summary.
- Includes app settings, language selection, help, and about pages.

## App Sections

### Splash and Onboarding

The app starts with a branded splash screen, then guides new users through a short onboarding flow before anonymous sign-in.

### Home

The home screen is the launch point for creating a new game or joining an existing one. It also links to settings.

### Create Session

Hosts configure the game before play starts:

- Banker name
- Currency symbol
- Starting capital
- GO salary amount

After creation, MonoLedger generates a join code for the session.

### Join Session

Players can join in two ways:

- Enter the 6-character session code manually.
- Scan the host's QR code.

Each player provides a display name before entering the session.

### Dashboard

The dashboard is the main in-game area. It has three tabs:

- Wallet: current balance, GO salary, bank actions, and quick player payments.
- Ledger: chronological transaction history for the full session.
- Players: active participants, balances, and Banker information.

### Payment Pad

The payment pad is used for all money movement. It includes:

- Numeric amount entry
- Quick denomination chips
- Pay/receive context
- Slide-to-confirm authorization
- Extra confirmation for very large bank payouts

### Game Settings

Game settings show the session code, fiscal rules, and active players. The Banker can transfer the Banker role, kick players, leave the session, or end the game.

### End Summary

When the session ends, players see the final standings, winner, total money in play, and participant count.

## Tech Stack

- Flutter and Dart
- Supabase Auth, Postgres, RPCs, Row Level Security, and Realtime
- `flutter_bloc` for state management
- `get_it` for dependency injection
- `go_router` for navigation
- `shared_preferences` for local settings
- `qr_flutter` for QR generation
- `mobile_scanner` for QR scanning
- `google_fonts` and `flutter_animate` for the visual system

## Project Structure

```text
lib/
  core/
    config/             App configuration
    localization/       Locale definitions and string catalog
    theme/              Dark neon app theme
    utils/              Formatting, QR, routing, and amount helpers
    widgets/            Shared UI widgets
  features/
    auth/               Anonymous authentication
    splash/             Splash and onboarding
    home/               Session state and home page
    session/            Create and join screens
    dashboard/          Wallet, ledger, players, payment pad, settings, summary
    transactions/       Transactions and GO salary requests
    settings/           Locale, haptics, help, and about pages

supabase/
  migrations/           Database migrations and RPC definitions

docs/
  functionalities_rules.md
  technical_details.md
  coding_standards.md
  stitched_screens_overview.md
```

## Requirements

- Flutter SDK compatible with Dart `^3.11.1`
- A Supabase project
- Android Studio or Xcode if running on mobile devices/simulators

## Setup

1. Install Flutter dependencies:

```bash
flutter pub get
```

2. Prepare Supabase.

Apply the SQL migrations in `supabase/migrations/` in chronological order. The current migrations expect the base `sessions` and `players` schema to already exist in the Supabase project, as noted in the original project setup.

3. Run the app with your Supabase credentials:

```bash
flutter run \
  --dart-define=SUPABASE_URL=https://your-project.supabase.co \
  --dart-define=SUPABASE_ANON_KEY=your-anon-key
```

The code includes default development credentials in `lib/core/config/app_config.dart`, but production builds should pass credentials through `--dart-define`.

## Testing

Run the test suite:

```bash
flutter test
```

Current tests cover core input/formatting helpers, join-code parsing, locale state, transaction state, and session state behavior.

## Documentation

- [Functionalities and Rules](docs/functionalities_rules.md): product behavior and game rules.
- [Technical Details](docs/technical_details.md): architecture, data flow, and backend notes.
- [Coding Standards](docs/coding_standards.md): conventions for future development.
- [Screens Overview](docs/stitched_screens_overview.md): screen-by-screen UI overview.

## Status

MonoLedger is an active Flutter project with the main game flow implemented. The Supabase backend is central to the experience, so a working database schema and RPC setup are required before full multiplayer testing.
