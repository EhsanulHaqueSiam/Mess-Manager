import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mess_manager/core/providers/members_provider.dart';
import 'package:mess_manager/features/meals/providers/meals_provider.dart';
import 'package:mess_manager/features/bazar/providers/bazar_provider.dart';
import 'package:mess_manager/features/vacation/providers/fixed_expenses_provider.dart';

/// Meal rate = Total Bazar / Total Meals
/// Handles edge cases:
/// - If totalMeals == 0 but totalBazar > 0: Returns 0 (bazar will be split equally)
/// - If both are 0: Returns 0
final mealRateProvider = Provider<double>((ref) {
  final totalBazar = ref.watch(totalBazarProvider);
  final totalMeals = ref.watch(totalMealsProvider);

  // Edge case: No meals recorded yet
  if (totalMeals <= 0) return 0;

  return totalBazar / totalMeals;
});

/// Balance data for a single member
class MemberBalance {
  final String memberId;
  final String name;
  final double totalMeals;
  final double totalBazar;
  final double balance; // Positive = will receive, Negative = owes
  final double mealCost; // meals * rate
  final double equalShare; // For when no meals recorded
  final double
  fixedExpenseShare; // Per-member share of fixed expenses (rent, wifi, etc.)
  final String status; // 'normal', 'no_meals', 'bazar_only'

  MemberBalance({
    required this.memberId,
    required this.name,
    required this.totalMeals,
    required this.totalBazar,
    required this.balance,
    required this.mealCost,
    this.equalShare = 0,
    this.fixedExpenseShare = 0,
    this.status = 'normal',
  });
}

/// Provider for all member balances with edge case handling
///
/// Fair Calculation Logic:
/// 1. Normal case: Balance = Bazar Contribution - (Meals × Meal Rate) - FixedExpenseShare
/// 2. No meals recorded: Split bazar equally among all members
/// 3. Member with bazar but no meals: They still pay equal share for bazar
/// 4. Fixed Expenses (Rent, Wifi, etc.) are ALWAYS split equally regardless of meals
/// 5. Handles floating point precision issues
final memberBalancesProvider = Provider<List<MemberBalance>>((ref) {
  final members = ref.watch(membersProvider);
  final mealsByMember = ref.watch(mealsByMemberProvider);
  final bazarByMember = ref.watch(bazarByMemberProvider);
  final totalBazar = ref.watch(totalBazarProvider);
  final totalMeals = ref.watch(totalMealsProvider);
  final mealRate = ref.watch(mealRateProvider);

  // Get fixed expenses total
  final fixedExpenses = ref.watch(fixedExpensesProvider);
  final totalFixedExpenses = fixedExpenses.fold<double>(
    0.0,
    (sum, expense) => sum + expense.amount,
  );

  // Edge case: No members
  if (members.isEmpty) return [];

  // Fixed expense share per member (always split equally)
  final fixedExpenseShare = members.isNotEmpty
      ? totalFixedExpenses / members.length
      : 0.0;

  // Edge case: No bazar and no meals - everyone just owes fixed expense share
  if (totalBazar <= 0 && totalMeals <= 0) {
    return members
        .map(
          (member) => MemberBalance(
            memberId: member.id,
            name: member.name,
            totalMeals: 0,
            totalBazar: 0,
            balance: _roundToTwoDecimals(-fixedExpenseShare), // Negative = owes
            mealCost: 0,
            fixedExpenseShare: _roundToTwoDecimals(fixedExpenseShare),
            status: 'no_activity',
          ),
        )
        .toList();
  }

  // Edge case: Bazar exists but no meals recorded
  // Split bazar cost equally among all members
  if (totalMeals <= 0 && totalBazar > 0) {
    final equalShare = totalBazar / members.length;

    return members.map((member) {
      final bazar = bazarByMember[member.id] ?? 0;
      // Balance = What they contributed - What they owe (equal share + fixed)
      final balance = bazar - equalShare - fixedExpenseShare;

      return MemberBalance(
        memberId: member.id,
        name: member.name,
        totalMeals: 0,
        totalBazar: bazar,
        balance: _roundToTwoDecimals(balance),
        mealCost: 0,
        equalShare: equalShare,
        fixedExpenseShare: _roundToTwoDecimals(fixedExpenseShare),
        status: 'no_meals',
      );
    }).toList();
  }

  // Normal case: Both bazar and meals exist
  return members.map((member) {
    final meals = mealsByMember[member.id] ?? 0;
    final bazar = bazarByMember[member.id] ?? 0;
    final mealCost = meals * mealRate;

    // Balance = Bazar Contribution - Meal Cost - Fixed Expense Share
    // Positive: contributed more bazar than consumed (will receive money)
    // Negative: consumed more than contributed (owes money)
    final balance = bazar - mealCost - fixedExpenseShare;

    // Determine status for UI hints
    String status = 'normal';
    if (meals <= 0 && bazar > 0) {
      status = 'bazar_only'; // Did bazar but didn't eat - will receive money
    } else if (meals > 0 && bazar <= 0) {
      status = 'meals_only'; // Ate but didn't do bazar - owes money
    }

    return MemberBalance(
      memberId: member.id,
      name: member.name,
      totalMeals: meals,
      totalBazar: bazar,
      balance: _roundToTwoDecimals(balance),
      mealCost: _roundToTwoDecimals(mealCost),
      fixedExpenseShare: _roundToTwoDecimals(fixedExpenseShare),
      status: status,
    );
  }).toList();
});

