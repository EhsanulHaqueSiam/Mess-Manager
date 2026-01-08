import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mess_manager/core/models/meal.dart';
import 'package:mess_manager/core/database/isar_service.dart';

/// Generate sample meals for demo (used only if no persisted data)
List<Meal> _generateSampleMeals() {
  final meals = <Meal>[];
  final now = DateTime.now();

  // Generate meals for the past 7 days
  for (int day = 0; day < 7; day++) {
    final date = now.subtract(Duration(days: day));

    // Member 1 (Siam) - 2 meals/day
    meals.add(
      Meal(
        id: 'meal_1_${day}_l',
        memberId: '1',
        date: date,
        count: 1,
        type: MealType.lunch,
        createdAt: date,
      ),
    );
    meals.add(
      Meal(
        id: 'meal_1_${day}_d',
        memberId: '1',
        date: date,
        count: 1,
        type: MealType.dinner,
        createdAt: date,
      ),
    );

    // Member 2 (Tanmoy) - 1.5 meals/day average
    meals.add(
      Meal(
        id: 'meal_2_${day}_l',
        memberId: '2',
        date: date,
        count: 1,
        type: MealType.lunch,
        createdAt: date,
      ),
    );
    meals.add(
      Meal(
        id: 'meal_2_${day}_d',
        memberId: '2',
        date: date,
        count: 1,
        type: MealType.dinner,
        createdAt: date,
      ),
    );

    // Member 3 (Sarkar) - 2 meals/day
    meals.add(
      Meal(
        id: 'meal_3_${day}_l',
        memberId: '3',
        date: date,
        count: 1,
        type: MealType.lunch,
        createdAt: date,
      ),
    );
    meals.add(
      Meal(
        id: 'meal_3_${day}_d',
        memberId: '3',
        date: date,
        count: 1,
        type: MealType.dinner,
        createdAt: date,
      ),
    );

    // Member 4 (Shahriyer) - 1 meal/day
    meals.add(
      Meal(
        id: 'meal_4_${day}_d',
        memberId: '4',
        date: date,
        count: 1,
        type: MealType.dinner,
        createdAt: date,
      ),
    );
  }

  return meals;
}

/// Provider for all meals
final mealsProvider = NotifierProvider<MealsNotifier, List<Meal>>(
  MealsNotifier.new,
);

class MealsNotifier extends Notifier<List<Meal>> {
  @override
  List<Meal> build() {
    // Try to load from Isar first
    final savedMeals = IsarService.getAllMeals();
    if (savedMeals.isNotEmpty) {
      return savedMeals;
    }
    // Fall back to sample data
    return _generateSampleMeals();
  }

  void _persist() {
    IsarService.saveMeals(state);
  }

  void addMeal(Meal meal) {
    state = [...state, meal];
    _persist();
  }

  void removeMeal(String id) {
    state = state.where((m) => m.id != id).toList();
    IsarService.deleteMeal(id);
  }

  void updateMeal(Meal meal) {
    state = [
      for (final m in state)
        if (m.id == meal.id) meal else m,
    ];
    IsarService.saveMeal(meal);
  }

  List<Meal> getMealsForDate(DateTime date) {
    return state
        .where(
          (m) =>
              m.date.year == date.year &&
              m.date.month == date.month &&
              m.date.day == date.day,
        )
        .toList();
  }

  List<Meal> getMealsForMember(String memberId) {
    return state.where((m) => m.memberId == memberId).toList();
  }

  double getTotalMealsForMember(String memberId) {
    return state
        .where((m) => m.memberId == memberId)
        .fold(0.0, (sum, m) => sum + m.count);
  }
}

/// Total meals count (sum of all meal counts)
final totalMealsProvider = Provider<double>((ref) {
  final meals = ref.watch(mealsProvider);
  return meals.fold(0.0, (sum, m) => sum + m.count);
});

/// Meals per member
final mealsByMemberProvider = Provider<Map<String, double>>((ref) {
  final meals = ref.watch(mealsProvider);
  final result = <String, double>{};
  for (final meal in meals) {
    result[meal.memberId] = (result[meal.memberId] ?? 0) + meal.count;
  }
  return result;
});

/// Guest stats for tracking who brings guests most often
class GuestStats {
  final String memberId;
  final int totalGuests;
  final int guestMealCount; // Number of times they brought guests
  final double avgGuestsPerVisit;

  GuestStats({
    required this.memberId,
    required this.totalGuests,
    required this.guestMealCount,
    required this.avgGuestsPerVisit,
  });
}

/// Provider for guest history - tracks who brings guests most often (VIP Guest List)
final guestStatsProvider = Provider<List<GuestStats>>((ref) {
  final meals = ref.watch(mealsProvider);
  final guestData = <String, (int totalGuests, int timesWithGuests)>{};

  for (final meal in meals) {
    if (meal.guestCount > 0) {
      final current = guestData[meal.memberId] ?? (0, 0);
      guestData[meal.memberId] = (current.$1 + meal.guestCount, current.$2 + 1);
    }
  }

  final stats = guestData.entries.map((e) {
    return GuestStats(
      memberId: e.key,
      totalGuests: e.value.$1,
      guestMealCount: e.value.$2,
      avgGuestsPerVisit: e.value.$2 > 0 ? e.value.$1 / e.value.$2 : 0,
    );
  }).toList();

  // Sort by total guests descending (VIP = most guests)
  stats.sort((a, b) => b.totalGuests.compareTo(a.totalGuests));
  return stats;
});

/// Top guest bringers (top 3 members who bring most guests)
final topGuestBringersProvider = Provider<List<GuestStats>>((ref) {
  final stats = ref.watch(guestStatsProvider);
  return stats.take(3).toList();
});

/// Total guests this month
final monthlyGuestCountProvider = Provider<int>((ref) {
  final meals = ref.watch(mealsProvider);
  final now = DateTime.now();
  return meals
      .where((m) => m.date.year == now.year && m.date.month == now.month)
      .fold(0, (sum, m) => sum + m.guestCount);
});
