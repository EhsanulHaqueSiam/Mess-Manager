# Architecture

**Analysis Date:** 2026-03-25

## Pattern Overview

**Overall:** Feature-modular offline-first architecture with Riverpod 3.x state management

**Key Characteristics:**
- 18 self-contained feature modules under `lib/features/`
- Offline-first data layer: Isar (local) + Cloud Firestore (remote) with mock fallback
- Riverpod `Notifier` / `AsyncNotifier` pattern (NOT legacy `StateNotifier`)
- Optimistic UI updates with rollback on failure
- go_router with auth-aware redirects and `ShellRoute` for tab navigation
- `@freezed sealed class` models with code generation (Freezed 3.x + `build_runner`)
- Role-based access control (7 roles) enforced via `RoleGate` widget and permission providers
- Demo mode that bypasses all Firebase, using `MockDataService` for local-only operation

## Layers

**Presentation Layer (Screens + Widgets):**
- Purpose: UI rendering, user interaction, animation
- Location: `lib/features/{name}/screens/` and `lib/features/{name}/widgets/`
- Contains: `ConsumerWidget` / `ConsumerStatefulWidget` screens, bottom sheets, cards, tabs
- Depends on: Providers (via `ref.watch` / `ref.read`), theme system, core widgets
- Used by: Router (via `GoRoute` builders)

**State Layer (Providers):**
- Purpose: Business logic, state management, derived computations
- Location: `lib/core/providers/` (global) and `lib/features/{name}/providers/` (feature-scoped)
- Contains: `NotifierProvider`, `Provider`, `AsyncNotifierProvider` declarations
- Depends on: Services, database, models
- Used by: Screens and widgets via Riverpod `ref`

**Service Layer:**
- Purpose: External communication, business operations, platform integration
- Location: `lib/core/services/`
- Contains: Firebase wrappers, Firestore operations, FCM, NLP, OCR, haptics, location, export, backup
- Depends on: Firebase SDK, Isar, Dio, platform APIs
- Used by: Providers (never directly by screens)

**Data Layer (Local + Remote):**
- Purpose: Persistence and data sync
- Location: `lib/core/database/` (Isar) and `lib/core/services/firestore_service.dart` (Firestore)
- Contains: `IsarService` (static methods), Isar collection definitions, `FirestoreService` (static methods)
- Depends on: Isar Plus, Cloud Firestore SDK
- Used by: Services and providers

**Model Layer:**
- Purpose: Type-safe data structures with serialization
- Location: `lib/core/models/`
- Contains: Freezed sealed classes with `.freezed.dart` + `.g.dart` generated files
- Depends on: `freezed_annotation`, `json_annotation`
- Used by: Every other layer

**API Layer:**
- Purpose: Type-safe HTTP clients via Retrofit
- Location: `lib/core/api/`
- Contains: `ApiClient` (REST), `AladhanApi` (prayer times), `DescoApi` (electricity), `DioClient` (Dio config)
- Depends on: Dio, Retrofit
- Used by: Services

## Data Flow

**Offline-First Read (Primary Pattern):**

1. Provider calls service (e.g., `MemberService.getMembers()`)
2. Service checks Isar local cache first (`IsarService.getAllMembers()`)
3. If local data exists, return immediately
4. Fire-and-forget background Firestore sync (`_fetchAndSync().ignore()`)
5. On Firestore response, update Isar cache, then update provider state
6. If Firestore fails, fall back to local data; if local empty too, use `MockDataService` in debug

**Optimistic Write Pattern:**

1. User action triggers provider method (e.g., `addMember(member)`)
2. Provider updates state immediately (optimistic): `state = [...state, member]`
3. If `DemoMode.isEnabled`, skip remote sync entirely
4. Provider calls service to persist to Firestore + Isar
5. On failure, provider reverts state to pre-mutation snapshot and rethrows

**Auth Flow:**