/// Round to 2 decimal places to avoid floating point issues
double _roundToTwoDecimals(double value) {
  return (value * 100).round() / 100;
}

/// Current member's balance
final currentMemberBalanceProvider = Provider<MemberBalance?>((ref) {
  final currentMemberId = ref.watch(currentMemberIdProvider);
  final balances = ref.watch(memberBalancesProvider);
  try {
    return balances.firstWhere((b) => b.memberId == currentMemberId);
  } catch (_) {
    return null;
  }
});

/// Summary statistics with edge case info
class BalanceSummary {
  final double totalBazar;
  final double totalMeals;
  final double mealRate;
  final int memberCount;
  final bool hasMeals;
  final bool hasBazar;
  final double
  totalFixedExpenses; // Total of all fixed expenses (rent, wifi, etc.)
  final double perMemberFixedShare; // Fixed expense per member
  final String calculationMode; // 'normal', 'equal_split', 'no_activity'

  BalanceSummary({
    required this.totalBazar,
    required this.totalMeals,
    required this.mealRate,
    required this.memberCount,
    required this.hasMeals,
    required this.hasBazar,
    required this.totalFixedExpenses,
    required this.perMemberFixedShare,
    required this.calculationMode,
  });
}

final balanceSummaryProvider = Provider<BalanceSummary>((ref) {
  final totalBazar = ref.watch(totalBazarProvider);
  final totalMeals = ref.watch(totalMealsProvider);
  final mealRate = ref.watch(mealRateProvider);
  final memberCount = ref.watch(membersProvider).length;

  // Get fixed expenses
  final fixedExpenses = ref.watch(fixedExpensesProvider);
  final totalFixedExpenses = fixedExpenses.fold<double>(
    0.0,
    (sum, expense) => sum + expense.amount,
  );
  final perMemberFixedShare = memberCount > 0
      ? totalFixedExpenses / memberCount
      : 0.0;

  String calculationMode;
  if (totalMeals <= 0 && totalBazar <= 0) {
    calculationMode = 'no_activity';
  } else if (totalMeals <= 0 && totalBazar > 0) {
    calculationMode = 'equal_split';
  } else {
    calculationMode = 'normal';
  }

  return BalanceSummary(
    totalBazar: totalBazar,
    totalMeals: totalMeals,
    mealRate: _roundToTwoDecimals(mealRate),
    memberCount: memberCount,
    hasMeals: totalMeals > 0,
    hasBazar: totalBazar > 0,
    totalFixedExpenses: _roundToTwoDecimals(totalFixedExpenses),
    perMemberFixedShare: _roundToTwoDecimals(perMemberFixedShare),
    calculationMode: calculationMode,
  );
});

/// Validation: Check if balances sum to zero (they should!)
final balanceValidationProvider = Provider<bool>((ref) {
  final balances = ref.watch(memberBalancesProvider);
  if (balances.isEmpty) return true;

  final sum = balances.fold(0.0, (sum, b) => sum + b.balance);
  // Allow small floating point tolerance
  return sum.abs() < 0.01;
});
