/// Settlement status
enum SettlementStatus { pending, partial, completed }

/// Monthly Settlement
class Settlement {
  final String id;
  final String messId;
  final int year;
  final int month;
  final DateTime calculatedAt;
  final List<SettlementItem> items;
  final SettlementStatus status;
  final DateTime? settledAt;

  const Settlement({
    required this.id,
    required this.messId,
    required this.year,
    required this.month,
    required this.calculatedAt,
    required this.items,
    this.status = SettlementStatus.pending,
    this.settledAt,
  });

  Settlement copyWith({
    String? id,
    String? messId,
    int? year,
    int? month,
    DateTime? calculatedAt,
    List<SettlementItem>? items,
    SettlementStatus? status,
    DateTime? settledAt,
  }) {
    return Settlement(
      id: id ?? this.id,
      messId: messId ?? this.messId,
      year: year ?? this.year,
      month: month ?? this.month,
      calculatedAt: calculatedAt ?? this.calculatedAt,
      items: items ?? this.items,
      status: status ?? this.status,
      settledAt: settledAt ?? this.settledAt,
    );
  }

  factory Settlement.fromJson(Map<String, dynamic> json) {
    return Settlement(
      id: json['id'] as String? ?? '',
      messId: json['messId'] as String? ?? '',
      year: (json['year'] ?? 2024) as int,
      month: (json['month'] ?? 1) as int,
      calculatedAt: DateTime.parse(json['calculatedAt'] as String),
      items: (json['items'] as List?)
              ?.map(
                  (e) => SettlementItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      status: _settlementStatusFromJson(json['status']),
      settledAt: json['settledAt'] != null
          ? DateTime.parse(json['settledAt'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'messId': messId,
      'year': year,
      'month': month,
      'calculatedAt': calculatedAt.toIso8601String(),
      'items': items.map((e) => e.toJson()).toList(),
      'status': status.name,
      'settledAt': settledAt?.toIso8601String(),
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Settlement &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          messId == other.messId &&
          year == other.year &&
          month == other.month &&
          calculatedAt == other.calculatedAt &&
          status == other.status &&
          settledAt == other.settledAt;

  @override
  int get hashCode => Object.hash(
        id,
        messId,
        year,
        month,
        calculatedAt,
        status,
        settledAt,
      );

  @override
  String toString() =>
      'Settlement(id: $id, messId: $messId, $month/$year, status: $status)';
}

/// Settlement Item
class SettlementItem {
  final String fromMemberId;
  final String toMemberId;
  final double amount;
  final bool isPaid;
  final DateTime? paidAt;
  final String? proofImagePath;
  final String? note;

  const SettlementItem({
    required this.fromMemberId,
    required this.toMemberId,
    required this.amount,
    this.isPaid = false,
    this.paidAt,
    this.proofImagePath,
    this.note,
  });

  SettlementItem copyWith({
    String? fromMemberId,
    String? toMemberId,
    double? amount,
    bool? isPaid,
    DateTime? paidAt,
    String? proofImagePath,
    String? note,
  }) {
    return SettlementItem(
      fromMemberId: fromMemberId ?? this.fromMemberId,
      toMemberId: toMemberId ?? this.toMemberId,
      amount: amount ?? this.amount,
      isPaid: isPaid ?? this.isPaid,
      paidAt: paidAt ?? this.paidAt,
      proofImagePath: proofImagePath ?? this.proofImagePath,
      note: note ?? this.note,
    );
  }

  factory SettlementItem.fromJson(Map<String, dynamic> json) {
    return SettlementItem(
      fromMemberId: json['fromMemberId'] as String? ?? '',
      toMemberId: json['toMemberId'] as String? ?? '',
      amount: (json['amount'] ?? 0).toDouble(),
      isPaid: json['isPaid'] ?? false,
      paidAt: json['paidAt'] != null
          ? DateTime.parse(json['paidAt'] as String)
          : null,
      proofImagePath: json['proofImagePath'] as String?,
      note: json['note'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'fromMemberId': fromMemberId,
      'toMemberId': toMemberId,
      'amount': amount,
      'isPaid': isPaid,
      'paidAt': paidAt?.toIso8601String(),
      'proofImagePath': proofImagePath,
      'note': note,
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SettlementItem &&
          runtimeType == other.runtimeType &&
          fromMemberId == other.fromMemberId &&
          toMemberId == other.toMemberId &&
          amount == other.amount &&
          isPaid == other.isPaid &&
          paidAt == other.paidAt &&
          proofImagePath == other.proofImagePath &&
          note == other.note;

  @override
  int get hashCode => Object.hash(
        fromMemberId,
        toMemberId,
        amount,
        isPaid,
        paidAt,
        proofImagePath,
        note,
      );

  @override
  String toString() =>
      'SettlementItem(from: $fromMemberId, to: $toMemberId, amount: $amount, paid: $isPaid)';
}

/// Settlement Payment
class SettlementPayment {
  final String id;
  final String settlementId;
  final String fromMemberId;
  final String toMemberId;
  final double amount;
  final DateTime paidAt;
  final String? proofImagePath;
  final String? note;
  final bool isConfirmed;

  const SettlementPayment({
    required this.id,
    required this.settlementId,
    required this.fromMemberId,
    required this.toMemberId,
    required this.amount,
    required this.paidAt,
    this.proofImagePath,
    this.note,
    this.isConfirmed = false,
  });

  SettlementPayment copyWith({
    String? id,
    String? settlementId,
    String? fromMemberId,
    String? toMemberId,
    double? amount,
    DateTime? paidAt,
    String? proofImagePath,
    String? note,
    bool? isConfirmed,
  }) {
    return SettlementPayment(
      id: id ?? this.id,
      settlementId: settlementId ?? this.settlementId,
      fromMemberId: fromMemberId ?? this.fromMemberId,
      toMemberId: toMemberId ?? this.toMemberId,
      amount: amount ?? this.amount,
      paidAt: paidAt ?? this.paidAt,
      proofImagePath: proofImagePath ?? this.proofImagePath,
      note: note ?? this.note,
      isConfirmed: isConfirmed ?? this.isConfirmed,
    );
  }

  factory SettlementPayment.fromJson(Map<String, dynamic> json) {
    return SettlementPayment(
      id: json['id'] as String? ?? '',
      settlementId: json['settlementId'] as String? ?? '',
      fromMemberId: json['fromMemberId'] as String? ?? '',
      toMemberId: json['toMemberId'] as String? ?? '',
      amount: (json['amount'] ?? 0).toDouble(),
      paidAt: DateTime.parse(json['paidAt'] as String),
      proofImagePath: json['proofImagePath'] as String?,
      note: json['note'] as String?,
      isConfirmed: json['isConfirmed'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'settlementId': settlementId,
      'fromMemberId': fromMemberId,
      'toMemberId': toMemberId,
      'amount': amount,
      'paidAt': paidAt.toIso8601String(),
      'proofImagePath': proofImagePath,
      'note': note,
      'isConfirmed': isConfirmed,
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SettlementPayment &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          settlementId == other.settlementId &&
          fromMemberId == other.fromMemberId &&
          toMemberId == other.toMemberId &&
          amount == other.amount &&
          paidAt == other.paidAt &&
          proofImagePath == other.proofImagePath &&
          note == other.note &&
          isConfirmed == other.isConfirmed;

  @override
  int get hashCode => Object.hash(
        id,
        settlementId,
        fromMemberId,
        toMemberId,
        amount,
        paidAt,
        proofImagePath,
        note,
        isConfirmed,
      );

  @override
  String toString() =>
      'SettlementPayment(id: $id, from: $fromMemberId, to: $toMemberId, amount: $amount, confirmed: $isConfirmed)';
}

/// Member Balance Summary
class MemberBalanceSummary {
  final String memberId;
  final double totalBazar;
  final double mealCost;
  final double monthlyShare;
  final double balance;

  const MemberBalanceSummary({
    required this.memberId,
    required this.totalBazar,
    required this.mealCost,
    required this.monthlyShare,
    required this.balance,
  });

  MemberBalanceSummary copyWith({
    String? memberId,
    double? totalBazar,
    double? mealCost,
    double? monthlyShare,
    double? balance,
  }) {
    return MemberBalanceSummary(
      memberId: memberId ?? this.memberId,
      totalBazar: totalBazar ?? this.totalBazar,
      mealCost: mealCost ?? this.mealCost,
      monthlyShare: monthlyShare ?? this.monthlyShare,
      balance: balance ?? this.balance,
    );
  }

  factory MemberBalanceSummary.fromJson(Map<String, dynamic> json) {
    return MemberBalanceSummary(
      memberId: json['memberId'] as String? ?? '',
      totalBazar: (json['totalBazar'] ?? 0).toDouble(),
      mealCost: (json['mealCost'] ?? 0).toDouble(),
      monthlyShare: (json['monthlyShare'] ?? 0).toDouble(),
      balance: (json['balance'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'memberId': memberId,
      'totalBazar': totalBazar,
      'mealCost': mealCost,
      'monthlyShare': monthlyShare,
      'balance': balance,
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MemberBalanceSummary &&
          runtimeType == other.runtimeType &&
          memberId == other.memberId &&
          totalBazar == other.totalBazar &&
          mealCost == other.mealCost &&
          monthlyShare == other.monthlyShare &&
          balance == other.balance;

  @override
  int get hashCode => Object.hash(
        memberId,
        totalBazar,
        mealCost,
        monthlyShare,
        balance,
      );

  @override
  String toString() =>
      'MemberBalanceSummary(memberId: $memberId, bazar: $totalBazar, mealCost: $mealCost, balance: $balance)';
}

// Helper function for enum parsing
SettlementStatus _settlementStatusFromJson(dynamic value) {
  if (value == null) return SettlementStatus.pending;
  try {
    return SettlementStatus.values.byName(value as String);
  } catch (_) {
    return SettlementStatus.pending;
  }
}
