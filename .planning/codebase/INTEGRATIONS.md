# External Integrations

**Analysis Date:** 2026-03-25

## APIs & External Services

**Firebase Suite (Primary Backend):**
- Firebase Core ^4.3.0 - Platform initialization
  - Client: `firebase_core` package
  - Init: `lib/core/services/firebase_service.dart` (`FirebaseService.initialize()`)
  - Config: `lib/firebase_options.dart` (gitignored, generated via FlutterFire CLI)

- Firebase Auth ^6.1.3 - User authentication
  - Client: `lib/core/services/auth_service.dart` (`AuthService`)
  - Methods: Email/password signup+signin, Google Sign-In, password reset, account deletion
  - Auth state: `AuthService.authStateChanges` stream
  - Google Sign-In: `google_sign_in: ^6.2.2` (pinned to 6.x)

- Cloud Firestore ^6.1.1 - Primary remote database
  - Client: `lib/core/services/firestore_service.dart` (`FirestoreService`)
  - Structure: Top-level `users/` and `messes/` collections
  - Subcollections: `messes/{messId}/meals`, `messes/{messId}/bazar`
  - Config collection: `config/nlp_keywords` for NLP keyword updates
  - Operations: User CRUD, mess create/join/leave, meals CRUD, bazar CRUD, batch operations
  - Free tier optimized: Batch writes, 1-hour remote config cache

- Firebase Cloud Messaging ^16.1.0 - Push notifications
  - Client: `lib/core/services/fcm_service.dart` (`FCMService`)
  - Features: Foreground/background message handling, topic subscriptions (`mess_{messId}`), token refresh
  - Background handler: Top-level `_firebaseMessagingBackgroundHandler()` function
  - Non-web only

- Firebase Analytics ^12.1.0 - Event tracking
  - Client: `lib/core/services/firebase_service.dart` (static methods)
  - Events: `sign_up`, `login`, `logout`, `meal_added`, `bazar_added`, `mess_created`, `mess_joined`, etc.
  - Screen tracking via `FirebaseAnalyticsObserver`
  - User ID binding for cross-device analytics

- Firebase Crashlytics ^5.0.6 - Crash reporting
  - Client: `lib/core/services/firebase_service.dart`
  - Setup: `FlutterError.onError` + `PlatformDispatcher.instance.onError` + `runZonedGuarded`
  - Disabled in debug mode, non-web only
  - Custom keys and log messages supported

- Firebase Performance ^0.11.1+3 - Performance monitoring
  - Client: `lib/core/services/firebase_service.dart`
  - Features: Custom traces, HTTP metrics
  - Disabled in debug mode

- Firebase Remote Config ^6.1.3 - Feature flags
  - Client: `lib/core/services/firebase_service.dart`
  - Defaults: `meal_rate_default`, `meal_reminder_morning/evening`, `night_preview_time`, `maintenance_mode`, `min_app_version`, `show_ads`
  - Cache: 1-hour minimum fetch interval (free tier friendly)

- Firebase App Check ^0.4.1+3 - Security
  - Client: `lib/core/services/firebase_service.dart` (`_initAppCheck()`)
  - Android: Play Integrity (production), Debug provider (development)
  - Apple: App Attest (production), Debug provider (development)
  - Web: reCAPTCHA v3 (site key via `--dart-define=RECAPTCHA_SITE_KEY`)

- Firebase In-App Messaging ^0.9.0+5 - In-app messages
  - Configured via Firebase console

- Firebase AI Logic ^3.6.1 - AI chatbot
  - Client: `lib/core/services/chatbot_service.dart` (`ChatbotService`)
  - Model: Gemini 2.5 Flash via `FirebaseAI.googleAI().generativeModel(model: 'gemini-2.5-flash')`
  - Auth: Uses Firebase auth (no separate API key needed)
  - Features: Chat sessions with mess context (balance, meal count, rate, bazar total), Bengali-English mixed responses
  - Suggestions: Pre-built question chips in Bengali

**Aladhan Prayer Times API:**
- Used for: Ramadan Sehri/Iftar times for all Bangladesh districts
  - SDK/Client: Retrofit-generated `lib/core/api/aladhan_api.dart` (`AladhanApi`)
  - Base URL: `https://api.aladhan.com/v1`
  - Auth: None (public API)
  - Endpoints:
    - `GET /timings/{date}` - Prayer times by coordinates
    - `GET /timingsByCity/{date}` - Prayer times by city name
  - Calculation method: University of Islamic Sciences, Karachi (method=1)
  - Service wrapper: `lib/core/services/prayer_times_service.dart` (`PrayerTimesService`)
  - Features: 64 Bangladesh district coordinates hardcoded, Sehri/Iftar time helpers

