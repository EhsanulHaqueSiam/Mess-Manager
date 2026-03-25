# Testing Patterns

**Analysis Date:** 2026-03-25

## Test Framework

**Runner:**
- `flutter_test` (built-in Flutter test framework)
- No custom test runner config file (no `dart_test.yaml`)

**Assertion Library:**
- `flutter_test` matchers (`expect`, `find`, `findsOneWidget`, etc.)

**Mocking:**
- `mocktail` 1.0.4 (in dev_dependencies, though no Mock classes defined yet -- test helpers use real Freezed models as fixtures)

**Run Commands:**
```bash
make test               # Run all tests
make test-unit          # Unit tests only (test/unit/)
make test-widget        # Widget tests only (test/widget/)
make test-smoke         # Smoke tests only (test/smoke/)
make test-security      # Security smoke tests
make test-e2e           # Integration tests (test/integration/)
make test-pages         # Page coverage tests
make test-screens       # Screen widget tests
make test-coverage      # Tests with coverage (lcov.info)
make coverage-html      # Generate HTML coverage report
make test-watch         # Watch mode (requires entr)
flutter test test/unit/providers/meals_provider_test.dart  # Single file
```

## Test File Organization

**Location:** Separate `test/` directory mirroring feature structure (NOT co-located)

**Naming:**
- Unit tests: `{feature}_test.dart` -- e.g., `meals_provider_test.dart`
- Widget tests: `{widget_name}_test.dart` -- e.g., `error_screen_test.dart`
- Smoke tests: `smoke_test.dart`, `security_smoke_test.dart`
- Integration tests: `integration_test.dart`, `page_coverage_test.dart`, `app_flow_test.dart`

**Structure:**
```
test/
├── helpers/
│   ├── mock_providers.dart       # Shared mock data factories
│   ├── test_app_wrapper.dart     # Widget test wrappers
│   └── test_helpers.dart         # ProviderContainer helpers, constants
├── smoke/
│   ├── smoke_test.dart           # Bootstrap, model, enum, theme, serialization tests
│   └── security_smoke_test.dart  # Authorization, data exposure, input validation
├── unit/
│   └── providers/
│       ├── meals_provider_test.dart      # Meal model & calculation tests
│       └── settlement_provider_test.dart # Balance & fixed cost tests
├── widget/
│   ├── screens/
│   │   ├── screen_widget_tests.dart # Registry-based screen tests
│   │   └── error_screen_test.dart   # ErrorScreen (placeholder - animation issues)
│   └── widgets/
│       └── sync_status_widget_test.dart # SyncStatusWidget + provider tests
├── integration/
│   ├── app_flow_test.dart          # Cross-feature data flow tests
│   ├── integration_test.dart       # Entity relationships, business logic, edge cases
│   └── page_coverage_test.dart     # Screen registry completeness verification
└── widget_test.dart                # Default Flutter test (placeholder)
```

## Test Structure

### Suite Organization
Tests are organized with `group()` using emoji-prefixed category names:

```dart
void main() {
  group('🚀 Bootstrap - Application Startup', () {
    test('ProviderContainer creates without exceptions', () {
      // ...
    });
  });

  group('📦 Models - Instantiation Without Errors', () {
    test('Member model instantiates with minimum required fields', () {
      // ...
    });
  });
}
```

### Group Naming Convention
- Emoji prefix for visual scanning in test output
- Category name -- descriptive of what aspect is being tested
- Hyphenated subcategory for specificity

Examples from the codebase:
- `'🚀 Bootstrap - Application Startup'`
- `'📦 Models - Instantiation Without Errors'`
- `'🎛️ Enums - All Values Exist'`
- `'🎨 Theme - Design System Exists'`
- `'📤 Serialization - JSON Round-Trip'`
- `'⚡ Edge Cases - Boundary Conditions'`
- `'🔐 Type Safety - Compile-Time Checks'`
- `'🔒 Security - Data Exposure Prevention'`
- `'🔗 Integration - Member ↔ Meal Integrity'`
- `'⚙️ Integration - Meal Rate Calculation'`
- `'🔄 Integration - Calculation Consistency'`

### Test Body Pattern
Tests follow a consistent structure:

```dart
test('descriptive name of what is verified', () {
  // Arrange - set up test data
  final meals = createMockMeals(DateTime.now());
  final bazar = createMockBazarEntries(DateTime.now());

  // Act - perform the operation
  final mealRate = calculateMealRate(meals, bazar);

  // Assert - verify the result
  expect(mealRate, closeTo(200.0, 0.01));
});
```

