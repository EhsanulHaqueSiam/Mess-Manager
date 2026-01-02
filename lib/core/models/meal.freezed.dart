// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'meal.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Meal {

 String get id; String get memberId; DateTime get date; int get count;// Whole numbers only: 1, 2, 3...
 MealType get type; MealStatus get status; bool get isFromSchedule;// Auto-added from weekly schedule
// Guest meal fields
 int get guestCount;// Number of guest meals
 String? get guestName;// Optional guest name
 List<String> get sharedWithMemberIds;// Split guest cost
 String? get note; DateTime? get createdAt;
/// Create a copy of Meal
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MealCopyWith<Meal> get copyWith => _$MealCopyWithImpl<Meal>(this as Meal, _$identity);

  /// Serializes this Meal to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Meal&&(identical(other.id, id) || other.id == id)&&(identical(other.memberId, memberId) || other.memberId == memberId)&&(identical(other.date, date) || other.date == date)&&(identical(other.count, count) || other.count == count)&&(identical(other.type, type) || other.type == type)&&(identical(other.status, status) || other.status == status)&&(identical(other.isFromSchedule, isFromSchedule) || other.isFromSchedule == isFromSchedule)&&(identical(other.guestCount, guestCount) || other.guestCount == guestCount)&&(identical(other.guestName, guestName) || other.guestName == guestName)&&const DeepCollectionEquality().equals(other.sharedWithMemberIds, sharedWithMemberIds)&&(identical(other.note, note) || other.note == note)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,memberId,date,count,type,status,isFromSchedule,guestCount,guestName,const DeepCollectionEquality().hash(sharedWithMemberIds),note,createdAt);

