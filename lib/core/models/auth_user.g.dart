// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AuthUser _$AuthUserFromJson(Map<String, dynamic> json) => _AuthUser(
  id: json['id'] as String,
  email: json['email'] as String,
  name: json['name'] as String,
  phone: json['phone'] as String?,
  avatarUrl: json['avatarUrl'] as String?,
  createdAt: DateTime.parse(json['createdAt'] as String),
  currentMessId: json['currentMessId'] as String?,
);

Map<String, dynamic> _$AuthUserToJson(_AuthUser instance) => <String, dynamic>{
  'id': instance.id,
  'email': instance.email,
  'name': instance.name,
  'phone': instance.phone,
  'avatarUrl': instance.avatarUrl,
  'createdAt': instance.createdAt.toIso8601String(),
  'currentMessId': instance.currentMessId,
};

_Mess _$MessFromJson(Map<String, dynamic> json) => _Mess(
  id: json['id'] as String,
  name: json['name'] as String,
  address: json['address'] as String,
  createdById: json['createdById'] as String,
  createdAt: DateTime.parse(json['createdAt'] as String),
  memberIds:
      (json['memberIds'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
  inviteCode: json['inviteCode'] as String?,
);

Map<String, dynamic> _$MessToJson(_Mess instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'address': instance.address,
  'createdById': instance.createdById,
  'createdAt': instance.createdAt.toIso8601String(),
  'memberIds': instance.memberIds,
  'inviteCode': instance.inviteCode,
};
