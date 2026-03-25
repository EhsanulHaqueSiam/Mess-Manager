import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';

import 'package:mess_manager/core/models/meal.dart';
import 'package:mess_manager/core/models/mess_settings.dart';
import 'package:mess_manager/core/providers/mess_settings_provider.dart';
import 'package:mess_manager/features/vacation/screens/bulk_cancel_screen.dart';

/// Meal Reminder Notification Model
class MealReminder {
  final String id;
  final DateTime date;
  final MealType mealType;
  final TimeOfDay reminderTime;
  final bool isDefault;
  final int guestCount;
  final bool isCancelled;

  const MealReminder({
    required this.id,
    required this.date,
    required this.mealType,
    required this.reminderTime,
    this.isDefault = true,
    this.guestCount = 0,
    this.isCancelled = false,
  });

  MealReminder copyWith({int? guestCount, bool? isCancelled, bool? isDefault}) {
    return MealReminder(
      id: id,
      date: date,
      mealType: mealType,
      reminderTime: reminderTime,
      isDefault: isDefault ?? this.isDefault,
      guestCount: guestCount ?? this.guestCount,
      isCancelled: isCancelled ?? this.isCancelled,
    );
  }
}

/// Meal Reminder Schedule — uses configurable times from MessSettings
class MealReminderSchedule {
  final MessSettings settings;

  const MealReminderSchedule(this.settings);

  /// Convenience: default schedule (for backward compat)
  static const _defaultSettings = MessSettings();

  TimeOfDay get nightBeforeTime =>
      TimeOfDay(hour: settings.nightPreviewHour, minute: settings.nightPreviewMinute);
  TimeOfDay get morningLunchTime =>
      TimeOfDay(hour: settings.lunchReminderHour, minute: settings.lunchReminderMinute);
  TimeOfDay get eveningDinnerTime =>
      TimeOfDay(hour: settings.dinnerReminderHour, minute: settings.dinnerReminderMinute);
  TimeOfDay get breakfastTime =>
      TimeOfDay(hour: settings.breakfastReminderHour, minute: settings.breakfastReminderMinute);

  /// Get scheduled reminders for a date
  List<ScheduledNotification> getRemindersForDate(DateTime date) {
    final reminders = <ScheduledNotification>[
      // Night before - for tomorrow's meals
      ScheduledNotification(
        id: 'night_${date.millisecondsSinceEpoch}',
        title: 'Tomorrow\'s Meals',
        body: 'Set your meals for tomorrow, or keep default',
        scheduledTime: _combineDateTime(
          date.subtract(const Duration(days: 1)),
          nightBeforeTime,
        ),
        type: NotificationType.mealPreview,
        icon: LucideIcons.moon,
      ),
    ];

    // Breakfast reminder (only in 3-meal system)
    if (settings.breakfastEnabled) {
      reminders.add(ScheduledNotification(
        id: 'breakfast_${date.millisecondsSinceEpoch}',
        title: 'Breakfast Reminder',
        body: 'Modify breakfast, add guest, or keep default',
        scheduledTime: _combineDateTime(date, breakfastTime),
        type: NotificationType.breakfastReminder,
        icon: LucideIcons.coffee,
      ));
    }

    // Lunch reminder
    reminders.add(ScheduledNotification(
      id: 'lunch_${date.millisecondsSinceEpoch}',
      title: 'Lunch Reminder',
      body: 'Modify lunch, add guest, or keep default settings',
      scheduledTime: _combineDateTime(date, morningLunchTime),
      type: NotificationType.lunchReminder,
      icon: LucideIcons.sun,
    ));

    // Dinner reminder
    reminders.add(ScheduledNotification(
      id: 'dinner_${date.millisecondsSinceEpoch}',
      title: 'Dinner Reminder',
      body: 'Modify dinner, add guest, or keep default settings',
      scheduledTime: _combineDateTime(date, eveningDinnerTime),
      type: NotificationType.dinnerReminder,
      icon: LucideIcons.sunset,
    ));

    return reminders;
  }

  /// Static convenience for default settings
  static List<ScheduledNotification> getDefaultRemindersForDate(DateTime date) {
    return const MealReminderSchedule(_defaultSettings).getRemindersForDate(date);
  }

  static DateTime _combineDateTime(DateTime date, TimeOfDay time) {
    return DateTime(date.year, date.month, date.day, time.hour, time.minute);
  }
}

/// Scheduled Notification
class ScheduledNotification {
  final String id;
  final String title;
  final String body;
  final DateTime scheduledTime;
  final NotificationType type;
  final IconData icon;

  const ScheduledNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.scheduledTime,
    required this.type,
    required this.icon,
  });
}

enum NotificationType {
  mealPreview, // Night before
  breakfastReminder,
  lunchReminder,
  dinnerReminder,
}

/// Meal Reminder Provider
class MealReminderNotifier extends Notifier<Map<String, MealReminder>> {
  @override
  Map<String, MealReminder> build() => {};

  /// Set meal for a specific date
  void setMeal({
    required DateTime date,
    required MealType type,
    int guestCount = 0,
    bool isCancelled = false,
  }) {
    final id = _generateId(date, type);
    state = {
      ...state,
      id: MealReminder(
        id: id,
        date: date,
        mealType: type,
        reminderTime: _getReminderTime(type),
        isDefault: false,
        guestCount: guestCount,
        isCancelled: isCancelled,
      ),
    };
  }

  /// Add guest to meal
  void addGuest(DateTime date, MealType type, int count) {
    final id = _generateId(date, type);
    final existing = state[id];

    if (existing != null) {
      state = {
        ...state,
        id: existing.copyWith(guestCount: existing.guestCount + count),
      };
    } else {
      setMeal(date: date, type: type, guestCount: count);
    }
  }

  /// Cancel meal
  void cancelMeal(DateTime date, MealType type) {
    setMeal(date: date, type: type, isCancelled: true);
  }

  /// Keep default (do nothing, just mark as acknowledged)
  void keepDefault(DateTime date, MealType type) {
    final id = _generateId(date, type);
    if (!state.containsKey(id)) {
      state = {
        ...state,
        id: MealReminder(
          id: id,
          date: date,
          mealType: type,
          reminderTime: _getReminderTime(type),
          isDefault: true,
        ),
      };
    }
  }

  /// Get meal status
  MealReminder? getMeal(DateTime date, MealType type) {
    final id = _generateId(date, type);
    return state[id];
  }

  String _generateId(DateTime date, MealType type) {
    return '${date.year}${date.month}${date.day}_${type.name}';
  }

  TimeOfDay _getReminderTime(MealType type) {
    final settings = ref.read(messSettingsProvider);
    return switch (type) {
      MealType.breakfast => TimeOfDay(
          hour: settings.breakfastReminderHour,
          minute: settings.breakfastReminderMinute,
        ),
      MealType.lunch => TimeOfDay(
          hour: settings.lunchReminderHour,
          minute: settings.lunchReminderMinute,
        ),
      MealType.dinner => TimeOfDay(
          hour: settings.dinnerReminderHour,
          minute: settings.dinnerReminderMinute,
        ),
    };
  }
}

final mealReminderProvider =
    NotifierProvider<MealReminderNotifier, Map<String, MealReminder>>(
  MealReminderNotifier.new,
);

/// Check if meal notifications should be skipped (due to cancellation)
final shouldSkipMealNotificationProvider =
    Provider.family<bool, (DateTime, MealType)>((ref, params) {
      final (date, mealType) = params;
      final cancellations = ref.watch(mealCancellationsProvider);
      return cancellations.any((c) => c.isMealCancelled(date, mealType));
    });
