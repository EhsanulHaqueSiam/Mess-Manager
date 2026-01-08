import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mess_manager/core/database/isar_service.dart';
import 'package:mess_manager/core/models/settlement.dart';
import 'package:mess_manager/features/balance/providers/balance_provider.dart';
import 'package:mess_manager/core/services/export_service.dart';
import 'package:mess_manager/core/providers/members_provider.dart';

/// Month lock state
class MonthLockState {
  final Map<String, bool> lockedMonths; // Key: "YYYY-MM"
  final Map<String, double> openingBalances; // Key: "memberId_YYYY-MM"

  const MonthLockState({
    this.lockedMonths = const {},
    this.openingBalances = const {},
  });

  MonthLockState copyWith({
    Map<String, bool>? lockedMonths,
    Map<String, double>? openingBalances,
  }) {
    return MonthLockState(
      lockedMonths: lockedMonths ?? this.lockedMonths,
      openingBalances: openingBalances ?? this.openingBalances,
    );
  }

  String _monthKey(int year, int month) =>
      '$year-${month.toString().padLeft(2, '0')}';
  String _balanceKey(String memberId, int year, int month) =>
      '${memberId}_${_monthKey(year, month)}';

  bool isLocked(int year, int month) =>
      lockedMonths[_monthKey(year, month)] ?? false;

  double getOpeningBalance(String memberId, int year, int month) {
    return openingBalances[_balanceKey(memberId, year, month)] ?? 0.0;
  }
}

/// Provider for month lock state
final monthLockProvider = NotifierProvider<MonthLockNotifier, MonthLockState>(
  MonthLockNotifier.new,
);

class MonthLockNotifier extends Notifier<MonthLockState> {
  static const _lockedMonthsKey = 'locked_months';
  static const _openingBalancesKey = 'opening_balances';

  @override
  MonthLockState build() {
    // Load from Isar settings
    final lockedData = IsarService.getSetting(_lockedMonthsKey);
    final balanceData = IsarService.getSetting(_openingBalancesKey);

    final lockedMonths = <String, bool>{};
    final openingBalances = <String, double>{};

    // Parse locked months (format: "2026-01,2026-02,...")
    if (lockedData != null && lockedData.isNotEmpty) {
      for (final m in lockedData.split(',')) {
        if (m.isNotEmpty) lockedMonths[m] = true;
      }
    }

    // Parse opening balances (format: "memberId_2026-01:500.0;memberId_2026-02:-200.0;...")
    if (balanceData != null && balanceData.isNotEmpty) {
      for (final entry in balanceData.split(';')) {
        final parts = entry.split(':');
        if (parts.length == 2) {
          openingBalances[parts[0]] = double.tryParse(parts[1]) ?? 0.0;
        }
      }
    }

    return MonthLockState(
      lockedMonths: lockedMonths,
      openingBalances: openingBalances,
    );
  }

  void _save() {
    // Save locked months
    final lockedStr = state.lockedMonths.keys.join(',');
    IsarService.saveSetting(_lockedMonthsKey, lockedStr);

    // Save opening balances
    final balanceStr = state.openingBalances.entries
        .map((e) => '${e.key}:${e.value}')
        .join(';');
    IsarService.saveSetting(_openingBalancesKey, balanceStr);
  }

  String _monthKey(int year, int month) =>
      '$year-${month.toString().padLeft(2, '0')}';

  /// Check if a month is locked
  bool isMonthLocked(int year, int month) {
    return state.lockedMonths[_monthKey(year, month)] ?? false;
  }

  /// Close and lock a month
  /// Returns the generated PDF bytes if successful
  Future<ClosedMonthResult> closeMonth({
    required int year,
    required int month,
    required BalanceSummary summary,
    required List<MemberBalance> balances,
    required List<SettlementItem> payments,
  }) async {
    final monthKey = _monthKey(year, month);

    // Already locked?
    if (state.lockedMonths[monthKey] == true) {
      return ClosedMonthResult(
        success: false,
        error: 'Month is already locked',
      );
    }

    // Calculate carry-forward balances for next month
    final nextYear = month == 12 ? year + 1 : year;
    final nextMonth = month == 12 ? 1 : month + 1;

    final newOpeningBalances = Map<String, double>.from(state.openingBalances);
    for (final balance in balances) {
      final key = '${balance.memberId}_${_monthKey(nextYear, nextMonth)}';
      newOpeningBalances[key] = balance.balance; // Carry forward the balance
    }

    // Mark month as locked
    final newLockedMonths = Map<String, bool>.from(state.lockedMonths);
    newLockedMonths[monthKey] = true;

    state = state.copyWith(
      lockedMonths: newLockedMonths,
      openingBalances: newOpeningBalances,
    );
    _save();

    // Generate final PDF
    final members = ref.read(membersProvider);
    final pdfBytes = await ExportService.generateSettlementPdf(
      year: year,
      month: month,
      totalBazar: summary.totalBazar,
      mealRate: summary.mealRate,
      balances: balances
          .map(
            (b) => MemberBalanceSummary(
              memberId: b.memberId,
              totalBazar: b.totalBazar,
              mealCost: b.mealCost,
              monthlyShare: b.fixedExpenseShare,
              balance: b.balance,
            ),
          )
          .toList(),
      payments: payments,
      members: members,
      messName: 'Area51 Mess',
    );

    return ClosedMonthResult(
      success: true,
      pdfBytes: pdfBytes,
      carryForwardBalances: Map.fromEntries(
        balances.map((b) => MapEntry(b.memberId, b.balance)),
      ),
    );
  }

  /// Unlock a month (Super Admin only)
  void unlockMonth(int year, int month) {
    final monthKey = _monthKey(year, month);
    final newLockedMonths = Map<String, bool>.from(state.lockedMonths);
    newLockedMonths.remove(monthKey);
    state = state.copyWith(lockedMonths: newLockedMonths);
    _save();
  }

  /// Get opening balance for a member in a specific month
  double getOpeningBalance(String memberId, int year, int month) {
    final key = '${memberId}_${_monthKey(year, month)}';
    return state.openingBalances[key] ?? 0.0;
  }
}

/// Result of closing a month
class ClosedMonthResult {
  final bool success;
  final String? error;
  final List<int>? pdfBytes;
  final Map<String, double>? carryForwardBalances;

  ClosedMonthResult({
    required this.success,
    this.error,
    this.pdfBytes,
    this.carryForwardBalances,
  });
}

/// Provider to check if current month is locked
final isCurrentMonthLockedProvider = Provider<bool>((ref) {
  final now = DateTime.now();
  final state = ref.watch(monthLockProvider);
  return state.isLocked(now.year, now.month);
});

/// Provider for current month opening balances
final currentMonthOpeningBalancesProvider = Provider<Map<String, double>>((
  ref,
) {
  final now = DateTime.now();
  final state = ref.watch(monthLockProvider);
  final members = ref.watch(membersProvider);

  return Map.fromEntries(
    members.map(
      (m) => MapEntry(m.id, state.getOpeningBalance(m.id, now.year, now.month)),
    ),
  );
});
