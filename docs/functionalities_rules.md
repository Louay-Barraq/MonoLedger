# Functionalities and Rules

This document explains what MonoLedger does from a user's point of view. It is useful for contributors, testers, and anyone trying to understand the intended product behavior.

## Product Purpose

MonoLedger replaces physical board-game cash with a shared digital wallet system. A host creates a game session, players join with a code or QR scan, and all balances update in real time as players make payments.

The app is designed for board games where money changes hands often and mistakes can slow the game down.

## Main Roles

### Player

A player can:

- Join an active session.
- View their current balance.
- Pay another player.
- Pay money to the bank.
- Receive money from the bank.
- Request GO salary.
- View the shared transaction ledger.
- Leave the session.

### Banker

The Banker is the session owner/administrator. The Banker can do everything a player can, plus:

- Approve or decline GO salary requests from other players.
- Transfer the Banker role to another active player.
- Kick players from the session.
- End the game.

The app treats the Banker as a privileged player, not as a separate account type.

## Core Features

### Anonymous Sign-In

MonoLedger uses Supabase anonymous authentication so users can start quickly without creating a traditional account.

### Create Session

The host creates a session by choosing:

- Banker name
- Currency symbol
- Starting capital
- GO salary amount

The app creates a session code that can be copied or shared as a QR code.

### Join Session

Players can join an open session by:

- Typing the 6-character join code.
- Scanning the session QR code.

Players who voluntarily left can rejoin if the backend permits it. Players who were kicked cannot rejoin the same session.

### Live Session Sync

The app watches session and player updates through Supabase realtime streams. This keeps balance changes, player status, Banker changes, and session ending events visible to everyone.

### Wallet

The wallet tab shows:

- Current player's balance.
- Percentage change compared with the starting balance.
- GO salary action.
- Bank payment actions.
- Ranked player list for quick player-to-player payments.

### Payment Pad

The payment pad is used to enter and confirm money movement. It includes:

- Numeric keypad input.
- Decimal support.
- Quick denomination chips for common board-game values.
- Slide-to-confirm interaction.

Transfers are submitted only after the slide confirmation completes.

### Transaction Types

MonoLedger supports four transaction types:

- Player to player: one player pays another active player.
- Pay bank: a player pays money out to the bank.
- From bank: a player receives money from the bank.
- Collect GO: a player receives the configured GO salary.

### GO Salary

GO salary follows a Banker approval model:

- The Banker can collect GO instantly.
- Non-bankers create a pending GO request.
- The Banker sees a prompt and can approve or decline the request.
- Approved GO requests create a transaction and update the player's balance.
- A player can have only one pending GO request at a time.

### Ledger

The ledger tab shows the shared session history. It is the source for reviewing disputed moves during play.

Each item shows:

- Transaction direction/type.
- Related players or bank.
- Amount.
- Time label.

### Player Management

The active player list shows who is currently in the session and who is the Banker.

The Banker can:

- Kick an active player.
- Transfer Banker ownership.

Kicked players are removed from the active view and are blocked from rejoining that session.

### Leaving a Session

Players can leave the session voluntarily.

If the Banker leaves while other active players remain, backend logic can assign the Banker role to another player. If no active players remain, the session ends.

### Ending a Game

When a session is ended, the app routes players to the end summary screen. The summary ranks players by final balance and highlights the winner.

## Safety Rules

- Transactions must go through server-side Supabase RPCs.
- A player cannot pay themselves.
- A player cannot pay more than their current balance.
- Inactive, kicked, or missing players cannot receive player-to-player transfers.
- Closed sessions cannot accept new transactions.
- Large bank payouts above 50 percent of total player liquidity require an extra confirmation in the app.

## User Guidance

- Share session codes only with people playing the game.
- Use the ledger to resolve mistakes or disputes.
- Keep the app open during play for the smoothest realtime updates.
- End the session when the game is finished so players see final standings.
