/// Notification Types
enum NotificationType { info, success, warning, error, chat, bill, duty }

/// App Notification Model
class AppNotification {
  final String id;
  final String title;
  final String body;
  final NotificationType type;
  final DateTime timestamp;
  final bool isRead;
  final String? payload;

  const AppNotification({
    required this.id,
    required this.title,
    required this.body,
    this.type = NotificationType.info,
    required this.timestamp,
    this.isRead = false,
    this.payload,
  });

  AppNotification copyWith({
    String? id,
    String? title,
    String? body,
    NotificationType? type,
    DateTime? timestamp,
    bool? isRead,
    String? payload,
  }) {
    return AppNotification(
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      type: type ?? this.type,
      timestamp: timestamp ?? this.timestamp,
      isRead: isRead ?? this.isRead,
      payload: payload ?? this.payload,
    );
  }

  factory AppNotification.fromJson(Map<String, dynamic> json) {
    return AppNotification(
      id: json['id'] as String,
      title: json['title'] as String,
      body: json['body'] as String,
      type: NotificationType.values.byName(
        json['type'] as String? ?? 'info',
      ),
      timestamp: DateTime.parse(json['timestamp'] as String),
      isRead: json['isRead'] as bool? ?? false,
      payload: json['payload'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'body': body,
      'type': type.name,
      'timestamp': timestamp.toIso8601String(),
      'isRead': isRead,
      'payload': payload,
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppNotification &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          title == other.title &&
          body == other.body &&
          type == other.type &&
          timestamp == other.timestamp &&
          isRead == other.isRead &&
          payload == other.payload;

  @override
  int get hashCode => Object.hash(
        id,
        title,
        body,
        type,
        timestamp,
        isRead,
        payload,
      );

  @override
  String toString() {
    return 'AppNotification(id: $id, title: $title, body: $body, type: $type, timestamp: $timestamp, isRead: $isRead, payload: $payload)';
  }
}
