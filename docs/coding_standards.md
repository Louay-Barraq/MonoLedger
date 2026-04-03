# MonoLedger - Coding Standards

These rules are mandatory for all development iterations to maintain the high premium quality of MonoLedger.

## 📐 Architecture & Modularity
-   **Feature-First Design**: Organize code by features (e.g., `features/wallet`), keeping each feature self-contained with its own BLoCs, use cases, and repositories.
-   **Layer Isolation**: Never import code from a "higher" layer (e.g., UI) into a "lower" layer (e.g., Domain).
-   **Interfaces over Implementations**: Depend on repository interfaces in the domain layer to allow for easy swapping of data sources.

## 💄 Design Consistency (Tactical Kineticism)
-   **No Ad-hoc Styles**: All UI elements must use tokens from the `AppDesignSystem`.
-   **The "No-Line" Rule**: Avoid 1px borders. Use `surface-container` background shifts for separation.
-   **Animations**: All transitions must be smooth. Use `AnimatedSwitcher` and custom `TweenAnimations` for state changes.
-   **Haptics**: Integrate tactile feedback for all "kinetic" interactions (e.g., Sliding the pay handle).

## 🧩 Optimization & Performance
-   **Lazy Loading**: Use `ListView.builder` for list-intensive screens like the Detailed Ledger.
-   **Immutability**: All State and Entity classes must be `@immutable` using `equatable`.
-   **Reactive State**: Minimize `setState`. Use `BlocBuilder` and `BlocListener` for granular UI updates.

## 🧪 Testing & Quality
-   **Unit Tests**: Required for all Use Cases and BLoCs.
-   **Widget Tests**: Required for core reusable components (Buttons, Inputs).
-   **Clean Diffs**: Ensure code is formatted with `dart format .` before every commit.

## 🛠️ Tooling & Standards
-   **Naming**: Use `snake_case` for files and `PascalCase` for classes.
-   **Doc Comments**: Provide dartdoc comments (`///`) for all public API methods and complex business logic.
