# Codebase Structure

**Analysis Date:** 2026-03-25

## Directory Layout

```
area51_app/
├── lib/
│   ├── main.dart                  # App entry point, Firebase/Isar init, ProviderScope
│   ├── firebase_options.dart      # FlutterFire CLI generated (gitignored in CI)
│   ├── core/                      # Shared infrastructure, models, services, theme
│   │   ├── core.dart              # Barrel export for core module
│   │   ├── accessibility/         # Accessibility helpers
│   │   ├── api/                   # Retrofit API clients (Dio-based)
│   │   ├── constants/             # App constants (currently empty)
│   │   ├── database/              # Isar service + collection schemas
│   │   │   ├── isar_service.dart  # Central static DB facade
│   │   │   └── collections/       # Isar collection definitions (11 collections)
│   │   ├── models/                # Freezed data models (13 model files + generated)
│   │   ├── providers/             # Global Riverpod providers (9 providers)
│   │   ├── router/                # go_router configuration
│   │   │   └── app_router.dart    # All routes + auth redirect logic
│   │   ├── services/              # Business services (22 service files)
│   │   ├── testing/               # Test utilities (screen registry)
│   │   ├── theme/                 # Design system
│   │   │   └── app_theme.dart     # AppColors, AppSpacing, AppTypography, ThemeData
│   │   ├── utils/                 # Utility functions (currently empty)
│   │   └── widgets/               # Reusable core widgets (11 widget files)
│   ├── features/                  # 18 feature modules
│   │   ├── analytics/             # Charts, spending trends, price analysis
│   │   ├── auth/                  # Login, signup, mess selection, profile, approval
│   │   ├── balance/               # Member balance overview
│   │   ├── bazar/                 # Grocery shopping entries, budget, shopping list
│   │   ├── chatbot/               # AI chatbot (Firebase AI Logic / Gemini)
│   │   ├── dashboard/             # Home screen with summary cards
│   │   ├── desco/                 # DESCO electricity bill tracking
│   │   ├── duties/                # Duty roster scheduling and tracking
│   │   ├── info/                  # Mess information display/edit
│   │   ├── meals/                 # Meal tracking, schedules, bulk entry
│   │   ├── members/               # Member management (no providers dir)
│   │   ├── money/                 # Money transactions (deposits, withdrawals)
│   │   ├── notifications/         # Push notifications, meal reminders, history
│   │   ├── ramadan/               # Ramadan-specific meal/bazar tracking
│   │   ├── settings/              # App settings, theme color picker
│   │   ├── settlement/            # Monthly settlement, audit, penalties, month lock
│   │   ├── unified/               # Unified timeline/entry view
│   │   └── vacation/              # Vacation tracking, fixed expenses, bulk cancel
│   └── shared/                    # Cross-feature shared widgets
│       └── widgets/               # MainShell, voice entry, receipt scan, party splitter
├── test/                          # Test suite
│   ├── helpers/                   # Mock providers, test wrappers
│   ├── unit/                      # Unit tests
│   ├── widget/                    # Widget tests
│   ├── smoke/                     # Smoke tests
│   ├── integration/               # Integration tests
│   └── widget_test.dart           # Default Flutter test
├── integration_test/              # Full integration tests
│   └── app_test.dart              # App-level integration test
├── assets/
│   └── screenshots/               # App screenshots
├── tool/                          # Build/dev tooling
├── android/                       # Android platform
├── ios/                           # iOS platform
├── linux/                         # Linux desktop platform
├── web/                           # Web platform
├── pubspec.yaml                   # Dependencies and Flutter config
├── Makefile                       # Build/test commands
├── analysis_options.yaml          # Dart linter rules
├── firestore.rules                # Firestore security rules
├── firestore.indexes.json         # Firestore index config
├── storage.rules                  # Firebase Storage security rules
├── firebase.json                  # Firebase project config
├── serve_web.py                   # Dev server with COOP/COEP headers
├── CLAUDE.md                      # AI assistant project instructions
└── README.md                      # Project documentation
```

## Directory Purposes

**`lib/core/`:**
- Purpose: Shared infrastructure used by all features
- Contains: Models, services, providers, database, theme, router, widgets, API clients
- Key files: `core.dart` (barrel export), `database/isar_service.dart`, `theme/app_theme.dart`, `router/app_router.dart`

