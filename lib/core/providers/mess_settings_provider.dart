import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mess_manager/core/models/mess_settings.dart';
import 'package:mess_manager/core/database/isar_service.dart';

const _settingsKey = 'mess_settings';

/// Provider for mess-wide settings (meal system, notification times)
final messSettingsProvider =
    NotifierProvider<MessSettingsNotifier, MessSettings>(
  MessSettingsNotifier.new,
);

class MessSettingsNotifier extends Notifier<MessSettings> {
  @override
  MessSettings build() {
    // Load from local storage
    final json = IsarService.getSetting<Map<String, dynamic>>(_settingsKey);
    if (json != null) {
      return MessSettings.fromJson(json);
    }
    return const MessSettings(); // defaults: 2 meals, standard times
  }

  /// Update meal system count (2 or 3)
  void setMealSystem(int count) {
    assert(count == 2 || count == 3);
    state = state.copyWith(mealSystemCount: count);
    _persist();
    debugPrint('Meal system updated to $count meals/day');
  }

  /// Update lunch reminder time
  void setLunchReminderTime(int hour, int minute) {
    state = state.copyWith(
      lunchReminderHour: hour,
      lunchReminderMinute: minute,
    );
    _persist();
  }

  /// Update dinner reminder time
  void setDinnerReminderTime(int hour, int minute) {
    state = state.copyWith(
      dinnerReminderHour: hour,
      dinnerReminderMinute: minute,
    );
    _persist();
  }

  /// Update breakfast reminder time
  void setBreakfastReminderTime(int hour, int minute) {
    state = state.copyWith(
      breakfastReminderHour: hour,
      breakfastReminderMinute: minute,
    );
    _persist();
  }

  /// Update night preview time
  void setNightPreviewTime(int hour, int minute) {
    state = state.copyWith(
      nightPreviewHour: hour,
      nightPreviewMinute: minute,
    );
    _persist();
  }

  void _persist() {
    IsarService.saveSetting(_settingsKey, state.toJson());
  }
}

/// Whether breakfast is enabled mess-wide
final breakfastEnabledProvider = Provider<bool>((ref) {
  return ref.watch(messSettingsProvider).breakfastEnabled;
});

/// Current meal system count (2 or 3)
final mealSystemCountProvider = Provider<int>((ref) {
  return ref.watch(messSettingsProvider).mealSystemCount;
});
