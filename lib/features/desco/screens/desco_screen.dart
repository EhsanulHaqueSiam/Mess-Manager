import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:getwidget/getwidget.dart';

import 'package:mess_manager/core/theme/app_theme.dart';
import 'package:mess_manager/core/services/desco_service.dart';
import 'package:mess_manager/core/services/haptic_service.dart';
import 'package:mess_manager/core/widgets/gf_components.dart';
import 'package:mess_manager/features/desco/providers/desco_provider.dart';

/// DESCO Screen - Uses GetWidget + VelocityX + flutter_animate + fl_chart
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

    return Scaffold(
      appBar: AppBar(
        title: HStack([
          const Icon(LucideIcons.zap, color: AppColors.warning, size: 22),
          8.widthBox,
          'Electricity'.text.make(),
        ]),
        actions: [
          GFIconButton(
            icon: const Icon(LucideIcons.refreshCw, size: 20),
            type: GFButtonType.transparent,
            onPressed: () {
              HapticService.lightTap();
              ref.invalidate(descoBalanceProvider);
              ref.invalidate(descoConsumptionProvider);
            },
          ),
          GFIconButton(
            icon: const Icon(LucideIcons.settings, size: 20),
            type: GFButtonType.transparent,
            onPressed: () => _showMeterSetup(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: VStack(crossAlignment: CrossAxisAlignment.start, [
          // Balance Card
          _buildBalanceCard(balanceAsync, lowBalanceAsync, estimatedDays),
          16.heightBox,

          // Monthly Usage Chart
          _buildUsageChartSection(consumptionAsync),
          16.heightBox,

          // Quick Stats
          _buildQuickStats(consumptionAsync),
        ]),
      ),
    );
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
        final isLow =
            lowStatus == LowBalanceStatus.estimatedLow ||
            lowStatus == LowBalanceStatus.confirmedLow;

        return GFCard(
          margin: EdgeInsets.zero,
          padding: const EdgeInsets.all(AppSpacing.lg),
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          gradient: LinearGradient(
            colors: isLow
                ? [AppColors.error, AppColors.error.withValues(alpha: 0.7)]
                : [AppColors.warning, AppColors.warning.withValues(alpha: 0.7)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          content: VStack(crossAlignment: CrossAxisAlignment.start, [
            HStack([
              Icon(
                isLow ? LucideIcons.alertTriangle : LucideIcons.zap,
                color: Colors.white,
                size: 24,
              ),
              8.widthBox,
              (balance.isEstimated ? 'Estimated Balance' : 'Current Balance')
                  .text
                  .sm
                  .color(Colors.white.withValues(alpha: 0.8))
                  .make()
                  .expand(),
              if (balance.isEstimated)
                GFBadge(
                  text: '~estimated',
                  color: Colors.white.withValues(alpha: 0.2),
                  textColor: Colors.white,
                  size: GFSize.SMALL,
                ),
            ]),
            12.heightBox,
            '৳${balance.currentBalance.toStringAsFixed(0)}'.text.xl4.white.bold
                .make(),
            if (estimatedDays != null) ...[
              8.heightBox,
              '~$estimatedDays days remaining'.text
                  .color(Colors.white.withValues(alpha: 0.8))
                  .make(),
            ],
            if (isLow) ...[
              12.heightBox,
              GFButton(
                onPressed: () {
                  HapticService.warning();
                  _confirmLowBalance();
                },
                text: 'Confirm Balance',
                icon: const Icon(
                  LucideIcons.alertCircle,
                  size: 18,
                  color: AppColors.error,
                ),
                color: Colors.white,
                textColor: AppColors.error,
                fullWidthButton: true,
              ),
            ],
          ]),
        ).animate().fadeIn().scale(begin: const Offset(0.95, 0.95));
      },
      loading: () => const GFLoader(type: GFLoaderType.circle),
      error: (e, s) => _buildSetupPrompt(),
    );
  }

  Widget _buildSetupPrompt() {
    return GFAppCard(
      borderColor: AppColors.warning.withValues(alpha: 0.5),
      child: VStack([
        const Icon(LucideIcons.zap, size: 48, color: AppColors.warning),
        12.heightBox,
        'Setup DESCO Meter'.text.lg
            .color(AppColors.textPrimaryDark)
            .center
            .make(),
        8.heightBox,
        'Enter your account or meter number to view electricity balance'.text.sm
            .color(AppColors.textSecondaryDark)
            .center
            .make(),
        16.heightBox,
        GFPrimaryButton(
          text: 'Setup Now',
          icon: LucideIcons.settings,
          onPressed: () => _showMeterSetup(context),
        ),
      ]).p16(),
    ).animate().fadeIn();
  }

  Widget _buildUsageChartSection(
    AsyncValue<List<DescoConsumption>> consumptionAsync,
  ) {
    return VStack(crossAlignment: CrossAxisAlignment.start, [
      HStack([
        'Monthly Usage'.text.xl.bold
            .color(AppColors.textPrimaryDark)
            .make()
            .expand(),
        SegmentedButton<bool>(
          segments: [
            ButtonSegment(
              value: false,
              label: DateTime.now().year.toString().text.make(),
            ),
            ButtonSegment(
              value: true,
              label: (DateTime.now().year - 1).toString().text.make(),
            ),
          ],
          selected: {_showPrevYear},
          onSelectionChanged: (s) {
            HapticService.selectionTick();
            setState(() => _showPrevYear = s.first);
          },
          style: const ButtonStyle(visualDensity: VisualDensity.compact),
        ),
      ]),
      12.heightBox,
      GFAppCard(
        child: SizedBox(
          height: 220,
          child: consumptionAsync.when(
            data: (data) => _buildUsageChart(data),
            loading: () => const GFLoader(type: GFLoaderType.circle).centered(),
            error: (e, s) => 'Failed to load data'.text
                .color(AppColors.textSecondaryDark)
                .makeCentered(),
          ),
        ),
      ),
    ]).animate(delay: 200.ms).fadeIn().slideY(begin: 0.05);
  }

  Widget _buildUsageChart(List<DescoConsumption> data) {
    if (data.isEmpty) {
      return 'No consumption data'.text
          .color(AppColors.textSecondaryDark)
          .makeCentered();
    }

    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: data.map((e) => e.units).reduce((a, b) => a > b ? a : b) * 1.2,
        barTouchData: BarTouchData(
          touchTooltipData: BarTouchTooltipData(
            getTooltipColor: (group) => AppColors.surfaceDark,
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              return BarTooltipItem(
                '${data[group.x].units.toStringAsFixed(0)} kWh\n৳${data[group.x].amount.toStringAsFixed(0)}',
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
                  return data[value.toInt()].month.text.xs
                      .color(AppColors.textMutedDark)
                      .make()
                      .p4();
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

  Widget _buildQuickStats(AsyncValue<List<DescoConsumption>> consumptionAsync) {
    return consumptionAsync.when(
      data: (data) {
        if (data.isEmpty) return const SizedBox.shrink();

        final avgUnits =
            data.map((e) => e.units).reduce((a, b) => a + b) / data.length;
        final avgCost =
            data.map((e) => e.amount).reduce((a, b) => a + b) / data.length;
        final lastMonth = data.isNotEmpty ? data.last : null;

        return VStack([
          'Quick Stats'.text.xl.bold
              .color(AppColors.textPrimaryDark)
              .make()
              .wFull(context),
          12.heightBox,
          HStack([
            _buildStatCard(
              icon: LucideIcons.activity,
              label: 'Avg Usage',
              value: '${avgUnits.toStringAsFixed(0)} kWh',
              color: AppColors.info,
            ).expand(),
            8.widthBox,
            _buildStatCard(
              icon: LucideIcons.wallet,
              label: 'Avg Cost',
              value: '৳${avgCost.toStringAsFixed(0)}',
              color: AppColors.warning,
            ).expand(),
          ]),
          8.heightBox,
          if (lastMonth != null)
            _buildStatCard(
              icon: LucideIcons.calendar,
              label: 'Last Month',
              value:
                  '${lastMonth.units.toStringAsFixed(0)} kWh • ৳${lastMonth.amount.toStringAsFixed(0)}',
              color: AppColors.success,
              fullWidth: true,
            ),
        ]).animate(delay: 400.ms).fadeIn().slideY(begin: 0.05);
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
    return GFAppCard(
      child: HStack([
        GFAvatar(
          size: 36,
          backgroundColor: color.withValues(alpha: 0.15),
          child: Icon(icon, color: color, size: 18),
        ),
        12.widthBox,
        VStack(crossAlignment: CrossAxisAlignment.start, [
          label.text.xs.color(AppColors.textMutedDark).make(),
          value.text.color(AppColors.textPrimaryDark).bold.make(),
        ]).expand(),
      ]),
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
    return Container(
      padding: EdgeInsets.only(
        left: AppSpacing.lg,
        right: AppSpacing.lg,
        top: AppSpacing.lg,
        bottom: MediaQuery.of(context).viewInsets.bottom + AppSpacing.lg,
      ),
      decoration: const BoxDecoration(
        color: AppColors.surfaceDark,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppSpacing.radiusLg),
        ),
      ),
      child: SingleChildScrollView(
        child: VStack(crossAlignment: CrossAxisAlignment.start, [
          // Handle
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
          16.heightBox,

          // Header
          HStack([
            const Icon(LucideIcons.zap, color: AppColors.warning),
            8.widthBox,
            'Setup DESCO Meter'.text.xl2
                .color(AppColors.textPrimaryDark)
                .make(),
          ]),
          16.heightBox,

          // Meter Number
          TextField(
            controller: _meterController,
            decoration: const InputDecoration(
              labelText: 'Meter Number',
              prefixIcon: Icon(LucideIcons.hash, size: 18),
            ),
            keyboardType: TextInputType.number,
          ),
          12.heightBox,

          // Account Number
          TextField(
            controller: _accountController,
            decoration: const InputDecoration(
              labelText: 'Account Number (optional)',
              prefixIcon: Icon(LucideIcons.creditCard, size: 18),
            ),
          ),
          24.heightBox,

          // Submit
          GFPrimaryButton(
            text: 'Save Settings',
            icon: LucideIcons.check,
            isLoading: _isLoading,
            onPressed: _save,
          ),
        ]),
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
        showErrorToast(context, 'Setup failed');
      }
    }
  }
}