**`lib/core/models/`:**
- Purpose: All Freezed data models (domain entities)
- Contains: `.dart` source + `.freezed.dart` + `.g.dart` generated files
- Key files: `member.dart`, `meal.dart`, `bazar_entry.dart`, `money_transaction.dart`, `auth_user.dart`, `settlement.dart`, `duty.dart`, `ramadan.dart`, `unified_entry.dart`, `app_notification.dart`, `mess_info.dart`
- Pattern: Each model has enums + `@freezed sealed class` + `fromJson` factory

**`lib/core/database/`:**
- Purpose: Local persistence via Isar Plus
- Contains: `isar_service.dart` (facade) + `collections/` (11 Isar collection schema files + generated)
- Key files: `isar_service.dart` (897 lines, all static CRUD methods)
- Pattern: Collection files have `toModel()` / `fromModel()` converters bridging Isar schemas to Freezed models

**`lib/core/providers/`:**
- Purpose: Global state providers shared across features
- Contains: 9 provider files
- Key files: `members_provider.dart` (member list + current member), `role_provider.dart` (RBAC permissions), `demo_mode_provider.dart`, `sync_provider.dart`, `search_provider.dart`, `smart_suggestions_provider.dart`, `home_widget_provider.dart`, `test_user_provider.dart`, `theme_provider.dart`

**`lib/core/services/`:**
- Purpose: Business logic services, external API integration, platform services
- Contains: 22 service files (all static class methods)
- Key files: `firebase_service.dart` (Firebase init + analytics + crashlytics + remote config), `firestore_service.dart` (Firestore CRUD for users/messes/meals/bazar), `member_service.dart` (offline-first member fetching), `auth_service.dart` (Firebase Auth wrapper), `mock_data_service.dart` (seed data for demo mode), `chatbot_service.dart` (Gemini AI), `desco_service.dart` (electricity bill), `nlp_categorizer.dart` (expense categorization), `receipt_ocr_service.dart`, `voice_entry_service.dart`, `haptic_service.dart`, `export_service.dart`, `backup_service.dart`, `fcm_service.dart`, `local_notification_service.dart`, `prayer_times_service.dart`, `location_service.dart`, `storage_service.dart`, `toast_service.dart`, `analytics_events_service.dart`, `auto_month_close_service.dart`, `quick_actions_service.dart`

**`lib/core/api/`:**
- Purpose: Type-safe HTTP clients via Retrofit + Dio
- Contains: `api_client.dart` (REST CRUD), `aladhan_api.dart` (prayer times), `desco_api.dart` (electricity), `dio_client.dart` (Dio instance configuration)
- Pattern: `@RestApi()` abstract classes with `.g.dart` generated implementations

**`lib/core/widgets/`:**
- Purpose: Reusable UI components used across features
- Contains: 11 widget files
- Key files: `app_components.dart` (GlassCard, AppPrimaryButton, AppCard, AppChip, SectionLabel, StatCard -- 30KB), `app_sheet.dart` (bottom sheet wrapper system), `role_gate.dart` (RBAC widget), `form_widgets.dart` (form inputs), `animated_widgets.dart` (animation helpers), `skeleton_widgets.dart` (loading skeletons), `speed_dial_fab.dart`, `app_breadcrumb.dart`, `error_screen.dart`, `hook_base.dart`, `widgets.dart` (barrel export)

**`lib/core/theme/`:**
- Purpose: Design system tokens and ThemeData builders
- Contains: `app_theme.dart` (803 lines)
- Exports: `AppColors` (colors + gradients), `AppSpacing` (4px grid + border radius + shadows + glassTile), `AppTypography` (Poppins/Inter/JetBrains Mono), `AppTheme` (darkTheme, lightTheme, buildDarkTheme, buildLightTheme), `AppColorsX` context extension

**`lib/features/{name}/`:**
- Purpose: Self-contained feature modules
- Contains: `screens/`, `providers/` (optional), `widgets/` (optional) subdirectories
- Pattern: Each feature follows `screens/ + providers/ + widgets/` structure. Some features lack providers (members, dashboard) or widgets (auth, balance, settings, chatbot, desco, duties, notifications, ramadan, vacation)

**`lib/shared/widgets/`:**
- Purpose: Cross-feature widgets shared between multiple features
- Contains: 10 widget files
- Key files: `main_shell.dart` (floating glass nav bar for ShellRoute), `micro_interactions.dart`, `party_splitter_sheet.dart`, `receipt_scan_widget.dart`, `search_sheet.dart`, `smart_suggestion_card.dart`, `test_mode_switcher.dart`, `voice_entry_sheet.dart`, `voice_entry_widget.dart`, `widgets.dart` (barrel export)

