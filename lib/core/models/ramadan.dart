/// Ramadan meal types
enum RamadanMealType { sehri, iftar }

/// Ramadan Season
class RamadanSeason {
  final String id;
  final String messId;
  final DateTime startDate;
  final DateTime endDate;
  final int year;
  final List<String> optedInMemberIds;
  final bool isActive;
  final bool isSettled;
  final DateTime? createdAt;

  const RamadanSeason({
    required this.id,
    required this.messId,
    required this.startDate,
    required this.endDate,
    required this.year,
    this.optedInMemberIds = const [],
    this.isActive = true,
    this.isSettled = false,
    this.createdAt,
  });

  RamadanSeason copyWith({
    String? id,
    String? messId,
    DateTime? startDate,
    DateTime? endDate,
    int? year,
    List<String>? optedInMemberIds,
    bool? isActive,
    bool? isSettled,
    DateTime? createdAt,
  }) {
    return RamadanSeason(
      id: id ?? this.id,
      messId: messId ?? this.messId,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      year: year ?? this.year,
      optedInMemberIds: optedInMemberIds ?? this.optedInMemberIds,
      isActive: isActive ?? this.isActive,
      isSettled: isSettled ?? this.isSettled,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  factory RamadanSeason.fromJson(Map<String, dynamic> json) {
    return RamadanSeason(
      id: json['id'] as String? ?? '',
      messId: json['messId'] as String? ?? '',
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: DateTime.parse(json['endDate'] as String),
      year: (json['year'] ?? 2024) as int,
      optedInMemberIds: List<String>.from(json['optedInMemberIds'] ?? []),
      isActive: json['isActive'] ?? true,
      isSettled: json['isSettled'] ?? false,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'messId': messId,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'year': year,
      'optedInMemberIds': optedInMemberIds,
      'isActive': isActive,
      'isSettled': isSettled,
      'createdAt': createdAt?.toIso8601String(),
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RamadanSeason &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          messId == other.messId &&
          startDate == other.startDate &&
          endDate == other.endDate &&
          year == other.year &&
          isActive == other.isActive &&
          isSettled == other.isSettled &&
          createdAt == other.createdAt;

  @override
  int get hashCode => Object.hash(
        id,
        messId,
        startDate,
        endDate,
        year,
        isActive,
        isSettled,
        createdAt,
      );

  @override
  String toString() =>
      'RamadanSeason(id: $id, messId: $messId, year: $year, active: $isActive, settled: $isSettled)';
}

/// Ramadan Meal
class RamadanMeal {
  final String id;
  final String seasonId;
  final String memberId;
  final DateTime date;
  final RamadanMealType type;
  final int count;
  final int guestCount; // Number of guest meals (sponsor pays)
  final String? guestName; // Optional guest name(s) for reference
  final DateTime? createdAt;

  const RamadanMeal({
    required this.id,
    required this.seasonId,
    required this.memberId,
    required this.date,
    required this.type,
    this.count = 1,
    this.guestCount = 0,
    this.guestName,
    this.createdAt,
  });

  RamadanMeal copyWith({
    String? id,
    String? seasonId,
    String? memberId,
    DateTime? date,
    RamadanMealType? type,
    int? count,
    int? guestCount,
    String? guestName,
    DateTime? createdAt,
  }) {
    return RamadanMeal(
      id: id ?? this.id,
      seasonId: seasonId ?? this.seasonId,
      memberId: memberId ?? this.memberId,
      date: date ?? this.date,
      type: type ?? this.type,
      count: count ?? this.count,
      guestCount: guestCount ?? this.guestCount,
      guestName: guestName ?? this.guestName,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  factory RamadanMeal.fromJson(Map<String, dynamic> json) {
    return RamadanMeal(
      id: json['id'] as String? ?? '',
      seasonId: json['seasonId'] as String? ?? '',
      memberId: json['memberId'] as String? ?? '',
      date: DateTime.parse(json['date'] as String),
      type: _ramadanMealTypeFromJson(json['type']),
      count: (json['count'] ?? 1) as int,
      guestCount: (json['guestCount'] ?? 0) as int,
      guestName: json['guestName'] as String?,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'seasonId': seasonId,
      'memberId': memberId,
      'date': date.toIso8601String(),
      'type': type.name,
      'count': count,
      'guestCount': guestCount,
      'guestName': guestName,
      'createdAt': createdAt?.toIso8601String(),
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RamadanMeal &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          seasonId == other.seasonId &&
          memberId == other.memberId &&
          date == other.date &&
          type == other.type &&
          count == other.count &&
          guestCount == other.guestCount &&
          guestName == other.guestName &&
          createdAt == other.createdAt;

  @override
  int get hashCode => Object.hash(
        id,
        seasonId,
        memberId,
        date,
        type,
        count,
        guestCount,
        guestName,
        createdAt,
      );

  @override
  String toString() =>
      'RamadanMeal(id: $id, seasonId: $seasonId, memberId: $memberId, date: $date, type: $type)';
}

/// Ramadan Bazar
class RamadanBazar {
  final String id;
  final String seasonId;
  final String memberId;
  final DateTime date;
  final double amount;
  final String? description;
  final bool isForSehri;
  final DateTime? createdAt;

  const RamadanBazar({
    required this.id,
    required this.seasonId,
    required this.memberId,
    required this.date,
    required this.amount,
    this.description,
    this.isForSehri = false,
    this.createdAt,
  });

  RamadanBazar copyWith({
    String? id,
    String? seasonId,
    String? memberId,
    DateTime? date,
    double? amount,
    String? description,
    bool? isForSehri,
    DateTime? createdAt,
  }) {
    return RamadanBazar(
      id: id ?? this.id,
      seasonId: seasonId ?? this.seasonId,
      memberId: memberId ?? this.memberId,
      date: date ?? this.date,
      amount: amount ?? this.amount,
      description: description ?? this.description,
      isForSehri: isForSehri ?? this.isForSehri,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  factory RamadanBazar.fromJson(Map<String, dynamic> json) {
    return RamadanBazar(
      id: json['id'] as String? ?? '',
      seasonId: json['seasonId'] as String? ?? '',
      memberId: json['memberId'] as String? ?? '',
      date: DateTime.parse(json['date'] as String),
      amount: (json['amount'] ?? 0).toDouble(),
      description: json['description'] as String?,
      isForSehri: json['isForSehri'] ?? false,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'seasonId': seasonId,
      'memberId': memberId,
      'date': date.toIso8601String(),
      'amount': amount,
      'description': description,
      'isForSehri': isForSehri,
      'createdAt': createdAt?.toIso8601String(),
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RamadanBazar &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          seasonId == other.seasonId &&
          memberId == other.memberId &&
          date == other.date &&
          amount == other.amount &&
          description == other.description &&
          isForSehri == other.isForSehri &&
          createdAt == other.createdAt;

  @override
  int get hashCode => Object.hash(
        id,
        seasonId,
        memberId,
        date,
        amount,
        description,
        isForSehri,
        createdAt,
      );

  @override
  String toString() =>
      'RamadanBazar(id: $id, seasonId: $seasonId, memberId: $memberId, amount: $amount)';
}

/// Ramadan Balance
class RamadanBalance {
  final String memberId;
  final String seasonId;
  final int totalMeals;
  final double totalBazar;
  final double mealCost;
  final double balance;

  const RamadanBalance({
    required this.memberId,
    required this.seasonId,
    required this.totalMeals,
    required this.totalBazar,
    required this.mealCost,
    required this.balance,
  });

  RamadanBalance copyWith({
    String? memberId,
    String? seasonId,
    int? totalMeals,
    double? totalBazar,
    double? mealCost,
    double? balance,
  }) {
    return RamadanBalance(
      memberId: memberId ?? this.memberId,
      seasonId: seasonId ?? this.seasonId,
      totalMeals: totalMeals ?? this.totalMeals,
      totalBazar: totalBazar ?? this.totalBazar,
      mealCost: mealCost ?? this.mealCost,
      balance: balance ?? this.balance,
    );
  }

  factory RamadanBalance.fromJson(Map<String, dynamic> json) {
    return RamadanBalance(
      memberId: json['memberId'] as String? ?? '',
      seasonId: json['seasonId'] as String? ?? '',
      totalMeals: (json['totalMeals'] ?? 0) as int,
      totalBazar: (json['totalBazar'] ?? 0).toDouble(),
      mealCost: (json['mealCost'] ?? 0).toDouble(),
      balance: (json['balance'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'memberId': memberId,
      'seasonId': seasonId,
      'totalMeals': totalMeals,
      'totalBazar': totalBazar,
      'mealCost': mealCost,
      'balance': balance,
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RamadanBalance &&
          runtimeType == other.runtimeType &&
          memberId == other.memberId &&
          seasonId == other.seasonId &&
          totalMeals == other.totalMeals &&
          totalBazar == other.totalBazar &&
          mealCost == other.mealCost &&
          balance == other.balance;

  @override
  int get hashCode => Object.hash(
        memberId,
        seasonId,
        totalMeals,
        totalBazar,
        mealCost,
        balance,
      );

  @override
  String toString() =>
      'RamadanBalance(memberId: $memberId, seasonId: $seasonId, meals: $totalMeals, balance: $balance)';
}

/// Ramadan Payment - tracks paid credit/debt items
class RamadanPayment {
  final String id;
  final String seasonId;
  final String fromMemberId; // Debtor who paid
  final String toMemberId; // Creditor who received
  final double amount;
  final DateTime paidAt;

  const RamadanPayment({
    required this.id,
    required this.seasonId,
    required this.fromMemberId,
    required this.toMemberId,
    required this.amount,
    required this.paidAt,
  });

  RamadanPayment copyWith({
    String? id,
    String? seasonId,
    String? fromMemberId,
    String? toMemberId,
    double? amount,
    DateTime? paidAt,
  }) {
    return RamadanPayment(
      id: id ?? this.id,
      seasonId: seasonId ?? this.seasonId,
      fromMemberId: fromMemberId ?? this.fromMemberId,
      toMemberId: toMemberId ?? this.toMemberId,
      amount: amount ?? this.amount,
      paidAt: paidAt ?? this.paidAt,
    );
  }

  factory RamadanPayment.fromJson(Map<String, dynamic> json) {
    return RamadanPayment(
      id: json['id'] as String? ?? '',
      seasonId: json['seasonId'] as String? ?? '',
      fromMemberId: json['fromMemberId'] as String? ?? '',
      toMemberId: json['toMemberId'] as String? ?? '',
      amount: (json['amount'] ?? 0).toDouble(),
      paidAt: DateTime.parse(json['paidAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'seasonId': seasonId,
      'fromMemberId': fromMemberId,
      'toMemberId': toMemberId,
      'amount': amount,
      'paidAt': paidAt.toIso8601String(),
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RamadanPayment &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          seasonId == other.seasonId &&
          fromMemberId == other.fromMemberId &&
          toMemberId == other.toMemberId &&
          amount == other.amount &&
          paidAt == other.paidAt;

  @override
  int get hashCode => Object.hash(
        id,
        seasonId,
        fromMemberId,
        toMemberId,
        amount,
        paidAt,
      );

  @override
  String toString() =>
      'RamadanPayment(id: $id, from: $fromMemberId, to: $toMemberId, amount: $amount)';
}

// Helper function for enum parsing
RamadanMealType _ramadanMealTypeFromJson(dynamic value) {
  if (value == null) return RamadanMealType.iftar;
  try {
    return RamadanMealType.values.byName(value as String);
  } catch (_) {
    return RamadanMealType.iftar;
  }
}
