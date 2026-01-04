import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:getwidget/getwidget.dart';

import 'package:mess_manager/core/theme/app_theme.dart';
import 'package:mess_manager/core/services/haptic_service.dart';
import 'package:mess_manager/core/widgets/gf_components.dart';
import 'package:mess_manager/features/notifications/providers/notification_provider.dart';

/// Notification Settings Screen - Uses GetWidget + VelocityX + flutter_animate
class NotificationSettingsScreen extends ConsumerWidget {
  const NotificationSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(notificationSettingsProvider);
    final notifier = ref.read(notificationSettingsProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: [
          const Icon(LucideIcons.bell, color: AppColors.primary, size: 22),
          8.widthBox,
          'Notifications'.text.make(),
        ].hStack(),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          // Master Toggle
          GFCard(
            padding: const EdgeInsets.all(AppSpacing.md),
            margin: EdgeInsets.zero,
            gradient: LinearGradient(
              colors: [
                AppColors.primary.withValues(alpha: 0.15),
                AppColors.primaryLight.withValues(alpha: 0.05),
              ],
            ),
            border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            content: HStack([
              GFAvatar(
                backgroundColor: AppColors.primary.withValues(alpha: 0.2),
                child: const Icon(
                  LucideIcons.bellRing,
                  color: AppColors.primary,
                ),
              ),
              12.widthBox,
              VStack(crossAlignment: CrossAxisAlignment.start, [
                'All Notifications'.text
                    .color(AppColors.textPrimaryDark)
                    .bold
                    .make(),
                (settings.enabled ? 'Enabled' : 'Disabled').text.sm
                    .color(
                      settings.enabled
                          ? AppColors.moneyPositive
                          : AppColors.textMutedDark,
                    )
                    .make(),
              ]).expand(),
              GFToggle(
                value: settings.enabled,
                onChanged: (_) {
                  HapticService.selectionTick();
                  notifier.toggleAll();
                },
                enabledThumbColor: AppColors.primary,
                type: GFToggleType.ios,
              ),
            ]),
          ).animate().fadeIn().slideY(begin: 0.05),
          16.heightBox,

          // Section Header
          'Notification Types'.text.sm
              .color(AppColors.textSecondaryDark)
              .make(),
          8.heightBox,

          // Individual Toggles
          _buildToggle(
            icon: LucideIcons.utensils,
            title: 'Meal Reminders',
            subtitle: 'Log your meal yet?',
            enabled: settings.mealReminder && settings.enabled,
            onToggle: () => notifier.toggle(NotificationType.mealReminder),
            color: AppColors.mealColor,
          ).animate(delay: 100.ms).fadeIn(),
          _buildToggle(
            icon: LucideIcons.shoppingCart,
            title: 'Bazar Overdue',
            subtitle: 'Days since last bazar',
            enabled: settings.bazarOverdue && settings.enabled,
            onToggle: () => notifier.toggle(NotificationType.bazarOverdue),
            color: AppColors.bazarColor,
          ).animate(delay: 150.ms).fadeIn(),
          _buildToggle(
            icon: LucideIcons.receipt,
            title: 'Bill Due',
            subtitle: 'Rent due in 3 days',
            enabled: settings.billDue && settings.enabled,
            onToggle: () => notifier.toggle(NotificationType.billDue),
            color: AppColors.moneyNegative,
          ).animate(delay: 200.ms).fadeIn(),
          _buildToggle(
            icon: LucideIcons.zap,
            title: 'Low DESCO Balance',
            subtitle: 'Meter balance low',
            enabled: settings.lowDescoBalance && settings.enabled,
            onToggle: () => notifier.toggle(NotificationType.lowDescoBalance),
            color: AppColors.accentWarm,
          ).animate(delay: 250.ms).fadeIn(),
          _buildToggle(
            icon: LucideIcons.clipboardList,
            title: 'Duty Reminders',
            subtitle: 'Your turn this week',
            enabled: settings.dutyReminder && settings.enabled,
            onToggle: () => notifier.toggle(NotificationType.dutyReminder),
            color: AppColors.info,
          ).animate(delay: 300.ms).fadeIn(),
          _buildToggle(
            icon: LucideIcons.plus,
            title: 'New Entries',
            subtitle: 'Someone added entry',
            enabled: settings.newEntry && settings.enabled,
            onToggle: () => notifier.toggle(NotificationType.newEntry),
            color: AppColors.secondary,
          ).animate(delay: 350.ms).fadeIn(),
        ],
      ),
    );
  }

  Widget _buildToggle({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool enabled,
    required VoidCallback onToggle,
    required Color color,
  }) {
    return GFAppCard(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: HStack([
        GFAvatar(
          size: 40,
          backgroundColor: color.withValues(alpha: 0.15),
          child: Icon(icon, color: color, size: 20),
        ),
        12.widthBox,
        VStack(crossAlignment: CrossAxisAlignment.start, [
          title.text.color(AppColors.textPrimaryDark).bold.make(),
          subtitle.text.sm.color(AppColors.textMutedDark).make(),
        ]).expand(),
        GFToggle(
          value: enabled,
          onChanged: (_) {
            HapticService.selectionTick();
            onToggle();
          },
          enabledThumbColor: color,
          type: GFToggleType.ios,
        ),
      ]),
    );
  }
}
