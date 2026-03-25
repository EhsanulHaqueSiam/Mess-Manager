# Codebase Concerns

**Analysis Date:** 2026-03-25

## Tech Debt

### Freezed 3.x Sealed Class Property Access (CRITICAL - 1300+ errors)

- Issue: All Freezed models use `@freezed sealed class` (Freezed 3.x), but the entire codebase accesses properties directly on the sealed base type (e.g., `meal.id`, `meal.count`). Freezed 3.x sealed classes do not expose property getters on the base type -- properties are only on the generated private constructor variant (`_Meal`, `_BazarEntry`, etc.). The code needs either: (a) code generation to produce `.freezed.dart` files that promote getters (run `build_runner`), or (b) pattern matching to unwrap the sealed type.
- Files: Every model in `lib/core/models/` and every consumer across 60+ files:
  - `lib/core/database/collections/bazar_collection.dart` (13 errors)
  - `lib/core/database/collections/duty_collection.dart` (18 errors)
  - `lib/core/database/collections/meal_collection.dart` (12 errors)
  - `lib/core/database/collections/member_collection.dart`
  - `lib/core/database/collections/transaction_collection.dart`
  - `lib/core/database/collections/ramadan_collection.dart`
  - `lib/core/database/collections/settlement_collection.dart`
  - `lib/core/database/collections/unified_entry_collection.dart`
  - All providers under `lib/features/*/providers/`
  - All screens under `lib/features/*/screens/`
  - All test files under `test/`
- Impact: **App cannot compile.** 1,338 of the 1,360 analyzer errors trace back to this single root cause (undefined getters on sealed types + missing generated `.freezed.dart`/`.g.dart` files).
- Fix approach: Run `dart run build_runner build --delete-conflicting-outputs` to generate all `.freezed.dart` and `.g.dart` files. If Freezed 3.x code gen still does not promote getters on the sealed base type, add `const` constructors or use the Freezed `@Freezed(copyWith: true)` annotation with accessor promotion enabled. Alternatively, if code gen works but `isar_community_generator` conflict blocks it (see next item), resolve the dependency conflict first.

### Isar Code Generator Conflict (BLOCKS build_runner)

- Issue: The pubspec.yaml comment at line 119-121 states: "isar_community_generator removed due to unresolvable version conflicts between isar_plus (needs analyzer ^8.4.1) and isar_community_generator (needs analyzer <8.3.0)." This means `build_runner` cannot generate Isar collection schemas, and the existing `.g.dart` collection files may be stale or manually maintained.
- Files: `pubspec.yaml:119-121`
- Impact: Isar collection schemas cannot be regenerated. Any model changes require manual `.g.dart` edits, which is error-prone and unsustainable.
- Fix approach: Either (a) wait for `isar_plus` ecosystem to release a compatible generator, (b) switch to `isar_community` with matching analyzer constraints, or (c) migrate off Isar to a different local DB (Hive, Drift/SQLite) that has stable code generation.

### Missing Generated Files (22 errors)

- Issue: 11 Freezed models have missing `.freezed.dart` and `.g.dart` files, causing 22 `uri_does_not_exist` / `uri_has_not_been_generated` errors.
- Files:
  - `lib/core/models/auth_user.dart`
  - `lib/core/models/bazar_entry.dart`
  - `lib/core/models/bazar_list_item.dart`
  - `lib/core/models/default_meal_schedule.dart`
  - `lib/core/models/duty.dart`
  - `lib/core/models/meal.dart`
  - `lib/core/models/member.dart`
  - `lib/core/models/money_transaction.dart`
  - `lib/core/models/ramadan.dart`
  - `lib/core/models/settlement.dart`
  - `lib/core/models/unified_entry.dart`
- Impact: No model serialization (fromJson/toJson), no copyWith, no equality -- foundational model layer is entirely broken.
- Fix approach: Run `dart run build_runner build --delete-conflicting-outputs`. Resolve dependency conflicts first if build_runner fails (see Isar generator conflict above).

### Google Sign-In v7.x Breaking Changes

