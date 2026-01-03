import 'dart:async';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

import 'package:mess_manager/core/services/firebase_service.dart';

/// Background message handler (must be top-level function)
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Handle background message
  debugPrint('Background message: ${message.messageId}');
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
    _messaging.onTokenRefresh.listen((newToken) {
      _token = newToken;
      if (kDebugMode) {
        debugPrint('FCM Token refreshed: $newToken');
      }
      // TODO: Update token in Firestore for user
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

      // You can show a local notification here if needed
      // Or update app state
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
