import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:gap/gap.dart';
import 'package:mess_manager/core/theme/app_theme.dart';
import 'package:mess_manager/features/analytics/providers/analytics_provider.dart';
import 'package:mess_manager/features/balance/providers/balance_provider.dart';

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
        title: Row(
          children: [
            const Icon(
              LucideIcons.barChart3,
              color: AppColors.primary,
              size: 22,
            ),
            const Gap(AppSpacing.sm),
            const Text('Analytics'),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Quick Stats
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    icon: LucideIcons.wallet,
                    label: 'Daily Avg',
                    value: '৳${avgDailySpending.toStringAsFixed(0)}',
                    subtitle: 'spending',
                    color: AppColors.bazarColor,
                  ),
                ),
                const Gap(AppSpacing.sm),
                Expanded(
                  child: _buildStatCard(
                    icon: LucideIcons.utensils,
                    label: 'Daily Avg',
                    value: avgDailyMeals.toStringAsFixed(1),
                    subtitle: 'meals',
                    color: AppColors.mealColor,
                  ),
                ),
              ],
            ).animate().fadeIn().slideY(begin: 0.1),
            const Gap(AppSpacing.lg),

            // Weekly Trend Chart
            Text(
              'Last 7 Days',
              style: AppTypography.headlineSmall.copyWith(
                color: AppColors.textPrimaryDark,
              ),
            ),
            const Gap(AppSpacing.sm),
            _buildWeeklyChart(weeklyTrend),
            const Gap(AppSpacing.lg),

            // Month Summary
            Text(
              'This Month',
              style: AppTypography.headlineSmall.copyWith(
                color: AppColors.textPrimaryDark,
              ),
            ),
            const Gap(AppSpacing.sm),
            Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: AppColors.cardDark,
                borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                border: Border.all(
                  color: AppColors.borderDark.withValues(alpha: 0.5),
                ),
              ),
              child: Column(
                children: [
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
                ],
              ),
            ).animate(delay: 200.ms).fadeIn().slideY(begin: 0.1),
            const Gap(AppSpacing.lg),

            // Tips
            _buildTipCard(),
            const Gap(AppSpacing.xxl),
          ],
        ),
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
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 18),
              const Gap(AppSpacing.xs),
              Text(
                label,
                style: AppTypography.labelSmall.copyWith(
                  color: AppColors.textSecondaryDark,
                ),
              ),
            ],
          ),
          const Gap(AppSpacing.sm),
          Text(
            value,
            style: AppTypography.displaySmall.copyWith(
              color: color,
              fontWeight: FontWeight.w700,
            ),
          ),
          Text(
            subtitle,
            style: AppTypography.labelSmall.copyWith(
              color: AppColors.textMutedDark,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeeklyChart(List<DailyStats> stats) {
    if (stats.isEmpty) {
      return Container(
        height: 150,
        alignment: Alignment.center,
        child: Text(
          'No data yet',
          style: AppTypography.bodyMedium.copyWith(
            color: AppColors.textMutedDark,
          ),
        ),
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

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.cardDark,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        border: Border.all(color: AppColors.borderDark.withValues(alpha: 0.5)),
      ),
      child: Column(
        children: [
          // Bars
          SizedBox(
            height: 120,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: List.generate(7, (index) {
                final stat = index < stats.length ? stats[index] : null;
                final mealHeight = stat != null && maxMeals > 0
                    ? (stat.mealCount / maxMeals) * 80
                    : 0.0;
                final bazarHeight = stat != null && maxBazar > 0
                    ? (stat.bazarAmount / maxBazar) * 80
                    : 0.0;

                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 2),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        // Bazar bar
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
                        const Gap(2),
                        // Meals bar
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
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
          const Gap(AppSpacing.sm),
          // Day labels
          Row(
            children: List.generate(7, (index) {
              final date = stats.isNotEmpty && index < stats.length
                  ? stats[index].date
                  : null;
              final isToday =
                  date != null &&
                  date.day == DateTime.now().day &&
                  date.month == DateTime.now().month;

              return Expanded(
                child: Center(
                  child: Text(
                    date != null ? weekdays[date.weekday - 1] : '',
                    style: AppTypography.labelSmall.copyWith(
                      color: isToday
                          ? AppColors.primary
                          : AppColors.textMutedDark,
                      fontWeight: isToday ? FontWeight.w600 : null,
                    ),
                  ),
                ),
              );
            }),
          ),
          const Gap(AppSpacing.md),
          // Legend
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildLegendItem('Meals', AppColors.mealColor),
              const Gap(AppSpacing.lg),
              _buildLegendItem('Bazar', AppColors.bazarColor),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const Gap(4),
        Text(
          label,
          style: AppTypography.labelSmall.copyWith(
            color: AppColors.textSecondaryDark,
          ),
        ),
      ],
    );
  }

  Widget _buildMonthRow({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: Row(
        children: [
          Icon(icon, color: color, size: 18),
          const Gap(AppSpacing.sm),
          Expanded(
            child: Text(
              label,
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.textPrimaryDark,
              ),
            ),
          ),
          Text(
            value,
            style: AppTypography.titleMedium.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTipCard() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.info.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        border: Border.all(color: AppColors.info.withValues(alpha: 0.3)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(LucideIcons.lightbulb, color: AppColors.info, size: 20),
          const Gap(AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Tip',
                  style: AppTypography.labelMedium.copyWith(
                    color: AppColors.info,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Gap(2),
                Text(
                  'Set up your weekly meal schedule to track expected vs actual consumption!',
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textSecondaryDark,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate(delay: 300.ms).fadeIn();
  }
}
