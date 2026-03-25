import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mess_manager/core/providers/members_provider.dart';
import 'package:mess_manager/features/meals/providers/meals_provider.dart';
import 'package:mess_manager/features/bazar/providers/bazar_provider.dart';

/// Daily statistics for the current month
class DailyStats {
  final DateTime date;
  final double mealCount;
  final double bazarAmount;

  DailyStats({
    required this.date,
    required this.mealCount,
    required this.bazarAmount,
  });
}

/// Monthly analytics provider
final monthlyStatsProvider = Provider<List<DailyStats>>((ref) {
  final meals = ref.watch(mealsProvider);
  final bazarEntries = ref.watch(bazarEntriesProvider);

  final now = DateTime.now();
  final monthStart = DateTime(now.year, now.month, 1);

  // Group by day
  final dailyMeals = <int, double>{};
  final dailyBazar = <int, double>{};

  for (final meal in meals) {
    if (meal.date.isAfter(monthStart.subtract(const Duration(days: 1)))) {
      final day = meal.date.day;
      dailyMeals[day] = (dailyMeals[day] ?? 0) + meal.count;
    }
  }

  for (final entry in bazarEntries) {
    if (entry.date.isAfter(monthStart.subtract(const Duration(days: 1)))) {
      final day = entry.date.day;
      dailyBazar[day] = (dailyBazar[day] ?? 0) + entry.amount;
    }
  }

  // Create daily stats
  final stats = <DailyStats>[];
  final daysInMonth = DateTime(now.year, now.month + 1, 0).day;

  for (var day = 1; day <= daysInMonth; day++) {
    stats.add(
      DailyStats(
        date: DateTime(now.year, now.month, day),
        mealCount: dailyMeals[day] ?? 0,
        bazarAmount: dailyBazar[day] ?? 0,
      ),
    );
  }

  return stats;
});

/// Weekly trend (last 7 days)
final weeklyTrendProvider = Provider<List<DailyStats>>((ref) {
  final meals = ref.watch(mealsProvider);
  final bazarEntries = ref.watch(bazarEntriesProvider);

  final now = DateTime.now();
  final weekStart = now.subtract(const Duration(days: 6));

  final stats = <DailyStats>[];

  for (var i = 0; i < 7; i++) {
    final date = weekStart.add(Duration(days: i));
    final dateOnly = DateTime(date.year, date.month, date.day);

    double mealCount = 0;
    double bazarAmount = 0;

    for (final meal in meals) {
      final mealDate = DateTime(meal.date.year, meal.date.month, meal.date.day);
      if (mealDate == dateOnly) {
        mealCount += meal.count;
      }
    }

    for (final entry in bazarEntries) {
      final entryDate = DateTime(
        entry.date.year,
        entry.date.month,
        entry.date.day,
      );
      if (entryDate == dateOnly) {
        bazarAmount += entry.amount;
      }
    }

    stats.add(
      DailyStats(
        date: dateOnly,
        mealCount: mealCount,
        bazarAmount: bazarAmount,
      ),
    );
  }

  return stats;
});

/// Average spending per day
final avgDailySpendingProvider = Provider<double>((ref) {
  final stats = ref.watch(weeklyTrendProvider);
  if (stats.isEmpty) return 0;

  final totalSpending = stats.fold(0.0, (sum, s) => sum + s.bazarAmount);
  final daysWithSpending = stats.where((s) => s.bazarAmount > 0).length;

  if (daysWithSpending == 0) return 0;
  return totalSpending / daysWithSpending;
});

/// Average meals per day
final avgDailyMealsProvider = Provider<double>((ref) {
  final stats = ref.watch(weeklyTrendProvider);
  if (stats.isEmpty) return 0;

  final totalMeals = stats.fold(0.0, (sum, s) => sum + s.mealCount);
  return totalMeals / 7;
});

/// Month-over-month comparison
class MonthComparison {
  final double currentMonthBazar;
  final double currentMonthMeals;
  final double percentChange; // vs last month projected

  MonthComparison({
    required this.currentMonthBazar,
    required this.currentMonthMeals,
    required this.percentChange,
  });
}

final monthComparisonProvider = Provider<MonthComparison>((ref) {
  final totalBazar = ref.watch(totalBazarProvider);
  final totalMeals = ref.watch(totalMealsProvider);

  // Simple projection: assume this month continues at current rate
  return MonthComparison(
    currentMonthBazar: totalBazar,
    currentMonthMeals: totalMeals,
    percentChange: 0,
  );
});

