/// ═══════════════════════════════════════════════════════════════════════════
/// ADVANCED INTEGRATION TEST SUITE
/// ═══════════════════════════════════════════════════════════════════════════
/// Purpose: Verify cross-feature integrations work correctly.
/// Prevents "integration hell" by catching cross-boundary issues early.
///
/// Categories:
///   1. Entity Relationships - Model references
///   2. Business Logic Flow - Calculation chains
///   3. Data Aggregation - Summaries and rollups
///   4. State Consistency - Provider interactions
///   5. Edge Case Handling - Boundaries and limits
///   6. Regression Prevention - Known issue guards
/// ═══════════════════════════════════════════════════════════════════════════

import 'package:flutter_test/flutter_test.dart';

import 'package:mess_manager/core/models/member.dart';
import 'package:mess_manager/core/models/meal.dart';
import 'package:mess_manager/core/models/bazar_entry.dart';
import 'package:mess_manager/features/vacation/providers/fixed_expenses_provider.dart';

import '../helpers/mock_providers.dart';

void main() {
  // ═══════════════════════════════════════════════════════════════════════════
  // CATEGORY 1: ENTITY RELATIONSHIPS
  // ═══════════════════════════════════════════════════════════════════════════
  group('🔗 Integration - Member ↔ Meal Integrity', () {
    test('All meals reference existing member IDs', () {
      final members = mockMembers;
      final meals = createMockMeals(DateTime.now());
      final memberIds = members.map((m) => m.id).toSet();

      for (final meal in meals) {
        expect(
          memberIds.contains(meal.memberId),
          isTrue,
          reason:
              'Meal ${meal.id} references non-existent member: ${meal.memberId}',
        );
      }
    });

    test('Meal count aggregation per member is accurate', () {
      final meals = createMockMeals(DateTime.now());

      // Manual aggregation
      final mealsByMember = <String, int>{};
      for (final meal in meals) {
        mealsByMember[meal.memberId] =
            (mealsByMember[meal.memberId] ?? 0) + meal.count;
      }

      // Verify expected values from mock data
      expect(mealsByMember['member_1'], equals(2)); // breakfast(1) + lunch(1)
      expect(mealsByMember['member_2'], equals(2)); // dinner(2)
      expect(mealsByMember.containsKey('member_3'), isFalse); // No meals
    });

    test('Total meal count matches sum of individual counts', () {
      final meals = createMockMeals(DateTime.now());

      final totalFromSum = meals.fold(0, (sum, m) => sum + m.count);
      final totalFromList = meals.map((m) => m.count).reduce((a, b) => a + b);

      expect(totalFromSum, equals(totalFromList));
      expect(totalFromSum, equals(4)); // 1 + 1 + 2
    });
  });

  group('🔗 Integration - Member ↔ Bazar Integrity', () {
    test('All bazar entries reference existing member IDs', () {
      final members = mockMembers;
      final entries = createMockBazarEntries(DateTime.now());
      final memberIds = members.map((m) => m.id).toSet();

      for (final entry in entries) {
        expect(
          memberIds.contains(entry.memberId),
          isTrue,
          reason:
              'Bazar ${entry.id} references non-existent member: ${entry.memberId}',
        );
      }
    });

    test('Bazar amount aggregation per member is accurate', () {
      final entries = createMockBazarEntries(DateTime.now());

      final bazarByMember = <String, double>{};
      for (final entry in entries) {
        bazarByMember[entry.memberId] =
            (bazarByMember[entry.memberId] ?? 0) + entry.amount;
      }

      expect(bazarByMember['member_1'], closeTo(500.0, 0.01));
      expect(bazarByMember['member_2'], closeTo(300.0, 0.01));
    });

    test('Total bazar amount matches sum of entries', () {
      final entries = createMockBazarEntries(DateTime.now());

      final total = entries.fold(0.0, (sum, e) => sum + e.amount);

      expect(total, closeTo(800.0, 0.01)); // 500 + 300
    });

    test('Itemized entry sum matches entry amount', () {
      final entries = createMockBazarEntries(DateTime.now());

      for (final entry in entries.where((e) => e.isItemized)) {
        final itemSum = entry.items.fold(0.0, (sum, i) => sum + i.price);
        expect(
          itemSum,
          closeTo(entry.amount, 0.01),
          reason:
              'Entry ${entry.id} items sum (${itemSum}) != amount (${entry.amount})',
        );
      }
    });
  });

  // ═══════════════════════════════════════════════════════════════════════════
  // CATEGORY 2: BUSINESS LOGIC FLOW
  // ═══════════════════════════════════════════════════════════════════════════
  group('⚙️ Integration - Meal Rate Calculation', () {
    test('Meal rate = Total Bazar / Total Meals', () {
      final meals = createMockMeals(DateTime.now());
      final bazar = createMockBazarEntries(DateTime.now());

      final totalBazar = bazar.fold(0.0, (sum, e) => sum + e.amount);
      final totalMeals = meals.fold(0, (sum, m) => sum + m.count);

      final expectedRate = totalBazar / totalMeals;
      final actualRate = calculateMealRate(meals, bazar);

      expect(actualRate, closeTo(expectedRate, 0.01));
      expect(actualRate, closeTo(200.0, 0.01)); // 800/4 = 200
    });

    test('Meal rate is zero when no meals exist', () {
      final bazar = createMockBazarEntries(DateTime.now());

      final rate = calculateMealRate([], bazar);

      expect(rate, equals(0.0));
    });

    test('Meal rate increases when bazar increases', () {
      final meals = createMockMeals(DateTime.now());
      final bazar = createMockBazarEntries(DateTime.now());

      final originalRate = calculateMealRate(meals, bazar);

      // Add more bazar
      final moreBazar = [
        ...bazar,
        BazarEntry(
          id: 'extra',
          memberId: 'member_1',
          amount: 400.0,
          date: DateTime.now(),
        ),
      ];

      final newRate = calculateMealRate(meals, moreBazar);

      expect(newRate, greaterThan(originalRate));
      expect(newRate, closeTo(300.0, 0.01)); // 1200/4 = 300
    });

    test('Meal rate decreases when meals increase', () {
      final meals = createMockMeals(DateTime.now());
      final bazar = createMockBazarEntries(DateTime.now());

      final originalRate = calculateMealRate(meals, bazar);

      // Add more meals
      final moreMeals = [
        ...meals,
        Meal(
          id: 'extra',
          memberId: 'member_3',
          type: MealType.dinner,
          count: 4,
          date: DateTime.now(),
        ),
      ];

      final newRate = calculateMealRate(moreMeals, bazar);

      expect(newRate, lessThan(originalRate));
      expect(newRate, closeTo(100.0, 0.01)); // 800/8 = 100
    });
  });

  group('⚙️ Integration - Balance Calculation', () {
    test('Balance = Bazar - (Meals × Rate) - Fixed Share', () {
      final meals = createMockMeals(DateTime.now());
      final bazar = createMockBazarEntries(DateTime.now());
      final mealRate = calculateMealRate(meals, bazar); // 200

      // member_1: bazar=500, meals=2, fixed=1200
      // Balance = 500 - (2 × 200) - 1200 = 500 - 400 - 1200 = -1100
      final balance = calculateMemberBalance(
        memberId: 'member_1',
        bazarEntries: bazar,
        meals: meals,
        mealRate: mealRate,
        fixedShare: 1200.0,
      );

      expect(balance, closeTo(-1100.0, 0.01));
    });

    test('Opening balance is included in calculation', () {
      final meals = createMockMeals(DateTime.now());
      final bazar = createMockBazarEntries(DateTime.now());
      final mealRate = calculateMealRate(meals, bazar);

      final withoutOpening = calculateMemberBalance(
        memberId: 'member_1',
        bazarEntries: bazar,
        meals: meals,
        mealRate: mealRate,
        fixedShare: 1200.0,
        openingBalance: 0.0,
      );

      final withOpening = calculateMemberBalance(
        memberId: 'member_1',
        bazarEntries: bazar,
        meals: meals,
        mealRate: mealRate,
        fixedShare: 1200.0,
        openingBalance: 500.0,
      );

      expect(withOpening - withoutOpening, closeTo(500.0, 0.01));
    });

    test('Member with no activity has negative balance from fixed costs', () {
      final meals = createMockMeals(DateTime.now());
      final bazar = createMockBazarEntries(DateTime.now());
      final mealRate = calculateMealRate(meals, bazar);

      // member_3 has no bazar, no meals
      final balance = calculateMemberBalance(
        memberId: 'member_3',
        bazarEntries: bazar,
        meals: meals,
        mealRate: mealRate,
        fixedShare: 1200.0,
      );

      expect(balance, closeTo(-1200.0, 0.01));
      expect(balance, isNegative);
    });

    test('Higher bazar contribution leads to higher balance', () {
      final meals = createMockMeals(DateTime.now());
      final bazar = createMockBazarEntries(DateTime.now());
      final mealRate = calculateMealRate(meals, bazar);

      // Both have same meal count (2), but different bazar
      final member1Balance = calculateMemberBalance(
        memberId: 'member_1', // bazar=500
        bazarEntries: bazar,
        meals: meals,
        mealRate: mealRate,
        fixedShare: 1200.0,
      );

      final member2Balance = calculateMemberBalance(
        memberId: 'member_2', // bazar=300
        bazarEntries: bazar,
        meals: meals,
        mealRate: mealRate,
        fixedShare: 1200.0,
      );

      expect(member1Balance, greaterThan(member2Balance));
    });
  });

  // ═══════════════════════════════════════════════════════════════════════════
  // CATEGORY 3: DATA AGGREGATION
  // ═══════════════════════════════════════════════════════════════════════════
  group('� Integration - Fixed Expense Distribution', () {
    test('Fixed expenses split equally among active members', () {
      final expenses = createMockFixedExpenses();
      final totalFixed = expenses.fold(0.0, (sum, e) => sum + e.amount);

      final activeMembers = mockMembers.where((m) => m.isActive).toList();
      final sharePerMember = totalFixed / activeMembers.length;

      expect(totalFixed, closeTo(3600.0, 0.01)); // rent + wifi
      expect(activeMembers.length, equals(3));
      expect(sharePerMember, closeTo(1200.0, 0.01));
    });

    test('Inactive members are excluded from fixed expense split', () {
      final membersWithInactive = mockMembers
          .map((m) => m.id == 'member_3' ? m.copyWith(isActive: false) : m)
          .toList();

      final expenses = createMockFixedExpenses();
      final totalFixed = expenses.fold(0.0, (sum, e) => sum + e.amount);

      final activeMembers = membersWithInactive
          .where((m) => m.isActive)
          .toList();
      final sharePerMember = totalFixed / activeMembers.length;

      expect(activeMembers.length, equals(2));
      expect(sharePerMember, closeTo(1800.0, 0.01));
    });

    test('Total of all member shares equals total fixed expenses', () {
      final expenses = createMockFixedExpenses();
      final totalFixed = expenses.fold(0.0, (sum, e) => sum + e.amount);

      final activeCount = mockMembers.where((m) => m.isActive).length;
      final sharePerMember = totalFixed / activeCount;
      final totalShares = sharePerMember * activeCount;

      expect(totalShares, closeTo(totalFixed, 0.01));
    });
  });

  group('� Integration - Date Filtering', () {
    test('Current month filter excludes previous month data', () {
      final now = DateTime.now();
      final thisMonth = DateTime(now.year, now.month, 15);
      final lastMonth = DateTime(now.year, now.month - 1, 15);

      final allMeals = [
        ...createMockMeals(thisMonth),
        Meal(
          id: 'old_meal',
          memberId: 'member_1',
          type: MealType.lunch,
          count: 10, // Large count to notice if included
          date: lastMonth,
        ),
      ];

      final currentMonthMeals = allMeals
          .where((m) => m.date.year == now.year && m.date.month == now.month)
          .toList();

      expect(currentMonthMeals.length, equals(3));
      expect(currentMonthMeals.every((m) => m.date.month == now.month), isTrue);
    });

    test('Year boundary is handled correctly', () {
      final december = DateTime(2024, 12, 31);
      final january = DateTime(2025, 1, 1);

      final allEntries = [
        BazarEntry(id: 'dec', memberId: 'm1', amount: 100, date: december),
        BazarEntry(id: 'jan', memberId: 'm1', amount: 200, date: january),
      ];

      final dec2024 = allEntries
          .where((e) => e.date.year == 2024 && e.date.month == 12)
          .toList();

      final jan2025 = allEntries
          .where((e) => e.date.year == 2025 && e.date.month == 1)
          .toList();

      expect(dec2024.length, equals(1));
      expect(jan2025.length, equals(1));
      expect(dec2024.first.amount, equals(100.0));
      expect(jan2025.first.amount, equals(200.0));
    });
  });

  // ═══════════════════════════════════════════════════════════════════════════
  // CATEGORY 4: STATE CONSISTENCY
  // ═══════════════════════════════════════════════════════════════════════════
  group('🔄 Integration - Calculation Consistency', () {
    test('Same inputs produce same meal rate', () {
      final meals = createMockMeals(DateTime.now());
      final bazar = createMockBazarEntries(DateTime.now());

      final rate1 = calculateMealRate(meals, bazar);
      final rate2 = calculateMealRate(meals, bazar);
      final rate3 = calculateMealRate(meals, bazar);

      expect(rate1, equals(rate2));
      expect(rate2, equals(rate3));
    });

    test('Same inputs produce same balance', () {
      final meals = createMockMeals(DateTime.now());
      final bazar = createMockBazarEntries(DateTime.now());
      final mealRate = calculateMealRate(meals, bazar);

      final bal1 = calculateMemberBalance(
        memberId: 'member_1',
        bazarEntries: bazar,
        meals: meals,
        mealRate: mealRate,
        fixedShare: 1200.0,
      );

      final bal2 = calculateMemberBalance(
        memberId: 'member_1',
        bazarEntries: bazar,
        meals: meals,
        mealRate: mealRate,
        fixedShare: 1200.0,
      );

      expect(bal1, equals(bal2));
    });

    test('All balances are finite numbers', () {
      final meals = createMockMeals(DateTime.now());
      final bazar = createMockBazarEntries(DateTime.now());
      final mealRate = calculateMealRate(meals, bazar);

      for (final member in mockMembers) {
        final balance = calculateMemberBalance(
          memberId: member.id,
          bazarEntries: bazar,
          meals: meals,
          mealRate: mealRate,
          fixedShare: 1200.0,
        );

        expect(
          balance.isFinite,
          isTrue,
          reason: 'Balance for ${member.id} is not finite',
        );
        expect(
          balance.isNaN,
          isFalse,
          reason: 'Balance for ${member.id} is NaN',
        );
      }
    });
  });

  // ═══════════════════════════════════════════════════════════════════════════
  // CATEGORY 5: EDGE CASE HANDLING
  // ═══════════════════════════════════════════════════════════════════════════
  group('⚡ Integration - Edge Cases', () {
    test('Empty meals list does not crash balance calculation', () {
      final bazar = createMockBazarEntries(DateTime.now());

      expect(() {
        calculateMemberBalance(
          memberId: 'member_1',
          bazarEntries: bazar,
          meals: [],
          mealRate: 0.0,
          fixedShare: 1200.0,
        );
      }, returnsNormally);
    });

    test('Empty bazar list does not crash balance calculation', () {
      final meals = createMockMeals(DateTime.now());

      expect(() {
        calculateMemberBalance(
          memberId: 'member_1',
          bazarEntries: [],
          meals: meals,
          mealRate: 0.0,
          fixedShare: 1200.0,
        );
      }, returnsNormally);
    });

    test('Zero fixed share is handled', () {
      final meals = createMockMeals(DateTime.now());
      final bazar = createMockBazarEntries(DateTime.now());
      final mealRate = calculateMealRate(meals, bazar);

      final balance = calculateMemberBalance(
        memberId: 'member_1',
        bazarEntries: bazar,
        meals: meals,
        mealRate: mealRate,
        fixedShare: 0.0, // No fixed expenses
      );

      expect(balance.isFinite, isTrue);
      // Balance = 500 - 400 - 0 = 100
      expect(balance, closeTo(100.0, 0.01));
    });

    test('Very large amounts are handled', () {
      final largeEntry = BazarEntry(
        id: 'large',
        memberId: 'member_1',
        amount: 9999999.99,
        date: DateTime.now(),
      );

      expect(largeEntry.amount, equals(9999999.99));
      expect(largeEntry.amount.isFinite, isTrue);
    });

    test('Very small amounts are handled', () {
      final smallEntry = BazarEntry(
        id: 'small',
        memberId: 'member_1',
        amount: 0.01,
        date: DateTime.now(),
      );

      expect(smallEntry.amount, equals(0.01));
      expect(smallEntry.amount, greaterThan(0));
    });
  });

  // ═══════════════════════════════════════════════════════════════════════════
  // CATEGORY 6: REGRESSION PREVENTION
  // ═══════════════════════════════════════════════════════════════════════════
  group('🛑 Integration - Regression Guards', () {
    test('Mock data maintains expected structure', () {
      expect(mockMembers.length, equals(3));
      expect(createMockMeals(DateTime.now()).length, equals(3));
      expect(createMockBazarEntries(DateTime.now()).length, equals(2));
      expect(createMockFixedExpenses().length, equals(2));
    });

    test('Mock member roles are correct', () {
      final admin = mockMembers.firstWhere((m) => m.id == 'member_1');
      final member = mockMembers.firstWhere((m) => m.id == 'member_2');

      expect(admin.role, equals(MemberRole.admin));
      expect(member.role, equals(MemberRole.member));
    });

    test('Mock bazar amounts are correct', () {
      final entries = createMockBazarEntries(DateTime.now());

      final member1Bazar = entries.firstWhere((e) => e.memberId == 'member_1');
      final member2Bazar = entries.firstWhere((e) => e.memberId == 'member_2');

      expect(member1Bazar.amount, equals(500.0));
      expect(member2Bazar.amount, equals(300.0));
    });

    test('Mock fixed expenses total is correct', () {
      final expenses = createMockFixedExpenses();
      final total = expenses.fold(0.0, (sum, e) => sum + e.amount);

      expect(total, equals(3600.0)); // rent(3000) + wifi(600)
    });
  });
}
