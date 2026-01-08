// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'mess_info.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MessInfo {

 String get wifiPassword; String get landlordName; String get landlordPhone; String get policePhone; String get fireServicePhone; String get ambulancePhone; String get gateCloseTime; String get wifiOffTime; String get rule1; String get rule2; String get descoAccount; String get gasAccount;
/// Create a copy of MessInfo
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MessInfoCopyWith<MessInfo> get copyWith => _$MessInfoCopyWithImpl<MessInfo>(this as MessInfo, _$identity);

  /// Serializes this MessInfo to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MessInfo&&(identical(other.wifiPassword, wifiPassword) || other.wifiPassword == wifiPassword)&&(identical(other.landlordName, landlordName) || other.landlordName == landlordName)&&(identical(other.landlordPhone, landlordPhone) || other.landlordPhone == landlordPhone)&&(identical(other.policePhone, policePhone) || other.policePhone == policePhone)&&(identical(other.fireServicePhone, fireServicePhone) || other.fireServicePhone == fireServicePhone)&&(identical(other.ambulancePhone, ambulancePhone) || other.ambulancePhone == ambulancePhone)&&(identical(other.gateCloseTime, gateCloseTime) || other.gateCloseTime == gateCloseTime)&&(identical(other.wifiOffTime, wifiOffTime) || other.wifiOffTime == wifiOffTime)&&(identical(other.rule1, rule1) || other.rule1 == rule1)&&(identical(other.rule2, rule2) || other.rule2 == rule2)&&(identical(other.descoAccount, descoAccount) || other.descoAccount == descoAccount)&&(identical(other.gasAccount, gasAccount) || other.gasAccount == gasAccount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,wifiPassword,landlordName,landlordPhone,policePhone,fireServicePhone,ambulancePhone,gateCloseTime,wifiOffTime,rule1,rule2,descoAccount,gasAccount);

@override
String toString() {
  return 'MessInfo(wifiPassword: $wifiPassword, landlordName: $landlordName, landlordPhone: $landlordPhone, policePhone: $policePhone, fireServicePhone: $fireServicePhone, ambulancePhone: $ambulancePhone, gateCloseTime: $gateCloseTime, wifiOffTime: $wifiOffTime, rule1: $rule1, rule2: $rule2, descoAccount: $descoAccount, gasAccount: $gasAccount)';
}


}

