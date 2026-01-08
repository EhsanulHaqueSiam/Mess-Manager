import 'package:freezed_annotation/freezed_annotation.dart';

part 'ramadan.freezed.dart';
part 'ramadan.g.dart';

/// Ramadan meal types
enum RamadanMealType { sehri, iftar }

/// Ramadan Season
@freezed
sealed class RamadanSeason with _$RamadanSeason {
  const factory RamadanSeason({
    required String id,
    required String messId,
    required DateTime startDate,
    required DateTime endDate,
    required int year,
    @Default([]) List<String> optedInMemberIds,
    @Default(true) bool isActive,
    @Default(false) bool isSettled,
    DateTime? createdAt,
  }) = _RamadanSeason;

  factory RamadanSeason.fromJson(Map<String, dynamic> json) =>
      _$RamadanSeasonFromJson(json);
}

/// Ramadan Meal
@freezed
sealed class RamadanMeal with _$RamadanMeal {
  const factory RamadanMeal({
    required String id,
    required String seasonId,
    required String memberId,
    required DateTime date,
    required RamadanMealType type,
    @Default(1) int count,
    @Default(0) int guestCount, // Number of guest meals (sponsor pays)
    String? guestName, // Optional guest name(s) for reference
    DateTime? createdAt,
  }) = _RamadanMeal;

  factory RamadanMeal.fromJson(Map<String, dynamic> json) =>
      _$RamadanMealFromJson(json);
}

/// Ramadan Bazar
@freezed
sealed class RamadanBazar with _$RamadanBazar {
  const factory RamadanBazar({
    required String id,
    required String seasonId,
    required String memberId,
    required DateTime date,
    required double amount,
    String? description,
    @Default(false) bool isForSehri,
    DateTime? createdAt,
  }) = _RamadanBazar;

  factory RamadanBazar.fromJson(Map<String, dynamic> json) =>
      _$RamadanBazarFromJson(json);
}

/// Ramadan Balance
@freezed
sealed class RamadanBalance with _$RamadanBalance {
  const factory RamadanBalance({
    required String memberId,
    required String seasonId,
    required int totalMeals,
    required double totalBazar,
    required double mealCost,
    required double balance,
  }) = _RamadanBalance;

  factory RamadanBalance.fromJson(Map<String, dynamic> json) =>
      _$RamadanBalanceFromJson(json);
}

/// Ramadan Payment - tracks paid credit/debt items
@freezed
sealed class RamadanPayment with _$RamadanPayment {
  const factory RamadanPayment({
    required String id,
    required String seasonId,
    required String fromMemberId, // Debtor who paid
    required String toMemberId, // Creditor who received
    required double amount,
    required DateTime paidAt,
  }) = _RamadanPayment;

  factory RamadanPayment.fromJson(Map<String, dynamic> json) =>
      _$RamadanPaymentFromJson(json);
}
