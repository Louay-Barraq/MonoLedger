# Coding Standards

These standards help keep MonoLedger readable, testable, and consistent as the app grows.

## Guiding Principles

- Keep the app easy to understand for future contributors.
- Prefer clear feature boundaries over clever abstractions.
- Keep money movement server-authoritative.
- Make realtime state predictable and recoverable.
- Preserve the fast, neon, game-night feel of the interface.

## Project Organization

Use the existing feature-first structure:

```text
lib/features/<feature>/
  data/
  domain/
  presentation/
```

Use `core/` only for shared utilities, app-wide theme, localization, configuration, and reusable widgets.

Avoid placing feature-specific behavior in `core/`.

## Layering Rules

- Presentation can depend on domain and data through injected repositories or BLoCs.
- Domain should stay independent of Flutter UI code.
- Data models can extend or convert to domain entities.
- Repository interfaces live in the domain layer.
- Repository implementations live in the data layer.

## State Management

Use BLoC or Cubit for flows that affect multiple widgets, routes, or backend state.

Good BLoC candidates:

- Auth status
- Session membership and realtime updates
- Transaction submission and transaction list watching
- GO salary requests
- Settings preferences

Use local `StatefulWidget` state for small UI-only concerns such as selected chips, text fields, keypad input, and temporary animations.

## Supabase and Backend Rules

Balance-changing operations must go through RPCs. Do not update player balances directly from UI code.

Client code should call repository methods, not raw Supabase queries, from presentation widgets.

When adding backend behavior:

- Add or update SQL migrations.
- Keep RPC names explicit.
- Add Row Level Security policies where table access changes.
- Make Banker-only actions verify the caller server-side.
- Return enough data for the app to update cleanly.

## Realtime Handling

Realtime events should be treated as update signals, not as the only source of truth.

Preferred pattern:

1. Listen to the relevant Supabase realtime stream.
2. Refetch the current session, players, transactions, or requests.
3. Emit a complete state object to the UI.

This is slightly more work than applying partial patches, but it is safer for multiplayer balance state.

## UI and Design Standards

MonoLedger uses a dark, high-contrast visual style with neon green as the primary action color.

Follow these conventions:

- Use `AppTheme` colors before introducing new colors.
- Use Plus Jakarta Sans for major labels/headings when consistent with nearby UI.
- Use monospace styling for codes, currency values, and compact data labels.
- Keep payment and balance numbers easy to scan.
- Keep important actions obvious and hard to trigger accidentally.
- Use slide-to-confirm or confirmation dialogs for high-impact actions.
- Avoid hidden admin behavior; Banker controls should be visible in appropriate settings areas.

## Localization

User-facing strings that appear in shared or high-level screens should move into `AppLocalizations`.

When adding localized text:

- Add an English string first.
- Add fallbacks for other supported locales when possible.
- Keep language labels in `AppLocale`.

Gameplay screens currently contain some hard-coded English strings. New work should move important repeated strings toward localization.

## Naming

- Files: `snake_case.dart`
- Classes, enums, and typedefs: `PascalCase`
- Methods, variables, and parameters: `camelCase`
- Private members: prefix with `_`
- BLoC events: use past-tense/request style names such as `SessionJoinRequested`
- BLoC states: use clear names such as `SessionLoading`, `SessionSuccess`, `SessionError`

## Error Handling

Map backend error codes to user-friendly messages in BLoCs or repositories.

Examples:

- `insufficient_funds` -> "Insufficient funds for this transfer."
- `session_closed` -> "This session is no longer active."
- `only_banker` -> "Only the Banker can perform this action."

Avoid showing raw backend exceptions directly to users.

## Testing Expectations

Add tests for:

- Formatting and parsing helpers.
- BLoC state transitions.
- Repository behavior when practical.
- Edge cases around joining, leaving, kicking, and failed transactions.

Before committing meaningful code changes, run:

```bash
dart format .
flutter test
```

## Documentation Expectations

When a feature changes user-visible behavior, update:

- `README.md` if the high-level product behavior changes.
- `docs/functionalities_rules.md` if game rules or user flows change.
- `docs/technical_details.md` if architecture, backend, routes, or dependencies change.
- `docs/stitched_screens_overview.md` if screens or navigation structure change.
