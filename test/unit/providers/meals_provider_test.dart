import 'package:flutter_test/flutter_test.dart';

import 'package:mess_manager/core/models/meal.dart';

import '../../helpers/mock_providers.dart';

void main() {
  group('MealsProvider Tests', () {
    test('mock meals have correct structure', () {
      final meals = createMockMeals(DateTime.now());

      expect(meals, isA<List<Meal>>());
      expect(meals.length, equals(3));
    });

    test('meals reference valid member IDs', () {
      final meals = createMockMeals(DateTime.now());
      final memberIds = mockMembers.map((m) => m.id).toSet();

      for (final meal in meals) {
        expect(memberIds.contains(meal.memberId), isTrue);
      }
    });

    test('meal count totals correctly', () {
      final meals = createMockMeals(DateTime.now());

      final totalMeals = meals.fold(0, (sum, m) => sum + m.count);
      expect(totalMeals, equals(4)); // 1 + 1 + 2
    });

    test('meals by member groups correctly', () {
      final meals = createMockMeals(DateTime.now());

      final member1Meals = meals
          .where((m) => m.memberId == 'member_1')
          .fold(0, (sum, m) => sum + m.count);
      expect(member1Meals, equals(2)); // 1 + 1

      final member2Meals = meals
          .where((m) => m.memberId == 'member_2')
          .fold(0, (sum, m) => sum + m.count);
      expect(member2Meals, equals(2)); // 2
    });

    test('meal rate calculates correctly with mock data', () {
      final meals = createMockMeals(DateTime.now());
      final bazar = createMockBazarEntries(DateTime.now());

      final mealRate = calculateMealRate(meals, bazar);

      // Total bazar = 800, Total meals = 4
      // Rate = 800/4 = 200
      expect(mealRate, closeTo(200.0, 0.01));
    });

    test('empty meals returns zero meal rate', () {
      final bazar = createMockBazarEntries(DateTime.now());

      final mealRate = calculateMealRate([], bazar);
      expect(mealRate, equals(0.0));
    });
  });

  group('Meal Model Tests', () {
    test('Meal has correct type enum values', () {
      expect(MealType.values.length, equals(3));
      expect(MealType.values, contains(MealType.breakfast));
      expect(MealType.values, contains(MealType.lunch));
      expect(MealType.values, contains(MealType.dinner));
    });

    test('Meal can be created with required fields', () {
      final meal = Meal(
        id: 'test_meal',
        memberId: 'test_member',
        type: MealType.lunch,
        count: 1,
        date: DateTime.now(),
      );

      expect(meal.id, equals('test_meal'));
      expect(meal.memberId, equals('test_member'));
      expect(meal.type, equals(MealType.lunch));
      expect(meal.count, equals(1));
    });

    test('Meal count must be positive for valid data', () {
      final meal = Meal(
        id: 'test_meal',
        memberId: 'test_member',
        type: MealType.lunch,
        count: 1,
        date: DateTime.now(),
      );

      expect(meal.count, greaterThan(0));
    });
  });
}
