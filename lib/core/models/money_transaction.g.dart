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
      isSettled: json['isSettled'] as bool? ?? false,
      settledAt: json['settledAt'] == null
          ? null
          : DateTime.parse(json['settledAt'] as String),
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
      'isSettled': instance.isSettled,
      'settledAt': instance.settledAt?.toIso8601String(),
      'createdAt': instance.createdAt?.toIso8601String(),
    };
