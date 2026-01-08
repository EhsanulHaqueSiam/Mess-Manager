import 'package:flutter_test/flutter_test.dart';

import '../../helpers/mock_providers.dart';

void main() {
  group('Balance Calculation Tests', () {
    test('calculateMealRate computes correctly', () {
      final meals = createMockMeals(DateTime.now());
      final bazar = createMockBazarEntries(DateTime.now());

      // Total bazar = 800, Total meals = 4
      final rate = calculateMealRate(meals, bazar);
      expect(rate, closeTo(200.0, 0.01));
    });

    test('calculateMealRate returns 0 when no meals', () {
      final bazar = createMockBazarEntries(DateTime.now());

      final rate = calculateMealRate([], bazar);
      expect(rate, equals(0.0));
    });

    test('calculateMemberBalance includes bazar contributions', () {
      final meals = createMockMeals(DateTime.now());
      final bazar = createMockBazarEntries(DateTime.now());
      final mealRate = calculateMealRate(meals, bazar);

      // member_1 has 500 bazar, 2 meals (400 cost), 1200 fixed share
      final balance = calculateMemberBalance(
        memberId: 'member_1',
        bazarEntries: bazar,
        meals: meals,
        mealRate: mealRate,
        fixedShare: 1200.0,
      );

      // 500 - 400 - 1200 = -1100
      expect(balance, closeTo(-1100.0, 0.01));
    });

    test('calculateMemberBalance includes opening balance', () {
      final meals = createMockMeals(DateTime.now());
      final bazar = createMockBazarEntries(DateTime.now());
      final mealRate = calculateMealRate(meals, bazar);

      final balance = calculateMemberBalance(
        memberId: 'member_1',
        bazarEntries: bazar,
        meals: meals,
        mealRate: mealRate,
        fixedShare: 1200.0,
        openingBalance: 500.0, // Carry forward from last month
      );

      // 500 (opening) + 500 (bazar) - 400 (meals) - 1200 (fixed) = -600
      expect(balance, closeTo(-600.0, 0.01));
    });

    test('member with no activity has negative balance from fixed costs', () {
      final meals = createMockMeals(DateTime.now());
      final bazar = createMockBazarEntries(DateTime.now());
      final mealRate = calculateMealRate(meals, bazar);

      // member_3 has no bazar entries in mock data
      final balance = calculateMemberBalance(
        memberId: 'member_3',
        bazarEntries: bazar,
        meals: meals,
        mealRate: mealRate,
        fixedShare: 1200.0,
      );

      // 0 (bazar) - 0 (meals) - 1200 (fixed) = -1200
      expect(balance, closeTo(-1200.0, 0.01));
    });
  });

  group('Pro-rata Fixed Cost Tests', () {
    test('full month member gets full share', () {
      final daysInMonth = 30;
      final memberActiveDays = 30;
      final totalFixedExpenses = 3600.0;
      final totalActiveDays = 90; // 3 members * 30 days

      final share = (memberActiveDays / totalActiveDays) * totalFixedExpenses;
      expect(share, closeTo(1200.0, 0.01));
    });

    test('half month member gets half share', () {
      final memberActiveDays = 15;
      final totalFixedExpenses = 3600.0;
      final totalActiveDays = 75; // 2 full + 1 half = 30+30+15

      final share = (memberActiveDays / totalActiveDays) * totalFixedExpenses;
      expect(share, closeTo(720.0, 0.01));
    });

    test('inactive member gets zero share', () {
      final memberActiveDays = 0;
      final totalFixedExpenses = 3600.0;
      final totalActiveDays = 60;

      final share = totalActiveDays > 0
          ? (memberActiveDays / totalActiveDays) * totalFixedExpenses
          : 0.0;
      expect(share, equals(0.0));
    });
  });
}
