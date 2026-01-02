import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mess_manager/core/models/meal.dart';
import 'package:mess_manager/core/services/storage_service.dart';

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
    // Try to load from storage first
    final savedMeals = StorageService.loadMealsJson();
    if (savedMeals.isNotEmpty) {
      return savedMeals.map((json) => Meal.fromJson(json)).toList();
    }
    // Fall back to sample data
    return _generateSampleMeals();
  }

  void _persist() {
    StorageService.saveMeals(state);
  }

  void addMeal(Meal meal) {
    state = [...state, meal];
    _persist();
  }

  void removeMeal(String id) {
    state = state.where((m) => m.id != id).toList();
    _persist();
  }

  void updateMeal(Meal meal) {
    state = [
      for (final m in state)
        if (m.id == meal.id) meal else m,
    ];
    _persist();
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
