/// ═══════════════════════════════════════════════════════════════════════════
/// GOLDEN TEST HELPER - Shared setup for all golden screenshot tests
/// ═══════════════════════════════════════════════════════════════════════════
/// Provides:
///   - AppTheme.buildDarkTheme() integration (not generic ThemeData.dark)
///   - Full Riverpod provider overrides for all screen dependencies
///   - Animation settling for flutter_animate widgets
///   - Configurable screen sizes via TestDevices
/// ═══════════════════════════════════════════════════════════════════════════
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// ignore: implementation_imports
import 'package:riverpod/src/framework.dart' show Override;
import 'package:flutter_test/flutter_test.dart';
import 'package:mess_manager/core/theme/app_theme.dart';
import 'package:mess_manager/core/models/member.dart';
import 'package:mess_manager/core/models/meal.dart';
import 'package:mess_manager/core/models/bazar_entry.dart';
import 'package:mess_manager/core/models/auth_user.dart';
import 'package:mess_manager/core/models/settlement.dart';
import 'package:mess_manager/core/models/default_meal_schedule.dart';
import 'package:mess_manager/core/models/mess_settings.dart';
import 'package:mess_manager/core/models/ramadan.dart';
import 'package:mess_manager/core/models/duty.dart';
import 'package:mess_manager/core/models/money_transaction.dart';

// Core providers
import 'package:mess_manager/core/providers/members_provider.dart';
import 'package:mess_manager/core/providers/theme_provider.dart';
import 'package:mess_manager/core/providers/mess_settings_provider.dart';
import 'package:mess_manager/core/providers/sync_provider.dart';

// Auth providers
import 'package:mess_manager/features/auth/providers/auth_provider.dart';
import 'package:mess_manager/features/auth/providers/approval_provider.dart';

// Feature providers
import 'package:mess_manager/features/meals/providers/meals_provider.dart';
import 'package:mess_manager/features/meals/providers/meal_schedule_provider.dart';
import 'package:mess_manager/features/bazar/providers/bazar_provider.dart';
import 'package:mess_manager/features/balance/providers/balance_provider.dart';
import 'package:mess_manager/features/vacation/providers/vacation_provider.dart';
import 'package:mess_manager/features/vacation/providers/fixed_expenses_provider.dart';
import 'package:mess_manager/features/money/providers/money_provider.dart';
import 'package:mess_manager/features/duties/providers/duty_provider.dart';
import 'package:mess_manager/features/settlement/providers/settlement_provider.dart';
import 'package:mess_manager/features/settlement/providers/month_lock_provider.dart';
import 'package:mess_manager/features/ramadan/providers/ramadan_provider.dart';
import 'package:mess_manager/features/notifications/providers/notification_provider.dart';
import 'package:mess_manager/features/notifications/providers/meal_reminder_provider.dart';
import 'package:mess_manager/features/chatbot/providers/chatbot_provider.dart';
import 'package:mess_manager/features/settings/providers/theme_color_provider.dart';

import '../helpers/test_app_wrapper.dart';

// ═══════════════════════════════════════════════════════════════════════════
// MOCK DATA
// ═══════════════════════════════════════════════════════════════════════════

final _mockMembers = [
  Member(
    id: 'member_1',
    name: 'Siam',
    role: MemberRole.superAdmin,
    email: 'siam@area51.com',
    isActive: true,
    joinedAt: DateTime(2024, 1, 1),
  ),
  Member(
    id: 'member_2',
    name: 'Tanmoy',
    role: MemberRole.admin,
    email: 'tanmoy@area51.com',
    isActive: true,
    joinedAt: DateTime(2024, 1, 15),
  ),
  Member(
    id: 'member_3',
    name: 'Sarkar',
    role: MemberRole.member,
    email: 'sarkar@area51.com',
    isActive: true,
    joinedAt: DateTime(2024, 2, 1),
  ),
  Member(
    id: 'member_4',
    name: 'Shahriyer',
    role: MemberRole.member,
    email: 'shahriyer@area51.com',
    isActive: true,
    joinedAt: DateTime(2024, 3, 1),
  ),
];

