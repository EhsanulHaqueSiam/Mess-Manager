import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:mess_manager/core/database/isar_service.dart';
import 'package:mess_manager/core/models/app_notification.dart';
import 'package:mess_manager/core/theme/app_theme.dart';
import 'package:mess_manager/core/widgets/app_components.dart';
import 'package:gap/gap.dart';

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
    // Seed the stream with current data, then listen for mutations
    _notificationsStream = _buildNotificationsStream();

    // Mark all as read on open
    WidgetsBinding.instance.addPostFrameCallback((_) {
      IsarService.markAllNotificationsAsRead();
    });
  }

  Stream<List<AppNotification>> _buildNotificationsStream() async* {
    // Emit current state immediately
    yield IsarService.getAllNotifications();
    // Then forward all future changes
    yield* IsarService.watchNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0E1A),
      body: Stack(
        children: [
          // Background gradient
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFF0A0E1A), Color(0xFF0D1520)],
                ),
              ),
            ),
          ),

          // Breathing accent orb - top right
          Positioned(
            top: -60,
            right: -40,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppColors.primary.withValues(alpha: 0.15),
                    AppColors.primary.withValues(alpha: 0.0),
                  ],
                ),
              ),
            )
                .animate(onPlay: (c) => c.repeat(reverse: true))
                .scaleXY(begin: 0.8, end: 1.2, duration: 4000.ms)
                .fadeIn(duration: 1000.ms),
          ),

          // Breathing accent orb - bottom left
          Positioned(
            bottom: -80,
            left: -60,
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppColors.primary.withValues(alpha: 0.1),
                    AppColors.primary.withValues(alpha: 0.0),
                  ],
                ),
              ),
            )
                .animate(onPlay: (c) => c.repeat(reverse: true))
                .scaleXY(begin: 1.0, end: 1.3, duration: 5000.ms)
                .fadeIn(duration: 1000.ms),
          ),

          // Main content
          SafeArea(
            child: Column(
              children: [
                // Custom header
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                    vertical: AppSpacing.sm,
                  ),
                  child: Row(
                    children: [
                      // Back button
                      GestureDetector(
                        onTap: () => Navigator.of(context).pop(),
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withValues(alpha: 0.05),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.08),
                            ),
                          ),
                          child: Icon(
                            LucideIcons.arrowLeft,
                            color: Colors.white.withValues(alpha: 0.9),
                            size: 18,
                          ),
                        ),
                      ),
                      const Gap(12),

                      // Gradient halo icon
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: RadialGradient(
                            colors: [
                              AppColors.primary.withValues(alpha: 0.3),
                              AppColors.primary.withValues(alpha: 0.05),
                            ],
                          ),
                          border: Border.all(
                            color: AppColors.primary.withValues(alpha: 0.3),
                          ),
                        ),
                        child: const Icon(
                          LucideIcons.bell,
                          color: AppColors.primary,
                          size: 20,
                        ),
                      ),
                      const Gap(12),

                      // Title column
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Notifications',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white.withValues(alpha: 0.9),
                              ),
                            ),
                            Text(
                              'Activity feed',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.white.withValues(alpha: 0.5),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Clear all action
                      GestureDetector(
                        onLongPress: () {
                          IsarService.clearNotifications();
                          HapticFeedback.mediumImpact();
                        },
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withValues(alpha: 0.05),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.08),
                            ),
                          ),
                          child: IconButton(
                            padding: EdgeInsets.zero,
                            icon: Icon(
                              LucideIcons.trash2,
                              color: Colors.white.withValues(alpha: 0.5),
                              size: 18,
                            ),
                            onPressed: () {
                              showInfoToast(context, 'Long press to clear all');
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const Gap(8),

                // Notifications list
                Expanded(
                  child: StreamBuilder<List<AppNotification>>(
                    stream: _notificationsStream,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator.adaptive(
                            backgroundColor:
                                Colors.white.withValues(alpha: 0.1),
                          ),
                        );
                      }

                      final notifications = snapshot.data ?? [];

                      if (notifications.isEmpty) {
                        return Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                LucideIcons.bellOff,
                                size: 64,
                                color: Colors.white.withValues(alpha: 0.3),
                              ),
                              const Gap(16),
                              Text(
                                'No notifications yet',
                                style: TextStyle(
                                  color: Colors.white.withValues(alpha: 0.3),
                                ),
                              ),
                            ],
                          ),
                        );
                      }

                      return ListView.separated(
                        padding: const EdgeInsets.all(AppSpacing.md),
                        itemCount: notifications.length,
                        separatorBuilder: (context, index) => const Gap(8),
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
                                        content: Text(
                                          'Notification deleted',
                                          style: TextStyle(
                                            color: Colors.white
                                                .withValues(alpha: 0.9),
                                          ),
                                        ),
                                        action: SnackBarAction(
                                          label: 'Undo',
                                          textColor: AppColors.primary,
                                          onPressed: () {
                                            IsarService.saveNotification(
                                              deletedNotification,
                                            );
                                          },
                                        ),
                                        backgroundColor:
                                            const Color(0xFF0D1520),
                                        duration: const Duration(seconds: 4),
                                      ),
                                    );
                                  },
                                  backgroundColor: AppColors.error,
                                  foregroundColor: Colors.white,
                                  icon: LucideIcons.trash2,
                                  label: 'Delete',
                                  borderRadius: BorderRadius.circular(
                                    AppSpacing.radiusSm,
                                  ),
                                ),
                              ],
                            ),
                            child: _buildNotificationCard(n),
                          ).animate().fadeIn().slideX();
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationCard(AppNotification n) {
    final isUnread = !n.isRead;

    return ClipRRect(
      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.03),
            border: Border.all(
              color: isUnread
                  ? AppColors.primary.withValues(alpha: 0.25)
                  : Colors.white.withValues(alpha: 0.05),
              width: isUnread ? 1.5 : 1.0,
            ),
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            boxShadow: isUnread
                ? [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.08),
                      blurRadius: 12,
                      spreadRadius: 0,
                    ),
                  ]
                : null,
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm + 4,
          ),
          child: Row(
            children: [
              // Icon with halo
              _buildIcon(n.type),
              const Gap(12),

              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      n.title,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.white.withValues(alpha: 0.9),
                      ),
                    ),
                    const Gap(2),
                    Text(
                      n.body,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white.withValues(alpha: 0.5),
                      ),
                    ),
                    const Gap(4),
                    Text(
                      timeago.format(n.timestamp),
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.white.withValues(alpha: 0.3),
                      ),
                    ),
                  ],
                ),
              ),

              // Unread indicator
              if (isUnread)
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.primary,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.4),
                        blurRadius: 6,
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
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

    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [
            color.withValues(alpha: 0.2),
            color.withValues(alpha: 0.05),
          ],
        ),
        border: Border.all(
          color: color.withValues(alpha: 0.15),
        ),
      ),
      child: Icon(icon, color: color, size: 20),
    );
  }
}