/// @nodoc
abstract mixin class $MessInfoCopyWith<$Res>  {
  factory $MessInfoCopyWith(MessInfo value, $Res Function(MessInfo) _then) = _$MessInfoCopyWithImpl;
@useResult
$Res call({
 String wifiPassword, String landlordName, String landlordPhone, String policePhone, String fireServicePhone, String ambulancePhone, String gateCloseTime, String wifiOffTime, String rule1, String rule2, String descoAccount, String gasAccount
});




}
/// @nodoc
class _$MessInfoCopyWithImpl<$Res>
    implements $MessInfoCopyWith<$Res> {
  _$MessInfoCopyWithImpl(this._self, this._then);

  final MessInfo _self;
  final $Res Function(MessInfo) _then;

/// Create a copy of MessInfo
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? wifiPassword = null,Object? landlordName = null,Object? landlordPhone = null,Object? policePhone = null,Object? fireServicePhone = null,Object? ambulancePhone = null,Object? gateCloseTime = null,Object? wifiOffTime = null,Object? rule1 = null,Object? rule2 = null,Object? descoAccount = null,Object? gasAccount = null,}) {
  return _then(_self.copyWith(
wifiPassword: null == wifiPassword ? _self.wifiPassword : wifiPassword // ignore: cast_nullable_to_non_nullable
as String,landlordName: null == landlordName ? _self.landlordName : landlordName // ignore: cast_nullable_to_non_nullable
as String,landlordPhone: null == landlordPhone ? _self.landlordPhone : landlordPhone // ignore: cast_nullable_to_non_nullable
as String,policePhone: null == policePhone ? _self.policePhone : policePhone // ignore: cast_nullable_to_non_nullable
as String,fireServicePhone: null == fireServicePhone ? _self.fireServicePhone : fireServicePhone // ignore: cast_nullable_to_non_nullable
as String,ambulancePhone: null == ambulancePhone ? _self.ambulancePhone : ambulancePhone // ignore: cast_nullable_to_non_nullable
as String,gateCloseTime: null == gateCloseTime ? _self.gateCloseTime : gateCloseTime // ignore: cast_nullable_to_non_nullable
as String,wifiOffTime: null == wifiOffTime ? _self.wifiOffTime : wifiOffTime // ignore: cast_nullable_to_non_nullable
as String,rule1: null == rule1 ? _self.rule1 : rule1 // ignore: cast_nullable_to_non_nullable
as String,rule2: null == rule2 ? _self.rule2 : rule2 // ignore: cast_nullable_to_non_nullable
as String,descoAccount: null == descoAccount ? _self.descoAccount : descoAccount // ignore: cast_nullable_to_non_nullable
as String,gasAccount: null == gasAccount ? _self.gasAccount : gasAccount // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [MessInfo].
extension MessInfoPatterns on MessInfo {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MessInfo value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MessInfo() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MessInfo value)  $default,){
final _that = this;
switch (_that) {
case _MessInfo():
return $default(_that);}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MessInfo value)?  $default,){
final _that = this;
switch (_that) {
case _MessInfo() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String wifiPassword,  String landlordName,  String landlordPhone,  String policePhone,  String fireServicePhone,  String ambulancePhone,  String gateCloseTime,  String wifiOffTime,  String rule1,  String rule2,  String descoAccount,  String gasAccount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MessInfo() when $default != null:
return $default(_that.wifiPassword,_that.landlordName,_that.landlordPhone,_that.policePhone,_that.fireServicePhone,_that.ambulancePhone,_that.gateCloseTime,_that.wifiOffTime,_that.rule1,_that.rule2,_that.descoAccount,_that.gasAccount);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String wifiPassword,  String landlordName,  String landlordPhone,  String policePhone,  String fireServicePhone,  String ambulancePhone,  String gateCloseTime,  String wifiOffTime,  String rule1,  String rule2,  String descoAccount,  String gasAccount)  $default,) {final _that = this;
switch (_that) {
case _MessInfo():
return $default(_that.wifiPassword,_that.landlordName,_that.landlordPhone,_that.policePhone,_that.fireServicePhone,_that.ambulancePhone,_that.gateCloseTime,_that.wifiOffTime,_that.rule1,_that.rule2,_that.descoAccount,_that.gasAccount);}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String wifiPassword,  String landlordName,  String landlordPhone,  String policePhone,  String fireServicePhone,  String ambulancePhone,  String gateCloseTime,  String wifiOffTime,  String rule1,  String rule2,  String descoAccount,  String gasAccount)?  $default,) {final _that = this;
switch (_that) {
case _MessInfo() when $default != null:
return $default(_that.wifiPassword,_that.landlordName,_that.landlordPhone,_that.policePhone,_that.fireServicePhone,_that.ambulancePhone,_that.gateCloseTime,_that.wifiOffTime,_that.rule1,_that.rule2,_that.descoAccount,_that.gasAccount);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MessInfo implements MessInfo {
  const _MessInfo({this.wifiPassword = 'MessWifi@2026', this.landlordName = 'Mr. Rahim', this.landlordPhone = '+880 1712-345678', this.policePhone = '999', this.fireServicePhone = '199', this.ambulancePhone = '199', this.gateCloseTime = '10 PM', this.wifiOffTime = '11 PM', this.rule1 = 'No smoking inside rooms', this.rule2 = 'Guests allowed until 8 PM', this.descoAccount = '12345678', this.gasAccount = '1234'});
  factory _MessInfo.fromJson(Map<String, dynamic> json) => _$MessInfoFromJson(json);

@override@JsonKey() final  String wifiPassword;
@override@JsonKey() final  String landlordName;
@override@JsonKey() final  String landlordPhone;
@override@JsonKey() final  String policePhone;
@override@JsonKey() final  String fireServicePhone;
@override@JsonKey() final  String ambulancePhone;
@override@JsonKey() final  String gateCloseTime;
@override@JsonKey() final  String wifiOffTime;
@override@JsonKey() final  String rule1;
@override@JsonKey() final  String rule2;
@override@JsonKey() final  String descoAccount;
@override@JsonKey() final  String gasAccount;

/// Create a copy of MessInfo
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MessInfoCopyWith<_MessInfo> get copyWith => __$MessInfoCopyWithImpl<_MessInfo>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MessInfoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MessInfo&&(identical(other.wifiPassword, wifiPassword) || other.wifiPassword == wifiPassword)&&(identical(other.landlordName, landlordName) || other.landlordName == landlordName)&&(identical(other.landlordPhone, landlordPhone) || other.landlordPhone == landlordPhone)&&(identical(other.policePhone, policePhone) || other.policePhone == policePhone)&&(identical(other.fireServicePhone, fireServicePhone) || other.fireServicePhone == fireServicePhone)&&(identical(other.ambulancePhone, ambulancePhone) || other.ambulancePhone == ambulancePhone)&&(identical(other.gateCloseTime, gateCloseTime) || other.gateCloseTime == gateCloseTime)&&(identical(other.wifiOffTime, wifiOffTime) || other.wifiOffTime == wifiOffTime)&&(identical(other.rule1, rule1) || other.rule1 == rule1)&&(identical(other.rule2, rule2) || other.rule2 == rule2)&&(identical(other.descoAccount, descoAccount) || other.descoAccount == descoAccount)&&(identical(other.gasAccount, gasAccount) || other.gasAccount == gasAccount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,wifiPassword,landlordName,landlordPhone,policePhone,fireServicePhone,ambulancePhone,gateCloseTime,wifiOffTime,rule1,rule2,descoAccount,gasAccount);

@override
String toString() {
  return 'MessInfo(wifiPassword: $wifiPassword, landlordName: $landlordName, landlordPhone: $landlordPhone, policePhone: $policePhone, fireServicePhone: $fireServicePhone, ambulancePhone: $ambulancePhone, gateCloseTime: $gateCloseTime, wifiOffTime: $wifiOffTime, rule1: $rule1, rule2: $rule2, descoAccount: $descoAccount, gasAccount: $gasAccount)';
}


}

/// @nodoc
abstract mixin class _$MessInfoCopyWith<$Res> implements $MessInfoCopyWith<$Res> {
  factory _$MessInfoCopyWith(_MessInfo value, $Res Function(_MessInfo) _then) = __$MessInfoCopyWithImpl;
@override @useResult
$Res call({
 String wifiPassword, String landlordName, String landlordPhone, String policePhone, String fireServicePhone, String ambulancePhone, String gateCloseTime, String wifiOffTime, String rule1, String rule2, String descoAccount, String gasAccount
});




}
/// @nodoc
class __$MessInfoCopyWithImpl<$Res>
    implements _$MessInfoCopyWith<$Res> {
  __$MessInfoCopyWithImpl(this._self, this._then);

  final _MessInfo _self;
  final $Res Function(_MessInfo) _then;

/// Create a copy of MessInfo
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? wifiPassword = null,Object? landlordName = null,Object? landlordPhone = null,Object? policePhone = null,Object? fireServicePhone = null,Object? ambulancePhone = null,Object? gateCloseTime = null,Object? wifiOffTime = null,Object? rule1 = null,Object? rule2 = null,Object? descoAccount = null,Object? gasAccount = null,}) {
  return _then(_MessInfo(
wifiPassword: null == wifiPassword ? _self.wifiPassword : wifiPassword // ignore: cast_nullable_to_non_nullable
as String,landlordName: null == landlordName ? _self.landlordName : landlordName // ignore: cast_nullable_to_non_nullable
as String,landlordPhone: null == landlordPhone ? _self.landlordPhone : landlordPhone // ignore: cast_nullable_to_non_nullable
as String,policePhone: null == policePhone ? _self.policePhone : policePhone // ignore: cast_nullable_to_non_nullable
as String,fireServicePhone: null == fireServicePhone ? _self.fireServicePhone : fireServicePhone // ignore: cast_nullable_to_non_nullable
as String,ambulancePhone: null == ambulancePhone ? _self.ambulancePhone : ambulancePhone // ignore: cast_nullable_to_non_nullable
as String,gateCloseTime: null == gateCloseTime ? _self.gateCloseTime : gateCloseTime // ignore: cast_nullable_to_non_nullable
as String,wifiOffTime: null == wifiOffTime ? _self.wifiOffTime : wifiOffTime // ignore: cast_nullable_to_non_nullable
as String,rule1: null == rule1 ? _self.rule1 : rule1 // ignore: cast_nullable_to_non_nullable
as String,rule2: null == rule2 ? _self.rule2 : rule2 // ignore: cast_nullable_to_non_nullable
as String,descoAccount: null == descoAccount ? _self.descoAccount : descoAccount // ignore: cast_nullable_to_non_nullable
as String,gasAccount: null == gasAccount ? _self.gasAccount : gasAccount // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
