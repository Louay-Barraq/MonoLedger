# MonoLedger PRD - Stitch Screens Overview

This document provides a detailed overview of the screens and design system found in the "MonoLedger PRD" Stitch project.

## 🎨 Design Strategy: Tactical Kineticism

The design system is built for speed, precision, and high-stakes interaction, moving away from a "static app" feel toward a "high-end utility instrument."

- **Foundation**: Deep charcoal foundations with piercing neon accents.
- **Primary Color**: `#3FFF8B` (Neon Green) - The "Action" color.
- **Secondary Color**: `#FFD709` (Gold) - The "Value" color.
- **Tertiary Color**: `#44A5FF` (Sky Blue) - The "Logic" color.
- **Typography**: 
  - **Headlines**: Plus Jakarta Sans (Authoritative/Wide)
  - **Body**: Inter (Neutral/Legible)
  - **Data/Currency**: Space Grotesk / JetBrains Mono (Monospaced for stability)
- **Layering**: Depth is achieved through background color shifts (`surface-container` tiers) instead of 1px borders.

---

## 📱 Screens Overview

### 1. Landing Screen (Final)
The entry point of the application.
- **Purpose**: Welcoming the user and providing clear paths to start or join a game.
- **Key Elements**: Primary CTAs for "Create Session" and "Join Session", branding logo.

### 2. Create Session (Final)
The setup interface for game hosts.
- **Purpose**: Configuring a new game session.
- **Key Elements**: Input fields for game rules, starting balances, and session naming.

### 3. Join Session (Final)
The entry point for players joining a host.
- **Purpose**: Connecting to an existing game via a session code.
- **Key Elements**: Session code input field, "Join" button.

### 4. Dashboard (Final)
The primary in-game interface.
- **Purpose**: Providing a real-time overview of the player's status.
- **Key Elements**: Current balance (large monospaced), quick action buttons (Pay, Request, Transfer), and game status indicators.

### 5. Payment Pad (Final)
The transaction interface.
- **Purpose**: Inputting and confirming currency transfers.
- **Key Elements**: Number pad, denomination bill buttons (circular icons), and the "Slide to Pay" confirmation widget.

### 6. Players List
Social overview of the game.
- **Purpose**: Seeing who is currently in the session and their approximate status.
- **Key Elements**: List of player cards showing names and status indicators (without dividers, separated by color shifts).

### 7. Detailed Ledger (Final)
The financial audit log.
- **Purpose**: Reviewing transaction history for transparency.
- **Key Elements**: Chronological list of incoming/outgoing transfers with timestamps and descriptions.

### 8. Game Settings
In-game configuration.
- **Purpose**: Adjusting rules or app behavior during a session.
- **Key Elements**: Toggles for notifications, haptics, and rule-specific adjustments.

### 9. End of Game Summary
The final results screen.
- **Purpose**: Determining the winner and showing final standings.
- **Key Elements**: Ranked list of players with final balances and game stats.

### 10. MonoLedger Board Game Currency Manager
General overview/branding screen.
- **Purpose**: High-level identification of the tool's utility.
- **Key Elements**: Branding and mission statement for the currency manager.

---

## ✨ New Designs: Splash & Onboarding

### 🚀 Splash Screen (Animation: "Power On")
The initial loading sequence designed to set the "Tactical Kineticism" tone.

- **Visual State**: Deep charcoal (`#0E0E0E`) background.
- **Animation Sequence**:
    1. **Outline Trace**: A faint, dim outline of the MonoLedger logo appears.
    2. **Pulse**: A high-speed neon green (`#3FFF8B`) pulse traces the logo's path.
    3. **Illumination**: A subtle CRT-style flicker effect as the logo fills with color and the "MonoLedger" text fades in.
    4. **Settling**: A soft, static glow remains behind the logo until the app transitions to Onboarding or Landing.

### 📚 Onboarding Sequence (3 Steps)

#### Step 1: Welcome to the Neon Ledger
- **Visuals**: Large geometric graphic representing "Wealth Control."
- **Copy**: "Tactical Wealth Management. Welcome to the Neon Ledger."
- **CTA**: "Next"

#### Step 2: Session Deployment
- **Visuals**: Iconography showing session codes and "connection rays."
- **Copy**: "Deploy your game. Create a new session or join an existing one in seconds."
- **CTA**: "Next"

#### Step 3: High-Speed Transactions
- **Visuals**: Animated preview of the "Slide to Pay" handle moving across a track.
- **Copy**: "Precision at speed. Authorize payments with a single tactile gesture."
- **CTA**: "Get Started"
