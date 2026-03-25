# Coding Conventions

**Analysis Date:** 2026-03-25

## Naming Patterns

**Files:**
- Dart files: `snake_case.dart` -- e.g., `app_theme.dart`, `bazar_provider.dart`, `add_meal_sheet.dart`
- Generated files: `{name}.freezed.dart`, `{name}.g.dart` -- always co-located with source
- Test files: `{name}_test.dart` -- e.g., `meals_provider_test.dart`, `smoke_test.dart`
- Barrel files: `widgets.dart` -- re-exports all widgets from a directory

**Classes:**
- Widgets: `PascalCase` matching the file name -- `DashboardScreen`, `AppPrimaryButton`, `GlassCard`
- Providers: `camelCase` with `Provider` suffix -- `bazarEntriesProvider`, `mealsProvider`, `currentMemberBalanceProvider`
- Notifiers: `PascalCase` with `Notifier` suffix -- `BazarEntriesNotifier`, `MealsNotifier`
- Models: `PascalCase` matching file name -- `Member`, `Meal`, `BazarEntry`
- Enums: `PascalCase` with `camelCase` values -- `MemberRole.superAdmin`, `MealType.breakfast`

**Functions:**
- Private helpers: `_camelCase` with underscore prefix -- `_generateSampleMeals()`, `_buildHeader()`
- Build methods in widgets: `_buildSectionName()` -- `_buildHeroBalance()`, `_buildQuickActions()`
- Factory constructors: `ClassName.descriptiveName` -- `EmptyStateWidget.noMeals()`, `AppBadge.success()`

**Variables:**
- Local: `camelCase` -- `currentBalance`, `mealRate`, `todayMealCount`
- Constants: `camelCase` within class -- `AppSpacing.radiusMd`, `AppColors.primary`

**Types:**
- Use Freezed `@freezed sealed class` pattern for all data models
- Enums are standalone, not nested in classes

## Code Style

**Formatting:**
- Dart default formatter (no custom `.prettierrc` or equivalent)
- Lint rules from `package:flutter_lints/flutter.yaml` via `analysis_options.yaml`
- No custom lint rules enabled beyond the base set

**Linting:**
- Tool: `flutter_lints` 6.x
- Config: `analysis_options.yaml`
- Run: `flutter analyze`
- No custom rules currently enforced -- the `rules:` section is empty with commented-out examples

**Alpha Values:**
- Use `Color.withValues(alpha: 0.5)` (NOT deprecated `withOpacity`)
- This is enforced throughout the codebase

**const Constructors:**
- Use `const` for constructors wherever possible
- Widget constructors: `const MyWidget({super.key})`
- Use `super.key` instead of `Key? key` parameter

## Import Organization

**Order:**
1. `dart:` core libraries (`dart:ui`, `dart:async`)
2. `package:flutter/` framework imports
3. `package:` third-party packages (`flutter_riverpod`, `flutter_animate`, `go_router`, etc.)
4. `package:mess_manager/` internal project imports (absolute paths)
5. Relative imports for test helpers only (e.g., `../../helpers/mock_providers.dart`)

**Path Style:**
- Production code: Always absolute imports -- `package:mess_manager/core/theme/app_theme.dart`
- Test code: Relative imports for test helpers -- `../../helpers/test_app_wrapper.dart`
- Never mix relative and absolute imports in the same file

**Path Aliases:**
- None configured. Use full `package:mess_manager/` paths.

## Widget Patterns

### Screen Widget Pattern
All screens use `ConsumerWidget` (for Riverpod integration):

```dart
class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(someProvider);
    return Scaffold(
      body: Stack(
        children: [
          const _AuroraMesh(),      // Background effect
          SafeArea(
            child: SingleChildScrollView(
              // Screen content
            ),
          ),
        ],
      ),
    );
  }
}
```

### Screen Structure (No AppBar)
Screens do NOT use standard `AppBar`. Instead they use custom Stack-based headers:
- Background layer: `Stack` with gradient/aurora mesh background
- Content: `SafeArea` > `SingleChildScrollView` or `CustomScrollView`
- Headers: Custom `Row` with icon + title, built as private `_build*` methods

