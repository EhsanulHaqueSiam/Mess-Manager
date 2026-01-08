import 'package:isar_plus/isar_plus.dart';
import '../../models/app_notification.dart';

part 'app_notification_collection.g.dart';

@collection
class AppNotificationCollection {
  late int id;

  @Index(unique: true)
  late String notificationId;

  late String title;
  late String body;

  late String type;

  @Index()
  late DateTime timestamp;

  late bool isRead;
  String? payload;

  AppNotification toModel() {
    return AppNotification(
      id: notificationId,
      title: title,
      body: body,
      type: NotificationType.values.byName(type),
      timestamp: timestamp,
      isRead: isRead,
      payload: payload,
    );
  }

  static AppNotificationCollection fromModel(AppNotification model) {
    return AppNotificationCollection()
      ..notificationId = model.id
      ..title = model.title
      ..body = model.body
      ..type = model.type.name
      ..timestamp = model.timestamp
      ..isRead = model.isRead
      ..payload = model.payload;
  }
}
