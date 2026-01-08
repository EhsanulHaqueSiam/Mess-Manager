// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'money_transaction.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MoneyTransaction {

 String get id; String get fromMemberId; String get toMemberId; double get amount; DateTime get date; String? get description; String? get note;/// Photo proof URL - required for amounts > 500
 String? get photoProofUrl;/// Receiver's response note (for rejection reason, etc.)
 String? get responseNote;/// Current status of the transaction
 TransactionStatus get status;/// Legacy field - kept for backwards compatibility
 bool get isSettled; DateTime? get settledAt; DateTime? get acceptedAt; DateTime? get rejectedAt; DateTime? get createdAt;
/// Create a copy of MoneyTransaction
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MoneyTransactionCopyWith<MoneyTransaction> get copyWith => _$MoneyTransactionCopyWithImpl<MoneyTransaction>(this as MoneyTransaction, _$identity);

  /// Serializes this MoneyTransaction to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MoneyTransaction&&(identical(other.id, id) || other.id == id)&&(identical(other.fromMemberId, fromMemberId) || other.fromMemberId == fromMemberId)&&(identical(other.toMemberId, toMemberId) || other.toMemberId == toMemberId)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.date, date) || other.date == date)&&(identical(other.description, description) || other.description == description)&&(identical(other.note, note) || other.note == note)&&(identical(other.photoProofUrl, photoProofUrl) || other.photoProofUrl == photoProofUrl)&&(identical(other.responseNote, responseNote) || other.responseNote == responseNote)&&(identical(other.status, status) || other.status == status)&&(identical(other.isSettled, isSettled) || other.isSettled == isSettled)&&(identical(other.settledAt, settledAt) || other.settledAt == settledAt)&&(identical(other.acceptedAt, acceptedAt) || other.acceptedAt == acceptedAt)&&(identical(other.rejectedAt, rejectedAt) || other.rejectedAt == rejectedAt)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,fromMemberId,toMemberId,amount,date,description,note,photoProofUrl,responseNote,status,isSettled,settledAt,acceptedAt,rejectedAt,createdAt);

