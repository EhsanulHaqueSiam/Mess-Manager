import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:gap/gap.dart';

import 'package:mess_manager/core/theme/app_theme.dart';
import 'package:mess_manager/core/services/haptic_service.dart';
import 'package:mess_manager/features/notifications/providers/notification_provider.dart';

/// Notification Settings Screen
class NotificationSettingsScreen extends ConsumerWidget {
  const NotificationSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(notificationSettingsProvider);
    final notifier = ref.read(notificationSettingsProvider.notifier);

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
            top: -50,
            right: -30,
            child: Container(
              width: 180,
              height: 180,
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
            bottom: -70,
            left: -50,
            child: Container(
              width: 220,
              height: 220,
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
                            color: AppColors.warning.withValues(alpha: 0.10),
                            border: Border.all(
                              color: AppColors.warning.withValues(alpha: 0.18),
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
                              'Manage alerts',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.white.withValues(alpha: 0.5),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const Gap(8),

                // Scrollable content
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    children: [
                      // Master Toggle - Glass card with gradient highlight
                      ClipRRect(
                        borderRadius:
                            BorderRadius.circular(AppSpacing.radiusMd),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                          child: Container(
                            padding: const EdgeInsets.all(AppSpacing.md),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  AppColors.primary.withValues(alpha: 0.12),
                                  AppColors.primary.withValues(alpha: 0.03),
                                ],
                              ),
                              border: Border.all(
                                color:
                                    AppColors.primary.withValues(alpha: 0.25),
                              ),
                              borderRadius:
                                  BorderRadius.circular(AppSpacing.radiusMd),
                              boxShadow: [
                                BoxShadow(
                                  color:
                                      AppColors.primary.withValues(alpha: 0.08),
                                  blurRadius: 16,
                                  spreadRadius: 0,
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 44,
                                  height: 44,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    gradient: RadialGradient(
                                      colors: [
                                        AppColors.primary
                                            .withValues(alpha: 0.3),
                                        AppColors.primary
                                            .withValues(alpha: 0.05),
                                      ],
                                    ),
                                    border: Border.all(
                                      color: AppColors.primary
                                          .withValues(alpha: 0.2),
                                    ),
                                  ),
                                  child: const Icon(
                                    LucideIcons.bellRing,
                                    color: AppColors.primary,
                                    size: 20,
                                  ),
                                ),
                                const Gap(12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'All Notifications',
                                        style: TextStyle(
                                          color: Colors.white
                                              .withValues(alpha: 0.9),
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        settings.enabled
                                            ? 'Enabled'
                                            : 'Disabled',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: settings.enabled
                                              ? AppColors.moneyPositive
                                              : Colors.white
                                                  .withValues(alpha: 0.3),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Switch.adaptive(
                                  value: settings.enabled,
                                  onChanged: (_) {
                                    HapticService.toggle();
                                    notifier.toggleAll();
                                  },
                                  activeColor: AppColors.primary,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ).animate().fadeIn().slideY(begin: 0.05),
                      const Gap(16),

                      // Section Header
                      Text(
                        'Notification Types',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.5,
                          color: Colors.white.withValues(alpha: 0.5),
                        ),
                      ),
                      const Gap(8),

                      // Individual Toggles
                      _buildToggle(
                        context: context,
                        icon: LucideIcons.utensils,
                        title: 'Meal Reminders',
                        subtitle: 'Log your meal yet?',
                        enabled: settings.mealReminder && settings.enabled,
                        onToggle: () =>
                            notifier.toggle(NotificationType.mealReminder),
                        color: AppColors.mealColor,
                      ).animate(delay: 100.ms).fadeIn(),
                      _buildToggle(
                        context: context,
                        icon: LucideIcons.shoppingCart,
                        title: 'Bazar Overdue',
                        subtitle: 'Days since last bazar',
                        enabled: settings.bazarOverdue && settings.enabled,
                        onToggle: () =>
                            notifier.toggle(NotificationType.bazarOverdue),
                        color: AppColors.bazarColor,
                      ).animate(delay: 150.ms).fadeIn(),
                      _buildToggle(
                        context: context,
                        icon: LucideIcons.receipt,
                        title: 'Bill Due',
                        subtitle: 'Rent due in 3 days',
                        enabled: settings.billDue && settings.enabled,
                        onToggle: () =>
                            notifier.toggle(NotificationType.billDue),
                        color: AppColors.moneyNegative,
                      ).animate(delay: 200.ms).fadeIn(),
                      _buildToggle(
                        context: context,
                        icon: LucideIcons.zap,
                        title: 'Low DESCO Balance',
                        subtitle: 'Meter balance low',
                        enabled: settings.lowDescoBalance && settings.enabled,
                        onToggle: () =>
                            notifier.toggle(NotificationType.lowDescoBalance),
                        color: AppColors.accentWarm,
                      ).animate(delay: 250.ms).fadeIn(),
                      _buildToggle(
                        context: context,
                        icon: LucideIcons.clipboardList,
                        title: 'Duty Reminders',
                        subtitle: 'Your turn this week',
                        enabled: settings.dutyReminder && settings.enabled,
                        onToggle: () =>
                            notifier.toggle(NotificationType.dutyReminder),
                        color: AppColors.info,
                      ).animate(delay: 300.ms).fadeIn(),
                      _buildToggle(
                        context: context,
                        icon: LucideIcons.plus,
                        title: 'New Entries',
                        subtitle: 'Someone added entry',
                        enabled: settings.newEntry && settings.enabled,
                        onToggle: () =>
                            notifier.toggle(NotificationType.newEntry),
                        color: AppColors.secondary,
                      ).animate(delay: 350.ms).fadeIn(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildToggle({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required bool enabled,
    required VoidCallback onToggle,
    required Color color,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.sm + 2,
            ),
            decoration: AppSpacing.accentCard(accent: AppColors.warning, radius: AppSpacing.radiusMd),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
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
                ),
                const Gap(12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.9),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white.withValues(alpha: 0.3),
                        ),
                      ),
                    ],
                  ),
                ),
                Switch.adaptive(
                  value: enabled,
                  onChanged: (_) {
                    HapticService.toggle();
                    onToggle();
                  },
                  activeColor: color,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
