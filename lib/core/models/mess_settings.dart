/// Mess-wide configuration managed by superAdmin
class MessSettings {
  /// Number of meals per day: 2 (lunch + dinner) or 3 (breakfast + lunch + dinner)
  final int mealSystemCount;

  /// Notification time for lunch reminder (hour:minute in 24h)
  final int lunchReminderHour;
  final int lunchReminderMinute;

  /// Notification time for dinner reminder
  final int dinnerReminderHour;
  final int dinnerReminderMinute;

  /// Notification time for breakfast reminder (only used when mealSystemCount == 3)
  final int breakfastReminderHour;
  final int breakfastReminderMinute;

  /// Night-before preview notification time
  final int nightPreviewHour;
  final int nightPreviewMinute;

  const MessSettings({
    this.mealSystemCount = 2,
    this.lunchReminderHour = 9,
    this.lunchReminderMinute = 0,
    this.dinnerReminderHour = 17,
    this.dinnerReminderMinute = 0,
    this.breakfastReminderHour = 7,
    this.breakfastReminderMinute = 0,
    this.nightPreviewHour = 21,
    this.nightPreviewMinute = 0,
  });

  bool get isThreeMealSystem => mealSystemCount == 3;
  bool get breakfastEnabled => mealSystemCount >= 3;

  MessSettings copyWith({
    int? mealSystemCount,
    int? lunchReminderHour,
    int? lunchReminderMinute,
    int? dinnerReminderHour,
    int? dinnerReminderMinute,
    int? breakfastReminderHour,
    int? breakfastReminderMinute,
    int? nightPreviewHour,
    int? nightPreviewMinute,
  }) {
    return MessSettings(
      mealSystemCount: mealSystemCount ?? this.mealSystemCount,
      lunchReminderHour: lunchReminderHour ?? this.lunchReminderHour,
      lunchReminderMinute: lunchReminderMinute ?? this.lunchReminderMinute,
      dinnerReminderHour: dinnerReminderHour ?? this.dinnerReminderHour,
      dinnerReminderMinute: dinnerReminderMinute ?? this.dinnerReminderMinute,
      breakfastReminderHour: breakfastReminderHour ?? this.breakfastReminderHour,
      breakfastReminderMinute: breakfastReminderMinute ?? this.breakfastReminderMinute,
      nightPreviewHour: nightPreviewHour ?? this.nightPreviewHour,
      nightPreviewMinute: nightPreviewMinute ?? this.nightPreviewMinute,
    );
  }

  factory MessSettings.fromJson(Map<String, dynamic> json) {
    return MessSettings(
      mealSystemCount: (json['mealSystemCount'] ?? 2) as int,
      lunchReminderHour: (json['lunchReminderHour'] ?? 9) as int,
      lunchReminderMinute: (json['lunchReminderMinute'] ?? 0) as int,
      dinnerReminderHour: (json['dinnerReminderHour'] ?? 17) as int,
      dinnerReminderMinute: (json['dinnerReminderMinute'] ?? 0) as int,
      breakfastReminderHour: (json['breakfastReminderHour'] ?? 7) as int,
      breakfastReminderMinute: (json['breakfastReminderMinute'] ?? 0) as int,
      nightPreviewHour: (json['nightPreviewHour'] ?? 21) as int,
      nightPreviewMinute: (json['nightPreviewMinute'] ?? 0) as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'mealSystemCount': mealSystemCount,
      'lunchReminderHour': lunchReminderHour,
      'lunchReminderMinute': lunchReminderMinute,
      'dinnerReminderHour': dinnerReminderHour,
      'dinnerReminderMinute': dinnerReminderMinute,
      'breakfastReminderHour': breakfastReminderHour,
      'breakfastReminderMinute': breakfastReminderMinute,
      'nightPreviewHour': nightPreviewHour,
      'nightPreviewMinute': nightPreviewMinute,
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MessSettings &&
          runtimeType == other.runtimeType &&
          mealSystemCount == other.mealSystemCount &&
          lunchReminderHour == other.lunchReminderHour &&
          lunchReminderMinute == other.lunchReminderMinute &&
          dinnerReminderHour == other.dinnerReminderHour &&
          dinnerReminderMinute == other.dinnerReminderMinute &&
          breakfastReminderHour == other.breakfastReminderHour &&
          breakfastReminderMinute == other.breakfastReminderMinute &&
          nightPreviewHour == other.nightPreviewHour &&
          nightPreviewMinute == other.nightPreviewMinute;

  @override
  int get hashCode => Object.hash(
        mealSystemCount,
        lunchReminderHour,
        lunchReminderMinute,
        dinnerReminderHour,
        dinnerReminderMinute,
        breakfastReminderHour,
        breakfastReminderMinute,
        nightPreviewHour,
        nightPreviewMinute,
      );

  @override
  String toString() =>
      'MessSettings(meals: $mealSystemCount, lunch: $lunchReminderHour:$lunchReminderMinute, dinner: $dinnerReminderHour:$dinnerReminderMinute)';
}
