# Technology Stack

**Analysis Date:** 2026-03-25

## Languages

**Primary:**
- Dart ^3.10.4 - All application code (`lib/`, `test/`)

**Secondary:**
- Kotlin 2.2.20 - Android native layer (`android/app/src/main/kotlin/`)
- Swift - iOS native layer (`ios/Runner/`)
- Kotlin DSL (Gradle) - Android build configuration (`android/build.gradle.kts`, `android/app/build.gradle.kts`, `android/settings.gradle.kts`)
- Python - Local web development server (`serve_web.py`)

## Runtime

**Environment:**
- Flutter 3.38.5 (pubspec SDK constraint: ^3.10.4)
- CI uses Flutter 3.41.5 (`.github/workflows/build.yml` env var)
- Java/JVM 17 (Android builds, set in `android/app/build.gradle.kts`)

**Package Manager:**
- Flutter pub (Dart's built-in package manager)
- Lockfile: `pubspec.lock` present
- CocoaPods for iOS (`ios/Podfile`, iOS deployment target 14.0)

## Frameworks

**Core:**
- Flutter 3.38.5 - Cross-platform UI framework (Android, iOS, Web, Linux)
- Riverpod 3.x (`flutter_riverpod: ^3.1.0`, `riverpod: ^3.1.0`, `hooks_riverpod: ^3.1.0`) - State management using modern `Notifier`/`AsyncNotifier` pattern
- go_router ^17.0.1 - Declarative routing with auth-aware redirects

**Data Layer:**
- Isar Plus ^1.2.0 (`isar_plus`, `isar_plus_flutter_libs`) - Local NoSQL database (disabled on web)
- Cloud Firestore ^6.1.1 - Remote NoSQL database (subcollections under `messes/{messId}/`)
- Dio ^5.4.0 - HTTP client with interceptors, retry logic, exponential backoff
- Retrofit ^4.9.2 - Type-safe REST API client code generation

**Code Generation:**
- build_runner ^2.10.4 - Code generation orchestrator
- Freezed ^3.2.3 + freezed_annotation ^3.1.0 - Immutable data classes (`@freezed sealed class` pattern)
- json_serializable ^6.8.0 + json_annotation ^4.9.0 - JSON serialization
- riverpod_generator ^4.0.0+1 + riverpod_annotation ^4.0.0 - Provider code generation
- retrofit_generator ^10.2.1 - Retrofit API client generation

**Testing:**
- flutter_test (SDK) - Widget and unit testing
- integration_test (SDK) - Integration/E2E testing
- mocktail ^1.0.4 - Mocking library (preferred over mockito)

**Build/Dev:**
- flutter_native_splash ^2.4.0 - Splash screen generation
- flutter_launcher_icons ^0.14.3 - App icon generation
- flutter_lints ^6.0.0 - Lint rules
- Makefile - Test automation (`make test`, `make test-unit`, `make build-runner`, etc.)

## Key Dependencies

**Critical (app breaks without these):**
- `firebase_core: ^4.3.0` - Firebase platform initialization
- `firebase_auth: ^6.1.3` - User authentication (email/password + Google Sign-In)
- `cloud_firestore: ^6.1.1` - Primary remote database
- `isar_plus: ^1.2.0` - Primary local database (offline-first)
- `flutter_riverpod: ^3.1.0` - All state management
- `go_router: ^17.0.1` - All navigation/routing
- `freezed_annotation: ^3.1.0` - All data models depend on this

**Firebase Suite (all free tier):**
- `firebase_auth: ^6.1.3` - Authentication (50K MAUs free)
- `cloud_firestore: ^6.1.1` - Database (1GB storage, 50K reads/day free)
- `firebase_messaging: ^16.1.0` - Push notifications (unlimited)
- `firebase_analytics: ^12.1.0` - Event analytics
- `firebase_crashlytics: ^5.0.6` - Crash reporting (non-web only)
- `firebase_performance: ^0.11.1+3` - Performance monitoring (non-web only)
- `firebase_remote_config: ^6.1.3` - Feature flags and remote configuration
- `firebase_app_check: ^0.4.1+3` - App security (Play Integrity / App Attest)
- `firebase_in_app_messaging: ^0.9.0+5` - In-app messages
- `firebase_ai: ^3.6.1` - Firebase AI Logic (Gemini 2.5 Flash chatbot)

**Authentication:**
- `google_sign_in: ^6.2.2` - Google OAuth (pinned to 6.x to avoid v7 breaking changes)
- `local_auth: ^3.0.0` - Biometric authentication (fingerprint/face)
- `flutter_secure_storage: ^10.0.0` - Encrypted key-value storage

**UI/UX:**
- `flutter_animate: ^4.5.0` - Micro-animations, staggered reveals
- `shadcn_ui: ^0.46.0` - Modern UI component library
- `forui: ^0.17.0` - Minimalist widget library
- `google_fonts: ^6.2.0` - Typography (Poppins headings, Inter body, JetBrains Mono numbers)
- `lucide_icons: ^0.257.0` - Icon set (used instead of Material Icons)
- `fl_chart: ^1.1.1` - Charts (pie, bar) for analytics
- `flex_color_scheme: ^8.2.0` - Material 3 dynamic theming
- `dynamic_color: ^1.8.1` - Android 12+ Material You color extraction
- `adaptive_theme: ^3.7.2` - Light/dark theme persistence
- `animated_theme_switcher: ^2.0.10` - Animated theme transitions
- `gap: ^3.0.0` - Spacing utility (`Gap(8)`)
- `flutter_slidable: ^4.0.3` - Swipe-to-action list items
- `skeletonizer: ^2.1.2` - Skeleton loading states
- `toastification: ^3.0.3` - Toast notification system
- `lottie: ^3.3.1` - JSON-based animations
- `cached_network_image: ^3.4.1` - Network image caching
- `flutter_svg: ^2.0.16` - SVG rendering

**Forms & Input:**
- `flutter_form_builder: ^10.2.0` - Advanced form handling
- `form_builder_validators: ^11.2.0` - Form validation
- `speech_to_text: ^7.3.0` - Voice entry for meals/bazar
- `mobile_scanner: ^7.1.4` - QR/barcode scanning
- `image_picker: ^1.2.1` - Camera/gallery image selection

**ML/AI:**
- `google_mlkit_text_recognition: ^0.15.0` - Receipt OCR scanner (on-device)
- `firebase_ai: ^3.6.1` - Gemini 2.5 Flash chatbot via Firebase AI Logic

**Export & Sharing:**
- `pdf: ^3.11.0` - PDF generation
- `printing: ^5.13.0` - Print/share PDF
- `csv: ^6.0.0` - CSV export
- `syncfusion_flutter_xlsio: ^32.1.21` - Excel XLSX generation
- `share_plus: ^12.0.1` - Native share dialog
- `file_picker: ^10.3.8` - File selection (backup restore)

**Location & Platform:**
- `geolocator: ^14.0.2` - GPS location services
- `geocoding: ^3.0.0` - Reverse geocoding (coordinates to address)
- `workmanager: ^0.7.0` - Background task scheduling
- `quick_actions: ^1.0.0` - 3D Touch / app shortcuts
- `home_widget: ^0.7.0` - Home screen widget support
- `flutter_displaymode: ^0.7.0` - High refresh rate display modes (120Hz+)
- `flutter_advanced_haptic: ^1.0.1` - Haptic feedback patterns
- `permission_handler: ^12.0.1` - Runtime permission management

**Utility:**
- `uuid: ^4.5.2` - Unique ID generation
- `path_provider: ^2.1.5` - Platform-specific file paths
- `money2: ^6.1.0` - Currency formatting
- `logger: ^2.6.2` - Structured logging
- `timeago: ^3.7.1` - Relative time formatting ("3 hours ago")
- `flutter_local_notifications: ^19.5.0` - Scheduled local notifications
- `timezone: ^0.10.1` - Timezone handling (Asia/Dhaka)
- `flutter_hooks: ^0.21.3+1` - React-style hooks for widgets

**Infrastructure:**
- `flutter_web_plugins` (SDK) - Web platform URL strategy

## Configuration

**Environment:**
- Firebase config files are gitignored and generated from GitHub Secrets in CI
  - `lib/firebase_options.dart` - FlutterFire CLI generated (base64-decoded from `FIREBASE_OPTIONS_DART` secret)
  - `android/app/google-services.json` - Android Firebase config (base64-decoded from `GOOGLE_SERVICES_JSON` secret)
  - `ios/Runner/GoogleService-Info.plist` - iOS Firebase config (base64-decoded from `GOOGLE_SERVICE_INFO_PLIST` secret)
- `RECAPTCHA_SITE_KEY` passed via `--dart-define` for web App Check
- Demo mode (`DemoMode.isEnabled`) bypasses all Firebase calls, uses `MockDataService`

**Build:**
- `pubspec.yaml` - Dart/Flutter dependencies and app metadata
- `android/app/build.gradle.kts` - Android build config (minSdk 26, Kotlin DSL, R8 minification + shrinkResources in release)
- `android/settings.gradle.kts` - Android Gradle plugins (AGP 8.11.1, Google Services, Firebase Perf, Crashlytics)
- `ios/Podfile` - iOS CocoaPods config (platform iOS 14.0)
- `Makefile` - Test and build automation commands

**Dependency Overrides:**
- `source_gen: ^4.1.1` - Pinned for code generator compatibility
- `build: ^4.0.0` - Pinned for code generator compatibility
- Note: `isar_community_generator` removed due to analyzer version conflicts (isar_plus needs ^8.4.1, generator needs <8.3.0)

## Platform Requirements

**Development:**
- Flutter SDK 3.38.5+
- Dart SDK 3.10.4+
- Java 17 (Android builds)
- Android SDK (minSdk 26 = Android 8.0)
- Xcode (iOS builds, deployment target 14.0)
- `dart run build_runner build --delete-conflicting-outputs` required after model/API changes

**Android:**
- Application ID: `com.area51.area51`
- minSdk: 26 (Android 8.0 Oreo)
- compileSdk: Flutter default (latest)
- Java desugaring enabled (`com.android.tools:desugar_jdk_libs:2.1.4`)
- R8 code shrinking + resource shrinking in release
- ProGuard rules: `proguard-rules.pro`

**iOS:**
- Deployment Target: 14.0
- Uses frameworks + modular headers

**Web:**
- Isar disabled (uses Firebase/in-memory only)
- `serve_web.py` provides dev server with required COOP/COEP headers
- Some Firebase features non-functional (Crashlytics, Performance)
- Path URL strategy (no hash in URLs)

**CI/CD:**
- GitHub Actions (`.github/workflows/build.yml`)
- Triggers: push to main/dev, PRs to main/dev, manual dispatch
- Jobs: Analyze & Test (ubuntu), Build Android APK (ubuntu), Build iOS (macos)
- Codecov integration for coverage reporting
- Artifacts: APK + debug symbols (14-day retention), iOS build + debug symbols (30-day retention)

---

*Stack analysis: 2026-03-25*