### Section Labels
Standard section label pattern used across screens:

```dart
Widget _sectionLabel(BuildContext context, String text) {
  return Row(
    children: [
      Container(
        width: 3, height: 14,
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: AppColors.gradientPrimary),
          borderRadius: BorderRadius.circular(2),
        ),
      ),
      const Gap(8),
      Text(
        text.toUpperCase(),
        style: AppTypography.labelSmall.copyWith(
          color: context.textMuted,
          letterSpacing: 1.5,
          fontSize: 11,
        ),
      ),
    ],
  );
}
```

### Provider Pattern (Riverpod 3.x Notifier)
Use `Notifier` / `NotifierProvider` (NOT legacy `StateNotifier`):

```dart
final bazarEntriesProvider =
    NotifierProvider<BazarEntriesNotifier, List<BazarEntry>>(
      BazarEntriesNotifier.new,
    );

class BazarEntriesNotifier extends Notifier<List<BazarEntry>> {
  @override
  List<BazarEntry> build() {
    final saved = IsarService.getAllBazarEntries();
    if (saved.isNotEmpty) return saved;
    return _generateSampleEntries(); // Fallback
  }

  void addEntry(BazarEntry entry) {
    state = [...state, entry];
    IsarService.saveBazarEntry(entry);
  }

  void removeEntry(String id) {
    state = state.where((e) => e.id != id).toList();
    IsarService.deleteBazarEntry(id);
  }

  void updateEntry(BazarEntry entry) {
    state = [
      for (final e in state)
        if (e.id == entry.id) entry else e,
    ];
    IsarService.saveBazarEntry(entry);
  }
}
```

### Freezed Model Pattern
All data models use `@freezed sealed class`:

```dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'member.freezed.dart';
part 'member.g.dart';

@freezed
sealed class Member with _$Member {
  const factory Member({
    required String id,
    required String name,
    @Default(MemberRole.member) MemberRole role,
    @Default(true) bool isActive,
    @Default(0.0) double balance,
    String? email,
    DateTime? joinedAt,
  }) = _Member;

  factory Member.fromJson(Map<String, dynamic> json) =>
      _$MemberFromJson(json);
}
```

Key rules:
- Always use `@Default()` for optional fields with defaults
- Required fields use `required` keyword
- Nullable optional fields use `Type?` without default
- Always include `fromJson` factory
- Generated files: `.freezed.dart` + `.g.dart`

### Role-Based Access Pattern
Use `RoleGate` widget for conditional rendering by user role:

```dart
// Named factory constructors for common checks
RoleGate.admin(child: EditButton()),
RoleGate.meal(child: AddMealButton()),
RoleGate.bazar(child: AddBazarButton()),

// Custom permission check
RoleGate(
  permission: canManageMembersProvider,
  child: MemberManagementPanel(),
  fallback: const SizedBox.shrink(),
),
```

Location: `lib/core/widgets/role_gate.dart`

## Theme Usage

### Context Extensions
Access theme values through `BuildContext` extensions (NOT raw `Theme.of`):

```dart
// Use these (defined in lib/core/theme/app_theme.dart)
context.textPrimary      // Primary text color (theme-aware)
context.textSecondary    // Secondary text color
context.textMuted        // Muted text color
context.cardColor        // Card background
context.surfaceColor     // Surface background
context.borderColor      // Border color
context.background       // Scaffold background
context.isDark           // Boolean for dark mode check
context.colors           // Full ColorScheme
context.theme            // Full ThemeData
```

### Design Token Classes
- `AppColors` -- all color constants (`lib/core/theme/app_theme.dart`)
- `AppSpacing` -- spacing tokens on 4px grid, border radii, shadows, glassTile helpers
- `AppTypography` -- text styles (Poppins headings, Inter body, JetBrains Mono for numbers)

### Color Usage Rules
- Never hardcode colors inline -- always use `AppColors.*` or `context.*` accessors
- Status colors: `AppColors.success`, `.warning`, `.error`, `.info`
- Feature colors: `AppColors.mealColor` (purple), `.bazarColor` (cyan)
- Money colors: `AppColors.moneyPositive` (green), `.moneyNegative` (red)

