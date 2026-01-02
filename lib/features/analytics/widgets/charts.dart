import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:mess_manager/core/theme/app_theme.dart';

/// Balance donut chart showing credit vs debt distribution
class BalanceDonutChart extends StatelessWidget {
  final double balance;
  final double totalContribution;
  final double totalConsumption;

  const BalanceDonutChart({
    super.key,
    required this.balance,
    required this.totalContribution,
    required this.totalConsumption,
  });

  @override
  Widget build(BuildContext context) {
    final isCredit = balance >= 0;
    final absBalance = balance.abs();

    return SizedBox(
      height: 200,
      child: Stack(
        alignment: Alignment.center,
        children: [
          PieChart(
            PieChartData(
              sectionsSpace: 3,
              centerSpaceRadius: 60,
              sections: [
                PieChartSectionData(
                  value: totalContribution,
                  color: AppColors.success,
                  title: '',
                  radius: 25,
                ),
                PieChartSectionData(
                  value: totalConsumption,
                  color: AppColors.error,
                  title: '',
                  radius: 25,
                ),
              ],
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                isCredit ? 'CREDIT' : 'DEBT',
                style: AppTypography.labelSmall.copyWith(
                  color: AppColors.textSecondaryDark,
                ),
              ),
              Text(
                '৳${absBalance.toStringAsFixed(0)}',
                style: AppTypography.displaySmall.copyWith(
                  color: isCredit ? AppColors.success : AppColors.error,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Monthly spending trend line chart
class SpendingTrendChart extends StatelessWidget {
  final List<double> monthlySpending;
  final List<String> monthLabels;

  const SpendingTrendChart({
    super.key,
    required this.monthlySpending,
    required this.monthLabels,
  });

  @override
  Widget build(BuildContext context) {
    if (monthlySpending.isEmpty) return const SizedBox.shrink();

    final maxY = monthlySpending.reduce((a, b) => a > b ? a : b);

    return SizedBox(
      height: 200,
      child: LineChart(
        LineChartData(
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: maxY / 4,
            getDrawingHorizontalLine: (value) =>
                FlLine(color: AppColors.borderDark, strokeWidth: 1),
          ),
          titlesData: FlTitlesData(
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  final idx = value.toInt();
                  if (idx >= 0 && idx < monthLabels.length) {
                    return Text(
                      monthLabels[idx],
                      style: AppTypography.labelSmall.copyWith(
                        color: AppColors.textSecondaryDark,
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 45,
                getTitlesWidget: (value, meta) => Text(
                  '৳${(value / 1000).toStringAsFixed(0)}k',
                  style: AppTypography.labelSmall.copyWith(
                    color: AppColors.textSecondaryDark,
                  ),
                ),
              ),
            ),
          ),
          borderData: FlBorderData(show: false),
          lineBarsData: [
            LineChartBarData(
              spots: monthlySpending.asMap().entries.map((e) {
                return FlSpot(e.key.toDouble(), e.value);
              }).toList(),
              isCurved: true,
              color: AppColors.primary,
              barWidth: 3,
              dotData: FlDotData(
                show: true,
                getDotPainter: (spot, percent, bar, index) {
                  return FlDotCirclePainter(
                    radius: 4,
                    color: AppColors.primary,
                    strokeWidth: 2,
                    strokeColor: AppColors.surfaceDark,
                  );
                },
              ),
              belowBarData: BarAreaData(
                show: true,
                color: AppColors.primary.withValues(alpha: 0.15),
              ),
            ),
          ],
          minY: 0,
          maxY: maxY * 1.1,
        ),
      ),
    );
  }
}

/// Meal comparison bar chart
class MealComparisonChart extends StatelessWidget {
  final Map<String, int> memberMeals;
  final double averageMeals;

  const MealComparisonChart({
    super.key,
    required this.memberMeals,
    required this.averageMeals,
  });

  @override
  Widget build(BuildContext context) {
    final entries = memberMeals.entries.toList();
    final maxMeals = entries.isEmpty
        ? 1.0
        : entries
              .map((e) => e.value)
              .reduce((a, b) => a > b ? a : b)
              .toDouble();

    return SizedBox(
      height: 200,
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: maxMeals * 1.2,
          barTouchData: BarTouchData(enabled: true),
          titlesData: FlTitlesData(
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            leftTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  final idx = value.toInt();
                  if (idx >= 0 && idx < entries.length) {
                    return Text(
                      entries[idx].key.substring(0, 2),
                      style: AppTypography.labelSmall.copyWith(
                        color: AppColors.textSecondaryDark,
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          ),
          borderData: FlBorderData(show: false),
          barGroups: entries.asMap().entries.map((entry) {
            final isAboveAvg = entry.value.value > averageMeals;
            return BarChartGroupData(
              x: entry.key,
              barRods: [
                BarChartRodData(
                  toY: entry.value.value.toDouble(),
                  width: 20,
                  color: isAboveAvg ? AppColors.warning : AppColors.success,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(4),
                  ),
                ),
              ],
            );
          }).toList(),
          gridData: FlGridData(
            show: true,
            horizontalInterval: averageMeals,
            getDrawingHorizontalLine: (value) {
              if (value == averageMeals) {
                return FlLine(
                  color: AppColors.primary,
                  strokeWidth: 2,
                  dashArray: [5, 5],
                );
              }
              return FlLine(color: Colors.transparent);
            },
          ),
        ),
      ),
    );
  }
}