- Issue: `google_sign_in: ^6.2.2` is pinned in pubspec (comment: "Pinned to 6.x to avoid v7 breaking changes"), but the resolved version may have already bumped. The analyzer reports: "The class 'GoogleSignIn' doesn't have an unnamed constructor" and "'accessToken' isn't defined for the type 'GoogleSignInAuthentication'", indicating the v7.x API is in effect.
- Files: `lib/core/services/auth_service.dart:27`, `lib/core/services/auth_service.dart:130`
- Impact: Google Sign-In is completely broken. Users cannot authenticate via Google.
- Fix approach: Migrate to `google_sign_in` v7.x API: use `GoogleSignIn.instance` instead of `GoogleSignIn()`, and use the new auth token access pattern. Alternatively, pin to an exact 6.x version with `dependency_overrides`.

### Workmanager API Mismatch

- Issue: `ExistingWorkPolicy` is used where `ExistingPeriodicWorkPolicy?` is expected. The `isInDebugMode` parameter is deprecated.
- Files: `lib/core/services/auto_month_close_service.dart:25,38`
- Impact: Background auto month-close scheduling fails to compile.
- Fix approach: Change `ExistingWorkPolicy.keep` to `ExistingPeriodicWorkPolicy.keep`. Remove `isInDebugMode` parameter or use `WorkmanagerDebug` handlers.

### Meals Provider Type Mismatch

- Issue: A `(double, int)` record is assigned to a `(int, int)` variable in the guest stats computation.
- Files: `lib/features/meals/providers/meals_provider.dart:196`
- Impact: Compilation error in guest meal statistics.
- Fix approach: Cast `guestCount` sum to `int` or change the record type to `(int, int)`.

### Dependency Overrides in pubspec.yaml

- Issue: `source_gen: ^4.1.1` and `build: ^4.0.0` are forced via `dependency_overrides`. This circumvents normal dependency resolution and can cause subtle incompatibilities with other generators (Freezed, Retrofit, json_serializable).
- Files: `pubspec.yaml:123-126`
- Impact: Generators may produce incorrect code or crash during build_runner execution.
- Fix approach: Remove overrides and resolve version conflicts properly by upgrading dependent packages.

## Known Bugs

### Reflection-Based Plugin Registration (Android)

- Issue: The standard `GeneratedPluginRegistrant.java` is excluded from compilation (see `android/app/build.gradle.kts` comment at bottom). Instead, `MainActivity.kt` manually registers 38 plugins via `Class.forName()` reflection. Three plugins are known to fail at runtime: `file_picker` (FilePickerPlugin), `firebase_performance` (FlutterFirebasePerformancePlugin), `package_info_plus` (PackageInfoPlugin).
- Files:
  - `android/app/src/main/kotlin/com/area51/area51/MainActivity.kt`
  - `android/app/build.gradle.kts:56-60` (JavaCompile exclusion)
- Symptoms: Runtime `Log.w` warnings for failed plugin registration; `file_picker`, `firebase_performance`, and `package_info_plus` features silently fail.
- Trigger: Every Android app launch.
- Workaround: Failures are caught silently via try/catch in the loop. Features degrade gracefully (backup restore fails with file_picker, performance monitoring disabled, app version info unavailable).

### BuildContext Across Async Gaps (18 instances)

- Issue: `BuildContext` is used after `await` calls without proper `mounted` checks, or with unrelated `mounted` checks.
- Files:
  - `lib/features/auth/screens/login_screen.dart:875,878`
  - `lib/features/bazar/widgets/add_bazar_sheet.dart:1072,1120,1122,1146,1148`
  - `lib/features/meals/screens/meals_screen.dart:831,841`
  - `lib/features/members/widgets/member_actions_sheet.dart:1168,1169,1577,1579`
  - `lib/features/money/widgets/add_transaction_sheet.dart:360`
- Symptoms: Potential `setState called after dispose` crashes, or navigation to deallocated routes.
- Trigger: Slow network responses followed by user navigating away.
- Workaround: None currently. Add `if (!context.mounted) return;` before each context use after await.

## Security Considerations

### Firestore Rules Missing Subcollections

