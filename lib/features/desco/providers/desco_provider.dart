import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mess_manager/core/services/desco_service.dart';

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

/// Customer location
final descoLocationProvider = FutureProvider.autoDispose<DescoLocation?>((
  ref,
) async {
  return await DescoService.getLocation();
});

/// Low balance warning (estimated, not API call)
final descoLowBalanceProvider = FutureProvider<LowBalanceStatus>((ref) async {
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