@override
String toString() {
  return 'Meal(id: $id, memberId: $memberId, date: $date, count: $count, type: $type, status: $status, isFromSchedule: $isFromSchedule, guestCount: $guestCount, guestName: $guestName, sharedWithMemberIds: $sharedWithMemberIds, note: $note, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $MealCopyWith<$Res>  {
  factory $MealCopyWith(Meal value, $Res Function(Meal) _then) = _$MealCopyWithImpl;
@useResult
$Res call({
 String id, String memberId, DateTime date, int count, MealType type, MealStatus status, bool isFromSchedule, int guestCount, String? guestName, List<String> sharedWithMemberIds, String? note, DateTime? createdAt
});




}
/// @nodoc
class _$MealCopyWithImpl<$Res>
    implements $MealCopyWith<$Res> {
  _$MealCopyWithImpl(this._self, this._then);

  final Meal _self;
  final $Res Function(Meal) _then;

/// Create a copy of Meal
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? memberId = null,Object? date = null,Object? count = null,Object? type = null,Object? status = null,Object? isFromSchedule = null,Object? guestCount = null,Object? guestName = freezed,Object? sharedWithMemberIds = null,Object? note = freezed,Object? createdAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,memberId: null == memberId ? _self.memberId : memberId // ignore: cast_nullable_to_non_nullable
as String,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as MealType,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as MealStatus,isFromSchedule: null == isFromSchedule ? _self.isFromSchedule : isFromSchedule // ignore: cast_nullable_to_non_nullable
as bool,guestCount: null == guestCount ? _self.guestCount : guestCount // ignore: cast_nullable_to_non_nullable
as int,guestName: freezed == guestName ? _self.guestName : guestName // ignore: cast_nullable_to_non_nullable
as String?,sharedWithMemberIds: null == sharedWithMemberIds ? _self.sharedWithMemberIds : sharedWithMemberIds // ignore: cast_nullable_to_non_nullable
as List<String>,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [Meal].
extension MealPatterns on Meal {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Meal value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Meal() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Meal value)  $default,){
final _that = this;
switch (_that) {
case _Meal():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Meal value)?  $default,){
final _that = this;
switch (_that) {
case _Meal() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String memberId,  DateTime date,  int count,  MealType type,  MealStatus status,  bool isFromSchedule,  int guestCount,  String? guestName,  List<String> sharedWithMemberIds,  String? note,  DateTime? createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Meal() when $default != null:
return $default(_that.id,_that.memberId,_that.date,_that.count,_that.type,_that.status,_that.isFromSchedule,_that.guestCount,_that.guestName,_that.sharedWithMemberIds,_that.note,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String memberId,  DateTime date,  int count,  MealType type,  MealStatus status,  bool isFromSchedule,  int guestCount,  String? guestName,  List<String> sharedWithMemberIds,  String? note,  DateTime? createdAt)  $default,) {final _that = this;
switch (_that) {
case _Meal():
return $default(_that.id,_that.memberId,_that.date,_that.count,_that.type,_that.status,_that.isFromSchedule,_that.guestCount,_that.guestName,_that.sharedWithMemberIds,_that.note,_that.createdAt);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String memberId,  DateTime date,  int count,  MealType type,  MealStatus status,  bool isFromSchedule,  int guestCount,  String? guestName,  List<String> sharedWithMemberIds,  String? note,  DateTime? createdAt)?  $default,) {final _that = this;
switch (_that) {
case _Meal() when $default != null:
return $default(_that.id,_that.memberId,_that.date,_that.count,_that.type,_that.status,_that.isFromSchedule,_that.guestCount,_that.guestName,_that.sharedWithMemberIds,_that.note,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Meal implements Meal {
  const _Meal({required this.id, required this.memberId, required this.date, this.count = 1, this.type = MealType.lunch, this.status = MealStatus.confirmed, this.isFromSchedule = false, this.guestCount = 0, this.guestName, final  List<String> sharedWithMemberIds = const [], this.note, this.createdAt}): _sharedWithMemberIds = sharedWithMemberIds;
  factory _Meal.fromJson(Map<String, dynamic> json) => _$MealFromJson(json);

@override final  String id;
@override final  String memberId;
@override final  DateTime date;
@override@JsonKey() final  int count;
// Whole numbers only: 1, 2, 3...
@override@JsonKey() final  MealType type;
@override@JsonKey() final  MealStatus status;
@override@JsonKey() final  bool isFromSchedule;
// Auto-added from weekly schedule
// Guest meal fields
@override@JsonKey() final  int guestCount;
// Number of guest meals
@override final  String? guestName;
// Optional guest name
 final  List<String> _sharedWithMemberIds;
// Optional guest name
@override@JsonKey() List<String> get sharedWithMemberIds {
  if (_sharedWithMemberIds is EqualUnmodifiableListView) return _sharedWithMemberIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_sharedWithMemberIds);
}

// Split guest cost
@override final  String? note;
@override final  DateTime? createdAt;

/// Create a copy of Meal
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MealCopyWith<_Meal> get copyWith => __$MealCopyWithImpl<_Meal>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MealToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Meal&&(identical(other.id, id) || other.id == id)&&(identical(other.memberId, memberId) || other.memberId == memberId)&&(identical(other.date, date) || other.date == date)&&(identical(other.count, count) || other.count == count)&&(identical(other.type, type) || other.type == type)&&(identical(other.status, status) || other.status == status)&&(identical(other.isFromSchedule, isFromSchedule) || other.isFromSchedule == isFromSchedule)&&(identical(other.guestCount, guestCount) || other.guestCount == guestCount)&&(identical(other.guestName, guestName) || other.guestName == guestName)&&const DeepCollectionEquality().equals(other._sharedWithMemberIds, _sharedWithMemberIds)&&(identical(other.note, note) || other.note == note)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,memberId,date,count,type,status,isFromSchedule,guestCount,guestName,const DeepCollectionEquality().hash(_sharedWithMemberIds),note,createdAt);

@override
String toString() {
  return 'Meal(id: $id, memberId: $memberId, date: $date, count: $count, type: $type, status: $status, isFromSchedule: $isFromSchedule, guestCount: $guestCount, guestName: $guestName, sharedWithMemberIds: $sharedWithMemberIds, note: $note, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$MealCopyWith<$Res> implements $MealCopyWith<$Res> {
  factory _$MealCopyWith(_Meal value, $Res Function(_Meal) _then) = __$MealCopyWithImpl;
@override @useResult
$Res call({
 String id, String memberId, DateTime date, int count, MealType type, MealStatus status, bool isFromSchedule, int guestCount, String? guestName, List<String> sharedWithMemberIds, String? note, DateTime? createdAt
});




}
/// @nodoc
class __$MealCopyWithImpl<$Res>
    implements _$MealCopyWith<$Res> {
  __$MealCopyWithImpl(this._self, this._then);

  final _Meal _self;
  final $Res Function(_Meal) _then;

/// Create a copy of Meal
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? memberId = null,Object? date = null,Object? count = null,Object? type = null,Object? status = null,Object? isFromSchedule = null,Object? guestCount = null,Object? guestName = freezed,Object? sharedWithMemberIds = null,Object? note = freezed,Object? createdAt = freezed,}) {
  return _then(_Meal(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,memberId: null == memberId ? _self.memberId : memberId // ignore: cast_nullable_to_non_nullable
as String,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as MealType,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as MealStatus,isFromSchedule: null == isFromSchedule ? _self.isFromSchedule : isFromSchedule // ignore: cast_nullable_to_non_nullable
as bool,guestCount: null == guestCount ? _self.guestCount : guestCount // ignore: cast_nullable_to_non_nullable
as int,guestName: freezed == guestName ? _self.guestName : guestName // ignore: cast_nullable_to_non_nullable
as String?,sharedWithMemberIds: null == sharedWithMemberIds ? _self._sharedWithMemberIds : sharedWithMemberIds // ignore: cast_nullable_to_non_nullable
as List<String>,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}


/// @nodoc
mixin _$DailyMealSummary {

 DateTime get date; Map<String, int> get memberMeals;// memberId -> count (int)
 int get totalMeals;
/// Create a copy of DailyMealSummary
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DailyMealSummaryCopyWith<DailyMealSummary> get copyWith => _$DailyMealSummaryCopyWithImpl<DailyMealSummary>(this as DailyMealSummary, _$identity);

  /// Serializes this DailyMealSummary to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DailyMealSummary&&(identical(other.date, date) || other.date == date)&&const DeepCollectionEquality().equals(other.memberMeals, memberMeals)&&(identical(other.totalMeals, totalMeals) || other.totalMeals == totalMeals));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,date,const DeepCollectionEquality().hash(memberMeals),totalMeals);

@override
String toString() {
  return 'DailyMealSummary(date: $date, memberMeals: $memberMeals, totalMeals: $totalMeals)';
}


}

/// @nodoc
abstract mixin class $DailyMealSummaryCopyWith<$Res>  {
  factory $DailyMealSummaryCopyWith(DailyMealSummary value, $Res Function(DailyMealSummary) _then) = _$DailyMealSummaryCopyWithImpl;
@useResult
$Res call({
 DateTime date, Map<String, int> memberMeals, int totalMeals
});




}
/// @nodoc
class _$DailyMealSummaryCopyWithImpl<$Res>
    implements $DailyMealSummaryCopyWith<$Res> {
  _$DailyMealSummaryCopyWithImpl(this._self, this._then);

  final DailyMealSummary _self;
  final $Res Function(DailyMealSummary) _then;

/// Create a copy of DailyMealSummary
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? date = null,Object? memberMeals = null,Object? totalMeals = null,}) {
  return _then(_self.copyWith(
date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,memberMeals: null == memberMeals ? _self.memberMeals : memberMeals // ignore: cast_nullable_to_non_nullable
as Map<String, int>,totalMeals: null == totalMeals ? _self.totalMeals : totalMeals // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [DailyMealSummary].
extension DailyMealSummaryPatterns on DailyMealSummary {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DailyMealSummary value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DailyMealSummary() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DailyMealSummary value)  $default,){
final _that = this;
switch (_that) {
case _DailyMealSummary():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DailyMealSummary value)?  $default,){
final _that = this;
switch (_that) {
case _DailyMealSummary() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( DateTime date,  Map<String, int> memberMeals,  int totalMeals)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DailyMealSummary() when $default != null:
return $default(_that.date,_that.memberMeals,_that.totalMeals);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( DateTime date,  Map<String, int> memberMeals,  int totalMeals)  $default,) {final _that = this;
switch (_that) {
case _DailyMealSummary():
return $default(_that.date,_that.memberMeals,_that.totalMeals);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( DateTime date,  Map<String, int> memberMeals,  int totalMeals)?  $default,) {final _that = this;
switch (_that) {
case _DailyMealSummary() when $default != null:
return $default(_that.date,_that.memberMeals,_that.totalMeals);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DailyMealSummary implements DailyMealSummary {
  const _DailyMealSummary({required this.date, required final  Map<String, int> memberMeals, this.totalMeals = 0}): _memberMeals = memberMeals;
  factory _DailyMealSummary.fromJson(Map<String, dynamic> json) => _$DailyMealSummaryFromJson(json);

@override final  DateTime date;
 final  Map<String, int> _memberMeals;
@override Map<String, int> get memberMeals {
  if (_memberMeals is EqualUnmodifiableMapView) return _memberMeals;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_memberMeals);
}

// memberId -> count (int)
@override@JsonKey() final  int totalMeals;

/// Create a copy of DailyMealSummary
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DailyMealSummaryCopyWith<_DailyMealSummary> get copyWith => __$DailyMealSummaryCopyWithImpl<_DailyMealSummary>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DailyMealSummaryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DailyMealSummary&&(identical(other.date, date) || other.date == date)&&const DeepCollectionEquality().equals(other._memberMeals, _memberMeals)&&(identical(other.totalMeals, totalMeals) || other.totalMeals == totalMeals));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,date,const DeepCollectionEquality().hash(_memberMeals),totalMeals);

@override
String toString() {
  return 'DailyMealSummary(date: $date, memberMeals: $memberMeals, totalMeals: $totalMeals)';
}


}

/// @nodoc
abstract mixin class _$DailyMealSummaryCopyWith<$Res> implements $DailyMealSummaryCopyWith<$Res> {
  factory _$DailyMealSummaryCopyWith(_DailyMealSummary value, $Res Function(_DailyMealSummary) _then) = __$DailyMealSummaryCopyWithImpl;
@override @useResult
$Res call({
 DateTime date, Map<String, int> memberMeals, int totalMeals
});




}
/// @nodoc
class __$DailyMealSummaryCopyWithImpl<$Res>
    implements _$DailyMealSummaryCopyWith<$Res> {
  __$DailyMealSummaryCopyWithImpl(this._self, this._then);

  final _DailyMealSummary _self;
  final $Res Function(_DailyMealSummary) _then;

/// Create a copy of DailyMealSummary
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? date = null,Object? memberMeals = null,Object? totalMeals = null,}) {
  return _then(_DailyMealSummary(
date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,memberMeals: null == memberMeals ? _self._memberMeals : memberMeals // ignore: cast_nullable_to_non_nullable
as Map<String, int>,totalMeals: null == totalMeals ? _self.totalMeals : totalMeals // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$VacationPeriod {

 String get id; String get memberId; DateTime get startDate;// Date vacation starts
 DateTime get endDate;// Date vacation ends
 MealType get lastMealBefore;// Last meal before leaving
 MealType get firstMealAfter;// First meal after returning
 String? get reason; bool get isActive;
/// Create a copy of VacationPeriod
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$VacationPeriodCopyWith<VacationPeriod> get copyWith => _$VacationPeriodCopyWithImpl<VacationPeriod>(this as VacationPeriod, _$identity);

  /// Serializes this VacationPeriod to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is VacationPeriod&&(identical(other.id, id) || other.id == id)&&(identical(other.memberId, memberId) || other.memberId == memberId)&&(identical(other.startDate, startDate) || other.startDate == startDate)&&(identical(other.endDate, endDate) || other.endDate == endDate)&&(identical(other.lastMealBefore, lastMealBefore) || other.lastMealBefore == lastMealBefore)&&(identical(other.firstMealAfter, firstMealAfter) || other.firstMealAfter == firstMealAfter)&&(identical(other.reason, reason) || other.reason == reason)&&(identical(other.isActive, isActive) || other.isActive == isActive));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,memberId,startDate,endDate,lastMealBefore,firstMealAfter,reason,isActive);

@override
String toString() {
  return 'VacationPeriod(id: $id, memberId: $memberId, startDate: $startDate, endDate: $endDate, lastMealBefore: $lastMealBefore, firstMealAfter: $firstMealAfter, reason: $reason, isActive: $isActive)';
}


}

/// @nodoc
abstract mixin class $VacationPeriodCopyWith<$Res>  {
  factory $VacationPeriodCopyWith(VacationPeriod value, $Res Function(VacationPeriod) _then) = _$VacationPeriodCopyWithImpl;
@useResult
$Res call({
 String id, String memberId, DateTime startDate, DateTime endDate, MealType lastMealBefore, MealType firstMealAfter, String? reason, bool isActive
});




}
/// @nodoc
class _$VacationPeriodCopyWithImpl<$Res>
    implements $VacationPeriodCopyWith<$Res> {
  _$VacationPeriodCopyWithImpl(this._self, this._then);

  final VacationPeriod _self;
  final $Res Function(VacationPeriod) _then;

/// Create a copy of VacationPeriod
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? memberId = null,Object? startDate = null,Object? endDate = null,Object? lastMealBefore = null,Object? firstMealAfter = null,Object? reason = freezed,Object? isActive = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,memberId: null == memberId ? _self.memberId : memberId // ignore: cast_nullable_to_non_nullable
as String,startDate: null == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as DateTime,endDate: null == endDate ? _self.endDate : endDate // ignore: cast_nullable_to_non_nullable
as DateTime,lastMealBefore: null == lastMealBefore ? _self.lastMealBefore : lastMealBefore // ignore: cast_nullable_to_non_nullable
as MealType,firstMealAfter: null == firstMealAfter ? _self.firstMealAfter : firstMealAfter // ignore: cast_nullable_to_non_nullable
as MealType,reason: freezed == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String?,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [VacationPeriod].
extension VacationPeriodPatterns on VacationPeriod {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _VacationPeriod value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _VacationPeriod() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _VacationPeriod value)  $default,){
final _that = this;
switch (_that) {
case _VacationPeriod():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _VacationPeriod value)?  $default,){
final _that = this;
switch (_that) {
case _VacationPeriod() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String memberId,  DateTime startDate,  DateTime endDate,  MealType lastMealBefore,  MealType firstMealAfter,  String? reason,  bool isActive)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _VacationPeriod() when $default != null:
return $default(_that.id,_that.memberId,_that.startDate,_that.endDate,_that.lastMealBefore,_that.firstMealAfter,_that.reason,_that.isActive);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String memberId,  DateTime startDate,  DateTime endDate,  MealType lastMealBefore,  MealType firstMealAfter,  String? reason,  bool isActive)  $default,) {final _that = this;
switch (_that) {
case _VacationPeriod():
return $default(_that.id,_that.memberId,_that.startDate,_that.endDate,_that.lastMealBefore,_that.firstMealAfter,_that.reason,_that.isActive);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String memberId,  DateTime startDate,  DateTime endDate,  MealType lastMealBefore,  MealType firstMealAfter,  String? reason,  bool isActive)?  $default,) {final _that = this;
switch (_that) {
case _VacationPeriod() when $default != null:
return $default(_that.id,_that.memberId,_that.startDate,_that.endDate,_that.lastMealBefore,_that.firstMealAfter,_that.reason,_that.isActive);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _VacationPeriod implements VacationPeriod {
  const _VacationPeriod({required this.id, required this.memberId, required this.startDate, required this.endDate, this.lastMealBefore = MealType.dinner, this.firstMealAfter = MealType.lunch, this.reason, this.isActive = true});
  factory _VacationPeriod.fromJson(Map<String, dynamic> json) => _$VacationPeriodFromJson(json);

@override final  String id;
@override final  String memberId;
@override final  DateTime startDate;
// Date vacation starts
@override final  DateTime endDate;
// Date vacation ends
@override@JsonKey() final  MealType lastMealBefore;
// Last meal before leaving
@override@JsonKey() final  MealType firstMealAfter;
// First meal after returning
@override final  String? reason;
@override@JsonKey() final  bool isActive;

/// Create a copy of VacationPeriod
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$VacationPeriodCopyWith<_VacationPeriod> get copyWith => __$VacationPeriodCopyWithImpl<_VacationPeriod>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$VacationPeriodToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _VacationPeriod&&(identical(other.id, id) || other.id == id)&&(identical(other.memberId, memberId) || other.memberId == memberId)&&(identical(other.startDate, startDate) || other.startDate == startDate)&&(identical(other.endDate, endDate) || other.endDate == endDate)&&(identical(other.lastMealBefore, lastMealBefore) || other.lastMealBefore == lastMealBefore)&&(identical(other.firstMealAfter, firstMealAfter) || other.firstMealAfter == firstMealAfter)&&(identical(other.reason, reason) || other.reason == reason)&&(identical(other.isActive, isActive) || other.isActive == isActive));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,memberId,startDate,endDate,lastMealBefore,firstMealAfter,reason,isActive);

@override
String toString() {
  return 'VacationPeriod(id: $id, memberId: $memberId, startDate: $startDate, endDate: $endDate, lastMealBefore: $lastMealBefore, firstMealAfter: $firstMealAfter, reason: $reason, isActive: $isActive)';
}


}

/// @nodoc
abstract mixin class _$VacationPeriodCopyWith<$Res> implements $VacationPeriodCopyWith<$Res> {
  factory _$VacationPeriodCopyWith(_VacationPeriod value, $Res Function(_VacationPeriod) _then) = __$VacationPeriodCopyWithImpl;
@override @useResult
$Res call({
 String id, String memberId, DateTime startDate, DateTime endDate, MealType lastMealBefore, MealType firstMealAfter, String? reason, bool isActive
});




}
/// @nodoc
class __$VacationPeriodCopyWithImpl<$Res>
    implements _$VacationPeriodCopyWith<$Res> {
  __$VacationPeriodCopyWithImpl(this._self, this._then);

  final _VacationPeriod _self;
  final $Res Function(_VacationPeriod) _then;

/// Create a copy of VacationPeriod
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? memberId = null,Object? startDate = null,Object? endDate = null,Object? lastMealBefore = null,Object? firstMealAfter = null,Object? reason = freezed,Object? isActive = null,}) {
  return _then(_VacationPeriod(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,memberId: null == memberId ? _self.memberId : memberId // ignore: cast_nullable_to_non_nullable
as String,startDate: null == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as DateTime,endDate: null == endDate ? _self.endDate : endDate // ignore: cast_nullable_to_non_nullable
as DateTime,lastMealBefore: null == lastMealBefore ? _self.lastMealBefore : lastMealBefore // ignore: cast_nullable_to_non_nullable
as MealType,firstMealAfter: null == firstMealAfter ? _self.firstMealAfter : firstMealAfter // ignore: cast_nullable_to_non_nullable
as MealType,reason: freezed == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String?,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$FixedExpense {

 String get id; FixedExpenseType get type; double get amount; DateTime get dueDate; int get month;// 1-12
 int get year; String? get description; bool get isPaid; DateTime? get paidAt; String? get paidByMemberId; List<String> get splitMemberIds;
/// Create a copy of FixedExpense
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FixedExpenseCopyWith<FixedExpense> get copyWith => _$FixedExpenseCopyWithImpl<FixedExpense>(this as FixedExpense, _$identity);

  /// Serializes this FixedExpense to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FixedExpense&&(identical(other.id, id) || other.id == id)&&(identical(other.type, type) || other.type == type)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.dueDate, dueDate) || other.dueDate == dueDate)&&(identical(other.month, month) || other.month == month)&&(identical(other.year, year) || other.year == year)&&(identical(other.description, description) || other.description == description)&&(identical(other.isPaid, isPaid) || other.isPaid == isPaid)&&(identical(other.paidAt, paidAt) || other.paidAt == paidAt)&&(identical(other.paidByMemberId, paidByMemberId) || other.paidByMemberId == paidByMemberId)&&const DeepCollectionEquality().equals(other.splitMemberIds, splitMemberIds));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,type,amount,dueDate,month,year,description,isPaid,paidAt,paidByMemberId,const DeepCollectionEquality().hash(splitMemberIds));

@override
String toString() {
  return 'FixedExpense(id: $id, type: $type, amount: $amount, dueDate: $dueDate, month: $month, year: $year, description: $description, isPaid: $isPaid, paidAt: $paidAt, paidByMemberId: $paidByMemberId, splitMemberIds: $splitMemberIds)';
}


}

/// @nodoc
abstract mixin class $FixedExpenseCopyWith<$Res>  {
  factory $FixedExpenseCopyWith(FixedExpense value, $Res Function(FixedExpense) _then) = _$FixedExpenseCopyWithImpl;
@useResult
$Res call({
 String id, FixedExpenseType type, double amount, DateTime dueDate, int month, int year, String? description, bool isPaid, DateTime? paidAt, String? paidByMemberId, List<String> splitMemberIds
});




}
/// @nodoc
class _$FixedExpenseCopyWithImpl<$Res>
    implements $FixedExpenseCopyWith<$Res> {
  _$FixedExpenseCopyWithImpl(this._self, this._then);

  final FixedExpense _self;
  final $Res Function(FixedExpense) _then;

/// Create a copy of FixedExpense
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? type = null,Object? amount = null,Object? dueDate = null,Object? month = null,Object? year = null,Object? description = freezed,Object? isPaid = null,Object? paidAt = freezed,Object? paidByMemberId = freezed,Object? splitMemberIds = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as FixedExpenseType,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as double,dueDate: null == dueDate ? _self.dueDate : dueDate // ignore: cast_nullable_to_non_nullable
as DateTime,month: null == month ? _self.month : month // ignore: cast_nullable_to_non_nullable
as int,year: null == year ? _self.year : year // ignore: cast_nullable_to_non_nullable
as int,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,isPaid: null == isPaid ? _self.isPaid : isPaid // ignore: cast_nullable_to_non_nullable
as bool,paidAt: freezed == paidAt ? _self.paidAt : paidAt // ignore: cast_nullable_to_non_nullable
as DateTime?,paidByMemberId: freezed == paidByMemberId ? _self.paidByMemberId : paidByMemberId // ignore: cast_nullable_to_non_nullable
as String?,splitMemberIds: null == splitMemberIds ? _self.splitMemberIds : splitMemberIds // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [FixedExpense].
extension FixedExpensePatterns on FixedExpense {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FixedExpense value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FixedExpense() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FixedExpense value)  $default,){
final _that = this;
switch (_that) {
case _FixedExpense():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FixedExpense value)?  $default,){
final _that = this;
switch (_that) {
case _FixedExpense() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  FixedExpenseType type,  double amount,  DateTime dueDate,  int month,  int year,  String? description,  bool isPaid,  DateTime? paidAt,  String? paidByMemberId,  List<String> splitMemberIds)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FixedExpense() when $default != null:
return $default(_that.id,_that.type,_that.amount,_that.dueDate,_that.month,_that.year,_that.description,_that.isPaid,_that.paidAt,_that.paidByMemberId,_that.splitMemberIds);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  FixedExpenseType type,  double amount,  DateTime dueDate,  int month,  int year,  String? description,  bool isPaid,  DateTime? paidAt,  String? paidByMemberId,  List<String> splitMemberIds)  $default,) {final _that = this;
switch (_that) {
case _FixedExpense():
return $default(_that.id,_that.type,_that.amount,_that.dueDate,_that.month,_that.year,_that.description,_that.isPaid,_that.paidAt,_that.paidByMemberId,_that.splitMemberIds);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  FixedExpenseType type,  double amount,  DateTime dueDate,  int month,  int year,  String? description,  bool isPaid,  DateTime? paidAt,  String? paidByMemberId,  List<String> splitMemberIds)?  $default,) {final _that = this;
switch (_that) {
case _FixedExpense() when $default != null:
return $default(_that.id,_that.type,_that.amount,_that.dueDate,_that.month,_that.year,_that.description,_that.isPaid,_that.paidAt,_that.paidByMemberId,_that.splitMemberIds);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _FixedExpense implements FixedExpense {
  const _FixedExpense({required this.id, required this.type, required this.amount, required this.dueDate, required this.month, required this.year, this.description, this.isPaid = false, this.paidAt, this.paidByMemberId, final  List<String> splitMemberIds = const []}): _splitMemberIds = splitMemberIds;
  factory _FixedExpense.fromJson(Map<String, dynamic> json) => _$FixedExpenseFromJson(json);

@override final  String id;
@override final  FixedExpenseType type;
@override final  double amount;
@override final  DateTime dueDate;
@override final  int month;
// 1-12
@override final  int year;
@override final  String? description;
@override@JsonKey() final  bool isPaid;
@override final  DateTime? paidAt;
@override final  String? paidByMemberId;
 final  List<String> _splitMemberIds;
@override@JsonKey() List<String> get splitMemberIds {
  if (_splitMemberIds is EqualUnmodifiableListView) return _splitMemberIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_splitMemberIds);
}


/// Create a copy of FixedExpense
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FixedExpenseCopyWith<_FixedExpense> get copyWith => __$FixedExpenseCopyWithImpl<_FixedExpense>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FixedExpenseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FixedExpense&&(identical(other.id, id) || other.id == id)&&(identical(other.type, type) || other.type == type)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.dueDate, dueDate) || other.dueDate == dueDate)&&(identical(other.month, month) || other.month == month)&&(identical(other.year, year) || other.year == year)&&(identical(other.description, description) || other.description == description)&&(identical(other.isPaid, isPaid) || other.isPaid == isPaid)&&(identical(other.paidAt, paidAt) || other.paidAt == paidAt)&&(identical(other.paidByMemberId, paidByMemberId) || other.paidByMemberId == paidByMemberId)&&const DeepCollectionEquality().equals(other._splitMemberIds, _splitMemberIds));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,type,amount,dueDate,month,year,description,isPaid,paidAt,paidByMemberId,const DeepCollectionEquality().hash(_splitMemberIds));

@override
String toString() {
  return 'FixedExpense(id: $id, type: $type, amount: $amount, dueDate: $dueDate, month: $month, year: $year, description: $description, isPaid: $isPaid, paidAt: $paidAt, paidByMemberId: $paidByMemberId, splitMemberIds: $splitMemberIds)';
}


}

/// @nodoc
abstract mixin class _$FixedExpenseCopyWith<$Res> implements $FixedExpenseCopyWith<$Res> {
  factory _$FixedExpenseCopyWith(_FixedExpense value, $Res Function(_FixedExpense) _then) = __$FixedExpenseCopyWithImpl;
@override @useResult
$Res call({
 String id, FixedExpenseType type, double amount, DateTime dueDate, int month, int year, String? description, bool isPaid, DateTime? paidAt, String? paidByMemberId, List<String> splitMemberIds
});




}
/// @nodoc
class __$FixedExpenseCopyWithImpl<$Res>
    implements _$FixedExpenseCopyWith<$Res> {
  __$FixedExpenseCopyWithImpl(this._self, this._then);

  final _FixedExpense _self;
  final $Res Function(_FixedExpense) _then;

/// Create a copy of FixedExpense
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? type = null,Object? amount = null,Object? dueDate = null,Object? month = null,Object? year = null,Object? description = freezed,Object? isPaid = null,Object? paidAt = freezed,Object? paidByMemberId = freezed,Object? splitMemberIds = null,}) {
  return _then(_FixedExpense(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as FixedExpenseType,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as double,dueDate: null == dueDate ? _self.dueDate : dueDate // ignore: cast_nullable_to_non_nullable
as DateTime,month: null == month ? _self.month : month // ignore: cast_nullable_to_non_nullable
as int,year: null == year ? _self.year : year // ignore: cast_nullable_to_non_nullable
as int,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,isPaid: null == isPaid ? _self.isPaid : isPaid // ignore: cast_nullable_to_non_nullable
as bool,paidAt: freezed == paidAt ? _self.paidAt : paidAt // ignore: cast_nullable_to_non_nullable
as DateTime?,paidByMemberId: freezed == paidByMemberId ? _self.paidByMemberId : paidByMemberId // ignore: cast_nullable_to_non_nullable
as String?,splitMemberIds: null == splitMemberIds ? _self._splitMemberIds : splitMemberIds // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}


/// @nodoc
mixin _$FixedExpensePayment {

 String get id; String get expenseId; String get memberId; double get shareAmount; bool get isPaid; DateTime? get paidAt;
/// Create a copy of FixedExpensePayment
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FixedExpensePaymentCopyWith<FixedExpensePayment> get copyWith => _$FixedExpensePaymentCopyWithImpl<FixedExpensePayment>(this as FixedExpensePayment, _$identity);

  /// Serializes this FixedExpensePayment to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FixedExpensePayment&&(identical(other.id, id) || other.id == id)&&(identical(other.expenseId, expenseId) || other.expenseId == expenseId)&&(identical(other.memberId, memberId) || other.memberId == memberId)&&(identical(other.shareAmount, shareAmount) || other.shareAmount == shareAmount)&&(identical(other.isPaid, isPaid) || other.isPaid == isPaid)&&(identical(other.paidAt, paidAt) || other.paidAt == paidAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,expenseId,memberId,shareAmount,isPaid,paidAt);

@override
String toString() {
  return 'FixedExpensePayment(id: $id, expenseId: $expenseId, memberId: $memberId, shareAmount: $shareAmount, isPaid: $isPaid, paidAt: $paidAt)';
}


}

/// @nodoc
abstract mixin class $FixedExpensePaymentCopyWith<$Res>  {
  factory $FixedExpensePaymentCopyWith(FixedExpensePayment value, $Res Function(FixedExpensePayment) _then) = _$FixedExpensePaymentCopyWithImpl;
@useResult
$Res call({
 String id, String expenseId, String memberId, double shareAmount, bool isPaid, DateTime? paidAt
});




}
/// @nodoc
class _$FixedExpensePaymentCopyWithImpl<$Res>
    implements $FixedExpensePaymentCopyWith<$Res> {
  _$FixedExpensePaymentCopyWithImpl(this._self, this._then);

  final FixedExpensePayment _self;
  final $Res Function(FixedExpensePayment) _then;

/// Create a copy of FixedExpensePayment
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? expenseId = null,Object? memberId = null,Object? shareAmount = null,Object? isPaid = null,Object? paidAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,expenseId: null == expenseId ? _self.expenseId : expenseId // ignore: cast_nullable_to_non_nullable
as String,memberId: null == memberId ? _self.memberId : memberId // ignore: cast_nullable_to_non_nullable
as String,shareAmount: null == shareAmount ? _self.shareAmount : shareAmount // ignore: cast_nullable_to_non_nullable
as double,isPaid: null == isPaid ? _self.isPaid : isPaid // ignore: cast_nullable_to_non_nullable
as bool,paidAt: freezed == paidAt ? _self.paidAt : paidAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [FixedExpensePayment].
extension FixedExpensePaymentPatterns on FixedExpensePayment {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FixedExpensePayment value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FixedExpensePayment() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FixedExpensePayment value)  $default,){
final _that = this;
switch (_that) {
case _FixedExpensePayment():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FixedExpensePayment value)?  $default,){
final _that = this;
switch (_that) {
case _FixedExpensePayment() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String expenseId,  String memberId,  double shareAmount,  bool isPaid,  DateTime? paidAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FixedExpensePayment() when $default != null:
return $default(_that.id,_that.expenseId,_that.memberId,_that.shareAmount,_that.isPaid,_that.paidAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String expenseId,  String memberId,  double shareAmount,  bool isPaid,  DateTime? paidAt)  $default,) {final _that = this;
switch (_that) {
case _FixedExpensePayment():
return $default(_that.id,_that.expenseId,_that.memberId,_that.shareAmount,_that.isPaid,_that.paidAt);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String expenseId,  String memberId,  double shareAmount,  bool isPaid,  DateTime? paidAt)?  $default,) {final _that = this;
switch (_that) {
case _FixedExpensePayment() when $default != null:
return $default(_that.id,_that.expenseId,_that.memberId,_that.shareAmount,_that.isPaid,_that.paidAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _FixedExpensePayment implements FixedExpensePayment {
  const _FixedExpensePayment({required this.id, required this.expenseId, required this.memberId, required this.shareAmount, this.isPaid = false, this.paidAt});
  factory _FixedExpensePayment.fromJson(Map<String, dynamic> json) => _$FixedExpensePaymentFromJson(json);

@override final  String id;
@override final  String expenseId;
@override final  String memberId;
@override final  double shareAmount;
@override@JsonKey() final  bool isPaid;
@override final  DateTime? paidAt;

/// Create a copy of FixedExpensePayment
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FixedExpensePaymentCopyWith<_FixedExpensePayment> get copyWith => __$FixedExpensePaymentCopyWithImpl<_FixedExpensePayment>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FixedExpensePaymentToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FixedExpensePayment&&(identical(other.id, id) || other.id == id)&&(identical(other.expenseId, expenseId) || other.expenseId == expenseId)&&(identical(other.memberId, memberId) || other.memberId == memberId)&&(identical(other.shareAmount, shareAmount) || other.shareAmount == shareAmount)&&(identical(other.isPaid, isPaid) || other.isPaid == isPaid)&&(identical(other.paidAt, paidAt) || other.paidAt == paidAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,expenseId,memberId,shareAmount,isPaid,paidAt);

@override
String toString() {
  return 'FixedExpensePayment(id: $id, expenseId: $expenseId, memberId: $memberId, shareAmount: $shareAmount, isPaid: $isPaid, paidAt: $paidAt)';
}


}

/// @nodoc
abstract mixin class _$FixedExpensePaymentCopyWith<$Res> implements $FixedExpensePaymentCopyWith<$Res> {
  factory _$FixedExpensePaymentCopyWith(_FixedExpensePayment value, $Res Function(_FixedExpensePayment) _then) = __$FixedExpensePaymentCopyWithImpl;
@override @useResult
$Res call({
 String id, String expenseId, String memberId, double shareAmount, bool isPaid, DateTime? paidAt
});




}
/// @nodoc
class __$FixedExpensePaymentCopyWithImpl<$Res>
    implements _$FixedExpensePaymentCopyWith<$Res> {
  __$FixedExpensePaymentCopyWithImpl(this._self, this._then);

  final _FixedExpensePayment _self;
  final $Res Function(_FixedExpensePayment) _then;

/// Create a copy of FixedExpensePayment
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? expenseId = null,Object? memberId = null,Object? shareAmount = null,Object? isPaid = null,Object? paidAt = freezed,}) {
  return _then(_FixedExpensePayment(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,expenseId: null == expenseId ? _self.expenseId : expenseId // ignore: cast_nullable_to_non_nullable
as String,memberId: null == memberId ? _self.memberId : memberId // ignore: cast_nullable_to_non_nullable
as String,shareAmount: null == shareAmount ? _self.shareAmount : shareAmount // ignore: cast_nullable_to_non_nullable
as double,isPaid: null == isPaid ? _self.isPaid : isPaid // ignore: cast_nullable_to_non_nullable
as bool,paidAt: freezed == paidAt ? _self.paidAt : paidAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