### Instantiation Safety Pattern
A common pattern tests that constructors do not throw:

```dart
test('Member model instantiates with minimum required fields', () {
  Member? member;

  expect(() {
    member = Member(id: 'test_id', name: 'Test User');
  }, returnsNormally);

  expect(member?.id, equals('test_id'));
  expect(member?.name, equals('Test User'));
});
```

## Test Helpers

### TestAppWrapper (`test/helpers/test_app_wrapper.dart`)
Standard widget test wrapper providing `ProviderScope` + `MaterialApp`:

```dart
await tester.pumpWidget(
  TestAppWrapper(
    themeMode: ThemeMode.dark,        // Default: dark
    screenSize: TestDevices.pixel4,   // Default: 411x823
    child: MyScreenWidget(),
  ),
);
```

### MinimalTestWrapper
Simplified wrapper for basic widget tests (no theme, no media query):

```dart
await tester.pumpWidget(
  MinimalTestWrapper(child: MyWidget()),
);
```

### WidgetTester Extensions (`test/helpers/test_app_wrapper.dart`)
Convenience methods on `WidgetTester`:

```dart
// Pump with wrapper + settle
await tester.pumpTestApp(MyWidget());

// Pump minimal + settle
await tester.pumpMinimal(MyWidget());

// Tap by text
await tester.tapByText('Submit');

// Tap by icon
await tester.tapByIcon(LucideIcons.plus);

// Enter text by key
await tester.enterTextByKey(Key('nameField'), 'John');

// Scroll until visible
await tester.scrollUntilVisible('Hidden Item');

// Verify basic screen structure
await tester.verifyScreenStructure(expectAppBar: false);
```

### Test Device Sizes (`test/helpers/test_app_wrapper.dart`)
Pre-defined screen sizes for responsive testing:

```dart
TestDevices.iPhoneSE          // 375x667
TestDevices.iPhone14          // 390x844
TestDevices.iPhone14ProMax    // 430x932
TestDevices.pixel4            // 411x823 (default)
TestDevices.pixel7            // 412x915
TestDevices.galaxyS21         // 360x800
TestDevices.iPad              // 768x1024
TestDevices.iPadPro           // 1024x1366
```

### createContainer (`test/helpers/test_helpers.dart`)
Creates a `ProviderContainer` for pure unit tests (auto-disposed):

```dart
final container = createContainer(overrides: [
  // provider overrides
]);
final value = container.read(myProvider);
```

### TestConstants / TestDates (`test/helpers/test_helpers.dart`)
```dart
TestConstants.testMemberId    // 'test_member_1'
TestConstants.testMemberName  // 'Test User'
TestConstants.testMessId      // 'test_mess_1'
TestConstants.testAmount      // 100.0

TestDates.today
TestDates.yesterday
TestDates.lastWeek
TestDates.monthStart
TestDates.monthEnd
```

### Mock Data Factories (`test/helpers/mock_providers.dart`)
Shared test data builders using real Freezed models:

```dart
// Pre-built member fixtures
final mockMembers = [
  Member(id: 'member_1', name: 'Alice', role: MemberRole.admin, ...),
  Member(id: 'member_2', name: 'Bob', role: MemberRole.member, ...),
  Member(id: 'member_3', name: 'Charlie', role: MemberRole.member, ...),
];

// Factory functions (take DateTime for date flexibility)
List<Meal> createMockMeals(DateTime date)
List<BazarEntry> createMockBazarEntries(DateTime date)
List<FixedExpense> createMockFixedExpenses()

// Calculation helpers (reusable business logic for assertions)
double calculateMealRate(List<Meal> meals, List<BazarEntry> bazar)
double calculateMemberBalance({...})
```

## Mocking

**Framework:** `mocktail` 1.0.4 (declared in `pubspec.yaml`)

**Current Mocking Approach:**
The codebase does NOT currently define `Mock` classes using mocktail. Instead, tests use:
- Real Freezed model instances as fixtures (from `mock_providers.dart`)
- `ProviderContainer` with default providers (from `test_helpers.dart`)
- `TestAppWrapper` with `ProviderScope` for widget tests