### Typography Usage
- Headings: `AppTypography.headlineLarge`, `.headlineMedium`, `.headlineSmall`
- Body text: `AppTypography.bodyLarge`, `.bodyMedium`, `.bodySmall`
- Labels: `AppTypography.labelLarge`, `.labelMedium`, `.labelSmall`
- Monetary values: `AppTypography.mono`, `.monoLarge` (JetBrains Mono)
- Always apply color via `.copyWith(color: context.textPrimary)`

### Spacing
- Use `Gap` widget from the `gap` package instead of `SizedBox`
- Use `AppSpacing` constants: `xs(4)`, `sm(8)`, `md(16)`, `lg(24)`, `xl(32)`, `xxl(48)`, `xxxl(64)`
- Border radii: `radiusXs(6)`, `radiusSm(10)`, `radiusMd(14)`, `radiusLg(20)`, `radiusXl(28)`, `radiusFull(9999)`

## Animation Patterns

### flutter_animate Usage
Use `flutter_animate` extension methods for all micro-interactions:

```dart
// Staggered reveal (common pattern)
Text('Title').animate().fadeIn(delay: 100.ms),
Text('Subtitle').animate().fadeIn(delay: 200.ms),
ActionButton().animate().fadeIn(delay: 300.ms).scale(begin: Offset(0.9, 0.9)),

// Looping shimmer on CTA buttons
button.animate(onPlay: (c) => c.repeat())
    .shimmer(duration: 2.seconds, color: Colors.white.withValues(alpha: 0.3));

// Breathing/floating effect for decorative orbs
orb.animate(onPlay: (c) => c.repeat(reverse: true))
    .scaleXY(begin: 0.8, end: 1.2, duration: 3.seconds);

// Dialog entrance
dialog.animate().fadeIn(duration: 200.ms)
    .scale(begin: const Offset(0.95, 0.95));

// Error shake
widget.animate().shake(duration: 400.ms);

// Shimmer loading placeholder
container.animate(onPlay: (c) => c.repeat())
    .shimmer(duration: 1200.ms, color: context.borderColor);
```

### Haptic Feedback
Always pair user interactions with haptic feedback via `HapticService`:
- `HapticService.lightTap()` -- list item taps, secondary buttons
- `HapticService.buttonPress()` -- primary buttons, confirm actions
- `HapticService.modalOpen()` -- opening sheets/dialogs
- `HapticService.warning()` -- danger actions
- `HapticService.success()` -- completion animations
- `HapticService.error()` -- error states
- `HapticService.bouncyTap()` -- card press-down micro-interactions

### Card Press Micro-interaction
Tappable cards use scale-down animation on press via `_CardTappable`:
- Press: scale to 0.975 over 80ms
- Release: scale back to 1.0 over 120ms
- Combined with `HapticService.lightTap()`

## Glassmorphism Pattern

### Standard Glass Card
Use `GlassCard` from `lib/core/widgets/app_components.dart` for hero sections:

```dart
GlassCard(
  blur: 16,           // BackdropFilter sigma
  opacity: 0.05,      // White overlay alpha
  padding: EdgeInsets.all(AppSpacing.lg),
  child: content,
)
```

### Standard AppCard
Use `AppCard` for regular content cards (theme-aware, not glass):

```dart
AppCard(
  padding: EdgeInsets.all(AppSpacing.md),
  onTap: () => handleTap(),
  child: content,
)
```

### Glass Tile Helper
For inline glass decorations, use `AppSpacing.glassTile()`:

```dart
Container(
  decoration: AppSpacing.glassTile(radius: AppSpacing.radiusMd),
  child: content,
)
```

## Bottom Sheet Pattern

Use `AppSheet.show()` for all bottom sheets (from `lib/core/widgets/app_components.dart`):

```dart
AppSheet.show(
  context: context,
  title: 'Add Bazar Entry',
  child: AddBazarForm(),
);
```

Alternative: `showAppSheet()` function from `lib/core/widgets/app_sheet.dart` for more control:

```dart
showAppSheet(
  context: context,
  title: 'Options',
  isScrollControlled: true,
  child: content,
);
```

