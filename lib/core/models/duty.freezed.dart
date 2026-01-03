// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'duty.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DutyAssignment {

 String get id; String get messId; String get memberId; DutyType get type; DateTime get date; DutyStatus get status; DateTime? get completedAt; String? get proofImagePath;// Photo proof
 String? get note; String? get swappedWithMemberId;
/// Create a copy of DutyAssignment
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DutyAssignmentCopyWith<DutyAssignment> get copyWith => _$DutyAssignmentCopyWithImpl<DutyAssignment>(this as DutyAssignment, _$identity);

  /// Serializes this DutyAssignment to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DutyAssignment&&(identical(other.id, id) || other.id == id)&&(identical(other.messId, messId) || other.messId == messId)&&(identical(other.memberId, memberId) || other.memberId == memberId)&&(identical(other.type, type) || other.type == type)&&(identical(other.date, date) || other.date == date)&&(identical(other.status, status) || other.status == status)&&(identical(other.completedAt, completedAt) || other.completedAt == completedAt)&&(identical(other.proofImagePath, proofImagePath) || other.proofImagePath == proofImagePath)&&(identical(other.note, note) || other.note == note)&&(identical(other.swappedWithMemberId, swappedWithMemberId) || other.swappedWithMemberId == swappedWithMemberId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,messId,memberId,type,date,status,completedAt,proofImagePath,note,swappedWithMemberId);

@override
String toString() {
  return 'DutyAssignment(id: $id, messId: $messId, memberId: $memberId, type: $type, date: $date, status: $status, completedAt: $completedAt, proofImagePath: $proofImagePath, note: $note, swappedWithMemberId: $swappedWithMemberId)';
}


}