**What to Mock (when needed):**
- `IsarService` -- local database operations
- Firebase services (Auth, Firestore) -- when testing providers that depend on them
- `HapticService` -- for widget tests that trigger haptics
- Network clients (Dio, Retrofit) -- for API integration tests

**What NOT to Mock:**
- Freezed models -- use real instances from factories
- Pure calculation functions -- test with real data
- Theme/styling -- use `TestAppWrapper` which provides a real `MaterialApp`

## Screen Registry Testing

The app uses a `ScreenRegistry` (`lib/core/testing/screen_registry.dart`) for auto-discovery testing. When a new screen is added to the registry, it is automatically included in:

- **Instantiation tests:** Verify `screen.builder()` does not throw
- **Route uniqueness:** All routes are verified unique
- **Feature coverage:** Each feature must have at least 1 screen
- **Auth marking:** Public vs auth-required routes are verified

**Adding a new screen to test coverage:**
1. Add a `ScreenInfo` entry to `screenRegistry` list in `lib/core/testing/screen_registry.dart`
2. Tests in `test/widget/screens/screen_widget_tests.dart` and `test/integration/page_coverage_test.dart` will automatically pick it up

```dart
// In lib/core/testing/screen_registry.dart
ScreenInfo(
  route: AppRoutes.myFeature,
  name: 'MyFeature',
  feature: 'my_feature',
  builder: () => const MyFeatureScreen(),
  requiresAuth: true,
  hasBottomNav: false,
),
```

## Test Categories

### Smoke Tests (`test/smoke/`)
**Purpose:** Fast sanity checks run first to catch catastrophic failures.

**`smoke_test.dart` covers:**
- Bootstrap: `ProviderContainer` creation, `MaterialApp` instantiation, route constants
- Model instantiation: All Freezed models with required and default fields
- Enum validation: All enum values exist and have expected count
- Theme system: `AppColors`, `AppSpacing` token existence and ordering
- Serialization: JSON round-trip for all core models
- Edge cases: Boundary values, empty collections, large/small amounts
- Type safety: Correct types for critical fields

**`security_smoke_test.dart` covers:**
- Data exposure: `toJson()` does not leak sensitive fields (password, token)
- Authorization model: `MemberRole` hierarchy ordering
- State isolation: Freezed immutability (`copyWith` creates new instance)
- Input validation: Edge cases with empty/zero/negative values
- Temporal controls: Date fields preserved in serialization
- Multi-tenant isolation: `messId` field on settlements

### Unit Tests (`test/unit/`)
**Purpose:** Test business logic and calculations in isolation.

**`meals_provider_test.dart`:**
- Mock meal structure validation
- Member ID referential integrity
- Meal count aggregation
- Meal rate calculation (total bazar / total meals)
- Model field types and enum values

**`settlement_provider_test.dart`:**
- Balance calculation formula: `opening + bazar - (meals * rate) - fixedShare`
- Pro-rata fixed cost splitting by active days
- Opening balance inclusion
- Inactive member handling

### Widget Tests (`test/widget/`)
**Purpose:** Verify individual widgets and screens render correctly.

**`screen_widget_tests.dart`:**
- Registry verification (27 screens, 17 features, unique routes)
- Per-screen instantiation via registry iterator
- Basic rendering (MaterialApp, Scaffold present)
- Feature screen counts
- Responsive rendering at different device sizes
- Test wrapper infrastructure validation

**`sync_status_widget_test.dart`:**
- Widget rendering (both `SyncIndicator` and `SyncStatusWidget`)
- Provider state: "Never synced", "Just now", "Xm ago", "Xh ago"
- Uses `ProviderContainer` directly for provider unit tests

**Known limitation:** `flutter_animate` causes timer issues in widget tests. The `error_screen_test.dart` is a placeholder with a skip comment. Use `pumpAndSettle` carefully or test animated widgets without animations.

### Integration Tests (`test/integration/`)
**Purpose:** Verify cross-feature data flows and business logic chains.

**`integration_test.dart` covers:**
- Entity relationships (Member <-> Meal, Member <-> Bazar referential integrity)
- Meal rate calculation chain (increase/decrease scenarios)
- Balance calculation end-to-end
- Fixed expense distribution (equal split, pro-rata, inactive exclusion)
- Date filtering (month boundaries, year boundaries)
- Calculation consistency (same inputs -> same outputs)
- Edge cases (empty lists, zero values, large/small amounts)
- Regression guards (mock data shape assertions)

