import 'package:freezed_annotation/freezed_annotation.dart';

part 'settlement.freezed.dart';
part 'settlement.g.dart';

/// Settlement status
enum SettlementStatus { pending, partial, completed }

/// Monthly Settlement
@freezed
sealed class Settlement with _$Settlement {
  @JsonSerializable(explicitToJson: true)
  const factory Settlement({
    required String id,
    required String messId,
    required int year,
    required int month,
    required DateTime calculatedAt,
    required List<SettlementItem> items,
    @Default(SettlementStatus.pending) SettlementStatus status,
    DateTime? settledAt,
  }) = _Settlement;

  factory Settlement.fromJson(Map<String, dynamic> json) =>
      _$SettlementFromJson(json);
}

/// Settlement Item
@freezed
sealed class SettlementItem with _$SettlementItem {
  const factory SettlementItem({
    required String fromMemberId,
    required String toMemberId,
    required double amount,
    @Default(false) bool isPaid,
    DateTime? paidAt,
    String? proofImagePath,
    String? note,
  }) = _SettlementItem;

  factory SettlementItem.fromJson(Map<String, dynamic> json) =>
      _$SettlementItemFromJson(json);
}

/// Settlement Payment
@freezed
sealed class SettlementPayment with _$SettlementPayment {
  const factory SettlementPayment({
    required String id,
    required String settlementId,
    required String fromMemberId,
    required String toMemberId,
    required double amount,
    required DateTime paidAt,
    String? proofImagePath,
    String? note,
    @Default(false) bool isConfirmed,
  }) = _SettlementPayment;

  factory SettlementPayment.fromJson(Map<String, dynamic> json) =>
      _$SettlementPaymentFromJson(json);
}

/// Member Balance Summary
@freezed
sealed class MemberBalanceSummary with _$MemberBalanceSummary {
  const factory MemberBalanceSummary({
    required String memberId,
    required double totalBazar,
    required double mealCost,
    required double monthlyShare,
    required double balance,
  }) = _MemberBalanceSummary;

  factory MemberBalanceSummary.fromJson(Map<String, dynamic> json) =>
      _$MemberBalanceSummaryFromJson(json);
}
