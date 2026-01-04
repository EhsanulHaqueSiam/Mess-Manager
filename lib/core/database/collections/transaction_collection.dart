import 'package:isar_plus/isar_plus.dart';
import '../../models/money_transaction.dart';

part 'transaction_collection.g.dart';

/// Isar collection for MoneyTransaction data
@collection
class TransactionCollection {
  late int id;

  @Index()
  late String transactionId;

  @Index()
  late String fromMemberId;

  @Index()
  late String toMemberId;

  late double amount;

  late DateTime date;

  String? description;

  String? note;

  late bool isSettled;

  DateTime? settledAt;

  DateTime? createdAt;

  // ─────────────────────────────────────────────────────────────────────────
  // Model Converters
  // ─────────────────────────────────────────────────────────────────────────

  /// Convert to Freezed MoneyTransaction model
  MoneyTransaction toModel() {
    return MoneyTransaction(
      id: transactionId,
      fromMemberId: fromMemberId,
      toMemberId: toMemberId,
      amount: amount,
      date: date,
      description: description,
      note: note,
      isSettled: isSettled,
      settledAt: settledAt,
      createdAt: createdAt,
    );
  }

  /// Create from Freezed MoneyTransaction model
  static TransactionCollection fromModel(MoneyTransaction t) {
    return TransactionCollection()
      ..transactionId = t.id
      ..fromMemberId = t.fromMemberId
      ..toMemberId = t.toMemberId
      ..amount = t.amount
      ..date = t.date
      ..description = t.description
      ..note = t.note
      ..isSettled = t.isSettled
      ..settledAt = t.settledAt
      ..createdAt = t.createdAt;
  }
}
