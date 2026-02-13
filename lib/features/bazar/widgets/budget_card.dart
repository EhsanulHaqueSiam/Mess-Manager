import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lucide_icons/lucide_icons.dart';
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

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      decoration: BoxDecoration(
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
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with budget status
          Row(
            children: [
              Icon(
                summary.isOverBudget
                    ? LucideIcons.alertTriangle
                    : LucideIcons.wallet,
                color: summary.isOverBudget ? AppColors.error : AppColors.primary,
                size: 24,
              ),
              const Gap(8),
              Expanded(
                child: Text(
                  'Monthly Budget',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: context.textPrimary,
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(LucideIcons.settings, size: 18),
                onPressed: () => _showBudgetSettings(context, ref),
              ),
            ],
          ),
          const Gap(AppSpacing.md),

          // Progress bar
          _buildProgressBar(context, summary),
          const Gap(AppSpacing.sm),

          // Stats row
          Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    Text(
                      '৳${summary.totalSpent.toStringAsFixed(0)}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: context.textPrimary,
                      ),
                    ),
                    Text(
                      'Spent',
                      style: TextStyle(
                        fontSize: 10,
                        color: context.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    Text(
                      '৳${summary.remaining.toStringAsFixed(0)}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: summary.remaining < 0
                            ? AppColors.error
                            : AppColors.success,
                      ),
                    ),
                    Text(
                      'Remaining',
                      style: TextStyle(
                        fontSize: 10,
                        color: context.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    Text(
                      '৳${summary.dailyBurnRate.toStringAsFixed(0)}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: context.textPrimary,
                      ),
                    ),
                    Text(
                      'Daily Avg',
                      style: TextStyle(
                        fontSize: 10,
                        color: context.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          // Warning if over budget
          if (summary.isOverBudget) ...[
            const Gap(AppSpacing.md),
            Container(
              padding: const EdgeInsets.all(AppSpacing.sm),
              decoration: BoxDecoration(
                color: AppColors.error.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
              ),
              child: Row(
                children: [
                  const Icon(
                    LucideIcons.alertCircle,
                    size: 16,
                    color: AppColors.error,
                  ),
                  const Gap(8),
                  Expanded(
                    child: Text(
                      'Projected: ৳${summary.projectedTotal.toStringAsFixed(0)} - Consider reducing expenses!',
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.error,
                      ),
                    ),
                  ),
                ],
              ),
            ).animate().shake(duration: 500.ms),
          ],
        ],
      ),
    ).animate().fadeIn().slideY(begin: -0.05);
  }

  Widget _buildSetupCard(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      decoration: BoxDecoration(
        color: context.cardColor,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        border: Border.all(
          color: context.borderColor.withValues(alpha: 0.5),
        ),
      ),
      child: Row(
        children: [
          Icon(LucideIcons.wallet, color: context.textSecondary),
          const Gap(12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Set Monthly Budget',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: context.textPrimary,
                  ),
                ),
                Text(
                  'Track spending and get alerts',
                  style: TextStyle(
                    fontSize: 10,
                    color: context.textMuted,
                  ),
                ),
              ],
            ),
          ),
          OutlinedButton(
            onPressed: () => _showBudgetSettings(context, ref),
            child: const Text('Setup'),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressBar(BuildContext context, BudgetSummary summary) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: (summary.percentUsed / 100).clamp(0, 1),
            backgroundColor: context.borderColor,
            valueColor: AlwaysStoppedAnimation(
              summary.percentUsed > 80 ? AppColors.error : AppColors.primary,
            ),
            minHeight: 8,
          ),
        ),
        const Gap(4),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${summary.percentUsed.toStringAsFixed(0)}% used',
              style: TextStyle(
                fontSize: 10,
                color: context.textMuted,
              ),
            ),
            Text(
              '${summary.daysRemaining} days left',
              style: TextStyle(
                fontSize: 10,
                color: context.textMuted,
              ),
            ),
          ],
        ),
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
            color: context.surfaceColor,
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
                    color: context.borderColor,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const Gap(AppSpacing.lg),
              Text(
                'Budget Settings',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: context.textPrimary,
                ),
              ),
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
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () {
                    HapticService.buttonPress();
                    final amount = double.tryParse(controller.text) ?? 0;
                    ref.read(budgetProvider.notifier).setMonthlyLimit(amount);
                    ref.read(budgetProvider.notifier).toggleEnabled(isEnabled);
                    Navigator.pop(ctx);
                  },
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.primary,
                  ),
                  child: const Text('Save Budget'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