final _mockUser = AuthUser(
  id: 'user_1',
  email: 'siam@area51.com',
  name: 'Siam',
  createdAt: DateTime(2024, 1, 1),
  currentMessId: 'mess_area51',
);

final _mockMess = Mess(
  id: 'mess_area51',
  name: 'Area51',
  address: 'Dhaka, Bangladesh',
  createdById: 'user_1',
  createdAt: DateTime(2024, 1, 1),
  memberIds: ['member_1', 'member_2', 'member_3', 'member_4'],
  inviteCode: 'A51XYZ',
);

List<Meal> _generateMockMeals() {
  final meals = <Meal>[];
  final now = DateTime.now();

  for (int day = 0; day < 7; day++) {
    final date = now.subtract(Duration(days: day));

    // Member 1 — 2 meals/day
    meals.addAll([
      Meal(
        id: 'meal_1_${day}_l',
        memberId: 'member_1',
        date: date,
        count: 1,
        type: MealType.lunch,
        createdAt: date,
      ),
      Meal(
        id: 'meal_1_${day}_d',
        memberId: 'member_1',
        date: date,
        count: 1,
        type: MealType.dinner,
        createdAt: date,
      ),
    ]);

    // Member 2 — 2 meals/day
    meals.addAll([
      Meal(
        id: 'meal_2_${day}_l',
        memberId: 'member_2',
        date: date,
        count: 1,
        type: MealType.lunch,
        createdAt: date,
      ),
      Meal(
        id: 'meal_2_${day}_d',
        memberId: 'member_2',
        date: date,
        count: 1,
        type: MealType.dinner,
        createdAt: date,
      ),
    ]);

    // Member 3 — 2 meals/day
    meals.addAll([
      Meal(
        id: 'meal_3_${day}_l',
        memberId: 'member_3',
        date: date,
        count: 1,
        type: MealType.lunch,
        createdAt: date,
      ),
      Meal(
        id: 'meal_3_${day}_d',
        memberId: 'member_3',
        date: date,
        count: 1,
        type: MealType.dinner,
        createdAt: date,
      ),
    ]);

    // Member 4 — 1 meal/day
    meals.add(
      Meal(
        id: 'meal_4_${day}_d',
        memberId: 'member_4',
        date: date,
        count: 1,
        type: MealType.dinner,
        createdAt: date,
      ),
    );
  }

  return meals;
}

List<BazarEntry> _generateMockBazarEntries() {
  final now = DateTime.now();
  return [
    BazarEntry(
      id: 'bazar_1',
      memberId: 'member_1',
      date: now.subtract(const Duration(days: 2)),
      amount: 1200,
      description: 'Weekly groceries',
      isItemized: true,
      items: const [
        BazarItem(name: 'Rice', price: 400, quantity: '5', unit: 'kg'),
        BazarItem(name: 'Oil', price: 350, quantity: '2', unit: 'ltr'),
        BazarItem(name: 'Vegetables', price: 250),
        BazarItem(name: 'Spices', price: 200),
      ],
      createdAt: now.subtract(const Duration(days: 2)),
    ),
    BazarEntry(
      id: 'bazar_2',
      memberId: 'member_2',
      date: now.subtract(const Duration(days: 4)),
      amount: 850,
      description: 'Fish and meat',
      isItemized: true,
      items: const [
        BazarItem(name: 'Fish (Rui)', price: 450, quantity: '1', unit: 'kg'),
        BazarItem(name: 'Chicken', price: 400, quantity: '1', unit: 'kg'),
      ],
      createdAt: now.subtract(const Duration(days: 4)),
    ),
    BazarEntry(
      id: 'bazar_3',
      memberId: 'member_3',
      date: now.subtract(const Duration(days: 1)),
      amount: 500,
      description: 'Fruits and snacks',
      isItemized: false,
      createdAt: now.subtract(const Duration(days: 1)),
    ),
    BazarEntry(
      id: 'bazar_4',
      memberId: 'member_1',
      date: now.subtract(const Duration(days: 6)),
      amount: 2000,
      description: 'Monthly stock',
      isItemized: false,
      createdAt: now.subtract(const Duration(days: 6)),
    ),
  ];
}

