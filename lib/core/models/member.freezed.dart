// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'member.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$FoodPreference {

 RestrictionType get type; String? get allergen; String? get notes; List<int> get daysActive;
/// Create a copy of FoodPreference
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FoodPreferenceCopyWith<FoodPreference> get copyWith => _$FoodPreferenceCopyWithImpl<FoodPreference>(this as FoodPreference, _$identity);

  /// Serializes this FoodPreference to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FoodPreference&&(identical(other.type, type) || other.type == type)&&(identical(other.allergen, allergen) || other.allergen == allergen)&&(identical(other.notes, notes) || other.notes == notes)&&const DeepCollectionEquality().equals(other.daysActive, daysActive));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,type,allergen,notes,const DeepCollectionEquality().hash(daysActive));

@override
String toString() {
  return 'FoodPreference(type: $type, allergen: $allergen, notes: $notes, daysActive: $daysActive)';
}


}

/// @nodoc
abstract mixin class $FoodPreferenceCopyWith<$Res>  {
  factory $FoodPreferenceCopyWith(FoodPreference value, $Res Function(FoodPreference) _then) = _$FoodPreferenceCopyWithImpl;
@useResult
$Res call({
 RestrictionType type, String? allergen, String? notes, List<int> daysActive
});




}
/// @nodoc
class _$FoodPreferenceCopyWithImpl<$Res>
    implements $FoodPreferenceCopyWith<$Res> {
  _$FoodPreferenceCopyWithImpl(this._self, this._then);

  final FoodPreference _self;
  final $Res Function(FoodPreference) _then;

/// Create a copy of FoodPreference
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? type = null,Object? allergen = freezed,Object? notes = freezed,Object? daysActive = null,}) {
  return _then(_self.copyWith(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as RestrictionType,allergen: freezed == allergen ? _self.allergen : allergen // ignore: cast_nullable_to_non_nullable
as String?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,daysActive: null == daysActive ? _self.daysActive : daysActive // ignore: cast_nullable_to_non_nullable
as List<int>,
  ));
}

}


/// Adds pattern-matching-related methods to [FoodPreference].
extension FoodPreferencePatterns on FoodPreference {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FoodPreference value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FoodPreference() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FoodPreference value)  $default,){
final _that = this;
switch (_that) {
case _FoodPreference():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FoodPreference value)?  $default,){
final _that = this;
switch (_that) {
case _FoodPreference() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( RestrictionType type,  String? allergen,  String? notes,  List<int> daysActive)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FoodPreference() when $default != null:
return $default(_that.type,_that.allergen,_that.notes,_that.daysActive);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( RestrictionType type,  String? allergen,  String? notes,  List<int> daysActive)  $default,) {final _that = this;
switch (_that) {
case _FoodPreference():
return $default(_that.type,_that.allergen,_that.notes,_that.daysActive);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( RestrictionType type,  String? allergen,  String? notes,  List<int> daysActive)?  $default,) {final _that = this;
switch (_that) {
case _FoodPreference() when $default != null:
return $default(_that.type,_that.allergen,_that.notes,_that.daysActive);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _FoodPreference implements FoodPreference {
  const _FoodPreference({required this.type, this.allergen, this.notes, final  List<int> daysActive = const []}): _daysActive = daysActive;
  factory _FoodPreference.fromJson(Map<String, dynamic> json) => _$FoodPreferenceFromJson(json);

@override final  RestrictionType type;
@override final  String? allergen;
@override final  String? notes;
 final  List<int> _daysActive;
@override@JsonKey() List<int> get daysActive {
  if (_daysActive is EqualUnmodifiableListView) return _daysActive;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_daysActive);
}


/// Create a copy of FoodPreference
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FoodPreferenceCopyWith<_FoodPreference> get copyWith => __$FoodPreferenceCopyWithImpl<_FoodPreference>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FoodPreferenceToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FoodPreference&&(identical(other.type, type) || other.type == type)&&(identical(other.allergen, allergen) || other.allergen == allergen)&&(identical(other.notes, notes) || other.notes == notes)&&const DeepCollectionEquality().equals(other._daysActive, _daysActive));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,type,allergen,notes,const DeepCollectionEquality().hash(_daysActive));

@override
String toString() {
  return 'FoodPreference(type: $type, allergen: $allergen, notes: $notes, daysActive: $daysActive)';
}


}

/// @nodoc
abstract mixin class _$FoodPreferenceCopyWith<$Res> implements $FoodPreferenceCopyWith<$Res> {
  factory _$FoodPreferenceCopyWith(_FoodPreference value, $Res Function(_FoodPreference) _then) = __$FoodPreferenceCopyWithImpl;
@override @useResult
$Res call({
 RestrictionType type, String? allergen, String? notes, List<int> daysActive
});




}
/// @nodoc
class __$FoodPreferenceCopyWithImpl<$Res>
    implements _$FoodPreferenceCopyWith<$Res> {
  __$FoodPreferenceCopyWithImpl(this._self, this._then);

  final _FoodPreference _self;
  final $Res Function(_FoodPreference) _then;

/// Create a copy of FoodPreference
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? type = null,Object? allergen = freezed,Object? notes = freezed,Object? daysActive = null,}) {
  return _then(_FoodPreference(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as RestrictionType,allergen: freezed == allergen ? _self.allergen : allergen // ignore: cast_nullable_to_non_nullable
as String?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,daysActive: null == daysActive ? _self._daysActive : daysActive // ignore: cast_nullable_to_non_nullable
as List<int>,
  ));
}


}