- Risk: The Firestore rules at `firestore.rules` only define access for 5 subcollections under `/messes/{messId}/`: `meals`, `bazar`, `members`, `cancellations`, `expenses`. However, the app writes to additional subcollections that have NO rules defined:
  - `shopping_list` (accessed in `lib/features/bazar/providers/shopping_list_provider.dart:123`)
  - `config` (accessed in `lib/core/services/nlp_categorizer.dart:123`)
  - Duties, transactions, settlements, ramadan data, unified entries, and notifications are stored locally (Isar) but if any future Firestore sync is added, they would be unprotected.
- Files: `firestore.rules`, `lib/core/services/firestore_service.dart`, `lib/features/bazar/providers/shopping_list_provider.dart`
- Current mitigation: Unmatched subcollections are denied by default (Firestore denies unless explicitly allowed). This means `shopping_list` and `config` writes silently fail.
- Recommendations: Add rules for `shopping_list` and `config` subcollections, or remove the Firestore write code for these collections if they are not needed.

### Firestore Rules: No Role-Based Access

- Risk: The app has 7 roles (`superAdmin`, `admin`, `mealManager`, `maintenance`, `member`, `temp`, `guest`) enforced client-side via `RoleGate` widget and permission providers, but Firestore rules only check `isMessOwner()` vs `isMessMember()` -- a binary check. Any member can create/modify meals for other members, create bazar entries with arbitrary amounts, etc.
- Files: `firestore.rules:61-106`
- Current mitigation: Client-side role checks in the UI prevent unauthorized actions for honest users.
- Recommendations: Add server-side role enforcement in Firestore rules by storing member roles in the mess document or members subcollection and checking them in rules.

### Release Build Signed with Debug Key

- Risk: The release build configuration uses `signingConfig = signingConfigs.getByName("debug")` which means release APKs are signed with the debug keystore.
- Files: `android/app/build.gradle.kts:41`
- Current mitigation: None -- this prevents Play Store uploads and means release builds have no production signing.
- Recommendations: Create a production keystore, configure `key.properties`, and reference it in the release signing config.

### Silent Exception Swallowing

- Risk: 33 instances of `catch (_) {}` silently swallow exceptions with no logging, especially in data conversion methods. Corrupted data in Isar will be silently discarded.
- Files: All collection files in `lib/core/database/collections/` (12 instances), plus `lib/core/providers/members_provider.dart` (2 instances)
- Current mitigation: None.
- Recommendations: At minimum, add `debugPrint` or `logger` calls in catch blocks. For data conversion, consider logging corrupted entries to Crashlytics.

## Performance Bottlenecks

### Oversized Screen Widgets

- Problem: Multiple screen files exceed 1000 lines, combining layout, business logic, and state management in single widget files. The largest non-generated files:
  - `lib/features/settings/screens/settings_screen.dart` (2,076 lines)
  - `lib/features/dashboard/screens/dashboard_screen.dart` (1,801 lines)
  - `lib/features/ramadan/screens/ramadan_screen.dart` (1,729 lines)
  - `lib/features/members/widgets/member_actions_sheet.dart` (1,586 lines)
  - `lib/features/duties/screens/duties_screen.dart` (1,555 lines)
  - `lib/features/settlement/screens/settlement_screen.dart` (1,498 lines)
  - `lib/features/bazar/screens/bazar_screen.dart` (1,418 lines)
  - `lib/features/desco/screens/desco_screen.dart` (1,321 lines)
  - `lib/features/bazar/widgets/add_bazar_sheet.dart` (1,156 lines)
  - `lib/features/money/screens/money_screen.dart` (1,131 lines)
- Files: Listed above.
- Cause: Monolithic widget builds trigger full subtree rebuilds when any state changes. Riverpod `ref.watch` in a 2000-line build method means the entire screen rebuilds.
- Improvement path: Extract sub-widgets into separate `ConsumerWidget` classes with focused `ref.watch` calls. Each extracted widget only rebuilds when its specific provider changes.

### IsarService: All-Static Synchronous Design