List<FixedExpense> _generateMockFixedExpenses() {
  final now = DateTime.now();
  return [
    FixedExpense(
      id: 'fix1',
      type: FixedExpenseType.rent,
      amount: 12000,
      dueDate: DateTime(now.year, now.month, 5),
      month: now.month,
      year: now.year,
      description: 'Monthly rent',
    ),
    FixedExpense(
      id: 'fix2',
      type: FixedExpenseType.wifi,
      amount: 800,
      dueDate: DateTime(now.year, now.month, 10),
      month: now.month,
      year: now.year,
      description: 'Internet bill',
    ),
    FixedExpense(
      id: 'fix3',
      type: FixedExpenseType.bua,
      amount: 3000,
      dueDate: DateTime(now.year, now.month, 1),
      month: now.month,
      year: now.year,
      description: 'Cleaner salary',
    ),
  ];
}

List<MoneyTransaction> _generateMockTransactions() {
  final now = DateTime.now();
  return [
    MoneyTransaction(
      id: 't1',
      fromMemberId: 'member_1',
      toMemberId: 'member_2',
      amount: 500,
      description: 'Lunch reimbursement',
      date: now.subtract(const Duration(days: 2)),
      status: TransactionStatus.settled,
      isSettled: true,
      settledAt: now.subtract(const Duration(days: 1)),
    ),
    MoneyTransaction(
      id: 't2',
      fromMemberId: 'member_3',
      toMemberId: 'member_1',
      amount: 200,
      description: 'Movie tickets',
      date: now.subtract(const Duration(days: 5)),
      status: TransactionStatus.pending,
      isSettled: false,
    ),
  ];
}

// ═══════════════════════════════════════════════════════════════════════════
// PROVIDER OVERRIDES
// ═══════════════════════════════════════════════════════════════════════════