**`app_flow_test.dart`:**
- Mock data structural validation
- Cross-reference integrity between fixtures
- Balance calculation produces finite results
- No duplicate IDs

**`page_coverage_test.dart`:**
- Screen registry populated (27 screens)
- All screen builders work
- All routes start with `/`
- All features have screens
- Route integrity (AppRoutes constants match registry)
- Navigation structure (5 bottom nav, auth flow)

## Writing New Tests

### New Unit Test
Place in `test/unit/{feature}/` or `test/unit/providers/`:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mess_manager/core/models/meal.dart';
import '../../helpers/mock_providers.dart';

void main() {
  group('MyFeature Tests', () {
    test('descriptive test name', () {
      final meals = createMockMeals(DateTime.now());
      // Act & Assert
      expect(result, expectedValue);
    });
  });
}
```

### New Widget Test
Place in `test/widget/widgets/` or `test/widget/screens/`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../helpers/test_app_wrapper.dart';

void main() {
  group('MyWidget Tests', () {
    testWidgets('renders basic structure', (tester) async {
      await tester.pumpWidget(
        const TestAppWrapper(child: MyWidget()),
      );
      expect(find.byType(MyWidget), findsOneWidget);
    });
  });
}
```

### New Smoke Test Addition
Add tests to existing `test/smoke/smoke_test.dart` in the appropriate group:

```dart
// In the '📦 Models' group:
test('NewModel instantiates correctly', () {
  NewModel? model;
  expect(() {
    model = NewModel(id: 'test', requiredField: 'value');
  }, returnsNormally);
  expect(model?.id, equals('test'));
});
```

## Coverage

**Requirements:** No minimum coverage target enforced

**Generate Coverage:**
```bash
make test-coverage        # Generates coverage/lcov.info
make coverage-html        # Generates coverage/html/index.html (requires genhtml)
```

**View Coverage:**
```bash
open coverage/html/index.html
```

## Common Assertion Patterns

### Numeric Assertions
```dart
expect(mealRate, closeTo(200.0, 0.01));  // Float comparison with tolerance
expect(balance, isNegative);
expect(balance, isPositive);
expect(balance.isFinite, isTrue);
expect(balance.isNaN, isFalse);
expect(amount, greaterThan(0));
```

### Model Assertions
```dart
expect(member, isA<Member>());
expect(member.id, isNotEmpty);
expect(member.email, isNull);
expect(member.preferences, isEmpty);
```

### Widget Assertions
```dart
expect(find.byType(MaterialApp), findsOneWidget);
expect(find.byType(Scaffold), findsWidgets);
expect(find.text('Never synced'), findsOneWidget);
expect(find.textContaining('Synced:'), findsOneWidget);
expect(find.byType(Tooltip), findsOneWidget);
```

### Constructor Safety
```dart
expect(() {
  Model(id: 'test', name: 'Test');
}, returnsNormally);
```

### Serialization Round-Trip
```dart
final json = original.toJson();
final restored = Model.fromJson(json);
expect(restored.id, equals(original.id));
expect(restored.amount, equals(original.amount));
```

### Referential Integrity
```dart
final memberIds = members.map((m) => m.id).toSet();
for (final meal in meals) {
  expect(
    memberIds.contains(meal.memberId),
    isTrue,
    reason: 'Meal ${meal.id} references non-existent member: ${meal.memberId}',
  );
}
```

## Known Testing Limitations

1. **flutter_animate in widget tests:** `flutter_animate` animations cause timer issues with `pumpAndSettle()`. Screens with heavy animations (e.g., `ErrorScreen`) have placeholder tests. Workaround: use `pump(duration)` instead of `pumpAndSettle()`.

2. **GoogleFonts requires network:** Theme tests that instantiate `AppTheme.darkTheme` may fail in CI without network access because `GoogleFonts` fetches fonts. The smoke test only checks that `AppTheme` class is accessible, not the full theme.

3. **Firebase not mocked:** Tests that touch Firebase providers are not currently covered. The demo mode / mock data fallback pattern means most features can be tested without Firebase.

4. **No E2E device tests in CI:** The Makefile has `test-android`, `test-ios`, `test-device` targets, but these require a connected device/emulator and are not run in CI.

5. **Widget rendering tests are shallow:** Screen widget tests verify instantiation and basic pump, not deep interaction. Most screens need provider mocks to render beyond a placeholder.

---

*Testing analysis: 2026-03-25*