**`test/`:**
- Purpose: Test suite organized by test type
- Contains: `helpers/` (mock providers, test wrappers), `unit/`, `widget/`, `smoke/`, `integration/`

## Key File Locations

**Entry Points:**
- `lib/main.dart`: App bootstrap, init sequence, root widget
- `lib/core/router/app_router.dart`: All route definitions and auth redirects

**Configuration:**
- `pubspec.yaml`: Dependencies, Flutter settings, assets
- `analysis_options.yaml`: Dart linter configuration
- `Makefile`: Build, test, and dev commands
- `firestore.rules`: Firestore security rules
- `storage.rules`: Firebase Storage security rules
- `firebase.json`: Firebase project configuration
- `serve_web.py`: Web dev server with required COOP/COEP headers

**Core Logic:**
- `lib/core/database/isar_service.dart`: All local CRUD operations (897 lines)
- `lib/core/services/firestore_service.dart`: All Firestore operations
- `lib/core/services/firebase_service.dart`: Firebase initialization and service wrappers
- `lib/core/providers/members_provider.dart`: Member state with offline-first loading
- `lib/core/providers/role_provider.dart`: RBAC permission definitions and providers
- `lib/features/auth/providers/auth_provider.dart`: Authentication state machine (435 lines)

**Design System:**
- `lib/core/theme/app_theme.dart`: All design tokens (AppColors, AppSpacing, AppTypography)
- `lib/core/widgets/app_components.dart`: Primary UI components (GlassCard, buttons, cards)
- `lib/core/widgets/app_sheet.dart`: Bottom sheet system

**Testing:**
- `test/helpers/mock_providers.dart`: Riverpod mock overrides for testing
- `test/helpers/test_app_wrapper.dart`: ProviderScope wrapper for widget tests
- `integration_test/app_test.dart`: Full app integration test

## Naming Conventions

**Files:**
- `snake_case.dart` for all Dart files: `meals_provider.dart`, `bazar_screen.dart`
- Screens: `{feature}_screen.dart` (e.g., `dashboard_screen.dart`, `bazar_screen.dart`)
- Providers: `{entity}_provider.dart` (e.g., `meals_provider.dart`, `balance_provider.dart`)
- Widgets: `{descriptive_name}.dart` (e.g., `add_meal_sheet.dart`, `budget_card.dart`)
- Models: `{entity}.dart` (e.g., `member.dart`, `meal.dart`)
- Services: `{name}_service.dart` (e.g., `firebase_service.dart`, `haptic_service.dart`)
- Collections: `{entity}_collection.dart` (e.g., `member_collection.dart`)
- Generated: `{source}.freezed.dart`, `{source}.g.dart`

**Directories:**
- Feature modules: `lib/features/{feature_name}/` (snake_case, singular noun)
- Feature subdirs: `screens/`, `providers/`, `widgets/`

**Classes:**
- PascalCase: `MembersNotifier`, `BazarScreen`, `GlassCard`
- Providers: `final {name}Provider = NotifierProvider<...>(...)` or `final {name}Provider = Provider<...>((ref) => ...)`
- Models: `@freezed sealed class {Name} with _${Name}`

## Where to Add New Code

**New Feature Module:**
1. Create directory: `lib/features/{name}/`
2. Add subdirectories: `screens/`, `providers/`, `widgets/` as needed
3. Create screen: `lib/features/{name}/screens/{name}_screen.dart` (extend `ConsumerWidget`)
4. Create provider: `lib/features/{name}/providers/{name}_provider.dart` (extend `Notifier<T>`)
5. Add route in `lib/core/router/app_router.dart` -- add constant to `AppRoutes`, add `GoRoute`
6. If it needs local persistence: add Isar collection in `lib/core/database/collections/`, register schema in `IsarService.init()`, add CRUD methods to `IsarService`

**New Freezed Model:**
1. Create `lib/core/models/{name}.dart` with `@freezed sealed class` pattern
2. Add `part '{name}.freezed.dart';` and `part '{name}.g.dart';`
3. Run: `dart run build_runner build --delete-conflicting-outputs`
4. If needed for local storage: create matching `lib/core/database/collections/{name}_collection.dart`

