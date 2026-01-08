// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_notification.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AppNotification _$AppNotificationFromJson(Map<String, dynamic> json) =>
    _AppNotification(
      id: json['id'] as String,
      title: json['title'] as String,
      body: json['body'] as String,
      type:
          $enumDecodeNullable(_$NotificationTypeEnumMap, json['type']) ??
          NotificationType.info,
      timestamp: DateTime.parse(json['timestamp'] as String),
      isRead: json['isRead'] as bool? ?? false,
      payload: json['payload'] as String?,
    );

Map<String, dynamic> _$AppNotificationToJson(_AppNotification instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'body': instance.body,
      'type': _$NotificationTypeEnumMap[instance.type]!,
      'timestamp': instance.timestamp.toIso8601String(),
      'isRead': instance.isRead,
      'payload': instance.payload,
    };

const _$NotificationTypeEnumMap = {
  NotificationType.info: 'info',
  NotificationType.success: 'success',
  NotificationType.warning: 'warning',
  NotificationType.error: 'error',
  NotificationType.chat: 'chat',
  NotificationType.bill: 'bill',
  NotificationType.duty: 'duty',
};
