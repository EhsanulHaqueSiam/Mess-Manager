import 'package:freezed_annotation/freezed_annotation.dart';

part 'meal.freezed.dart';
part 'meal.g.dart';

/// Type of meal
enum MealType { breakfast, lunch, dinner }

/// Status of a meal entry
enum MealStatus {
  scheduled, // Future meal from default schedule
  confirmed, // Confirmed/eaten meal
  cancelled, // Cancelled/skipped meal
}

/// Meal entry for a member
@freezed
sealed class Meal with _$Meal {
  const factory Meal({
    required String id,
    required String memberId,
    required DateTime date,
    @Default(1) int count, // Whole numbers only: 1, 2, 3...
    @Default(MealType.lunch) MealType type,
    @Default(MealStatus.confirmed) MealStatus status,
    @Default(false) bool isFromSchedule, // Auto-added from weekly schedule
    // Guest meal fields
    @Default(0) int guestCount, // Number of guest meals
    String? guestName, // Optional guest name
    @Default([]) List<String> sharedWithMemberIds, // Split guest cost
    String? note,
    DateTime? createdAt,
  }) = _Meal;

  factory Meal.fromJson(Map<String, dynamic> json) => _$MealFromJson(json);
}

/// Daily meal summary for quick view
@freezed
sealed class DailyMealSummary with _$DailyMealSummary {
  const factory DailyMealSummary({
    required DateTime date,
    required Map<String, int> memberMeals, // memberId -> count (int)
    @Default(0) int totalMeals,
  }) = _DailyMealSummary;

  factory DailyMealSummary.fromJson(Map<String, dynamic> json) =>
      _$DailyMealSummaryFromJson(json);
}

/// Vacation mode data with meal-specific boundaries
/// Example: 2-1-26 night to 12-1-26 evening
/// means: 2-1-26 lunch is last meal, 12-1-26 dinner is first meal back
@freezed
sealed class VacationPeriod with _$VacationPeriod {
  const factory VacationPeriod({
    required String id,
    required String memberId,
    required DateTime startDate, // Date vacation starts
    required DateTime endDate, // Date vacation ends
    @Default(MealType.dinner)
    MealType lastMealBefore, // Last meal before leaving
    @Default(MealType.lunch)
    MealType firstMealAfter, // First meal after returning
    String? reason,
    @Default(true) bool isActive,
  }) = _VacationPeriod;

  factory VacationPeriod.fromJson(Map<String, dynamic> json) =>
      _$VacationPeriodFromJson(json);
}

/// Types of fixed monthly expenses
enum FixedExpenseType {
  rent, // বাড়ি ভাড়া
  wifi, // ওয়াইফাই/ইন্টারনেট
  bua, // কাজের লোক (bua/maid)
  electricity, // বিদ্যুৎ
  gas, // গ্যাস
  water, // পানি
  emergency, // জরুরি খরচ
  other, // অন্যান্য
}

/// Fixed monthly expense that everyone pays regardless of meals/vacation
@freezed
sealed class FixedExpense with _$FixedExpense {
  const factory FixedExpense({
    required String id,
    required FixedExpenseType type,
    required double amount,
    required DateTime dueDate,
    required int month, // 1-12
    required int year,
    String? description,
    @Default(false) bool isPaid,
    DateTime? paidAt,
    String? paidByMemberId,
    @Default([])
    List<String> splitMemberIds, // If empty, split among all active members
  }) = _FixedExpense;

  factory FixedExpense.fromJson(Map<String, dynamic> json) =>
      _$FixedExpenseFromJson(json);
}

/// Per-member payment status for a fixed expense
@freezed
sealed class FixedExpensePayment with _$FixedExpensePayment {
  const factory FixedExpensePayment({
    required String id,
    required String expenseId,
    required String memberId,
    required double shareAmount,
    @Default(false) bool isPaid,
    DateTime? paidAt,
  }) = _FixedExpensePayment;

  factory FixedExpensePayment.fromJson(Map<String, dynamic> json) =>
      _$FixedExpensePaymentFromJson(json);
}
