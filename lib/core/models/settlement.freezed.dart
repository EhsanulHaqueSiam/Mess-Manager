// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'settlement.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Settlement {

 String get id; String get messId; int get year; int get month; DateTime get calculatedAt; List<SettlementItem> get items; SettlementStatus get status; DateTime? get settledAt;
/// Create a copy of Settlement
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SettlementCopyWith<Settlement> get copyWith => _$SettlementCopyWithImpl<Settlement>(this as Settlement, _$identity);

  /// Serializes this Settlement to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Settlement&&(identical(other.id, id) || other.id == id)&&(identical(other.messId, messId) || other.messId == messId)&&(identical(other.year, year) || other.year == year)&&(identical(other.month, month) || other.month == month)&&(identical(other.calculatedAt, calculatedAt) || other.calculatedAt == calculatedAt)&&const DeepCollectionEquality().equals(other.items, items)&&(identical(other.status, status) || other.status == status)&&(identical(other.settledAt, settledAt) || other.settledAt == settledAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,messId,year,month,calculatedAt,const DeepCollectionEquality().hash(items),status,settledAt);

@override
String toString() {
  return 'Settlement(id: $id, messId: $messId, year: $year, month: $month, calculatedAt: $calculatedAt, items: $items, status: $status, settledAt: $settledAt)';
}


}

