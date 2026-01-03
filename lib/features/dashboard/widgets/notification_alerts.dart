import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:gap/gap.dart';

import 'package:mess_manager/core/theme/app_theme.dart';
import 'package:mess_manager/core/services/haptic_service.dart';

/// Notification Alert Model
class DashboardAlert {
  final String id;
  final String title;
  final String message;
  final AlertType type;
  final IconData icon;
  final DateTime? dueDate;
  final VoidCallback? onTap;
  final VoidCallback? onDismiss;

  const DashboardAlert({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    required this.icon,
    this.dueDate,
    this.onTap,
    this.onDismiss,
  });
}

enum AlertType { rent, buaBill, desco, bazar, meal, general, urgent }

/// Get color for alert type
Color getAlertColor(AlertType type) {
  switch (type) {
    case AlertType.rent:
      return const Color(0xFFE11D48); // Rose red - urgent
    case AlertType.buaBill:
      return const Color(0xFFF97316); // Orange - warning
    case AlertType.desco:
      return const Color(0xFFFBBF24); // Amber - electric
    case AlertType.bazar:
      return AppColors.bazarColor;
    case AlertType.meal:
      return AppColors.mealColor;
    case AlertType.urgent:
      return const Color(0xFFDC2626); // Red
    case AlertType.general:
      return AppColors.info;
  }
}

/// Notification Alerts Area Widget
class NotificationAlertsArea extends StatelessWidget {
  final List<DashboardAlert> alerts;

  const NotificationAlertsArea({super.key, required this.alerts});

  @override
  Widget build(BuildContext context) {
    if (alerts.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(
              LucideIcons.bellRing,
              color: AppColors.warning,
              size: 18,
            ),
            const Gap(AppSpacing.sm),
            Text(
              'Notifications',
              style: AppTypography.headlineSmall.copyWith(
                color: AppColors.textPrimaryDark,
              ),
            ),
            const Gap(AppSpacing.sm),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.warning.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '${alerts.length}',
                style: AppTypography.labelSmall.copyWith(
                  color: AppColors.warning,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const Gap(AppSpacing.sm),
        ...alerts.asMap().entries.map((entry) {
          return _buildAlertCard(entry.value, entry.key);
        }),
      ],
    );
  }

  Widget _buildAlertCard(DashboardAlert alert, int index) {
    final color = getAlertColor(alert.type);

    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            HapticService.lightTap();
            alert.onTap?.call();
          },
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Row(
              children: [
                // Icon with glow
                Container(
                  padding: const EdgeInsets.all(AppSpacing.sm),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                    boxShadow: [
                      BoxShadow(
                        color: color.withValues(alpha: 0.3),
                        blurRadius: 8,
                        spreadRadius: -2,
                      ),
                    ],
                  ),
                  child: Icon(alert.icon, color: color, size: 20),
                ),
                const Gap(AppSpacing.md),

                // Title & Message
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        alert.title,
                        style: AppTypography.titleSmall.copyWith(
                          color: AppColors.textPrimaryDark,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        alert.message,
                        style: AppTypography.bodySmall.copyWith(
                          color: AppColors.textSecondaryDark,
                        ),
                      ),
                    ],
                  ),
                ),

                // Due date badge
                if (alert.dueDate != null) ...[
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      _formatDue(alert.dueDate!),
                      style: AppTypography.labelSmall.copyWith(
                        color: color,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],

                // Dismiss button
                if (alert.onDismiss != null) ...[
                  const Gap(AppSpacing.xs),
                  IconButton(
                    onPressed: () {
                      HapticService.lightTap();
                      alert.onDismiss?.call();
                    },
                    icon: Icon(LucideIcons.x, color: color, size: 16),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(
                      minWidth: 32,
                      minHeight: 32,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    ).animate(delay: (80 * index).ms).fadeIn().slideX(begin: 0.05);
  }

  String _formatDue(DateTime date) {
    final now = DateTime.now();
    final diff = date.difference(now).inDays;

    if (diff < 0) return 'Overdue';
    if (diff == 0) return 'Today';
    if (diff == 1) return 'Tomorrow';
    if (diff <= 7) return 'In $diff days';
    return '${date.day}/${date.month}';
  }
}

/// Sample alerts for demo
List<DashboardAlert> getSampleAlerts() {
  final now = DateTime.now();
  return [
    DashboardAlert(
      id: 'rent_1',
      title: 'Rent Due Soon',
      message: 'Monthly rent ৳7,000 due in 3 days',
      type: AlertType.rent,
      icon: LucideIcons.home,
      dueDate: now.add(const Duration(days: 3)),
    ),
    DashboardAlert(
      id: 'bua_1',
      title: 'Bua Bill',
      message: 'Maid salary ৳2,500 for this month',
      type: AlertType.buaBill,
      icon: LucideIcons.userCheck,
      dueDate: now.add(const Duration(days: 5)),
    ),
    DashboardAlert(
      id: 'desco_1',
      title: 'DESCO Balance Low',
      message: 'Current balance: ৳450. Recharge soon!',
      type: AlertType.desco,
      icon: LucideIcons.zap,
    ),
    DashboardAlert(
      id: 'bazar_1',
      title: 'No Bazar Today',
      message: 'Kitchen needs restocking',
      type: AlertType.bazar,
      icon: LucideIcons.shoppingCart,
    ),
  ];
}
