import 'package:flutter_riverpod/flutter_riverpod.dart';
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
  // Would compare to previous month data when available
  return MonthComparison(
    currentMonthBazar: totalBazar,
    currentMonthMeals: totalMeals,
    percentChange: 0, // Would calculate from previous month data
  );
});