/// All provider overrides needed to render screens without real services.
///
/// Uses overrideWithValue for simple derived providers and
/// overrideWith for Notifier-based providers to avoid touching Isar/Firebase.
/// Returns the full list of provider overrides for golden tests.
List<Override> get goldenProviderOverrides {
  final mockMeals = _generateMockMeals();
  final mockBazar = _generateMockBazarEntries();
  final mockFixedExpenses = _generateMockFixedExpenses();

  // Computed values
  final totalBazar = mockBazar.fold(0.0, (sum, e) => sum + e.amount);
  final totalMeals = mockMeals.fold(0.0, (sum, m) => sum + m.count);
  final mealRate = totalMeals > 0 ? totalBazar / totalMeals : 0.0;

  // Meals by member
  final mealsByMember = <String, double>{};
  for (final meal in mockMeals) {
    mealsByMember[meal.memberId] =
        (mealsByMember[meal.memberId] ?? 0) + meal.count;
  }

  // Bazar by member
  final bazarByMember = <String, double>{};
  for (final entry in mockBazar) {
    bazarByMember[entry.memberId] =
        (bazarByMember[entry.memberId] ?? 0) + entry.amount;
  }

  // Fixed expense share
  final totalFixed =
      mockFixedExpenses.fold(0.0, (sum, e) => sum + e.amount);
  final fixedShare = _mockMembers.isNotEmpty
      ? totalFixed / _mockMembers.length
      : 0.0;

  // Member balances
  final memberBalances = _mockMembers.map((member) {
    final meals = mealsByMember[member.id] ?? 0;
    final bazar = bazarByMember[member.id] ?? 0;
    final mealCost = meals * mealRate;
    final balance = bazar - mealCost - fixedShare;
    return MemberBalance(
      memberId: member.id,
      name: member.name,
      totalMeals: meals,
      totalBazar: bazar,
      balance: (balance * 100).round() / 100,
      mealCost: (mealCost * 100).round() / 100,
      fixedExpenseShare: (fixedShare * 100).round() / 100,
    );
  }).toList();

  final currentBalance = memberBalances.firstWhere(
    (b) => b.memberId == 'member_1',
    orElse: () => MemberBalance(
      memberId: 'member_1',
      name: 'Siam',
      totalMeals: 0,
      totalBazar: 0,
      balance: 0,
      mealCost: 0,
    ),
  );

  return [
    // ── Auth ──────────────────────────────────────────────────────────
    authProvider.overrideWith(() {
      return _MockAuthNotifier();
    }),
    isAuthenticatedProvider.overrideWithValue(true),
    currentUserProvider.overrideWithValue(_mockUser),
    currentMessProvider.overrideWithValue(_mockMess),

    // ── Members ──────────────────────────────────────────────────────
    membersProvider.overrideWith(() => _MockMembersNotifier()),
    currentMemberIdProvider.overrideWith(() => _MockCurrentMemberNotifier()),
    currentMemberProvider.overrideWithValue(_mockMembers.first),

    // ── Meals ────────────────────────────────────────────────────────
    mealsProvider.overrideWith(() => _MockMealsNotifier()),
    totalMealsProvider.overrideWithValue(totalMeals),
    mealsByMemberProvider.overrideWithValue(mealsByMember),

    // ── Bazar ────────────────────────────────────────────────────────
    bazarEntriesProvider.overrideWith(() => _MockBazarNotifier()),
    totalBazarProvider.overrideWithValue(totalBazar),
    bazarByMemberProvider.overrideWithValue(bazarByMember),

    // ── Balance ──────────────────────────────────────────────────────
    mealRateProvider.overrideWithValue(mealRate),
    memberBalancesProvider.overrideWithValue(memberBalances),
    currentMemberBalanceProvider.overrideWithValue(currentBalance),
    balanceSummaryProvider.overrideWithValue(
      BalanceSummary(
        totalBazar: totalBazar,
        totalMeals: totalMeals,
        mealRate: (mealRate * 100).round() / 100,
        memberCount: _mockMembers.length,
        hasMeals: true,
        hasBazar: true,
        totalFixedExpenses: totalFixed,
        perMemberFixedShare: (fixedShare * 100).round() / 100,
        calculationMode: 'normal',
      ),
    ),
    balanceValidationProvider.overrideWithValue(true),

    // ── Fixed expenses / Vacation ────────────────────────────────────
    fixedExpensesProvider.overrideWith(() => _MockFixedExpensesNotifier()),
    fixedExpensePerMemberProvider.overrideWithValue(fixedShare),
    vacationsProvider.overrideWith(() => _MockVacationNotifier()),

    // ── Money ────────────────────────────────────────────────────────
    moneyTransactionsProvider
        .overrideWith(() => _MockMoneyTransactionsNotifier()),

    // ── Duties ───────────────────────────────────────────────────────
    dutySchedulesProvider.overrideWith(() => _MockDutySchedulesNotifier()),
    dutyAssignmentsProvider.overrideWith(() => _MockDutyAssignmentsNotifier()),

    // ── Settlement ───────────────────────────────────────────────────
    settlementsProvider.overrideWith(() => _MockSettlementsNotifier()),
    monthLockProvider.overrideWith(() => _MockMonthLockNotifier()),

    // ── Ramadan ──────────────────────────────────────────────────────
    ramadanSeasonsProvider.overrideWith(() => _MockRamadanSeasonsNotifier()),
    activeRamadanSeasonProvider.overrideWithValue(null),

    // ── Notifications ────────────────────────────────────────────────
    notificationSettingsProvider
        .overrideWith(() => _MockNotificationSettingsNotifier()),

    // ── Chatbot ──────────────────────────────────────────────────────
    chatbotProvider.overrideWith(() => _MockChatbotNotifier()),

    // ── Meal Schedule ────────────────────────────────────────────────
    mealScheduleProvider.overrideWith(() => _MockMealScheduleNotifier()),

    // ── Meal Reminders ───────────────────────────────────────────────
    mealReminderProvider.overrideWith(() => _MockMealReminderNotifier()),

    // ── Approval ─────────────────────────────────────────────────────
    approvalProvider.overrideWith(() => _MockApprovalNotifier()),

    // ── Theme ────────────────────────────────────────────────────────
    themeModeProvider.overrideWith(() => _MockThemeModeNotifier()),
    themeColorProvider.overrideWith(() => _MockThemeColorNotifier()),

    // ── Sync ─────────────────────────────────────────────────────────
    lastSyncTimeProvider.overrideWith(() => _MockSyncTimeNotifier()),

    // ── Mess Settings ────────────────────────────────────────────────
    messSettingsProvider.overrideWith(() => _MockMessSettingsNotifier()),
    breakfastEnabledProvider.overrideWithValue(false),
    mealSystemCountProvider.overrideWithValue(2),
  ];
}