/// @nodoc
abstract mixin class $DutyAssignmentCopyWith<$Res>  {
  factory $DutyAssignmentCopyWith(DutyAssignment value, $Res Function(DutyAssignment) _then) = _$DutyAssignmentCopyWithImpl;
@useResult
$Res call({
 String id, String messId, String memberId, DutyType type, DateTime date, DutyStatus status, DateTime? completedAt, String? proofImagePath, String? note, String? swappedWithMemberId
});




}
/// @nodoc
class _$DutyAssignmentCopyWithImpl<$Res>
    implements $DutyAssignmentCopyWith<$Res> {
  _$DutyAssignmentCopyWithImpl(this._self, this._then);

  final DutyAssignment _self;
  final $Res Function(DutyAssignment) _then;

/// Create a copy of DutyAssignment
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? messId = null,Object? memberId = null,Object? type = null,Object? date = null,Object? status = null,Object? completedAt = freezed,Object? proofImagePath = freezed,Object? note = freezed,Object? swappedWithMemberId = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,messId: null == messId ? _self.messId : messId // ignore: cast_nullable_to_non_nullable
as String,memberId: null == memberId ? _self.memberId : memberId // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as DutyType,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as DutyStatus,completedAt: freezed == completedAt ? _self.completedAt : completedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,proofImagePath: freezed == proofImagePath ? _self.proofImagePath : proofImagePath // ignore: cast_nullable_to_non_nullable
as String?,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,swappedWithMemberId: freezed == swappedWithMemberId ? _self.swappedWithMemberId : swappedWithMemberId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [DutyAssignment].
extension DutyAssignmentPatterns on DutyAssignment {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DutyAssignment value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DutyAssignment() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DutyAssignment value)  $default,){
final _that = this;
switch (_that) {
case _DutyAssignment():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DutyAssignment value)?  $default,){
final _that = this;
switch (_that) {
case _DutyAssignment() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String messId,  String memberId,  DutyType type,  DateTime date,  DutyStatus status,  DateTime? completedAt,  String? proofImagePath,  String? note,  String? swappedWithMemberId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DutyAssignment() when $default != null:
return $default(_that.id,_that.messId,_that.memberId,_that.type,_that.date,_that.status,_that.completedAt,_that.proofImagePath,_that.note,_that.swappedWithMemberId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String messId,  String memberId,  DutyType type,  DateTime date,  DutyStatus status,  DateTime? completedAt,  String? proofImagePath,  String? note,  String? swappedWithMemberId)  $default,) {final _that = this;
switch (_that) {
case _DutyAssignment():
return $default(_that.id,_that.messId,_that.memberId,_that.type,_that.date,_that.status,_that.completedAt,_that.proofImagePath,_that.note,_that.swappedWithMemberId);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String messId,  String memberId,  DutyType type,  DateTime date,  DutyStatus status,  DateTime? completedAt,  String? proofImagePath,  String? note,  String? swappedWithMemberId)?  $default,) {final _that = this;
switch (_that) {
case _DutyAssignment() when $default != null:
return $default(_that.id,_that.messId,_that.memberId,_that.type,_that.date,_that.status,_that.completedAt,_that.proofImagePath,_that.note,_that.swappedWithMemberId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DutyAssignment implements DutyAssignment {
  const _DutyAssignment({required this.id, required this.messId, required this.memberId, required this.type, required this.date, this.status = DutyStatus.pending, this.completedAt, this.proofImagePath, this.note, this.swappedWithMemberId});
  factory _DutyAssignment.fromJson(Map<String, dynamic> json) => _$DutyAssignmentFromJson(json);

@override final  String id;
@override final  String messId;
@override final  String memberId;
@override final  DutyType type;
@override final  DateTime date;
@override@JsonKey() final  DutyStatus status;
@override final  DateTime? completedAt;
@override final  String? proofImagePath;
// Photo proof
@override final  String? note;
@override final  String? swappedWithMemberId;

/// Create a copy of DutyAssignment
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DutyAssignmentCopyWith<_DutyAssignment> get copyWith => __$DutyAssignmentCopyWithImpl<_DutyAssignment>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DutyAssignmentToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DutyAssignment&&(identical(other.id, id) || other.id == id)&&(identical(other.messId, messId) || other.messId == messId)&&(identical(other.memberId, memberId) || other.memberId == memberId)&&(identical(other.type, type) || other.type == type)&&(identical(other.date, date) || other.date == date)&&(identical(other.status, status) || other.status == status)&&(identical(other.completedAt, completedAt) || other.completedAt == completedAt)&&(identical(other.proofImagePath, proofImagePath) || other.proofImagePath == proofImagePath)&&(identical(other.note, note) || other.note == note)&&(identical(other.swappedWithMemberId, swappedWithMemberId) || other.swappedWithMemberId == swappedWithMemberId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,messId,memberId,type,date,status,completedAt,proofImagePath,note,swappedWithMemberId);

@override
String toString() {
  return 'DutyAssignment(id: $id, messId: $messId, memberId: $memberId, type: $type, date: $date, status: $status, completedAt: $completedAt, proofImagePath: $proofImagePath, note: $note, swappedWithMemberId: $swappedWithMemberId)';
}


}

/// @nodoc
abstract mixin class _$DutyAssignmentCopyWith<$Res> implements $DutyAssignmentCopyWith<$Res> {
  factory _$DutyAssignmentCopyWith(_DutyAssignment value, $Res Function(_DutyAssignment) _then) = __$DutyAssignmentCopyWithImpl;
@override @useResult
$Res call({
 String id, String messId, String memberId, DutyType type, DateTime date, DutyStatus status, DateTime? completedAt, String? proofImagePath, String? note, String? swappedWithMemberId
});




}
/// @nodoc
class __$DutyAssignmentCopyWithImpl<$Res>
    implements _$DutyAssignmentCopyWith<$Res> {
  __$DutyAssignmentCopyWithImpl(this._self, this._then);

  final _DutyAssignment _self;
  final $Res Function(_DutyAssignment) _then;

/// Create a copy of DutyAssignment
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? messId = null,Object? memberId = null,Object? type = null,Object? date = null,Object? status = null,Object? completedAt = freezed,Object? proofImagePath = freezed,Object? note = freezed,Object? swappedWithMemberId = freezed,}) {
  return _then(_DutyAssignment(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,messId: null == messId ? _self.messId : messId // ignore: cast_nullable_to_non_nullable
as String,memberId: null == memberId ? _self.memberId : memberId // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as DutyType,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as DutyStatus,completedAt: freezed == completedAt ? _self.completedAt : completedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,proofImagePath: freezed == proofImagePath ? _self.proofImagePath : proofImagePath // ignore: cast_nullable_to_non_nullable
as String?,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,swappedWithMemberId: freezed == swappedWithMemberId ? _self.swappedWithMemberId : swappedWithMemberId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$DutySchedule {

 String get id; String get messId; DutyType get type; List<String> get rotationOrder;// Member IDs in rotation order
 int get rotationIntervalDays;// Days per assignment
 DateTime? get lastRotatedAt; bool get isActive;
/// Create a copy of DutySchedule
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DutyScheduleCopyWith<DutySchedule> get copyWith => _$DutyScheduleCopyWithImpl<DutySchedule>(this as DutySchedule, _$identity);

  /// Serializes this DutySchedule to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DutySchedule&&(identical(other.id, id) || other.id == id)&&(identical(other.messId, messId) || other.messId == messId)&&(identical(other.type, type) || other.type == type)&&const DeepCollectionEquality().equals(other.rotationOrder, rotationOrder)&&(identical(other.rotationIntervalDays, rotationIntervalDays) || other.rotationIntervalDays == rotationIntervalDays)&&(identical(other.lastRotatedAt, lastRotatedAt) || other.lastRotatedAt == lastRotatedAt)&&(identical(other.isActive, isActive) || other.isActive == isActive));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,messId,type,const DeepCollectionEquality().hash(rotationOrder),rotationIntervalDays,lastRotatedAt,isActive);

@override
String toString() {
  return 'DutySchedule(id: $id, messId: $messId, type: $type, rotationOrder: $rotationOrder, rotationIntervalDays: $rotationIntervalDays, lastRotatedAt: $lastRotatedAt, isActive: $isActive)';
}


}

/// @nodoc
abstract mixin class $DutyScheduleCopyWith<$Res>  {
  factory $DutyScheduleCopyWith(DutySchedule value, $Res Function(DutySchedule) _then) = _$DutyScheduleCopyWithImpl;
@useResult
$Res call({
 String id, String messId, DutyType type, List<String> rotationOrder, int rotationIntervalDays, DateTime? lastRotatedAt, bool isActive
});




}
/// @nodoc
class _$DutyScheduleCopyWithImpl<$Res>
    implements $DutyScheduleCopyWith<$Res> {
  _$DutyScheduleCopyWithImpl(this._self, this._then);

  final DutySchedule _self;
  final $Res Function(DutySchedule) _then;

/// Create a copy of DutySchedule
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? messId = null,Object? type = null,Object? rotationOrder = null,Object? rotationIntervalDays = null,Object? lastRotatedAt = freezed,Object? isActive = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,messId: null == messId ? _self.messId : messId // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as DutyType,rotationOrder: null == rotationOrder ? _self.rotationOrder : rotationOrder // ignore: cast_nullable_to_non_nullable
as List<String>,rotationIntervalDays: null == rotationIntervalDays ? _self.rotationIntervalDays : rotationIntervalDays // ignore: cast_nullable_to_non_nullable
as int,lastRotatedAt: freezed == lastRotatedAt ? _self.lastRotatedAt : lastRotatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [DutySchedule].
extension DutySchedulePatterns on DutySchedule {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DutySchedule value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DutySchedule() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DutySchedule value)  $default,){
final _that = this;
switch (_that) {
case _DutySchedule():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DutySchedule value)?  $default,){
final _that = this;
switch (_that) {
case _DutySchedule() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String messId,  DutyType type,  List<String> rotationOrder,  int rotationIntervalDays,  DateTime? lastRotatedAt,  bool isActive)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DutySchedule() when $default != null:
return $default(_that.id,_that.messId,_that.type,_that.rotationOrder,_that.rotationIntervalDays,_that.lastRotatedAt,_that.isActive);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String messId,  DutyType type,  List<String> rotationOrder,  int rotationIntervalDays,  DateTime? lastRotatedAt,  bool isActive)  $default,) {final _that = this;
switch (_that) {
case _DutySchedule():
return $default(_that.id,_that.messId,_that.type,_that.rotationOrder,_that.rotationIntervalDays,_that.lastRotatedAt,_that.isActive);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String messId,  DutyType type,  List<String> rotationOrder,  int rotationIntervalDays,  DateTime? lastRotatedAt,  bool isActive)?  $default,) {final _that = this;
switch (_that) {
case _DutySchedule() when $default != null:
return $default(_that.id,_that.messId,_that.type,_that.rotationOrder,_that.rotationIntervalDays,_that.lastRotatedAt,_that.isActive);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DutySchedule implements DutySchedule {
  const _DutySchedule({required this.id, required this.messId, required this.type, required final  List<String> rotationOrder, this.rotationIntervalDays = 1, this.lastRotatedAt, this.isActive = true}): _rotationOrder = rotationOrder;
  factory _DutySchedule.fromJson(Map<String, dynamic> json) => _$DutyScheduleFromJson(json);

@override final  String id;
@override final  String messId;
@override final  DutyType type;
 final  List<String> _rotationOrder;
@override List<String> get rotationOrder {
  if (_rotationOrder is EqualUnmodifiableListView) return _rotationOrder;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_rotationOrder);
}

// Member IDs in rotation order
@override@JsonKey() final  int rotationIntervalDays;
// Days per assignment
@override final  DateTime? lastRotatedAt;
@override@JsonKey() final  bool isActive;

/// Create a copy of DutySchedule
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DutyScheduleCopyWith<_DutySchedule> get copyWith => __$DutyScheduleCopyWithImpl<_DutySchedule>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DutyScheduleToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DutySchedule&&(identical(other.id, id) || other.id == id)&&(identical(other.messId, messId) || other.messId == messId)&&(identical(other.type, type) || other.type == type)&&const DeepCollectionEquality().equals(other._rotationOrder, _rotationOrder)&&(identical(other.rotationIntervalDays, rotationIntervalDays) || other.rotationIntervalDays == rotationIntervalDays)&&(identical(other.lastRotatedAt, lastRotatedAt) || other.lastRotatedAt == lastRotatedAt)&&(identical(other.isActive, isActive) || other.isActive == isActive));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,messId,type,const DeepCollectionEquality().hash(_rotationOrder),rotationIntervalDays,lastRotatedAt,isActive);

@override
String toString() {
  return 'DutySchedule(id: $id, messId: $messId, type: $type, rotationOrder: $rotationOrder, rotationIntervalDays: $rotationIntervalDays, lastRotatedAt: $lastRotatedAt, isActive: $isActive)';
}


}

/// @nodoc
abstract mixin class _$DutyScheduleCopyWith<$Res> implements $DutyScheduleCopyWith<$Res> {
  factory _$DutyScheduleCopyWith(_DutySchedule value, $Res Function(_DutySchedule) _then) = __$DutyScheduleCopyWithImpl;
@override @useResult
$Res call({
 String id, String messId, DutyType type, List<String> rotationOrder, int rotationIntervalDays, DateTime? lastRotatedAt, bool isActive
});




}
/// @nodoc
class __$DutyScheduleCopyWithImpl<$Res>
    implements _$DutyScheduleCopyWith<$Res> {
  __$DutyScheduleCopyWithImpl(this._self, this._then);

  final _DutySchedule _self;
  final $Res Function(_DutySchedule) _then;

/// Create a copy of DutySchedule
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? messId = null,Object? type = null,Object? rotationOrder = null,Object? rotationIntervalDays = null,Object? lastRotatedAt = freezed,Object? isActive = null,}) {
  return _then(_DutySchedule(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,messId: null == messId ? _self.messId : messId // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as DutyType,rotationOrder: null == rotationOrder ? _self._rotationOrder : rotationOrder // ignore: cast_nullable_to_non_nullable
as List<String>,rotationIntervalDays: null == rotationIntervalDays ? _self.rotationIntervalDays : rotationIntervalDays // ignore: cast_nullable_to_non_nullable
as int,lastRotatedAt: freezed == lastRotatedAt ? _self.lastRotatedAt : lastRotatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$DutySwapRequest {

 String get id; String get dutyId; String get fromMemberId; String get toMemberId; DateTime get requestedAt; bool get isApproved; DateTime? get respondedAt; String? get message;
/// Create a copy of DutySwapRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DutySwapRequestCopyWith<DutySwapRequest> get copyWith => _$DutySwapRequestCopyWithImpl<DutySwapRequest>(this as DutySwapRequest, _$identity);

  /// Serializes this DutySwapRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DutySwapRequest&&(identical(other.id, id) || other.id == id)&&(identical(other.dutyId, dutyId) || other.dutyId == dutyId)&&(identical(other.fromMemberId, fromMemberId) || other.fromMemberId == fromMemberId)&&(identical(other.toMemberId, toMemberId) || other.toMemberId == toMemberId)&&(identical(other.requestedAt, requestedAt) || other.requestedAt == requestedAt)&&(identical(other.isApproved, isApproved) || other.isApproved == isApproved)&&(identical(other.respondedAt, respondedAt) || other.respondedAt == respondedAt)&&(identical(other.message, message) || other.message == message));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,dutyId,fromMemberId,toMemberId,requestedAt,isApproved,respondedAt,message);

@override
String toString() {
  return 'DutySwapRequest(id: $id, dutyId: $dutyId, fromMemberId: $fromMemberId, toMemberId: $toMemberId, requestedAt: $requestedAt, isApproved: $isApproved, respondedAt: $respondedAt, message: $message)';
}


}

/// @nodoc
abstract mixin class $DutySwapRequestCopyWith<$Res>  {
  factory $DutySwapRequestCopyWith(DutySwapRequest value, $Res Function(DutySwapRequest) _then) = _$DutySwapRequestCopyWithImpl;
@useResult
$Res call({
 String id, String dutyId, String fromMemberId, String toMemberId, DateTime requestedAt, bool isApproved, DateTime? respondedAt, String? message
});




}
/// @nodoc
class _$DutySwapRequestCopyWithImpl<$Res>
    implements $DutySwapRequestCopyWith<$Res> {
  _$DutySwapRequestCopyWithImpl(this._self, this._then);

  final DutySwapRequest _self;
  final $Res Function(DutySwapRequest) _then;

/// Create a copy of DutySwapRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? dutyId = null,Object? fromMemberId = null,Object? toMemberId = null,Object? requestedAt = null,Object? isApproved = null,Object? respondedAt = freezed,Object? message = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,dutyId: null == dutyId ? _self.dutyId : dutyId // ignore: cast_nullable_to_non_nullable
as String,fromMemberId: null == fromMemberId ? _self.fromMemberId : fromMemberId // ignore: cast_nullable_to_non_nullable
as String,toMemberId: null == toMemberId ? _self.toMemberId : toMemberId // ignore: cast_nullable_to_non_nullable
as String,requestedAt: null == requestedAt ? _self.requestedAt : requestedAt // ignore: cast_nullable_to_non_nullable
as DateTime,isApproved: null == isApproved ? _self.isApproved : isApproved // ignore: cast_nullable_to_non_nullable
as bool,respondedAt: freezed == respondedAt ? _self.respondedAt : respondedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [DutySwapRequest].
extension DutySwapRequestPatterns on DutySwapRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DutySwapRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DutySwapRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DutySwapRequest value)  $default,){
final _that = this;
switch (_that) {
case _DutySwapRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DutySwapRequest value)?  $default,){
final _that = this;
switch (_that) {
case _DutySwapRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String dutyId,  String fromMemberId,  String toMemberId,  DateTime requestedAt,  bool isApproved,  DateTime? respondedAt,  String? message)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DutySwapRequest() when $default != null:
return $default(_that.id,_that.dutyId,_that.fromMemberId,_that.toMemberId,_that.requestedAt,_that.isApproved,_that.respondedAt,_that.message);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String dutyId,  String fromMemberId,  String toMemberId,  DateTime requestedAt,  bool isApproved,  DateTime? respondedAt,  String? message)  $default,) {final _that = this;
switch (_that) {
case _DutySwapRequest():
return $default(_that.id,_that.dutyId,_that.fromMemberId,_that.toMemberId,_that.requestedAt,_that.isApproved,_that.respondedAt,_that.message);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String dutyId,  String fromMemberId,  String toMemberId,  DateTime requestedAt,  bool isApproved,  DateTime? respondedAt,  String? message)?  $default,) {final _that = this;
switch (_that) {
case _DutySwapRequest() when $default != null:
return $default(_that.id,_that.dutyId,_that.fromMemberId,_that.toMemberId,_that.requestedAt,_that.isApproved,_that.respondedAt,_that.message);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DutySwapRequest implements DutySwapRequest {
  const _DutySwapRequest({required this.id, required this.dutyId, required this.fromMemberId, required this.toMemberId, required this.requestedAt, this.isApproved = false, this.respondedAt, this.message});
  factory _DutySwapRequest.fromJson(Map<String, dynamic> json) => _$DutySwapRequestFromJson(json);

@override final  String id;
@override final  String dutyId;
@override final  String fromMemberId;
@override final  String toMemberId;
@override final  DateTime requestedAt;
@override@JsonKey() final  bool isApproved;
@override final  DateTime? respondedAt;
@override final  String? message;

/// Create a copy of DutySwapRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DutySwapRequestCopyWith<_DutySwapRequest> get copyWith => __$DutySwapRequestCopyWithImpl<_DutySwapRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DutySwapRequestToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DutySwapRequest&&(identical(other.id, id) || other.id == id)&&(identical(other.dutyId, dutyId) || other.dutyId == dutyId)&&(identical(other.fromMemberId, fromMemberId) || other.fromMemberId == fromMemberId)&&(identical(other.toMemberId, toMemberId) || other.toMemberId == toMemberId)&&(identical(other.requestedAt, requestedAt) || other.requestedAt == requestedAt)&&(identical(other.isApproved, isApproved) || other.isApproved == isApproved)&&(identical(other.respondedAt, respondedAt) || other.respondedAt == respondedAt)&&(identical(other.message, message) || other.message == message));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,dutyId,fromMemberId,toMemberId,requestedAt,isApproved,respondedAt,message);

@override
String toString() {
  return 'DutySwapRequest(id: $id, dutyId: $dutyId, fromMemberId: $fromMemberId, toMemberId: $toMemberId, requestedAt: $requestedAt, isApproved: $isApproved, respondedAt: $respondedAt, message: $message)';
}


}

/// @nodoc
abstract mixin class _$DutySwapRequestCopyWith<$Res> implements $DutySwapRequestCopyWith<$Res> {
  factory _$DutySwapRequestCopyWith(_DutySwapRequest value, $Res Function(_DutySwapRequest) _then) = __$DutySwapRequestCopyWithImpl;
@override @useResult
$Res call({
 String id, String dutyId, String fromMemberId, String toMemberId, DateTime requestedAt, bool isApproved, DateTime? respondedAt, String? message
});




}
/// @nodoc
class __$DutySwapRequestCopyWithImpl<$Res>
    implements _$DutySwapRequestCopyWith<$Res> {
  __$DutySwapRequestCopyWithImpl(this._self, this._then);

  final _DutySwapRequest _self;
  final $Res Function(_DutySwapRequest) _then;

/// Create a copy of DutySwapRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? dutyId = null,Object? fromMemberId = null,Object? toMemberId = null,Object? requestedAt = null,Object? isApproved = null,Object? respondedAt = freezed,Object? message = freezed,}) {
  return _then(_DutySwapRequest(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,dutyId: null == dutyId ? _self.dutyId : dutyId // ignore: cast_nullable_to_non_nullable
as String,fromMemberId: null == fromMemberId ? _self.fromMemberId : fromMemberId // ignore: cast_nullable_to_non_nullable
as String,toMemberId: null == toMemberId ? _self.toMemberId : toMemberId // ignore: cast_nullable_to_non_nullable
as String,requestedAt: null == requestedAt ? _self.requestedAt : requestedAt // ignore: cast_nullable_to_non_nullable
as DateTime,isApproved: null == isApproved ? _self.isApproved : isApproved // ignore: cast_nullable_to_non_nullable
as bool,respondedAt: freezed == respondedAt ? _self.respondedAt : respondedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
