import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:getwidget/getwidget.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:gap/gap.dart';

import 'package:mess_manager/core/theme/app_theme.dart';
import 'package:mess_manager/core/widgets/gf_components.dart';
import 'package:mess_manager/core/services/export_service.dart';
import 'package:mess_manager/core/providers/members_provider.dart';
import 'package:mess_manager/features/analytics/providers/analytics_provider.dart';
import 'package:mess_manager/features/analytics/providers/price_trend_provider.dart';
import 'package:mess_manager/features/balance/providers/balance_provider.dart';
import 'package:mess_manager/features/bazar/providers/bazar_provider.dart';

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
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(LucideIcons.share2, size: 22),
            tooltip: 'Export',
            onSelected: (value) {
              if (value == 'csv') {
                _exportCsv(context, summary, weeklyTrend);
              } else if (value == 'pdf') {
                _exportPdf(context, summary, weeklyTrend);
              }
            },
            itemBuilder: (ctx) => [
              const PopupMenuItem(
                value: 'csv',
                child: Row(
                  children: [
                    Icon(LucideIcons.fileSpreadsheet, size: 18),
                    SizedBox(width: 8),
                    Text('Export CSV'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'pdf',
                child: Row(
                  children: [
                    Icon(LucideIcons.fileText, size: 18),
                    SizedBox(width: 8),
                    Text('Export PDF'),
                  ],
                ),
              ),
            ],
          ),
        ],
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

          // Contribution Pie Chart
          'Contribution Breakdown'.text.xl.bold
              .color(AppColors.textPrimaryDark)
              .make(),
          8.heightBox,
          _buildContributionPieChart(ref),
          16.heightBox,

          // Price Spike Alerts (Expense Watchlist)
          _buildPriceSpikeAlerts(ref),

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

  /// Build contribution pie chart using fl_chart
  Widget _buildContributionPieChart(WidgetRef ref) {
    final members = ref.watch(membersProvider);
    final bazarByMember = ref.watch(bazarByMemberProvider);
    final totalBazar = ref.watch(totalBazarProvider);

    if (totalBazar <= 0 || bazarByMember.isEmpty) {
      return GFAppCard(
        child: 'No contribution data'.text
            .color(AppColors.textMutedDark)
            .center
            .make()
            .p16(),
      );
    }

    // Chart colors
    final colors = [
      AppColors.bazarColor,
      AppColors.mealColor,
      AppColors.primary,
      AppColors.success,
      AppColors.warning,
      AppColors.info,
      AppColors.accentWarm,
    ];

    // Build pie sections
    final sections = <PieChartSectionData>[];
    var colorIndex = 0;
    for (final member in members) {
      final amount = bazarByMember[member.id] ?? 0;
      if (amount > 0) {
        final percentage = (amount / totalBazar) * 100;
        sections.add(
          PieChartSectionData(
            value: amount,
            title: '${percentage.toStringAsFixed(0)}%',
            titleStyle: AppTypography.labelSmall.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
            color: colors[colorIndex % colors.length],
            radius: 50,
          ),
        );
        colorIndex++;
      }
    }

    return GFAppCard(
      child: Column(
        children: [
          SizedBox(
            height: 180,
            child: PieChart(
              PieChartData(
                sections: sections,
                sectionsSpace: 2,
                centerSpaceRadius: 40,
                startDegreeOffset: -90,
              ),
            ),
          ),
          const Gap(AppSpacing.md),
          // Legend
          Wrap(
            spacing: AppSpacing.md,
            runSpacing: AppSpacing.xs,
            alignment: WrapAlignment.center,
            children: [
              for (var i = 0; i < members.length && i < colors.length; i++)
                if ((bazarByMember[members[i].id] ?? 0) > 0)
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: colors[i % colors.length],
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      4.widthBox,
                      members[i].name
                          .toString()
                          .text
                          .xs
                          .color(AppColors.textSecondaryDark)
                          .make(),
                    ],
                  ),
            ],
          ),
        ],
      ),
    ).animate(delay: 250.ms).fadeIn().slideY(begin: 0.1);
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

  /// Build price spike alerts card (Expense Watchlist)
  Widget _buildPriceSpikeAlerts(WidgetRef ref) {
    final spikes = ref.watch(priceSpikesProvider);
    final alertMessage = ref.watch(spikeAlertMessageProvider);

    // Don't show if no spikes
    if (spikes.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        16.heightBox,
        'Expense Watchlist'.text.xl.bold
            .color(AppColors.textPrimaryDark)
            .make(),
        8.heightBox,
        GFAppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Alert header
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.warning.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      LucideIcons.alertTriangle,
                      color: AppColors.warning,
                      size: 20,
                    ),
                  ),
                  12.widthBox,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        'Price Alerts'.text.semiBold.make(),
                        if (alertMessage != null)
                          alertMessage.text.sm
                              .color(AppColors.textSecondaryDark)
                              .make(),
                      ],
                    ),
                  ),
                ],
              ),
              16.heightBox,
              // Spike list
              ...spikes
                  .take(5)
                  .map(
                    (spike) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        children: [
                          Expanded(
                            child: spike.itemName.text.capitalize.make(),
                          ),
                          Text(
                            '৳${spike.lastPrice.toStringAsFixed(0)}',
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                          8.widthBox,
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.red.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              '+${(spike.percentChange * 100).toStringAsFixed(0)}%',
                              style: const TextStyle(
                                color: Colors.red,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              if (spikes.length > 5)
                Text(
                  '+${spikes.length - 5} more items',
                  style: TextStyle(
                    color: AppColors.textMutedDark,
                    fontSize: 12,
                  ),
                ),
            ],
          ),
        ).animate(delay: 350.ms).fadeIn().slideY(begin: 0.1),
      ],
    );
  }

  /// Export analytics data as CSV
  Future<void> _exportCsv(
    BuildContext context,
    BalanceSummary summary,
    List<DailyStats> weeklyTrend,
  ) async {
    try {
      final now = DateTime.now();
      final buffer = StringBuffer();

      // Header
      buffer.writeln('Analytics Report - ${now.month}/${now.year}');
      buffer.writeln('');

      // Summary section
      buffer.writeln('Monthly Summary');
      buffer.writeln('Total Bazar,৳${summary.totalBazar.toStringAsFixed(0)}');
      buffer.writeln('Total Meals,${summary.totalMeals.toStringAsFixed(1)}');
      buffer.writeln('Meal Rate,৳${summary.mealRate.toStringAsFixed(2)}');
      buffer.writeln('');

      // Weekly trend
      buffer.writeln('Daily Trend');
      buffer.writeln('Date,Meals,Bazar Amount');
      for (final stat in weeklyTrend) {
        buffer.writeln(
          '${stat.date.day}/${stat.date.month}/${stat.date.year},${stat.mealCount},${stat.bazarAmount.toStringAsFixed(0)}',
        );
      }

      await ExportService.shareCsv(
        buffer.toString(),
        'analytics_${now.year}_${now.month}.csv',
      );

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Analytics exported to CSV'),
            backgroundColor: AppColors.success,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Export failed: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  /// Export analytics data as PDF
  Future<void> _exportPdf(
    BuildContext context,
    BalanceSummary summary,
    List<DailyStats> weeklyTrend,
  ) async {
    try {
      final now = DateTime.now();

      // Build content for PDF
      final content =
          '''
ANALYTICS REPORT
${now.day}/${now.month}/${now.year}

MONTHLY SUMMARY
═══════════════════════════════════
Total Bazar:     ৳${summary.totalBazar.toStringAsFixed(0)}
Total Meals:     ${summary.totalMeals.toStringAsFixed(1)}
Meal Rate:       ৳${summary.mealRate.toStringAsFixed(2)}

DAILY TREND (Last 7 Days)
═══════════════════════════════════
${weeklyTrend.map((s) => '${s.date.day}/${s.date.month}: ${s.mealCount} meals, ৳${s.bazarAmount.toStringAsFixed(0)} bazar').join('\n')}

Generated by Area51 Mess Manager
''';

      await ExportService.shareCsv(
        content,
        'analytics_${now.year}_${now.month}.txt',
      );

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Analytics exported'),
            backgroundColor: AppColors.success,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Export failed: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }
}
