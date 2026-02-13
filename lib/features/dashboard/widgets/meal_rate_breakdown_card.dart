import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:gap/gap.dart';

import 'package:mess_manager/core/theme/app_theme.dart';
import 'package:mess_manager/core/widgets/app_components.dart';
import 'package:mess_manager/features/balance/providers/balance_provider.dart';
import 'package:mess_manager/features/meals/providers/meals_provider.dart';

/// Meal Rate Breakdown Card - Shows transparent formula for meal rate calculation
class MealRateBreakdownCard extends ConsumerWidget {
  const MealRateBreakdownCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summary = ref.watch(balanceSummaryProvider);
    final totalMeals = ref.watch(totalMealsProvider);

    // Formula: (Total Bazar + Fixed) / Total Meals = Rate
    final numerator = summary.totalBazar + summary.totalFixedExpenses;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.mealColor.withValues(alpha: 0.15),
            AppColors.mealColor.withValues(alpha: 0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(color: AppColors.mealColor.withValues(alpha: 0.3)),
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Icon(LucideIcons.calculator, color: AppColors.mealColor, size: 20),
              const Gap(8),
              Expanded(
                child: Text(
                  'Meal Rate Formula',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: context.textPrimary,
                  ),
                ),
              ),
              AppBadge(
                text: '৳${summary.mealRate.toStringAsFixed(2)}',
                color: AppColors.mealColor.withValues(alpha: 0.1),
                textColor: AppColors.mealColor,
              ),
            ],
          ),
          const Gap(AppSpacing.md),

          // Formula visualization
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: context.surfaceColor,
              borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
              border: Border.all(color: context.borderColor),
            ),
            child: Column(
              children: [
                // Numerator breakdown
                Row(
                  children: [
                    Expanded(
                      child: _buildFormulaItem(
                        context,
                        'Bazar',
                        '৳${summary.totalBazar.toStringAsFixed(0)}',
                        LucideIcons.shoppingCart,
                        AppColors.bazarColor,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text(
                        '+',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: context.textMuted,
                        ),
                      ),
                    ),
                    Expanded(
                      child: _buildFormulaItem(
                        context,
                        'Fixed',
                        '৳${summary.totalFixedExpenses.toStringAsFixed(0)}',
                        LucideIcons.home,
                        AppColors.warning,
                      ),
                    ),
                  ],
                ),
                const Divider(height: 24),

                // Division line
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          Text(
                            '৳${numerator.toStringAsFixed(0)}',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: context.textPrimary,
                            ),
                          ),
                          Text(
                            'Total Cost',
                            style: TextStyle(
                              fontSize: 10,
                              color: context.textMuted,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text(
                        '÷',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          Text(
                            totalMeals.toStringAsFixed(1),
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: context.textPrimary,
                            ),
                          ),
                          Text(
                            'Total Meals',
                            style: TextStyle(
                              fontSize: 10,
                              color: context.textMuted,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text(
                        '=',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: AppColors.success,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          Text(
                            '৳${summary.mealRate.toStringAsFixed(2)}',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppColors.success,
                            ),
                          ),
                          Text(
                            'Per Meal',
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
              ],
            ),
          ),
          const Gap(AppSpacing.sm),

          // Info note
          Row(
            children: [
              Icon(
                LucideIcons.info,
                size: 14,
                color: context.textSecondary,
              ),
              const Gap(6),
              Expanded(
                child: Text(
                  'Rate = (Bazar + Fixed Costs) ÷ Total Meals',
                  style: TextStyle(
                    fontSize: 10,
                    color: context.textMuted,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    ).animate().fadeIn().scale(begin: const Offset(0.98, 0.98));
  }

  Widget _buildFormulaItem(
    BuildContext context,
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CircleAvatar(
          radius: 14,
          backgroundColor: color.withValues(alpha: 0.15),
          child: Icon(icon, size: 14, color: color),
        ),
        const Gap(4),
        Text(
          value,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: context.textPrimary,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            color: context.textMuted,
          ),
        ),
      ],
    );
  }
}
