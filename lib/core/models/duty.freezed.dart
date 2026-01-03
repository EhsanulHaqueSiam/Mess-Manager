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

 String get id; String get messId; String get memberId; DutyType get type; DateTime get date; DutyStatus get status; DateTime? get completedAt; String? get proofImagePath;// Photo proof when completing
 String? get note; String? get swappedWithMemberId;// If swapped
// Dispute fields
 String? get disputedBy;// Member ID who disputed
 String? get disputePhotoPath;// Counter-evidence photo
 String? get disputeReason;// Reason for dispute
 DateTime? get disputedAt;// Admin review
 String? get adminNotes; String? get reviewedBy;// Admin who reviewed
 DateTime? get reviewedAt;// Substitute tracking
 String? get completedByMemberId;
/// Create a copy of DutyAssignment
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DutyAssignmentCopyWith<DutyAssignment> get copyWith => _$DutyAssignmentCopyWithImpl<DutyAssignment>(this as DutyAssignment, _$identity);

  /// Serializes this DutyAssignment to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DutyAssignment&&(identical(other.id, id) || other.id == id)&&(identical(other.messId, messId) || other.messId == messId)&&(identical(other.memberId, memberId) || other.memberId == memberId)&&(identical(other.type, type) || other.type == type)&&(identical(other.date, date) || other.date == date)&&(identical(other.status, status) || other.status == status)&&(identical(other.completedAt, completedAt) || other.completedAt == completedAt)&&(identical(other.proofImagePath, proofImagePath) || other.proofImagePath == proofImagePath)&&(identical(other.note, note) || other.note == note)&&(identical(other.swappedWithMemberId, swappedWithMemberId) || other.swappedWithMemberId == swappedWithMemberId)&&(identical(other.disputedBy, disputedBy) || other.disputedBy == disputedBy)&&(identical(other.disputePhotoPath, disputePhotoPath) || other.disputePhotoPath == disputePhotoPath)&&(identical(other.disputeReason, disputeReason) || other.disputeReason == disputeReason)&&(identical(other.disputedAt, disputedAt) || other.disputedAt == disputedAt)&&(identical(other.adminNotes, adminNotes) || other.adminNotes == adminNotes)&&(identical(other.reviewedBy, reviewedBy) || other.reviewedBy == reviewedBy)&&(identical(other.reviewedAt, reviewedAt) || other.reviewedAt == reviewedAt)&&(identical(other.completedByMemberId, completedByMemberId) || other.completedByMemberId == completedByMemberId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,messId,memberId,type,date,status,completedAt,proofImagePath,note,swappedWithMemberId,disputedBy,disputePhotoPath,disputeReason,disputedAt,adminNotes,reviewedBy,reviewedAt,completedByMemberId);

@override
String toString() {
  return 'DutyAssignment(id: $id, messId: $messId, memberId: $memberId, type: $type, date: $date, status: $status, completedAt: $completedAt, proofImagePath: $proofImagePath, note: $note, swappedWithMemberId: $swappedWithMemberId, disputedBy: $disputedBy, disputePhotoPath: $disputePhotoPath, disputeReason: $disputeReason, disputedAt: $disputedAt, adminNotes: $adminNotes, reviewedBy: $reviewedBy, reviewedAt: $reviewedAt, completedByMemberId: $completedByMemberId)';
}


}

