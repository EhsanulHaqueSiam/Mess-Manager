import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mess_manager/core/database/isar_service.dart';
import 'package:mess_manager/features/bazar/providers/bazar_provider.dart';

/// Budget state containing monthly limit and tracking data
class BudgetState {
  final double monthlyLimit;
  final int year;
  final int month;
  final bool isEnabled;

  const BudgetState({
    this.monthlyLimit = 0,
    this.year = 0,
    this.month = 0,
    this.isEnabled = false,
  });

  BudgetState copyWith({
    double? monthlyLimit,
    int? year,
    int? month,
    bool? isEnabled,
  }) {
    return BudgetState(
      monthlyLimit: monthlyLimit ?? this.monthlyLimit,
      year: year ?? this.year,
      month: month ?? this.month,
      isEnabled: isEnabled ?? this.isEnabled,
    );
  }
}

/// Budget limits provider
final budgetProvider = NotifierProvider<BudgetNotifier, BudgetState>(
  BudgetNotifier.new,
);

class BudgetNotifier extends Notifier<BudgetState> {
  static const _budgetKey = 'monthly_budget';
  static const _enabledKey = 'budget_enabled';

  @override
  BudgetState build() {
    final now = DateTime.now();
    final saved = IsarService.getSetting(_budgetKey);
    final enabled = IsarService.getSetting(_enabledKey);
    return BudgetState(
      monthlyLimit: double.tryParse(saved ?? '') ?? 0,
      year: now.year,
      month: now.month,
      isEnabled: enabled == 'true',
    );
  }

  void setMonthlyLimit(double limit) {
    state = state.copyWith(monthlyLimit: limit);
    IsarService.saveSetting(_budgetKey, limit.toString());
  }

  void toggleEnabled(bool enabled) {
    state = state.copyWith(isEnabled: enabled);
    IsarService.saveSetting(_enabledKey, enabled.toString());
  }
}

/// Current month bazar total
final currentMonthBazarProvider = Provider<double>((ref) {
  final entries = ref.watch(bazarEntriesProvider);
  final now = DateTime.now();

  return entries
      .where((e) => e.date.year == now.year && e.date.month == now.month)
      .fold(0.0, (sum, e) => sum + e.amount);
});

/// Budget summary with analytics
class BudgetSummary {
  final double monthlyLimit;
  final double totalSpent;
  final double remaining;
  final double dailyBurnRate;
  final double projectedTotal;
  final int daysElapsed;
  final int daysRemaining;
  final bool isOverBudget;
  final double percentUsed;
  final bool isEnabled;

  const BudgetSummary({
    required this.monthlyLimit,
    required this.totalSpent,
    required this.remaining,
    required this.dailyBurnRate,
    required this.projectedTotal,
    required this.daysElapsed,
    required this.daysRemaining,
    required this.isOverBudget,
    required this.percentUsed,
    required this.isEnabled,
  });
}

/// Computed budget summary with burn rate and projections
final budgetSummaryProvider = Provider<BudgetSummary>((ref) {
  final budget = ref.watch(budgetProvider);
  final totalSpent = ref.watch(currentMonthBazarProvider);

  final now = DateTime.now();
  final daysInMonth = DateTime(now.year, now.month + 1, 0).day;
  final daysElapsed = now.day;
  final daysRemaining = daysInMonth - daysElapsed;

  // Calculate daily burn rate (average daily spending)
  final dailyBurnRate = daysElapsed > 0 ? totalSpent / daysElapsed : 0.0;

  // Project total spending for the month
  final projectedTotal = dailyBurnRate * daysInMonth;

  // Calculate remaining budget
  final remaining = budget.monthlyLimit - totalSpent;

  // Calculate percent used
  final percentUsed = budget.monthlyLimit > 0
      ? (totalSpent / budget.monthlyLimit * 100)
      : 0.0;

  // Is over budget if projected > limit OR already exceeded
  final isOverBudget =
      budget.isEnabled &&
      (projectedTotal > budget.monthlyLimit || remaining < 0);

  return BudgetSummary(
    monthlyLimit: budget.monthlyLimit,
    totalSpent: totalSpent,
    remaining: remaining,
    dailyBurnRate: dailyBurnRate,
    projectedTotal: projectedTotal,
    daysElapsed: daysElapsed,
    daysRemaining: daysRemaining,
    isOverBudget: isOverBudget,
    percentUsed: percentUsed.clamp(0, 100),
    isEnabled: budget.isEnabled,
  );
});
