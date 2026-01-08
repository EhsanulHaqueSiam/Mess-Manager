import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:getwidget/getwidget.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:gap/gap.dart';

import 'package:mess_manager/core/theme/app_theme.dart';
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

    return GFCard(
      padding: const EdgeInsets.all(AppSpacing.lg),
      margin: EdgeInsets.zero,
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
      content: VStack(crossAlignment: CrossAxisAlignment.start, [
        // Header
        HStack([
          Icon(LucideIcons.calculator, color: AppColors.mealColor, size: 20),
          8.widthBox,
          'Meal Rate Formula'.text.semiBold.make().expand(),
          GFBadge(
            text: '৳${summary.mealRate.toStringAsFixed(2)}',
            color: AppColors.mealColor,
          ),
        ]),
        const Gap(AppSpacing.md),

        // Formula visualization
        Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: AppColors.surfaceDark,
            borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
            border: Border.all(color: AppColors.borderDark),
          ),
          child: Column(
            children: [
              // Numerator breakdown
              HStack([
                _buildFormulaItem(
                  'Bazar',
                  '৳${summary.totalBazar.toStringAsFixed(0)}',
                  LucideIcons.shoppingCart,
                  AppColors.bazarColor,
                ).expand(),
                '+'.text.xl.bold.gray500.make().p8(),
                _buildFormulaItem(
                  'Fixed',
                  '৳${summary.totalFixedExpenses.toStringAsFixed(0)}',
                  LucideIcons.home,
                  AppColors.warning,
                ).expand(),
              ]),
              const Divider(height: 24),

              // Division line
              HStack([
                VStack([
                  '৳${numerator.toStringAsFixed(0)}'.text.lg.bold.make(),
                  'Total Cost'.text.xs.gray500.make(),
                ]).expand(),
                '÷'.text.xl2.bold.color(AppColors.primary).make().p8(),
                VStack([
                  totalMeals.toStringAsFixed(1).text.lg.bold.make(),
                  'Total Meals'.text.xs.gray500.make(),
                ]).expand(),
                '='.text.xl2.bold.color(AppColors.success).make().p8(),
                VStack([
                  '৳${summary.mealRate.toStringAsFixed(2)}'.text.lg.bold
                      .color(AppColors.success)
                      .make(),
                  'Per Meal'.text.xs.gray500.make(),
                ]).expand(),
              ]),
            ],
          ),
        ),
        const Gap(AppSpacing.sm),

        // Info note
        HStack([
          const Icon(
            LucideIcons.info,
            size: 14,
            color: AppColors.textSecondaryDark,
          ),
          6.widthBox,
          'Rate = (Bazar + Fixed Costs) ÷ Total Meals'.text.xs.gray500
              .make()
              .expand(),
        ]),
      ]),
    ).animate().fadeIn().scale(begin: const Offset(0.98, 0.98));
  }

  Widget _buildFormulaItem(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return VStack(crossAlignment: CrossAxisAlignment.center, [
      GFAvatar(
        size: 28,
        backgroundColor: color.withValues(alpha: 0.15),
        child: Icon(icon, size: 14, color: color),
      ),
      const Gap(4),
      value.text.sm.bold.make(),
      label.text.xs.gray500.make(),
    ]);
  }
}
