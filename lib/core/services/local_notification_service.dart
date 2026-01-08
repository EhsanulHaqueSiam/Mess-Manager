import 'dart:async';
import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz_data;

/// Local Notification Service
/// Schedules reminders for meals, duties, and alerts
class LocalNotificationService {
  static final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  static bool _initialized = false;

  /// Initialize notification service
  static Future<void> initialize() async {
    if (_initialized) return;

    tz_data.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Asia/Dhaka'));

    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notifications.initialize(
      settings,
      onDidReceiveNotificationResponse: _onNotificationTap,
    );

    _initialized = true;
    if (kDebugMode) debugPrint('LocalNotificationService initialized');
  }

  /// Handle notification tap
  static void _onNotificationTap(NotificationResponse response) {
    final payload = response.payload;
    if (payload != null) {
      if (kDebugMode) debugPrint('Notification tapped: $payload');
      // Handle navigation based on payload
      // e.g., 'meal_reminder', 'duty_reminder', 'desco_low'
    }
  }

  /// Request notification permissions
  static Future<bool> requestPermissions() async {
    final android = _notifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    final ios = _notifications
        .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin
        >();

    if (android != null) {
      final granted = await android.requestNotificationsPermission();
      return granted ?? false;
    }
    if (ios != null) {
      final granted = await ios.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
      return granted ?? false;
    }
    return true;
  }

  // ============== MEAL REMINDERS ==============

