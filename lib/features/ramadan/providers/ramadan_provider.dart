import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mess_manager/core/models/ramadan.dart';
import 'package:mess_manager/core/database/isar_service.dart';

/// Current active Ramadan season
final activeRamadanSeasonProvider = Provider<RamadanSeason?>((ref) {
  final seasons = ref.watch(ramadanSeasonsProvider);
  final now = DateTime.now();
  return seasons
      .where(
        (s) =>
            s.isActive && now.isAfter(s.startDate) && now.isBefore(s.endDate),
      )
      .firstOrNull;
});

/// All Ramadan seasons
final ramadanSeasonsProvider =
    NotifierProvider<RamadanSeasonsNotifier, List<RamadanSeason>>(
      RamadanSeasonsNotifier.new,
    );

class RamadanSeasonsNotifier extends Notifier<List<RamadanSeason>> {
  @override
  List<RamadanSeason> build() {
    return IsarService.getAllRamadanSeasons();
  }

  void _save() {
    IsarService.saveRamadanSeasons(state);
  }

  Future<void> createSeason({
    required DateTime startDate,
    required DateTime endDate,
    required int hijriYear,
    required List<String> optedInMemberIds,
  }) async {
    final season = RamadanSeason(
      id: 'ramadan_${DateTime.now().millisecondsSinceEpoch}',
      messId: 'default',
      startDate: startDate,
      endDate: endDate,
      year: hijriYear,
      optedInMemberIds: optedInMemberIds,
      createdAt: DateTime.now(),
    );
    state = [...state, season];
    _save();
  }

  Future<void> optIn(String seasonId, String memberId) async {
    state = state.map((s) {
      if (s.id == seasonId && !s.optedInMemberIds.contains(memberId)) {
        return s.copyWith(optedInMemberIds: [...s.optedInMemberIds, memberId]);
      }
      return s;
    }).toList();
    _save();
  }

  Future<void> optOut(String seasonId, String memberId) async {
    state = state.map((s) {
      if (s.id == seasonId) {
        return s.copyWith(
          optedInMemberIds: s.optedInMemberIds
              .where((id) => id != memberId)
              .toList(),
        );
      }
      return s;
    }).toList();
    _save();
  }

  Future<void> endSeason(String seasonId) async {
    state = state.map((s) {
      if (s.id == seasonId) {
        return s.copyWith(isActive: false);
      }
      return s;
    }).toList();
    _save();
  }

  /// Mark season as fully settled (hides from UI)
  Future<void> markSeasonSettled(String seasonId) async {
    state = state.map((s) {
      if (s.id == seasonId) {
        return s.copyWith(isSettled: true, isActive: false);
      }
      return s;
    }).toList();
    _save();
  }
}

/// Ramadan meals for active season
final ramadanMealsProvider =
    NotifierProvider<RamadanMealsNotifier, List<RamadanMeal>>(
      RamadanMealsNotifier.new,
    );

class RamadanMealsNotifier extends Notifier<List<RamadanMeal>> {
  @override
  List<RamadanMeal> build() {
    return IsarService.getAllRamadanMeals();
  }

  void _save() {
    IsarService.saveRamadanMeals(state);
  }

  Future<void> addMeal({
    required String seasonId,
    required String memberId,
    required DateTime date,
    required RamadanMealType type,
    int count = 1,
    int guestCount = 0,
    String? guestName,
  }) async {
    final meal = RamadanMeal(
      id: 'rmeal_${DateTime.now().millisecondsSinceEpoch}',
      seasonId: seasonId,
      memberId: memberId,
      date: date,
      type: type,
      count: count,
      guestCount: guestCount,
      guestName: guestName,
      createdAt: DateTime.now(),
    );
    state = [...state, meal];
    _save();
  }

  Future<void> removeMeal(String mealId) async {
    state = state.where((m) => m.id != mealId).toList();
    IsarService.deleteRamadanMeal(mealId);
  }

  List<RamadanMeal> getMealsForDate(String seasonId, DateTime date) {
    return state
        .where(
          (m) =>
              m.seasonId == seasonId &&
              m.date.year == date.year &&
              m.date.month == date.month &&
              m.date.day == date.day,
        )
        .toList();
  }
}

/// Ramadan bazar for active season
final ramadanBazarProvider =
    NotifierProvider<RamadanBazarNotifier, List<RamadanBazar>>(
      RamadanBazarNotifier.new,
    );