/// @nodoc
mixin _$Member {

 String get id; String get name; MemberRole get role; String? get avatarUrl; String? get phone; List<FoodPreference> get preferences; double get balance;// Positive = will receive, Negative = owes
 DateTime? get joinedAt;// Temporary member fields
 DateTime? get activeFromDate;// For temp members
 DateTime? get activeToDate;// For temp members
 bool get isActive;
/// Create a copy of Member
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MemberCopyWith<Member> get copyWith => _$MemberCopyWithImpl<Member>(this as Member, _$identity);

  /// Serializes this Member to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Member&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.role, role) || other.role == role)&&(identical(other.avatarUrl, avatarUrl) || other.avatarUrl == avatarUrl)&&(identical(other.phone, phone) || other.phone == phone)&&const DeepCollectionEquality().equals(other.preferences, preferences)&&(identical(other.balance, balance) || other.balance == balance)&&(identical(other.joinedAt, joinedAt) || other.joinedAt == joinedAt)&&(identical(other.activeFromDate, activeFromDate) || other.activeFromDate == activeFromDate)&&(identical(other.activeToDate, activeToDate) || other.activeToDate == activeToDate)&&(identical(other.isActive, isActive) || other.isActive == isActive));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,role,avatarUrl,phone,const DeepCollectionEquality().hash(preferences),balance,joinedAt,activeFromDate,activeToDate,isActive);

@override
String toString() {
  return 'Member(id: $id, name: $name, role: $role, avatarUrl: $avatarUrl, phone: $phone, preferences: $preferences, balance: $balance, joinedAt: $joinedAt, activeFromDate: $activeFromDate, activeToDate: $activeToDate, isActive: $isActive)';
}


}

