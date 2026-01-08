import 'package:flutter_test/flutter_test.dart';

import 'package:mess_manager/core/models/member.dart';
import 'package:mess_manager/core/models/meal.dart';
import 'package:mess_manager/core/models/bazar_entry.dart';
import 'package:mess_manager/features/vacation/providers/fixed_expenses_provider.dart';

/// Mock members for testing
final mockMembers = [
  Member(
    id: 'member_1',
    name: 'Alice',
    role: MemberRole.admin,
    isActive: true,
    joinedAt: DateTime(2024, 1, 1),
  ),
  Member(
    id: 'member_2',
    name: 'Bob',
    role: MemberRole.member,
    isActive: true,
    joinedAt: DateTime(2024, 1, 15),
  ),
  Member(
    id: 'member_3',
    name: 'Charlie',
    role: MemberRole.member,
    isActive: true,
    joinedAt: DateTime(2024, 2, 1),
  ),
];

/// Mock meals for testing
List<Meal> createMockMeals(DateTime date) => [
  Meal(
    id: 'meal_1',
    memberId: 'member_1',
    type: MealType.breakfast,
    count: 1,
    date: date,
  ),
  Meal(
    id: 'meal_2',
    memberId: 'member_1',
    type: MealType.lunch,
    count: 1,
    date: date,
  ),
  Meal(
    id: 'meal_3',
    memberId: 'member_2',
    type: MealType.dinner,
    count: 2,
    date: date,
  ),
];

/// Mock bazar entries for testing
List<BazarEntry> createMockBazarEntries(DateTime date) => [
  BazarEntry(
    id: 'bazar_1',
    memberId: 'member_1',
    amount: 500.0,
    items: [
      BazarItem(name: 'Rice', price: 300.0),
      BazarItem(name: 'Dal', price: 200.0),
    ],
    isItemized: true,
    date: date,
  ),
  BazarEntry(
    id: 'bazar_2',
    memberId: 'member_2',
    amount: 300.0,
    items: [BazarItem(name: 'Vegetables', price: 300.0)],
    isItemized: true,
    date: date,
  ),
];

/// Mock fixed expenses for testing
List<FixedExpense> createMockFixedExpenses() => [
  FixedExpense(
    id: 'fix_1',
    type: FixedExpenseType.rent,
    amount: 3000.0,
    dueDate: DateTime.now(),
    month: DateTime.now().month,
    year: DateTime.now().year,
  ),
  FixedExpense(
    id: 'fix_2',
    type: FixedExpenseType.wifi,
    amount: 600.0,
    dueDate: DateTime.now(),
    month: DateTime.now().month,
    year: DateTime.now().year,
  ),
];

/// Calculate meal rate from mock data
double calculateMealRate(List<Meal> meals, List<BazarEntry> bazar) {
  final totalBazar = bazar.fold(0.0, (sum, b) => sum + b.amount);
  final totalMeals = meals.fold(0, (sum, m) => sum + m.count);
  return totalMeals > 0 ? totalBazar / totalMeals : 0.0;
}

/// Calculate member balance
double calculateMemberBalance({
  required String memberId,
  required List<BazarEntry> bazarEntries,
  required List<Meal> meals,
  required double mealRate,
  required double fixedShare,
  double openingBalance = 0.0,
}) {
  final memberBazar = bazarEntries
      .where((b) => b.memberId == memberId)
      .fold(0.0, (sum, b) => sum + b.amount);
  final memberMeals = meals
      .where((m) => m.memberId == memberId)
      .fold(0, (sum, m) => sum + m.count);
  final mealCost = memberMeals * mealRate;

  return openingBalance + memberBazar - mealCost - fixedShare;
}