**DESCO Prepaid Meter API:**
- Used for: Electricity meter balance, consumption history, recharge tracking
  - SDK/Client: Retrofit-generated `lib/core/api/desco_api.dart` (`DescoApi`)
  - Base URL: `https://prepaid.desco.org.bd/api`
  - Auth: None (public API, queries by account/meter number)
  - Endpoints:
    - `GET /tkdes/customer/getCustomerInfo` - Customer info lookup
    - `GET /tkdes/customer/getBalance` - Current balance
    - `GET /tkdes/customer/getCustomerMonthlyConsumption` - Monthly usage
    - `GET /tkdes/customer/getRechargeHistory` - Recharge history
    - `GET /common/getCustomerLocation` - Customer location
  - Service wrapper: `lib/core/services/desco_service.dart` (`DescoService`)
  - Smart caching: Balance cached until 2am BD time (DESCO update window), consumption cached 1 week, recharge cached 1 day, location cached indefinitely
  - Features: Estimated balance calculation, low-balance alerts, days-remaining estimation, meter setup/lookup

**Generic REST API Client:**
- Client: `lib/core/api/api_client.dart` (`ApiClient`) + `lib/core/api/dio_client.dart` (`DioClient`)
- Base URL: Placeholder `https://api.example.com/v1` (not connected to live backend)
- Features: CRUD endpoints for members, meals, bazar, transactions
- Interceptors: Logging (debug only), error handling (401 redirect), retry with exponential backoff (max 3 retries)
- Auth: Bearer token support (`DioClient.setAuthToken()`)

## Data Storage

**Databases:**
- Cloud Firestore (remote)
  - Connection: Firebase SDK (auto-configured via `firebase_options.dart`)
  - Client: `lib/core/services/firestore_service.dart`
  - Collections: `users/`, `messes/`, `messes/{messId}/meals`, `messes/{messId}/bazar`, `config/`
  - Offline persistence: Built-in Firestore offline cache

- Isar Plus (local, non-web)
  - Connection: `lib/core/database/isar_service.dart` (`IsarService.init()`)
  - Database name: `mess_manager_db`
  - Location: `getApplicationDocumentsDirectory()`
  - Collections (16): MemberCollection, MealCollection, BazarEntryCollection, TransactionCollection, SettingsCollection, DutyAssignmentCollection, DutyScheduleCollection, DutyDebtCollection, UnifiedEntryCollection, SettlementCollection, RamadanSeasonCollection, RamadanMealCollection, RamadanBazarCollection, AppNotificationCollection, PendingApprovalCollection
  - Schema files: `lib/core/database/collections/*.dart`
  - Settings: Key-value store via `SettingsCollection` (typed: string, int, double, bool, json)
  - Sync tracking: `last_sync_time` stored in settings

**File Storage:**
- Local filesystem only (via `path_provider`)
  - Temp directory: PDF/CSV/XLSX exports before sharing
  - App documents: Backup files, saved exports
  - No cloud file storage (no Firebase Storage, no S3)

**Caching:**
- Isar settings-based caching for DESCO API data
  - Balance: Cached until next DESCO 2am update window
  - Consumption: 1-week cache
  - Recharge history: 1-day cache
  - Location: Indefinite cache
- Firebase Remote Config: 1-hour cache interval
- NLP keywords: Loaded once from Firestore at startup, merged with hardcoded defaults

**Secure Storage:**
- `flutter_secure_storage: ^10.0.0` - Encrypted key-value storage for sensitive data
- FCM tokens persisted via IsarService settings

## Authentication & Identity

**Auth Providers:**
- Firebase Auth (`lib/core/services/auth_service.dart`)
  - Email/Password: Signup, signin, password reset
  - Google Sign-In: OAuth via `google_sign_in` package
  - Biometric: `local_auth` for fingerprint/face unlock (device-level, not Firebase)
  - Auth state: Stream-based via `FirebaseAuth.authStateChanges()`
  - Disabled on web (Firebase not configured for web)

**Role-Based Access:**
- 7 roles: `superAdmin`, `admin`, `mealManager`, `maintenance`, `member`, `temp`, `guest`
- Enforced via `RoleGate` widget and permission providers
- Pending approval flow: `PendingApproval` model with `ApprovalStatus` enum

## Monitoring & Observability

**Error Tracking:**
- Firebase Crashlytics (mobile only, production only)
  - Fatal errors: `FlutterError.onError` + `PlatformDispatcher.instance.onError`
  - Non-fatal: `FirebaseCrashlytics.instance.recordError()`
  - Async errors: `runZonedGuarded` in `lib/main.dart`
  - Custom keys and log messages for context

**Analytics:**
- Firebase Analytics
  - Screen views: `FirebaseAnalyticsObserver` on router
  - Custom events: Auth events, CRUD operations, feature usage
  - User ID tracking: Set on login, cleared on logout

