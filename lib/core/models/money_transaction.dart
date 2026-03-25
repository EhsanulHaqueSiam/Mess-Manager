/// Transaction status for request/confirmation flow
enum TransactionStatus {
  /// Transaction request created, awaiting receiver confirmation
  pending,

  /// Receiver accepted the transaction request
  accepted,

  /// Receiver rejected the transaction request
  rejected,

  /// Transaction has been settled/paid
  settled,
}

/// Money transaction between members
///
/// Flow:
/// 1. Sender creates transaction (status: pending)
/// 2. Receiver accepts or rejects
/// 3. If accepted, sender pays and marks as settled
///
/// Photo proof required for amounts > 500 BDT
class MoneyTransaction {
  final String id;
  final String fromMemberId;
  final String toMemberId;
  final double amount;
  final DateTime date;
  final String? description;
  final String? note;

  /// Photo proof URL - required for amounts > 500
  final String? photoProofUrl;

  /// Receiver's response note (for rejection reason, etc.)
  final String? responseNote;

  /// Current status of the transaction
  final TransactionStatus status;

  /// Legacy field - kept for backwards compatibility
  final bool isSettled;
  final DateTime? settledAt;
  final DateTime? acceptedAt;
  final DateTime? rejectedAt;
  final DateTime? createdAt;

  const MoneyTransaction({
    required this.id,
    required this.fromMemberId,
    required this.toMemberId,
    required this.amount,
    required this.date,
    this.description,
    this.note,
    this.photoProofUrl,
    this.responseNote,
    this.status = TransactionStatus.pending,
    this.isSettled = false,
    this.settledAt,
    this.acceptedAt,
    this.rejectedAt,
    this.createdAt,
  });

  MoneyTransaction copyWith({
    String? id,
    String? fromMemberId,
    String? toMemberId,
    double? amount,
    DateTime? date,
    String? description,
    String? note,
    String? photoProofUrl,
    String? responseNote,
    TransactionStatus? status,
    bool? isSettled,
    DateTime? settledAt,
    DateTime? acceptedAt,
    DateTime? rejectedAt,
    DateTime? createdAt,
  }) {
    return MoneyTransaction(
      id: id ?? this.id,
      fromMemberId: fromMemberId ?? this.fromMemberId,
      toMemberId: toMemberId ?? this.toMemberId,
      amount: amount ?? this.amount,
      date: date ?? this.date,
      description: description ?? this.description,
      note: note ?? this.note,
      photoProofUrl: photoProofUrl ?? this.photoProofUrl,
      responseNote: responseNote ?? this.responseNote,
      status: status ?? this.status,
      isSettled: isSettled ?? this.isSettled,
      settledAt: settledAt ?? this.settledAt,
      acceptedAt: acceptedAt ?? this.acceptedAt,
      rejectedAt: rejectedAt ?? this.rejectedAt,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  factory MoneyTransaction.fromJson(Map<String, dynamic> json) {
    return MoneyTransaction(
      id: json['id'] as String,
      fromMemberId: json['fromMemberId'] as String,
      toMemberId: json['toMemberId'] as String,
      amount: (json['amount'] ?? 0).toDouble(),
      date: DateTime.parse(json['date'] as String),
      description: json['description'] as String?,
      note: json['note'] as String?,
      photoProofUrl: json['photoProofUrl'] as String?,
      responseNote: json['responseNote'] as String?,
      status: TransactionStatus.values.byName(
        json['status'] as String? ?? 'pending',
      ),
      isSettled: json['isSettled'] as bool? ?? false,
      settledAt: json['settledAt'] != null
          ? DateTime.parse(json['settledAt'] as String)
          : null,
      acceptedAt: json['acceptedAt'] != null
          ? DateTime.parse(json['acceptedAt'] as String)
          : null,
      rejectedAt: json['rejectedAt'] != null
          ? DateTime.parse(json['rejectedAt'] as String)
          : null,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fromMemberId': fromMemberId,
      'toMemberId': toMemberId,
      'amount': amount,
      'date': date.toIso8601String(),
      'description': description,
      'note': note,
      'photoProofUrl': photoProofUrl,
      'responseNote': responseNote,
      'status': status.name,
      'isSettled': isSettled,
      'settledAt': settledAt?.toIso8601String(),
      'acceptedAt': acceptedAt?.toIso8601String(),
      'rejectedAt': rejectedAt?.toIso8601String(),
      'createdAt': createdAt?.toIso8601String(),
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MoneyTransaction &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          fromMemberId == other.fromMemberId &&
          toMemberId == other.toMemberId &&
          amount == other.amount &&
          date == other.date &&
          description == other.description &&
          note == other.note &&
          photoProofUrl == other.photoProofUrl &&
          responseNote == other.responseNote &&
          status == other.status &&
          isSettled == other.isSettled &&
          settledAt == other.settledAt &&
          acceptedAt == other.acceptedAt &&
          rejectedAt == other.rejectedAt &&
          createdAt == other.createdAt;

  @override
  int get hashCode => Object.hash(
        id,
        fromMemberId,
        toMemberId,
        amount,
        date,
        description,
        note,
        photoProofUrl,
        responseNote,
        status,
        isSettled,
        settledAt,
        acceptedAt,
        rejectedAt,
        createdAt,
      );

  @override
  String toString() {
    return 'MoneyTransaction(id: $id, fromMemberId: $fromMemberId, toMemberId: $toMemberId, amount: $amount, date: $date, status: $status, isSettled: $isSettled)';
  }
}

/// Extension for convenience methods
extension MoneyTransactionX on MoneyTransaction {
  /// Whether this transaction requires photo proof (amount > 500)
  bool get requiresPhotoProof => amount > 500;

  /// Whether photo proof is provided
  bool get hasPhotoProof => photoProofUrl != null && photoProofUrl!.isNotEmpty;

  /// Whether photo proof requirement is satisfied
  bool get photoProofSatisfied => !requiresPhotoProof || hasPhotoProof;

  /// Whether this transaction can be accepted by receiver
  bool get canBeAccepted => status == TransactionStatus.pending;

  /// Whether this transaction can be settled
  bool get canBeSettled => status == TransactionStatus.accepted;
}