**New Provider:**
- Global (shared across features): `lib/core/providers/{name}_provider.dart`
- Feature-scoped: `lib/features/{feature}/providers/{name}_provider.dart`
- Use `NotifierProvider<FooNotifier, T>` for stateful providers with methods
- Use `Provider<T>` for derived/computed values

**New Core Service:**
- Add to `lib/core/services/{name}_service.dart`
- Use static class methods pattern (consistent with existing services)
- Wire into providers, not screens directly

**New Reusable Widget:**
- Used by many features: `lib/core/widgets/{name}.dart`
- Used by 2-3 specific features: `lib/shared/widgets/{name}.dart`
- Feature-specific: `lib/features/{feature}/widgets/{name}.dart`

**New Bottom Sheet:**
- Create widget file: `lib/features/{feature}/widgets/{name}_sheet.dart`
- Use `showAppSheet()` from `lib/core/widgets/app_sheet.dart` as the outer wrapper
- Follow existing pattern: `ConsumerWidget` with `ref.watch()` for providers

**New Isar Collection:**
1. Create `lib/core/database/collections/{name}_collection.dart`
2. Add `@collection` class with `toModel()` and `fromModel()` converters
3. Register the schema in `IsarService.init()` schemas list
4. Add CRUD static methods to `IsarService`
5. Run: `dart run build_runner build --delete-conflicting-outputs`

**New API Endpoint:**
- REST: Add method to `lib/core/api/api_client.dart` with Retrofit annotations
- External API: Create new `lib/core/api/{name}_api.dart` with `@RestApi()` class
- Run: `dart run build_runner build --delete-conflicting-outputs`

**New Test:**
- Unit: `test/unit/{feature_or_module}/{name}_test.dart`
- Widget: `test/widget/{feature}/{name}_test.dart`
- Smoke: `test/smoke/{name}_test.dart`
- Integration: `test/integration/{name}_test.dart`
- Use mock providers from `test/helpers/mock_providers.dart`
- Use `TestAppWrapper` from `test/helpers/test_app_wrapper.dart` for widget tests

## Special Directories

**`lib/core/database/collections/`:**
- Purpose: Isar collection schemas with generated code
- Generated: Yes (`.g.dart` files generated by `build_runner`)
- Committed: Yes (generated files are committed)

**`build/`:**
- Purpose: Flutter build output
- Generated: Yes
- Committed: No (gitignored)

**`lib/core/testing/`:**
- Purpose: Test support utilities (screen registry for testing discovery)
- Generated: No
- Committed: Yes

**`tool/`:**
- Purpose: Custom build/dev tooling scripts
- Generated: No
- Committed: Yes

**`assets/screenshots/`:**
- Purpose: App screenshots for documentation
- Generated: No
- Committed: Yes

## Feature Module Details

| Feature | Screens | Providers | Widgets | Description |
|---------|---------|-----------|---------|-------------|
| analytics | 1 (35KB) | 2 | 1 | Charts, spending trends, price analysis |
| auth | 6 | 2 | 0 | Login, signup, profile, mess selection, approvals |
| balance | 1 (25KB) | 1 | 0 | Member balance overview |
| bazar | 1 (54KB) | 4 | 3 | Grocery entries, budget, shopping list |
| chatbot | 1 (24KB) | 1 | 0 | AI assistant (Gemini) |
| dashboard | 1 (65KB) | 0 | 2 | Home screen, meal rate card, notification alerts |
| desco | 1 (46KB) | 1 | 0 | DESCO electricity bill tracking |
| duties | 1 (55KB) | 1 | 0 | Duty roster scheduling |
| info | 1 (21KB) | 1 | 1 | Mess information display/edit |
| meals | 1 (34KB) | 2 | 3 | Meal tracking, schedules, bulk entry |
| members | 1 (23KB) | 0 | 2 | Member management (uses core member providers) |
| money | 1 (40KB) | 1 | 1 | Money transactions |
| notifications | 2 | 2 | 0 | Push notifications, reminders, history, settings |
| ramadan | 2 | 1 | 0 | Ramadan meal/bazar/calendar tracking |
| settings | 1 (79KB) | 1 | 0 | App settings, theme picker (largest screen) |
| settlement | 2 | 4 | 2 | Monthly settlement, audit, penalties, month lock |
| unified | 0 | 1 | 1 | Unified timeline entry view (widget-only) |
| vacation | 3 | 2 | 0 | Vacation tracking, fixed expenses, bulk cancel |

---

*Structure analysis: 2026-03-25*
