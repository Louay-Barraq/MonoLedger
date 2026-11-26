# MonoLedger logo exploration

Brief: an ownable symbol for a board-game money app. Playful game-night energy,
precise like a ledger, inside the existing dark "neon terminal" system
(#0B0D0F background, #14F195 mint, Plus Jakarta Sans / Space Mono). It must read
as an Android launcher icon at 48px inside the 66% safe zone, work in one
colour, and avoid any resemblance to Monopoly or other game trademarks.

Architecture: symbol plus wordmark lockup ("MonoLedger", Mono white + Ledger
mint, as already used in the app), with the symbol alone for the launcher
icon, splash and square contexts.

Renders: `design/logo-variants/NN-name.png` (512px) and `NN-name-48.png`
(launcher size). Regenerate with `flutter test tool/logo_variants_test.dart`.

| # | Variant | Approach | Verdict |
|---|---------|----------|---------|
| 01 | Coin-stack M: three coin columns, tall-short-tall | Literal + letterform | Rejected: reads as an audio equalizer, not money or an M |
| 02 | Token ledger: ring with three ledger rows and a cursor | Abstract gesture | Right idea; thin ring weak on circle masks |
| 03 | Exchange coin: one coin split in two halves sliding apart | Abstract gesture | Rejected: reads as a letter "e", says nothing about money |
| 04 | ML monogram: monoline M running into an L foot | Monogram | Clean but generic initials; no game-night character |
| 05 | Die ledger: die face whose middle pips became a ledger row | Literal | Rejected: reads as a ÷ sign in a box |
| 06 | Pip M: five dice pips arranged as an M | Letterform | Rejected: reads as the five face of a die |
| 07 | Ledger coin: solid coin with rows and cursor cut out | Refined 02 | Rejected: green circle + stacked bars is too close to Spotify |
| **08** | **Hex ledger token** | **Refined 02** | **Selected** |

## 08, Hex ledger token (selected)

- **Architecture:** symbol; lockup with the existing two-tone wordmark.
- **Typography (lockup):** Plus Jakarta Sans ExtraBold, "Mono" white + "Ledger" #14F195.
- **Symbol:** a pointy-top hexagon (radius 40% of the box, corners rounded at
  7%) = a board-game token. Cut out of it: three left-aligned ledger rows
  (38 / 28 / 16% wide, 7% tall, pill ends) and a square terminal cursor after
  the last row. Geometry lives in `lib/core/widgets/monoledger_logo.dart`.
- **Colour tokens:** mint #14F195 on #0B0D0F (primary and reverse); single-colour
  black #000000 or white #FFFFFF (the cut-outs stay transparent).
- **Application notes:** launcher icon (adaptive foreground fits the safe zone;
  background #0B0D0F), 512px store icon, feature graphic lockup, splash,
  onboarding and home. Reads at 48px; at 16px the hexagon and top row survive.
  No gradients, so it embroiders and foil-stamps cleanly.
- **Signals:** a game piece (hex token) holding a ledger with a live cursor:
  play money, kept precisely, updating in real time.
- **Rejects:** wallets and banking clichés, dollar signs, top hats, property
  cards, and the circle-with-bars look of music apps.