@override
String toString() {
  return 'MoneyTransaction(id: $id, fromMemberId: $fromMemberId, toMemberId: $toMemberId, amount: $amount, date: $date, description: $description, note: $note, photoProofUrl: $photoProofUrl, responseNote: $responseNote, status: $status, isSettled: $isSettled, settledAt: $settledAt, acceptedAt: $acceptedAt, rejectedAt: $rejectedAt, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $MoneyTransactionCopyWith<$Res>  {
  factory $MoneyTransactionCopyWith(MoneyTransaction value, $Res Function(MoneyTransaction) _then) = _$MoneyTransactionCopyWithImpl;
@useResult
$Res call({
 String id, String fromMemberId, String toMemberId, double amount, DateTime date, String? description, String? note, String? photoProofUrl, String? responseNote, TransactionStatus status, bool isSettled, DateTime? settledAt, DateTime? acceptedAt, DateTime? rejectedAt, DateTime? createdAt
});




}
/// @nodoc
class _$MoneyTransactionCopyWithImpl<$Res>
    implements $MoneyTransactionCopyWith<$Res> {
  _$MoneyTransactionCopyWithImpl(this._self, this._then);

  final MoneyTransaction _self;
  final $Res Function(MoneyTransaction) _then;

/// Create a copy of MoneyTransaction
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? fromMemberId = null,Object? toMemberId = null,Object? amount = null,Object? date = null,Object? description = freezed,Object? note = freezed,Object? photoProofUrl = freezed,Object? responseNote = freezed,Object? status = null,Object? isSettled = null,Object? settledAt = freezed,Object? acceptedAt = freezed,Object? rejectedAt = freezed,Object? createdAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,fromMemberId: null == fromMemberId ? _self.fromMemberId : fromMemberId // ignore: cast_nullable_to_non_nullable
as String,toMemberId: null == toMemberId ? _self.toMemberId : toMemberId // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as double,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,photoProofUrl: freezed == photoProofUrl ? _self.photoProofUrl : photoProofUrl // ignore: cast_nullable_to_non_nullable
as String?,responseNote: freezed == responseNote ? _self.responseNote : responseNote // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as TransactionStatus,isSettled: null == isSettled ? _self.isSettled : isSettled // ignore: cast_nullable_to_non_nullable
as bool,settledAt: freezed == settledAt ? _self.settledAt : settledAt // ignore: cast_nullable_to_non_nullable
as DateTime?,acceptedAt: freezed == acceptedAt ? _self.acceptedAt : acceptedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,rejectedAt: freezed == rejectedAt ? _self.rejectedAt : rejectedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [MoneyTransaction].
extension MoneyTransactionPatterns on MoneyTransaction {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MoneyTransaction value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MoneyTransaction() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MoneyTransaction value)  $default,){
final _that = this;
switch (_that) {
case _MoneyTransaction():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MoneyTransaction value)?  $default,){
final _that = this;
switch (_that) {
case _MoneyTransaction() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String fromMemberId,  String toMemberId,  double amount,  DateTime date,  String? description,  String? note,  String? photoProofUrl,  String? responseNote,  TransactionStatus status,  bool isSettled,  DateTime? settledAt,  DateTime? acceptedAt,  DateTime? rejectedAt,  DateTime? createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MoneyTransaction() when $default != null:
return $default(_that.id,_that.fromMemberId,_that.toMemberId,_that.amount,_that.date,_that.description,_that.note,_that.photoProofUrl,_that.responseNote,_that.status,_that.isSettled,_that.settledAt,_that.acceptedAt,_that.rejectedAt,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String fromMemberId,  String toMemberId,  double amount,  DateTime date,  String? description,  String? note,  String? photoProofUrl,  String? responseNote,  TransactionStatus status,  bool isSettled,  DateTime? settledAt,  DateTime? acceptedAt,  DateTime? rejectedAt,  DateTime? createdAt)  $default,) {final _that = this;
switch (_that) {
case _MoneyTransaction():
return $default(_that.id,_that.fromMemberId,_that.toMemberId,_that.amount,_that.date,_that.description,_that.note,_that.photoProofUrl,_that.responseNote,_that.status,_that.isSettled,_that.settledAt,_that.acceptedAt,_that.rejectedAt,_that.createdAt);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String fromMemberId,  String toMemberId,  double amount,  DateTime date,  String? description,  String? note,  String? photoProofUrl,  String? responseNote,  TransactionStatus status,  bool isSettled,  DateTime? settledAt,  DateTime? acceptedAt,  DateTime? rejectedAt,  DateTime? createdAt)?  $default,) {final _that = this;
switch (_that) {
case _MoneyTransaction() when $default != null:
return $default(_that.id,_that.fromMemberId,_that.toMemberId,_that.amount,_that.date,_that.description,_that.note,_that.photoProofUrl,_that.responseNote,_that.status,_that.isSettled,_that.settledAt,_that.acceptedAt,_that.rejectedAt,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MoneyTransaction implements MoneyTransaction {
  const _MoneyTransaction({required this.id, required this.fromMemberId, required this.toMemberId, required this.amount, required this.date, this.description, this.note, this.photoProofUrl, this.responseNote, this.status = TransactionStatus.pending, this.isSettled = false, this.settledAt, this.acceptedAt, this.rejectedAt, this.createdAt});
  factory _MoneyTransaction.fromJson(Map<String, dynamic> json) => _$MoneyTransactionFromJson(json);

@override final  String id;
@override final  String fromMemberId;
@override final  String toMemberId;
@override final  double amount;
@override final  DateTime date;
@override final  String? description;
@override final  String? note;
/// Photo proof URL - required for amounts > 500
@override final  String? photoProofUrl;
/// Receiver's response note (for rejection reason, etc.)
@override final  String? responseNote;
/// Current status of the transaction
@override@JsonKey() final  TransactionStatus status;
/// Legacy field - kept for backwards compatibility
@override@JsonKey() final  bool isSettled;
@override final  DateTime? settledAt;
@override final  DateTime? acceptedAt;
@override final  DateTime? rejectedAt;
@override final  DateTime? createdAt;

/// Create a copy of MoneyTransaction
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MoneyTransactionCopyWith<_MoneyTransaction> get copyWith => __$MoneyTransactionCopyWithImpl<_MoneyTransaction>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MoneyTransactionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MoneyTransaction&&(identical(other.id, id) || other.id == id)&&(identical(other.fromMemberId, fromMemberId) || other.fromMemberId == fromMemberId)&&(identical(other.toMemberId, toMemberId) || other.toMemberId == toMemberId)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.date, date) || other.date == date)&&(identical(other.description, description) || other.description == description)&&(identical(other.note, note) || other.note == note)&&(identical(other.photoProofUrl, photoProofUrl) || other.photoProofUrl == photoProofUrl)&&(identical(other.responseNote, responseNote) || other.responseNote == responseNote)&&(identical(other.status, status) || other.status == status)&&(identical(other.isSettled, isSettled) || other.isSettled == isSettled)&&(identical(other.settledAt, settledAt) || other.settledAt == settledAt)&&(identical(other.acceptedAt, acceptedAt) || other.acceptedAt == acceptedAt)&&(identical(other.rejectedAt, rejectedAt) || other.rejectedAt == rejectedAt)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,fromMemberId,toMemberId,amount,date,description,note,photoProofUrl,responseNote,status,isSettled,settledAt,acceptedAt,rejectedAt,createdAt);

@override
String toString() {
  return 'MoneyTransaction(id: $id, fromMemberId: $fromMemberId, toMemberId: $toMemberId, amount: $amount, date: $date, description: $description, note: $note, photoProofUrl: $photoProofUrl, responseNote: $responseNote, status: $status, isSettled: $isSettled, settledAt: $settledAt, acceptedAt: $acceptedAt, rejectedAt: $rejectedAt, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$MoneyTransactionCopyWith<$Res> implements $MoneyTransactionCopyWith<$Res> {
  factory _$MoneyTransactionCopyWith(_MoneyTransaction value, $Res Function(_MoneyTransaction) _then) = __$MoneyTransactionCopyWithImpl;
@override @useResult
$Res call({
 String id, String fromMemberId, String toMemberId, double amount, DateTime date, String? description, String? note, String? photoProofUrl, String? responseNote, TransactionStatus status, bool isSettled, DateTime? settledAt, DateTime? acceptedAt, DateTime? rejectedAt, DateTime? createdAt
});




}
/// @nodoc
class __$MoneyTransactionCopyWithImpl<$Res>
    implements _$MoneyTransactionCopyWith<$Res> {
  __$MoneyTransactionCopyWithImpl(this._self, this._then);

  final _MoneyTransaction _self;
  final $Res Function(_MoneyTransaction) _then;

/// Create a copy of MoneyTransaction
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? fromMemberId = null,Object? toMemberId = null,Object? amount = null,Object? date = null,Object? description = freezed,Object? note = freezed,Object? photoProofUrl = freezed,Object? responseNote = freezed,Object? status = null,Object? isSettled = null,Object? settledAt = freezed,Object? acceptedAt = freezed,Object? rejectedAt = freezed,Object? createdAt = freezed,}) {
  return _then(_MoneyTransaction(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,fromMemberId: null == fromMemberId ? _self.fromMemberId : fromMemberId // ignore: cast_nullable_to_non_nullable
as String,toMemberId: null == toMemberId ? _self.toMemberId : toMemberId // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as double,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,photoProofUrl: freezed == photoProofUrl ? _self.photoProofUrl : photoProofUrl // ignore: cast_nullable_to_non_nullable
as String?,responseNote: freezed == responseNote ? _self.responseNote : responseNote // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as TransactionStatus,isSettled: null == isSettled ? _self.isSettled : isSettled // ignore: cast_nullable_to_non_nullable
as bool,settledAt: freezed == settledAt ? _self.settledAt : settledAt // ignore: cast_nullable_to_non_nullable
as DateTime?,acceptedAt: freezed == acceptedAt ? _self.acceptedAt : acceptedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,rejectedAt: freezed == rejectedAt ? _self.rejectedAt : rejectedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
