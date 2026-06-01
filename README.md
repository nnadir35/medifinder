# MediFinder — Provider Search Case Study

MediFinder is a global healthcare discovery platform that connects patients with verified medical specialists worldwide. This case study implements a 3-screen provider search flow — list, filter, and detail — demonstrating Clean Architecture, Bloc state management, and Material 3 theming in Flutter with no backend dependency.

---

## Architecture

MediFinder uses **Clean Architecture** with three distinct layers:

- **Domain** — pure Dart entities (`ProviderEntity`, `FilterState`). No Flutter imports. No knowledge of data sources or UI. This is the stable core that survives backend swaps unchanged.
- **Data** — `ProviderModel` extends `ProviderEntity` and adds `fromMap`/`toMap` for future-proofing. All data is currently mocked via `mockProviders`.
- **Presentation** — Bloc drives all state transitions. Screens and widgets are purely reactive and never mutate state directly.

**Why Clean Architecture?** Separation of concerns means each layer has a single reason to change. Swapping the mock data for a real REST API requires touching only the data layer. UI refactors never cascade into business logic. Each layer can be tested in isolation.

**Why Bloc over Cubit / Provider / Riverpod?**

| Concern | Bloc advantage |
|---|---|
| Traceability | Every user action is an explicit `sealed class` event — you can log, replay, or test each one independently |
| Exhaustive states | `sealed class ProviderState` forces exhaustive `switch` expressions at every call site — the Dart 3 compiler catches missing cases |
| Unit testing | `bloc_test`'s `blocTest()` lets you seed any state, dispatch a single event, and assert the exact emitted states — no widget tree needed |
| Scalability | Adding a feature (e.g. bookmarks) means adding one event subclass and one state subclass without touching existing handlers |

---

## State Management

**Event → Bloc → State flow:**

```
User action (e.g. selects a country filter)
    │
    ▼
ProviderFilterApplied(FilterState(...))   ← dispatched from UI
    │
    ▼
ProviderBloc._applyFilters(all, query, filter)
    │
    ▼
emit(ProviderLoaded(filteredProviders: [...], activeFilter: ...))
    │
    ▼
BlocBuilder rebuilds ListView + active filter chip row
```

**Why `FilterState` is a plain data class inside `ProviderLoaded` (not a separate Bloc):**

Filters have no async side effects — they are derived purely from user interaction and applied synchronously against the already-loaded provider list. Embedding `FilterState` inside `ProviderLoaded` means:

- There is no valid state where a filter exists but providers haven't loaded — the types make this impossible.
- A single `BlocBuilder` rebuilds the list and the filter badge atomically, with no Bloc-to-Bloc communication needed.
- `FilterState.isEmpty` is a single source of truth for showing/hiding active filter UI.

---

## Folder Structure

```
lib/
├── core/
│   ├── error/
│   │   ├── exceptions.dart           # ServerException, NetworkException, …
│   │   └── failures.dart             # Failure subclasses (Equatable)
│   ├── router/
│   │   └── app_router.dart           # GoRouter — 2 routes
│   ├── theme/
│   │   ├── app_theme.dart            # AppTheme.light / .dark (Material 3)
│   │   └── app_theme_extension.dart  # Spacing/radius tokens + BuildContext ext
│   └── utils/
│       ├── constants.dart            # AppConstants (SharedPrefs keys, pagination)
│       └── extensions.dart           # ContextX, StringX, NullableStringX
│
├── features/
│   └── providers/
│       ├── data/
│       │   ├── mock/
│       │   │   └── mock_providers.dart    # 16 ProviderModel entries
│       │   └── models/
│       │       └── provider_model.dart    # fromMap / toMap
│       ├── domain/
│       │   └── entities/
│       │       ├── provider_entity.dart   # Core entity (Equatable)
│       │       └── filter_state.dart      # Filter data class (Equatable)
│       └── presentation/
│           ├── bloc/
│           │   ├── provider_bloc.dart
│           │   ├── provider_event.dart    # sealed class
│           │   └── provider_state.dart    # sealed class
│           ├── screens/
│           │   ├── provider_list_screen.dart
│           │   └── provider_detail_screen.dart
│           └── widgets/
│               ├── provider_avatar.dart   # CachedNetworkImage + initials fallback
│               ├── rating_stars.dart      # filled / half / empty stars
│               ├── provider_card.dart     # Hero + card layout
│               ├── filter_chip_group.dart # Reusable chip group
│               ├── loading_shimmer.dart   # Theme-aware animated shimmer
│               ├── empty_state.dart       # No results UI
│               └── error_state.dart       # Error + retry UI
│
└── main.dart   # MediFinderApp — BlocProvider + GoRouter + ValueNotifier<ThemeMode>
```

---

## How to Run

```bash
flutter pub get
flutter run
```

Requires Flutter 3.x with Dart 3.x (tested on Flutter 3.29.2).

---

## Key Technical Decisions

- **GoRouter** — Declarative routing with type-safe `extra` for passing `ProviderEntity` to the detail screen without re-fetching. Supports deep linking and web out of the box.
- **Hero animation** — `provider.id` is used as the Hero tag on `ProviderAvatar` in both `ProviderCard` and `ProviderDetailScreen`, giving a natural shared-element transition with zero extra code.
- **Null safety** — All nullable fields (`phone`, `website`, `bio`, `imageUrl`) are `String?`. Entire UI sections (contact, bio) are hidden when null rather than showing empty containers.
- **Theme token system** — `AppThemeExtension` spacing and radius tokens are consumed via `context.appTheme` throughout all feature code. Zero hardcoded padding values exist in the feature layer.
- **Sealed classes** — Both `ProviderEvent` and `ProviderState` are `sealed`. Every `switch` on `ProviderState` in the build methods is exhaustive — the Dart 3 compiler enforces completeness and will error if a new subclass is added without handling it everywhere.
