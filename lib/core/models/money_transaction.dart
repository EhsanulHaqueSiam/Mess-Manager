import 'package:freezed_annotation/freezed_annotation.dart';

part 'money_transaction.freezed.dart';
part 'money_transaction.g.dart';

/// Money transaction between members
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
    @Default(false) bool isSettled,
    DateTime? settledAt,
    DateTime? createdAt,
  }) = _MoneyTransaction;

  factory MoneyTransaction.fromJson(Map<String, dynamic> json) =>
      _$MoneyTransactionFromJson(json);
}
