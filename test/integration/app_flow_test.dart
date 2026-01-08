import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../helpers/mock_providers.dart';

void main() {
  group('App Flow Integration Tests', () {
    test('Mock data structures are valid', () {
      expect(mockMembers, isNotEmpty);
      expect(mockMembers.length, equals(3));
    });

    test('All mock members have required fields', () {
      for (final member in mockMembers) {
        expect(member.id, isNotEmpty);
        expect(member.name, isNotEmpty);
        expect(member.role, isNotNull);
        expect(member.isActive, isNotNull);
      }
    });

    test('Mock meals reference valid member IDs', () {
      final meals = createMockMeals(DateTime.now());
      final memberIds = mockMembers.map((m) => m.id).toSet();

      for (final meal in meals) {
        expect(
          memberIds.contains(meal.memberId),
          isTrue,
          reason: 'Meal ${meal.id} references invalid member ${meal.memberId}',
        );
      }
    });

    test('Mock bazar entries reference valid member IDs', () {
      final entries = createMockBazarEntries(DateTime.now());
      final memberIds = mockMembers.map((m) => m.id).toSet();

      for (final entry in entries) {
        expect(
          memberIds.contains(entry.memberId),
          isTrue,
          reason:
              'Bazar entry ${entry.id} references invalid member ${entry.memberId}',
        );
      }
    });

    test('Mock fixed expenses have valid amounts', () {
      final expenses = createMockFixedExpenses();

      for (final expense in expenses) {
        expect(expense.amount, greaterThan(0));
        expect(expense.type, isNotNull);
      }
    });

    test('Balance calculation produces valid results', () {
      final meals = createMockMeals(DateTime.now());
      final bazar = createMockBazarEntries(DateTime.now());
      final expenses = createMockFixedExpenses();
      final mealRate = calculateMealRate(meals, bazar);

      // Total fixed = 3600
      final totalFixed = expenses.fold(0.0, (sum, e) => sum + e.amount);
      final fixedShare = totalFixed / mockMembers.length;

      // Verify each member has a calculable balance
      for (final member in mockMembers) {
        final balance = calculateMemberBalance(
          memberId: member.id,
          bazarEntries: bazar,
          meals: meals,
          mealRate: mealRate,
          fixedShare: fixedShare,
        );

        expect(balance, isA<double>());
        expect(balance.isFinite, isTrue);
      }
    });

    test('Meal rate is consistent', () {
      final meals = createMockMeals(DateTime.now());
      final bazar = createMockBazarEntries(DateTime.now());

      final rate1 = calculateMealRate(meals, bazar);
      final rate2 = calculateMealRate(meals, bazar);

      expect(rate1, equals(rate2));
    });
  });

  group('Data Integrity Tests', () {
    test('No duplicate member IDs in mock data', () {
      final ids = mockMembers.map((m) => m.id).toList();
      final uniqueIds = ids.toSet();

      expect(ids.length, equals(uniqueIds.length));
    });

    test('All dates are valid', () {
      final now = DateTime.now();
      final meals = createMockMeals(now);
      final bazar = createMockBazarEntries(now);

      for (final meal in meals) {
        expect(meal.date.year, greaterThan(2020));
        expect(meal.date.year, lessThan(2030));
      }

      for (final entry in bazar) {
        expect(entry.date.year, greaterThan(2020));
        expect(entry.date.year, lessThan(2030));
      }
    });

    test('Fixed expenses have valid months', () {
      final expenses = createMockFixedExpenses();

      for (final expense in expenses) {
        expect(expense.month, greaterThanOrEqualTo(1));
        expect(expense.month, lessThanOrEqualTo(12));
        expect(expense.year, greaterThan(2020));
      }
    });
  });
}
