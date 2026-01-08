import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:gap/gap.dart';
import 'package:getwidget/getwidget.dart';

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
        color: AppColors.surfaceDark,
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
                  color: AppColors.borderDark,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const Gap(AppSpacing.lg),

            // Header
            HStack([
              const Icon(
                LucideIcons.percent,
                color: AppColors.warning,
                size: 24,
              ),
              12.widthBox,
              'Late Payment Penalty'.text.xl.bold.make().expand(),
              GFToggle(
                value: settings.isEnabled,
                onChanged: (value) {
                  HapticService.lightTap();
                  ref
                      .read(penaltySettingsProvider.notifier)
                      .setEnabled(value ?? false);
                },
                enabledTrackColor: AppColors.warning,
              ),
            ]),
            const Gap(AppSpacing.md),

            if (!settings.isEnabled)
              Container(
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: AppColors.info.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                ),
                child: HStack([
                  const Icon(LucideIcons.info, size: 18, color: AppColors.info),
                  8.widthBox,
                  'Enable to add automatic penalty for late payments.'.text.sm
                      .color(AppColors.info)
                      .make()
                      .expand(),
                ]),
              ),

            if (settings.isEnabled) ...[
              const Divider(height: 24),

              // Penalty Percent
              _buildSettingRow(
                label: 'Penalty Rate',
                description: 'Percentage added after grace period',
                child: HStack([
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
                    child: '${settings.penaltyPercent.toStringAsFixed(0)}%'
                        .text
                        .bold
                        .color(AppColors.warning)
                        .make(),
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
                ]),
              ),
              const Gap(AppSpacing.md),

              // Grace Period
              _buildSettingRow(
                label: 'Grace Period',
                description: 'Days before penalty starts',
                child: HStack([
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
                    child: '${settings.gracePeriodDays} days'.text.bold
                        .color(AppColors.info)
                        .make(),
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
                ]),
              ),
              const Gap(AppSpacing.md),

              // Max Penalty Cap
              _buildSettingRow(
                label: 'Maximum Penalty',
                description: 'Cap on total penalty amount',
                child: HStack([
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
                    child: '${settings.maxPenaltyPercent.toStringAsFixed(0)}%'
                        .text
                        .bold
                        .color(AppColors.error)
                        .make(),
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
                ]),
              ),
              const Gap(AppSpacing.md),

              // Compound Daily Toggle
              Container(
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: AppColors.cardDark,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                  border: Border.all(color: AppColors.borderDark),
                ),
                child: HStack([
                  VStack(crossAlignment: CrossAxisAlignment.start, [
                    'Compound Daily'.text.semiBold.make(),
                    'Penalty increases each day after grace period'
                        .text
                        .xs
                        .gray500
                        .make(),
                  ]).expand(),
                  GFToggle(
                    value: settings.compoundDaily,
                    onChanged: (value) {
                      HapticService.lightTap();
                      ref
                          .read(penaltySettingsProvider.notifier)
                          .setCompoundDaily(value ?? false);
                    },
                    enabledTrackColor: AppColors.error,
                  ),
                ]),
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
                child: VStack(crossAlignment: CrossAxisAlignment.start, [
                  HStack([
                    const Icon(
                      LucideIcons.calculator,
                      size: 16,
                      color: AppColors.warning,
                    ),
                    8.widthBox,
                    'Example Calculation'.text.semiBold
                        .color(AppColors.warning)
                        .make(),
                  ]),
                  8.heightBox,
                  'If someone owes ৳1,000:'.text.sm.make(),
                  4.heightBox,
                  '• After ${settings.gracePeriodDays} days: +৳${(1000 * settings.penaltyPercent / 100).toStringAsFixed(0)} (${settings.penaltyPercent.toStringAsFixed(0)}% penalty)'
                      .text
                      .xs
                      .gray500
                      .make(),
                  '• Maximum: ৳${(1000 * settings.maxPenaltyPercent / 100).toStringAsFixed(0)} cap (${settings.maxPenaltyPercent.toStringAsFixed(0)}% max)'
                      .text
                      .xs
                      .gray500
                      .make(),
                ]),
              ),
            ],

            const Gap(AppSpacing.lg),

            // Close Button
            GFButton(
              onPressed: () => Navigator.pop(context),
              text: 'Done',
              fullWidthButton: true,
              color: AppColors.primary,
            ),
            const Gap(AppSpacing.md),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingRow({
    required String label,
    required String description,
    required Widget child,
  }) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.cardDark,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        border: Border.all(color: AppColors.borderDark),
      ),
      child: HStack([
        VStack(crossAlignment: CrossAxisAlignment.start, [
          label.text.semiBold.make(),
          description.text.xs.gray500.make(),
        ]).expand(),
        child,
      ]),
    );
  }
}
