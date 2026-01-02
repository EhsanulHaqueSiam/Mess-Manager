// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bazar_list_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_BazarListItem _$BazarListItemFromJson(Map<String, dynamic> json) =>
    _BazarListItem(
      id: json['id'] as String,
      name: json['name'] as String,
      addedById: json['addedById'] as String,
      claimedById: json['claimedById'] as String?,
      status:
          $enumDecodeNullable(_$BazarListStatusEnumMap, json['status']) ??
          BazarListStatus.pending,
      quantity: json['quantity'] as String?,
      note: json['note'] as String?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      purchasedAt: json['purchasedAt'] == null
          ? null
          : DateTime.parse(json['purchasedAt'] as String),
    );

Map<String, dynamic> _$BazarListItemToJson(_BazarListItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'addedById': instance.addedById,
      'claimedById': instance.claimedById,
      'status': _$BazarListStatusEnumMap[instance.status]!,
      'quantity': instance.quantity,
      'note': instance.note,
      'createdAt': instance.createdAt?.toIso8601String(),
      'purchasedAt': instance.purchasedAt?.toIso8601String(),
    };

const _$BazarListStatusEnumMap = {
  BazarListStatus.pending: 'pending',
  BazarListStatus.claimed: 'claimed',
  BazarListStatus.purchased: 'purchased',
};
