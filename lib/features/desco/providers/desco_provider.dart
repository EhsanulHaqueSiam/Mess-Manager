import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mess_manager/core/database/isar_service.dart';
import 'package:mess_manager/core/services/desco_service.dart';
import 'package:mess_manager/core/services/local_notification_service.dart';

/// Check if meter is configured
final descoMeterConfiguredProvider = Provider<bool>((ref) {
  return DescoService.isMeterConfigured;
});

/// DESCO Balance Provider with auto-refresh
final descoBalanceProvider = FutureProvider.autoDispose<DescoBalance?>((
  ref,
) async {
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

/// Current year consumption
final descoConsumptionProvider =
    FutureProvider.autoDispose<List<DescoConsumption>>((ref) async {
      final year = DateTime.now().year;
      return await DescoService.getMonthlyConsumption(year: year);
    });

/// Previous year consumption
final descoPrevYearConsumptionProvider =
    FutureProvider.autoDispose<List<DescoConsumption>>((ref) async {
      final year = DateTime.now().year - 1;
      return await DescoService.getMonthlyConsumption(year: year);
    });

/// Current year recharge history
final descoRechargeProvider = FutureProvider.autoDispose<List<DescoRecharge>>((
  ref,
) async {
  final now = DateTime.now();
  return await DescoService.getRechargeHistory(
    from: DateTime(now.year, 1, 1),
    to: DateTime(now.year, 12, 31),
  );
});

/// Daily consumption (last 30 days — for charts)
final descoDailyConsumptionProvider =
    FutureProvider.autoDispose<List<DescoDailyConsumption>>((ref) async {
      final now = DateTime.now();
      return await DescoService.getDailyConsumption(
        from: now.subtract(const Duration(days: 30)),
        to: now,
      );
    });

/// Customer location
final descoLocationProvider = FutureProvider.autoDispose<DescoLocation?>((
  ref,
) async {
  return await DescoService.getLocation();
});

/// Configurable low balance threshold (default 200 BDT)
final descoLowBalanceThresholdProvider = Provider<double>((ref) {
  return IsarService.getSetting<double>('desco_low_threshold') ?? 200.0;
});

/// Low balance warning — triggers push notification on first detection
final descoLowBalanceProvider = FutureProvider<LowBalanceStatus>((ref) async {
  final threshold = ref.watch(descoLowBalanceThresholdProvider);
  final status = await DescoService.checkLowBalance(threshold: threshold);

  // Trigger local push notification if low
  if (status == LowBalanceStatus.estimatedLow ||
      status == LowBalanceStatus.confirmedLow) {
    final lastAlertKey = 'desco_last_low_alert';
    final lastAlert = IsarService.getSetting<String>(lastAlertKey);
    final today = DateTime.now().toIso8601String().substring(0, 10);

    // Only alert once per day to avoid spam
    if (lastAlert != today) {
      final balance = await DescoService.getBalance();
      if (balance != null) {
        await LocalNotificationService.showLowDescoAlert(
          balance.currentBalance,
        );
        IsarService.saveSetting(lastAlertKey, today);
      }
    }
  }

  return status;
});

/// Confirmed low balance (makes actual API call)
final descoConfirmedBalanceProvider = FutureProvider<LowBalanceStatus>((
  ref,
) async {
  return await DescoService.checkLowBalance(threshold: 200, confirm: true);
});

/// Estimated days until balance runs out
final descoEstimatedDaysProvider = Provider<int?>((ref) {
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

/// Last recharge info (from recharge history)
final lastRechargeProvider = Provider<DescoRecharge?>((ref) {
  final rechargesAsync = ref.watch(descoRechargeProvider);
  return rechargesAsync.when(
    data: (list) {
      if (list.isEmpty) return null;
      final sorted = [...list]..sort((a, b) => b.date.compareTo(a.date));
      return sorted.first;
    },
    loading: () => null,
    error: (e, s) => null,
  );
});

/// Max load (units) for a specific month
double _maxLoadForMonth(List<DescoConsumption> data, int month) {
  final match = data.where((c) {
    final m = int.tryParse(c.month.split('-').last) ?? 0;
    return m == month;
  });
  if (match.isEmpty) return 0;
  return match.first.units;
}

/// Max load last month (kWh)
final maxLoadLastMonthProvider = Provider<double>((ref) {
  final consumptionAsync = ref.watch(descoConsumptionProvider);
  return consumptionAsync.when(
    data: (list) {
      final now = DateTime.now();
      final lastMonth = now.month == 1 ? 12 : now.month - 1;
      return _maxLoadForMonth(list, lastMonth);
    },
    loading: () => 0.0,
    error: (e, s) => 0.0,
  );
});

/// Max load last year (highest single month in previous year)
final maxLoadLastYearProvider = Provider<double>((ref) {
  final consumptionAsync = ref.watch(descoPrevYearConsumptionProvider);
  return consumptionAsync.when(
    data: (list) {
      if (list.isEmpty) return 0.0;
      return list.map((c) => c.units).reduce((a, b) => a > b ? a : b);
    },
    loading: () => 0.0,
    error: (e, s) => 0.0,
  );
});

/// Used this month (kWh)
final usedThisMonthUnitsProvider = Provider<double>((ref) {
  final consumptionAsync = ref.watch(descoConsumptionProvider);
  return consumptionAsync.when(
    data: (list) {
      final now = DateTime.now();
      return _maxLoadForMonth(list, now.month);
    },
    loading: () => 0.0,
    error: (e, s) => 0.0,
  );
});

/// Used this month (BDT) — uses balance API's currentMonthConsumption for live data
final usedThisMonthBdtProvider = Provider<double>((ref) {
  final balanceAsync = ref.watch(descoBalanceProvider);
  return balanceAsync.when(
    data: (balance) => balance?.currentMonthConsumption ?? 0.0,
    loading: () => 0.0,
    error: (e, s) => 0.0,
  );
});

/// Recharged this month (BDT)
final rechargedThisMonthProvider = Provider<double>((ref) {
  final rechargesAsync = ref.watch(descoRechargeProvider);
  return rechargesAsync.when(
    data: (list) {
      final now = DateTime.now();
      return list
          .where((r) => r.date.month == now.month && r.date.year == now.year)
          .fold(0.0, (sum, r) => sum + r.amount);
    },
    loading: () => 0.0,
    error: (e, s) => 0.0,
  );
});
