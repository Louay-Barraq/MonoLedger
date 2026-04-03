# Design System Strategy: Tactical Kineticism

## 1. Overview & Creative North Star
**The Creative North Star: "The Neon Ledger"**
This design system is built for speed, precision, and high-stakes interaction. It moves away from the "static app" feel toward a "high-end utility instrument." By leveraging deep charcoal foundations and piercing neon accents, the system mimics the look of professional fintech tools and military-grade interfaces, adapted for the competitive environment of board games. 

The aesthetic identity is defined by **Tactical Kineticism**: every element feels like it is part of a live, breathing engine. We break the "template" look through intentional asymmetry in card layouts, monospaced data precision, and "physical" depth that replaces standard flat borders with tonal layering.

---

## 2. Colors
The palette is engineered for high contrast to ensure legibility in various gaming environments (from dimly lit living rooms to bright tabletops).

*   **Primary (`#3FFF8B`):** The "Action" color. Used for confirmations, capital gains, and successful transactions.
*   **Secondary (`#FFD709`):** The "Value" color. Reserved for high-denomination bills and critical system warnings.
*   **Tertiary (`#44A5FF`):** The "Logic" color. Used for mid-tier denominations and secondary navigation.

### The "No-Line" Rule
Designers are prohibited from using 1px solid borders to section off content. Boundaries must be defined solely through background color shifts. For example, a `surface-container-low` section should sit on a `background` floor. This creates a seamless, modern flow that feels like a single integrated surface rather than a collection of boxes.

### Surface Hierarchy & Nesting
Use the `surface-container` tiers to create "nested" depth:
*   **Global Background:** `surface-dim` (#0E0E0E).
*   **Main Interactivity Area:** `surface-container-low` (#131313).
*   **Actionable Cards:** `surface-container-high` (#20201F).
*   **Floating Modals:** `surface-bright` (#2C2C2C).

### Glass & Gradient Rule
To achieve a premium "Editorial" feel, floating elements (like the 'Slide to Pay' widget) should utilize **Glassmorphism**. Use a semi-transparent `surface` color with a `24px` backdrop blur. Primary CTAs should not be flat; apply a subtle linear gradient from `primary` to `primary-container` at a 135-degree angle to provide visual "soul."

---

## 3. Typography
The system uses a tri-font strategy to balance character, readability, and data-density.

*   **Display & Headlines (Plus Jakarta Sans):** Chosen for its wide, authoritative stance. Use `display-lg` for room codes and `headline-md` for screen titles. Its geometric nature feels modern and high-end.
*   **Body & Titles (Inter):** The workhorse. Inter provides maximum legibility for player names and settings. It is neutral, allowing the currency values to take center stage.
*   **Labels & Values (Space Grotesk / JetBrains Mono):** For currency values and technical labels, use monospaced or highly tabular fonts. This ensures that as numbers fluctuate (e.g., $1,000 changing to $1,900), the characters do not "jump" or shift, maintaining a stable UI.

---

## 4. Elevation & Depth
In this system, depth is a function of light, not lines.

*   **The Layering Principle:** Stacking `surface-container` tiers creates a natural lift. An opponent's card (`surface-container-highest`) placed on the player grid (`surface-container-low`) creates immediate hierarchy without a single shadow.
*   **Ambient Shadows:** For floating action buttons or the Wallet Card, use an extra-diffused shadow: `box-shadow: 0 20px 40px rgba(0, 0, 0, 0.4)`. The shadow color must be a tinted version of the background to maintain the "Dark Mode" immersion.
*   **The "Ghost Border" Fallback:** If a border is required for accessibility, use the `outline-variant` at 15% opacity. It should be felt, not seen.
*   **Haptic Visuals:** Elements should feel "pressable." Use a slight scale down (98%) and a shift to a lower `surface-container` color on active states to mimic tactile feedback.

---

## 5. Components

### Bill Buttons
*   **Style:** Perfectly circular.
*   **Visuals:** Use the `outline` token for the ring. The value inside uses the color-coded denomination (Primary for $5/$500, Tertiary for $20, etc.).
*   **State:** On tap, the circle fills with a 10% opacity version of its denomination color.

### Wallet Card
*   **Layout:** High-contrast `primary` text for the balance.
*   **Asymmetry:** Place the "Balance" label in a `label-sm` monospaced font in the upper-left, with the large monospaced value anchored to the right to create a professional, non-standard layout.

### Confirm Slider ('Slide to Pay')
*   **Track:** `surface-container-lowest` with a "Ghost Border."
*   **Handle:** A `primary` circular icon with a chevron.
*   **Visual Cue:** As the user slides, the track behind the handle fills with a `primary-container` gradient, creating a "charging" effect.

### Input Fields
*   **Style:** Soft, `surface-container-high` backgrounds.
*   **Focus State:** No thick borders. Instead, the `outline` glows subtly with the `primary` color at 30% opacity.

### Player Grid
*   **Constraint:** Forbid the use of divider lines. 
*   **Separation:** Use `spacing-4` (1rem) vertical gaps and subtle background shifts between the "Host" player and opponents.

---

## 6. Do's and Don'ts

### Do:
*   **Use Monospacing for Numbers:** Always use monospaced fonts for currency to prevent layout jitter during rapid transactions.
*   **Embrace Negative Space:** Use the `spacing-8` and `spacing-12` tokens to let the "Neon Ledger" breathe. High contrast requires more room to avoid eye fatigue.
*   **Intentional Asymmetry:** Align labels to the left and values to the right within cards to create a sophisticated, editorial look.

### Don't:
*   **Don't Use Pure Black (#000000):** Except for the `surface-container-lowest`. Use `background` (#0E0E0E) to allow for depth layering.
*   **Don't Use 1px Solid Borders:** This is the quickest way to make the app look "cheap" or "templated." 
*   **Don't Mix Gradients:** Stick to the 135-degree "Action" gradient for Primary elements only. Do not apply gradients to neutral surfaces.
*   **Don't Use Standard Shadows:** Avoid small, dark, "muddy" shadows. If it's not a large, ambient ambient glow, don't use a shadow at all.