- Problem: `IsarService` uses entirely static methods and synchronous Isar reads (`getAllMembers()`, `getAllMeals()`, etc.). For large datasets, synchronous reads block the UI thread.
- Files: `lib/core/database/isar_service.dart` (896 lines, 30+ static methods)
- Cause: Isar supports both sync and async operations; only sync variants are used.
- Improvement path: Convert to async operations (`isar.mealCollections.where().findAllAsync()`) for read-heavy paths, or use Isar's `watch()` streams for reactive updates.

### Massive Generated Isar Files

- Problem: Generated Isar collection files are very large (e.g., `duty_collection.g.dart` at 8,597 lines). While these do not affect runtime performance, they slow down IDE analysis and `flutter analyze` significantly.
- Files: `lib/core/database/collections/*.g.dart`
- Cause: Isar generates exhaustive query builders for every indexed field.
- Improvement path: Not directly fixable without reducing indexed fields. Consider if all indexes are necessary.

## Fragile Areas

### Isar Collection ↔ Model Mapping Layer

- Files:
  - `lib/core/database/collections/bazar_collection.dart`
  - `lib/core/database/collections/duty_collection.dart`
  - `lib/core/database/collections/meal_collection.dart`
  - `lib/core/database/collections/member_collection.dart`
  - `lib/core/database/collections/transaction_collection.dart`
  - `lib/core/database/collections/ramadan_collection.dart`
  - `lib/core/database/collections/settlement_collection.dart`
  - `lib/core/database/collections/unified_entry_collection.dart`
- Why fragile: Manual `fromModel()` / `toModel()` conversion between Freezed models and Isar collections. Any field added to a Freezed model must also be manually added to the collection class and both converter methods. Enum fields use raw index integers (`DutyType.values[typeIndex]`) which break silently if enum order changes. JSON-encoded lists (e.g., `itemsJson`, `sharedWithMemberIdsJson`) add serialization overhead and silent failure on corruption.
- Safe modification: When adding a field to a model, update the Isar collection class, `toModel()`, `fromModel()`, and regenerate `.g.dart`.
- Test coverage: No unit tests for collection ↔ model conversion.

### Android Plugin Registration

- Files: `android/app/src/main/kotlin/com/area51/area51/MainActivity.kt`
- Why fragile: Reflection-based plugin instantiation via `Class.forName()` using hardcoded fully-qualified class names. Any plugin update that changes its main class name will silently fail. No compile-time safety.
- Safe modification: After updating any Flutter plugin version, verify the plugin's main class name has not changed. Test on a physical Android device.
- Test coverage: None. Plugin failures are only visible in logcat.

## Scaling Limits

### Firestore Free Tier

- Current capacity: 50K reads/day, 20K writes/day, 1GB storage (Firebase free tier Spark plan).
- Limit: A mess with 10 members each logging 3 meals/day = 30 meal writes + 30 reads for display = 60 operations/day for meals alone. With bazar, duties, settlements, and background syncs, a single active mess could consume 200-500 operations/day. At 100 active messes, this approaches 50K reads/day.
- Scaling path: Implement batched reads, local caching (already using Isar), and read-through patterns. Aggregate data server-side using Cloud Functions to reduce per-document reads.

### Isar Database Size (Mobile)

- Current capacity: No size limit enforced in code.
- Limit: For a mess running 2+ years with detailed bazar entries (photos, receipts, items), the local DB could grow to 500MB+.
- Scaling path: Implement data archival strategy (move old months to cloud-only storage, clear local Isar after successful sync).

## Dependencies at Risk

### isar_plus (v1.2.0)

- Risk: Community fork of Isar, not the official `isar` package. Code generator is incompatible (removed from pubspec). Long-term maintenance uncertain.
- Impact: If `isar_plus` is abandoned, all local persistence breaks.
- Migration plan: Evaluate `drift` (SQLite-based, stable code gen) or `hive_ce` as alternatives with mature ecosystems.

### google_sign_in (^6.2.2 but resolving to v7.x)

- Risk: The v7.x API has breaking changes (no unnamed constructor, different auth token access). The pinned range `^6.2.2` may resolve to 7.x if pub resolver allows.
- Impact: Google authentication broken.
- Migration plan: Lock to `6.2.2` exactly, or migrate code to v7.x API.

### Kotlin 2.2.20

