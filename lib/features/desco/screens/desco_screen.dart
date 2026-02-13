import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:gap/gap.dart';

import 'package:mess_manager/core/theme/app_theme.dart';
import 'package:mess_manager/core/services/desco_service.dart';
import 'package:mess_manager/core/services/haptic_service.dart';
import 'package:mess_manager/core/widgets/app_components.dart';
import 'package:mess_manager/features/desco/providers/desco_provider.dart';
import 'package:mess_manager/core/providers/demo_mode_provider.dart';

/// DESCO Screen - Cosmic Bioluminescence Design
class DescoScreen extends ConsumerStatefulWidget {
  const DescoScreen({super.key});

  @override
  ConsumerState<DescoScreen> createState() => _DescoScreenState();
}

class _DescoScreenState extends ConsumerState<DescoScreen> {
  bool _showPrevYear = false;

  @override
  Widget build(BuildContext context) {
    final balanceAsync = ref.watch(descoBalanceProvider);
    final consumptionAsync = _showPrevYear
        ? ref.watch(descoPrevYearConsumptionProvider)
        : ref.watch(descoConsumptionProvider);
    final lowBalanceAsync = ref.watch(descoLowBalanceProvider);
    final estimatedDays = ref.watch(descoEstimatedDaysProvider);

    // Show setup prompt when no data is configured
    final hasData = balanceAsync.when(
      data: (d) => d != null,
      loading: () => false,
      error: (e, s) => false,
    );

    return Scaffold(
      backgroundColor: const Color(0xFF0A0E1A),
      body: Stack(
        children: [
          // -- Background gradient fill --
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

          // -- Breathing accent orb 1 (top-right, electric yellow) --
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
                    AppColors.warning.withValues(alpha: 0.15),
                    AppColors.warning.withValues(alpha: 0.0),
                  ],
                ),
              ),
            )
                .animate(onPlay: (c) => c.repeat(reverse: true))
                .scaleXY(begin: 0.8, end: 1.2, duration: 4000.ms)
                .fadeIn(duration: 2000.ms),
          ),

          // -- Breathing accent orb 2 (bottom-left, warm amber) --
          Positioned(
            bottom: 80,
            left: -60,
            child: Container(
              width: 160,
              height: 160,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppColors.warning.withValues(alpha: 0.10),
                    AppColors.warning.withValues(alpha: 0.0),
                  ],
                ),
              ),
            )
                .animate(onPlay: (c) => c.repeat(reverse: true))
                .scaleXY(begin: 1.0, end: 1.3, duration: 5000.ms)
                .fadeIn(duration: 2000.ms),
          ),

          // -- Main content --
          SafeArea(
            child: Column(
              children: [
                // -- Custom cosmic header (replaces AppBar) --
                _buildCosmicHeader(context),

                // -- Scrollable body --
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Show setup prompt only when no data
                        if (!hasData) ...[
                          _buildSimpleSetupPrompt(),
                        ] else ...[
                          // Balance card
                          _buildBalanceCard(
                                  balanceAsync, lowBalanceAsync, estimatedDays)
                              .animate(delay: 100.ms)
                              .fadeIn()
                              .slideY(begin: 0.05),
                          const SizedBox(height: 24),

                          // Section label: Monthly Usage
                          _buildSectionLabel('MONTHLY USAGE'),
                          const SizedBox(height: 12),
                          _buildSimpleConsumptionChart(consumptionAsync)
                              .animate(delay: 200.ms)
                              .fadeIn()
                              .slideY(begin: 0.05),
                          const SizedBox(height: 24),

                          // Section label: Quick Stats
                          _buildSectionLabel('QUICK STATS'),
                          const SizedBox(height: 12),

                          // Stats row
                          Row(
                            children: [
                              Expanded(
                                child: _buildSimpleStatCard(
                                  'Est. Days Left',
                                  estimatedDays?.toString() ?? '-',
                                  LucideIcons.calendar,
                                  AppColors.primary,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: _buildSimpleStatCard(
                                  'Avg Monthly',
                                  '${ref.watch(avgMonthlyConsumptionProvider).toStringAsFixed(0)} kWh',
                                  LucideIcons.activity,
                                  AppColors.info,
                                ),
                              ),
                            ],
                          )
                              .animate(delay: 300.ms)
                              .fadeIn()
                              .slideY(begin: 0.05),
                        ],
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ====== Cosmic header (replaces AppBar) ======
  Widget _buildCosmicHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 8, 8),
      child: Row(
        children: [
          // Gradient halo icon
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  AppColors.warning.withValues(alpha: 0.3),
                  AppColors.warning.withValues(alpha: 0.05),
                ],
              ),
            ),
            child: const Center(
              child: Icon(LucideIcons.zap, color: AppColors.warning, size: 22),
            ),
          ),
          const SizedBox(width: 12),
          // Title + subtitle
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Electricity',
                  style: AppTypography.titleLarge.copyWith(
                    color: Colors.white.withValues(alpha: 0.9),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'DESCO Prepaid Meter',
                  style: AppTypography.bodySmall.copyWith(
                    color: Colors.white.withValues(alpha: 0.3),
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
          // Action buttons
          IconButton(
            icon: Icon(LucideIcons.refreshCw,
                size: 20, color: Colors.white.withValues(alpha: 0.5)),
            onPressed: () {
              HapticService.lightTap();
              ref.invalidate(descoBalanceProvider);
              ref.invalidate(descoConsumptionProvider);
            },
          ),
          IconButton(
            icon: Icon(LucideIcons.settings,
                size: 20, color: Colors.white.withValues(alpha: 0.5)),
            onPressed: () => _showMeterSetup(context),
          ),
        ],
      ),
    ).animate(delay: 50.ms).fadeIn().slideY(begin: 0.03);
  }

  // ====== Section label with gradient accent bar ======
  Widget _buildSectionLabel(String label) {
    return Row(
      children: [
        Container(
          width: 3,
          height: 14,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(2),
            gradient: const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [AppColors.warning, AppColors.warning],
            ),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: AppTypography.labelSmall.copyWith(
            color: Colors.white.withValues(alpha: 0.3),
            letterSpacing: 1.5,
            fontSize: 11,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  // ====== Glass card wrapper ======
  Widget _glassCard({
    required Widget child,
    EdgeInsetsGeometry? padding,
    BorderRadius? borderRadius,
    Color? borderColor,
  }) {
    final br = borderRadius ?? BorderRadius.circular(AppSpacing.radiusMd);
    return ClipRRect(
      borderRadius: br,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.03),
            borderRadius: br,
            border: Border.all(
              color: borderColor ?? Colors.white.withValues(alpha: 0.05),
            ),
          ),
          child: child,
        ),
      ),
    );
  }

  /// Simple consumption chart using standard widgets
  Widget _buildSimpleConsumptionChart(
    AsyncValue<List<DescoConsumption>> consumptionAsync,
  ) {
    return consumptionAsync.when(
      data: (consumption) {
        if (consumption.isEmpty) {
          return _glassCard(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              height: 200,
              child: Center(
                child: Text(
                  'No consumption data available',
                  style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.5)),
                ),
              ),
            ),
          );
        }

        final maxUnits = consumption
            .map((c) => c.units)
            .reduce((a, b) => a > b ? a : b);

        return _glassCard(
          padding: const EdgeInsets.all(16),
          child: SizedBox(
            height: 200,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: consumption.map((c) {
                final height =
                    maxUnits > 0 ? (c.units / maxUnits) * 140 : 40.0;
                final month = c.month.split('-').last;
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 2),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          '${c.units.toInt()}',
                          style: AppTypography.bodySmall.copyWith(
                            color: Colors.white.withValues(alpha: 0.3),
                            fontSize: 9,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          height: height,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              colors: [
                                AppColors.warning,
                                AppColors.warning.withValues(alpha: 0.5),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          month,
                          style: AppTypography.bodySmall.copyWith(
                            color: Colors.white.withValues(alpha: 0.3),
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        );
      },
      loading: () => _glassCard(
        child: const SizedBox(
          height: 200,
          child: Center(
            child: CircularProgressIndicator(color: AppColors.warning),
          ),
        ),
      ),
      error: (e, s) => _glassCard(
        child: SizedBox(
          height: 200,
          child: Center(
            child: Text('Error loading data',
                style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.5))),
          ),
        ),
      ),
    );
  }

  /// Simple stat card using glassmorphism
  Widget _buildSimpleStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return _glassCard(
      padding: const EdgeInsets.all(16),
      borderColor: color.withValues(alpha: 0.15),
      child: Column(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  color.withValues(alpha: 0.25),
                  color.withValues(alpha: 0.05),
                ],
              ),
            ),
            child: Center(child: Icon(icon, color: color, size: 20)),
          ),
          const SizedBox(height: 10),
          Text(
            value,
            style: AppTypography.titleLarge.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: AppTypography.bodySmall.copyWith(
              color: Colors.white.withValues(alpha: 0.5),
            ),
          ),
        ],
      ),
    );
  }

  /// Simple setup prompt with cosmic styling
  Widget _buildSimpleSetupPrompt() {
    return _glassCard(
      padding: const EdgeInsets.all(24),
      borderColor: AppColors.warning.withValues(alpha: 0.2),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Glowing zap icon
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  AppColors.warning.withValues(alpha: 0.2),
                  AppColors.warning.withValues(alpha: 0.0),
                ],
              ),
            ),
            child: const Center(
              child:
                  Icon(LucideIcons.zap, size: 36, color: AppColors.warning),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Setup DESCO Meter',
            style: AppTypography.titleLarge.copyWith(
              color: Colors.white.withValues(alpha: 0.9),
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'Enter your account or meter number to view electricity balance',
            style: AppTypography.bodyMedium.copyWith(
              color: Colors.white.withValues(alpha: 0.5),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => _showMeterSetup(context),
              icon: const Icon(LucideIcons.settings),
              label: const Text('Setup Now'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.warning,
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    ).animate(delay: 100.ms).fadeIn().slideY(begin: 0.05);
  }

  Widget _buildBalanceCard(
    AsyncValue<DescoBalance?> balanceAsync,
    AsyncValue<LowBalanceStatus> lowBalanceAsync,
    int? estimatedDays,
  ) {
    return balanceAsync.when(
      data: (balance) {
        if (balance == null) return _buildSetupPrompt();

        final lowStatus = lowBalanceAsync.when(
          data: (s) => s,
          loading: () => LowBalanceStatus.unknown,
          error: (e, s) => LowBalanceStatus.unknown,
        );
        final isLow = lowStatus == LowBalanceStatus.estimatedLow ||
            lowStatus == LowBalanceStatus.confirmedLow;

        // Gradient colors based on status
        Color gradientStart = AppColors.warning;
        Color gradientEnd = AppColors.warning.withValues(alpha: 0.7);
        if (isLow) {
          gradientStart = AppColors.error;
          gradientEnd = AppColors.error.withValues(alpha: 0.7);
        }

        return ClipRRect(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
            child: Container(
              padding: const EdgeInsets.all(AppSpacing.lg),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    gradientStart.withValues(alpha: 0.85),
                    gradientEnd.withValues(alpha: 0.65),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.1),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        isLow ? LucideIcons.alertTriangle : LucideIcons.zap,
                        color: Colors.white,
                        size: 24,
                      ),
                      const Gap(8),
                      Expanded(
                        child: Text(
                          balance.isEstimated
                              ? 'Estimated Balance'
                              : 'Current Balance',
                          style: AppTypography.bodySmall.copyWith(
                            color: Colors.white.withValues(alpha: 0.8),
                          ),
                        ),
                      ),
                      if (balance.isEstimated)
                        AppBadge(
                          text: '~estimated',
                          color: Colors.white.withValues(alpha: 0.2),
                          textColor: Colors.white,
                        ),
                    ],
                  ),
                  const Gap(12),
                  Text(
                    '\u09F3${balance.currentBalance.toStringAsFixed(0)}',
                    style: AppTypography.headlineLarge.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (estimatedDays != null) ...[
                    const Gap(8),
                    Text(
                      '~$estimatedDays days remaining',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.8),
                      ),
                    ),
                  ],
                  if (isLow) ...[
                    const Gap(12),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton.icon(
                        onPressed: () {
                          HapticService.warning();
                          _confirmLowBalance();
                        },
                        icon: const Icon(
                          LucideIcons.alertCircle,
                          size: 18,
                          color: AppColors.error,
                        ),
                        label: const Text('Confirm Balance',
                            style: TextStyle(color: AppColors.error)),
                        style: FilledButton.styleFrom(
                          backgroundColor: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ).animate().fadeIn().scale(begin: const Offset(0.95, 0.95));
      },
      loading: () => Center(
        child: CircularProgressIndicator(
          color: AppColors.warning.withValues(alpha: 0.7),
        ),
      ),
      error: (e, s) => _buildSetupPrompt(),
    );
  }

  /// Display balance when data is available (used by inline AsyncValue.when)
  Widget _buildBalanceDisplay(
    DescoBalance balance,
    AsyncValue<LowBalanceStatus> lowBalanceAsync,
    int? estimatedDays,
  ) {
    final lowStatus = lowBalanceAsync.when(
      data: (s) => s,
      loading: () => LowBalanceStatus.unknown,
      error: (e, s) => LowBalanceStatus.unknown,
    );
    final isLow = lowStatus == LowBalanceStatus.estimatedLow ||
        lowStatus == LowBalanceStatus.confirmedLow;

    Color gradientStart = AppColors.warning;
    Color gradientEnd = AppColors.warning.withValues(alpha: 0.7);
    if (isLow) {
      gradientStart = AppColors.error;
      gradientEnd = AppColors.error.withValues(alpha: 0.7);
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.lg),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                gradientStart.withValues(alpha: 0.85),
                gradientEnd.withValues(alpha: 0.65),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.1),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    isLow ? LucideIcons.alertTriangle : LucideIcons.zap,
                    color: Colors.white,
                    size: 24,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      balance.isEstimated
                          ? 'Estimated Balance'
                          : 'Current Balance',
                      style: AppTypography.bodySmall.copyWith(
                        color: Colors.white.withValues(alpha: 0.8),
                      ),
                    ),
                  ),
                  if (balance.isEstimated)
                    AppBadge(
                      text: '~estimated',
                      color: Colors.white.withValues(alpha: 0.2),
                      textColor: Colors.white,
                    ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                '\u09F3${balance.currentBalance.toStringAsFixed(0)}',
                style: AppTypography.headlineLarge.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (estimatedDays != null) ...[
                const SizedBox(height: 8),
                Text(
                  '~$estimatedDays days remaining',
                  style: AppTypography.bodyMedium.copyWith(
                    color: Colors.white.withValues(alpha: 0.8),
                  ),
                ),
              ],
              if (isLow) ...[
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: () {
                      HapticService.warning();
                      _confirmLowBalance();
                    },
                    icon: const Icon(
                      LucideIcons.alertCircle,
                      size: 18,
                      color: AppColors.error,
                    ),
                    label: const Text('Confirm Balance',
                        style: TextStyle(color: AppColors.error)),
                    style: FilledButton.styleFrom(
                      backgroundColor: Colors.white,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    ).animate().fadeIn().scale(begin: const Offset(0.95, 0.95));
  }

  Widget _buildSetupPrompt() {
    return _glassCard(
      padding: const EdgeInsets.all(16),
      borderColor: AppColors.warning.withValues(alpha: 0.2),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  AppColors.warning.withValues(alpha: 0.2),
                  AppColors.warning.withValues(alpha: 0.0),
                ],
              ),
            ),
            child: const Center(
              child:
                  Icon(LucideIcons.zap, size: 32, color: AppColors.warning),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Setup DESCO Meter',
            style: AppTypography.titleLarge.copyWith(
              color: Colors.white.withValues(alpha: 0.9),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'Enter your account or meter number to view electricity balance',
            style: AppTypography.bodyMedium.copyWith(
              color: Colors.white.withValues(alpha: 0.5),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          AppPrimaryButton(
            text: 'Setup Now',
            icon: LucideIcons.settings,
            onPressed: () => _showMeterSetup(context),
          ),
        ],
      ),
    ).animate().fadeIn();
  }

  Widget _buildUsageChartSection(
    AsyncValue<List<DescoConsumption>> consumptionAsync,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                'Monthly Usage',
                style: AppTypography.titleLarge.copyWith(
                  color: Colors.white.withValues(alpha: 0.9),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SegmentedButton<bool>(
              segments: [
                ButtonSegment(
                  value: false,
                  label: Text(DateTime.now().year.toString()),
                ),
                ButtonSegment(
                  value: true,
                  label: Text((DateTime.now().year - 1).toString()),
                ),
              ],
              selected: {_showPrevYear},
              onSelectionChanged: (s) {
                HapticService.selectionTick();
                setState(() => _showPrevYear = s.first);
              },
              style: const ButtonStyle(visualDensity: VisualDensity.compact),
            ),
          ],
        ),
        const SizedBox(height: 12),
        _glassCard(
          child: SizedBox(
            height: 220,
            child: consumptionAsync.when(
              data: (data) => _buildUsageChart(data),
              loading: () => const Center(
                child: CircularProgressIndicator(color: AppColors.warning),
              ),
              error: (e, s) => Center(
                child: Text(
                  'Failed to load data',
                  style: AppTypography.bodyMedium.copyWith(
                    color: Colors.white.withValues(alpha: 0.5),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    ).animate(delay: 200.ms).fadeIn().slideY(begin: 0.05);
  }

  Widget _buildUsageChart(List<DescoConsumption> data) {
    if (data.isEmpty) {
      return Center(
        child: Text(
          'No consumption data',
          style: TextStyle(color: Colors.white.withValues(alpha: 0.5)),
        ),
      );
    }

    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: data.map((e) => e.units).reduce((a, b) => a > b ? a : b) * 1.2,
        barTouchData: BarTouchData(
          touchTooltipData: BarTouchTooltipData(
            getTooltipColor: (group) => const Color(0xFF0D1520),
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              return BarTooltipItem(
                '${data[group.x].units.toStringAsFixed(0)} kWh\n\u09F3${data[group.x].amount.toStringAsFixed(0)}',
                AppTypography.labelSmall.copyWith(color: Colors.white),
              );
            },
          ),
        ),
        titlesData: FlTitlesData(
          show: true,
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                if (value.toInt() < data.length) {
                  return Padding(
                    padding: const EdgeInsets.all(4),
                    child: Text(
                      data[value.toInt()].month,
                      style: AppTypography.labelSmall.copyWith(
                          color: Colors.white.withValues(alpha: 0.3)),
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),
          leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        borderData: FlBorderData(show: false),
        gridData: const FlGridData(show: false),
        barGroups: data.asMap().entries.map((e) {
          return BarChartGroupData(
            x: e.key,
            barRods: [
              BarChartRodData(
                toY: e.value.units,
                gradient: LinearGradient(
                  colors: [
                    AppColors.warning,
                    AppColors.warning.withValues(alpha: 0.6),
                  ],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                ),
                width: 16,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(4),
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildQuickStats(
      AsyncValue<List<DescoConsumption>> consumptionAsync) {
    return consumptionAsync.when(
      data: (data) {
        if (data.isEmpty) return const SizedBox.shrink();

        final avgUnits =
            data.map((e) => e.units).reduce((a, b) => a + b) / data.length;
        final avgCost =
            data.map((e) => e.amount).reduce((a, b) => a + b) / data.length;
        final lastMonth = data.isNotEmpty ? data.last : null;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: double.infinity,
              child: Text(
                'Quick Stats',
                style: AppTypography.titleLarge.copyWith(
                  color: Colors.white.withValues(alpha: 0.9),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    icon: LucideIcons.activity,
                    label: 'Avg Usage',
                    value: '${avgUnits.toStringAsFixed(0)} kWh',
                    color: AppColors.info,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildStatCard(
                    icon: LucideIcons.wallet,
                    label: 'Avg Cost',
                    value: '\u09F3${avgCost.toStringAsFixed(0)}',
                    color: AppColors.warning,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            if (lastMonth != null)
              _buildStatCard(
                icon: LucideIcons.calendar,
                label: 'Last Month',
                value:
                    '${lastMonth.units.toStringAsFixed(0)} kWh \u2022 \u09F3${lastMonth.amount.toStringAsFixed(0)}',
                color: AppColors.success,
                fullWidth: true,
              ),
          ],
        ).animate(delay: 400.ms).fadeIn().slideY(begin: 0.05);
      },
      loading: () => const SizedBox.shrink(),
      error: (e, s) => const SizedBox.shrink(),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
    bool fullWidth = false,
  }) {
    return _glassCard(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  color.withValues(alpha: 0.2),
                  color.withValues(alpha: 0.05),
                ],
              ),
            ),
            child: Center(child: Icon(icon, color: color, size: 18)),
          ),
          const Gap(12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: AppTypography.labelSmall.copyWith(
                        color: Colors.white.withValues(alpha: 0.3))),
                Text(value,
                    style: AppTypography.titleSmall.copyWith(
                        color: Colors.white.withValues(alpha: 0.9),
                        fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showMeterSetup(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const _MeterSetupSheet(),
    );
  }

  void _confirmLowBalance() {
    // Trigger confirmed balance check & refresh
    ref.invalidate(descoConfirmedBalanceProvider);
    ref.invalidate(descoBalanceProvider);
    showSuccessToast(context, 'Balance check triggered');
  }
}

// ==================== Meter Setup Sheet ====================

class _MeterSetupSheet extends ConsumerStatefulWidget {
  const _MeterSetupSheet();

  @override
  ConsumerState<_MeterSetupSheet> createState() => _MeterSetupSheetState();
}

class _MeterSetupSheetState extends ConsumerState<_MeterSetupSheet> {
  final _meterController = TextEditingController();
  final _accountController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _meterController.dispose();
    _accountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          padding: EdgeInsets.only(
            left: 24,
            right: 24,
            top: 24,
            bottom: MediaQuery.of(context).viewInsets.bottom + 24,
          ),
          decoration: BoxDecoration(
            color: const Color(0xFF0D1520).withValues(alpha: 0.95),
            borderRadius:
                const BorderRadius.vertical(top: Radius.circular(24)),
            border: Border(
              top: BorderSide(
                  color: Colors.white.withValues(alpha: 0.08), width: 1),
              left: BorderSide(
                  color: Colors.white.withValues(alpha: 0.05), width: 1),
              right: BorderSide(
                  color: Colors.white.withValues(alpha: 0.05), width: 1),
            ),
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Gradient handle bar
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(2),
                      gradient: LinearGradient(
                        colors: [
                          AppColors.warning.withValues(alpha: 0.4),
                          AppColors.warning.withValues(alpha: 0.1),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Header with gradient halo
                Row(
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            AppColors.warning.withValues(alpha: 0.3),
                            AppColors.warning.withValues(alpha: 0.05),
                          ],
                        ),
                      ),
                      child: const Center(
                        child: Icon(LucideIcons.zap,
                            color: AppColors.warning, size: 18),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      'Setup DESCO Meter',
                      style: AppTypography.titleLarge.copyWith(
                        color: Colors.white.withValues(alpha: 0.9),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Meter Number
                TextField(
                  controller: _meterController,
                  style:
                      TextStyle(color: Colors.white.withValues(alpha: 0.9)),
                  decoration: InputDecoration(
                    labelText: 'Meter Number',
                    labelStyle: TextStyle(
                        color: Colors.white.withValues(alpha: 0.4)),
                    prefixIcon: Icon(LucideIcons.hash,
                        size: 18,
                        color: Colors.white.withValues(alpha: 0.3)),
                    filled: true,
                    fillColor: Colors.white.withValues(alpha: 0.04),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                          color: Colors.white.withValues(alpha: 0.08)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                          color: AppColors.warning.withValues(alpha: 0.5)),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 12),

                // Account Number
                TextField(
                  controller: _accountController,
                  style:
                      TextStyle(color: Colors.white.withValues(alpha: 0.9)),
                  decoration: InputDecoration(
                    labelText: 'Account Number (optional)',
                    labelStyle: TextStyle(
                        color: Colors.white.withValues(alpha: 0.4)),
                    prefixIcon: Icon(LucideIcons.creditCard,
                        size: 18,
                        color: Colors.white.withValues(alpha: 0.3)),
                    filled: true,
                    fillColor: Colors.white.withValues(alpha: 0.04),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                          color: Colors.white.withValues(alpha: 0.08)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                          color: AppColors.warning.withValues(alpha: 0.5)),
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Submit
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _isLoading ? null : _save,
                    icon: _isLoading
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child:
                                CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(LucideIcons.check),
                    label:
                        Text(_isLoading ? 'Saving...' : 'Save Settings'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.warning,
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _save() async {
    if (_meterController.text.isEmpty) {
      showErrorToast(context, 'Enter meter number');
      return;
    }

    setState(() => _isLoading = true);
    HapticService.buttonPress();

    // In demo mode, just show success and close
    if (DemoMode.isEnabled) {
      await Future.delayed(const Duration(milliseconds: 500));
      if (mounted) {
        Navigator.pop(context);
        showSuccessToast(context, 'Demo: Meter setup saved (simulated)');
      }
      return;
    }

    try {
      // First lookup the meter
      final info = await DescoService.lookupMeter(
        inputMeterNo: _meterController.text.trim(),
        inputAccountNo: _accountController.text.trim().isEmpty
            ? null
            : _accountController.text.trim(),
      );

      if (info == null) {
        if (mounted) {
          setState(() => _isLoading = false);
          showErrorToast(context, 'Meter not found');
        }
        return;
      }

      // Setup the meter
      await DescoService.setupMeter(info);

      // Refresh the balance provider
      ref.invalidate(descoBalanceProvider);
      if (mounted) {
        Navigator.pop(context);
        showSuccessToast(context, 'Meter setup complete');
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        showErrorToast(context, 'Setup failed: ${e.toString()}');
      }
    }
  }
}
