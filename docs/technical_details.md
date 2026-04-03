# MonoLedger - Technical Details

This document outlines the technical architecture and implementation strategy for the MonoLedger Flutter application.

## 🏗️ Architecture: Clean Architecture

To ensure maintainability, scalability, and testability, MonoLedger follows the **Clean Architecture** pattern, dividing the code into three primary layers:

1.  **Data Layer**:
    *   **Repositories**: Implementation of domain repository interfaces.
    *   **Data Sources**: Remote (Firebase/Supabase) and Local (Hive/Isar) data providers.
    *   **Models**: Data transfer objects (DTOs) and serialization logic.
2.  **Domain Layer (Core)**:
    *   **Entities**: Pure business objects.
    *   **Use Cases**: Specific business logic operations (e.g., `MakeTransfer`, `JoinSession`).
    *   **Repositories (Interfaces)**: Abstract definitions for data operations.
3.  **Presentation Layer**:
    *   **BLoC (Business Logic Component)**: State management for predictable, reactive UI updates.
    *   **UI (Widgets)**: Reusable components following the "Tactical Kineticism" design system.

## 🛠️ Technology Stack

-   **State Management**: `flutter_bloc`
-   **Dependency Injection**: `get_it`
-   **Routing**: `go_router`
-   **Local Storage**: `isar` (High-performance NoSQL database for caching logs and local state)
-   **Service Layer**: (Likely Firebase for real-time session synchronization)
-   **Linting**: `flutter_lints` with custom strict rules.

## 🎨 Design System Implementation

The "Neon Ledger" design system is implemented using **Theme Extensions**:
-   **Tokens**: Custom color and spacing tokens are defined in a `AppDesignSystem` class.
-   **Components**: Atomic design approach, starting from `NeoButton`, `NeoInput`, and `NeoSurface`.

## 📦 Modularization Strategy

The project is structured by feature to isolate dependencies:
-   `features/auth/`: Splash and Onboarding.
-   `features/session/`: Create/Join/Manage game sessions.
-   `features/wallet/`: Dashboard, Payment Pad, and Detailed Ledger.
-   `core/`: Transversal utilities, design system, and error handling.
