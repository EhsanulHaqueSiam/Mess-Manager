import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:gap/gap.dart';

import 'package:mess_manager/core/theme/app_theme.dart';
import 'package:mess_manager/core/widgets/app_components.dart';
import 'package:mess_manager/core/services/export_service.dart';
import 'package:mess_manager/core/providers/members_provider.dart';
import 'package:mess_manager/features/analytics/providers/analytics_provider.dart';
import 'package:mess_manager/features/analytics/providers/price_trend_provider.dart';
import 'package:mess_manager/features/balance/providers/balance_provider.dart';
import 'package:mess_manager/features/bazar/providers/bazar_provider.dart';

/// Analytics Screen
class AnalyticsScreen extends ConsumerWidget {
  const AnalyticsScreen({super.key});

  /// Glass morphism card wrapper
  Widget _glassCard({required Widget child, EdgeInsetsGeometry? padding}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: Container(
          padding: padding ?? const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.03),
            border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          ),
          child: child,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final weeklyTrend = ref.watch(weeklyTrendProvider);
    final avgDailySpending = ref.watch(avgDailySpendingProvider);
    final avgDailyMeals = ref.watch(avgDailyMealsProvider);
    final summary = ref.watch(balanceSummaryProvider);

    return Scaffold(
      backgroundColor: const Color(0xFF0A0E1A),
      body: Stack(
        children: [
          // Background gradient
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFF0A0E1A), Color(0xFF0D1520)],
                ),
              ),
            ),
          ),

          // Breathing accent orb - top right
          Positioned(
            top: -60,
            right: -40,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppColors.primary.withValues(alpha: 0.15),
                    AppColors.primary.withValues(alpha: 0.0),
                  ],
                ),
              ),
            )
                .animate(onPlay: (c) => c.repeat(reverse: true))
                .scaleXY(begin: 0.8, end: 1.2, duration: 4000.ms),
          ),

          // Breathing accent orb - bottom left
          Positioned(
            bottom: 100,
            left: -60,
            child: Container(
              width: 180,
              height: 180,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppColors.primary.withValues(alpha: 0.1),
                    AppColors.primary.withValues(alpha: 0.0),
                  ],
                ),
              ),
            )
                .animate(onPlay: (c) => c.repeat(reverse: true))
                .scaleXY(begin: 1.0, end: 1.3, duration: 5000.ms),
          ),

          // Main content
          SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Custom header row
                    Row(
                      children: [
                        // Gradient halo icon
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: RadialGradient(
                              colors: [
                                AppColors.primary.withValues(alpha: 0.3),
                                AppColors.primary.withValues(alpha: 0.0),
                              ],
                            ),
                          ),
                          child: const Center(
                            child: Icon(
                              LucideIcons.barChart3,
                              color: AppColors.primary,
                              size: 22,
                            ),
                          ),
                        ),
                        const Gap(12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Analytics',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge
                                    ?.copyWith(
                                      color:
                                          Colors.white.withValues(alpha: 0.9),
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                              Text(
                                'Spending & meal insights',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.white.withValues(alpha: 0.5),
                                ),
                              ),
                            ],
                          ),
                        ),
                        PopupMenuButton<String>(
                          icon: Icon(
                            LucideIcons.share2,
                            size: 22,
                            color: Colors.white.withValues(alpha: 0.5),
                          ),
                          tooltip: 'Export',
                          color: const Color(0xFF0D1520),
                          onSelected: (value) {
                            if (value == 'csv') {
                              _exportCsv(context, summary, weeklyTrend);
                            } else if (value == 'pdf') {
                              _exportPdf(context, summary, weeklyTrend);
                            }
                          },
                          itemBuilder: (ctx) => [
                            PopupMenuItem(
                              value: 'csv',
                              child: Row(
                                children: [
                                  Icon(
                                    LucideIcons.fileSpreadsheet,
                                    size: 18,
                                    color:
                                        Colors.white.withValues(alpha: 0.9),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Export CSV',
                                    style: TextStyle(
                                      color: Colors.white
                                          .withValues(alpha: 0.9),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            PopupMenuItem(
                              value: 'pdf',
                              child: Row(
                                children: [
                                  Icon(
                                    LucideIcons.fileText,
                                    size: 18,
                                    color:
                                        Colors.white.withValues(alpha: 0.9),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Export PDF',
                                    style: TextStyle(
                                      color: Colors.white
                                          .withValues(alpha: 0.9),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const Gap(24),

                    // Quick Stats
                    Row(
                      children: [
                        Expanded(
                          child: _buildStatCard(
                            context: context,
                            icon: LucideIcons.wallet,
                            label: 'Daily Avg',
                            value: '৳${avgDailySpending.toStringAsFixed(0)}',
                            subtitle: 'spending',
                            color: AppColors.bazarColor,
                          ),
                        ),
                        const Gap(8),
                        Expanded(
                          child: _buildStatCard(
                            context: context,
                            icon: LucideIcons.utensils,
                            label: 'Daily Avg',
                            value: avgDailyMeals.toStringAsFixed(1),
                            subtitle: 'meals',
                            color: AppColors.mealColor,
                          ),
                        ),
                      ],
                    ).animate().fadeIn().slideY(begin: 0.1),
                    const Gap(16),

                    // Weekly Trend
                    Text(
                      'Last 7 Days',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.white.withValues(alpha: 0.9),
                          ),
                    ),
                    const Gap(8),
                    _buildWeeklyChart(context, weeklyTrend),
                    const Gap(16),

                    // Month Summary
                    Text(
                      'This Month',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.white.withValues(alpha: 0.9),
                          ),
                    ),
                    const Gap(8),
                    _glassCard(
                      child: Column(
                        children: [
                          _buildMonthRow(
                            context: context,
                            icon: LucideIcons.shoppingCart,
                            label: 'Total Bazar',
                            value:
                                '৳${summary.totalBazar.toStringAsFixed(0)}',
                            color: AppColors.bazarColor,
                          ),
                          Divider(
                            color: Colors.white.withValues(alpha: 0.06),
                          ),
                          _buildMonthRow(
                            context: context,
                            icon: LucideIcons.utensils,
                            label: 'Total Meals',
                            value: summary.totalMeals.toStringAsFixed(1),
                            color: AppColors.mealColor,
                          ),
                          Divider(
                            color: Colors.white.withValues(alpha: 0.06),
                          ),
                          _buildMonthRow(
                            context: context,
                            icon: LucideIcons.calculator,
                            label: 'Meal Rate',
                            value:
                                '৳${summary.mealRate.toStringAsFixed(2)}',
                            color: AppColors.primary,
                          ),
                        ],
                      ),
                    ).animate(delay: 200.ms).fadeIn().slideY(begin: 0.1),
                    const Gap(16),

                    // Contribution Pie Chart
                    Text(
                      'Contribution Breakdown',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.white.withValues(alpha: 0.9),
                          ),
                    ),
                    const Gap(8),
                    _buildContributionPieChart(context, ref),
                    const Gap(16),

                    // Price Spike Alerts (Expense Watchlist)
                    _buildPriceSpikeAlerts(context, ref),

                    // Tip Card
                    _buildTipCard(context),
                    const Gap(32),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required BuildContext context,
    required IconData icon,
    required String label,
    required String value,
    required String subtitle,
    required Color color,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.03),
            border: Border.all(color: color.withValues(alpha: 0.15)),
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(icon, color: color, size: 18),
                  const Gap(4),
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.white.withValues(alpha: 0.5),
                    ),
                  ),
                ],
              ),
              const Gap(8),
              Text(
                value,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: color,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.white.withValues(alpha: 0.3),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Build contribution pie chart using fl_chart
  Widget _buildContributionPieChart(BuildContext context, WidgetRef ref) {
    final members = ref.watch(membersProvider);
    final bazarByMember = ref.watch(bazarByMemberProvider);
    final totalBazar = ref.watch(totalBazarProvider);

    if (totalBazar <= 0 || bazarByMember.isEmpty) {
      return _glassCard(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Center(
            child: Text(
              'No contribution data',
              style: TextStyle(color: Colors.white.withValues(alpha: 0.3)),
            ),
          ),
        ),
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

    return _glassCard(
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
                      const Gap(4),
                      Text(
                        members[i].name.toString(),
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.white.withValues(alpha: 0.5),
                        ),
                      ),
                    ],
                  ),
            ],
          ),
        ],
      ),
    ).animate(delay: 250.ms).fadeIn().slideY(begin: 0.1);
  }

  Widget _buildWeeklyChart(BuildContext context, List<DailyStats> stats) {
    if (stats.isEmpty) {
      return _glassCard(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Center(
            child: Text(
              'No data yet',
              style: TextStyle(color: Colors.white.withValues(alpha: 0.3)),
            ),
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

    return _glassCard(
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
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
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
          const Gap(8),

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
                    style: TextStyle(
                      fontSize: 10,
                      color: isToday
                          ? AppColors.primary
                          : Colors.white.withValues(alpha: 0.3),
                      fontWeight: isToday ? FontWeight.w600 : FontWeight.w400,
                    ),
                  ),
                ),
              );
            }),
          ),
          const Gap(12),

          // Legend
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildLegendItem(context, 'Meals', AppColors.mealColor),
              const Gap(16),
              _buildLegendItem(context, 'Bazar', AppColors.bazarColor),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(BuildContext context, String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
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
          style: TextStyle(
            fontSize: 10,
            color: Colors.white.withValues(alpha: 0.5),
          ),
        ),
      ],
    );
  }

  Widget _buildMonthRow({
    required BuildContext context,
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: color, size: 18),
          const Gap(8),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.9),
              ),
            ),
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: color,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildTipCard(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.03),
            border: Border.all(color: AppColors.info.withValues(alpha: 0.15)),
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(LucideIcons.lightbulb, color: AppColors.info, size: 20),
              const Gap(8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Tip',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.info,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Gap(2),
                    Text(
                      'Set up your weekly meal schedule to track expected vs actual consumption!',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white.withValues(alpha: 0.5),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ).animate(delay: 300.ms).fadeIn();
  }

  /// Build price spike alerts card (Expense Watchlist)
  Widget _buildPriceSpikeAlerts(BuildContext context, WidgetRef ref) {
    final spikes = ref.watch(priceSpikesProvider);
    final alertMessage = ref.watch(spikeAlertMessageProvider);

    // Don't show if no spikes
    if (spikes.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Gap(16),
        Text(
          'Expense Watchlist',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.white.withValues(alpha: 0.9),
              ),
        ),
        const Gap(8),
        ClipRRect(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
            child: Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.03),
                border: Border.all(
                  color: AppColors.warning.withValues(alpha: 0.15),
                ),
                borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
              ),
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
                      const Gap(12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Price Alerts',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Colors.white.withValues(alpha: 0.9),
                              ),
                            ),
                            if (alertMessage != null)
                              Text(
                                alertMessage,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.white.withValues(alpha: 0.5),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const Gap(16),
                  // Spike list
                  ...spikes
                      .take(5)
                      .map(
                        (spike) => Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  spike.itemName[0].toUpperCase() +
                                      spike.itemName.substring(1),
                                  style: TextStyle(
                                    color:
                                        Colors.white.withValues(alpha: 0.9),
                                  ),
                                ),
                              ),
                              Text(
                                '৳${spike.lastPrice.toStringAsFixed(0)}',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white.withValues(alpha: 0.9),
                                ),
                              ),
                              const Gap(8),
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
                        color: Colors.white.withValues(alpha: 0.3),
                        fontSize: 12,
                      ),
                    ),
                ],
              ),
            ),
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