## Toast/Notification Pattern

Use convenience wrappers from `lib/core/widgets/app_components.dart`:

```dart
showSuccessToast(context, 'Entry saved!');
showErrorToast(context, 'Failed to save');
showInfoToast(context, 'Syncing...');
showWarningToast(context, 'Are you sure?');
```

These automatically trigger appropriate haptic feedback.

## Error Handling

**Patterns:**
- Providers: Load from Isar first, fall back to sample data if empty
- Optimistic UI: Update state immediately, revert on failure
- Empty states: Use `EmptyStateWidget` factory constructors (`.noMeals()`, `.noBazar()`, `.error()`)
- Input validation: Service layer validates, models accept any value (Freezed models are structural, not validated)

## Logging

**Framework:** `logger` package (imported but used sparingly)

**Debug Prints:**
- Router debugging: `debugPrint('GoRouter: ...')` for navigation diagnostics
- Use `kDebugMode` guard for debug-only code

## Comments

**When to Comment:**
- File-level doc comments with `///` for purpose and usage examples
- Section dividers using `// ===...===` horizontal rules with section titles
- Enum value comments for business meaning (inline)
- Doc comments on public APIs and widget classes

**Style:**
```dart
// ═══════════════════════════════════════════════════════════════════════════
// SECTION TITLE
// ═══════════════════════════════════════════════════════════════════════════
```

## Module Design

**Exports:**
- Core widgets barrel file: `lib/core/widgets/widgets.dart` re-exports `app_components.dart`, `animated_widgets.dart`, `hook_base.dart`
- Shared widgets barrel: `lib/shared/widgets/widgets.dart`
- No feature-level barrel files observed

**Custom Components Library:**
| Component | File | Purpose |
|-----------|------|---------|
| `GlassCard` | `lib/core/widgets/app_components.dart` | Glassmorphism card |
| `AppCard` | `lib/core/widgets/app_components.dart` | Standard themed card |
| `AppPrimaryButton` | `lib/core/widgets/app_components.dart` | Primary CTA button |
| `AppSecondaryButton` | `lib/core/widgets/app_components.dart` | Outlined button |
| `AppDangerButton` | `lib/core/widgets/app_components.dart` | Destructive action button |
| `AppDialog` | `lib/core/widgets/app_components.dart` | Modal dialog |
| `AppConfirmDialog` | `lib/core/widgets/app_components.dart` | Yes/no confirmation |
| `AppSheet` | `lib/core/widgets/app_components.dart` | Bottom sheet |
| `AppInput` | `lib/core/widgets/app_components.dart` | Text input with glow |
| `AppBadge` | `lib/core/widgets/app_components.dart` | Status pill badge |
| `AppMemberAvatar` | `lib/core/widgets/app_components.dart` | Avatar with initials |
| `AppShimmerLoader` | `lib/core/widgets/app_components.dart` | Shimmer placeholder |
| `RoleGate` | `lib/core/widgets/role_gate.dart` | Permission-gated content |
| `SpeedDialFAB` | `lib/core/widgets/speed_dial_fab.dart` | Expandable FAB |
| `EmptyStateWidget` | `lib/core/widgets/animated_widgets.dart` | Empty state display |
| `MoneyText` | `lib/core/widgets/animated_widgets.dart` | Currency display |
| `TappableScale` | `lib/shared/widgets/micro_interactions.dart` | Tap scale effect |
| `AppFormTextField` | `lib/core/widgets/form_widgets.dart` | Form builder field |
| `SkeletonCard` | `lib/core/widgets/skeleton_widgets.dart` | Skeleton loading |
| `ErrorScreen` | `lib/core/widgets/error_screen.dart` | 404 error page |

## Icons

Use `LucideIcons` from the `lucide_icons` package everywhere. Do NOT use `Icons.*` (Material) except in skeleton/fallback widgets.

```dart
import 'package:lucide_icons/lucide_icons.dart';

Icon(LucideIcons.plus, size: 18)
Icon(LucideIcons.x, size: 20)
Icon(LucideIcons.alertTriangle, size: 20)
```

---

*Convention analysis: 2026-03-25*
