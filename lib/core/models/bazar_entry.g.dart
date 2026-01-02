// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bazar_entry.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_BazarItem _$BazarItemFromJson(Map<String, dynamic> json) => _BazarItem(
  name: json['name'] as String,
  price: (json['price'] as num).toDouble(),
  quantity: json['quantity'] as String?,
  unit: json['unit'] as String?,
);

Map<String, dynamic> _$BazarItemToJson(_BazarItem instance) =>
    <String, dynamic>{
      'name': instance.name,
      'price': instance.price,
      'quantity': instance.quantity,
      'unit': instance.unit,
    };

_BazarEntry _$BazarEntryFromJson(Map<String, dynamic> json) => _BazarEntry(
  id: json['id'] as String,
  memberId: json['memberId'] as String,
  date: DateTime.parse(json['date'] as String),
  amount: (json['amount'] as num).toDouble(),
  description: json['description'] as String?,
  items:
      (json['items'] as List<dynamic>?)
          ?.map((e) => BazarItem.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  isItemized: json['isItemized'] as bool? ?? false,
  photoUrls:
      (json['photoUrls'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
  receiptUrls:
      (json['receiptUrls'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
  createdAt: json['createdAt'] == null
      ? null
      : DateTime.parse(json['createdAt'] as String),
);

Map<String, dynamic> _$BazarEntryToJson(_BazarEntry instance) =>
    <String, dynamic>{
      'id': instance.id,
      'memberId': instance.memberId,
      'date': instance.date.toIso8601String(),
      'amount': instance.amount,
      'description': instance.description,
      'items': instance.items,
      'isItemized': instance.isItemized,
      'photoUrls': instance.photoUrls,
      'receiptUrls': instance.receiptUrls,
      'createdAt': instance.createdAt?.toIso8601String(),
    };
