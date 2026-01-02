import 'package:freezed_annotation/freezed_annotation.dart';

part 'default_meal_schedule.freezed.dart';
part 'default_meal_schedule.g.dart';

/// Default meal schedule for a member on a specific weekday
/// This represents the "expected" pattern, not actual entries
@freezed
sealed class DefaultMealSchedule with _$DefaultMealSchedule {
  const factory DefaultMealSchedule({
    required String memberId,
    required int weekday, // 1 = Monday, 7 = Sunday
    @Default(false) bool breakfast,
    @Default(true) bool lunch,
    @Default(true) bool dinner,
  }) = _DefaultMealSchedule;

  factory DefaultMealSchedule.fromJson(Map<String, dynamic> json) =>
      _$DefaultMealScheduleFromJson(json);
}

/// Weekly schedule summary for display
@freezed
sealed class WeeklySchedule with _$WeeklySchedule {
  const factory WeeklySchedule({
    required String memberId,
    required List<DefaultMealSchedule> days, // 7 days (Mon-Sun)
    @Default(0.0) double expectedWeeklyMeals,
  }) = _WeeklySchedule;

  factory WeeklySchedule.fromJson(Map<String, dynamic> json) =>
      _$WeeklyScheduleFromJson(json);
}
