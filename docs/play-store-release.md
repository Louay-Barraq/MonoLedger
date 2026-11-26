# Google Play release guide

Status (26 Nov 2026): database migrations pushed, upload key configured, legal
pages live on GitHub Pages, listings and screenshots for four languages ready in
`fastlane/metadata/android/`, with the Die and coin icon and a feature graphic
per language. What's left is the Play Console itself.

## 1. Before the first upload

- **Application ID** is `com.louaybarraq.monoledger`. It can't change after the
  first upload.
- **Upload key:** `android/key.properties` points at your keystore (git-ignored).
  Back the keystore and passwords up somewhere safe. Turn on **Play App Signing**.
- **Legal pages:**
  - Privacy policy: https://louay-barraq.github.io/MonoLedger/privacy-policy.html
  - Delete data: https://louay-barraq.github.io/MonoLedger/delete-data.html

## 2. Build

```bash
flutter build appbundle --release
```

Upload `build/app/outputs/bundle/release/app-release.aab`. Bump `version:` in
`pubspec.yaml` (for example `1.0.1+2`) for every new upload, and add a matching
`changelogs/<versionCode>.txt` per language.

## 3. Store listing

All listing text, ASO notes, category and tags: [store-listing.md](store-listing.md).

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
