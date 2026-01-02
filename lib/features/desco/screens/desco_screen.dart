import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:gap/gap.dart';
import 'package:mess_manager/core/theme/app_theme.dart';
import 'package:mess_manager/core/services/desco_service.dart';
import 'package:mess_manager/features/desco/providers/desco_provider.dart';

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
        title: Row(
          children: [
            const Icon(LucideIcons.zap, color: AppColors.warning, size: 22),
            const Gap(AppSpacing.sm),
            const Text('Electricity'),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(LucideIcons.refreshCw, size: 20),
            onPressed: () {
              ref.invalidate(descoBalanceProvider);
              ref.invalidate(descoConsumptionProvider);
            },
            tooltip: 'Refresh',
          ),
          IconButton(
            icon: const Icon(LucideIcons.settings, size: 20),
            onPressed: () => _showMeterSetup(context),
            tooltip: 'Meter Settings',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Balance Card
            _buildBalanceCard(balanceAsync, lowBalanceAsync, estimatedDays),
            const Gap(AppSpacing.lg),

            // Monthly Usage Chart
            _buildUsageChartSection(consumptionAsync),
            const Gap(AppSpacing.lg),

            // Quick Stats
            _buildQuickStats(consumptionAsync),
          ],
        ),
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
        if (balance == null) {
          return _buildSetupPrompt();
        }

        final lowStatus = lowBalanceAsync.when(
          data: (s) => s,
          loading: () => LowBalanceStatus.unknown,
          error: (e, s) => LowBalanceStatus.unknown,
        );
        final isLow =
            lowStatus == LowBalanceStatus.estimatedLow ||
            lowStatus == LowBalanceStatus.confirmedLow;

        return Container(
          padding: const EdgeInsets.all(AppSpacing.lg),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: isLow
                  ? [AppColors.error, AppColors.error.withValues(alpha: 0.7)]
                  : [
                      AppColors.warning,
                      AppColors.warning.withValues(alpha: 0.7),
                    ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            boxShadow: [
              BoxShadow(
                color: (isLow ? AppColors.error : AppColors.warning).withValues(
                  alpha: 0.3,
                ),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
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
                  const Gap(AppSpacing.sm),
                  Text(
                    balance.isEstimated
                        ? 'Estimated Balance'
                        : 'Current Balance',
                    style: AppTypography.labelMedium.copyWith(
                      color: Colors.white.withValues(alpha: 0.8),
                    ),
                  ),
                  const Spacer(),
                  if (balance.isEstimated)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        '~estimated',
                        style: AppTypography.labelSmall.copyWith(
                          color: Colors.white,
                        ),
                      ),
                    ),
                ],
              ),
              const Gap(AppSpacing.md),
              Text(
                '৳${balance.currentBalance.toStringAsFixed(0)}',
                style: AppTypography.displayMedium.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
              if (estimatedDays != null) ...[
                const Gap(AppSpacing.sm),
                Text(
                  '~$estimatedDays days remaining',
                  style: AppTypography.bodyMedium.copyWith(
                    color: Colors.white.withValues(alpha: 0.8),
                  ),
                ),
              ],
              if (isLow) ...[
                const Gap(AppSpacing.md),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () => _confirmLowBalance(),
                    icon: const Icon(LucideIcons.alertCircle, size: 18),
                    label: const Text('Confirm Balance'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: AppColors.error,
                    ),
                  ),
                ),
              ],
            ],
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, s) => _buildSetupPrompt(),
    );
  }

  Widget _buildSetupPrompt() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.cardDark,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        border: Border.all(color: AppColors.warning.withValues(alpha: 0.5)),
      ),
      child: Column(
        children: [
          const Icon(LucideIcons.zap, size: 48, color: AppColors.warning),
          const Gap(AppSpacing.md),
          Text(
            'Setup DESCO Meter',
            style: AppTypography.titleMedium.copyWith(
              color: AppColors.textPrimaryDark,
            ),
          ),
          const Gap(AppSpacing.sm),
          Text(
            'Enter your account or meter number to view electricity balance',
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.textSecondaryDark,
            ),
            textAlign: TextAlign.center,
          ),
          const Gap(AppSpacing.md),
          ElevatedButton.icon(
            onPressed: () => _showMeterSetup(context),
            icon: const Icon(LucideIcons.settings, size: 18),
            label: const Text('Setup Now'),
          ),
        ],
      ),
    );
  }

  Widget _buildUsageChartSection(
    AsyncValue<List<DescoConsumption>> consumptionAsync,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Monthly Usage',
              style: AppTypography.headlineSmall.copyWith(
                color: AppColors.textPrimaryDark,
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
              onSelectionChanged: (s) =>
                  setState(() => _showPrevYear = s.first),
              style: ButtonStyle(visualDensity: VisualDensity.compact),
            ),
          ],
        ),
        const Gap(AppSpacing.md),
        Container(
          height: 250,
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: AppColors.cardDark,
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          ),
          child: consumptionAsync.when(
            data: (data) => _buildUsageChart(data),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, s) => Center(
              child: Text(
                'Failed to load data',
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.textSecondaryDark,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildUsageChart(List<DescoConsumption> data) {
    if (data.isEmpty) {
      return Center(
        child: Text(
          'No consumption data',
          style: AppTypography.bodyMedium.copyWith(
            color: AppColors.textSecondaryDark,
          ),
        ),
      );
    }

    final maxY = data.map((e) => e.units).reduce((a, b) => a > b ? a : b);

    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: maxY * 1.2,
        barTouchData: BarTouchData(
          enabled: true,
          touchTooltipData: BarTouchTooltipData(
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              final consumption = data[groupIndex];
              return BarTooltipItem(
                '${consumption.units.toStringAsFixed(0)} units\n৳${consumption.amount.toStringAsFixed(0)}',
                AppTypography.labelSmall.copyWith(color: Colors.white),
              );
            },
          ),
        ),
        titlesData: FlTitlesData(
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 40,
              getTitlesWidget: (value, meta) => Text(
                value.toInt().toString(),
                style: AppTypography.labelSmall.copyWith(
                  color: AppColors.textMutedDark,
                ),
              ),
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                final idx = value.toInt();
                if (idx >= 0 && idx < data.length) {
                  final month = data[idx].month;
                  // Extract month abbreviation
                  final parts = month.split('-');
                  final monthNum = parts.length > 1
                      ? int.tryParse(parts[1]) ?? 0
                      : 0;
                  final monthNames = [
                    '',
                    'Jan',
                    'Feb',
                    'Mar',
                    'Apr',
                    'May',
                    'Jun',
                    'Jul',
                    'Aug',
                    'Sep',
                    'Oct',
                    'Nov',
                    'Dec',
                  ];
                  return Text(
                    monthNum > 0 && monthNum <= 12
                        ? monthNames[monthNum]
                        : month,
                    style: AppTypography.labelSmall.copyWith(
                      color: AppColors.textMutedDark,
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ),
        borderData: FlBorderData(show: false),
        gridData: FlGridData(
          show: true,
          horizontalInterval: maxY / 4,
          getDrawingHorizontalLine: (value) =>
              FlLine(color: AppColors.borderDark, strokeWidth: 1),
          drawVerticalLine: false,
        ),
        barGroups: data.asMap().entries.map((entry) {
          return BarChartGroupData(
            x: entry.key,
            barRods: [
              BarChartRodData(
                toY: entry.value.units,
                color: AppColors.warning,
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

        final totalUnits = data.fold(0.0, (sum, c) => sum + c.units);
        final totalAmount = data.fold(0.0, (sum, c) => sum + c.amount);
        final avgUnits = totalUnits / data.length;
        final avgRate = totalUnits > 0 ? totalAmount / totalUnits : 0.0;

        return Row(
          children: [
            Expanded(
              child: _buildStatCard(
                icon: LucideIcons.activity,
                label: 'Avg/Month',
                value: '${avgUnits.toStringAsFixed(0)} units',
                color: AppColors.primary,
              ),
            ),
            const Gap(AppSpacing.sm),
            Expanded(
              child: _buildStatCard(
                icon: LucideIcons.trendingUp,
                label: 'Total',
                value: '${totalUnits.toStringAsFixed(0)} units',
                color: AppColors.success,
              ),
            ),
            const Gap(AppSpacing.sm),
            Expanded(
              child: _buildStatCard(
                icon: LucideIcons.dollarSign,
                label: 'Avg Rate',
                value: '৳${avgRate.toStringAsFixed(2)}/unit',
                color: AppColors.warning,
              ),
            ),
          ],
        );
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
  }) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.cardDark,
        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 20),
          const Gap(AppSpacing.xs),
          Text(
            label,
            style: AppTypography.labelSmall.copyWith(
              color: AppColors.textMutedDark,
            ),
          ),
          const Gap(2),
          Text(
            value,
            style: AppTypography.labelMedium.copyWith(
              color: AppColors.textPrimaryDark,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Future<void> _confirmLowBalance() async {
    final status = await DescoService.checkLowBalance(confirm: true);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            status == LowBalanceStatus.confirmedLow
                ? '⚠️ Balance is low! Recharge soon.'
                : '✓ Balance is OK',
          ),
          backgroundColor: status == LowBalanceStatus.confirmedLow
              ? AppColors.error
              : AppColors.success,
        ),
      );
      ref.invalidate(descoBalanceProvider);
    }
  }

  void _showMeterSetup(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const _MeterSetupSheet(),
    );
  }
}

/// Meter Setup Bottom Sheet
class _MeterSetupSheet extends ConsumerStatefulWidget {
  const _MeterSetupSheet();

  @override
  ConsumerState<_MeterSetupSheet> createState() => _MeterSetupSheetState();
}

class _MeterSetupSheetState extends ConsumerState<_MeterSetupSheet> {
  final _controller = TextEditingController();
  bool _isLoading = false;
  DescoCustomerInfo? _foundInfo;
  String? _error;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.surfaceDark,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(AppSpacing.radiusLg),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
          const Gap(AppSpacing.lg),
          Text(
            'Setup DESCO Meter',
            style: AppTypography.headlineMedium.copyWith(
              color: AppColors.textPrimaryDark,
            ),
          ),
          const Gap(AppSpacing.md),
          Text(
            'Enter your account number (8 digits) or meter number (12 digits)',
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.textSecondaryDark,
            ),
          ),
          const Gap(AppSpacing.lg),
          TextField(
            controller: _controller,
            keyboardType: TextInputType.number,
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.textPrimaryDark,
            ),
            decoration: InputDecoration(
              hintText: 'Account or Meter Number',
              prefixIcon: const Icon(LucideIcons.hash, size: 18),
              suffixIcon: _isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : IconButton(
                      icon: const Icon(LucideIcons.search, size: 18),
                      onPressed: _lookup,
                    ),
            ),
            onSubmitted: (_) => _lookup(),
          ),
          if (_error != null) ...[
            const Gap(AppSpacing.sm),
            Text(
              _error!,
              style: AppTypography.bodySmall.copyWith(color: AppColors.error),
            ),
          ],
          if (_foundInfo != null) ...[
            const Gap(AppSpacing.lg),
            Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: AppColors.success.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                border: Border.all(
                  color: AppColors.success.withValues(alpha: 0.5),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(
                        LucideIcons.checkCircle,
                        color: AppColors.success,
                        size: 20,
                      ),
                      const Gap(AppSpacing.sm),
                      Text(
                        'Meter Found',
                        style: AppTypography.titleSmall.copyWith(
                          color: AppColors.success,
                        ),
                      ),
                    ],
                  ),
                  const Gap(AppSpacing.sm),
                  _infoRow('Account', _foundInfo!.accountNo ?? '-'),
                  _infoRow('Meter', _foundInfo!.meterNo ?? '-'),
                  _infoRow('Name', _foundInfo!.customerName ?? '-'),
                  _infoRow('Area', _foundInfo!.area ?? '-'),
                ],
              ),
            ),
            const Gap(AppSpacing.lg),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _save,
                icon: const Icon(LucideIcons.check, size: 18),
                label: const Text('Use This Meter'),
              ),
            ),
          ],
          const Gap(AppSpacing.lg),
        ],
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Row(
        children: [
          SizedBox(
            width: 60,
            child: Text(
              label,
              style: AppTypography.labelSmall.copyWith(
                color: AppColors.textMutedDark,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.textPrimaryDark,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _lookup() async {
    final input = _controller.text.trim();
    if (input.isEmpty) return;

    setState(() {
      _isLoading = true;
      _error = null;
      _foundInfo = null;
    });

    // Determine input type by length
    String? accountNo;
    String? meterNo;

    if (input.length == 8) {
      accountNo = input;
    } else if (input.length == 12) {
      meterNo = input;
    } else {
      setState(() {
        _isLoading = false;
        _error = 'Enter 8-digit account or 12-digit meter number';
      });
      return;
    }

    final info = await DescoService.lookupMeter(
      inputAccountNo: accountNo,
      inputMeterNo: meterNo,
    );

    setState(() {
      _isLoading = false;
      if (info != null && info.isValid) {
        _foundInfo = info;
      } else {
        _error = 'Meter not found. Check the number.';
      }
    });
  }

  Future<void> _save() async {
    if (_foundInfo == null) return;

    final success = await DescoService.setupMeter(_foundInfo!);
    if (success && mounted) {
      ref.invalidate(descoBalanceProvider);
      ref.invalidate(descoConsumptionProvider);
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('✓ Meter setup complete'),
          backgroundColor: AppColors.success,
        ),
      );
    }
  }
}
