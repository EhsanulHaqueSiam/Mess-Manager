import 'package:freezed_annotation/freezed_annotation.dart';

part 'mess_info.freezed.dart';
part 'mess_info.g.dart';

@freezed
sealed class MessInfo with _$MessInfo {
  const factory MessInfo({
    @Default('MessWifi@2026') String wifiPassword,
    @Default('Mr. Rahim') String landlordName,
    @Default('+880 1712-345678') String landlordPhone,
    @Default('999') String policePhone,
    @Default('199') String fireServicePhone,
    @Default('199') String ambulancePhone,
    @Default('10 PM') String gateCloseTime,
    @Default('11 PM') String wifiOffTime,
    @Default('No smoking inside rooms') String rule1,
    @Default('Guests allowed until 8 PM') String rule2,
    @Default('12345678') String descoAccount,
    @Default('1234') String gasAccount,
  }) = _MessInfo;

  factory MessInfo.fromJson(Map<String, dynamic> json) =>
      _$MessInfoFromJson(json);
}