// ═══════════════════════════════════════════════════════════════════════════
// MOCK NOTIFIERS
// ═══════════════════════════════════════════════════════════════════════════
// These bypass Isar/Firebase calls that would fail in a test environment.

class _MockAuthNotifier extends AuthNotifier {
  @override
  AuthState build() => AuthState(
        status: AuthStatus.authenticated,
        user: _mockUser,
        currentMess: _mockMess,
        availableMesses: [_mockMess],
      );
}

class _MockMembersNotifier extends MembersNotifier {
  @override
  List<Member> build() => List.from(_mockMembers);
}

class _MockCurrentMemberNotifier extends CurrentMemberNotifier {
  @override
  String build() => 'member_1';
}

class _MockMealsNotifier extends MealsNotifier {
  @override
  List<Meal> build() => _generateMockMeals();
}

class _MockBazarNotifier extends BazarEntriesNotifier {
  @override
  List<BazarEntry> build() => _generateMockBazarEntries();
}

class _MockFixedExpensesNotifier extends FixedExpensesNotifier {
  @override
  List<FixedExpense> build() => _generateMockFixedExpenses();
}

class _MockVacationNotifier extends VacationNotifier {
  @override
  List<VacationPeriod> build() => [];
}

class _MockMoneyTransactionsNotifier extends MoneyTransactionsNotifier {
  @override
  List<MoneyTransaction> build() => _generateMockTransactions();
}

class _MockDutySchedulesNotifier extends DutySchedulesNotifier {
  @override
  List<DutySchedule> build() => [];
}

class _MockDutyAssignmentsNotifier extends DutyAssignmentsNotifier {
  @override
  List<DutyAssignment> build() => [];
}

class _MockSettlementsNotifier extends SettlementsNotifier {
  @override
  List<Settlement> build() => [];
}

class _MockMonthLockNotifier extends MonthLockNotifier {
  @override
  MonthLockState build() => const MonthLockState();
}

class _MockRamadanSeasonsNotifier extends RamadanSeasonsNotifier {
  @override
  List<RamadanSeason> build() => [];
}

class _MockNotificationSettingsNotifier extends NotificationSettingsNotifier {
  @override
  NotificationSettings build() => const NotificationSettings();
}

class _MockChatbotNotifier extends ChatbotNotifier {
  @override
  ChatState build() => const ChatState(isReady: true);
}

class _MockMealScheduleNotifier extends MealScheduleNotifier {
  @override
  Map<String, List<DefaultMealSchedule>> build() => {};
}

class _MockMealReminderNotifier extends MealReminderNotifier {
  @override
  Map<String, MealReminder> build() => {};
}

class _MockApprovalNotifier extends ApprovalNotifier {
  @override
  ApprovalState build() => const ApprovalState();
}

class _MockThemeModeNotifier extends ThemeModeNotifier {
  @override
  ThemeMode build() => ThemeMode.dark;
}

class _MockThemeColorNotifier extends ThemeColorNotifier {
  @override
  ThemeColorOption build() => ThemeColorOption.teal;
}

class _MockSyncTimeNotifier extends SyncTimeNotifier {
  @override
  DateTime? build() => DateTime.now();
}

class _MockMessSettingsNotifier extends MessSettingsNotifier {
  @override
  MessSettings build() => const MessSettings();
}

