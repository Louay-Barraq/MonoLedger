# Google Play store listing and ASO

The listing text lives in `fastlane/metadata/android/<locale>/`, in the layout
`fastlane supply` uploads, so there is one copy to edit. `flutter test`
(`test/store_listing_test.dart`) checks Play's length limits, screenshot count
and banned terms.

| Play language | Folder | Title (max 30) |
| --- | --- | --- |
| English (United States), default | `en-US` | MonoLedger: Game Money Banker |
| French (France) | `fr-FR` | MonoLedger : Banque de jeux |
| Spanish (Spain) | `es-ES` | MonoLedger: Banco de juegos |
| Arabic | `ar` | MonoLedger: بنك ألعاب الطاولة |

Each folder holds `title.txt`, `short_description.txt`, `full_description.txt`,
`changelogs/1.txt` and, under `images/`, the icon, a feature graphic and six
1080×1920 screenshots with a headline in that language (`phoneScreenshots/`).

## Keyword plan

Google Play has no keyword field: it ranks on the title, short description and
full description. Title carries the head term, the short description the next
ones, and the full description repeats them naturally with long-tail phrases in
section text.

| | Title | Short description | Long tail in the full description |
| --- | --- | --- | --- |
| EN | game money, banker | board game money, balances, paper cash | play money, game bank, money tracker, tabletop game, ledger, game night |
| FR | banque, jeux | argent, jeux de société, soldes | banquier, argent fictif, compteur d'argent, jeu de plateau, soirées jeux |
| ES | banco, juegos | dinero, juegos de mesa, saldos | banquero, banca, dinero ficticio, contador de dinero, juego de tablero |
| AR | بنك، ألعاب الطاولة | أموال، هاتف، أرصدة | المصرفي، أموال وهمية، عدّاد أموال، لعبة لوحية، سهرات اللعب |

**How these were chosen, and what is not known.** The terms come from how
comparable apps describe themselves ("banker", "board money", "game bank") and
from natural phrasing in each language. No search-volume tool was used, so
treat them as a starting point. After launch, check Play Console → Grow →
Store performance → search terms every few weeks, and use **Store listing
experiments** to test one change at a time (icon first, then short description,
then first screenshot).

**Deliberately left out:** "Monopoly" and other publishers' game names. They
would attract searches, but Play's metadata and impersonation rules prohibit
using others' trademarks, and a listing can be rejected or removed for it.

## Screenshot order

1. Every balance, live (wallet)
2. Pay in seconds (payment pad)
3. Every payment recorded (ledger)
4. The Banker is in charge (salary approval)
5. Crown the winner (end summary)
6. Your game, your rules (create game)

The first two or three are what most people see in search results. Regenerate
with `flutter test tool/store_screenshots_test.dart --dart-define=RAW_DIR=<captures>`.

## Console settings

- **App or game:** App. **Category:** Entertainment.
- **Tags:** pick up to five from Play's list, closest to board games, utilities
  and entertainment.
- **Contact:** a support email is required and shown publicly; website:
  https://louay-barraq.github.io/MonoLedger/
- **Add languages:** Grow → Store presence → Main store listing → Manage
  translations → add French (France), Spanish (Spain) and Arabic.
- Play shows the English listing to every other language. Adding Spanish (Latin
  America, `es-419`) later is worthwhile; copy `es-ES` and change "móvil" to
  "celular".
- **Graphics:** per language in `fastlane/metadata/android/<locale>/images/`:
  `icon.png` (512×512), `featureGraphic.png` (1024×500) and screenshots. Copies
  of the English ones are in `store/`.