**Performance:**
- Firebase Performance Monitoring (mobile only, production only)
  - Custom traces: `FirebaseService.startTrace()`
  - HTTP metrics: `FirebaseService.createHttpMetric()`

**Logs:**
- `debugPrint()` for development logging
- `logger: ^2.6.2` available for structured logging
- `FirebaseCrashlytics.instance.log()` for breadcrumb logging in production

## CI/CD & Deployment

**Hosting:**
- No deployed backend (Firebase is the backend)
- Android: APK built in CI, artifact uploaded
- iOS: IPA built in CI (no-codesign), artifact uploaded
- Web: Local dev via `serve_web.py` with COOP/COEP headers

**CI Pipeline:**
- GitHub Actions (`.github/workflows/build.yml`)
- Trigger: Push to `main`/`dev`, PRs to `main`/`dev`, manual dispatch
- Concurrency: Cancel in-progress runs for same branch
- Jobs:
  1. **Analyze & Test** (ubuntu, 15min timeout): `flutter pub get` -> `build_runner` -> `flutter analyze` (non-fatal) -> `flutter test --coverage` -> Codecov upload
  2. **Build Android** (ubuntu, 30min timeout, depends on analyze): Decode Firebase secrets -> `flutter build apk --release --obfuscate --split-debug-info` -> upload artifact (14-day retention)
  3. **Build iOS** (macos, 45min timeout, depends on analyze): Decode Firebase secrets -> CocoaPods install -> `flutter build ios --release --no-codesign --obfuscate --split-debug-info` -> upload artifact (14-day retention)

## Environment Configuration

**Required env vars / secrets (GitHub Actions):**
- `GOOGLE_SERVICES_JSON` - Base64-encoded `android/app/google-services.json`
- `FIREBASE_OPTIONS_DART` - Base64-encoded `lib/firebase_options.dart`
- `GOOGLE_SERVICE_INFO_PLIST` - Base64-encoded `ios/Runner/GoogleService-Info.plist`

**Optional dart-define vars:**
- `RECAPTCHA_SITE_KEY` - reCAPTCHA v3 site key for web App Check

**Secrets location:**
- GitHub repository secrets (for CI)
- Local Firebase config files (gitignored, generated via `flutterfire configure`)
- `.env` files not used (no `.env` files detected)

## On-Device ML Services

**Google ML Kit Text Recognition:**
- Package: `google_mlkit_text_recognition: ^0.15.0`
- Client: `lib/core/services/receipt_ocr_service.dart` (`ReceiptOcrNotifier`)
- Purpose: Receipt OCR scanner for bazar expense extraction
- Features: Item name + price extraction, total detection, Bengali currency (Taka) pattern matching, BDT format support
- Script: Latin text recognition
- Fully on-device (no network calls)

**Speech-to-Text:**
- Package: `speech_to_text: ^7.3.0`
- Client: `lib/core/services/voice_entry_service.dart` (`VoiceEntryNotifier`)
- Purpose: Voice commands for meal/bazar entry
- Features: Natural language parsing ("Add 2 lunch for today", "bazar 500 taka vegetables"), meal type detection, guest count extraction, amount extraction
- Default locale: `en_US`
- Fully on-device

## NLP Categorization

**Custom NLP Service:**
- Client: `lib/core/services/nlp_categorizer.dart` (`NLPCategorizer`)
- Purpose: Auto-detect expense type from description text
- Categories: `mealBazar`, `monthly` (amenities), `fixed` (bills)
- Sub-categories: rent, electricity, gas, wifi, water, maid, garbage, soap, tissue, toothpaste, filter, coil
- Keywords: Hardcoded defaults (Bengali + English) with Firestore-based overrides from `config/nlp_keywords` document
- Confidence scoring: 0.5-0.9 based on match type

## Export Formats

**Generated Documents:**
- PDF - Settlement reports via `pdf` + `printing` packages (`lib/core/services/export_service.dart`)
- CSV - Balance exports via `csv` package
- XLSX - Excel reports with styled formatting via `syncfusion_flutter_xlsio` package
- JSON - Full backup/restore via `lib/core/services/backup_service.dart`

## Notifications

**Push (Remote):**
- Firebase Cloud Messaging (`lib/core/services/fcm_service.dart`)
- Topic-based: `mess_{messId}` per mess group
- Background handler: Saves to Isar for notification history

**Local (Scheduled):**
- `flutter_local_notifications: ^19.5.0` (`lib/core/services/local_notification_service.dart`)
- Timezone: Asia/Dhaka
- Used for: Meal reminders, duty reminders, bill alerts

## Webhooks & Callbacks

**Incoming:**
- None (no server-side webhook endpoints)

**Outgoing:**
- None (no outbound webhook integrations)

---

*Integration audit: 2026-03-25*