/// @nodoc
abstract mixin class $DutyAssignmentCopyWith<$Res>  {
  factory $DutyAssignmentCopyWith(DutyAssignment value, $Res Function(DutyAssignment) _then) = _$DutyAssignmentCopyWithImpl;
@useResult
$Res call({
 String id, String messId, String memberId, DutyType type, DateTime date, DutyStatus status, DateTime? completedAt, String? proofImagePath, String? note, String? swappedWithMemberId, String? disputedBy, String? disputePhotoPath, String? disputeReason, DateTime? disputedAt, String? adminNotes, String? reviewedBy, DateTime? reviewedAt, String? completedByMemberId
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
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? messId = null,Object? memberId = null,Object? type = null,Object? date = null,Object? status = null,Object? completedAt = freezed,Object? proofImagePath = freezed,Object? note = freezed,Object? swappedWithMemberId = freezed,Object? disputedBy = freezed,Object? disputePhotoPath = freezed,Object? disputeReason = freezed,Object? disputedAt = freezed,Object? adminNotes = freezed,Object? reviewedBy = freezed,Object? reviewedAt = freezed,Object? completedByMemberId = freezed,}) {
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
as String?,disputedBy: freezed == disputedBy ? _self.disputedBy : disputedBy // ignore: cast_nullable_to_non_nullable
as String?,disputePhotoPath: freezed == disputePhotoPath ? _self.disputePhotoPath : disputePhotoPath // ignore: cast_nullable_to_non_nullable
as String?,disputeReason: freezed == disputeReason ? _self.disputeReason : disputeReason // ignore: cast_nullable_to_non_nullable
as String?,disputedAt: freezed == disputedAt ? _self.disputedAt : disputedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,adminNotes: freezed == adminNotes ? _self.adminNotes : adminNotes // ignore: cast_nullable_to_non_nullable
as String?,reviewedBy: freezed == reviewedBy ? _self.reviewedBy : reviewedBy // ignore: cast_nullable_to_non_nullable
as String?,reviewedAt: freezed == reviewedAt ? _self.reviewedAt : reviewedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,completedByMemberId: freezed == completedByMemberId ? _self.completedByMemberId : completedByMemberId // ignore: cast_nullable_to_non_nullable
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String messId,  String memberId,  DutyType type,  DateTime date,  DutyStatus status,  DateTime? completedAt,  String? proofImagePath,  String? note,  String? swappedWithMemberId,  String? disputedBy,  String? disputePhotoPath,  String? disputeReason,  DateTime? disputedAt,  String? adminNotes,  String? reviewedBy,  DateTime? reviewedAt,  String? completedByMemberId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DutyAssignment() when $default != null:
return $default(_that.id,_that.messId,_that.memberId,_that.type,_that.date,_that.status,_that.completedAt,_that.proofImagePath,_that.note,_that.swappedWithMemberId,_that.disputedBy,_that.disputePhotoPath,_that.disputeReason,_that.disputedAt,_that.adminNotes,_that.reviewedBy,_that.reviewedAt,_that.completedByMemberId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String messId,  String memberId,  DutyType type,  DateTime date,  DutyStatus status,  DateTime? completedAt,  String? proofImagePath,  String? note,  String? swappedWithMemberId,  String? disputedBy,  String? disputePhotoPath,  String? disputeReason,  DateTime? disputedAt,  String? adminNotes,  String? reviewedBy,  DateTime? reviewedAt,  String? completedByMemberId)  $default,) {final _that = this;
switch (_that) {
case _DutyAssignment():
return $default(_that.id,_that.messId,_that.memberId,_that.type,_that.date,_that.status,_that.completedAt,_that.proofImagePath,_that.note,_that.swappedWithMemberId,_that.disputedBy,_that.disputePhotoPath,_that.disputeReason,_that.disputedAt,_that.adminNotes,_that.reviewedBy,_that.reviewedAt,_that.completedByMemberId);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String messId,  String memberId,  DutyType type,  DateTime date,  DutyStatus status,  DateTime? completedAt,  String? proofImagePath,  String? note,  String? swappedWithMemberId,  String? disputedBy,  String? disputePhotoPath,  String? disputeReason,  DateTime? disputedAt,  String? adminNotes,  String? reviewedBy,  DateTime? reviewedAt,  String? completedByMemberId)?  $default,) {final _that = this;
switch (_that) {
case _DutyAssignment() when $default != null:
return $default(_that.id,_that.messId,_that.memberId,_that.type,_that.date,_that.status,_that.completedAt,_that.proofImagePath,_that.note,_that.swappedWithMemberId,_that.disputedBy,_that.disputePhotoPath,_that.disputeReason,_that.disputedAt,_that.adminNotes,_that.reviewedBy,_that.reviewedAt,_that.completedByMemberId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DutyAssignment implements DutyAssignment {
  const _DutyAssignment({required this.id, required this.messId, required this.memberId, required this.type, required this.date, this.status = DutyStatus.pending, this.completedAt, this.proofImagePath, this.note, this.swappedWithMemberId, this.disputedBy, this.disputePhotoPath, this.disputeReason, this.disputedAt, this.adminNotes, this.reviewedBy, this.reviewedAt, this.completedByMemberId});
  factory _DutyAssignment.fromJson(Map<String, dynamic> json) => _$DutyAssignmentFromJson(json);

@override final  String id;
@override final  String messId;
@override final  String memberId;
@override final  DutyType type;
@override final  DateTime date;
@override@JsonKey() final  DutyStatus status;
@override final  DateTime? completedAt;
@override final  String? proofImagePath;
// Photo proof when completing
@override final  String? note;
@override final  String? swappedWithMemberId;
// If swapped
// Dispute fields
@override final  String? disputedBy;
// Member ID who disputed
@override final  String? disputePhotoPath;
// Counter-evidence photo
@override final  String? disputeReason;
// Reason for dispute
@override final  DateTime? disputedAt;
// Admin review
@override final  String? adminNotes;
@override final  String? reviewedBy;
// Admin who reviewed
@override final  DateTime? reviewedAt;
// Substitute tracking
@override final  String? completedByMemberId;

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
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DutyAssignment&&(identical(other.id, id) || other.id == id)&&(identical(other.messId, messId) || other.messId == messId)&&(identical(other.memberId, memberId) || other.memberId == memberId)&&(identical(other.type, type) || other.type == type)&&(identical(other.date, date) || other.date == date)&&(identical(other.status, status) || other.status == status)&&(identical(other.completedAt, completedAt) || other.completedAt == completedAt)&&(identical(other.proofImagePath, proofImagePath) || other.proofImagePath == proofImagePath)&&(identical(other.note, note) || other.note == note)&&(identical(other.swappedWithMemberId, swappedWithMemberId) || other.swappedWithMemberId == swappedWithMemberId)&&(identical(other.disputedBy, disputedBy) || other.disputedBy == disputedBy)&&(identical(other.disputePhotoPath, disputePhotoPath) || other.disputePhotoPath == disputePhotoPath)&&(identical(other.disputeReason, disputeReason) || other.disputeReason == disputeReason)&&(identical(other.disputedAt, disputedAt) || other.disputedAt == disputedAt)&&(identical(other.adminNotes, adminNotes) || other.adminNotes == adminNotes)&&(identical(other.reviewedBy, reviewedBy) || other.reviewedBy == reviewedBy)&&(identical(other.reviewedAt, reviewedAt) || other.reviewedAt == reviewedAt)&&(identical(other.completedByMemberId, completedByMemberId) || other.completedByMemberId == completedByMemberId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,messId,memberId,type,date,status,completedAt,proofImagePath,note,swappedWithMemberId,disputedBy,disputePhotoPath,disputeReason,disputedAt,adminNotes,reviewedBy,reviewedAt,completedByMemberId);

@override
String toString() {
  return 'DutyAssignment(id: $id, messId: $messId, memberId: $memberId, type: $type, date: $date, status: $status, completedAt: $completedAt, proofImagePath: $proofImagePath, note: $note, swappedWithMemberId: $swappedWithMemberId, disputedBy: $disputedBy, disputePhotoPath: $disputePhotoPath, disputeReason: $disputeReason, disputedAt: $disputedAt, adminNotes: $adminNotes, reviewedBy: $reviewedBy, reviewedAt: $reviewedAt, completedByMemberId: $completedByMemberId)';
}


}

/// @nodoc
abstract mixin class _$DutyAssignmentCopyWith<$Res> implements $DutyAssignmentCopyWith<$Res> {
  factory _$DutyAssignmentCopyWith(_DutyAssignment value, $Res Function(_DutyAssignment) _then) = __$DutyAssignmentCopyWithImpl;
@override @useResult
$Res call({
 String id, String messId, String memberId, DutyType type, DateTime date, DutyStatus status, DateTime? completedAt, String? proofImagePath, String? note, String? swappedWithMemberId, String? disputedBy, String? disputePhotoPath, String? disputeReason, DateTime? disputedAt, String? adminNotes, String? reviewedBy, DateTime? reviewedAt, String? completedByMemberId
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
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? messId = null,Object? memberId = null,Object? type = null,Object? date = null,Object? status = null,Object? completedAt = freezed,Object? proofImagePath = freezed,Object? note = freezed,Object? swappedWithMemberId = freezed,Object? disputedBy = freezed,Object? disputePhotoPath = freezed,Object? disputeReason = freezed,Object? disputedAt = freezed,Object? adminNotes = freezed,Object? reviewedBy = freezed,Object? reviewedAt = freezed,Object? completedByMemberId = freezed,}) {
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
as String?,disputedBy: freezed == disputedBy ? _self.disputedBy : disputedBy // ignore: cast_nullable_to_non_nullable
as String?,disputePhotoPath: freezed == disputePhotoPath ? _self.disputePhotoPath : disputePhotoPath // ignore: cast_nullable_to_non_nullable
as String?,disputeReason: freezed == disputeReason ? _self.disputeReason : disputeReason // ignore: cast_nullable_to_non_nullable
as String?,disputedAt: freezed == disputedAt ? _self.disputedAt : disputedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,adminNotes: freezed == adminNotes ? _self.adminNotes : adminNotes // ignore: cast_nullable_to_non_nullable
as String?,reviewedBy: freezed == reviewedBy ? _self.reviewedBy : reviewedBy // ignore: cast_nullable_to_non_nullable
as String?,reviewedAt: freezed == reviewedAt ? _self.reviewedAt : reviewedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,completedByMemberId: freezed == completedByMemberId ? _self.completedByMemberId : completedByMemberId // ignore: cast_nullable_to_non_nullable
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


/// @nodoc
mixin _$DutyDebt {

 String get id; String get debtorId;// Who owes the duty
 String get creditorId;// Who did the work
 DutyType get dutyType; DateTime get date; String get originalDutyId;// Link to original assignment
 bool get isSettled; DateTime? get settledAt; String? get settledByDutyId;
/// Create a copy of DutyDebt
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DutyDebtCopyWith<DutyDebt> get copyWith => _$DutyDebtCopyWithImpl<DutyDebt>(this as DutyDebt, _$identity);

  /// Serializes this DutyDebt to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DutyDebt&&(identical(other.id, id) || other.id == id)&&(identical(other.debtorId, debtorId) || other.debtorId == debtorId)&&(identical(other.creditorId, creditorId) || other.creditorId == creditorId)&&(identical(other.dutyType, dutyType) || other.dutyType == dutyType)&&(identical(other.date, date) || other.date == date)&&(identical(other.originalDutyId, originalDutyId) || other.originalDutyId == originalDutyId)&&(identical(other.isSettled, isSettled) || other.isSettled == isSettled)&&(identical(other.settledAt, settledAt) || other.settledAt == settledAt)&&(identical(other.settledByDutyId, settledByDutyId) || other.settledByDutyId == settledByDutyId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,debtorId,creditorId,dutyType,date,originalDutyId,isSettled,settledAt,settledByDutyId);

@override
String toString() {
  return 'DutyDebt(id: $id, debtorId: $debtorId, creditorId: $creditorId, dutyType: $dutyType, date: $date, originalDutyId: $originalDutyId, isSettled: $isSettled, settledAt: $settledAt, settledByDutyId: $settledByDutyId)';
}


}

/// @nodoc
abstract mixin class $DutyDebtCopyWith<$Res>  {
  factory $DutyDebtCopyWith(DutyDebt value, $Res Function(DutyDebt) _then) = _$DutyDebtCopyWithImpl;
@useResult
$Res call({
 String id, String debtorId, String creditorId, DutyType dutyType, DateTime date, String originalDutyId, bool isSettled, DateTime? settledAt, String? settledByDutyId
});




}
/// @nodoc
class _$DutyDebtCopyWithImpl<$Res>
    implements $DutyDebtCopyWith<$Res> {
  _$DutyDebtCopyWithImpl(this._self, this._then);

  final DutyDebt _self;
  final $Res Function(DutyDebt) _then;

/// Create a copy of DutyDebt
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? debtorId = null,Object? creditorId = null,Object? dutyType = null,Object? date = null,Object? originalDutyId = null,Object? isSettled = null,Object? settledAt = freezed,Object? settledByDutyId = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,debtorId: null == debtorId ? _self.debtorId : debtorId // ignore: cast_nullable_to_non_nullable
as String,creditorId: null == creditorId ? _self.creditorId : creditorId // ignore: cast_nullable_to_non_nullable
as String,dutyType: null == dutyType ? _self.dutyType : dutyType // ignore: cast_nullable_to_non_nullable
as DutyType,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,originalDutyId: null == originalDutyId ? _self.originalDutyId : originalDutyId // ignore: cast_nullable_to_non_nullable
as String,isSettled: null == isSettled ? _self.isSettled : isSettled // ignore: cast_nullable_to_non_nullable
as bool,settledAt: freezed == settledAt ? _self.settledAt : settledAt // ignore: cast_nullable_to_non_nullable
as DateTime?,settledByDutyId: freezed == settledByDutyId ? _self.settledByDutyId : settledByDutyId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [DutyDebt].
extension DutyDebtPatterns on DutyDebt {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DutyDebt value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DutyDebt() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DutyDebt value)  $default,){
final _that = this;
switch (_that) {
case _DutyDebt():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DutyDebt value)?  $default,){
final _that = this;
switch (_that) {
case _DutyDebt() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String debtorId,  String creditorId,  DutyType dutyType,  DateTime date,  String originalDutyId,  bool isSettled,  DateTime? settledAt,  String? settledByDutyId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DutyDebt() when $default != null:
return $default(_that.id,_that.debtorId,_that.creditorId,_that.dutyType,_that.date,_that.originalDutyId,_that.isSettled,_that.settledAt,_that.settledByDutyId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String debtorId,  String creditorId,  DutyType dutyType,  DateTime date,  String originalDutyId,  bool isSettled,  DateTime? settledAt,  String? settledByDutyId)  $default,) {final _that = this;
switch (_that) {
case _DutyDebt():
return $default(_that.id,_that.debtorId,_that.creditorId,_that.dutyType,_that.date,_that.originalDutyId,_that.isSettled,_that.settledAt,_that.settledByDutyId);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String debtorId,  String creditorId,  DutyType dutyType,  DateTime date,  String originalDutyId,  bool isSettled,  DateTime? settledAt,  String? settledByDutyId)?  $default,) {final _that = this;
switch (_that) {
case _DutyDebt() when $default != null:
return $default(_that.id,_that.debtorId,_that.creditorId,_that.dutyType,_that.date,_that.originalDutyId,_that.isSettled,_that.settledAt,_that.settledByDutyId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DutyDebt implements DutyDebt {
  const _DutyDebt({required this.id, required this.debtorId, required this.creditorId, required this.dutyType, required this.date, required this.originalDutyId, this.isSettled = false, this.settledAt, this.settledByDutyId});
  factory _DutyDebt.fromJson(Map<String, dynamic> json) => _$DutyDebtFromJson(json);

@override final  String id;
@override final  String debtorId;
// Who owes the duty
@override final  String creditorId;
// Who did the work
@override final  DutyType dutyType;
@override final  DateTime date;
@override final  String originalDutyId;
// Link to original assignment
@override@JsonKey() final  bool isSettled;
@override final  DateTime? settledAt;
@override final  String? settledByDutyId;

/// Create a copy of DutyDebt
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DutyDebtCopyWith<_DutyDebt> get copyWith => __$DutyDebtCopyWithImpl<_DutyDebt>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DutyDebtToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DutyDebt&&(identical(other.id, id) || other.id == id)&&(identical(other.debtorId, debtorId) || other.debtorId == debtorId)&&(identical(other.creditorId, creditorId) || other.creditorId == creditorId)&&(identical(other.dutyType, dutyType) || other.dutyType == dutyType)&&(identical(other.date, date) || other.date == date)&&(identical(other.originalDutyId, originalDutyId) || other.originalDutyId == originalDutyId)&&(identical(other.isSettled, isSettled) || other.isSettled == isSettled)&&(identical(other.settledAt, settledAt) || other.settledAt == settledAt)&&(identical(other.settledByDutyId, settledByDutyId) || other.settledByDutyId == settledByDutyId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,debtorId,creditorId,dutyType,date,originalDutyId,isSettled,settledAt,settledByDutyId);

@override
String toString() {
  return 'DutyDebt(id: $id, debtorId: $debtorId, creditorId: $creditorId, dutyType: $dutyType, date: $date, originalDutyId: $originalDutyId, isSettled: $isSettled, settledAt: $settledAt, settledByDutyId: $settledByDutyId)';
}


}

/// @nodoc
abstract mixin class _$DutyDebtCopyWith<$Res> implements $DutyDebtCopyWith<$Res> {
  factory _$DutyDebtCopyWith(_DutyDebt value, $Res Function(_DutyDebt) _then) = __$DutyDebtCopyWithImpl;
@override @useResult
$Res call({
 String id, String debtorId, String creditorId, DutyType dutyType, DateTime date, String originalDutyId, bool isSettled, DateTime? settledAt, String? settledByDutyId
});




}
/// @nodoc
class __$DutyDebtCopyWithImpl<$Res>
    implements _$DutyDebtCopyWith<$Res> {
  __$DutyDebtCopyWithImpl(this._self, this._then);

  final _DutyDebt _self;
  final $Res Function(_DutyDebt) _then;

/// Create a copy of DutyDebt
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? debtorId = null,Object? creditorId = null,Object? dutyType = null,Object? date = null,Object? originalDutyId = null,Object? isSettled = null,Object? settledAt = freezed,Object? settledByDutyId = freezed,}) {
  return _then(_DutyDebt(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,debtorId: null == debtorId ? _self.debtorId : debtorId // ignore: cast_nullable_to_non_nullable
as String,creditorId: null == creditorId ? _self.creditorId : creditorId // ignore: cast_nullable_to_non_nullable
as String,dutyType: null == dutyType ? _self.dutyType : dutyType // ignore: cast_nullable_to_non_nullable
as DutyType,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,originalDutyId: null == originalDutyId ? _self.originalDutyId : originalDutyId // ignore: cast_nullable_to_non_nullable
as String,isSettled: null == isSettled ? _self.isSettled : isSettled // ignore: cast_nullable_to_non_nullable
as bool,settledAt: freezed == settledAt ? _self.settledAt : settledAt // ignore: cast_nullable_to_non_nullable
as DateTime?,settledByDutyId: freezed == settledByDutyId ? _self.settledByDutyId : settledByDutyId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
