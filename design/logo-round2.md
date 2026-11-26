# MonoLedger logo, round 2

Feedback on round 1: the hex token "doesn't give an idea about the application".
Goal for round 2: someone seeing the icon for two seconds in the Play Store
should think "board-game money, on my phone". All marks are mint #14F195 on
#0B0D0F, single colour, drawn in code, and contain nothing from Monopoly
(no top hat, no mascot, no property cards, no pastel bills).

Comparison sheet: `design/logo-round2/sheet.png` (each mark large, plus its
48px launcher-size preview). Single marks: `design/logo-round2/NN.png`.
Regenerate: `flutter test tool/logo_round2_test.dart`.

| # | Name | Approach | Signals | Watch-outs |
|---|------|----------|---------|------------|
| 01 | Note into phone | Literal | Paper money moving into your phone: exactly what the app replaces | Phone outline is thin at 48px; strongest as a story, weakest silhouette |
| 02 | Pawn coin | Literal (game + money) | A game piece stamped on a coin: board-game money in one shape | Pawn also reads as chess; still "game" |
| 03 | Die and coin | Literal (game + money) | Dice plus a token: game night and money together | Two objects compete at small sizes |
| 04 | Banknote M | Letterform-derived | A bill with M where the portrait goes: money + MonoLedger | Wide shape uses ~80% of an adaptive icon's width |
| 05 | Coin exchange | Abstract gesture | Money passing between players: payments between friends | Close to generic "sync/exchange" icons |
| 06 | Coin M | Letterform-derived | A minted coin with M: currency + brand, very sketchable | Coin-with-letter is common in finance apps |
| 07 | Fanned notes | Literal | A hand of play money held like cards: playful, game-table energy | Notes read as cards first, money second |
| 08 | Pawn banknote | Literal + wit | A bill whose portrait is a game pawn: "game money" in one image | Most detail; pawn is small at 48px |

## Selected: 03, Die and coin (26 Nov 2026)

In production in `lib/core/widgets/monoledger_logo.dart`: the same die and coin,
centred in its box, with the pips, the coin rim and the die/coin gap as real
cut-outs so it works in one colour on any background. Used for the launcher
icon, Android splash, in-app screens, store icons and feature graphics.
Regenerate graphics with `flutter test tool/render_icon_test.dart` followed by
`dart run flutter_launcher_icons`.
