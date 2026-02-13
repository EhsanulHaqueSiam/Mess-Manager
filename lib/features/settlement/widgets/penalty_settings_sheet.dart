import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:gap/gap.dart';

import 'package:mess_manager/core/theme/app_theme.dart';
import 'package:mess_manager/core/services/haptic_service.dart';
import 'package:mess_manager/features/settlement/providers/penalty_provider.dart';

/// Penalty Settings Sheet - Admin only
class PenaltySettingsSheet extends ConsumerWidget {
  const PenaltySettingsSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(penaltySettingsProvider);

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: context.surfaceColor,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(AppSpacing.radiusLg),
        ),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Handle
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: context.borderColor,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const Gap(AppSpacing.lg),

            // Header
            Row(
              children: [
                const Icon(
                  LucideIcons.percent,
                  color: AppColors.warning,
                  size: 24,
                ),
                const Gap(12),
                Expanded(
                  child: Text(
                    'Late Payment Penalty',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Switch.adaptive(
                  value: settings.isEnabled,
                  onChanged: (value) {
                    HapticService.lightTap();
                    ref
                        .read(penaltySettingsProvider.notifier)
                        .setEnabled(value);
                  },
                  activeColor: AppColors.warning,
                ),
              ],
            ),
            const Gap(AppSpacing.md),

            if (!settings.isEnabled)
              Container(
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: AppColors.info.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                ),
                child: Row(
                  children: [
                    const Icon(LucideIcons.info, size: 18, color: AppColors.info),
                    const Gap(8),
                    Expanded(
                      child: Text(
                        'Enable to add automatic penalty for late payments.',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.info,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

            if (settings.isEnabled) ...[
              const Divider(height: 24),

              // Penalty Percent
              _buildSettingRow(
                context: context,
                label: 'Penalty Rate',
                description: 'Percentage added after grace period',
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(LucideIcons.minus, size: 18),
                      onPressed: () {
                        HapticService.lightTap();
                        ref
                            .read(penaltySettingsProvider.notifier)
                            .setPenaltyPercent(settings.penaltyPercent - 1);
                      },
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.warning.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                      ),
                      child: Text(
                        '${settings.penaltyPercent.toStringAsFixed(0)}%',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppColors.warning,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(LucideIcons.plus, size: 18),
                      onPressed: () {
                        HapticService.lightTap();
                        ref
                            .read(penaltySettingsProvider.notifier)
                            .setPenaltyPercent(settings.penaltyPercent + 1);
                      },
                    ),
                  ],
                ),
              ),
              const Gap(AppSpacing.md),

              // Grace Period
              _buildSettingRow(
                context: context,
                label: 'Grace Period',
                description: 'Days before penalty starts',
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(LucideIcons.minus, size: 18),
                      onPressed: () {
                        HapticService.lightTap();
                        ref
                            .read(penaltySettingsProvider.notifier)
                            .setGracePeriodDays(settings.gracePeriodDays - 1);
                      },
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.info.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                      ),
                      child: Text(
                        '${settings.gracePeriodDays} days',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppColors.info,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(LucideIcons.plus, size: 18),
                      onPressed: () {
                        HapticService.lightTap();
                        ref
                            .read(penaltySettingsProvider.notifier)
                            .setGracePeriodDays(settings.gracePeriodDays + 1);
                      },
                    ),
                  ],
                ),
              ),
              const Gap(AppSpacing.md),

              // Max Penalty Cap
              _buildSettingRow(
                context: context,
                label: 'Maximum Penalty',
                description: 'Cap on total penalty amount',
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(LucideIcons.minus, size: 18),
                      onPressed: () {
                        HapticService.lightTap();
                        ref
                            .read(penaltySettingsProvider.notifier)
                            .setMaxPenaltyPercent(settings.maxPenaltyPercent - 5);
                      },
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.error.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                      ),
                      child: Text(
                        '${settings.maxPenaltyPercent.toStringAsFixed(0)}%',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppColors.error,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(LucideIcons.plus, size: 18),
                      onPressed: () {
                        HapticService.lightTap();
                        ref
                            .read(penaltySettingsProvider.notifier)
                            .setMaxPenaltyPercent(settings.maxPenaltyPercent + 5);
                      },
                    ),
                  ],
                ),
              ),
              const Gap(AppSpacing.md),

              // Compound Daily Toggle
              Container(
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: context.cardColor,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                  border: Border.all(color: context.borderColor),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Compound Daily',
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                          Text(
                            'Penalty increases each day after grace period',
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.grey[500],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Switch.adaptive(
                      value: settings.compoundDaily,
                      onChanged: (value) {
                        HapticService.lightTap();
                        ref
                            .read(penaltySettingsProvider.notifier)
                            .setCompoundDaily(value);
                      },
                      activeColor: AppColors.error,
                    ),
                  ],
                ),
              ),
              const Gap(AppSpacing.lg),

              // Example Calculation
              Container(
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: AppColors.warning.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                  border: Border.all(
                    color: AppColors.warning.withValues(alpha: 0.3),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          LucideIcons.calculator,
                          size: 16,
                          color: AppColors.warning,
                        ),
                        const Gap(8),
                        Text(
                          'Example Calculation',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: AppColors.warning,
                          ),
                        ),
                      ],
                    ),
                    const Gap(8),
                    const Text(
                      'If someone owes ৳1,000:',
                      style: TextStyle(fontSize: 12),
                    ),
                    const Gap(4),
                    Text(
                      '• After ${settings.gracePeriodDays} days: +৳${(1000 * settings.penaltyPercent / 100).toStringAsFixed(0)} (${settings.penaltyPercent.toStringAsFixed(0)}% penalty)',
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.grey[500],
                      ),
                    ),
                    Text(
                      '• Maximum: ৳${(1000 * settings.maxPenaltyPercent / 100).toStringAsFixed(0)} cap (${settings.maxPenaltyPercent.toStringAsFixed(0)}% max)',
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.grey[500],
                      ),
                    ),
                  ],
                ),
              ),
            ],

            const Gap(AppSpacing.lg),

            // Close Button
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () => Navigator.pop(context),
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.primary,
                ),
                child: const Text('Done'),
              ),
            ),
            const Gap(AppSpacing.md),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingRow({
    required BuildContext context,
    required String label,
    required String description,
    required Widget child,
  }) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: context.cardColor,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        border: Border.all(color: context.borderColor),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),
          ),
          child,
        ],
      ),
    );
  }
}
