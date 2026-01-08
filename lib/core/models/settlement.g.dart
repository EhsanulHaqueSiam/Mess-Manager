// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settlement.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Settlement _$SettlementFromJson(Map<String, dynamic> json) => _Settlement(
  id: json['id'] as String,
  messId: json['messId'] as String,
  year: (json['year'] as num).toInt(),
  month: (json['month'] as num).toInt(),
  calculatedAt: DateTime.parse(json['calculatedAt'] as String),
  items: (json['items'] as List<dynamic>)
      .map((e) => SettlementItem.fromJson(e as Map<String, dynamic>))
      .toList(),
  status:
      $enumDecodeNullable(_$SettlementStatusEnumMap, json['status']) ??
      SettlementStatus.pending,
  settledAt: json['settledAt'] == null
      ? null
      : DateTime.parse(json['settledAt'] as String),
);

Map<String, dynamic> _$SettlementToJson(_Settlement instance) =>
    <String, dynamic>{
      'id': instance.id,
      'messId': instance.messId,
      'year': instance.year,
      'month': instance.month,
      'calculatedAt': instance.calculatedAt.toIso8601String(),
      'items': instance.items.map((e) => e.toJson()).toList(),
      'status': _$SettlementStatusEnumMap[instance.status]!,
      'settledAt': instance.settledAt?.toIso8601String(),
    };

const _$SettlementStatusEnumMap = {
  SettlementStatus.pending: 'pending',
  SettlementStatus.partial: 'partial',
  SettlementStatus.completed: 'completed',
};

_SettlementItem _$SettlementItemFromJson(Map<String, dynamic> json) =>
    _SettlementItem(
      fromMemberId: json['fromMemberId'] as String,
      toMemberId: json['toMemberId'] as String,
      amount: (json['amount'] as num).toDouble(),
      isPaid: json['isPaid'] as bool? ?? false,
      paidAt: json['paidAt'] == null
          ? null
          : DateTime.parse(json['paidAt'] as String),
      proofImagePath: json['proofImagePath'] as String?,
      note: json['note'] as String?,
    );

Map<String, dynamic> _$SettlementItemToJson(_SettlementItem instance) =>
    <String, dynamic>{
      'fromMemberId': instance.fromMemberId,
      'toMemberId': instance.toMemberId,
      'amount': instance.amount,
      'isPaid': instance.isPaid,
      'paidAt': instance.paidAt?.toIso8601String(),
      'proofImagePath': instance.proofImagePath,
      'note': instance.note,
    };

_SettlementPayment _$SettlementPaymentFromJson(Map<String, dynamic> json) =>
    _SettlementPayment(
      id: json['id'] as String,
      settlementId: json['settlementId'] as String,
      fromMemberId: json['fromMemberId'] as String,
      toMemberId: json['toMemberId'] as String,
      amount: (json['amount'] as num).toDouble(),
      paidAt: DateTime.parse(json['paidAt'] as String),
      proofImagePath: json['proofImagePath'] as String?,
      note: json['note'] as String?,
      isConfirmed: json['isConfirmed'] as bool? ?? false,
    );

Map<String, dynamic> _$SettlementPaymentToJson(_SettlementPayment instance) =>
    <String, dynamic>{
      'id': instance.id,
      'settlementId': instance.settlementId,
      'fromMemberId': instance.fromMemberId,
      'toMemberId': instance.toMemberId,
      'amount': instance.amount,
      'paidAt': instance.paidAt.toIso8601String(),
      'proofImagePath': instance.proofImagePath,
      'note': instance.note,
      'isConfirmed': instance.isConfirmed,
    };

_MemberBalanceSummary _$MemberBalanceSummaryFromJson(
  Map<String, dynamic> json,
) => _MemberBalanceSummary(
  memberId: json['memberId'] as String,
  totalBazar: (json['totalBazar'] as num).toDouble(),
  mealCost: (json['mealCost'] as num).toDouble(),
  monthlyShare: (json['monthlyShare'] as num).toDouble(),
  balance: (json['balance'] as num).toDouble(),
);

Map<String, dynamic> _$MemberBalanceSummaryToJson(
  _MemberBalanceSummary instance,
) => <String, dynamic>{
  'memberId': instance.memberId,
  'totalBazar': instance.totalBazar,
  'mealCost': instance.mealCost,
  'monthlyShare': instance.monthlyShare,
  'balance': instance.balance,
};
