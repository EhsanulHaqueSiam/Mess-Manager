import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_notification.freezed.dart';
part 'app_notification.g.dart';

/// Notification Types
enum NotificationType { info, success, warning, error, chat, bill, duty }

/// App Notification Model
@freezed
sealed class AppNotification with _$AppNotification {
  const factory AppNotification({
    required String id,
    required String title,
    required String body,
    @Default(NotificationType.info) NotificationType type,
    required DateTime timestamp,
    @Default(false) bool isRead,
    String? payload,
  }) = _AppNotification;

  factory AppNotification.fromJson(Map<String, dynamic> json) =>
      _$AppNotificationFromJson(json);
}
