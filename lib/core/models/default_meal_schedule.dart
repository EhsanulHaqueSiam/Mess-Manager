/// Default meal schedule for a member on a specific weekday
/// This represents the "expected" pattern, not actual entries
class DefaultMealSchedule {
  final String memberId;
  final int weekday; // 1 = Monday, 7 = Sunday
  final bool breakfast;
  final bool lunch;
  final bool dinner;

  const DefaultMealSchedule({
    required this.memberId,
    required this.weekday,
    this.breakfast = false,
    this.lunch = true,
    this.dinner = true,
  });

  DefaultMealSchedule copyWith({
    String? memberId,
    int? weekday,
    bool? breakfast,
    bool? lunch,
    bool? dinner,
  }) {
    return DefaultMealSchedule(
      memberId: memberId ?? this.memberId,
      weekday: weekday ?? this.weekday,
      breakfast: breakfast ?? this.breakfast,
      lunch: lunch ?? this.lunch,
      dinner: dinner ?? this.dinner,
    );
  }

  factory DefaultMealSchedule.fromJson(Map<String, dynamic> json) {
    return DefaultMealSchedule(
      memberId: json['memberId'] as String,
      weekday: (json['weekday'] ?? 0) as int,
      breakfast: json['breakfast'] as bool? ?? false,
      lunch: json['lunch'] as bool? ?? true,
      dinner: json['dinner'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'memberId': memberId,
      'weekday': weekday,
      'breakfast': breakfast,
      'lunch': lunch,
      'dinner': dinner,
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DefaultMealSchedule &&
          runtimeType == other.runtimeType &&
          memberId == other.memberId &&
          weekday == other.weekday &&
          breakfast == other.breakfast &&
          lunch == other.lunch &&
          dinner == other.dinner;

  @override
  int get hashCode => Object.hash(memberId, weekday, breakfast, lunch, dinner);

  @override
  String toString() {
    return 'DefaultMealSchedule(memberId: $memberId, weekday: $weekday, breakfast: $breakfast, lunch: $lunch, dinner: $dinner)';
  }
}

/// Weekly schedule summary for display
class WeeklySchedule {
  final String memberId;
  final List<DefaultMealSchedule> days; // 7 days (Mon-Sun)
  final double expectedWeeklyMeals;

  const WeeklySchedule({
    required this.memberId,
    required this.days,
    this.expectedWeeklyMeals = 0.0,
  });

  WeeklySchedule copyWith({
    String? memberId,
    List<DefaultMealSchedule>? days,
    double? expectedWeeklyMeals,
  }) {
    return WeeklySchedule(
      memberId: memberId ?? this.memberId,
      days: days ?? this.days,
      expectedWeeklyMeals: expectedWeeklyMeals ?? this.expectedWeeklyMeals,
    );
  }

  factory WeeklySchedule.fromJson(Map<String, dynamic> json) {
    return WeeklySchedule(
      memberId: json['memberId'] as String,
      days: (json['days'] as List?)
              ?.map((e) =>
                  DefaultMealSchedule.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      expectedWeeklyMeals:
          (json['expectedWeeklyMeals'] ?? 0.0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'memberId': memberId,
      'days': days.map((e) => e.toJson()).toList(),
      'expectedWeeklyMeals': expectedWeeklyMeals,
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WeeklySchedule &&
          runtimeType == other.runtimeType &&
          memberId == other.memberId &&
          days.length == other.days.length &&
          expectedWeeklyMeals == other.expectedWeeklyMeals;

  @override
  int get hashCode => Object.hash(
        memberId,
        Object.hashAll(days),
        expectedWeeklyMeals,
      );

  @override
  String toString() {
    return 'WeeklySchedule(memberId: $memberId, days: $days, expectedWeeklyMeals: $expectedWeeklyMeals)';
  }
}
