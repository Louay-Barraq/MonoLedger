# Screens Overview

This document describes the major MonoLedger screens and how they fit together in the user journey.

## Design Direction

MonoLedger is designed like a fast board-game finance console:

- Dark background for focus during game night.
- Neon green for primary action and important status.
- Large readable balances.
- Monospace labels for codes, currency, and compact data.
- Touch-first controls for quick play.
- Confirmation patterns for irreversible or high-impact actions.

The goal is to make the app feel quick and tactile without making the rules hard to understand.

## Navigation Map

```text
Splash
  -> Onboarding
  -> Home

Home
  -> Create Session
  -> Join Session
  -> Settings

Join Session
  -> Enter Code
  -> Scan QR Code

Dashboard
  -> Wallet Tab
  -> Ledger Tab
  -> Players Tab
  -> Payment Pad
  -> Game Settings
  -> End Summary

Settings
  -> Help
  -> About
```

## Splash Screen

Purpose: introduce the brand and decide where the user should go next.

Behavior:

- Checks authentication status.
- Routes authenticated users to Home.
- Routes unauthenticated users to Onboarding.

## Onboarding

Purpose: quickly explain the app before anonymous sign-in.

Current flow:

1. Welcome to MonoLedger.
2. Realtime syncing.
3. Secure/private session experience.

The final onboarding action signs the user in anonymously and sends them to Home.

## Home

Purpose: starting point for each visit.

Primary actions:

- Create Session
- Join Session

Secondary actions:

- Open Settings

The page also communicates that the app supports multiplayer realtime board-game money tracking.

## Create Session

Purpose: configure a new game.

Inputs and controls:

- Banker name
- Currency symbol
- Starting capital presets
- Custom starting capital
- GO amount presets
- Custom GO amount

Successful creation sends the host into the Dashboard with a generated join code.

## Join Method

Purpose: let players choose how they want to connect.

Options:

- Enter Code
- Scan QR Code

## Join Code

Purpose: manually join a session.

Inputs:

- 6-character session code
- Player display name

The screen validates that the code and name are present before dispatching the join request.

## Join QR Scan

Purpose: join by scanning the host's QR code.

Behavior:

- Opens the camera scanner.
- Reads MonoLedger QR payloads.
- Extracts the session code.
- Routes to the Join Code screen with the code prefilled.

## Dashboard

Purpose: main in-game shell.

The dashboard owns the current session context and starts watchers for:

- Session/player updates
- Transactions
- GO salary requests

It also handles:

- Kicked-player removal flow
- Session-ended flow
- QR sharing
- Leave-session confirmation
- Bottom tab navigation

## Wallet Tab

Purpose: give each player their working game wallet.

Main elements:

- Current balance card
- Change versus starting balance
- GO salary button
- Pay Bank action
- From Bank action
- Ranked active players list

Tapping another player opens the Payment Pad for a player-to-player transfer.

## Ledger Tab

Purpose: provide financial transparency.

Shows:

- Number of transactions
- Transaction list
- Transaction type
- Parties involved
- Amount direction
- Time label

Also links to Game Settings when session data is available.

## Players Tab

Purpose: show who is currently in the game.

Shows:

- Bank/Banker card
- Active players
- Player balances
- Banker badge

## Payment Pad

Purpose: enter and confirm transfers.

Supports:

- Player-to-player payments
- Paying the bank
- Receiving from the bank

Controls:

- Numeric keypad
- Comma decimal separator
- Quick denomination chips
- Clear and backspace
- Slide-to-confirm button

Special behavior:

- Large bank payouts above 50 percent of total player liquidity require a second confirmation.
- Transfers are blocked if the user is no longer active in the session.

## GO Approval Banner

Purpose: notify the Banker when another player requests GO salary.

Behavior:

- Shows pending GO salary requests to the Banker.
- Allows approve or decline.
- Approved requests update the request and create a salary transaction through Supabase.

## Game Settings

Purpose: manage the active session.

Always shows:

- Session code
- Copy code action
- Starting capital
- GO bonus
- Active player list

Banker controls:

- Transfer Banker role
- Kick player
- Leave session
- End session

Player controls:

- Leave session

## End of Game Summary

Purpose: close the session with a clear result.

Shows:

- Winner card
- Final standings
- Total money across listed players
- Participant count
- Save and exit action

## Settings

Purpose: app-level preferences and support information.

Includes:

- Language selection
- Haptics toggle
- Help and FAQ
- About page
- Version label

## Help

Purpose: answer common user questions.

Topics include:

- What MonoLedger is
- Creating a session
- Joining a session
- Banker role
- GO salary
- Leaving and rejoining
- Kicked players
- Data storage
- Supported games

## About

Purpose: explain the app and credit the developer.

Includes:

- MonoLedger summary
- Developer information
