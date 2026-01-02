// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'default_meal_schedule.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_DefaultMealSchedule _$DefaultMealScheduleFromJson(Map<String, dynamic> json) =>
    _DefaultMealSchedule(
      memberId: json['memberId'] as String,
      weekday: (json['weekday'] as num).toInt(),
      breakfast: json['breakfast'] as bool? ?? false,
      lunch: json['lunch'] as bool? ?? true,
      dinner: json['dinner'] as bool? ?? true,
    );

Map<String, dynamic> _$DefaultMealScheduleToJson(
  _DefaultMealSchedule instance,
) => <String, dynamic>{
  'memberId': instance.memberId,
  'weekday': instance.weekday,
  'breakfast': instance.breakfast,
  'lunch': instance.lunch,
  'dinner': instance.dinner,
};

_WeeklySchedule _$WeeklyScheduleFromJson(Map<String, dynamic> json) =>
    _WeeklySchedule(
      memberId: json['memberId'] as String,
      days: (json['days'] as List<dynamic>)
          .map((e) => DefaultMealSchedule.fromJson(e as Map<String, dynamic>))
          .toList(),
      expectedWeeklyMeals:
          (json['expectedWeeklyMeals'] as num?)?.toDouble() ?? 0.0,
    );

Map<String, dynamic> _$WeeklyScheduleToJson(_WeeklySchedule instance) =>
    <String, dynamic>{
      'memberId': instance.memberId,
      'days': instance.days,
      'expectedWeeklyMeals': instance.expectedWeeklyMeals,
    };