class RamadanBazarNotifier extends Notifier<List<RamadanBazar>> {
  @override
  List<RamadanBazar> build() {
    return IsarService.getAllRamadanBazar();
  }

  void _save() {
    IsarService.saveRamadanBazars(state);
  }

  Future<void> addBazar({
    required String seasonId,
    required String memberId,
    required double amount,
    String? description,
    bool isForSehri = false,
  }) async {
    final bazar = RamadanBazar(
      id: 'rbazar_${DateTime.now().millisecondsSinceEpoch}',
      seasonId: seasonId,
      memberId: memberId,
      date: DateTime.now(),
      amount: amount,
      description: description,
      isForSehri: isForSehri,
      createdAt: DateTime.now(),
    );
    state = [...state, bazar];
    _save();
  }

  double getTotalForSeason(String seasonId) {
    return state
        .where((b) => b.seasonId == seasonId)
        .fold(0.0, (sum, b) => sum + b.amount);
  }

  double getMemberTotal(String seasonId, String memberId) {
    return state
        .where((b) => b.seasonId == seasonId && b.memberId == memberId)
        .fold(0.0, (sum, b) => sum + b.amount);
  }
}

/// Ramadan payments (tracks which credit/debt items have been paid)
final ramadanPaymentsProvider =
    NotifierProvider<RamadanPaymentsNotifier, List<RamadanPayment>>(
      RamadanPaymentsNotifier.new,
    );

class RamadanPaymentsNotifier extends Notifier<List<RamadanPayment>> {
  @override
  List<RamadanPayment> build() {
    return IsarService.getAllRamadanPayments();
  }

  void _save() {
    IsarService.saveRamadanPayments(state);
  }

  Future<void> addPayment({
    required String seasonId,
    required String fromMemberId,
    required String toMemberId,
    required double amount,
  }) async {
    final payment = RamadanPayment(
      id: 'rpay_${DateTime.now().millisecondsSinceEpoch}',
      seasonId: seasonId,
      fromMemberId: fromMemberId,
      toMemberId: toMemberId,
      amount: amount,
      paidAt: DateTime.now(),
    );
    state = [...state, payment];
    _save();
  }

  /// Get total paid amount between two members for a season
  double getPaidAmount(
    String seasonId,
    String fromMemberId,
    String toMemberId,
  ) {
    return state
        .where(
          (p) =>
              p.seasonId == seasonId &&
              p.fromMemberId == fromMemberId &&
              p.toMemberId == toMemberId,
        )
        .fold(0.0, (sum, p) => sum + p.amount);
  }
}

/// Calculate Ramadan balance for each opted-in member
final ramadanBalancesProvider = Provider<List<RamadanBalance>>((ref) {
  final season = ref.watch(activeRamadanSeasonProvider);
  if (season == null) return [];

  final meals = ref
      .watch(ramadanMealsProvider)
      .where((m) => m.seasonId == season.id)
      .toList();
  final bazar = ref.watch(ramadanBazarProvider);

  // Calculate total meals and meal rate (including guest meals)
  final totalMeals = meals.fold(0, (sum, m) => sum + m.count + m.guestCount);
  final totalBazar = bazar
      .where((b) => b.seasonId == season.id)
      .fold(0.0, (sum, b) => sum + b.amount);
  final mealRate = totalMeals > 0 ? totalBazar / totalMeals : 0.0;

  // Calculate per-member balances (sponsor pays for their guests)
  return season.optedInMemberIds.map((memberId) {
    final memberMeals = meals
        .where((m) => m.memberId == memberId)
        .fold(0, (sum, m) => sum + m.count + m.guestCount);
    final memberBazar = bazar
        .where((b) => b.seasonId == season.id && b.memberId == memberId)
        .fold(0.0, (sum, b) => sum + b.amount);
    final mealCost = memberMeals * mealRate;

    return RamadanBalance(
      memberId: memberId,
      seasonId: season.id,
      totalMeals: memberMeals,
      totalBazar: memberBazar,
      mealCost: mealCost,
      balance: memberBazar - mealCost,
    );
  }).toList();
});

/// Ramadan meal rate (with divide-by-zero protection)
final ramadanMealRateProvider = Provider<double>((ref) {
  final season = ref.watch(activeRamadanSeasonProvider);
  if (season == null) return 0.0;

  final meals = ref
      .watch(ramadanMealsProvider)
      .where((m) => m.seasonId == season.id)
      .toList();
  final bazar = ref.watch(ramadanBazarProvider);
  final totalBazar = bazar
      .where((b) => b.seasonId == season.id)
      .fold(0.0, (sum, b) => sum + b.amount);

  final totalMeals = meals.fold(0, (sum, m) => sum + m.count);
  // Protection against divide-by-zero
  if (totalMeals == 0) return 0.0;
  return totalBazar / totalMeals;
});

