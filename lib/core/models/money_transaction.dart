import 'package:freezed_annotation/freezed_annotation.dart';

part 'money_transaction.freezed.dart';
part 'money_transaction.g.dart';

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
@freezed
sealed class MoneyTransaction with _$MoneyTransaction {
  const factory MoneyTransaction({
    required String id,
    required String fromMemberId,
    required String toMemberId,
    required double amount,
    required DateTime date,
    String? description,
    String? note,

    /// Photo proof URL - required for amounts > 500
    String? photoProofUrl,

    /// Receiver's response note (for rejection reason, etc.)
    String? responseNote,

    /// Current status of the transaction
    @Default(TransactionStatus.pending) TransactionStatus status,

    /// Legacy field - kept for backwards compatibility
    @Default(false) bool isSettled,
    DateTime? settledAt,
    DateTime? acceptedAt,
    DateTime? rejectedAt,
    DateTime? createdAt,
  }) = _MoneyTransaction;

  factory MoneyTransaction.fromJson(Map<String, dynamic> json) =>
      _$MoneyTransactionFromJson(json);
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
