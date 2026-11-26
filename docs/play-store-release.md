# Google Play release guide

Status (26 Nov 2026): database migrations pushed, upload key configured,
GitHub Pages set to `main` → `/docs` (the legal pages go live once this branch
is merged), screenshots and graphics in `store/`. What's left is the Play
Console itself.

## 1. One-time setup (you)

1. **Push the pending database migrations.** Three migrations have run locally
   and in the tests but not on the live project yet:
   `20260604040000_capture_dashboard_objects`, `20261126120000_go_cleanup_profiles_reversal`,
   `20261126130000_delete_my_account`.

   ```bash
   supabase db push --include-all
   ```

   The app's reversal, Past games stats, GO cleanup and **Delete my data**
   (required by Play) depend on them.

2. **Publish the legal pages.** GitHub → repo Settings → Pages → Source:
   "Deploy from a branch", branch `main`, folder `/docs`. The URLs become:
   - Privacy policy: https://louay-barraq.github.io/MonoLedger/privacy-policy.html
   - Delete data: https://louay-barraq.github.io/MonoLedger/delete-data.html

   These are already the defaults in `lib/core/config/app_config.dart`. If you
   host them elsewhere, pass `--dart-define=PRIVACY_POLICY_URL=...` and
   `--dart-define=DELETE_DATA_URL=...` when building.

3. **Create the upload key** (keep the file and passwords safe and out of git):

   ```bash
   keytool -genkey -v -keystore ~/monoledger-upload.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload
   ```

   Copy `android/key.properties.example` to `android/key.properties` and fill it
   in. Turn on **Play App Signing** in the Play Console (default for new apps).

4. **Check the application ID.** It is `com.louaybarraq.monoledger`. It can't
   change after the first upload; edit `android/app/build.gradle.kts` (and the
   `MainActivity.kt` package/folder) now if you want a different one.

## 2. Build

```bash
flutter build appbundle --release
```

Upload `build/app/outputs/bundle/release/app-release.aab`. Bump `version:` in
`pubspec.yaml` (for example `1.0.1+2`) for every new upload.

## 3. Store listing

**App name:** MonoLedger

**Short description (80 max):**
> Replace paper money in board games with a live shared ledger for every player.

**Full description:**
> MonoLedger replaces the paper money in your board games with a live, shared ledger on every player's phone.
>
> • Host a game in seconds: pick a currency symbol, starting money and GO salary.
> • Friends join with a 6-character code or by scanning a QR code.
> • Pay other players or the bank with a quick keypad and slide-to-confirm.
> • The Banker approves GO salary, can undo a mistaken payment, and manages players.
> • Every payment shows up instantly in a shared ledger, so disputes take seconds.
> • See final standings, game highlights and your past games.
>
> No sign-up, no ads, no tracking. MonoLedger tracks pretend money only; it does not handle real money.

**Graphics (in `store/`):** `icon-512.png` (512×512), `feature-graphic.png`
(1024×500) and 7 phone screenshots in `store/screenshots/` (1080×2160, taken
from a real game on a Pixel 7a emulator): welcome, home, wallet, GO approval,
payment pad, ledger, end summary. Logo rationale: `design/logo-variants.md`.

**Category:** Board (or Tools). **Tags:** board games, score keeper.

**Trademarks:** don't name other companies' games (for example "Monopoly") in
the listing or screenshots. The app's own text and README no longer name other
games; keep it that way.

## 4. App content answers

**Privacy policy URL:** the GitHub Pages URL above.

**Ads:** No.

**App access:** All functionality is available without special access (anonymous
sign-in happens automatically).

**Target audience:** 13+ (the app is not designed for children; a lower age
group adds Families policy requirements).

**Content rating (IARC):** utility/reference-type app; no violence, sexual
content, gambling (no real money, no prizes), user-to-user chat or location
sharing. Players see each other's chosen display names inside a game: answer
"yes" to users interacting/sharing content only if asked about display names
visible to other users.

**Data safety:**

| Question | Answer |
| --- | --- |
| Collects or shares user data? | Collects: yes. Shares: no. |
| Encrypted in transit? | Yes |
| Users can request deletion? | Yes, in-app (Settings → Delete my data) and the delete-data URL |
| Personal info → Name | Collected (the display name typed for a game). Required for app functionality. Not shared. |
| Personal info → User IDs | Collected (random anonymous account ID). App functionality. Not shared. |
| App activity → Other user-generated content | Collected (in-game payments and balances). App functionality. Not shared. |
| Device or other IDs | Not collected. |
| Location, contacts, photos, financial info, messages, health | Not collected. Camera images are processed on-device only and never leave the phone. |
| Processing ephemeral? | No (game history is stored). |

Supabase acts as a service provider (processor), which Play does not count as
"sharing".

**Account deletion URL:** the delete-data URL above.

## 5. Before you press "Release"

- Install the release build on a real Android phone and play a full game with
  a second phone: create, join by code and QR, pay, GO request/approve,
  reversal, leave/rejoin, end game, Past games, Delete my data.
- Start with an **internal testing** track; Play requires closed testing with
  testers for new personal developer accounts before production.
