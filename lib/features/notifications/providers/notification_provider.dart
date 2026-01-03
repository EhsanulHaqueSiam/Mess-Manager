import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mess_manager/core/services/storage_service.dart';

/// Notification types
enum NotificationType {
  mealReminder,
  bazarOverdue,
  billDue,
  lowDescoBalance,
  dutyReminder,
  newEntry,
}

/// Notification settings state
class NotificationSettings {
  final bool enabled;
  final bool mealReminder;
  final bool bazarOverdue;
  final bool billDue;
  final bool lowDescoBalance;
  final bool dutyReminder;
  final bool newEntry;

  const NotificationSettings({
    this.enabled = true,
    this.mealReminder = true,
    this.bazarOverdue = true,
    this.billDue = true,
    this.lowDescoBalance = true,
    this.dutyReminder = true,
    this.newEntry = true,
  });

  NotificationSettings copyWith({
    bool? enabled,
    bool? mealReminder,
    bool? bazarOverdue,
    bool? billDue,
    bool? lowDescoBalance,
    bool? dutyReminder,
    bool? newEntry,
  }) {
    return NotificationSettings(
      enabled: enabled ?? this.enabled,
      mealReminder: mealReminder ?? this.mealReminder,
      bazarOverdue: bazarOverdue ?? this.bazarOverdue,
      billDue: billDue ?? this.billDue,
      lowDescoBalance: lowDescoBalance ?? this.lowDescoBalance,
      dutyReminder: dutyReminder ?? this.dutyReminder,
      newEntry: newEntry ?? this.newEntry,
    );
  }

  Map<String, dynamic> toJson() => {
    'enabled': enabled,
    'mealReminder': mealReminder,
    'bazarOverdue': bazarOverdue,
    'billDue': billDue,
    'lowDescoBalance': lowDescoBalance,
    'dutyReminder': dutyReminder,
    'newEntry': newEntry,
  };

  factory NotificationSettings.fromJson(Map<String, dynamic> json) {
    return NotificationSettings(
      enabled: json['enabled'] as bool? ?? true,
      mealReminder: json['mealReminder'] as bool? ?? true,
      bazarOverdue: json['bazarOverdue'] as bool? ?? true,
      billDue: json['billDue'] as bool? ?? true,
      lowDescoBalance: json['lowDescoBalance'] as bool? ?? true,
      dutyReminder: json['dutyReminder'] as bool? ?? true,
      newEntry: json['newEntry'] as bool? ?? true,
    );
  }
}

/// Notification settings provider
class NotificationSettingsNotifier extends Notifier<NotificationSettings> {
  @override
  NotificationSettings build() {
    return _load();
  }

  NotificationSettings _load() {
    final json = StorageService.loadJson('notification_settings');
    if (json != null) {
      return NotificationSettings.fromJson(json);
    }
    return const NotificationSettings();
  }

  Future<void> _save() async {
    await StorageService.saveJson('notification_settings', state.toJson());
  }

  Future<void> toggle(NotificationType type) async {
    switch (type) {
      case NotificationType.mealReminder:
        state = state.copyWith(mealReminder: !state.mealReminder);
      case NotificationType.bazarOverdue:
        state = state.copyWith(bazarOverdue: !state.bazarOverdue);
      case NotificationType.billDue:
        state = state.copyWith(billDue: !state.billDue);
      case NotificationType.lowDescoBalance:
        state = state.copyWith(lowDescoBalance: !state.lowDescoBalance);
      case NotificationType.dutyReminder:
        state = state.copyWith(dutyReminder: !state.dutyReminder);
      case NotificationType.newEntry:
        state = state.copyWith(newEntry: !state.newEntry);
    }
    await _save();
  }

  Future<void> toggleAll() async {
    state = state.copyWith(enabled: !state.enabled);
    await _save();
  }
}

final notificationSettingsProvider =
    NotifierProvider<NotificationSettingsNotifier, NotificationSettings>(
      NotificationSettingsNotifier.new,
    );
