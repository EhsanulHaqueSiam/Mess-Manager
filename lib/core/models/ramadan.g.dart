// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ramadan.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_RamadanSeason _$RamadanSeasonFromJson(Map<String, dynamic> json) =>
    _RamadanSeason(
      id: json['id'] as String,
      messId: json['messId'] as String,
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: DateTime.parse(json['endDate'] as String),
      year: (json['year'] as num).toInt(),
      optedInMemberIds:
          (json['optedInMemberIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      isActive: json['isActive'] as bool? ?? true,
      isSettled: json['isSettled'] as bool? ?? false,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$RamadanSeasonToJson(_RamadanSeason instance) =>
    <String, dynamic>{
      'id': instance.id,
      'messId': instance.messId,
      'startDate': instance.startDate.toIso8601String(),
      'endDate': instance.endDate.toIso8601String(),
      'year': instance.year,
      'optedInMemberIds': instance.optedInMemberIds,
      'isActive': instance.isActive,
      'isSettled': instance.isSettled,
      'createdAt': instance.createdAt?.toIso8601String(),
    };

_RamadanMeal _$RamadanMealFromJson(Map<String, dynamic> json) => _RamadanMeal(
  id: json['id'] as String,
  seasonId: json['seasonId'] as String,
  memberId: json['memberId'] as String,
  date: DateTime.parse(json['date'] as String),
  type: $enumDecode(_$RamadanMealTypeEnumMap, json['type']),
  count: (json['count'] as num?)?.toInt() ?? 1,
  guestName: json['guestName'] as String?,
  createdAt: json['createdAt'] == null
      ? null
      : DateTime.parse(json['createdAt'] as String),
);

Map<String, dynamic> _$RamadanMealToJson(_RamadanMeal instance) =>
    <String, dynamic>{
      'id': instance.id,
      'seasonId': instance.seasonId,
      'memberId': instance.memberId,
      'date': instance.date.toIso8601String(),
      'type': _$RamadanMealTypeEnumMap[instance.type]!,
      'count': instance.count,
      'guestName': instance.guestName,
      'createdAt': instance.createdAt?.toIso8601String(),
    };

const _$RamadanMealTypeEnumMap = {
  RamadanMealType.sehri: 'sehri',
  RamadanMealType.iftar: 'iftar',
};

_RamadanBazar _$RamadanBazarFromJson(Map<String, dynamic> json) =>
    _RamadanBazar(
      id: json['id'] as String,
      seasonId: json['seasonId'] as String,
      memberId: json['memberId'] as String,
      date: DateTime.parse(json['date'] as String),
      amount: (json['amount'] as num).toDouble(),
      description: json['description'] as String?,
      isForSehri: json['isForSehri'] as bool? ?? false,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$RamadanBazarToJson(_RamadanBazar instance) =>
    <String, dynamic>{
      'id': instance.id,
      'seasonId': instance.seasonId,
      'memberId': instance.memberId,
      'date': instance.date.toIso8601String(),
      'amount': instance.amount,
      'description': instance.description,
      'isForSehri': instance.isForSehri,
      'createdAt': instance.createdAt?.toIso8601String(),
    };

_RamadanBalance _$RamadanBalanceFromJson(Map<String, dynamic> json) =>
    _RamadanBalance(
      memberId: json['memberId'] as String,
      seasonId: json['seasonId'] as String,
      totalMeals: (json['totalMeals'] as num).toInt(),
      totalBazar: (json['totalBazar'] as num).toDouble(),
      mealCost: (json['mealCost'] as num).toDouble(),
      balance: (json['balance'] as num).toDouble(),
    );

Map<String, dynamic> _$RamadanBalanceToJson(_RamadanBalance instance) =>
    <String, dynamic>{
      'memberId': instance.memberId,
      'seasonId': instance.seasonId,
      'totalMeals': instance.totalMeals,
      'totalBazar': instance.totalBazar,
      'mealCost': instance.mealCost,
      'balance': instance.balance,
    };