- Risk: Kotlin 2.2.20 is very new and causes the `GeneratedPluginRegistrant.java` compilation issue (Java code cannot resolve Kotlin-only plugin classes). This required the manual reflection-based workaround in `MainActivity.kt`.
- Impact: Every plugin update requires verifying the reflection class names still work.
- Migration plan: Consider downgrading to Kotlin 2.1.x for better Flutter plugin compatibility, or wait for Flutter to officially support Kotlin 2.2.x.

## Missing Critical Features

### No Offline-to-Online Sync Conflict Resolution

- Problem: The app claims "offline-first" with Isar local + Firestore remote, but there is no conflict resolution strategy. `FirestoreService` methods do simple `set()` / `update()` calls without checking for concurrent modifications.
- Blocks: Multi-device usage. If two users edit the same meal/bazar entry offline, last-write-wins with no merge logic.

### No Data Migration Strategy

- Problem: No Isar schema migration logic exists. `IsarService.init()` opens the DB without version checks or migration callbacks.
- Blocks: Any model schema change (adding/removing fields) will crash on existing user devices with incompatible Isar schemas.
- Files: `lib/core/database/isar_service.dart:54`

## Test Coverage Gaps

### Overall Coverage: Minimal

- What's not tested: 10 test files total for ~60K lines of non-generated Dart code. No tests for:
  - Any Isar collection ↔ model conversion
  - Any Firestore service operations
  - Auth service (Google Sign-In, email auth)
  - Any provider beyond meals and settlement
  - Any screen besides error_screen
  - Backup/restore service
  - Export service (PDF, CSV, Excel)
  - Location service
  - Role-based access control
  - Duty scheduling/rotation logic
  - Ramadan features
  - Vacation/fixed expenses
- Files: `test/` directory (10 test files, 4 helpers)
- Risk: Any refactoring (especially the Freezed sealed class fix) has no safety net. Regressions will not be caught.
- Priority: **High** -- the Freezed fix will touch every model and consumer, and there are no tests to verify correctness.

### Tests Also Have Compile Errors

- What's not tested: The existing tests also suffer from the same Freezed sealed class errors and cannot run.
- Files:
  - `test/integration/integration_test.dart` (type assignment error + 20+ undefined getters)
  - `test/integration/app_flow_test.dart`
  - `test/smoke/smoke_test.dart`
  - `test/smoke/security_smoke_test.dart`
  - `test/unit/providers/meals_provider_test.dart`
  - `test/helpers/mock_providers.dart`
- Risk: Zero test feedback loop. All tests are broken.
- Priority: **High** -- fix tests alongside the Freezed model fix.

## Deprecated API Usage (15 instances)

### Flutter Framework Deprecations

- `SemanticsService.announce()` → use `sendAnnouncement()`: `lib/core/accessibility/accessibility_helper.dart:371`
- `TextFormField.value` → use `initialValue`: `lib/features/members/widgets/add_edit_member_sheet.dart:132`
- `Switch.activeColor` → use `activeThumbColor`/`activeTrackColor` (5 instances):
  - `lib/features/notifications/screens/notification_settings_screen.dart:266,433`
  - `lib/features/settlement/widgets/penalty_settings_sheet.dart:69,282`
  - `lib/features/vacation/screens/vacation_screen.dart:520`

### Plugin Deprecations

- `Workmanager.isInDebugMode` → use `WorkmanagerDebug`: `lib/core/services/auto_month_close_service.dart:25`
- `Share.shareXFiles()` → use `SharePlus.instance.share()`: `lib/core/services/backup_service.dart:67`
- `FirebaseAppCheck.androidProvider` → use `providerAndroid`: `lib/core/services/firebase_service.dart:80`
- `FirebaseAppCheck.appleProvider` → use `providerApple`: `lib/core/services/firebase_service.dart:83`
- `FirebaseAppCheck.webProvider` → use `providerWeb`: `lib/core/services/firebase_service.dart:87`
- `Geolocator.desiredAccuracy` / `timeLimit` → use settings objects: `lib/core/services/location_service.dart:105-106`

---

*Concerns audit: 2026-03-25*
