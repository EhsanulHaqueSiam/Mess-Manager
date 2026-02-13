import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mess_manager/core/services/desco_service.dart';
import 'package:mess_manager/core/providers/demo_mode_provider.dart';

/// Check if meter is configured (for demo or real)
final descoMeterConfiguredProvider = Provider<bool>((ref) {
  return DescoService.isMeterConfigured;
});

/// DESCO Balance Provider with auto-refresh and demo mode support
final descoBalanceProvider = FutureProvider.autoDispose<DescoBalance?>((
  ref,
) async {
  final isDemoMode = DemoMode.isEnabled;

  if (isDemoMode && DescoService.isMeterConfigured) {
    // Return mock data in demo mode when meter is configured
    return DescoBalance(
      currentBalance: 1250.50,
      lastRechargeAmount: 500,
      lastRechargeDate: DateTime.now().subtract(const Duration(days: 5)),
      lastUpdated: DateTime.now(),
      meterNo: DescoService.meterNo,
      accountNo: DescoService.accountNo,
      customerName: 'Demo User',
      isEstimated: false,
    );
  }

  return await DescoService.getBalance();
});

/// Force refresh trigger (simple counter)
final descoRefreshTriggerProvider = Provider<int>((ref) => 0);

/// Refreshable balance provider
final descoBalanceRefreshableProvider = FutureProvider<DescoBalance?>((
  ref,
) async {
  return await DescoService.getBalance(forceRefresh: true);
});

/// Current year consumption with demo mode support
final descoConsumptionProvider =
    FutureProvider.autoDispose<List<DescoConsumption>>((ref) async {
      final isDemoMode = DemoMode.isEnabled;
      final year = DateTime.now().year;

      if (isDemoMode && DescoService.isMeterConfigured) {
        // Return mock consumption data in demo mode
        return _generateMockConsumption(year);
      }

      return await DescoService.getMonthlyConsumption(year: year);
    });

/// Previous year consumption
final descoPrevYearConsumptionProvider =
    FutureProvider.autoDispose<List<DescoConsumption>>((ref) async {
      final isDemoMode = DemoMode.isEnabled;
      final year = DateTime.now().year - 1;

      if (isDemoMode && DescoService.isMeterConfigured) {
        return _generateMockConsumption(year);
      }

      return await DescoService.getMonthlyConsumption(year: year);
    });

/// Generate mock consumption data for demo mode
List<DescoConsumption> _generateMockConsumption(int year) {
  final now = DateTime.now();
  final months = <DescoConsumption>[];

  for (int m = 1; m <= 12; m++) {
    // Only generate data for past months in current year
    if (year == now.year && m > now.month) break;

    // Random-ish but consistent consumption based on month
    final baseUnits = 150 + (m * 10) + ((m % 3) * 20);
    final units = baseUnits.toDouble();
    final rate = 8.5; // Approx BDT per unit

    months.add(
      DescoConsumption(
        month: '$year-${m.toString().padLeft(2, '0')}',
        units: units,
        amount: units * rate,
        perUnitRate: rate,
      ),
    );
  }

  return months;
}

/// Current year recharge history
final descoRechargeProvider = FutureProvider.autoDispose<List<DescoRecharge>>((
  ref,
) async {
  final isDemoMode = DemoMode.isEnabled;
  final now = DateTime.now();

  if (isDemoMode && DescoService.isMeterConfigured) {
    // Return mock recharge history in demo mode
    return [
      DescoRecharge(
        date: now.subtract(const Duration(days: 5)),
        amount: 500,
        transactionId: 'DEMO001',
        source: 'bKash',
      ),
      DescoRecharge(
        date: now.subtract(const Duration(days: 35)),
        amount: 1000,
        transactionId: 'DEMO002',
        source: 'Nagad',
      ),
      DescoRecharge(
        date: now.subtract(const Duration(days: 65)),
        amount: 800,
        transactionId: 'DEMO003',
        source: 'Bank',
      ),
    ];
  }

  return await DescoService.getRechargeHistory(
    from: DateTime(now.year, 1, 1),
    to: DateTime(now.year, 12, 31),
  );
});

/// Customer location
final descoLocationProvider = FutureProvider.autoDispose<DescoLocation?>((
  ref,
) async {
  final isDemoMode = DemoMode.isEnabled;

  if (isDemoMode && DescoService.isMeterConfigured) {
    return DescoLocation(
      address: 'Demo Address, Dhaka',
      area: 'Demo Area',
      zone: 'Demo Zone',
      latitude: 23.8103,
      longitude: 90.4125,
    );
  }

  return await DescoService.getLocation();
});

/// Low balance warning (estimated, not API call)
final descoLowBalanceProvider = FutureProvider<LowBalanceStatus>((ref) async {
  final isDemoMode = DemoMode.isEnabled;

  if (isDemoMode && DescoService.isMeterConfigured) {
    return LowBalanceStatus.estimatedOk;
  }

  return await DescoService.checkLowBalance(threshold: 200);
});

/// Confirmed low balance (makes actual API call)
final descoConfirmedBalanceProvider = FutureProvider<LowBalanceStatus>((
  ref,
) async {
  return await DescoService.checkLowBalance(threshold: 200, confirm: true);
});

/// Estimated days until balance runs out
final descoEstimatedDaysProvider = Provider<int?>((ref) {
  final isDemoMode = DemoMode.isEnabled;

  if (isDemoMode && DescoService.isMeterConfigured) {
    return 45; // Mock estimated days
  }

  return DescoService.getEstimatedDaysRemaining();
});

/// Total recharge this year (computed from async data)
final totalRechargeThisYearProvider = Provider<double>((ref) {
  final rechargesAsync = ref.watch(descoRechargeProvider);
  return rechargesAsync.when(
    data: (list) => list.fold(0.0, (sum, r) => sum + r.amount),
    loading: () => 0.0,
    error: (e, s) => 0.0,
  );
});

/// Average monthly consumption (computed from async data)
final avgMonthlyConsumptionProvider = Provider<double>((ref) {
  final consumptionAsync = ref.watch(descoConsumptionProvider);
  return consumptionAsync.when(
    data: (list) => list.isEmpty
        ? 0.0
        : list.fold(0.0, (sum, c) => sum + c.units) / list.length,
    loading: () => 0.0,
    error: (e, s) => 0.0,
  );
});
