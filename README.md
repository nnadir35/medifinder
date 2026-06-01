# MediFinder

A global healthcare provider discovery platform built with Flutter. MediFinder helps patients find and connect with verified medical specialists worldwide — filtering by country, city, and specialty — with a clean, accessible interface that works in both light and dark mode.

---

## Architecture

MediFinder follows **Clean Architecture** with three layers:

```
Presentation  →  Domain  →  Data
(Bloc, Screens, Widgets)   (Entities)   (Models, Mock)
```

- **Domain** — pure Dart entities (`ProviderEntity`, `FilterState`). No Flutter imports. No dependencies on data or presentation.
- **Data** — `ProviderModel` extends `ProviderEntity` and adds `fromMap`/`toMap`. Mock data lives here and is the only data source.
- **Presentation** — Bloc drives all state. Screens and widgets are purely reactive.

### Why Bloc over Cubit / Provider / Riverpod?

| Concern | Decision |
|---|---|
| Explicit event types | `sealed class ProviderEvent` makes every user action traceable and testable |
| State transitions | `sealed class ProviderState` exhaustively handled in `switch` — no runtime surprises |
| Scalability | Adding a new feature (e.g. bookmarks) means adding one event + one state subclass, not changing existing code |
| Separation | UI never mutates state directly — it dispatches events |

### Why `FilterState` is a data class inside `ProviderLoaded` (not a separate Bloc state)

Filters are not a lifecycle phase — they are data carried by the loaded state. Embedding `FilterState` inside `ProviderLoaded` means:
- A single `BlocBuilder` rebuilds the list and the filter badge atomically.
- No risk of a filter state existing while providers haven't loaded yet.
- `FilterState.isEmpty` gives the UI a single truth for showing/hiding active filter UI.

---

## State Management Flow

```
User action
    │
    ▼
ProviderEvent  (e.g. ProviderFilterApplied)
    │
    ▼
ProviderBloc._applyFilters(all, query, filter)
    │
    ▼
ProviderLoaded(filteredProviders: [...], activeFilter: ...)
    │
    ▼
BlocBuilder rebuilds ListView / filter chips
```

---

## Folder Structure

```
lib/
├── core/
│   ├── error/
│   │   ├── exceptions.dart        # ServerException, NetworkException, …
│   │   └── failures.dart          # Failure subclasses (Equatable)
│   ├── router/
│   │   └── app_router.dart        # GoRouter — 2 routes
│   ├── theme/
│   │   ├── app_theme.dart         # AppTheme.light / .dark (Material 3)
│   │   └── app_theme_extension.dart  # Spacing/radius tokens + BuildContext ext
│   └── utils/
│       ├── constants.dart         # AppConstants (SharedPrefs keys, pagination)
│       └── extensions.dart        # ContextX, StringX, NullableStringX
│
├── features/
│   └── providers/
│       ├── data/
│       │   ├── mock/
│       │   │   └── mock_providers.dart   # 16 ProviderModel entries
│       │   └── models/
│       │       └── provider_model.dart   # fromMap / toMap
│       ├── domain/
│       │   └── entities/
│       │       ├── provider_entity.dart  # Core entity (Equatable)
│       │       └── filter_state.dart     # Filter data class (Equatable)
│       └── presentation/
│           ├── bloc/
│           │   ├── provider_bloc.dart
│           │   ├── provider_event.dart   # sealed class
│           │   └── provider_state.dart   # sealed class
│           ├── screens/
│           │   ├── provider_list_screen.dart
│           │   └── provider_detail_screen.dart
│           └── widgets/
│               ├── provider_avatar.dart   # CachedNetworkImage + initials fallback
│               ├── rating_stars.dart      # filled / half / empty stars
│               ├── provider_card.dart     # Hero + card layout
│               ├── filter_chip_group.dart # Reusable chip group
│               ├── loading_shimmer.dart   # Animated shimmer placeholder
│               ├── empty_state.dart       # No results UI
│               └── error_state.dart       # Error + retry UI
│
└── main.dart   # MediFinderApp — BlocProvider + GoRouter + theme notifier
```

---

## How to Run

```bash
# Install dependencies
flutter pub get

# Run on a connected device or simulator
flutter run

# Analyse for issues
flutter analyze
```

Requires Flutter 3.x with Dart 3.x (tested on Flutter 3.29.2).

---

## Key Technical Decisions

| Decision | Rationale |
|---|---|
| **GoRouter** | Declarative routing with type-safe `extra` for passing `ProviderEntity` to detail screen; supports deep linking and web |
| **Hero animation** | `provider.id` used as Hero tag on `ProviderAvatar` in both list card and detail header — gives a natural transition with zero extra code |
| **Null safety throughout** | All nullable fields (`imageUrl`, `phone`, `website`, `bio`) are `String?`; every callsite guards with `if (x != null)` or null-aware operators |
| **Spacing tokens** | `context.appTheme.spacingMd` etc. from `AppThemeExtension` — no hardcoded `padding` or `SizedBox` with magic numbers |
| **Sealed classes** | Both `ProviderEvent` and `ProviderState` are `sealed` — the Dart compiler enforces exhaustive handling in every `switch`, eliminating missing-case bugs |
| **`ValueNotifier<ThemeMode>`** | Simple global notifier for theme toggling without a full state management solution for a single bool; persisted to `SharedPreferences` |
| **Mock-first data layer** | `ProviderModel.fromMap`/`toMap` future-proofs the data layer — swapping in a real API requires only adding a repository without touching domain or presentation |
