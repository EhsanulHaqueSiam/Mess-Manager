import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mess_manager/core/models/settlement.dart';

import 'package:mess_manager/core/database/isar_service.dart';
import 'package:mess_manager/core/providers/members_provider.dart';
import 'package:mess_manager/features/bazar/providers/bazar_provider.dart';
import 'package:mess_manager/features/meals/providers/meals_provider.dart';
import 'package:mess_manager/features/vacation/providers/fixed_expenses_provider.dart';
import 'package:mess_manager/features/settlement/providers/month_lock_provider.dart';

/// All settlements history
final settlementsProvider =
    NotifierProvider<SettlementsNotifier, List<Settlement>>(
      SettlementsNotifier.new,
    );

class SettlementsNotifier extends Notifier<List<Settlement>> {
  @override
  List<Settlement> build() {
    return IsarService.getAllSettlements();
  }

  void _save() {
    IsarService.saveSettlements(state);
  }

  Settlement? getForMonth(int year, int month) {
    return state.where((s) => s.year == year && s.month == month).firstOrNull;
  }

  Future<void> createSettlement({
    required int year,
    required int month,
    required List<SettlementItem> items,
  }) async {
    final settlement = Settlement(
      id: 'settle_${year}_$month',
      messId: 'default',
      year: year,
      month: month,
      calculatedAt: DateTime.now(),
      items: items,
    );

    // Remove old settlement for same month if exists
    state = state.where((s) => !(s.year == year && s.month == month)).toList();
    state = [...state, settlement];
    _save();
  }

  Future<void> markItemPaid(
    String settlementId,
    String fromId,
    String toId,
  ) async {
    state = state.map((s) {
      if (s.id == settlementId) {
        final updatedItems = s.items.map((item) {
          if (item.fromMemberId == fromId && item.toMemberId == toId) {
            return item.copyWith(isPaid: true, paidAt: DateTime.now());
          }
          return item;
        }).toList();

        final allPaid = updatedItems.every((i) => i.isPaid);
        return s.copyWith(
          items: updatedItems,
          status: allPaid
              ? SettlementStatus.completed
              : SettlementStatus.partial,
          settledAt: allPaid ? DateTime.now() : null,
        );
      }
      return s;
    }).toList();
    _save();
  }

  /// Super Admin: Force mark all items as paid
  Future<void> forceSettleAll(String settlementId) async {
    state = state.map((s) {
      if (s.id == settlementId) {
        final updatedItems = s.items.map((item) {
          return item.copyWith(isPaid: true, paidAt: DateTime.now());
        }).toList();

        return s.copyWith(
          items: updatedItems,
          status: SettlementStatus.completed,
          settledAt: DateTime.now(),
        );
      }
      return s;
    }).toList();
    _save();
  }
}

