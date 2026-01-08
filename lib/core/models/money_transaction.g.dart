// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'money_transaction.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MoneyTransaction _$MoneyTransactionFromJson(Map<String, dynamic> json) =>
    _MoneyTransaction(
      id: json['id'] as String,
      fromMemberId: json['fromMemberId'] as String,
      toMemberId: json['toMemberId'] as String,
      amount: (json['amount'] as num).toDouble(),
      date: DateTime.parse(json['date'] as String),
      description: json['description'] as String?,
      note: json['note'] as String?,
      photoProofUrl: json['photoProofUrl'] as String?,
      responseNote: json['responseNote'] as String?,
      status:
          $enumDecodeNullable(_$TransactionStatusEnumMap, json['status']) ??
          TransactionStatus.pending,
      isSettled: json['isSettled'] as bool? ?? false,
      settledAt: json['settledAt'] == null
          ? null
          : DateTime.parse(json['settledAt'] as String),
      acceptedAt: json['acceptedAt'] == null
          ? null
          : DateTime.parse(json['acceptedAt'] as String),
      rejectedAt: json['rejectedAt'] == null
          ? null
          : DateTime.parse(json['rejectedAt'] as String),
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$MoneyTransactionToJson(_MoneyTransaction instance) =>
    <String, dynamic>{
      'id': instance.id,
      'fromMemberId': instance.fromMemberId,
      'toMemberId': instance.toMemberId,
      'amount': instance.amount,
      'date': instance.date.toIso8601String(),
      'description': instance.description,
      'note': instance.note,
      'photoProofUrl': instance.photoProofUrl,
      'responseNote': instance.responseNote,
      'status': _$TransactionStatusEnumMap[instance.status]!,
      'isSettled': instance.isSettled,
      'settledAt': instance.settledAt?.toIso8601String(),
      'acceptedAt': instance.acceptedAt?.toIso8601String(),
      'rejectedAt': instance.rejectedAt?.toIso8601String(),
      'createdAt': instance.createdAt?.toIso8601String(),
    };

const _$TransactionStatusEnumMap = {
  TransactionStatus.pending: 'pending',
  TransactionStatus.accepted: 'accepted',
  TransactionStatus.rejected: 'rejected',
  TransactionStatus.settled: 'settled',
};
