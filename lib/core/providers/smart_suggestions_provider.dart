import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mess_manager/features/bazar/providers/bazar_provider.dart';
import 'package:mess_manager/features/meals/providers/meals_provider.dart';

/// Time since last bazar entry
final lastBazarProvider = Provider<DateTime?>((ref) {
  final entries = ref.watch(bazarEntriesProvider);
  if (entries.isEmpty) return null;

  // Find most recent entry
  final sorted = [...entries]..sort((a, b) => b.date.compareTo(a.date));
  return sorted.first.date;
});

/// Days since last bazar
final daysSinceLastBazarProvider = Provider<int?>((ref) {
  final lastBazar = ref.watch(lastBazarProvider);
  if (lastBazar == null) return null;

  return DateTime.now().difference(lastBazar).inDays;
});

/// Time since last meal (for any member)
final lastMealProvider = Provider<DateTime?>((ref) {
  final meals = ref.watch(mealsProvider);
  if (meals.isEmpty) return null;

  final sorted = [...meals]..sort((a, b) => b.date.compareTo(a.date));
  return sorted.first.date;
});

/// Smart suggestion based on time patterns
enum SuggestionType {
  none,
  bazarReminder,
  monthlyReminder,
  noMealsToday,
  weekendShopping,
}

class SmartSuggestion {
  final SuggestionType type;
  final String title;
  final String message;
  final String? actionLabel;

  SmartSuggestion({
    required this.type,
    required this.title,
    required this.message,
    this.actionLabel,
  });
}

/// Smart suggestions provider
final smartSuggestionProvider = Provider<SmartSuggestion?>((ref) {
  final daysSinceBazar = ref.watch(daysSinceLastBazarProvider);
  final lastMeal = ref.watch(lastMealProvider);
  final now = DateTime.now();

  // Check if it's been too long since bazar
  if (daysSinceBazar != null && daysSinceBazar >= 3) {
    return SmartSuggestion(
      type: SuggestionType.bazarReminder,
      title: 'Time for groceries?',
      message: 'Last bazar was $daysSinceBazar days ago',
      actionLabel: 'Add Bazar',
    );
  }

  // Check if no meals logged today
  if (lastMeal != null) {
    final today = DateTime(now.year, now.month, now.day);
    final lastMealDate = DateTime(lastMeal.year, lastMeal.month, lastMeal.day);

    if (lastMealDate.isBefore(today) && now.hour >= 12) {
      return SmartSuggestion(
        type: SuggestionType.noMealsToday,
        title: 'No meals logged today',
        message: 'Remember to add today\'s meals',
        actionLabel: 'Add Meal',
      );
    }
  }

  // Weekend shopping reminder (Friday or Saturday)
  if ((now.weekday == 5 || now.weekday == 6) &&
      daysSinceBazar != null &&
      daysSinceBazar >= 2) {
    return SmartSuggestion(
      type: SuggestionType.weekendShopping,
      title: 'Weekend shopping?',
      message: 'Good time to stock up for the week',
      actionLabel: 'Check List',
    );
  }

  return null;
});

/// Monthly summary end approaching
final monthEndReminderProvider = Provider<bool>((ref) {
  final now = DateTime.now();
  final daysInMonth = DateTime(now.year, now.month + 1, 0).day;
  return now.day >= daysInMonth - 3; // Last 3 days of month
});

/// Quick stats for dashboard
class QuickStats {
  final int totalMembersActive;
  final int mealsToday;
  final int pendingShoppingItems;
  final bool hasUnbalancedAccounts;

  QuickStats({
    required this.totalMembersActive,
    required this.mealsToday,
    required this.pendingShoppingItems,
    required this.hasUnbalancedAccounts,
  });
}

final quickStatsProvider = Provider<QuickStats>((ref) {
  final meals = ref.watch(mealsProvider);
  final entries = ref.watch(bazarEntriesProvider);

  // Count today's meals
  final today = DateTime.now();
  final todayStart = DateTime(today.year, today.month, today.day);
  final mealsToday = meals
      .where(
        (m) =>
            m.date.isAfter(todayStart) || m.date.isAtSameMomentAs(todayStart),
      )
      .length;

  // Get active members (those with meals or bazar this month)
  final thisMonth = DateTime(today.year, today.month);
  final activeMemberIds = <String>{};
  for (final meal in meals) {
    if (meal.date.isAfter(thisMonth)) {
      activeMemberIds.add(meal.memberId);
    }
  }
  for (final entry in entries) {
    if (entry.date.isAfter(thisMonth)) {
      activeMemberIds.add(entry.memberId);
    }
  }

  return QuickStats(
    totalMembersActive: activeMemberIds.length,
    mealsToday: mealsToday,
    pendingShoppingItems: 0, // Will be connected later
    hasUnbalancedAccounts: false,
  );
});