// ═══════════════════════════════════════════════════════════════
// MEMBER-WISE ANALYTICS
// ═══════════════════════════════════════════════════════════════

/// Per-member cost breakdown for the current month
class MemberCostBreakdown {
  final String memberId;
  final String name;
  final int totalMeals; // includes guest meals
  final double bazarContribution;
  final double estimatedCost; // meals * mealRate
  final double netBalance; // bazarContribution - estimatedCost

  const MemberCostBreakdown({
    required this.memberId,
    required this.name,
    required this.totalMeals,
    required this.bazarContribution,
    required this.estimatedCost,
    required this.netBalance,
  });
}

/// Member-wise cost breakdown provider
final memberCostBreakdownProvider = Provider<List<MemberCostBreakdown>>((ref) {
  final members = ref.watch(membersProvider);
  final meals = ref.watch(mealsProvider);
  final bazarEntries = ref.watch(bazarEntriesProvider);

  final now = DateTime.now();
  final monthMeals = meals
      .where((m) => m.date.year == now.year && m.date.month == now.month)
      .toList();
  final monthBazar = bazarEntries
      .where((b) => b.date.year == now.year && b.date.month == now.month)
      .toList();

  final totalBazar = monthBazar.fold(0.0, (sum, b) => sum + b.amount);
  final totalMealCount = monthMeals.fold(
    0,
    (sum, m) => sum + m.count + m.guestCount,
  );
  final mealRate = totalMealCount > 0 ? totalBazar / totalMealCount : 0.0;

  return members.where((m) => m.isActive).map((member) {
    final memberMealCount = monthMeals
        .where((m) => m.memberId == member.id)
        .fold(0, (sum, m) => sum + m.count + m.guestCount);
    final memberBazar = monthBazar
        .where((b) => b.memberId == member.id)
        .fold(0.0, (sum, b) => sum + b.amount);
    final cost = memberMealCount * mealRate;

    return MemberCostBreakdown(
      memberId: member.id,
      name: member.name,
      totalMeals: memberMealCount,
      bazarContribution: memberBazar,
      estimatedCost: cost,
      netBalance: memberBazar - cost,
    );
  }).toList()
    ..sort((a, b) => b.totalMeals.compareTo(a.totalMeals));
});

/// Current meal rate (bazar / total meals)
final currentMealRateProvider = Provider<double>((ref) {
  final meals = ref.watch(mealsProvider);
  final bazarEntries = ref.watch(bazarEntriesProvider);

  final now = DateTime.now();
  final monthMeals = meals
      .where((m) => m.date.year == now.year && m.date.month == now.month);
  final monthBazar = bazarEntries
      .where((b) => b.date.year == now.year && b.date.month == now.month);

  final totalBazar = monthBazar.fold(0.0, (sum, b) => sum + b.amount);
  final totalMealCount = monthMeals.fold(
    0,
    (sum, m) => sum + m.count + m.guestCount,
  );

  return totalMealCount > 0 ? totalBazar / totalMealCount : 0.0;
});

/// End-of-month forecast based on current spending rate
class MonthForecast {
  final double projectedBazar;
  final double projectedMeals;
  final double projectedMealRate;
  final int daysElapsed;
  final int daysRemaining;

  const MonthForecast({
    required this.projectedBazar,
    required this.projectedMeals,
    required this.projectedMealRate,
    required this.daysElapsed,
    required this.daysRemaining,
  });
}

final monthForecastProvider = Provider<MonthForecast>((ref) {
  final totalBazar = ref.watch(totalBazarProvider);
  final totalMeals = ref.watch(totalMealsProvider);

  final now = DateTime.now();
  final daysInMonth = DateTime(now.year, now.month + 1, 0).day;
  final daysElapsed = now.day;
  final daysRemaining = daysInMonth - daysElapsed;

  final dailyBazarRate = daysElapsed > 0 ? totalBazar / daysElapsed : 0.0;
  final dailyMealRate = daysElapsed > 0 ? totalMeals / daysElapsed : 0.0;

  final projectedBazar = totalBazar + (dailyBazarRate * daysRemaining);
  final projectedMeals = totalMeals + (dailyMealRate * daysRemaining);
  final projectedMealRate = projectedMeals > 0
      ? projectedBazar / projectedMeals
      : 0.0;

  return MonthForecast(
    projectedBazar: projectedBazar,
    projectedMeals: projectedMeals,
    projectedMealRate: projectedMealRate,
    daysElapsed: daysElapsed,
    daysRemaining: daysRemaining,
  );
});
