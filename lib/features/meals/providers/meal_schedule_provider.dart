import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mess_manager/core/models/default_meal_schedule.dart';
import 'package:mess_manager/core/providers/members_provider.dart';

/// Generate default schedule for a member (lunch + dinner every day)
List<DefaultMealSchedule> _generateDefaultScheduleForMember(String memberId) {
  return List.generate(7, (index) {
    final weekday = index + 1; // 1 = Monday
    return DefaultMealSchedule(
      memberId: memberId,
      weekday: weekday,
      breakfast: false,
      lunch: true,
      dinner: true,
    );
  });
}

/// Generate default schedules for all sample members
Map<String, List<DefaultMealSchedule>> _generateSampleSchedules() {
  return {
    '1': _generateDefaultScheduleForMember('1'), // Siam
    '2': _generateDefaultScheduleForMember('2'), // Tanmoy
    '3': _generateDefaultScheduleForMember('3'), // Sarkar
    '4': [
      // Shahriyer - only dinner
      for (int day = 1; day <= 7; day++)
        DefaultMealSchedule(
          memberId: '4',
          weekday: day,
          breakfast: false,
          lunch: false,
          dinner: true,
        ),
    ],
  };
}

/// Provider for all member schedules
final mealScheduleProvider =
    NotifierProvider<
      MealScheduleNotifier,
      Map<String, List<DefaultMealSchedule>>
    >(MealScheduleNotifier.new);

class MealScheduleNotifier
    extends Notifier<Map<String, List<DefaultMealSchedule>>> {
  @override
  Map<String, List<DefaultMealSchedule>> build() => _generateSampleSchedules();

  /// Get schedule for a specific member
  List<DefaultMealSchedule> getScheduleForMember(String memberId) {
    return state[memberId] ?? _generateDefaultScheduleForMember(memberId);
  }

  /// Update a single day's schedule
  void updateDaySchedule(
    String memberId,
    int weekday, {
    bool? breakfast,
    bool? lunch,
    bool? dinner,
  }) {
    final memberSchedule = List<DefaultMealSchedule>.from(
      state[memberId] ?? _generateDefaultScheduleForMember(memberId),
    );

    final dayIndex = weekday - 1;
    if (dayIndex >= 0 && dayIndex < 7) {
      final current = memberSchedule[dayIndex];
      memberSchedule[dayIndex] = DefaultMealSchedule(
        memberId: memberId,
        weekday: weekday,
        breakfast: breakfast ?? current.breakfast,
        lunch: lunch ?? current.lunch,
        dinner: dinner ?? current.dinner,
      );

      state = {...state, memberId: memberSchedule};
    }
  }

  /// Toggle a meal type for a specific day
  void toggleMeal(String memberId, int weekday, String mealType) {
    final memberSchedule =
        state[memberId] ?? _generateDefaultScheduleForMember(memberId);
    final dayIndex = weekday - 1;

    if (dayIndex >= 0 && dayIndex < 7) {
      final current = memberSchedule[dayIndex];
      switch (mealType) {
        case 'breakfast':
          updateDaySchedule(memberId, weekday, breakfast: !current.breakfast);
          break;
        case 'lunch':
          updateDaySchedule(memberId, weekday, lunch: !current.lunch);
          break;
        case 'dinner':
          updateDaySchedule(memberId, weekday, dinner: !current.dinner);
          break;
      }
    }
  }

  /// Apply one member's schedule to all members
  void applyToAll(String sourceMemberId) {
    final sourceSchedule = state[sourceMemberId];
    if (sourceSchedule == null) return;

    final members = ref.read(membersProvider);
    final newState = <String, List<DefaultMealSchedule>>{};

    for (final member in members) {
      newState[member.id] = [
        for (final day in sourceSchedule)
          DefaultMealSchedule(
            memberId: member.id,
            weekday: day.weekday,
            breakfast: day.breakfast,
            lunch: day.lunch,
            dinner: day.dinner,
          ),
      ];
    }

    state = newState;
  }

  /// Calculate expected weekly meals for a member
  double getExpectedWeeklyMeals(String memberId) {
    final schedule = state[memberId] ?? [];
    double total = 0;
    for (final day in schedule) {
      if (day.breakfast) total += 1;
      if (day.lunch) total += 1;
      if (day.dinner) total += 1;
    }
    return total;
  }
}

/// Expected weekly meals for current member
final currentMemberExpectedMealsProvider = Provider<double>((ref) {
  final currentId = ref.watch(currentMemberIdProvider);
  final schedules = ref.watch(mealScheduleProvider);
  final schedule = schedules[currentId] ?? [];

  double total = 0;
  for (final day in schedule) {
    if (day.breakfast) total += 1;
    if (day.lunch) total += 1;
    if (day.dinner) total += 1;
  }
  return total;
});

/// All members expected weekly meals
final allMembersExpectedMealsProvider = Provider<Map<String, double>>((ref) {
  final schedules = ref.watch(mealScheduleProvider);
  final result = <String, double>{};

  for (final entry in schedules.entries) {
    double total = 0;
    for (final day in entry.value) {
      if (day.breakfast) total += 1;
      if (day.lunch) total += 1;
      if (day.dinner) total += 1;
    }
    result[entry.key] = total;
  }

  return result;
});
