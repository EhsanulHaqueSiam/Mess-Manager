// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'bazar_list_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$BazarListItem {

 String get id; String get name; String get addedById; String? get claimedById; BazarListStatus get status; String? get quantity; String? get note; DateTime? get createdAt; DateTime? get purchasedAt;
/// Create a copy of BazarListItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BazarListItemCopyWith<BazarListItem> get copyWith => _$BazarListItemCopyWithImpl<BazarListItem>(this as BazarListItem, _$identity);

  /// Serializes this BazarListItem to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BazarListItem&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.addedById, addedById) || other.addedById == addedById)&&(identical(other.claimedById, claimedById) || other.claimedById == claimedById)&&(identical(other.status, status) || other.status == status)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.note, note) || other.note == note)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.purchasedAt, purchasedAt) || other.purchasedAt == purchasedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,addedById,claimedById,status,quantity,note,createdAt,purchasedAt);

@override
String toString() {
  return 'BazarListItem(id: $id, name: $name, addedById: $addedById, claimedById: $claimedById, status: $status, quantity: $quantity, note: $note, createdAt: $createdAt, purchasedAt: $purchasedAt)';
}


}

/// @nodoc
abstract mixin class $BazarListItemCopyWith<$Res>  {
  factory $BazarListItemCopyWith(BazarListItem value, $Res Function(BazarListItem) _then) = _$BazarListItemCopyWithImpl;
@useResult
$Res call({
 String id, String name, String addedById, String? claimedById, BazarListStatus status, String? quantity, String? note, DateTime? createdAt, DateTime? purchasedAt
});




}
/// @nodoc
class _$BazarListItemCopyWithImpl<$Res>
    implements $BazarListItemCopyWith<$Res> {
  _$BazarListItemCopyWithImpl(this._self, this._then);

  final BazarListItem _self;
  final $Res Function(BazarListItem) _then;

/// Create a copy of BazarListItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? addedById = null,Object? claimedById = freezed,Object? status = null,Object? quantity = freezed,Object? note = freezed,Object? createdAt = freezed,Object? purchasedAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,addedById: null == addedById ? _self.addedById : addedById // ignore: cast_nullable_to_non_nullable
as String,claimedById: freezed == claimedById ? _self.claimedById : claimedById // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as BazarListStatus,quantity: freezed == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as String?,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,purchasedAt: freezed == purchasedAt ? _self.purchasedAt : purchasedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [BazarListItem].
extension BazarListItemPatterns on BazarListItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BazarListItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BazarListItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BazarListItem value)  $default,){
final _that = this;
switch (_that) {
case _BazarListItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BazarListItem value)?  $default,){
final _that = this;
switch (_that) {
case _BazarListItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String addedById,  String? claimedById,  BazarListStatus status,  String? quantity,  String? note,  DateTime? createdAt,  DateTime? purchasedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BazarListItem() when $default != null:
return $default(_that.id,_that.name,_that.addedById,_that.claimedById,_that.status,_that.quantity,_that.note,_that.createdAt,_that.purchasedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String addedById,  String? claimedById,  BazarListStatus status,  String? quantity,  String? note,  DateTime? createdAt,  DateTime? purchasedAt)  $default,) {final _that = this;
switch (_that) {
case _BazarListItem():
return $default(_that.id,_that.name,_that.addedById,_that.claimedById,_that.status,_that.quantity,_that.note,_that.createdAt,_that.purchasedAt);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String addedById,  String? claimedById,  BazarListStatus status,  String? quantity,  String? note,  DateTime? createdAt,  DateTime? purchasedAt)?  $default,) {final _that = this;
switch (_that) {
case _BazarListItem() when $default != null:
return $default(_that.id,_that.name,_that.addedById,_that.claimedById,_that.status,_that.quantity,_that.note,_that.createdAt,_that.purchasedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _BazarListItem implements BazarListItem {
  const _BazarListItem({required this.id, required this.name, required this.addedById, this.claimedById, this.status = BazarListStatus.pending, this.quantity, this.note, this.createdAt, this.purchasedAt});
  factory _BazarListItem.fromJson(Map<String, dynamic> json) => _$BazarListItemFromJson(json);

@override final  String id;
@override final  String name;
@override final  String addedById;
@override final  String? claimedById;
@override@JsonKey() final  BazarListStatus status;
@override final  String? quantity;
@override final  String? note;
@override final  DateTime? createdAt;
@override final  DateTime? purchasedAt;

/// Create a copy of BazarListItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BazarListItemCopyWith<_BazarListItem> get copyWith => __$BazarListItemCopyWithImpl<_BazarListItem>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BazarListItemToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BazarListItem&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.addedById, addedById) || other.addedById == addedById)&&(identical(other.claimedById, claimedById) || other.claimedById == claimedById)&&(identical(other.status, status) || other.status == status)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.note, note) || other.note == note)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.purchasedAt, purchasedAt) || other.purchasedAt == purchasedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,addedById,claimedById,status,quantity,note,createdAt,purchasedAt);

@override
String toString() {
  return 'BazarListItem(id: $id, name: $name, addedById: $addedById, claimedById: $claimedById, status: $status, quantity: $quantity, note: $note, createdAt: $createdAt, purchasedAt: $purchasedAt)';
}


}

/// @nodoc
abstract mixin class _$BazarListItemCopyWith<$Res> implements $BazarListItemCopyWith<$Res> {
  factory _$BazarListItemCopyWith(_BazarListItem value, $Res Function(_BazarListItem) _then) = __$BazarListItemCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String addedById, String? claimedById, BazarListStatus status, String? quantity, String? note, DateTime? createdAt, DateTime? purchasedAt
});




}
/// @nodoc
class __$BazarListItemCopyWithImpl<$Res>
    implements _$BazarListItemCopyWith<$Res> {
  __$BazarListItemCopyWithImpl(this._self, this._then);

  final _BazarListItem _self;
  final $Res Function(_BazarListItem) _then;

/// Create a copy of BazarListItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? addedById = null,Object? claimedById = freezed,Object? status = null,Object? quantity = freezed,Object? note = freezed,Object? createdAt = freezed,Object? purchasedAt = freezed,}) {
  return _then(_BazarListItem(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,addedById: null == addedById ? _self.addedById : addedById // ignore: cast_nullable_to_non_nullable
as String,claimedById: freezed == claimedById ? _self.claimedById : claimedById // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as BazarListStatus,quantity: freezed == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as String?,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,purchasedAt: freezed == purchasedAt ? _self.purchasedAt : purchasedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