/// Current month balance summary per member
/// Formula: Balance = Opening + Deposits (Bazar) - Expenses (Meals + Fixed)
final currentMonthBalancesProvider = Provider<List<MemberBalanceSummary>>((
  ref,
) {
  final members = ref.watch(membersProvider);
  final bazarEntries = ref.watch(bazarEntriesProvider);
  final meals = ref.watch(mealsProvider);
  final fixedExpenses = ref.watch(fixedExpensesProvider);
  final monthLockState = ref.watch(monthLockProvider);

  final now = DateTime.now();
  final year = now.year;
  final month = now.month;

  // Filter to current month
  final monthBazar = bazarEntries
      .where((b) => b.date.year == year && b.date.month == month)
      .toList();

  final monthMeals = meals
      .where((m) => m.date.year == year && m.date.month == month)
      .toList();

  // Calculate totals - using meal count field
  final totalBazar = monthBazar.fold(0.0, (sum, b) => sum + b.amount);
  final totalMeals = monthMeals.fold(0, (sum, m) => sum + m.count);
  final mealRate = totalMeals > 0 ? totalBazar / totalMeals : 0.0;

  // Calculate fixed expenses total
  final totalFixedExpenses = fixedExpenses.fold<double>(
    0.0,
    (sum, e) => sum + e.amount,
  );

  // Calculate total active days across all members (for pro-rata)
  final daysInMonth = DateTime(year, month + 1, 0).day;
  final monthStart = DateTime(year, month, 1);
  final monthEnd = DateTime(year, month, daysInMonth);

  // Helper to calculate active days for a member in this month
  int getActiveDays(dynamic member) {
    if (!member.isActive) return 0;

    final fromDate = member.activeFromDate ?? member.joinedAt ?? monthStart;
    final toDate = member.activeToDate ?? monthEnd;

    // Clamp dates to current month
    final effectiveStart = fromDate.isBefore(monthStart)
        ? monthStart
        : fromDate;
    final effectiveEnd = toDate.isAfter(monthEnd) ? monthEnd : toDate;

    if (effectiveStart.isAfter(effectiveEnd)) return 0;

    return effectiveEnd.difference(effectiveStart).inDays + 1;
  }

  // Calculate total active days across all active members
  final totalActiveDays = members
      .where((m) => m.isActive)
      .fold(0, (sum, m) => sum + getActiveDays(m));

  // Calculate per-member balances including opening balance
  return members.map((member) {
    // Get opening balance from previous month carry-forward
    final openingBalance = monthLockState.getOpeningBalance(
      member.id,
      year,
      month,
    );

    final memberBazar = monthBazar
        .where((b) => b.memberId == member.id)
        .fold(0.0, (sum, b) => sum + b.amount);
    final memberMeals = monthMeals
        .where((m) => m.memberId == member.id)
        .fold(0, (sum, m) => sum + m.count);

    final mealCost = memberMeals * mealRate;

    // Pro-rata fixed expense share based on active days
    final memberActiveDays = getActiveDays(member);
    final monthlyShare = totalActiveDays > 0
        ? (memberActiveDays / totalActiveDays) * totalFixedExpenses
        : 0.0;

    // Balance = Opening + Deposits (Bazar) - Expenses (Meals + Fixed)
    return MemberBalanceSummary(
      memberId: member.id,
      totalBazar: memberBazar,
      mealCost: mealCost,
      monthlyShare: monthlyShare,
      balance: openingBalance + memberBazar - mealCost - monthlyShare,
    );
  }).toList();
});

/// Who owes whom calculation
final whoOwesWhomProvider = Provider<List<SettlementItem>>((ref) {
  final balances = ref.watch(currentMonthBalancesProvider);

  // Separate creditors (positive balance) and debtors (negative balance)
  final creditors = balances.where((b) => b.balance > 0).toList()
    ..sort((a, b) => b.balance.compareTo(a.balance));
  final debtors = balances.where((b) => b.balance < 0).toList()
    ..sort((a, b) => a.balance.compareTo(b.balance));

  final items = <SettlementItem>[];

  // Match debtors to creditors
  var creditorsCopy = creditors.map((c) => c.balance).toList();
  var debtorsCopy = debtors.map((d) => d.balance.abs()).toList();

  int c = 0, d = 0;
  while (c < creditors.length && d < debtors.length) {
    final amount = creditorsCopy[c] < debtorsCopy[d]
        ? creditorsCopy[c]
        : debtorsCopy[d];

    if (amount > 1) {
      // Only add if > 1 taka
      items.add(
        SettlementItem(
          fromMemberId: debtors[d].memberId,
          toMemberId: creditors[c].memberId,
          amount: amount,
        ),
      );
    }

    creditorsCopy[c] -= amount;
    debtorsCopy[d] -= amount;

    if (creditorsCopy[c] <= 0) c++;
    if (debtorsCopy[d] <= 0) d++;
  }

  return items;
});

/// Current month settlement status
final currentMonthSettlementProvider = Provider<Settlement?>((ref) {
  final now = DateTime.now();
  final settlements = ref.watch(settlementsProvider);
  return settlements
      .where((s) => s.year == now.year && s.month == now.month)
      .firstOrNull;
});
