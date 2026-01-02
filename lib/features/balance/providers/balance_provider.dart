import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mess_manager/core/providers/members_provider.dart';
import 'package:mess_manager/features/meals/providers/meals_provider.dart';
import 'package:mess_manager/features/bazar/providers/bazar_provider.dart';

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
  final String status; // 'normal', 'no_meals', 'bazar_only'

  MemberBalance({
    required this.memberId,
    required this.name,
    required this.totalMeals,
    required this.totalBazar,
    required this.balance,
    required this.mealCost,
    this.equalShare = 0,
    this.status = 'normal',
  });
}

/// Provider for all member balances with edge case handling
///
/// Fair Calculation Logic:
/// 1. Normal case: Balance = Bazar Contribution - (Meals × Meal Rate)
/// 2. No meals recorded: Split bazar equally among all members
/// 3. Member with bazar but no meals: They still pay equal share for bazar
/// 4. Handles floating point precision issues
final memberBalancesProvider = Provider<List<MemberBalance>>((ref) {
  final members = ref.watch(membersProvider);
  final mealsByMember = ref.watch(mealsByMemberProvider);
  final bazarByMember = ref.watch(bazarByMemberProvider);
  final totalBazar = ref.watch(totalBazarProvider);
  final totalMeals = ref.watch(totalMealsProvider);
  final mealRate = ref.watch(mealRateProvider);

  // Edge case: No members
  if (members.isEmpty) return [];

  // Edge case: No bazar and no meals - everyone is at 0
  if (totalBazar <= 0 && totalMeals <= 0) {
    return members
        .map(
          (member) => MemberBalance(
            memberId: member.id,
            name: member.name,
            totalMeals: 0,
            totalBazar: 0,
            balance: 0,
            mealCost: 0,
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
      // Balance = What they contributed - What they owe (equal share)
      final balance = bazar - equalShare;

      return MemberBalance(
        memberId: member.id,
        name: member.name,
        totalMeals: 0,
        totalBazar: bazar,
        balance: _roundToTwoDecimals(balance),
        mealCost: 0,
        equalShare: equalShare,
        status: 'no_meals',
      );
    }).toList();
  }

  // Normal case: Both bazar and meals exist
  return members.map((member) {
    final meals = mealsByMember[member.id] ?? 0;
    final bazar = bazarByMember[member.id] ?? 0;
    final mealCost = meals * mealRate;

    // Balance = Bazar Contribution - Meal Cost
    // Positive: contributed more bazar than consumed (will receive money)
    // Negative: consumed more than contributed (owes money)
    final balance = bazar - mealCost;

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
  final String calculationMode; // 'normal', 'equal_split', 'no_activity'

  BalanceSummary({
    required this.totalBazar,
    required this.totalMeals,
    required this.mealRate,
    required this.memberCount,
    required this.hasMeals,
    required this.hasBazar,
    required this.calculationMode,
  });
}

final balanceSummaryProvider = Provider<BalanceSummary>((ref) {
  final totalBazar = ref.watch(totalBazarProvider);
  final totalMeals = ref.watch(totalMealsProvider);
  final mealRate = ref.watch(mealRateProvider);
  final memberCount = ref.watch(membersProvider).length;

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
