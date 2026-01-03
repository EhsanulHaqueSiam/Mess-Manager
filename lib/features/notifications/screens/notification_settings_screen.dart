import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:gap/gap.dart';

import 'package:mess_manager/core/theme/app_theme.dart';
import 'package:mess_manager/features/notifications/providers/notification_provider.dart';

class NotificationSettingsScreen extends ConsumerWidget {
  const NotificationSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(notificationSettingsProvider);
    final notifier = ref.read(notificationSettingsProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Icon(LucideIcons.bell, color: AppColors.primary, size: 22),
            const Gap(AppSpacing.sm),
            const Text('Notifications'),
          ],
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          // Master Toggle
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.primary.withValues(alpha: 0.15),
                  AppColors.primaryLight.withValues(alpha: 0.05),
                ],
              ),
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
              border: Border.all(
                color: AppColors.primary.withValues(alpha: 0.3),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(AppSpacing.sm),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                  ),
                  child: const Icon(
                    LucideIcons.bellRing,
                    color: AppColors.primary,
                  ),
                ),
                const Gap(AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'All Notifications',
                        style: AppTypography.titleMedium.copyWith(
                          color: AppColors.textPrimaryDark,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        settings.enabled ? 'Enabled' : 'Disabled',
                        style: AppTypography.bodySmall.copyWith(
                          color: settings.enabled
                              ? AppColors.moneyPositive
                              : AppColors.textMutedDark,
                        ),
                      ),
                    ],
                  ),
                ),
                Switch(
                  value: settings.enabled,
                  onChanged: (_) => notifier.toggleAll(),
                  activeColor: AppColors.primary,
                ),
              ],
            ),
          ),
          const Gap(AppSpacing.lg),

          // Individual Toggles
          Text(
            'Notification Types',
            style: AppTypography.labelMedium.copyWith(
              color: AppColors.textSecondaryDark,
            ),
          ),
          const Gap(AppSpacing.sm),

          _buildToggle(
            icon: LucideIcons.utensils,
            title: 'Meal Reminders',
            subtitle: 'Log your meal yet?',
            enabled: settings.mealReminder && settings.enabled,
            onToggle: () => notifier.toggle(NotificationType.mealReminder),
            color: AppColors.mealColor,
          ),
          _buildToggle(
            icon: LucideIcons.shoppingCart,
            title: 'Bazar Overdue',
            subtitle: 'Days since last bazar',
            enabled: settings.bazarOverdue && settings.enabled,
            onToggle: () => notifier.toggle(NotificationType.bazarOverdue),
            color: AppColors.bazarColor,
          ),
          _buildToggle(
            icon: LucideIcons.receipt,
            title: 'Bill Due',
            subtitle: 'Rent due in 3 days',
            enabled: settings.billDue && settings.enabled,
            onToggle: () => notifier.toggle(NotificationType.billDue),
            color: AppColors.moneyNegative,
          ),
          _buildToggle(
            icon: LucideIcons.zap,
            title: 'Low DESCO Balance',
            subtitle: 'Meter balance low',
            enabled: settings.lowDescoBalance && settings.enabled,
            onToggle: () => notifier.toggle(NotificationType.lowDescoBalance),
            color: AppColors.accentWarm,
          ),
          _buildToggle(
            icon: LucideIcons.clipboardList,
            title: 'Duty Reminders',
            subtitle: 'Your turn this week',
            enabled: settings.dutyReminder && settings.enabled,
            onToggle: () => notifier.toggle(NotificationType.dutyReminder),
            color: AppColors.info,
          ),
          _buildToggle(
            icon: LucideIcons.plus,
            title: 'New Entries',
            subtitle: 'Someone added entry',
            enabled: settings.newEntry && settings.enabled,
            onToggle: () => notifier.toggle(NotificationType.newEntry),
            color: AppColors.secondary,
          ),
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
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.cardDark,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        border: Border.all(color: AppColors.borderDark.withValues(alpha: 0.5)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.sm),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const Gap(AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTypography.titleSmall.copyWith(
                    color: AppColors.textPrimaryDark,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  subtitle,
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textMutedDark,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: enabled,
            onChanged: (_) => onToggle(),
            activeColor: color,
          ),
        ],
      ),
    );
  }
}
