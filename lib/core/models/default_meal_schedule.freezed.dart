// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'default_meal_schedule.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DefaultMealSchedule {

 String get memberId; int get weekday;// 1 = Monday, 7 = Sunday
 bool get breakfast; bool get lunch; bool get dinner;
/// Create a copy of DefaultMealSchedule
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DefaultMealScheduleCopyWith<DefaultMealSchedule> get copyWith => _$DefaultMealScheduleCopyWithImpl<DefaultMealSchedule>(this as DefaultMealSchedule, _$identity);

  /// Serializes this DefaultMealSchedule to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DefaultMealSchedule&&(identical(other.memberId, memberId) || other.memberId == memberId)&&(identical(other.weekday, weekday) || other.weekday == weekday)&&(identical(other.breakfast, breakfast) || other.breakfast == breakfast)&&(identical(other.lunch, lunch) || other.lunch == lunch)&&(identical(other.dinner, dinner) || other.dinner == dinner));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,memberId,weekday,breakfast,lunch,dinner);

@override
String toString() {
  return 'DefaultMealSchedule(memberId: $memberId, weekday: $weekday, breakfast: $breakfast, lunch: $lunch, dinner: $dinner)';
}


}

/// @nodoc
abstract mixin class $DefaultMealScheduleCopyWith<$Res>  {
  factory $DefaultMealScheduleCopyWith(DefaultMealSchedule value, $Res Function(DefaultMealSchedule) _then) = _$DefaultMealScheduleCopyWithImpl;
@useResult
$Res call({
 String memberId, int weekday, bool breakfast, bool lunch, bool dinner
});




}
/// @nodoc
class _$DefaultMealScheduleCopyWithImpl<$Res>
    implements $DefaultMealScheduleCopyWith<$Res> {
  _$DefaultMealScheduleCopyWithImpl(this._self, this._then);

  final DefaultMealSchedule _self;
  final $Res Function(DefaultMealSchedule) _then;

/// Create a copy of DefaultMealSchedule
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? memberId = null,Object? weekday = null,Object? breakfast = null,Object? lunch = null,Object? dinner = null,}) {
  return _then(_self.copyWith(
memberId: null == memberId ? _self.memberId : memberId // ignore: cast_nullable_to_non_nullable
as String,weekday: null == weekday ? _self.weekday : weekday // ignore: cast_nullable_to_non_nullable
as int,breakfast: null == breakfast ? _self.breakfast : breakfast // ignore: cast_nullable_to_non_nullable
as bool,lunch: null == lunch ? _self.lunch : lunch // ignore: cast_nullable_to_non_nullable
as bool,dinner: null == dinner ? _self.dinner : dinner // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [DefaultMealSchedule].
extension DefaultMealSchedulePatterns on DefaultMealSchedule {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DefaultMealSchedule value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DefaultMealSchedule() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DefaultMealSchedule value)  $default,){
final _that = this;
switch (_that) {
case _DefaultMealSchedule():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DefaultMealSchedule value)?  $default,){
final _that = this;
switch (_that) {
case _DefaultMealSchedule() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String memberId,  int weekday,  bool breakfast,  bool lunch,  bool dinner)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DefaultMealSchedule() when $default != null:
return $default(_that.memberId,_that.weekday,_that.breakfast,_that.lunch,_that.dinner);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String memberId,  int weekday,  bool breakfast,  bool lunch,  bool dinner)  $default,) {final _that = this;
switch (_that) {
case _DefaultMealSchedule():
return $default(_that.memberId,_that.weekday,_that.breakfast,_that.lunch,_that.dinner);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String memberId,  int weekday,  bool breakfast,  bool lunch,  bool dinner)?  $default,) {final _that = this;
switch (_that) {
case _DefaultMealSchedule() when $default != null:
return $default(_that.memberId,_that.weekday,_that.breakfast,_that.lunch,_that.dinner);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DefaultMealSchedule implements DefaultMealSchedule {
  const _DefaultMealSchedule({required this.memberId, required this.weekday, this.breakfast = false, this.lunch = true, this.dinner = true});
  factory _DefaultMealSchedule.fromJson(Map<String, dynamic> json) => _$DefaultMealScheduleFromJson(json);

@override final  String memberId;
@override final  int weekday;
// 1 = Monday, 7 = Sunday
@override@JsonKey() final  bool breakfast;
@override@JsonKey() final  bool lunch;
@override@JsonKey() final  bool dinner;

/// Create a copy of DefaultMealSchedule
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DefaultMealScheduleCopyWith<_DefaultMealSchedule> get copyWith => __$DefaultMealScheduleCopyWithImpl<_DefaultMealSchedule>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DefaultMealScheduleToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DefaultMealSchedule&&(identical(other.memberId, memberId) || other.memberId == memberId)&&(identical(other.weekday, weekday) || other.weekday == weekday)&&(identical(other.breakfast, breakfast) || other.breakfast == breakfast)&&(identical(other.lunch, lunch) || other.lunch == lunch)&&(identical(other.dinner, dinner) || other.dinner == dinner));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,memberId,weekday,breakfast,lunch,dinner);

@override
String toString() {
  return 'DefaultMealSchedule(memberId: $memberId, weekday: $weekday, breakfast: $breakfast, lunch: $lunch, dinner: $dinner)';
}


}

/// @nodoc
abstract mixin class _$DefaultMealScheduleCopyWith<$Res> implements $DefaultMealScheduleCopyWith<$Res> {
  factory _$DefaultMealScheduleCopyWith(_DefaultMealSchedule value, $Res Function(_DefaultMealSchedule) _then) = __$DefaultMealScheduleCopyWithImpl;
@override @useResult
$Res call({
 String memberId, int weekday, bool breakfast, bool lunch, bool dinner
});




}
/// @nodoc
class __$DefaultMealScheduleCopyWithImpl<$Res>
    implements _$DefaultMealScheduleCopyWith<$Res> {
  __$DefaultMealScheduleCopyWithImpl(this._self, this._then);

  final _DefaultMealSchedule _self;
  final $Res Function(_DefaultMealSchedule) _then;

/// Create a copy of DefaultMealSchedule
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? memberId = null,Object? weekday = null,Object? breakfast = null,Object? lunch = null,Object? dinner = null,}) {
  return _then(_DefaultMealSchedule(
memberId: null == memberId ? _self.memberId : memberId // ignore: cast_nullable_to_non_nullable
as String,weekday: null == weekday ? _self.weekday : weekday // ignore: cast_nullable_to_non_nullable
as int,breakfast: null == breakfast ? _self.breakfast : breakfast // ignore: cast_nullable_to_non_nullable
as bool,lunch: null == lunch ? _self.lunch : lunch // ignore: cast_nullable_to_non_nullable
as bool,dinner: null == dinner ? _self.dinner : dinner // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$WeeklySchedule {

 String get memberId; List<DefaultMealSchedule> get days;// 7 days (Mon-Sun)
 double get expectedWeeklyMeals;
/// Create a copy of WeeklySchedule
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WeeklyScheduleCopyWith<WeeklySchedule> get copyWith => _$WeeklyScheduleCopyWithImpl<WeeklySchedule>(this as WeeklySchedule, _$identity);

  /// Serializes this WeeklySchedule to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WeeklySchedule&&(identical(other.memberId, memberId) || other.memberId == memberId)&&const DeepCollectionEquality().equals(other.days, days)&&(identical(other.expectedWeeklyMeals, expectedWeeklyMeals) || other.expectedWeeklyMeals == expectedWeeklyMeals));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,memberId,const DeepCollectionEquality().hash(days),expectedWeeklyMeals);

@override
String toString() {
  return 'WeeklySchedule(memberId: $memberId, days: $days, expectedWeeklyMeals: $expectedWeeklyMeals)';
}


}

/// @nodoc
abstract mixin class $WeeklyScheduleCopyWith<$Res>  {
  factory $WeeklyScheduleCopyWith(WeeklySchedule value, $Res Function(WeeklySchedule) _then) = _$WeeklyScheduleCopyWithImpl;
@useResult
$Res call({
 String memberId, List<DefaultMealSchedule> days, double expectedWeeklyMeals
});




}
/// @nodoc
class _$WeeklyScheduleCopyWithImpl<$Res>
    implements $WeeklyScheduleCopyWith<$Res> {
  _$WeeklyScheduleCopyWithImpl(this._self, this._then);

  final WeeklySchedule _self;
  final $Res Function(WeeklySchedule) _then;

/// Create a copy of WeeklySchedule
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? memberId = null,Object? days = null,Object? expectedWeeklyMeals = null,}) {
  return _then(_self.copyWith(
memberId: null == memberId ? _self.memberId : memberId // ignore: cast_nullable_to_non_nullable
as String,days: null == days ? _self.days : days // ignore: cast_nullable_to_non_nullable
as List<DefaultMealSchedule>,expectedWeeklyMeals: null == expectedWeeklyMeals ? _self.expectedWeeklyMeals : expectedWeeklyMeals // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [WeeklySchedule].
extension WeeklySchedulePatterns on WeeklySchedule {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WeeklySchedule value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WeeklySchedule() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WeeklySchedule value)  $default,){
final _that = this;
switch (_that) {
case _WeeklySchedule():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WeeklySchedule value)?  $default,){
final _that = this;
switch (_that) {
case _WeeklySchedule() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String memberId,  List<DefaultMealSchedule> days,  double expectedWeeklyMeals)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WeeklySchedule() when $default != null:
return $default(_that.memberId,_that.days,_that.expectedWeeklyMeals);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String memberId,  List<DefaultMealSchedule> days,  double expectedWeeklyMeals)  $default,) {final _that = this;
switch (_that) {
case _WeeklySchedule():
return $default(_that.memberId,_that.days,_that.expectedWeeklyMeals);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String memberId,  List<DefaultMealSchedule> days,  double expectedWeeklyMeals)?  $default,) {final _that = this;
switch (_that) {
case _WeeklySchedule() when $default != null:
return $default(_that.memberId,_that.days,_that.expectedWeeklyMeals);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _WeeklySchedule implements WeeklySchedule {
  const _WeeklySchedule({required this.memberId, required final  List<DefaultMealSchedule> days, this.expectedWeeklyMeals = 0.0}): _days = days;
  factory _WeeklySchedule.fromJson(Map<String, dynamic> json) => _$WeeklyScheduleFromJson(json);

@override final  String memberId;
 final  List<DefaultMealSchedule> _days;
@override List<DefaultMealSchedule> get days {
  if (_days is EqualUnmodifiableListView) return _days;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_days);
}

// 7 days (Mon-Sun)
@override@JsonKey() final  double expectedWeeklyMeals;

/// Create a copy of WeeklySchedule
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WeeklyScheduleCopyWith<_WeeklySchedule> get copyWith => __$WeeklyScheduleCopyWithImpl<_WeeklySchedule>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WeeklyScheduleToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WeeklySchedule&&(identical(other.memberId, memberId) || other.memberId == memberId)&&const DeepCollectionEquality().equals(other._days, _days)&&(identical(other.expectedWeeklyMeals, expectedWeeklyMeals) || other.expectedWeeklyMeals == expectedWeeklyMeals));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,memberId,const DeepCollectionEquality().hash(_days),expectedWeeklyMeals);

@override
String toString() {
  return 'WeeklySchedule(memberId: $memberId, days: $days, expectedWeeklyMeals: $expectedWeeklyMeals)';
}


}

/// @nodoc
abstract mixin class _$WeeklyScheduleCopyWith<$Res> implements $WeeklyScheduleCopyWith<$Res> {
  factory _$WeeklyScheduleCopyWith(_WeeklySchedule value, $Res Function(_WeeklySchedule) _then) = __$WeeklyScheduleCopyWithImpl;
@override @useResult
$Res call({
 String memberId, List<DefaultMealSchedule> days, double expectedWeeklyMeals
});




}
/// @nodoc
class __$WeeklyScheduleCopyWithImpl<$Res>
    implements _$WeeklyScheduleCopyWith<$Res> {
  __$WeeklyScheduleCopyWithImpl(this._self, this._then);

  final _WeeklySchedule _self;
  final $Res Function(_WeeklySchedule) _then;

/// Create a copy of WeeklySchedule
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? memberId = null,Object? days = null,Object? expectedWeeklyMeals = null,}) {
  return _then(_WeeklySchedule(
memberId: null == memberId ? _self.memberId : memberId // ignore: cast_nullable_to_non_nullable
as String,days: null == days ? _self._days : days // ignore: cast_nullable_to_non_nullable
as List<DefaultMealSchedule>,expectedWeeklyMeals: null == expectedWeeklyMeals ? _self.expectedWeeklyMeals : expectedWeeklyMeals // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

// dart format on
