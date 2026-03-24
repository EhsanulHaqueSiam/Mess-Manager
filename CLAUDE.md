# CLAUDE.md

## Project

**Mess Manager** -- Flutter app for shared living expense/meal management. Currency: BDT (৳).

- **Dart:** ^3.11.0 | **Flutter:** 3.41+ | **Platforms:** Android, iOS, Web, Linux

## Commands

```bash
flutter pub get && dart run build_runner build --delete-conflicting-outputs  # After model changes
flutter run -d <device_id>    # Run (chrome, linux, or device ID)
flutter analyze               # Lint
make test                     # All tests
```

## Architecture

**State:** Riverpod 3.x -- `Notifier`/`AsyncNotifier` pattern. All screens are `ConsumerWidget`/`ConsumerStatefulWidget`. Optimistic UI updates.

**Data:** Offline-first. Isar Plus (local, disabled on web) → Firestore (remote) → MockDataService (debug fallback). Demo mode via `DemoMode.isEnabled`.

**Routing:** go_router. `ShellRoute` wraps 5 tabs. Auth-aware redirects. Routes in `AppRoutes` constants.

**Models:** Freezed 3.x `@freezed sealed class` → `.freezed.dart` + `.g.dart`. Retrofit for API clients. Run `build_runner` after any model/API change.

**Features:** 18 modules at `lib/features/{name}/` each with `screens/`, `providers/`, `widgets/`.

**Roles:** 7 levels (`superAdmin` → `guest`). Enforced via `RoleGate` widget and permission providers.

## Key Files

| File | Purpose |
|------|---------|
| `lib/main.dart` | Entry, Firebase init, FPS setup, provider scope |
| `lib/core/theme/app_theme.dart` | Colors, spacing, typography, `glassTile()` helper |
| `lib/core/widgets/app_components.dart` | `AppCard`, `GlassCard`, `AppSheet`, `AppInput`, `AppBadge`, `AppMemberAvatar` |
| `lib/core/database/isar_service.dart` | All local CRUD |
| `lib/shared/widgets/main_shell.dart` | Floating glass navigation bar |

## Design System

Teal-based "Cosmic Bioluminescence" aesthetic:

- **Background:** `#0A0F14` (deep space) | **Cards:** `AppSpacing.glassTile()` with refraction highlight
- **Accent:** Cyan `#22D3EE` (primary), Mint `#34D399` (secondary) -- no purple/blue AI gradients
- **Text:** White alpha levels -- primary (0.9), secondary (0.5), muted (0.3)
- **Fonts:** Poppins (headings), Inter (body), JetBrains Mono (numbers)
- **Components:** `radiusMd` buttons (not pills), `radiusXs` badges, squircle avatars
- **Section labels:** Sentence case with solid accent bar -- not ALL-CAPS
- **Animations:** `flutter_animate` with 200ms default duration. Staggered entry, press-scale on cards.
- **Nav:** Floating glass bar with `BackdropFilter`, custom `_NavItem` with animated scale
- **Sheets:** `AppSheet.show()` with `radiusXl` top corners, gradient handle, tinted shadow
- **FPS:** `FlutterDisplayMode` auto-selects highest refresh rate (120/165/240+ Hz)

## Android Build

- **Kotlin 2.2** with reflection-based plugin registration in `MainActivity.kt` (bypasses Java/Kotlin interop issue)
- **Gradle:** 4G heap, G1GC, parallel builds, caching enabled. Excludes `GeneratedPluginRegistrant.java` from javac.
- **Release:** R8 minification + proguard rules enabled

## Firebase

Config files are gitignored (generated from CI secrets):
- `lib/firebase_options.dart`, `android/app/google-services.json`, `ios/Runner/GoogleService-Info.plist`
- Services: Auth, Firestore, Messaging, Analytics, Crashlytics, Performance, Remote Config, App Check, AI (Gemini)

## Git

- **Main:** `main` | **Dev:** `dev`
- Commit messages: no Co-Authored-By lines
