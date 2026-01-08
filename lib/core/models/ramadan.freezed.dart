// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ramadan.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$RamadanSeason {

 String get id; String get messId; DateTime get startDate; DateTime get endDate; int get year; List<String> get optedInMemberIds; bool get isActive; bool get isSettled; DateTime? get createdAt;
/// Create a copy of RamadanSeason
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RamadanSeasonCopyWith<RamadanSeason> get copyWith => _$RamadanSeasonCopyWithImpl<RamadanSeason>(this as RamadanSeason, _$identity);

  /// Serializes this RamadanSeason to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RamadanSeason&&(identical(other.id, id) || other.id == id)&&(identical(other.messId, messId) || other.messId == messId)&&(identical(other.startDate, startDate) || other.startDate == startDate)&&(identical(other.endDate, endDate) || other.endDate == endDate)&&(identical(other.year, year) || other.year == year)&&const DeepCollectionEquality().equals(other.optedInMemberIds, optedInMemberIds)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.isSettled, isSettled) || other.isSettled == isSettled)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,messId,startDate,endDate,year,const DeepCollectionEquality().hash(optedInMemberIds),isActive,isSettled,createdAt);

@override
String toString() {
  return 'RamadanSeason(id: $id, messId: $messId, startDate: $startDate, endDate: $endDate, year: $year, optedInMemberIds: $optedInMemberIds, isActive: $isActive, isSettled: $isSettled, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $RamadanSeasonCopyWith<$Res>  {
  factory $RamadanSeasonCopyWith(RamadanSeason value, $Res Function(RamadanSeason) _then) = _$RamadanSeasonCopyWithImpl;
@useResult
$Res call({
 String id, String messId, DateTime startDate, DateTime endDate, int year, List<String> optedInMemberIds, bool isActive, bool isSettled, DateTime? createdAt
});




}
/// @nodoc
class _$RamadanSeasonCopyWithImpl<$Res>
    implements $RamadanSeasonCopyWith<$Res> {
  _$RamadanSeasonCopyWithImpl(this._self, this._then);

  final RamadanSeason _self;
  final $Res Function(RamadanSeason) _then;

/// Create a copy of RamadanSeason
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? messId = null,Object? startDate = null,Object? endDate = null,Object? year = null,Object? optedInMemberIds = null,Object? isActive = null,Object? isSettled = null,Object? createdAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,messId: null == messId ? _self.messId : messId // ignore: cast_nullable_to_non_nullable
as String,startDate: null == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as DateTime,endDate: null == endDate ? _self.endDate : endDate // ignore: cast_nullable_to_non_nullable
as DateTime,year: null == year ? _self.year : year // ignore: cast_nullable_to_non_nullable
as int,optedInMemberIds: null == optedInMemberIds ? _self.optedInMemberIds : optedInMemberIds // ignore: cast_nullable_to_non_nullable
as List<String>,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,isSettled: null == isSettled ? _self.isSettled : isSettled // ignore: cast_nullable_to_non_nullable
as bool,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [RamadanSeason].
extension RamadanSeasonPatterns on RamadanSeason {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RamadanSeason value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RamadanSeason() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RamadanSeason value)  $default,){
final _that = this;
switch (_that) {
case _RamadanSeason():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RamadanSeason value)?  $default,){
final _that = this;
switch (_that) {
case _RamadanSeason() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String messId,  DateTime startDate,  DateTime endDate,  int year,  List<String> optedInMemberIds,  bool isActive,  bool isSettled,  DateTime? createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RamadanSeason() when $default != null:
return $default(_that.id,_that.messId,_that.startDate,_that.endDate,_that.year,_that.optedInMemberIds,_that.isActive,_that.isSettled,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String messId,  DateTime startDate,  DateTime endDate,  int year,  List<String> optedInMemberIds,  bool isActive,  bool isSettled,  DateTime? createdAt)  $default,) {final _that = this;
switch (_that) {
case _RamadanSeason():
return $default(_that.id,_that.messId,_that.startDate,_that.endDate,_that.year,_that.optedInMemberIds,_that.isActive,_that.isSettled,_that.createdAt);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String messId,  DateTime startDate,  DateTime endDate,  int year,  List<String> optedInMemberIds,  bool isActive,  bool isSettled,  DateTime? createdAt)?  $default,) {final _that = this;
switch (_that) {
case _RamadanSeason() when $default != null:
return $default(_that.id,_that.messId,_that.startDate,_that.endDate,_that.year,_that.optedInMemberIds,_that.isActive,_that.isSettled,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RamadanSeason implements RamadanSeason {
  const _RamadanSeason({required this.id, required this.messId, required this.startDate, required this.endDate, required this.year, final  List<String> optedInMemberIds = const [], this.isActive = true, this.isSettled = false, this.createdAt}): _optedInMemberIds = optedInMemberIds;
  factory _RamadanSeason.fromJson(Map<String, dynamic> json) => _$RamadanSeasonFromJson(json);

@override final  String id;
@override final  String messId;
@override final  DateTime startDate;
@override final  DateTime endDate;
@override final  int year;
 final  List<String> _optedInMemberIds;
@override@JsonKey() List<String> get optedInMemberIds {
  if (_optedInMemberIds is EqualUnmodifiableListView) return _optedInMemberIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_optedInMemberIds);
}

@override@JsonKey() final  bool isActive;
@override@JsonKey() final  bool isSettled;
@override final  DateTime? createdAt;

/// Create a copy of RamadanSeason
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RamadanSeasonCopyWith<_RamadanSeason> get copyWith => __$RamadanSeasonCopyWithImpl<_RamadanSeason>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RamadanSeasonToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RamadanSeason&&(identical(other.id, id) || other.id == id)&&(identical(other.messId, messId) || other.messId == messId)&&(identical(other.startDate, startDate) || other.startDate == startDate)&&(identical(other.endDate, endDate) || other.endDate == endDate)&&(identical(other.year, year) || other.year == year)&&const DeepCollectionEquality().equals(other._optedInMemberIds, _optedInMemberIds)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.isSettled, isSettled) || other.isSettled == isSettled)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,messId,startDate,endDate,year,const DeepCollectionEquality().hash(_optedInMemberIds),isActive,isSettled,createdAt);

@override
String toString() {
  return 'RamadanSeason(id: $id, messId: $messId, startDate: $startDate, endDate: $endDate, year: $year, optedInMemberIds: $optedInMemberIds, isActive: $isActive, isSettled: $isSettled, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$RamadanSeasonCopyWith<$Res> implements $RamadanSeasonCopyWith<$Res> {
  factory _$RamadanSeasonCopyWith(_RamadanSeason value, $Res Function(_RamadanSeason) _then) = __$RamadanSeasonCopyWithImpl;
@override @useResult
$Res call({
 String id, String messId, DateTime startDate, DateTime endDate, int year, List<String> optedInMemberIds, bool isActive, bool isSettled, DateTime? createdAt
});




}
/// @nodoc
class __$RamadanSeasonCopyWithImpl<$Res>
    implements _$RamadanSeasonCopyWith<$Res> {
  __$RamadanSeasonCopyWithImpl(this._self, this._then);

  final _RamadanSeason _self;
  final $Res Function(_RamadanSeason) _then;

/// Create a copy of RamadanSeason
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? messId = null,Object? startDate = null,Object? endDate = null,Object? year = null,Object? optedInMemberIds = null,Object? isActive = null,Object? isSettled = null,Object? createdAt = freezed,}) {
  return _then(_RamadanSeason(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,messId: null == messId ? _self.messId : messId // ignore: cast_nullable_to_non_nullable
as String,startDate: null == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as DateTime,endDate: null == endDate ? _self.endDate : endDate // ignore: cast_nullable_to_non_nullable
as DateTime,year: null == year ? _self.year : year // ignore: cast_nullable_to_non_nullable
as int,optedInMemberIds: null == optedInMemberIds ? _self._optedInMemberIds : optedInMemberIds // ignore: cast_nullable_to_non_nullable
as List<String>,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,isSettled: null == isSettled ? _self.isSettled : isSettled // ignore: cast_nullable_to_non_nullable
as bool,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}


/// @nodoc
mixin _$RamadanMeal {

 String get id; String get seasonId; String get memberId; DateTime get date; RamadanMealType get type; int get count; int get guestCount;// Number of guest meals (sponsor pays)
 String? get guestName;// Optional guest name(s) for reference
 DateTime? get createdAt;
/// Create a copy of RamadanMeal
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RamadanMealCopyWith<RamadanMeal> get copyWith => _$RamadanMealCopyWithImpl<RamadanMeal>(this as RamadanMeal, _$identity);

  /// Serializes this RamadanMeal to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RamadanMeal&&(identical(other.id, id) || other.id == id)&&(identical(other.seasonId, seasonId) || other.seasonId == seasonId)&&(identical(other.memberId, memberId) || other.memberId == memberId)&&(identical(other.date, date) || other.date == date)&&(identical(other.type, type) || other.type == type)&&(identical(other.count, count) || other.count == count)&&(identical(other.guestCount, guestCount) || other.guestCount == guestCount)&&(identical(other.guestName, guestName) || other.guestName == guestName)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,seasonId,memberId,date,type,count,guestCount,guestName,createdAt);

@override
String toString() {
  return 'RamadanMeal(id: $id, seasonId: $seasonId, memberId: $memberId, date: $date, type: $type, count: $count, guestCount: $guestCount, guestName: $guestName, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $RamadanMealCopyWith<$Res>  {
  factory $RamadanMealCopyWith(RamadanMeal value, $Res Function(RamadanMeal) _then) = _$RamadanMealCopyWithImpl;
@useResult
$Res call({
 String id, String seasonId, String memberId, DateTime date, RamadanMealType type, int count, int guestCount, String? guestName, DateTime? createdAt
});




}
/// @nodoc
class _$RamadanMealCopyWithImpl<$Res>
    implements $RamadanMealCopyWith<$Res> {
  _$RamadanMealCopyWithImpl(this._self, this._then);

  final RamadanMeal _self;
  final $Res Function(RamadanMeal) _then;

/// Create a copy of RamadanMeal
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? seasonId = null,Object? memberId = null,Object? date = null,Object? type = null,Object? count = null,Object? guestCount = null,Object? guestName = freezed,Object? createdAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,seasonId: null == seasonId ? _self.seasonId : seasonId // ignore: cast_nullable_to_non_nullable
as String,memberId: null == memberId ? _self.memberId : memberId // ignore: cast_nullable_to_non_nullable
as String,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as RamadanMealType,count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,guestCount: null == guestCount ? _self.guestCount : guestCount // ignore: cast_nullable_to_non_nullable
as int,guestName: freezed == guestName ? _self.guestName : guestName // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [RamadanMeal].
extension RamadanMealPatterns on RamadanMeal {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RamadanMeal value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RamadanMeal() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RamadanMeal value)  $default,){
final _that = this;
switch (_that) {
case _RamadanMeal():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RamadanMeal value)?  $default,){
final _that = this;
switch (_that) {
case _RamadanMeal() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String seasonId,  String memberId,  DateTime date,  RamadanMealType type,  int count,  int guestCount,  String? guestName,  DateTime? createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RamadanMeal() when $default != null:
return $default(_that.id,_that.seasonId,_that.memberId,_that.date,_that.type,_that.count,_that.guestCount,_that.guestName,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String seasonId,  String memberId,  DateTime date,  RamadanMealType type,  int count,  int guestCount,  String? guestName,  DateTime? createdAt)  $default,) {final _that = this;
switch (_that) {
case _RamadanMeal():
return $default(_that.id,_that.seasonId,_that.memberId,_that.date,_that.type,_that.count,_that.guestCount,_that.guestName,_that.createdAt);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String seasonId,  String memberId,  DateTime date,  RamadanMealType type,  int count,  int guestCount,  String? guestName,  DateTime? createdAt)?  $default,) {final _that = this;
switch (_that) {
case _RamadanMeal() when $default != null:
return $default(_that.id,_that.seasonId,_that.memberId,_that.date,_that.type,_that.count,_that.guestCount,_that.guestName,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RamadanMeal implements RamadanMeal {
  const _RamadanMeal({required this.id, required this.seasonId, required this.memberId, required this.date, required this.type, this.count = 1, this.guestCount = 0, this.guestName, this.createdAt});
  factory _RamadanMeal.fromJson(Map<String, dynamic> json) => _$RamadanMealFromJson(json);

@override final  String id;
@override final  String seasonId;
@override final  String memberId;
@override final  DateTime date;
@override final  RamadanMealType type;
@override@JsonKey() final  int count;
@override@JsonKey() final  int guestCount;
// Number of guest meals (sponsor pays)
@override final  String? guestName;
// Optional guest name(s) for reference
@override final  DateTime? createdAt;

/// Create a copy of RamadanMeal
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RamadanMealCopyWith<_RamadanMeal> get copyWith => __$RamadanMealCopyWithImpl<_RamadanMeal>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RamadanMealToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RamadanMeal&&(identical(other.id, id) || other.id == id)&&(identical(other.seasonId, seasonId) || other.seasonId == seasonId)&&(identical(other.memberId, memberId) || other.memberId == memberId)&&(identical(other.date, date) || other.date == date)&&(identical(other.type, type) || other.type == type)&&(identical(other.count, count) || other.count == count)&&(identical(other.guestCount, guestCount) || other.guestCount == guestCount)&&(identical(other.guestName, guestName) || other.guestName == guestName)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,seasonId,memberId,date,type,count,guestCount,guestName,createdAt);

@override
String toString() {
  return 'RamadanMeal(id: $id, seasonId: $seasonId, memberId: $memberId, date: $date, type: $type, count: $count, guestCount: $guestCount, guestName: $guestName, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$RamadanMealCopyWith<$Res> implements $RamadanMealCopyWith<$Res> {
  factory _$RamadanMealCopyWith(_RamadanMeal value, $Res Function(_RamadanMeal) _then) = __$RamadanMealCopyWithImpl;
@override @useResult
$Res call({
 String id, String seasonId, String memberId, DateTime date, RamadanMealType type, int count, int guestCount, String? guestName, DateTime? createdAt
});




}
/// @nodoc
class __$RamadanMealCopyWithImpl<$Res>
    implements _$RamadanMealCopyWith<$Res> {
  __$RamadanMealCopyWithImpl(this._self, this._then);

  final _RamadanMeal _self;
  final $Res Function(_RamadanMeal) _then;

/// Create a copy of RamadanMeal
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? seasonId = null,Object? memberId = null,Object? date = null,Object? type = null,Object? count = null,Object? guestCount = null,Object? guestName = freezed,Object? createdAt = freezed,}) {
  return _then(_RamadanMeal(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,seasonId: null == seasonId ? _self.seasonId : seasonId // ignore: cast_nullable_to_non_nullable
as String,memberId: null == memberId ? _self.memberId : memberId // ignore: cast_nullable_to_non_nullable
as String,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as RamadanMealType,count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,guestCount: null == guestCount ? _self.guestCount : guestCount // ignore: cast_nullable_to_non_nullable
as int,guestName: freezed == guestName ? _self.guestName : guestName // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}


/// @nodoc
mixin _$RamadanBazar {

 String get id; String get seasonId; String get memberId; DateTime get date; double get amount; String? get description; bool get isForSehri; DateTime? get createdAt;
/// Create a copy of RamadanBazar
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RamadanBazarCopyWith<RamadanBazar> get copyWith => _$RamadanBazarCopyWithImpl<RamadanBazar>(this as RamadanBazar, _$identity);

  /// Serializes this RamadanBazar to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RamadanBazar&&(identical(other.id, id) || other.id == id)&&(identical(other.seasonId, seasonId) || other.seasonId == seasonId)&&(identical(other.memberId, memberId) || other.memberId == memberId)&&(identical(other.date, date) || other.date == date)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.description, description) || other.description == description)&&(identical(other.isForSehri, isForSehri) || other.isForSehri == isForSehri)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,seasonId,memberId,date,amount,description,isForSehri,createdAt);

@override
String toString() {
  return 'RamadanBazar(id: $id, seasonId: $seasonId, memberId: $memberId, date: $date, amount: $amount, description: $description, isForSehri: $isForSehri, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $RamadanBazarCopyWith<$Res>  {
  factory $RamadanBazarCopyWith(RamadanBazar value, $Res Function(RamadanBazar) _then) = _$RamadanBazarCopyWithImpl;
@useResult
$Res call({
 String id, String seasonId, String memberId, DateTime date, double amount, String? description, bool isForSehri, DateTime? createdAt
});




}
/// @nodoc
class _$RamadanBazarCopyWithImpl<$Res>
    implements $RamadanBazarCopyWith<$Res> {
  _$RamadanBazarCopyWithImpl(this._self, this._then);

  final RamadanBazar _self;
  final $Res Function(RamadanBazar) _then;

/// Create a copy of RamadanBazar
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? seasonId = null,Object? memberId = null,Object? date = null,Object? amount = null,Object? description = freezed,Object? isForSehri = null,Object? createdAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,seasonId: null == seasonId ? _self.seasonId : seasonId // ignore: cast_nullable_to_non_nullable
as String,memberId: null == memberId ? _self.memberId : memberId // ignore: cast_nullable_to_non_nullable
as String,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as double,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,isForSehri: null == isForSehri ? _self.isForSehri : isForSehri // ignore: cast_nullable_to_non_nullable
as bool,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [RamadanBazar].
extension RamadanBazarPatterns on RamadanBazar {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RamadanBazar value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RamadanBazar() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RamadanBazar value)  $default,){
final _that = this;
switch (_that) {
case _RamadanBazar():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RamadanBazar value)?  $default,){
final _that = this;
switch (_that) {
case _RamadanBazar() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String seasonId,  String memberId,  DateTime date,  double amount,  String? description,  bool isForSehri,  DateTime? createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RamadanBazar() when $default != null:
return $default(_that.id,_that.seasonId,_that.memberId,_that.date,_that.amount,_that.description,_that.isForSehri,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String seasonId,  String memberId,  DateTime date,  double amount,  String? description,  bool isForSehri,  DateTime? createdAt)  $default,) {final _that = this;
switch (_that) {
case _RamadanBazar():
return $default(_that.id,_that.seasonId,_that.memberId,_that.date,_that.amount,_that.description,_that.isForSehri,_that.createdAt);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String seasonId,  String memberId,  DateTime date,  double amount,  String? description,  bool isForSehri,  DateTime? createdAt)?  $default,) {final _that = this;
switch (_that) {
case _RamadanBazar() when $default != null:
return $default(_that.id,_that.seasonId,_that.memberId,_that.date,_that.amount,_that.description,_that.isForSehri,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RamadanBazar implements RamadanBazar {
  const _RamadanBazar({required this.id, required this.seasonId, required this.memberId, required this.date, required this.amount, this.description, this.isForSehri = false, this.createdAt});
  factory _RamadanBazar.fromJson(Map<String, dynamic> json) => _$RamadanBazarFromJson(json);

@override final  String id;
@override final  String seasonId;
@override final  String memberId;
@override final  DateTime date;
@override final  double amount;
@override final  String? description;
@override@JsonKey() final  bool isForSehri;
@override final  DateTime? createdAt;

/// Create a copy of RamadanBazar
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RamadanBazarCopyWith<_RamadanBazar> get copyWith => __$RamadanBazarCopyWithImpl<_RamadanBazar>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RamadanBazarToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RamadanBazar&&(identical(other.id, id) || other.id == id)&&(identical(other.seasonId, seasonId) || other.seasonId == seasonId)&&(identical(other.memberId, memberId) || other.memberId == memberId)&&(identical(other.date, date) || other.date == date)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.description, description) || other.description == description)&&(identical(other.isForSehri, isForSehri) || other.isForSehri == isForSehri)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,seasonId,memberId,date,amount,description,isForSehri,createdAt);

@override
String toString() {
  return 'RamadanBazar(id: $id, seasonId: $seasonId, memberId: $memberId, date: $date, amount: $amount, description: $description, isForSehri: $isForSehri, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$RamadanBazarCopyWith<$Res> implements $RamadanBazarCopyWith<$Res> {
  factory _$RamadanBazarCopyWith(_RamadanBazar value, $Res Function(_RamadanBazar) _then) = __$RamadanBazarCopyWithImpl;
@override @useResult
$Res call({
 String id, String seasonId, String memberId, DateTime date, double amount, String? description, bool isForSehri, DateTime? createdAt
});




}
/// @nodoc
class __$RamadanBazarCopyWithImpl<$Res>
    implements _$RamadanBazarCopyWith<$Res> {
  __$RamadanBazarCopyWithImpl(this._self, this._then);

  final _RamadanBazar _self;
  final $Res Function(_RamadanBazar) _then;

/// Create a copy of RamadanBazar
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? seasonId = null,Object? memberId = null,Object? date = null,Object? amount = null,Object? description = freezed,Object? isForSehri = null,Object? createdAt = freezed,}) {
  return _then(_RamadanBazar(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,seasonId: null == seasonId ? _self.seasonId : seasonId // ignore: cast_nullable_to_non_nullable
as String,memberId: null == memberId ? _self.memberId : memberId // ignore: cast_nullable_to_non_nullable
as String,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as double,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,isForSehri: null == isForSehri ? _self.isForSehri : isForSehri // ignore: cast_nullable_to_non_nullable
as bool,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}


/// @nodoc
mixin _$RamadanBalance {

 String get memberId; String get seasonId; int get totalMeals; double get totalBazar; double get mealCost; double get balance;
/// Create a copy of RamadanBalance
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RamadanBalanceCopyWith<RamadanBalance> get copyWith => _$RamadanBalanceCopyWithImpl<RamadanBalance>(this as RamadanBalance, _$identity);

  /// Serializes this RamadanBalance to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RamadanBalance&&(identical(other.memberId, memberId) || other.memberId == memberId)&&(identical(other.seasonId, seasonId) || other.seasonId == seasonId)&&(identical(other.totalMeals, totalMeals) || other.totalMeals == totalMeals)&&(identical(other.totalBazar, totalBazar) || other.totalBazar == totalBazar)&&(identical(other.mealCost, mealCost) || other.mealCost == mealCost)&&(identical(other.balance, balance) || other.balance == balance));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,memberId,seasonId,totalMeals,totalBazar,mealCost,balance);

@override
String toString() {
  return 'RamadanBalance(memberId: $memberId, seasonId: $seasonId, totalMeals: $totalMeals, totalBazar: $totalBazar, mealCost: $mealCost, balance: $balance)';
}


}

/// @nodoc
abstract mixin class $RamadanBalanceCopyWith<$Res>  {
  factory $RamadanBalanceCopyWith(RamadanBalance value, $Res Function(RamadanBalance) _then) = _$RamadanBalanceCopyWithImpl;
@useResult
$Res call({
 String memberId, String seasonId, int totalMeals, double totalBazar, double mealCost, double balance
});




}
/// @nodoc
class _$RamadanBalanceCopyWithImpl<$Res>
    implements $RamadanBalanceCopyWith<$Res> {
  _$RamadanBalanceCopyWithImpl(this._self, this._then);

  final RamadanBalance _self;
  final $Res Function(RamadanBalance) _then;

/// Create a copy of RamadanBalance
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? memberId = null,Object? seasonId = null,Object? totalMeals = null,Object? totalBazar = null,Object? mealCost = null,Object? balance = null,}) {
  return _then(_self.copyWith(
memberId: null == memberId ? _self.memberId : memberId // ignore: cast_nullable_to_non_nullable
as String,seasonId: null == seasonId ? _self.seasonId : seasonId // ignore: cast_nullable_to_non_nullable
as String,totalMeals: null == totalMeals ? _self.totalMeals : totalMeals // ignore: cast_nullable_to_non_nullable
as int,totalBazar: null == totalBazar ? _self.totalBazar : totalBazar // ignore: cast_nullable_to_non_nullable
as double,mealCost: null == mealCost ? _self.mealCost : mealCost // ignore: cast_nullable_to_non_nullable
as double,balance: null == balance ? _self.balance : balance // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [RamadanBalance].
extension RamadanBalancePatterns on RamadanBalance {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RamadanBalance value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RamadanBalance() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RamadanBalance value)  $default,){
final _that = this;
switch (_that) {
case _RamadanBalance():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RamadanBalance value)?  $default,){
final _that = this;
switch (_that) {
case _RamadanBalance() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String memberId,  String seasonId,  int totalMeals,  double totalBazar,  double mealCost,  double balance)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RamadanBalance() when $default != null:
return $default(_that.memberId,_that.seasonId,_that.totalMeals,_that.totalBazar,_that.mealCost,_that.balance);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String memberId,  String seasonId,  int totalMeals,  double totalBazar,  double mealCost,  double balance)  $default,) {final _that = this;
switch (_that) {
case _RamadanBalance():
return $default(_that.memberId,_that.seasonId,_that.totalMeals,_that.totalBazar,_that.mealCost,_that.balance);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String memberId,  String seasonId,  int totalMeals,  double totalBazar,  double mealCost,  double balance)?  $default,) {final _that = this;
switch (_that) {
case _RamadanBalance() when $default != null:
return $default(_that.memberId,_that.seasonId,_that.totalMeals,_that.totalBazar,_that.mealCost,_that.balance);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RamadanBalance implements RamadanBalance {
  const _RamadanBalance({required this.memberId, required this.seasonId, required this.totalMeals, required this.totalBazar, required this.mealCost, required this.balance});
  factory _RamadanBalance.fromJson(Map<String, dynamic> json) => _$RamadanBalanceFromJson(json);

@override final  String memberId;
@override final  String seasonId;
@override final  int totalMeals;
@override final  double totalBazar;
@override final  double mealCost;
@override final  double balance;

/// Create a copy of RamadanBalance
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RamadanBalanceCopyWith<_RamadanBalance> get copyWith => __$RamadanBalanceCopyWithImpl<_RamadanBalance>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RamadanBalanceToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RamadanBalance&&(identical(other.memberId, memberId) || other.memberId == memberId)&&(identical(other.seasonId, seasonId) || other.seasonId == seasonId)&&(identical(other.totalMeals, totalMeals) || other.totalMeals == totalMeals)&&(identical(other.totalBazar, totalBazar) || other.totalBazar == totalBazar)&&(identical(other.mealCost, mealCost) || other.mealCost == mealCost)&&(identical(other.balance, balance) || other.balance == balance));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,memberId,seasonId,totalMeals,totalBazar,mealCost,balance);

@override
String toString() {
  return 'RamadanBalance(memberId: $memberId, seasonId: $seasonId, totalMeals: $totalMeals, totalBazar: $totalBazar, mealCost: $mealCost, balance: $balance)';
}


}

/// @nodoc
abstract mixin class _$RamadanBalanceCopyWith<$Res> implements $RamadanBalanceCopyWith<$Res> {
  factory _$RamadanBalanceCopyWith(_RamadanBalance value, $Res Function(_RamadanBalance) _then) = __$RamadanBalanceCopyWithImpl;
@override @useResult
$Res call({
 String memberId, String seasonId, int totalMeals, double totalBazar, double mealCost, double balance
});




}
/// @nodoc
class __$RamadanBalanceCopyWithImpl<$Res>
    implements _$RamadanBalanceCopyWith<$Res> {
  __$RamadanBalanceCopyWithImpl(this._self, this._then);

  final _RamadanBalance _self;
  final $Res Function(_RamadanBalance) _then;

/// Create a copy of RamadanBalance
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? memberId = null,Object? seasonId = null,Object? totalMeals = null,Object? totalBazar = null,Object? mealCost = null,Object? balance = null,}) {
  return _then(_RamadanBalance(
memberId: null == memberId ? _self.memberId : memberId // ignore: cast_nullable_to_non_nullable
as String,seasonId: null == seasonId ? _self.seasonId : seasonId // ignore: cast_nullable_to_non_nullable
as String,totalMeals: null == totalMeals ? _self.totalMeals : totalMeals // ignore: cast_nullable_to_non_nullable
as int,totalBazar: null == totalBazar ? _self.totalBazar : totalBazar // ignore: cast_nullable_to_non_nullable
as double,mealCost: null == mealCost ? _self.mealCost : mealCost // ignore: cast_nullable_to_non_nullable
as double,balance: null == balance ? _self.balance : balance // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}


/// @nodoc
mixin _$RamadanPayment {

 String get id; String get seasonId; String get fromMemberId;// Debtor who paid
 String get toMemberId;// Creditor who received
 double get amount; DateTime get paidAt;
/// Create a copy of RamadanPayment
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RamadanPaymentCopyWith<RamadanPayment> get copyWith => _$RamadanPaymentCopyWithImpl<RamadanPayment>(this as RamadanPayment, _$identity);

  /// Serializes this RamadanPayment to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RamadanPayment&&(identical(other.id, id) || other.id == id)&&(identical(other.seasonId, seasonId) || other.seasonId == seasonId)&&(identical(other.fromMemberId, fromMemberId) || other.fromMemberId == fromMemberId)&&(identical(other.toMemberId, toMemberId) || other.toMemberId == toMemberId)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.paidAt, paidAt) || other.paidAt == paidAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,seasonId,fromMemberId,toMemberId,amount,paidAt);

@override
String toString() {
  return 'RamadanPayment(id: $id, seasonId: $seasonId, fromMemberId: $fromMemberId, toMemberId: $toMemberId, amount: $amount, paidAt: $paidAt)';
}


}

/// @nodoc
abstract mixin class $RamadanPaymentCopyWith<$Res>  {
  factory $RamadanPaymentCopyWith(RamadanPayment value, $Res Function(RamadanPayment) _then) = _$RamadanPaymentCopyWithImpl;
@useResult
$Res call({
 String id, String seasonId, String fromMemberId, String toMemberId, double amount, DateTime paidAt
});




}
/// @nodoc
class _$RamadanPaymentCopyWithImpl<$Res>
    implements $RamadanPaymentCopyWith<$Res> {
  _$RamadanPaymentCopyWithImpl(this._self, this._then);

  final RamadanPayment _self;
  final $Res Function(RamadanPayment) _then;

/// Create a copy of RamadanPayment
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? seasonId = null,Object? fromMemberId = null,Object? toMemberId = null,Object? amount = null,Object? paidAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,seasonId: null == seasonId ? _self.seasonId : seasonId // ignore: cast_nullable_to_non_nullable
as String,fromMemberId: null == fromMemberId ? _self.fromMemberId : fromMemberId // ignore: cast_nullable_to_non_nullable
as String,toMemberId: null == toMemberId ? _self.toMemberId : toMemberId // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as double,paidAt: null == paidAt ? _self.paidAt : paidAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [RamadanPayment].
extension RamadanPaymentPatterns on RamadanPayment {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RamadanPayment value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RamadanPayment() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RamadanPayment value)  $default,){
final _that = this;
switch (_that) {
case _RamadanPayment():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RamadanPayment value)?  $default,){
final _that = this;
switch (_that) {
case _RamadanPayment() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String seasonId,  String fromMemberId,  String toMemberId,  double amount,  DateTime paidAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RamadanPayment() when $default != null:
return $default(_that.id,_that.seasonId,_that.fromMemberId,_that.toMemberId,_that.amount,_that.paidAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String seasonId,  String fromMemberId,  String toMemberId,  double amount,  DateTime paidAt)  $default,) {final _that = this;
switch (_that) {
case _RamadanPayment():
return $default(_that.id,_that.seasonId,_that.fromMemberId,_that.toMemberId,_that.amount,_that.paidAt);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String seasonId,  String fromMemberId,  String toMemberId,  double amount,  DateTime paidAt)?  $default,) {final _that = this;
switch (_that) {
case _RamadanPayment() when $default != null:
return $default(_that.id,_that.seasonId,_that.fromMemberId,_that.toMemberId,_that.amount,_that.paidAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RamadanPayment implements RamadanPayment {
  const _RamadanPayment({required this.id, required this.seasonId, required this.fromMemberId, required this.toMemberId, required this.amount, required this.paidAt});
  factory _RamadanPayment.fromJson(Map<String, dynamic> json) => _$RamadanPaymentFromJson(json);

@override final  String id;
@override final  String seasonId;
@override final  String fromMemberId;
// Debtor who paid
@override final  String toMemberId;
// Creditor who received
@override final  double amount;
@override final  DateTime paidAt;

/// Create a copy of RamadanPayment
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RamadanPaymentCopyWith<_RamadanPayment> get copyWith => __$RamadanPaymentCopyWithImpl<_RamadanPayment>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RamadanPaymentToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RamadanPayment&&(identical(other.id, id) || other.id == id)&&(identical(other.seasonId, seasonId) || other.seasonId == seasonId)&&(identical(other.fromMemberId, fromMemberId) || other.fromMemberId == fromMemberId)&&(identical(other.toMemberId, toMemberId) || other.toMemberId == toMemberId)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.paidAt, paidAt) || other.paidAt == paidAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,seasonId,fromMemberId,toMemberId,amount,paidAt);

@override
String toString() {
  return 'RamadanPayment(id: $id, seasonId: $seasonId, fromMemberId: $fromMemberId, toMemberId: $toMemberId, amount: $amount, paidAt: $paidAt)';
}


}

/// @nodoc
abstract mixin class _$RamadanPaymentCopyWith<$Res> implements $RamadanPaymentCopyWith<$Res> {
  factory _$RamadanPaymentCopyWith(_RamadanPayment value, $Res Function(_RamadanPayment) _then) = __$RamadanPaymentCopyWithImpl;
@override @useResult
$Res call({
 String id, String seasonId, String fromMemberId, String toMemberId, double amount, DateTime paidAt
});




}
/// @nodoc
class __$RamadanPaymentCopyWithImpl<$Res>
    implements _$RamadanPaymentCopyWith<$Res> {
  __$RamadanPaymentCopyWithImpl(this._self, this._then);

  final _RamadanPayment _self;
  final $Res Function(_RamadanPayment) _then;

/// Create a copy of RamadanPayment
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? seasonId = null,Object? fromMemberId = null,Object? toMemberId = null,Object? amount = null,Object? paidAt = null,}) {
  return _then(_RamadanPayment(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,seasonId: null == seasonId ? _self.seasonId : seasonId // ignore: cast_nullable_to_non_nullable
as String,fromMemberId: null == fromMemberId ? _self.fromMemberId : fromMemberId // ignore: cast_nullable_to_non_nullable
as String,toMemberId: null == toMemberId ? _self.toMemberId : toMemberId // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as double,paidAt: null == paidAt ? _self.paidAt : paidAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
