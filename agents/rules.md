# MonoLedger - Agent Coding Rules

Follow these rules strictly during every iteration of development for the MonoLedger project.

## 🏛️ Architecture
- Always use **Clean Architecture** (Data, Domain, Presentation).
- State management must be handled by **BLoC**.
- Features must be modular and located in `lib/features/`.

## 🎨 UI & Design
- Adhere to the **"Tactical Kineticism"** strategy.
- **No Borders**: Use background color shifts (`surface-container` variants).
- **Neon Accents**: Use `#3FFF8B` for primary actions.
- **Monospaced Numbers**: Use `Space Grotesk` or `JetBrains Mono` for currency values.

## 🛠️ Implementation
- **Clean Code**: Follow SOLID principles.
- **Immutability**: Use `Equatable` for states and events.
- **Performance**: Optimize list rendering and minimize widget rebuilds.

## ✅ Verification
- **Test Before Complete**: Run unit tests for every new BLoC or UseCase.
- **Visual Check**: Verify UI against the "Stitch" design system strategy.
