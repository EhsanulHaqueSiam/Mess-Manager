import 'dart:async';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

import 'package:mess_manager/core/services/firebase_service.dart';
import 'package:mess_manager/core/database/isar_service.dart';
import 'package:mess_manager/core/models/app_notification.dart';

/// Background message handler (must be top-level function)
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Handle background message
  debugPrint('Background message: ${message.messageId}');

  if (message.notification != null) {
    try {
      await IsarService.init();
      final type = FCMService.getTypeFromData(message.data);
      final n = AppNotification(
        id:
            message.messageId ??
            DateTime.now().millisecondsSinceEpoch.toString(),
        title: message.notification!.title ?? 'New Message',
        body: message.notification!.body ?? '',
        type: type,
        timestamp: message.sentTime ?? DateTime.now(),
        payload: message.data.toString(),
      );
      IsarService.saveNotification(n);
    } catch (e) {
      debugPrint('Bg Save Error: $e');
    }
  }
}

/// Firebase Cloud Messaging Service
/// Handles push notifications
class FCMService {
  static final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  static String? _token;

  /// Initialize FCM
  static Future<void> initialize() async {
    // Set background message handler
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // Request permission (iOS and Web)
    final settings = await _messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (kDebugMode) {
      debugPrint('FCM Permission status: ${settings.authorizationStatus}');
    }

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      await _getToken();
      _setupTokenRefresh();
      _setupForegroundMessageHandler();
    }
  }

  /// Get FCM token
  static Future<String?> _getToken() async {
    try {
      _token = await _messaging.getToken();
      if (kDebugMode) {
        debugPrint('FCM Token: $_token');
      }
      await FirebaseService.logEvent(name: 'fcm_token_obtained');
      return _token;
    } catch (e) {
      await FirebaseService.logError(
        e,
        StackTrace.current,
        reason: 'Get FCM token failed',
      );
      return null;
    }
  }

  /// Get current token
  static String? get token => _token;

  /// Setup token refresh listener
  static void _setupTokenRefresh() {
    _messaging.onTokenRefresh.listen((newToken) async {
      _token = newToken;
      if (kDebugMode) {
        debugPrint('FCM Token refreshed: $newToken');
      }

      // Persist token locally
      IsarService.saveSetting('fcm_token', newToken);

      // Optionally sync to Firestore if user is authenticated
      try {
        await FirebaseService.logEvent(
          name: 'fcm_token_refreshed',
          parameters: {'token_length': newToken.length},
        );
      } catch (e) {
        debugPrint('FCM token sync failed: $e');
      }
    });
  }

  /// Setup foreground message handler
  static void _setupForegroundMessageHandler() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (kDebugMode) {
        debugPrint(
          'Foreground message received: ${message.notification?.title}',
        );
      }

      // Handle the message
      _handleMessage(message);
    });

    // Handle message tap when app is in background
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      if (kDebugMode) {
        debugPrint('Message opened from background: ${message.data}');
      }
      _handleMessageTap(message);
    });
  }

  /// Handle incoming message
  static void _handleMessage(RemoteMessage message) {
    final notification = message.notification;
    if (notification != null) {
      // Log the notification
      FirebaseService.logEvent(
        name: 'notification_received',
        parameters: {'title': notification.title ?? 'No title'},
      );

      // Save to history
      try {
        final type = getTypeFromData(message.data);
        final n = AppNotification(
          id:
              message.messageId ??
              DateTime.now().millisecondsSinceEpoch.toString(),
          title: notification.title ?? 'New Message',
          body: notification.body ?? '',
          type: type,
          timestamp: message.sentTime ?? DateTime.now(),
          payload: message.data.toString(),
        );
        IsarService.saveNotification(n);
      } catch (e) {
        debugPrint('Save Error: $e');
      }
    }
  }

  /// Parse notification type
  static NotificationType getTypeFromData(Map<String, dynamic> data) {
    final type = data['type'] as String?;
    switch (type) {
      case 'bill':
      case 'bill_due':
        return NotificationType.bill;
      case 'duty':
        return NotificationType.duty;
      case 'chat':
        return NotificationType.chat;
      case 'bazar_alert':
        return NotificationType.warning;
      case 'success':
        return NotificationType.success;
      case 'error':
        return NotificationType.error;
      default:
        return NotificationType.info;
    }
  }

  /// Handle message tap
  static void _handleMessageTap(RemoteMessage message) {
    FirebaseService.logEvent(
      name: 'notification_tapped',
      parameters: {'data': message.data.toString()},
    );

    // Navigate to relevant screen based on message data
    final type = message.data['type'];
    switch (type) {
      case 'meal_reminder':
        // Navigate to meals screen
        break;
      case 'bazar_alert':
        // Navigate to bazar screen
        break;
      case 'bill_due':
        // Navigate to bills screen
        break;
    }
  }

  /// Subscribe to topic (for group notifications)
  static Future<void> subscribeToTopic(String topic) async {
    try {
      await _messaging.subscribeToTopic(topic);
      await FirebaseService.logEvent(
        name: 'fcm_topic_subscribed',
        parameters: {'topic': topic},
      );
    } catch (e) {
      await FirebaseService.logError(
        e,
        StackTrace.current,
        reason: 'Subscribe to topic failed',
      );
    }
  }

  /// Unsubscribe from topic
  static Future<void> unsubscribeFromTopic(String topic) async {
    try {
      await _messaging.unsubscribeFromTopic(topic);
      await FirebaseService.logEvent(
        name: 'fcm_topic_unsubscribed',
        parameters: {'topic': topic},
      );
    } catch (e) {
      await FirebaseService.logError(
        e,
        StackTrace.current,
        reason: 'Unsubscribe from topic failed',
      );
    }
  }

  /// Subscribe to mess notifications
  static Future<void> subscribeToMess(String messId) async {
    await subscribeToTopic('mess_$messId');
  }

  /// Unsubscribe from mess notifications
  static Future<void> unsubscribeFromMess(String messId) async {
    await unsubscribeFromTopic('mess_$messId');
  }

  /// Get initial message (app opened from terminated state via notification)
  static Future<RemoteMessage?> getInitialMessage() async {
    return _messaging.getInitialMessage();
  }
}
