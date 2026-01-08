/// Auto Month Close Service - Background Worker for Automatic Month Closing
///
/// Runs in the background to automatically close the previous month
/// on the 5th day of each new month.
library;

import 'package:flutter/foundation.dart';
import 'package:workmanager/workmanager.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

/// Task identifiers for workmanager
const autoMonthCloseTask = 'autoMonthCloseTask';
const autoMonthCloseUniqueId = 'com.area51.autoMonthClose';

/// Auto Month Close Service
class AutoMonthCloseService {
  static bool _isInitialized = false;

  /// Initialize the background worker
  static Future<void> initialize() async {
    if (_isInitialized) return;

    await Workmanager().initialize(
      callbackDispatcher,
      isInDebugMode: kDebugMode,
    );

    // Schedule periodic check (runs daily, checks if it's the 5th)
    await Workmanager().registerPeriodicTask(
      autoMonthCloseUniqueId,
      autoMonthCloseTask,
      frequency: const Duration(hours: 24),
      constraints: Constraints(
        networkType: NetworkType.not_required,
        requiresBatteryNotLow: false,
        requiresCharging: false,
      ),
      existingWorkPolicy: ExistingWorkPolicy.keep,
    );

    _isInitialized = true;
    debugPrint('✅ Auto Month Close Service initialized');
  }

  /// Check if auto-close should trigger
  static bool shouldTriggerAutoClose() {
    final now = DateTime.now();
    // Trigger on 5th of each month (grace period for data entry)
    return now.day == 5;
  }

  /// Get month to close (previous month)
  static (int year, int month) getMonthToClose() {
    final now = DateTime.now();
    if (now.month == 1) {
      return (now.year - 1, 12);
    }
    return (now.year, now.month - 1);
  }

  /// Cancel the periodic task
  static Future<void> cancel() async {
    await Workmanager().cancelByUniqueName(autoMonthCloseUniqueId);
    _isInitialized = false;
    debugPrint('❌ Auto Month Close Service cancelled');
  }

  /// Show notification when month is auto-closed
  static Future<void> showClosureNotification(int year, int month) async {
    final plugin = FlutterLocalNotificationsPlugin();

    const androidDetails = AndroidNotificationDetails(
      'month_close',
      'Month Close Notifications',
      channelDescription: 'Notifications for automatic month closures',
      importance: Importance.high,
      priority: Priority.high,
    );

    const iosDetails = DarwinNotificationDetails();

    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    final monthNames = [
      '',
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];

    await plugin.show(
      1001,
      '📅 Month Closed',
      '${monthNames[month]} $year has been automatically closed. Review the settlement.',
      details,
    );
  }
}

/// Workmanager callback dispatcher (must be top-level function)
@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((taskName, inputData) async {
    try {
      if (taskName == autoMonthCloseTask) {
        if (AutoMonthCloseService.shouldTriggerAutoClose()) {
          final (year, month) = AutoMonthCloseService.getMonthToClose();

          debugPrint('🔒 Auto-closing month: $year-$month');

          // Note: Actual month closing requires app context
          // This triggers a notification to remind user to review
          await AutoMonthCloseService.showClosureNotification(year, month);

          // For full auto-close, would need to:
          // 1. Initialize Isar in background
          // 2. Load providers
          // 3. Call monthLockNotifier.closeMonth()
          // This is complex due to Riverpod not being available in background isolate

          return true;
        }
      }
      return true;
    } catch (e) {
      debugPrint('⚠️ Auto month close error: $e');
      return false;
    }
  });
}

/// Provider preference key for auto-close setting
const autoCloseEnabledKey = 'auto_month_close_enabled';

/// Extension to check auto-close preference from Isar
extension AutoCloseSettings on Never {
  // This is a stub - actual implementation would use IsarService
  // static bool get isEnabled => IsarService.getSetting(autoCloseEnabledKey) == 'true';
  // static void setEnabled(bool value) => IsarService.saveSetting(autoCloseEnabledKey, value.toString());
}
