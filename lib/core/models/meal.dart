/// Type of meal
enum MealType { breakfast, lunch, dinner }

/// Status of a meal entry
enum MealStatus {
  scheduled, // Future meal from default schedule
  confirmed, // Confirmed/eaten meal
  cancelled, // Cancelled/skipped meal
}

/// Meal entry for a member
class Meal {
  final String id;
  final String memberId;
  final DateTime date;
  final int count; // Whole numbers only: 1, 2, 3...
  final MealType type;
  final MealStatus status;
  final bool isFromSchedule; // Auto-added from weekly schedule
  // Guest meal fields
  final int guestCount; // Number of guest meals
  final String? guestName; // Optional guest name
  final List<String> sharedWithMemberIds; // Split guest cost
  final String? note;
  final DateTime? createdAt;

  const Meal({
    required this.id,
    required this.memberId,
    required this.date,
    this.count = 1,
    this.type = MealType.lunch,
    this.status = MealStatus.confirmed,
    this.isFromSchedule = false,
    this.guestCount = 0,
    this.guestName,
    this.sharedWithMemberIds = const [],
    this.note,
    this.createdAt,
  });

  Meal copyWith({
    String? id,
    String? memberId,
    DateTime? date,
    int? count,
    MealType? type,
    MealStatus? status,
    bool? isFromSchedule,
    int? guestCount,
    String? guestName,
    List<String>? sharedWithMemberIds,
    String? note,
    DateTime? createdAt,
  }) {
    return Meal(
      id: id ?? this.id,
      memberId: memberId ?? this.memberId,
      date: date ?? this.date,
      count: count ?? this.count,
      type: type ?? this.type,
      status: status ?? this.status,
      isFromSchedule: isFromSchedule ?? this.isFromSchedule,
      guestCount: guestCount ?? this.guestCount,
      guestName: guestName ?? this.guestName,
      sharedWithMemberIds: sharedWithMemberIds ?? this.sharedWithMemberIds,
      note: note ?? this.note,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  factory Meal.fromJson(Map<String, dynamic> json) {
    return Meal(
      id: json['id'] as String? ?? '',
      memberId: json['memberId'] as String? ?? '',
      date: DateTime.parse(json['date'] as String),
      count: (json['count'] ?? 1) as int,
      type: _mealTypeFromJson(json['type']),
      status: _mealStatusFromJson(json['status']),
      isFromSchedule: json['isFromSchedule'] ?? false,
      guestCount: (json['guestCount'] ?? 0) as int,
      guestName: json['guestName'] as String?,
      sharedWithMemberIds:
          List<String>.from(json['sharedWithMemberIds'] ?? []),
      note: json['note'] as String?,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'memberId': memberId,
      'date': date.toIso8601String(),
      'count': count,
      'type': type.name,
      'status': status.name,
      'isFromSchedule': isFromSchedule,
      'guestCount': guestCount,
      'guestName': guestName,
      'sharedWithMemberIds': sharedWithMemberIds,
      'note': note,
      'createdAt': createdAt?.toIso8601String(),
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Meal &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          memberId == other.memberId &&
          date == other.date &&
          count == other.count &&
          type == other.type &&
          status == other.status &&
          isFromSchedule == other.isFromSchedule &&
          guestCount == other.guestCount &&
          guestName == other.guestName &&
          note == other.note &&
          createdAt == other.createdAt;

  @override
  int get hashCode => Object.hash(
        id,
        memberId,
        date,
        count,
        type,
        status,
        isFromSchedule,
        guestCount,
        guestName,
        note,
        createdAt,
      );

  @override
  String toString() =>
      'Meal(id: $id, memberId: $memberId, date: $date, count: $count, type: $type, status: $status)';
}

/// Daily meal summary for quick view
class DailyMealSummary {
  final DateTime date;
  final Map<String, int> memberMeals; // memberId -> count (int)
  final int totalMeals;

  const DailyMealSummary({
    required this.date,
    required this.memberMeals,
    this.totalMeals = 0,
  });

  DailyMealSummary copyWith({
    DateTime? date,
    Map<String, int>? memberMeals,
    int? totalMeals,
  }) {
    return DailyMealSummary(
      date: date ?? this.date,
      memberMeals: memberMeals ?? this.memberMeals,
      totalMeals: totalMeals ?? this.totalMeals,
    );
  }

  factory DailyMealSummary.fromJson(Map<String, dynamic> json) {
    return DailyMealSummary(
      date: DateTime.parse(json['date'] as String),
      memberMeals: Map<String, int>.from(json['memberMeals'] ?? {}),
      totalMeals: (json['totalMeals'] ?? 0) as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date.toIso8601String(),
      'memberMeals': memberMeals,
      'totalMeals': totalMeals,
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DailyMealSummary &&
          runtimeType == other.runtimeType &&
          date == other.date &&
          totalMeals == other.totalMeals;

  @override
  int get hashCode => Object.hash(date, totalMeals);

  @override
  String toString() =>
      'DailyMealSummary(date: $date, totalMeals: $totalMeals)';
}

/// Vacation mode data with meal-specific boundaries
/// Example: 2-1-26 night to 12-1-26 evening
/// means: 2-1-26 lunch is last meal, 12-1-26 dinner is first meal back
class VacationPeriod {
  final String id;
  final String memberId;
  final DateTime startDate; // Date vacation starts
  final DateTime endDate; // Date vacation ends
  final MealType lastMealBefore; // Last meal before leaving
  final MealType firstMealAfter; // First meal after returning
  final String? reason;
  final bool isActive;

  const VacationPeriod({
    required this.id,
    required this.memberId,
    required this.startDate,
    required this.endDate,
    this.lastMealBefore = MealType.dinner,
    this.firstMealAfter = MealType.lunch,
    this.reason,
    this.isActive = true,
  });

  VacationPeriod copyWith({
    String? id,
    String? memberId,
    DateTime? startDate,
    DateTime? endDate,
    MealType? lastMealBefore,
    MealType? firstMealAfter,
    String? reason,
    bool? isActive,
  }) {
    return VacationPeriod(
      id: id ?? this.id,
      memberId: memberId ?? this.memberId,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      lastMealBefore: lastMealBefore ?? this.lastMealBefore,
      firstMealAfter: firstMealAfter ?? this.firstMealAfter,
      reason: reason ?? this.reason,
      isActive: isActive ?? this.isActive,
    );
  }

  factory VacationPeriod.fromJson(Map<String, dynamic> json) {
    return VacationPeriod(
      id: json['id'] as String? ?? '',
      memberId: json['memberId'] as String? ?? '',
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: DateTime.parse(json['endDate'] as String),
      lastMealBefore: _mealTypeFromJson(json['lastMealBefore'] ?? 'dinner'),
      firstMealAfter: _mealTypeFromJson(json['firstMealAfter'] ?? 'lunch'),
      reason: json['reason'] as String?,
      isActive: json['isActive'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'memberId': memberId,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'lastMealBefore': lastMealBefore.name,
      'firstMealAfter': firstMealAfter.name,
      'reason': reason,
      'isActive': isActive,
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VacationPeriod &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          memberId == other.memberId &&
          startDate == other.startDate &&
          endDate == other.endDate &&
          lastMealBefore == other.lastMealBefore &&
          firstMealAfter == other.firstMealAfter &&
          reason == other.reason &&
          isActive == other.isActive;

  @override
  int get hashCode => Object.hash(
        id,
        memberId,
        startDate,
        endDate,
        lastMealBefore,
        firstMealAfter,
        reason,
        isActive,
      );

  @override
  String toString() =>
      'VacationPeriod(id: $id, memberId: $memberId, start: $startDate, end: $endDate, active: $isActive)';
}

/// Types of fixed monthly expenses
enum FixedExpenseType {
  rent,
  wifi,
  bua,
  electricity,
  gas,
  water,
  emergency,
  other,
}

/// Fixed monthly expense that everyone pays regardless of meals/vacation
class FixedExpense {
  final String id;
  final FixedExpenseType type;
  final double amount;
  final DateTime dueDate;
  final int month; // 1-12
  final int year;
  final String? description;
  final bool isPaid;
  final DateTime? paidAt;
  final String? paidByMemberId;
  final List<String>
      splitMemberIds; // If empty, split among all active members

  const FixedExpense({
    required this.id,
    required this.type,
    required this.amount,
    required this.dueDate,
    required this.month,
    required this.year,
    this.description,
    this.isPaid = false,
    this.paidAt,
    this.paidByMemberId,
    this.splitMemberIds = const [],
  });

  FixedExpense copyWith({
    String? id,
    FixedExpenseType? type,
    double? amount,
    DateTime? dueDate,
    int? month,
    int? year,
    String? description,
    bool? isPaid,
    DateTime? paidAt,
    String? paidByMemberId,
    List<String>? splitMemberIds,
  }) {
    return FixedExpense(
      id: id ?? this.id,
      type: type ?? this.type,
      amount: amount ?? this.amount,
      dueDate: dueDate ?? this.dueDate,
      month: month ?? this.month,
      year: year ?? this.year,
      description: description ?? this.description,
      isPaid: isPaid ?? this.isPaid,
      paidAt: paidAt ?? this.paidAt,
      paidByMemberId: paidByMemberId ?? this.paidByMemberId,
      splitMemberIds: splitMemberIds ?? this.splitMemberIds,
    );
  }

  factory FixedExpense.fromJson(Map<String, dynamic> json) {
    return FixedExpense(
      id: json['id'] as String? ?? '',
      type: _fixedExpenseTypeFromJson(json['type']),
      amount: (json['amount'] ?? 0).toDouble(),
      dueDate: DateTime.parse(json['dueDate'] as String),
      month: (json['month'] ?? 1) as int,
      year: (json['year'] ?? 2024) as int,
      description: json['description'] as String?,
      isPaid: json['isPaid'] ?? false,
      paidAt: json['paidAt'] != null
          ? DateTime.parse(json['paidAt'] as String)
          : null,
      paidByMemberId: json['paidByMemberId'] as String?,
      splitMemberIds: List<String>.from(json['splitMemberIds'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type.name,
      'amount': amount,
      'dueDate': dueDate.toIso8601String(),
      'month': month,
      'year': year,
      'description': description,
      'isPaid': isPaid,
      'paidAt': paidAt?.toIso8601String(),
      'paidByMemberId': paidByMemberId,
      'splitMemberIds': splitMemberIds,
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FixedExpense &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          type == other.type &&
          amount == other.amount &&
          dueDate == other.dueDate &&
          month == other.month &&
          year == other.year &&
          description == other.description &&
          isPaid == other.isPaid &&
          paidAt == other.paidAt &&
          paidByMemberId == other.paidByMemberId;

  @override
  int get hashCode => Object.hash(
        id,
        type,
        amount,
        dueDate,
        month,
        year,
        description,
        isPaid,
        paidAt,
        paidByMemberId,
      );

  @override
  String toString() =>
      'FixedExpense(id: $id, type: $type, amount: $amount, month: $month/$year, paid: $isPaid)';
}

/// Per-member payment status for a fixed expense
class FixedExpensePayment {
  final String id;
  final String expenseId;
  final String memberId;
  final double shareAmount;
  final bool isPaid;
  final DateTime? paidAt;

  const FixedExpensePayment({
    required this.id,
    required this.expenseId,
    required this.memberId,
    required this.shareAmount,
    this.isPaid = false,
    this.paidAt,
  });

  FixedExpensePayment copyWith({
    String? id,
    String? expenseId,
    String? memberId,
    double? shareAmount,
    bool? isPaid,
    DateTime? paidAt,
  }) {
    return FixedExpensePayment(
      id: id ?? this.id,
      expenseId: expenseId ?? this.expenseId,
      memberId: memberId ?? this.memberId,
      shareAmount: shareAmount ?? this.shareAmount,
      isPaid: isPaid ?? this.isPaid,
      paidAt: paidAt ?? this.paidAt,
    );
  }

  factory FixedExpensePayment.fromJson(Map<String, dynamic> json) {
    return FixedExpensePayment(
      id: json['id'] as String? ?? '',
      expenseId: json['expenseId'] as String? ?? '',
      memberId: json['memberId'] as String? ?? '',
      shareAmount: (json['shareAmount'] ?? 0).toDouble(),
      isPaid: json['isPaid'] ?? false,
      paidAt: json['paidAt'] != null
          ? DateTime.parse(json['paidAt'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'expenseId': expenseId,
      'memberId': memberId,
      'shareAmount': shareAmount,
      'isPaid': isPaid,
      'paidAt': paidAt?.toIso8601String(),
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FixedExpensePayment &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          expenseId == other.expenseId &&
          memberId == other.memberId &&
          shareAmount == other.shareAmount &&
          isPaid == other.isPaid &&
          paidAt == other.paidAt;

  @override
  int get hashCode => Object.hash(
        id,
        expenseId,
        memberId,
        shareAmount,
        isPaid,
        paidAt,
      );

  @override
  String toString() =>
      'FixedExpensePayment(id: $id, expenseId: $expenseId, memberId: $memberId, share: $shareAmount, paid: $isPaid)';
}

// Helper functions for enum parsing
MealType _mealTypeFromJson(dynamic value) {
  if (value == null) return MealType.lunch;
  try {
    return MealType.values.byName(value as String);
  } catch (_) {
    return MealType.lunch;
  }
}

MealStatus _mealStatusFromJson(dynamic value) {
  if (value == null) return MealStatus.confirmed;
  try {
    return MealStatus.values.byName(value as String);
  } catch (_) {
    return MealStatus.confirmed;
  }
}

FixedExpenseType _fixedExpenseTypeFromJson(dynamic value) {
  if (value == null) return FixedExpenseType.other;
  try {
    return FixedExpenseType.values.byName(value as String);
  } catch (_) {
    return FixedExpenseType.other;
  }
}