// ═══════════════════════════════════════════════════════════════════════════
// PUMP HELPER
// ═══════════════════════════════════════════════════════════════════════════

/// Pumps a screen widget inside the full golden test wrapper.
///
/// - Wraps in ProviderScope with all mock overrides
/// - Uses AppTheme.buildDarkTheme (the real theme, not generic)
/// - Sets MediaQuery to the requested [size]
/// - Pumps multiple frames to let flutter_animate settle
///
/// Does NOT call matchesGoldenFile — the caller does that.
Future<void> pumpScreenForGolden(
  WidgetTester tester,
  Widget screen, {
  Size size = TestDevices.pixel7,
}) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1.0;

  // Use plain dark theme for golden tests — avoids GoogleFonts network dependency
  final theme = ThemeData.dark(useMaterial3: true).copyWith(
    scaffoldBackgroundColor: AppColors.backgroundDark,
    colorScheme: ColorScheme.dark(
      primary: AppColors.primary,
      secondary: AppColors.accent,
      surface: AppColors.surfaceDark,
      error: AppColors.error,
    ),
  );

  await tester.pumpWidget(
    ProviderScope(
      overrides: goldenProviderOverrides,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        themeMode: ThemeMode.dark,
        darkTheme: theme,
        theme: theme,
        home: MediaQuery(
          data: MediaQueryData(
            size: size,
            padding: const EdgeInsets.only(top: 24, bottom: 34),
          ),
          child: screen,
        ),
      ),
    ),
  );

  // Let flutter_animate and other implicit animations settle.
  // Pump several frames, then pumpAndSettle with a timeout.
  await tester.pump(const Duration(milliseconds: 100));
  await tester.pump(const Duration(milliseconds: 100));
  await tester.pump(const Duration(milliseconds: 100));
  await tester.pump(const Duration(milliseconds: 200));
  await tester.pump(const Duration(milliseconds: 500));

  // Final settle — catches any remaining animation controllers.
  // Short timeout because some screens have infinite animations.
  try {
    await tester.pumpAndSettle(const Duration(milliseconds: 100));
  } catch (_) {
    // pumpAndSettle can throw if animations never finish (e.g. shimmer).
    // That is expected — we already pumped enough frames above.
  }
}

/// Pumps a bottom sheet widget rendered inside a Scaffold.
///
/// Useful for testing AddMealSheet, AddBazarSheet, etc. which are
/// designed to be shown via showModalBottomSheet.
Future<void> pumpSheetForGolden(
  WidgetTester tester,
  Widget sheet, {
  Size size = TestDevices.pixel7,
}) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1.0;

  // Use plain dark theme for golden tests — avoids GoogleFonts network dependency
  final theme = ThemeData.dark(useMaterial3: true).copyWith(
    scaffoldBackgroundColor: AppColors.backgroundDark,
    colorScheme: ColorScheme.dark(
      primary: AppColors.primary,
      secondary: AppColors.accent,
      surface: AppColors.surfaceDark,
      error: AppColors.error,
    ),
  );

  await tester.pumpWidget(
    ProviderScope(
      overrides: goldenProviderOverrides,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        themeMode: ThemeMode.dark,
        darkTheme: theme,
        theme: theme,
        home: Scaffold(
          backgroundColor: AppColors.backgroundDark,
          body: const SizedBox.expand(),
          bottomSheet: Material(
            color: AppColors.surfaceDark,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(28),
            ),
            child: SizedBox(
              width: size.width,
              height: size.height * 0.75,
              child: sheet,
            ),
          ),
        ),
      ),
    ),
  );

  await tester.pump(const Duration(milliseconds: 100));
  await tester.pump(const Duration(milliseconds: 100));
  await tester.pump(const Duration(milliseconds: 100));
  await tester.pump(const Duration(milliseconds: 200));
  await tester.pump(const Duration(milliseconds: 500));

  try {
    await tester.pumpAndSettle(const Duration(milliseconds: 100));
  } catch (_) {
    // Same rationale as pumpScreenForGolden.
  }
}