/// Check if Ramadan section should be visible
/// Visible when: active season exists OR any season has unsettled balances
final isRamadanVisibleProvider = Provider<bool>((ref) {
  final activeSeason = ref.watch(activeRamadanSeasonProvider);
  if (activeSeason != null) return true;

  // Check for unsettled past seasons
  final seasons = ref.watch(ramadanSeasonsProvider);
  final balances = ref.watch(ramadanBalancesProvider);

  // Show if any season has non-zero balances
  for (final season in seasons) {
    if (!season.isSettled) {
      final hasBalance = balances.any(
        (b) => b.seasonId == season.id && b.balance.abs() > 1,
      );
      if (hasBalance) return true;
    }
  }

  return false;
});

/// Season that needs settlement (most recent unsettled with balances)
final ramadanSeasonNeedingSettlementProvider = Provider<RamadanSeason?>((ref) {
  final seasons = ref.watch(ramadanSeasonsProvider);
  final now = DateTime.now();

  // Find seasons that ended and have unsettled balances
  for (final season in seasons.reversed) {
    if (!season.isSettled && now.isAfter(season.endDate)) {
      return season;
    }
  }
  return null;
});

/// Ramadan credit/debt items (who owes whom within Ramadan)
/// Filters out amounts that have already been paid
final ramadanCreditDebtProvider = Provider<List<RamadanCreditDebt>>((ref) {
  final season =
      ref.watch(activeRamadanSeasonProvider) ??
      ref.watch(ramadanSeasonNeedingSettlementProvider);
  if (season == null) return [];

  final balances = ref
      .watch(ramadanBalancesProvider)
      .where((b) => b.seasonId == season.id)
      .toList();
  final payments = ref.watch(ramadanPaymentsProvider);

  // Separate creditors and debtors
  final creditors = balances.where((b) => b.balance > 1).toList()
    ..sort((a, b) => b.balance.compareTo(a.balance));
  final debtors = balances.where((b) => b.balance < -1).toList()
    ..sort((a, b) => a.balance.compareTo(b.balance));

  final items = <RamadanCreditDebt>[];

  // Match debtors to creditors
  var creditorAmounts = creditors.map((c) => c.balance).toList();
  var debtorAmounts = debtors.map((d) => d.balance.abs()).toList();

  int c = 0, d = 0;
  while (c < creditors.length && d < debtors.length) {
    if (creditorAmounts[c] <= 0) {
      c++;
      continue;
    }
    if (debtorAmounts[d] <= 0) {
      d++;
      continue;
    }

    final amount = creditorAmounts[c] < debtorAmounts[d]
        ? creditorAmounts[c]
        : debtorAmounts[d];

    if (amount > 1) {
      // Calculate already paid amount for this pair
      final paidAmount = payments
          .where(
            (p) =>
                p.seasonId == season.id &&
                p.fromMemberId == debtors[d].memberId &&
                p.toMemberId == creditors[c].memberId,
          )
          .fold(0.0, (sum, p) => sum + p.amount);

      final remainingAmount = amount - paidAmount;

      // Only show if there's still an unpaid balance
      if (remainingAmount > 1) {
        items.add(
          RamadanCreditDebt(
            seasonId: season.id,
            fromMemberId: debtors[d].memberId,
            toMemberId: creditors[c].memberId,
            amount: remainingAmount,
          ),
        );
      }
    }

    creditorAmounts[c] -= amount;
    debtorAmounts[d] -= amount;
  }

  return items;
});

/// Check if all Ramadan balances are settled (near zero)
final isRamadanSettledProvider = Provider<bool>((ref) {
  final balances = ref.watch(ramadanBalancesProvider);
  if (balances.isEmpty) return true;
  return balances.every((b) => b.balance.abs() < 5); // ৳5 tolerance
});

/// Ramadan credit/debt item model
class RamadanCreditDebt {
  final String seasonId;
  final String fromMemberId; // Debtor
  final String toMemberId; // Creditor
  final double amount;
  final bool isPaid;
  final DateTime? paidAt;

  RamadanCreditDebt({
    required this.seasonId,
    required this.fromMemberId,
    required this.toMemberId,
    required this.amount,
    this.isPaid = false,
    this.paidAt,
  });
}