/// @nodoc
abstract mixin class $MemberCopyWith<$Res>  {
  factory $MemberCopyWith(Member value, $Res Function(Member) _then) = _$MemberCopyWithImpl;
@useResult
$Res call({
 String id, String name, MemberRole role, String? avatarUrl, String? phone, List<FoodPreference> preferences, double balance, DateTime? joinedAt, DateTime? activeFromDate, DateTime? activeToDate, bool isActive
});




}
/// @nodoc
class _$MemberCopyWithImpl<$Res>
    implements $MemberCopyWith<$Res> {
  _$MemberCopyWithImpl(this._self, this._then);

  final Member _self;
  final $Res Function(Member) _then;

/// Create a copy of Member
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? role = null,Object? avatarUrl = freezed,Object? phone = freezed,Object? preferences = null,Object? balance = null,Object? joinedAt = freezed,Object? activeFromDate = freezed,Object? activeToDate = freezed,Object? isActive = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as MemberRole,avatarUrl: freezed == avatarUrl ? _self.avatarUrl : avatarUrl // ignore: cast_nullable_to_non_nullable
as String?,phone: freezed == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String?,preferences: null == preferences ? _self.preferences : preferences // ignore: cast_nullable_to_non_nullable
as List<FoodPreference>,balance: null == balance ? _self.balance : balance // ignore: cast_nullable_to_non_nullable
as double,joinedAt: freezed == joinedAt ? _self.joinedAt : joinedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,activeFromDate: freezed == activeFromDate ? _self.activeFromDate : activeFromDate // ignore: cast_nullable_to_non_nullable
as DateTime?,activeToDate: freezed == activeToDate ? _self.activeToDate : activeToDate // ignore: cast_nullable_to_non_nullable
as DateTime?,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [Member].
extension MemberPatterns on Member {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Member value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Member() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Member value)  $default,){
final _that = this;
switch (_that) {
case _Member():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Member value)?  $default,){
final _that = this;
switch (_that) {
case _Member() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  MemberRole role,  String? avatarUrl,  String? phone,  List<FoodPreference> preferences,  double balance,  DateTime? joinedAt,  DateTime? activeFromDate,  DateTime? activeToDate,  bool isActive)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Member() when $default != null:
return $default(_that.id,_that.name,_that.role,_that.avatarUrl,_that.phone,_that.preferences,_that.balance,_that.joinedAt,_that.activeFromDate,_that.activeToDate,_that.isActive);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  MemberRole role,  String? avatarUrl,  String? phone,  List<FoodPreference> preferences,  double balance,  DateTime? joinedAt,  DateTime? activeFromDate,  DateTime? activeToDate,  bool isActive)  $default,) {final _that = this;
switch (_that) {
case _Member():
return $default(_that.id,_that.name,_that.role,_that.avatarUrl,_that.phone,_that.preferences,_that.balance,_that.joinedAt,_that.activeFromDate,_that.activeToDate,_that.isActive);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  MemberRole role,  String? avatarUrl,  String? phone,  List<FoodPreference> preferences,  double balance,  DateTime? joinedAt,  DateTime? activeFromDate,  DateTime? activeToDate,  bool isActive)?  $default,) {final _that = this;
switch (_that) {
case _Member() when $default != null:
return $default(_that.id,_that.name,_that.role,_that.avatarUrl,_that.phone,_that.preferences,_that.balance,_that.joinedAt,_that.activeFromDate,_that.activeToDate,_that.isActive);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Member implements Member {
  const _Member({required this.id, required this.name, this.role = MemberRole.member, this.avatarUrl, this.phone, final  List<FoodPreference> preferences = const [], this.balance = 0.0, this.joinedAt, this.activeFromDate, this.activeToDate, this.isActive = true}): _preferences = preferences;
  factory _Member.fromJson(Map<String, dynamic> json) => _$MemberFromJson(json);

@override final  String id;
@override final  String name;
@override@JsonKey() final  MemberRole role;
@override final  String? avatarUrl;
@override final  String? phone;
 final  List<FoodPreference> _preferences;
@override@JsonKey() List<FoodPreference> get preferences {
  if (_preferences is EqualUnmodifiableListView) return _preferences;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_preferences);
}

@override@JsonKey() final  double balance;
// Positive = will receive, Negative = owes
@override final  DateTime? joinedAt;
// Temporary member fields
@override final  DateTime? activeFromDate;
// For temp members
@override final  DateTime? activeToDate;
// For temp members
@override@JsonKey() final  bool isActive;

/// Create a copy of Member
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MemberCopyWith<_Member> get copyWith => __$MemberCopyWithImpl<_Member>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MemberToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Member&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.role, role) || other.role == role)&&(identical(other.avatarUrl, avatarUrl) || other.avatarUrl == avatarUrl)&&(identical(other.phone, phone) || other.phone == phone)&&const DeepCollectionEquality().equals(other._preferences, _preferences)&&(identical(other.balance, balance) || other.balance == balance)&&(identical(other.joinedAt, joinedAt) || other.joinedAt == joinedAt)&&(identical(other.activeFromDate, activeFromDate) || other.activeFromDate == activeFromDate)&&(identical(other.activeToDate, activeToDate) || other.activeToDate == activeToDate)&&(identical(other.isActive, isActive) || other.isActive == isActive));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,role,avatarUrl,phone,const DeepCollectionEquality().hash(_preferences),balance,joinedAt,activeFromDate,activeToDate,isActive);

@override
String toString() {
  return 'Member(id: $id, name: $name, role: $role, avatarUrl: $avatarUrl, phone: $phone, preferences: $preferences, balance: $balance, joinedAt: $joinedAt, activeFromDate: $activeFromDate, activeToDate: $activeToDate, isActive: $isActive)';
}


}

/// @nodoc
abstract mixin class _$MemberCopyWith<$Res> implements $MemberCopyWith<$Res> {
  factory _$MemberCopyWith(_Member value, $Res Function(_Member) _then) = __$MemberCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, MemberRole role, String? avatarUrl, String? phone, List<FoodPreference> preferences, double balance, DateTime? joinedAt, DateTime? activeFromDate, DateTime? activeToDate, bool isActive
});




}
/// @nodoc
class __$MemberCopyWithImpl<$Res>
    implements _$MemberCopyWith<$Res> {
  __$MemberCopyWithImpl(this._self, this._then);

  final _Member _self;
  final $Res Function(_Member) _then;

/// Create a copy of Member
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? role = null,Object? avatarUrl = freezed,Object? phone = freezed,Object? preferences = null,Object? balance = null,Object? joinedAt = freezed,Object? activeFromDate = freezed,Object? activeToDate = freezed,Object? isActive = null,}) {
  return _then(_Member(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as MemberRole,avatarUrl: freezed == avatarUrl ? _self.avatarUrl : avatarUrl // ignore: cast_nullable_to_non_nullable
as String?,phone: freezed == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String?,preferences: null == preferences ? _self._preferences : preferences // ignore: cast_nullable_to_non_nullable
as List<FoodPreference>,balance: null == balance ? _self.balance : balance // ignore: cast_nullable_to_non_nullable
as double,joinedAt: freezed == joinedAt ? _self.joinedAt : joinedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,activeFromDate: freezed == activeFromDate ? _self.activeFromDate : activeFromDate // ignore: cast_nullable_to_non_nullable
as DateTime?,activeToDate: freezed == activeToDate ? _self.activeToDate : activeToDate // ignore: cast_nullable_to_non_nullable
as DateTime?,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
