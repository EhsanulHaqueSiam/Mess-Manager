// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mess_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MessInfo _$MessInfoFromJson(Map<String, dynamic> json) => _MessInfo(
  wifiPassword: json['wifiPassword'] as String? ?? 'MessWifi@2026',
  landlordName: json['landlordName'] as String? ?? 'Mr. Rahim',
  landlordPhone: json['landlordPhone'] as String? ?? '+880 1712-345678',
  policePhone: json['policePhone'] as String? ?? '999',
  fireServicePhone: json['fireServicePhone'] as String? ?? '199',
  ambulancePhone: json['ambulancePhone'] as String? ?? '199',
  gateCloseTime: json['gateCloseTime'] as String? ?? '10 PM',
  wifiOffTime: json['wifiOffTime'] as String? ?? '11 PM',
  rule1: json['rule1'] as String? ?? 'No smoking inside rooms',
  rule2: json['rule2'] as String? ?? 'Guests allowed until 8 PM',
  descoAccount: json['descoAccount'] as String? ?? '12345678',
  gasAccount: json['gasAccount'] as String? ?? '1234',
);

Map<String, dynamic> _$MessInfoToJson(_MessInfo instance) => <String, dynamic>{
  'wifiPassword': instance.wifiPassword,
  'landlordName': instance.landlordName,
  'landlordPhone': instance.landlordPhone,
  'policePhone': instance.policePhone,
  'fireServicePhone': instance.fireServicePhone,
  'ambulancePhone': instance.ambulancePhone,
  'gateCloseTime': instance.gateCloseTime,
  'wifiOffTime': instance.wifiOffTime,
  'rule1': instance.rule1,
  'rule2': instance.rule2,
  'descoAccount': instance.descoAccount,
  'gasAccount': instance.gasAccount,
};