1. App starts -> `AuthNotifier.build()` schedules `_checkAuth()` via `Future.microtask()`
2. `_checkAuth()` reads `current_user` from Isar settings store
3. If found: sets `AuthStatus.authenticated` + loads messes from Isar settings
4. If not found: sets `AuthStatus.unauthenticated`
5. `GoRouter.redirect` checks `authProvider` on every navigation:
   - Unauthenticated + protected route -> redirect to `/login`
   - `pendingApproval` + not on pending screen -> redirect to `/pending-approval`
   - Authenticated + on login/signup -> redirect to `/` (dashboard)

**State Management:**
- Global state in `lib/core/providers/`: members, roles, sync time, demo mode, search, theme, smart suggestions
- Feature state in `lib/features/{name}/providers/`: meals, bazar, balance, money, settlement, duties, ramadan, etc.
- Derived providers compute values from base providers (e.g., `totalMealsProvider` derives from `mealsProvider`)
- Provider dependency graph: auth -> members -> roles -> permission checks

## Key Abstractions

**Freezed Models:**
- Purpose: Immutable, serializable domain entities with `copyWith`, `==`, `hashCode`
- Examples: `lib/core/models/member.dart`, `lib/core/models/meal.dart`, `lib/core/models/auth_user.dart`
- Pattern: `@freezed sealed class Foo with _$Foo { const factory Foo(...) = _Foo; factory Foo.fromJson(...) => _$FooFromJson(...); }`
- 13 models: Member, Meal, BazarEntry, MoneyTransaction, Duty (schedule/assignment/debt), UnifiedEntry, Settlement, Ramadan (season/meal/bazar/payment), AuthUser, Mess, AppNotification, MessInfo, BazarListItem, DefaultMealSchedule, VacationPeriod, FixedExpense, FoodPreference, DailyMealSummary

**Isar Collections (Bridge Layer):**
- Purpose: Isar-compatible schema that bridges Freezed models to local DB
- Examples: `lib/core/database/collections/member_collection.dart`, `lib/core/database/collections/meal_collection.dart`
- Pattern: `@collection class FooCollection { late int id; ... Member toModel() {...} static MemberCollection fromModel(Member m) {...} }`
- Each collection has `toModel()` and `fromModel()` converters. Enums stored as int indices, complex objects as JSON strings.

**IsarService (Central DB Facade):**
- Purpose: Single static class exposing all local CRUD via Isar
- Location: `lib/core/database/isar_service.dart`
- Pattern: All methods are `static`, check `isAvailable` (returns empty/null on web), use `instance.write()` for mutations
- Also doubles as key-value store via `SettingsCollection` (saveSetting/getSetting/removeSetting)

**Notifier Pattern (Riverpod 3.x):**
- Purpose: Stateful providers with methods for mutations
- Examples: `MembersNotifier`, `MealsNotifier`, `AuthNotifier`, `MoneyNotifier`
- Pattern: `class FooNotifier extends Notifier<T> { @override T build() { ... } void mutate(...) { state = ...; } }`
- Access other providers via `ref.watch()` / `ref.read()` inside notifier methods

**RoleGate Widget:**
- Purpose: Declarative role-based UI access control
- Location: `lib/core/widgets/role_gate.dart`
- Pattern: `RoleGate.admin(child: ...)`, `RoleGate.meal(child: ...)`, `RoleGate(permission: canAddBazarProvider, child: ...)`
- Shows child if permission granted, `SizedBox.shrink()` if denied, or disabled overlay if `showDisabled: true`

**AppSheet (Bottom Sheet System):**
- Purpose: Consistent modal bottom sheet wrapper
- Location: `lib/core/widgets/app_sheet.dart`
- Pattern: `showAppSheet(context: context, title: 'Add Meal', child: ...)`, `showConfirmSheet(...)`, `showActionSheet(...)`
- All feature sheets (add_meal_sheet, add_bazar_sheet, etc.) use this as their outer container

## Entry Points

**App Entry:**
- Location: `lib/main.dart`
- Triggers: App launch
- Responsibilities: Flutter binding init, high refresh rate mode, Isar init, Firebase init, NLP keyword loading, FCM init, `ProviderScope` wrapping, theme setup via `AdaptiveTheme` + `DynamicColorBuilder` + `ThemeProvider`

