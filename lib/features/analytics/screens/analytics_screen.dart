import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:getwidget/getwidget.dart';

import 'package:mess_manager/core/theme/app_theme.dart';
import 'package:mess_manager/core/widgets/gf_components.dart';
import 'package:mess_manager/features/analytics/providers/analytics_provider.dart';
import 'package:mess_manager/features/balance/providers/balance_provider.dart';

/// Analytics Screen - Uses GetWidget + VelocityX + flutter_animate
class AnalyticsScreen extends ConsumerWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final weeklyTrend = ref.watch(weeklyTrendProvider);
    final avgDailySpending = ref.watch(avgDailySpendingProvider);
    final avgDailyMeals = ref.watch(avgDailyMealsProvider);
    final summary = ref.watch(balanceSummaryProvider);

    return Scaffold(
      appBar: AppBar(
        title: [
          const Icon(LucideIcons.barChart3, color: AppColors.primary, size: 22),
          8.widthBox,
          'Analytics'.text.make(),
        ].hStack(),
      ),
      body: SingleChildScrollView(
        child: VStack([
          // Quick Stats
          HStack([
            _buildStatCard(
              icon: LucideIcons.wallet,
              label: 'Daily Avg',
              value: '৳${avgDailySpending.toStringAsFixed(0)}',
              subtitle: 'spending',
              color: AppColors.bazarColor,
            ).expand(),
            8.widthBox,
            _buildStatCard(
              icon: LucideIcons.utensils,
              label: 'Daily Avg',
              value: avgDailyMeals.toStringAsFixed(1),
              subtitle: 'meals',
              color: AppColors.mealColor,
            ).expand(),
          ]).animate().fadeIn().slideY(begin: 0.1),
          16.heightBox,

          // Weekly Trend
          'Last 7 Days'.text.xl.bold.color(AppColors.textPrimaryDark).make(),
          8.heightBox,
          _buildWeeklyChart(weeklyTrend),
          16.heightBox,

          // Month Summary
          'This Month'.text.xl.bold.color(AppColors.textPrimaryDark).make(),
          8.heightBox,
          GFAppCard(
            child: VStack([
              _buildMonthRow(
                icon: LucideIcons.shoppingCart,
                label: 'Total Bazar',
                value: '৳${summary.totalBazar.toStringAsFixed(0)}',
                color: AppColors.bazarColor,
              ),
              const Divider(color: AppColors.borderDark),
              _buildMonthRow(
                icon: LucideIcons.utensils,
                label: 'Total Meals',
                value: summary.totalMeals.toStringAsFixed(1),
                color: AppColors.mealColor,
              ),
              const Divider(color: AppColors.borderDark),
              _buildMonthRow(
                icon: LucideIcons.calculator,
                label: 'Meal Rate',
                value: '৳${summary.mealRate.toStringAsFixed(2)}',
                color: AppColors.primary,
              ),
            ]),
          ).animate(delay: 200.ms).fadeIn().slideY(begin: 0.1),
          16.heightBox,

          // Tip Card
          _buildTipCard(),
          32.heightBox,
        ]).p16(),
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String label,
    required String value,
    required String subtitle,
    required Color color,
  }) {
    return GFCard(
      padding: const EdgeInsets.all(AppSpacing.md),
      margin: EdgeInsets.zero,
      color: color.withValues(alpha: 0.1),
      border: Border.all(color: color.withValues(alpha: 0.2)),
      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      content: VStack(crossAlignment: CrossAxisAlignment.start, [
        HStack([
          Icon(icon, color: color, size: 18),
          4.widthBox,
          label.text.xs.color(AppColors.textSecondaryDark).make(),
        ]),
        8.heightBox,
        value.text.xl2.color(color).bold.make(),
        subtitle.text.xs.color(AppColors.textMutedDark).make(),
      ]),
    );
  }

  Widget _buildWeeklyChart(List<DailyStats> stats) {
    if (stats.isEmpty) {
      return GFAppCard(
        child: 'No data yet'.text
            .color(AppColors.textMutedDark)
            .center
            .make()
            .p16(),
      );
    }

    final maxMeals = stats.fold(
      0.0,
      (max, s) => s.mealCount > max ? s.mealCount : max,
    );
    final maxBazar = stats.fold(
      0.0,
      (max, s) => s.bazarAmount > max ? s.bazarAmount : max,
    );
    final weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

    return GFAppCard(
      child: VStack([
        // Bars
        SizedBox(
          height: 120,
          child: HStack(
            crossAlignment: CrossAxisAlignment.end,
            List.generate(7, (index) {
              final stat = index < stats.length ? stats[index] : null;
              final mealHeight = stat != null && maxMeals > 0
                  ? (stat.mealCount / maxMeals) * 80
                  : 0.0;
              final bazarHeight = stat != null && maxBazar > 0
                  ? (stat.bazarAmount / maxBazar) * 80
                  : 0.0;

              return VStack(alignment: MainAxisAlignment.end, [
                Container(
                  height: bazarHeight,
                  width: 12,
                  decoration: BoxDecoration(
                    color: AppColors.bazarColor.withValues(alpha: 0.7),
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(2),
                    ),
                  ),
                ),
                2.heightBox,
                Container(
                  height: mealHeight,
                  width: 12,
                  decoration: BoxDecoration(
                    color: AppColors.mealColor,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(2),
                    ),
                  ),
                ),
              ]).px4().expand();
            }),
          ),
        ),
        8.heightBox,

        // Day labels
        HStack(
          List.generate(7, (index) {
            final date = stats.isNotEmpty && index < stats.length
                ? stats[index].date
                : null;
            final isToday =
                date != null &&
                date.day == DateTime.now().day &&
                date.month == DateTime.now().month;

            return (date != null ? weekdays[date.weekday - 1] : '').text.xs
                .color(isToday ? AppColors.primary : AppColors.textMutedDark)
                .fontWeight(isToday ? FontWeight.w600 : FontWeight.w400)
                .make()
                .centered()
                .expand();
          }),
        ),
        12.heightBox,

        // Legend
        HStack(alignment: MainAxisAlignment.center, [
          _buildLegendItem('Meals', AppColors.mealColor),
          16.widthBox,
          _buildLegendItem('Bazar', AppColors.bazarColor),
        ]),
      ]),
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return HStack([
      Container(
        width: 12,
        height: 12,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(2),
        ),
      ),
      4.widthBox,
      label.text.xs.color(AppColors.textSecondaryDark).make(),
    ]);
  }

  Widget _buildMonthRow({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return HStack([
      Icon(icon, color: color, size: 18),
      8.widthBox,
      label.text.color(AppColors.textPrimaryDark).make().expand(),
      value.text.lg.color(color).bold.make(),
    ]).py8();
  }

  Widget _buildTipCard() {
    return GFAppCard(
      color: AppColors.info.withValues(alpha: 0.1),
      borderColor: AppColors.info.withValues(alpha: 0.3),
      child: HStack(crossAlignment: CrossAxisAlignment.start, [
        const Icon(LucideIcons.lightbulb, color: AppColors.info, size: 20),
        8.widthBox,
        VStack(crossAlignment: CrossAxisAlignment.start, [
          'Tip'.text.sm.color(AppColors.info).bold.make(),
          2.heightBox,
          'Set up your weekly meal schedule to track expected vs actual consumption!'
              .text
              .sm
              .color(AppColors.textSecondaryDark)
              .make(),
        ]).expand(),
      ]),
    ).animate(delay: 300.ms).fadeIn();
  }
}
