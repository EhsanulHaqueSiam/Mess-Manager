// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'unified_entry.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UnifiedEntry _$UnifiedEntryFromJson(Map<String, dynamic> json) =>
    _UnifiedEntry(
      id: json['id'] as String,
      memberId: json['memberId'] as String,
      date: DateTime.parse(json['date'] as String),
      amount: (json['amount'] as num).toDouble(),
      description: json['description'] as String?,
      type:
          $enumDecodeNullable(_$EntryTypeEnumMap, json['type']) ??
          EntryType.mealBazar,
      monthlyCategory: $enumDecodeNullable(
        _$MonthlyCategoryEnumMap,
        json['monthlyCategory'],
      ),
      photoUrls:
          (json['photoUrls'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      receiptUrls:
          (json['receiptUrls'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      isAutoDetected: json['isAutoDetected'] as bool? ?? true,
      items:
          (json['items'] as List<dynamic>?)
              ?.map((e) => UnifiedEntryItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$UnifiedEntryToJson(_UnifiedEntry instance) =>
    <String, dynamic>{
      'id': instance.id,
      'memberId': instance.memberId,
      'date': instance.date.toIso8601String(),
      'amount': instance.amount,
      'description': instance.description,
      'type': _$EntryTypeEnumMap[instance.type]!,
      'monthlyCategory': _$MonthlyCategoryEnumMap[instance.monthlyCategory],
      'photoUrls': instance.photoUrls,
      'receiptUrls': instance.receiptUrls,
      'isAutoDetected': instance.isAutoDetected,
      'items': instance.items,
      'createdAt': instance.createdAt?.toIso8601String(),
    };

const _$EntryTypeEnumMap = {
  EntryType.mealBazar: 'mealBazar',
  EntryType.monthly: 'monthly',
  EntryType.fixed: 'fixed',
};

const _$MonthlyCategoryEnumMap = {
  MonthlyCategory.rent: 'rent',
  MonthlyCategory.electricity: 'electricity',
  MonthlyCategory.gas: 'gas',
  MonthlyCategory.wifi: 'wifi',
  MonthlyCategory.water: 'water',
  MonthlyCategory.maid: 'maid',
  MonthlyCategory.garbage: 'garbage',
  MonthlyCategory.soap: 'soap',
  MonthlyCategory.tissue: 'tissue',
  MonthlyCategory.toothpaste: 'toothpaste',
  MonthlyCategory.filter: 'filter',
  MonthlyCategory.coil: 'coil',
  MonthlyCategory.other: 'other',
};

_UnifiedEntryItem _$UnifiedEntryItemFromJson(Map<String, dynamic> json) =>
    _UnifiedEntryItem(
      name: json['name'] as String,
      price: (json['price'] as num).toDouble(),
      type: $enumDecodeNullable(_$EntryTypeEnumMap, json['type']),
      category: $enumDecodeNullable(_$MonthlyCategoryEnumMap, json['category']),
    );

Map<String, dynamic> _$UnifiedEntryItemToJson(_UnifiedEntryItem instance) =>
    <String, dynamic>{
      'name': instance.name,
      'price': instance.price,
      'type': _$EntryTypeEnumMap[instance.type],
      'category': _$MonthlyCategoryEnumMap[instance.category],
    };