/// @nodoc
abstract mixin class $SettlementCopyWith<$Res>  {
  factory $SettlementCopyWith(Settlement value, $Res Function(Settlement) _then) = _$SettlementCopyWithImpl;
@useResult
$Res call({
 String id, String messId, int year, int month, DateTime calculatedAt, List<SettlementItem> items, SettlementStatus status, DateTime? settledAt
});




}
/// @nodoc
class _$SettlementCopyWithImpl<$Res>
    implements $SettlementCopyWith<$Res> {
  _$SettlementCopyWithImpl(this._self, this._then);

  final Settlement _self;
  final $Res Function(Settlement) _then;

/// Create a copy of Settlement
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? messId = null,Object? year = null,Object? month = null,Object? calculatedAt = null,Object? items = null,Object? status = null,Object? settledAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,messId: null == messId ? _self.messId : messId // ignore: cast_nullable_to_non_nullable
as String,year: null == year ? _self.year : year // ignore: cast_nullable_to_non_nullable
as int,month: null == month ? _self.month : month // ignore: cast_nullable_to_non_nullable
as int,calculatedAt: null == calculatedAt ? _self.calculatedAt : calculatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<SettlementItem>,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as SettlementStatus,settledAt: freezed == settledAt ? _self.settledAt : settledAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [Settlement].
extension SettlementPatterns on Settlement {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Settlement value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Settlement() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Settlement value)  $default,){
final _that = this;
switch (_that) {
case _Settlement():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Settlement value)?  $default,){
final _that = this;
switch (_that) {
case _Settlement() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String messId,  int year,  int month,  DateTime calculatedAt,  List<SettlementItem> items,  SettlementStatus status,  DateTime? settledAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Settlement() when $default != null:
return $default(_that.id,_that.messId,_that.year,_that.month,_that.calculatedAt,_that.items,_that.status,_that.settledAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String messId,  int year,  int month,  DateTime calculatedAt,  List<SettlementItem> items,  SettlementStatus status,  DateTime? settledAt)  $default,) {final _that = this;
switch (_that) {
case _Settlement():
return $default(_that.id,_that.messId,_that.year,_that.month,_that.calculatedAt,_that.items,_that.status,_that.settledAt);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String messId,  int year,  int month,  DateTime calculatedAt,  List<SettlementItem> items,  SettlementStatus status,  DateTime? settledAt)?  $default,) {final _that = this;
switch (_that) {
case _Settlement() when $default != null:
return $default(_that.id,_that.messId,_that.year,_that.month,_that.calculatedAt,_that.items,_that.status,_that.settledAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Settlement implements Settlement {
  const _Settlement({required this.id, required this.messId, required this.year, required this.month, required this.calculatedAt, required final  List<SettlementItem> items, this.status = SettlementStatus.pending, this.settledAt}): _items = items;
  factory _Settlement.fromJson(Map<String, dynamic> json) => _$SettlementFromJson(json);

@override final  String id;
@override final  String messId;
@override final  int year;
@override final  int month;
@override final  DateTime calculatedAt;
 final  List<SettlementItem> _items;
@override List<SettlementItem> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}

@override@JsonKey() final  SettlementStatus status;
@override final  DateTime? settledAt;

/// Create a copy of Settlement
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SettlementCopyWith<_Settlement> get copyWith => __$SettlementCopyWithImpl<_Settlement>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SettlementToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Settlement&&(identical(other.id, id) || other.id == id)&&(identical(other.messId, messId) || other.messId == messId)&&(identical(other.year, year) || other.year == year)&&(identical(other.month, month) || other.month == month)&&(identical(other.calculatedAt, calculatedAt) || other.calculatedAt == calculatedAt)&&const DeepCollectionEquality().equals(other._items, _items)&&(identical(other.status, status) || other.status == status)&&(identical(other.settledAt, settledAt) || other.settledAt == settledAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,messId,year,month,calculatedAt,const DeepCollectionEquality().hash(_items),status,settledAt);

@override
String toString() {
  return 'Settlement(id: $id, messId: $messId, year: $year, month: $month, calculatedAt: $calculatedAt, items: $items, status: $status, settledAt: $settledAt)';
}


}

/// @nodoc
abstract mixin class _$SettlementCopyWith<$Res> implements $SettlementCopyWith<$Res> {
  factory _$SettlementCopyWith(_Settlement value, $Res Function(_Settlement) _then) = __$SettlementCopyWithImpl;
@override @useResult
$Res call({
 String id, String messId, int year, int month, DateTime calculatedAt, List<SettlementItem> items, SettlementStatus status, DateTime? settledAt
});




}
/// @nodoc
class __$SettlementCopyWithImpl<$Res>
    implements _$SettlementCopyWith<$Res> {
  __$SettlementCopyWithImpl(this._self, this._then);

  final _Settlement _self;
  final $Res Function(_Settlement) _then;

/// Create a copy of Settlement
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? messId = null,Object? year = null,Object? month = null,Object? calculatedAt = null,Object? items = null,Object? status = null,Object? settledAt = freezed,}) {
  return _then(_Settlement(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,messId: null == messId ? _self.messId : messId // ignore: cast_nullable_to_non_nullable
as String,year: null == year ? _self.year : year // ignore: cast_nullable_to_non_nullable
as int,month: null == month ? _self.month : month // ignore: cast_nullable_to_non_nullable
as int,calculatedAt: null == calculatedAt ? _self.calculatedAt : calculatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<SettlementItem>,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as SettlementStatus,settledAt: freezed == settledAt ? _self.settledAt : settledAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}


/// @nodoc
mixin _$SettlementItem {

 String get fromMemberId; String get toMemberId; double get amount; bool get isPaid; DateTime? get paidAt; String? get proofImagePath; String? get note;
/// Create a copy of SettlementItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SettlementItemCopyWith<SettlementItem> get copyWith => _$SettlementItemCopyWithImpl<SettlementItem>(this as SettlementItem, _$identity);

  /// Serializes this SettlementItem to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SettlementItem&&(identical(other.fromMemberId, fromMemberId) || other.fromMemberId == fromMemberId)&&(identical(other.toMemberId, toMemberId) || other.toMemberId == toMemberId)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.isPaid, isPaid) || other.isPaid == isPaid)&&(identical(other.paidAt, paidAt) || other.paidAt == paidAt)&&(identical(other.proofImagePath, proofImagePath) || other.proofImagePath == proofImagePath)&&(identical(other.note, note) || other.note == note));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,fromMemberId,toMemberId,amount,isPaid,paidAt,proofImagePath,note);

@override
String toString() {
  return 'SettlementItem(fromMemberId: $fromMemberId, toMemberId: $toMemberId, amount: $amount, isPaid: $isPaid, paidAt: $paidAt, proofImagePath: $proofImagePath, note: $note)';
}


}

/// @nodoc
abstract mixin class $SettlementItemCopyWith<$Res>  {
  factory $SettlementItemCopyWith(SettlementItem value, $Res Function(SettlementItem) _then) = _$SettlementItemCopyWithImpl;
@useResult
$Res call({
 String fromMemberId, String toMemberId, double amount, bool isPaid, DateTime? paidAt, String? proofImagePath, String? note
});




}
/// @nodoc
class _$SettlementItemCopyWithImpl<$Res>
    implements $SettlementItemCopyWith<$Res> {
  _$SettlementItemCopyWithImpl(this._self, this._then);

  final SettlementItem _self;
  final $Res Function(SettlementItem) _then;

/// Create a copy of SettlementItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? fromMemberId = null,Object? toMemberId = null,Object? amount = null,Object? isPaid = null,Object? paidAt = freezed,Object? proofImagePath = freezed,Object? note = freezed,}) {
  return _then(_self.copyWith(
fromMemberId: null == fromMemberId ? _self.fromMemberId : fromMemberId // ignore: cast_nullable_to_non_nullable
as String,toMemberId: null == toMemberId ? _self.toMemberId : toMemberId // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as double,isPaid: null == isPaid ? _self.isPaid : isPaid // ignore: cast_nullable_to_non_nullable
as bool,paidAt: freezed == paidAt ? _self.paidAt : paidAt // ignore: cast_nullable_to_non_nullable
as DateTime?,proofImagePath: freezed == proofImagePath ? _self.proofImagePath : proofImagePath // ignore: cast_nullable_to_non_nullable
as String?,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [SettlementItem].
extension SettlementItemPatterns on SettlementItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SettlementItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SettlementItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SettlementItem value)  $default,){
final _that = this;
switch (_that) {
case _SettlementItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SettlementItem value)?  $default,){
final _that = this;
switch (_that) {
case _SettlementItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String fromMemberId,  String toMemberId,  double amount,  bool isPaid,  DateTime? paidAt,  String? proofImagePath,  String? note)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SettlementItem() when $default != null:
return $default(_that.fromMemberId,_that.toMemberId,_that.amount,_that.isPaid,_that.paidAt,_that.proofImagePath,_that.note);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String fromMemberId,  String toMemberId,  double amount,  bool isPaid,  DateTime? paidAt,  String? proofImagePath,  String? note)  $default,) {final _that = this;
switch (_that) {
case _SettlementItem():
return $default(_that.fromMemberId,_that.toMemberId,_that.amount,_that.isPaid,_that.paidAt,_that.proofImagePath,_that.note);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String fromMemberId,  String toMemberId,  double amount,  bool isPaid,  DateTime? paidAt,  String? proofImagePath,  String? note)?  $default,) {final _that = this;
switch (_that) {
case _SettlementItem() when $default != null:
return $default(_that.fromMemberId,_that.toMemberId,_that.amount,_that.isPaid,_that.paidAt,_that.proofImagePath,_that.note);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SettlementItem implements SettlementItem {
  const _SettlementItem({required this.fromMemberId, required this.toMemberId, required this.amount, this.isPaid = false, this.paidAt, this.proofImagePath, this.note});
  factory _SettlementItem.fromJson(Map<String, dynamic> json) => _$SettlementItemFromJson(json);

@override final  String fromMemberId;
@override final  String toMemberId;
@override final  double amount;
@override@JsonKey() final  bool isPaid;
@override final  DateTime? paidAt;
@override final  String? proofImagePath;
@override final  String? note;

/// Create a copy of SettlementItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SettlementItemCopyWith<_SettlementItem> get copyWith => __$SettlementItemCopyWithImpl<_SettlementItem>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SettlementItemToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SettlementItem&&(identical(other.fromMemberId, fromMemberId) || other.fromMemberId == fromMemberId)&&(identical(other.toMemberId, toMemberId) || other.toMemberId == toMemberId)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.isPaid, isPaid) || other.isPaid == isPaid)&&(identical(other.paidAt, paidAt) || other.paidAt == paidAt)&&(identical(other.proofImagePath, proofImagePath) || other.proofImagePath == proofImagePath)&&(identical(other.note, note) || other.note == note));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,fromMemberId,toMemberId,amount,isPaid,paidAt,proofImagePath,note);

@override
String toString() {
  return 'SettlementItem(fromMemberId: $fromMemberId, toMemberId: $toMemberId, amount: $amount, isPaid: $isPaid, paidAt: $paidAt, proofImagePath: $proofImagePath, note: $note)';
}


}

/// @nodoc
abstract mixin class _$SettlementItemCopyWith<$Res> implements $SettlementItemCopyWith<$Res> {
  factory _$SettlementItemCopyWith(_SettlementItem value, $Res Function(_SettlementItem) _then) = __$SettlementItemCopyWithImpl;
@override @useResult
$Res call({
 String fromMemberId, String toMemberId, double amount, bool isPaid, DateTime? paidAt, String? proofImagePath, String? note
});




}
/// @nodoc
class __$SettlementItemCopyWithImpl<$Res>
    implements _$SettlementItemCopyWith<$Res> {
  __$SettlementItemCopyWithImpl(this._self, this._then);

  final _SettlementItem _self;
  final $Res Function(_SettlementItem) _then;

/// Create a copy of SettlementItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? fromMemberId = null,Object? toMemberId = null,Object? amount = null,Object? isPaid = null,Object? paidAt = freezed,Object? proofImagePath = freezed,Object? note = freezed,}) {
  return _then(_SettlementItem(
fromMemberId: null == fromMemberId ? _self.fromMemberId : fromMemberId // ignore: cast_nullable_to_non_nullable
as String,toMemberId: null == toMemberId ? _self.toMemberId : toMemberId // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as double,isPaid: null == isPaid ? _self.isPaid : isPaid // ignore: cast_nullable_to_non_nullable
as bool,paidAt: freezed == paidAt ? _self.paidAt : paidAt // ignore: cast_nullable_to_non_nullable
as DateTime?,proofImagePath: freezed == proofImagePath ? _self.proofImagePath : proofImagePath // ignore: cast_nullable_to_non_nullable
as String?,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$SettlementPayment {

 String get id; String get settlementId; String get fromMemberId; String get toMemberId; double get amount; DateTime get paidAt; String? get proofImagePath; String? get note; bool get isConfirmed;
/// Create a copy of SettlementPayment
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SettlementPaymentCopyWith<SettlementPayment> get copyWith => _$SettlementPaymentCopyWithImpl<SettlementPayment>(this as SettlementPayment, _$identity);

  /// Serializes this SettlementPayment to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SettlementPayment&&(identical(other.id, id) || other.id == id)&&(identical(other.settlementId, settlementId) || other.settlementId == settlementId)&&(identical(other.fromMemberId, fromMemberId) || other.fromMemberId == fromMemberId)&&(identical(other.toMemberId, toMemberId) || other.toMemberId == toMemberId)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.paidAt, paidAt) || other.paidAt == paidAt)&&(identical(other.proofImagePath, proofImagePath) || other.proofImagePath == proofImagePath)&&(identical(other.note, note) || other.note == note)&&(identical(other.isConfirmed, isConfirmed) || other.isConfirmed == isConfirmed));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,settlementId,fromMemberId,toMemberId,amount,paidAt,proofImagePath,note,isConfirmed);

@override
String toString() {
  return 'SettlementPayment(id: $id, settlementId: $settlementId, fromMemberId: $fromMemberId, toMemberId: $toMemberId, amount: $amount, paidAt: $paidAt, proofImagePath: $proofImagePath, note: $note, isConfirmed: $isConfirmed)';
}


}

/// @nodoc
abstract mixin class $SettlementPaymentCopyWith<$Res>  {
  factory $SettlementPaymentCopyWith(SettlementPayment value, $Res Function(SettlementPayment) _then) = _$SettlementPaymentCopyWithImpl;
@useResult
$Res call({
 String id, String settlementId, String fromMemberId, String toMemberId, double amount, DateTime paidAt, String? proofImagePath, String? note, bool isConfirmed
});




}
/// @nodoc
class _$SettlementPaymentCopyWithImpl<$Res>
    implements $SettlementPaymentCopyWith<$Res> {
  _$SettlementPaymentCopyWithImpl(this._self, this._then);

  final SettlementPayment _self;
  final $Res Function(SettlementPayment) _then;

/// Create a copy of SettlementPayment
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? settlementId = null,Object? fromMemberId = null,Object? toMemberId = null,Object? amount = null,Object? paidAt = null,Object? proofImagePath = freezed,Object? note = freezed,Object? isConfirmed = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,settlementId: null == settlementId ? _self.settlementId : settlementId // ignore: cast_nullable_to_non_nullable
as String,fromMemberId: null == fromMemberId ? _self.fromMemberId : fromMemberId // ignore: cast_nullable_to_non_nullable
as String,toMemberId: null == toMemberId ? _self.toMemberId : toMemberId // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as double,paidAt: null == paidAt ? _self.paidAt : paidAt // ignore: cast_nullable_to_non_nullable
as DateTime,proofImagePath: freezed == proofImagePath ? _self.proofImagePath : proofImagePath // ignore: cast_nullable_to_non_nullable
as String?,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,isConfirmed: null == isConfirmed ? _self.isConfirmed : isConfirmed // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [SettlementPayment].
extension SettlementPaymentPatterns on SettlementPayment {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SettlementPayment value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SettlementPayment() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SettlementPayment value)  $default,){
final _that = this;
switch (_that) {
case _SettlementPayment():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SettlementPayment value)?  $default,){
final _that = this;
switch (_that) {
case _SettlementPayment() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String settlementId,  String fromMemberId,  String toMemberId,  double amount,  DateTime paidAt,  String? proofImagePath,  String? note,  bool isConfirmed)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SettlementPayment() when $default != null:
return $default(_that.id,_that.settlementId,_that.fromMemberId,_that.toMemberId,_that.amount,_that.paidAt,_that.proofImagePath,_that.note,_that.isConfirmed);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String settlementId,  String fromMemberId,  String toMemberId,  double amount,  DateTime paidAt,  String? proofImagePath,  String? note,  bool isConfirmed)  $default,) {final _that = this;
switch (_that) {
case _SettlementPayment():
return $default(_that.id,_that.settlementId,_that.fromMemberId,_that.toMemberId,_that.amount,_that.paidAt,_that.proofImagePath,_that.note,_that.isConfirmed);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String settlementId,  String fromMemberId,  String toMemberId,  double amount,  DateTime paidAt,  String? proofImagePath,  String? note,  bool isConfirmed)?  $default,) {final _that = this;
switch (_that) {
case _SettlementPayment() when $default != null:
return $default(_that.id,_that.settlementId,_that.fromMemberId,_that.toMemberId,_that.amount,_that.paidAt,_that.proofImagePath,_that.note,_that.isConfirmed);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SettlementPayment implements SettlementPayment {
  const _SettlementPayment({required this.id, required this.settlementId, required this.fromMemberId, required this.toMemberId, required this.amount, required this.paidAt, this.proofImagePath, this.note, this.isConfirmed = false});
  factory _SettlementPayment.fromJson(Map<String, dynamic> json) => _$SettlementPaymentFromJson(json);

@override final  String id;
@override final  String settlementId;
@override final  String fromMemberId;
@override final  String toMemberId;
@override final  double amount;
@override final  DateTime paidAt;
@override final  String? proofImagePath;
@override final  String? note;
@override@JsonKey() final  bool isConfirmed;

/// Create a copy of SettlementPayment
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SettlementPaymentCopyWith<_SettlementPayment> get copyWith => __$SettlementPaymentCopyWithImpl<_SettlementPayment>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SettlementPaymentToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SettlementPayment&&(identical(other.id, id) || other.id == id)&&(identical(other.settlementId, settlementId) || other.settlementId == settlementId)&&(identical(other.fromMemberId, fromMemberId) || other.fromMemberId == fromMemberId)&&(identical(other.toMemberId, toMemberId) || other.toMemberId == toMemberId)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.paidAt, paidAt) || other.paidAt == paidAt)&&(identical(other.proofImagePath, proofImagePath) || other.proofImagePath == proofImagePath)&&(identical(other.note, note) || other.note == note)&&(identical(other.isConfirmed, isConfirmed) || other.isConfirmed == isConfirmed));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,settlementId,fromMemberId,toMemberId,amount,paidAt,proofImagePath,note,isConfirmed);

@override
String toString() {
  return 'SettlementPayment(id: $id, settlementId: $settlementId, fromMemberId: $fromMemberId, toMemberId: $toMemberId, amount: $amount, paidAt: $paidAt, proofImagePath: $proofImagePath, note: $note, isConfirmed: $isConfirmed)';
}


}

/// @nodoc
abstract mixin class _$SettlementPaymentCopyWith<$Res> implements $SettlementPaymentCopyWith<$Res> {
  factory _$SettlementPaymentCopyWith(_SettlementPayment value, $Res Function(_SettlementPayment) _then) = __$SettlementPaymentCopyWithImpl;
@override @useResult
$Res call({
 String id, String settlementId, String fromMemberId, String toMemberId, double amount, DateTime paidAt, String? proofImagePath, String? note, bool isConfirmed
});




}
/// @nodoc
class __$SettlementPaymentCopyWithImpl<$Res>
    implements _$SettlementPaymentCopyWith<$Res> {
  __$SettlementPaymentCopyWithImpl(this._self, this._then);

  final _SettlementPayment _self;
  final $Res Function(_SettlementPayment) _then;

/// Create a copy of SettlementPayment
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? settlementId = null,Object? fromMemberId = null,Object? toMemberId = null,Object? amount = null,Object? paidAt = null,Object? proofImagePath = freezed,Object? note = freezed,Object? isConfirmed = null,}) {
  return _then(_SettlementPayment(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,settlementId: null == settlementId ? _self.settlementId : settlementId // ignore: cast_nullable_to_non_nullable
as String,fromMemberId: null == fromMemberId ? _self.fromMemberId : fromMemberId // ignore: cast_nullable_to_non_nullable
as String,toMemberId: null == toMemberId ? _self.toMemberId : toMemberId // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as double,paidAt: null == paidAt ? _self.paidAt : paidAt // ignore: cast_nullable_to_non_nullable
as DateTime,proofImagePath: freezed == proofImagePath ? _self.proofImagePath : proofImagePath // ignore: cast_nullable_to_non_nullable
as String?,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,isConfirmed: null == isConfirmed ? _self.isConfirmed : isConfirmed // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$MemberBalanceSummary {

 String get memberId; double get totalBazar; double get mealCost; double get monthlyShare; double get balance;
/// Create a copy of MemberBalanceSummary
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MemberBalanceSummaryCopyWith<MemberBalanceSummary> get copyWith => _$MemberBalanceSummaryCopyWithImpl<MemberBalanceSummary>(this as MemberBalanceSummary, _$identity);

  /// Serializes this MemberBalanceSummary to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MemberBalanceSummary&&(identical(other.memberId, memberId) || other.memberId == memberId)&&(identical(other.totalBazar, totalBazar) || other.totalBazar == totalBazar)&&(identical(other.mealCost, mealCost) || other.mealCost == mealCost)&&(identical(other.monthlyShare, monthlyShare) || other.monthlyShare == monthlyShare)&&(identical(other.balance, balance) || other.balance == balance));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,memberId,totalBazar,mealCost,monthlyShare,balance);

@override
String toString() {
  return 'MemberBalanceSummary(memberId: $memberId, totalBazar: $totalBazar, mealCost: $mealCost, monthlyShare: $monthlyShare, balance: $balance)';
}


}

/// @nodoc
abstract mixin class $MemberBalanceSummaryCopyWith<$Res>  {
  factory $MemberBalanceSummaryCopyWith(MemberBalanceSummary value, $Res Function(MemberBalanceSummary) _then) = _$MemberBalanceSummaryCopyWithImpl;
@useResult
$Res call({
 String memberId, double totalBazar, double mealCost, double monthlyShare, double balance
});




}
/// @nodoc
class _$MemberBalanceSummaryCopyWithImpl<$Res>
    implements $MemberBalanceSummaryCopyWith<$Res> {
  _$MemberBalanceSummaryCopyWithImpl(this._self, this._then);

  final MemberBalanceSummary _self;
  final $Res Function(MemberBalanceSummary) _then;

/// Create a copy of MemberBalanceSummary
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? memberId = null,Object? totalBazar = null,Object? mealCost = null,Object? monthlyShare = null,Object? balance = null,}) {
  return _then(_self.copyWith(
memberId: null == memberId ? _self.memberId : memberId // ignore: cast_nullable_to_non_nullable
as String,totalBazar: null == totalBazar ? _self.totalBazar : totalBazar // ignore: cast_nullable_to_non_nullable
as double,mealCost: null == mealCost ? _self.mealCost : mealCost // ignore: cast_nullable_to_non_nullable
as double,monthlyShare: null == monthlyShare ? _self.monthlyShare : monthlyShare // ignore: cast_nullable_to_non_nullable
as double,balance: null == balance ? _self.balance : balance // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [MemberBalanceSummary].
extension MemberBalanceSummaryPatterns on MemberBalanceSummary {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MemberBalanceSummary value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MemberBalanceSummary() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MemberBalanceSummary value)  $default,){
final _that = this;
switch (_that) {
case _MemberBalanceSummary():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MemberBalanceSummary value)?  $default,){
final _that = this;
switch (_that) {
case _MemberBalanceSummary() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String memberId,  double totalBazar,  double mealCost,  double monthlyShare,  double balance)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MemberBalanceSummary() when $default != null:
return $default(_that.memberId,_that.totalBazar,_that.mealCost,_that.monthlyShare,_that.balance);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String memberId,  double totalBazar,  double mealCost,  double monthlyShare,  double balance)  $default,) {final _that = this;
switch (_that) {
case _MemberBalanceSummary():
return $default(_that.memberId,_that.totalBazar,_that.mealCost,_that.monthlyShare,_that.balance);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String memberId,  double totalBazar,  double mealCost,  double monthlyShare,  double balance)?  $default,) {final _that = this;
switch (_that) {
case _MemberBalanceSummary() when $default != null:
return $default(_that.memberId,_that.totalBazar,_that.mealCost,_that.monthlyShare,_that.balance);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MemberBalanceSummary implements MemberBalanceSummary {
  const _MemberBalanceSummary({required this.memberId, required this.totalBazar, required this.mealCost, required this.monthlyShare, required this.balance});
  factory _MemberBalanceSummary.fromJson(Map<String, dynamic> json) => _$MemberBalanceSummaryFromJson(json);

@override final  String memberId;
@override final  double totalBazar;
@override final  double mealCost;
@override final  double monthlyShare;
@override final  double balance;

/// Create a copy of MemberBalanceSummary
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MemberBalanceSummaryCopyWith<_MemberBalanceSummary> get copyWith => __$MemberBalanceSummaryCopyWithImpl<_MemberBalanceSummary>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MemberBalanceSummaryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MemberBalanceSummary&&(identical(other.memberId, memberId) || other.memberId == memberId)&&(identical(other.totalBazar, totalBazar) || other.totalBazar == totalBazar)&&(identical(other.mealCost, mealCost) || other.mealCost == mealCost)&&(identical(other.monthlyShare, monthlyShare) || other.monthlyShare == monthlyShare)&&(identical(other.balance, balance) || other.balance == balance));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,memberId,totalBazar,mealCost,monthlyShare,balance);

@override
String toString() {
  return 'MemberBalanceSummary(memberId: $memberId, totalBazar: $totalBazar, mealCost: $mealCost, monthlyShare: $monthlyShare, balance: $balance)';
}


}

/// @nodoc
abstract mixin class _$MemberBalanceSummaryCopyWith<$Res> implements $MemberBalanceSummaryCopyWith<$Res> {
  factory _$MemberBalanceSummaryCopyWith(_MemberBalanceSummary value, $Res Function(_MemberBalanceSummary) _then) = __$MemberBalanceSummaryCopyWithImpl;
@override @useResult
$Res call({
 String memberId, double totalBazar, double mealCost, double monthlyShare, double balance
});




}
/// @nodoc
class __$MemberBalanceSummaryCopyWithImpl<$Res>
    implements _$MemberBalanceSummaryCopyWith<$Res> {
  __$MemberBalanceSummaryCopyWithImpl(this._self, this._then);

  final _MemberBalanceSummary _self;
  final $Res Function(_MemberBalanceSummary) _then;

/// Create a copy of MemberBalanceSummary
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? memberId = null,Object? totalBazar = null,Object? mealCost = null,Object? monthlyShare = null,Object? balance = null,}) {
  return _then(_MemberBalanceSummary(
memberId: null == memberId ? _self.memberId : memberId // ignore: cast_nullable_to_non_nullable
as String,totalBazar: null == totalBazar ? _self.totalBazar : totalBazar // ignore: cast_nullable_to_non_nullable
as double,mealCost: null == mealCost ? _self.mealCost : mealCost // ignore: cast_nullable_to_non_nullable
as double,monthlyShare: null == monthlyShare ? _self.monthlyShare : monthlyShare // ignore: cast_nullable_to_non_nullable
as double,balance: null == balance ? _self.balance : balance // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

// dart format on