**Router:**
- Location: `lib/core/router/app_router.dart`
- Triggers: All navigation
- Responsibilities: Defines all routes, auth redirect logic, `ShellRoute` for 5 main tabs

**Firebase Init:**
- Location: `lib/core/services/firebase_service.dart`
- Triggers: Called from `main()` during startup
- Responsibilities: Firebase Core, App Check, Crashlytics, Analytics, Performance, Remote Config init

## Router Architecture

**Shell Route (5 Main Tabs):**
- Dashboard (`/`), Bazar (`/bazar`), Meals (`/meals`), Balance (`/balance`), Settings (`/settings`)
- Wrapped in `MainShell` (`lib/shared/widgets/main_shell.dart`) -- glassmorphic floating bottom nav bar
- Uses `NoTransitionPage` for instant tab switches

**Auth Routes (Outside Shell):**
- `/login`, `/signup`, `/mess-selection`, `/profile`, `/pending-approval`, `/admin/approvals`

**Sub-Module Routes (Outside Shell, Back Navigation):**
- `/analytics`, `/money`, `/members`, `/vacation`, `/desco`, `/ramadan`, `/ramadan-calendar`
- `/settlement`, `/duties`, `/fixed-expenses`, `/info`, `/notification-settings`, `/chatbot`
- `/notifications`, `/month-summary`

**Route Constants:**
- All paths defined in `AppRoutes` class in `lib/core/router/app_router.dart`
- Use `context.go(AppRoutes.bazar)` for tab navigation
- Use `context.push(AppRoutes.analytics)` for sub-module navigation

## Error Handling

**Strategy:** Multi-layer with graceful degradation

**Patterns:**
- `FlutterError.onError` -> Crashlytics in production, `debugPrint` in debug
- `runZonedGuarded` catches uncaught async errors -> Crashlytics in production
- Service layer: try/catch with `FirebaseService.logError()` and rethrow
- Provider layer: optimistic mutations wrapped in try/catch with state rollback on failure
- Data layer: offline fallback chain (Isar -> Firestore -> MockDataService)
- Router: `errorPageBuilder` renders `ErrorScreen` widget
- Web platform: Isar operations silently return empty/null via `isAvailable` guard

## Cross-Cutting Concerns

**Logging:**
- `debugPrint()` used throughout for development logging
- `FirebaseService.log()` for production crash report breadcrumbs
- `FirebaseService.logEvent()` for analytics events
- No structured logging framework

**Validation:**
- Form validation in bottom sheet widgets (inline validation logic)
- Role-based permission checks via `RolePermissions` class and provider-level guards
- `RoleGate` widget for UI-level enforcement

**Authentication:**
- `AuthNotifier` in `lib/features/auth/providers/auth_provider.dart`
- Auth state persisted in Isar settings store (key: `current_user`)
- Three states: `authenticated`, `unauthenticated`, `pendingApproval`
- Sign-up creates a pending approval request; admin must approve before full access
- `isAuthenticatedProvider`, `currentUserProvider`, `currentMessProvider` expose auth state

**Demo Mode:**
- `DemoMode` class in `lib/core/providers/demo_mode_provider.dart`
- Global static flag (`DemoMode.isEnabled`) -- only activatable in debug builds
- When enabled: all providers use `MockDataService.mockMembers` etc., skip Firebase sync
- Every provider mutation method checks `if (DemoMode.isEnabled) return;` before remote ops

**Theming:**
- `AppTheme` in `lib/core/theme/app_theme.dart` -- FlexColorScheme base with custom overrides
- Material You support via `DynamicColorBuilder` for Android 12+
- User-selectable seed color via `themeColorProvider` persisted in Isar
- Context extensions: `context.textPrimary`, `context.cardColor`, `context.isDark`, etc.
- Design tokens: `AppColors`, `AppSpacing`, `AppTypography`

**Haptics:**
- `HapticService` in `lib/core/services/haptic_service.dart`
- Called on navigation, button presses, and significant interactions

---

*Architecture analysis: 2026-03-25*