  /// Schedule daily meal reminder with guest prompt
  static Future<void> scheduleMealReminder({
    required int hour,
    required int minute,
    required String mealType, // 'lunch' or 'dinner'
  }) async {
    final id = mealType == 'lunch' ? 1 : 2;

    await _notifications.zonedSchedule(
      id,
      '🍽️ $mealType Reminder',
      'Bringing any guests today?',
      _nextInstanceOfTime(hour, minute),
      NotificationDetails(
        android: AndroidNotificationDetails(
          'meal_reminders',
          'Meal Reminders',
          channelDescription: 'Daily meal reminders with guest prompt',
          importance: Importance.high,
          priority: Priority.high,
          actions: [
            const AndroidNotificationAction('yes', 'Yes, guests'),
            const AndroidNotificationAction('no', 'No guests'),
          ],
        ),
        iOS: const DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
      payload: 'meal_reminder:$mealType',
    );

    if (kDebugMode) {
      debugPrint('Scheduled $mealType reminder at $hour:$minute');
    }
  }

  /// Cancel meal reminder
  static Future<void> cancelMealReminder(String mealType) async {
    final id = mealType == 'lunch' ? 1 : 2;
    await _notifications.cancel(id);
  }

  // ============== DUTY REMINDERS ==============

  /// Schedule duty reminder
  static Future<void> scheduleDutyReminder({
    required int id,
    required String dutyName,
    required DateTime date,
    required int hour,
    required int minute,
  }) async {
    final scheduledDate = DateTime(
      date.year,
      date.month,
      date.day,
      hour,
      minute,
    );

    if (scheduledDate.isBefore(DateTime.now())) return;

    await _notifications.zonedSchedule(
      100 + id.hashCode,
      '🧹 Duty Today: $dutyName',
      'Your turn for $dutyName duty',
      tz.TZDateTime.from(scheduledDate, tz.local),
      NotificationDetails(
        android: AndroidNotificationDetails(
          'duty_reminders',
          'Duty Reminders',
          channelDescription: 'Reminders for assigned duties',
          importance: Importance.high,
          priority: Priority.high,
        ),
        iOS: const DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      payload: 'duty_reminder:$dutyName',
    );
  }

  // ============== DESCO LOW BALANCE ==============

  /// Show low DESCO balance alert
  static Future<void> showLowDescoAlert(double balance) async {
    await _notifications.show(
      200,
      '⚡ Low DESCO Balance',
      'Only ৳${balance.toStringAsFixed(0)} remaining',
      NotificationDetails(
        android: AndroidNotificationDetails(
          'desco_alerts',
          'DESCO Alerts',
          channelDescription: 'Low balance alerts for DESCO meter',
          importance: Importance.high,
          priority: Priority.high,
          color: const Color(0xFFFF5722),
        ),
        iOS: const DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      payload: 'desco_low:$balance',
    );
  }

  // ============== SETTLEMENT REMINDERS ==============

  /// Show settlement reminder
  static Future<void> showSettlementReminder({
    required String fromName,
    required String toName,
    required double amount,
  }) async {
    await _notifications.show(
      300,
      '💰 Settlement Due',
      '$fromName owes $toName ৳${amount.toStringAsFixed(0)}',
      NotificationDetails(
        android: AndroidNotificationDetails(
          'settlement_reminders',
          'Settlement Reminders',
          channelDescription: 'Monthly settlement reminders',
          importance: Importance.high,
          priority: Priority.high,
        ),
        iOS: const DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      payload: 'settlement',
    );
  }

  // ============== BILL DUE REMINDERS ==============

  /// Schedule bill due reminder (fires 3 days before due date)
  static Future<void> scheduleBillDueReminder({
    required int id,
    required String billName,
    required double amount,
    required DateTime dueDate,
  }) async {
    // Schedule reminder 3 days before
    final reminderDate = dueDate.subtract(const Duration(days: 3));
    if (reminderDate.isBefore(DateTime.now())) return;

    await _notifications.zonedSchedule(
      400 + id.hashCode,
      '📅 Bill Due Soon: $billName',
      '৳${amount.toStringAsFixed(0)} due on ${dueDate.day}/${dueDate.month}',
      tz.TZDateTime.from(
        DateTime(reminderDate.year, reminderDate.month, reminderDate.day, 9, 0),
        tz.local,
      ),
      NotificationDetails(
        android: AndroidNotificationDetails(
          'bill_reminders',
          'Bill Reminders',
          channelDescription: 'Reminders for upcoming bills and fixed expenses',
          importance: Importance.high,
          priority: Priority.high,
          color: const Color(0xFF4CAF50),
        ),
        iOS: const DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      payload: 'bill_due:$billName',
    );

    if (kDebugMode) {
      debugPrint('Scheduled bill reminder for $billName on $reminderDate');
    }
  }

  /// Cancel bill reminder
  static Future<void> cancelBillReminder(int id) async {
    await _notifications.cancel(400 + id.hashCode);
  }

  // ============== BAZAR ROSTER ALERTS ==============

  /// Show "Your turn this week" bazar roster notification
  static Future<void> showBazarRosterAlert({
    required String memberName,
    required DateTime weekStartDate,
  }) async {
    await _notifications.show(
      500,
      '🛒 Your Bazar Turn This Week',
      '$memberName, you are on bazar duty starting ${weekStartDate.day}/${weekStartDate.month}',
      NotificationDetails(
        android: AndroidNotificationDetails(
          'bazar_roster',
          'Bazar Roster',
          channelDescription: 'Weekly bazar duty notifications',
          importance: Importance.high,
          priority: Priority.high,
          color: const Color(0xFF2196F3),
        ),
        iOS: const DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      payload: 'bazar_roster',
    );
  }

  // ============== PRICE SPIKE ALERTS ==============

  /// Show price spike alert when an item exceeds historical average
  static Future<void> showPriceSpikeAlert({
    required String itemName,
    required double currentPrice,
    required double avgPrice,
    required int percentIncrease,
  }) async {
    await _notifications.show(
      600,
      '📈 Price Spike: $itemName',
      '৳${currentPrice.toStringAsFixed(0)} (+$percentIncrease% from avg ৳${avgPrice.toStringAsFixed(0)})',
      NotificationDetails(
        android: AndroidNotificationDetails(
          'price_alerts',
          'Price Alerts',
          channelDescription: 'Alerts when prices exceed historical average',
          importance: Importance.defaultImportance,
          priority: Priority.defaultPriority,
          color: const Color(0xFFFF9800),
        ),
        iOS: const DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      payload: 'price_spike:$itemName',
    );
  }

  // ============== HELPERS ==============

  /// Get next instance of a specific time
  static tz.TZDateTime _nextInstanceOfTime(int hour, int minute) {
    final now = tz.TZDateTime.now(tz.local);
    var scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }

  /// Cancel all notifications
  static Future<void> cancelAll() async {
    await _notifications.cancelAll();
  }

  /// Get pending notifications
  static Future<List<PendingNotificationRequest>> getPending() async {
    return _notifications.pendingNotificationRequests();
  }
}
