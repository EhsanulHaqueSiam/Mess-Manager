// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'member.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_FoodPreference _$FoodPreferenceFromJson(Map<String, dynamic> json) =>
    _FoodPreference(
      type: $enumDecode(_$RestrictionTypeEnumMap, json['type']),
      allergen: json['allergen'] as String?,
      notes: json['notes'] as String?,
      daysActive:
          (json['daysActive'] as List<dynamic>?)
              ?.map((e) => (e as num).toInt())
              .toList() ??
          const [],
    );

Map<String, dynamic> _$FoodPreferenceToJson(_FoodPreference instance) =>
    <String, dynamic>{
      'type': _$RestrictionTypeEnumMap[instance.type]!,
      'allergen': instance.allergen,
      'notes': instance.notes,
      'daysActive': instance.daysActive,
    };

const _$RestrictionTypeEnumMap = {
  RestrictionType.none: 'none',
  RestrictionType.noBeef: 'noBeef',
  RestrictionType.noPork: 'noPork',
  RestrictionType.vegetarian: 'vegetarian',
  RestrictionType.vegan: 'vegan',
  RestrictionType.allergic: 'allergic',
  RestrictionType.other: 'other',
};

_Member _$MemberFromJson(Map<String, dynamic> json) => _Member(
  id: json['id'] as String,
  name: json['name'] as String,
  role:
      $enumDecodeNullable(_$MemberRoleEnumMap, json['role']) ??
      MemberRole.member,
  avatarUrl: json['avatarUrl'] as String?,
  phone: json['phone'] as String?,
  preferences:
      (json['preferences'] as List<dynamic>?)
          ?.map((e) => FoodPreference.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  balance: (json['balance'] as num?)?.toDouble() ?? 0.0,
  joinedAt: json['joinedAt'] == null
      ? null
      : DateTime.parse(json['joinedAt'] as String),
  activeFromDate: json['activeFromDate'] == null
      ? null
      : DateTime.parse(json['activeFromDate'] as String),
  activeToDate: json['activeToDate'] == null
      ? null
      : DateTime.parse(json['activeToDate'] as String),
  isActive: json['isActive'] as bool? ?? true,
);

Map<String, dynamic> _$MemberToJson(_Member instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'role': _$MemberRoleEnumMap[instance.role]!,
  'avatarUrl': instance.avatarUrl,
  'phone': instance.phone,
  'preferences': instance.preferences,
  'balance': instance.balance,
  'joinedAt': instance.joinedAt?.toIso8601String(),
  'activeFromDate': instance.activeFromDate?.toIso8601String(),
  'activeToDate': instance.activeToDate?.toIso8601String(),
  'isActive': instance.isActive,
};

const _$MemberRoleEnumMap = {
  MemberRole.superAdmin: 'superAdmin',
  MemberRole.admin: 'admin',
  MemberRole.mealManager: 'mealManager',
  MemberRole.maintenance: 'maintenance',
  MemberRole.member: 'member',
  MemberRole.temp: 'temp',
  MemberRole.guest: 'guest',
};
