import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:getwidget/getwidget.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:gap/gap.dart';

import 'package:mess_manager/core/theme/app_theme.dart';
import 'package:mess_manager/core/services/haptic_service.dart';
import 'package:mess_manager/features/bazar/providers/budget_provider.dart';

/// Budget card widget showing spending summary and alerts
class BudgetCard extends ConsumerWidget {
  const BudgetCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summary = ref.watch(budgetSummaryProvider);

    if (!summary.isEnabled || summary.monthlyLimit <= 0) {
      return _buildSetupCard(context, ref);
    }

    return GFCard(
      padding: const EdgeInsets.all(AppSpacing.lg),
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      gradient: LinearGradient(
        colors: summary.isOverBudget
            ? [
                AppColors.error.withValues(alpha: 0.15),
                AppColors.error.withValues(alpha: 0.05),
              ]
            : [
                AppColors.primary.withValues(alpha: 0.15),
                AppColors.primary.withValues(alpha: 0.05),
              ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      border: Border.all(
        color: summary.isOverBudget
            ? AppColors.error.withValues(alpha: 0.3)
            : AppColors.primary.withValues(alpha: 0.3),
      ),
      borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
      content: VStack(crossAlignment: CrossAxisAlignment.start, [
        // Header with budget status
        HStack([
          Icon(
            summary.isOverBudget
                ? LucideIcons.alertTriangle
                : LucideIcons.wallet,
            color: summary.isOverBudget ? AppColors.error : AppColors.primary,
            size: 24,
          ),
          8.widthBox,
          'Monthly Budget'.text.lg.semiBold.make().expand(),
          GFIconButton(
            icon: const Icon(LucideIcons.settings, size: 18),
            type: GFButtonType.transparent,
            size: GFSize.SMALL,
            onPressed: () => _showBudgetSettings(context, ref),
          ),
        ]),
        const Gap(AppSpacing.md),

        // Progress bar
        _buildProgressBar(summary),
        const Gap(AppSpacing.sm),

        // Stats row
        HStack([
          VStack([
            '৳${summary.totalSpent.toStringAsFixed(0)}'.text.lg.bold.make(),
            'Spent'.text.xs.gray500.make(),
          ]).expand(),
          VStack([
            '৳${summary.remaining.toStringAsFixed(0)}'.text.lg.bold
                .color(
                  summary.remaining < 0 ? AppColors.error : AppColors.success,
                )
                .make(),
            'Remaining'.text.xs.gray500.make(),
          ]).expand(),
          VStack([
            '৳${summary.dailyBurnRate.toStringAsFixed(0)}'.text.lg.bold.make(),
            'Daily Avg'.text.xs.gray500.make(),
          ]).expand(),
        ]),

        // Warning if over budget
        if (summary.isOverBudget) ...[
          const Gap(AppSpacing.md),
          Container(
            padding: const EdgeInsets.all(AppSpacing.sm),
            decoration: BoxDecoration(
              color: AppColors.error.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
            ),
            child: HStack([
              const Icon(
                LucideIcons.alertCircle,
                size: 16,
                color: AppColors.error,
              ),
              8.widthBox,
              'Projected: ৳${summary.projectedTotal.toStringAsFixed(0)} - Consider reducing expenses!'
                  .text
                  .sm
                  .color(AppColors.error)
                  .make()
                  .expand(),
            ]),
          ).animate().shake(duration: 500.ms),
        ],
      ]),
    ).animate().fadeIn().slideY(begin: -0.05);
  }

  Widget _buildSetupCard(BuildContext context, WidgetRef ref) {
    return GFCard(
      padding: const EdgeInsets.all(AppSpacing.lg),
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      content: HStack([
        const Icon(LucideIcons.wallet, color: AppColors.textSecondaryDark),
        12.widthBox,
        VStack(crossAlignment: CrossAxisAlignment.start, [
          'Set Monthly Budget'.text.semiBold.make(),
          'Track spending and get alerts'.text.xs.gray500.make(),
        ]).expand(),
        GFButton(
          onPressed: () => _showBudgetSettings(context, ref),
          text: 'Setup',
          type: GFButtonType.outline,
          size: GFSize.SMALL,
        ),
      ]),
    );
  }

  Widget _buildProgressBar(BudgetSummary summary) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: (summary.percentUsed / 100).clamp(0, 1),
            backgroundColor: AppColors.borderDark,
            valueColor: AlwaysStoppedAnimation(
              summary.percentUsed > 80 ? AppColors.error : AppColors.primary,
            ),
            minHeight: 8,
          ),
        ),
        const Gap(4),
        HStack([
          '${summary.percentUsed.toStringAsFixed(0)}% used'.text.xs.gray500
              .make(),
          '${summary.daysRemaining} days left'.text.xs.gray500.make(),
        ], alignment: MainAxisAlignment.spaceBetween),
      ],
    );
  }

  void _showBudgetSettings(BuildContext context, WidgetRef ref) {
    final budget = ref.read(budgetProvider);
    final controller = TextEditingController(
      text: budget.monthlyLimit > 0
          ? budget.monthlyLimit.toStringAsFixed(0)
          : '',
    );
    var isEnabled = budget.isEnabled;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setState) => Container(
          padding: EdgeInsets.only(
            left: AppSpacing.lg,
            right: AppSpacing.lg,
            top: AppSpacing.lg,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + AppSpacing.lg,
          ),
          decoration: BoxDecoration(
            color: AppColors.surfaceDark,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(AppSpacing.radiusLg),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
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
              'Budget Settings'.text.xl.semiBold.make(),
              const Gap(AppSpacing.lg),

              // Enable toggle
              SwitchListTile(
                value: isEnabled,
                onChanged: (v) => setState(() => isEnabled = v),
                title: const Text('Enable Budget Tracking'),
                contentPadding: EdgeInsets.zero,
              ),
              const Gap(AppSpacing.md),

              // Amount input
              TextFormField(
                controller: controller,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Monthly Budget (৳)',
                  prefixIcon: Icon(LucideIcons.wallet),
                  helperText: 'e.g., 20000 for 20k budget',
                ),
              ),
              const Gap(AppSpacing.lg),

              // Save button
              GFButton(
                onPressed: () {
                  HapticService.buttonPress();
                  final amount = double.tryParse(controller.text) ?? 0;
                  ref.read(budgetProvider.notifier).setMonthlyLimit(amount);
                  ref.read(budgetProvider.notifier).toggleEnabled(isEnabled);
                  Navigator.pop(ctx);
                },
                text: 'Save Budget',
                fullWidthButton: true,
                color: AppColors.primary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
