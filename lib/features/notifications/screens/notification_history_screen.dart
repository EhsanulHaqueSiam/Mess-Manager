import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:getwidget/getwidget.dart';
import 'package:isar_plus/isar_plus.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:mess_manager/core/database/isar_service.dart';
import 'package:mess_manager/core/database/collections/app_notification_collection.dart';
import 'package:mess_manager/core/models/app_notification.dart';
import 'package:mess_manager/core/theme/app_theme.dart';

import 'package:velocity_x/velocity_x.dart';
import 'package:timeago/timeago.dart' as timeago;

class NotificationHistoryScreen extends ConsumerStatefulWidget {
  const NotificationHistoryScreen({super.key});

  @override
  ConsumerState<NotificationHistoryScreen> createState() =>
      _NotificationHistoryScreenState();
}

class _NotificationHistoryScreenState
    extends ConsumerState<NotificationHistoryScreen> {
  late Stream<List<AppNotification>> _notificationsStream;

  @override
  void initState() {
    super.initState();
    // Watch AppNotificationCollection and map to AppNotification model
    _notificationsStream = IsarService.instance.appNotificationCollections
        .where()
        .watch(fireImmediately: true)
        .map((event) {
          final list = event.map((c) => c.toModel()).toList();
          list.sort((a, b) => b.timestamp.compareTo(a.timestamp));
          return list;
        });

    // Mark all as read on open
    WidgetsBinding.instance.addPostFrameCallback((_) {
      IsarService.markAllNotificationsAsRead();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: 'Notifications'.text.make(),
        actions: [
          IconButton(
            icon: const Icon(LucideIcons.trash2),
            onPressed: () {
              GFToast.showToast(
                'Long press to clear all',
                context,
                toastDuration: 3,
              );
            },
          ).onInkLongPress(() {
            IsarService.clearNotifications();
            HapticFeedback.mediumImpact();
          }),
        ],
      ),
      body: StreamBuilder<List<AppNotification>>(
        stream: _notificationsStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const GFLoader(type: GFLoaderType.ios).centered();
          }

          final notifications = snapshot.data ?? [];

          if (notifications.isEmpty) {
            return VStack([
              const Icon(
                LucideIcons.bellOff,
                size: 64,
                color: AppColors.textSecondaryDark,
              ).centered(),
              16.heightBox,
              'No notifications yet'.text
                  .color(AppColors.textSecondaryDark)
                  .make(),
            ], crossAlignment: CrossAxisAlignment.center).centered();
          }

          return ListView.separated(
            padding: const EdgeInsets.all(AppSpacing.md),
            itemCount: notifications.length,
            separatorBuilder: (context, index) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final n = notifications[index];
              return Slidable(
                key: Key(n.id),
                endActionPane: ActionPane(
                  motion: const DrawerMotion(),
                  children: [
                    SlidableAction(
                      onPressed: (_) {
                        // Store for undo
                        final deletedNotification = n;

                        IsarService.deleteNotification(n.id);
                        HapticFeedback.lightImpact();

                        // Show undo SnackBar
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: const Text('Notification deleted'),
                            action: SnackBarAction(
                              label: 'Undo',
                              textColor: AppColors.primary,
                              onPressed: () {
                                IsarService.saveNotification(
                                  deletedNotification,
                                );
                              },
                            ),
                            backgroundColor: AppColors.cardDark,
                            duration: const Duration(seconds: 4),
                          ),
                        );
                      },
                      backgroundColor: AppColors.error,
                      foregroundColor: Colors.white,
                      icon: LucideIcons.trash2,
                      label: 'Delete',
                      borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                    ),
                  ],
                ),
                child: ListTile(
                  leading: _buildIcon(n.type),
                  title: n.title.text.semiBold.make(),
                  subtitle: VStack([
                    n.body.text.sm.make(),
                    4.heightBox,
                    timeago
                        .format(n.timestamp)
                        .text
                        .xs
                        .color(AppColors.textSecondaryDark)
                        .make(),
                  ]),
                  tileColor: n.isRead
                      ? Colors.transparent
                      : AppColors.primary.withValues(alpha: 0.05),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                    vertical: AppSpacing.sm,
                  ),
                  onTap: () {
                    // Navigate based on type/payload if needed
                  },
                ),
              ).animate().fadeIn().slideX();
            },
          );
        },
      ),
    );
  }

  Widget _buildIcon(NotificationType type) {
    IconData icon;
    Color color;

    switch (type) {
      case NotificationType.info:
        icon = LucideIcons.info;
        color = AppColors.info;
        break;
      case NotificationType.success:
        icon = LucideIcons.checkCircle;
        color = AppColors.success;
        break;
      case NotificationType.warning:
        icon = LucideIcons.alertTriangle;
        color = AppColors.warning;
        break;
      case NotificationType.error:
        icon = LucideIcons.xCircle;
        color = AppColors.error;
        break;
      case NotificationType.chat:
        icon = LucideIcons.messageCircle;
        color = AppColors.info;
        break;
      case NotificationType.bill:
        icon = LucideIcons.receipt;
        color = AppColors.error; // Bills are scary? or warning
        break;
      case NotificationType.duty:
        icon = LucideIcons.calendarClock;
        color = AppColors.primary;
        break;
    }

    return GFAvatar(
      size: 24,
      backgroundColor: color.withValues(alpha: 0.1),
      child: Icon(icon, color: color, size: 20),
    );
  }
}
