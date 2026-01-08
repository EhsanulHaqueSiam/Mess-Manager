// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'bazar_entry.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$BazarItem {

 String get name; double get price; String? get quantity; String? get unit;
/// Create a copy of BazarItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BazarItemCopyWith<BazarItem> get copyWith => _$BazarItemCopyWithImpl<BazarItem>(this as BazarItem, _$identity);

  /// Serializes this BazarItem to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BazarItem&&(identical(other.name, name) || other.name == name)&&(identical(other.price, price) || other.price == price)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.unit, unit) || other.unit == unit));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,price,quantity,unit);

@override
String toString() {
  return 'BazarItem(name: $name, price: $price, quantity: $quantity, unit: $unit)';
}


}

/// @nodoc
abstract mixin class $BazarItemCopyWith<$Res>  {
  factory $BazarItemCopyWith(BazarItem value, $Res Function(BazarItem) _then) = _$BazarItemCopyWithImpl;
@useResult
$Res call({
 String name, double price, String? quantity, String? unit
});




}
/// @nodoc
class _$BazarItemCopyWithImpl<$Res>
    implements $BazarItemCopyWith<$Res> {
  _$BazarItemCopyWithImpl(this._self, this._then);

  final BazarItem _self;
  final $Res Function(BazarItem) _then;

/// Create a copy of BazarItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? price = null,Object? quantity = freezed,Object? unit = freezed,}) {
  return _then(_self.copyWith(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,price: null == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as double,quantity: freezed == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as String?,unit: freezed == unit ? _self.unit : unit // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [BazarItem].
extension BazarItemPatterns on BazarItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BazarItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BazarItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BazarItem value)  $default,){
final _that = this;
switch (_that) {
case _BazarItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BazarItem value)?  $default,){
final _that = this;
switch (_that) {
case _BazarItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  double price,  String? quantity,  String? unit)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BazarItem() when $default != null:
return $default(_that.name,_that.price,_that.quantity,_that.unit);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  double price,  String? quantity,  String? unit)  $default,) {final _that = this;
switch (_that) {
case _BazarItem():
return $default(_that.name,_that.price,_that.quantity,_that.unit);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  double price,  String? quantity,  String? unit)?  $default,) {final _that = this;
switch (_that) {
case _BazarItem() when $default != null:
return $default(_that.name,_that.price,_that.quantity,_that.unit);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _BazarItem implements BazarItem {
  const _BazarItem({required this.name, required this.price, this.quantity, this.unit});
  factory _BazarItem.fromJson(Map<String, dynamic> json) => _$BazarItemFromJson(json);

@override final  String name;
@override final  double price;
@override final  String? quantity;
@override final  String? unit;

/// Create a copy of BazarItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BazarItemCopyWith<_BazarItem> get copyWith => __$BazarItemCopyWithImpl<_BazarItem>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BazarItemToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BazarItem&&(identical(other.name, name) || other.name == name)&&(identical(other.price, price) || other.price == price)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.unit, unit) || other.unit == unit));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,price,quantity,unit);

@override
String toString() {
  return 'BazarItem(name: $name, price: $price, quantity: $quantity, unit: $unit)';
}


}

/// @nodoc
abstract mixin class _$BazarItemCopyWith<$Res> implements $BazarItemCopyWith<$Res> {
  factory _$BazarItemCopyWith(_BazarItem value, $Res Function(_BazarItem) _then) = __$BazarItemCopyWithImpl;
@override @useResult
$Res call({
 String name, double price, String? quantity, String? unit
});




}
/// @nodoc
class __$BazarItemCopyWithImpl<$Res>
    implements _$BazarItemCopyWith<$Res> {
  __$BazarItemCopyWithImpl(this._self, this._then);

  final _BazarItem _self;
  final $Res Function(_BazarItem) _then;

/// Create a copy of BazarItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? price = null,Object? quantity = freezed,Object? unit = freezed,}) {
  return _then(_BazarItem(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,price: null == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as double,quantity: freezed == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as String?,unit: freezed == unit ? _self.unit : unit // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$BazarEntry {

 String get id; String get memberId; DateTime get date; double get amount; String? get description; List<BazarItem> get items;// For itemized entries
 bool get isItemized; List<String> get photoUrls;// Bazar photos (multiple)
 List<String> get receiptUrls;// Receipt images (separate section)
 DateTime? get createdAt;
/// Create a copy of BazarEntry
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BazarEntryCopyWith<BazarEntry> get copyWith => _$BazarEntryCopyWithImpl<BazarEntry>(this as BazarEntry, _$identity);

  /// Serializes this BazarEntry to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BazarEntry&&(identical(other.id, id) || other.id == id)&&(identical(other.memberId, memberId) || other.memberId == memberId)&&(identical(other.date, date) || other.date == date)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.description, description) || other.description == description)&&const DeepCollectionEquality().equals(other.items, items)&&(identical(other.isItemized, isItemized) || other.isItemized == isItemized)&&const DeepCollectionEquality().equals(other.photoUrls, photoUrls)&&const DeepCollectionEquality().equals(other.receiptUrls, receiptUrls)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,memberId,date,amount,description,const DeepCollectionEquality().hash(items),isItemized,const DeepCollectionEquality().hash(photoUrls),const DeepCollectionEquality().hash(receiptUrls),createdAt);

@override
String toString() {
  return 'BazarEntry(id: $id, memberId: $memberId, date: $date, amount: $amount, description: $description, items: $items, isItemized: $isItemized, photoUrls: $photoUrls, receiptUrls: $receiptUrls, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $BazarEntryCopyWith<$Res>  {
  factory $BazarEntryCopyWith(BazarEntry value, $Res Function(BazarEntry) _then) = _$BazarEntryCopyWithImpl;
@useResult
$Res call({
 String id, String memberId, DateTime date, double amount, String? description, List<BazarItem> items, bool isItemized, List<String> photoUrls, List<String> receiptUrls, DateTime? createdAt
});




}
/// @nodoc
class _$BazarEntryCopyWithImpl<$Res>
    implements $BazarEntryCopyWith<$Res> {
  _$BazarEntryCopyWithImpl(this._self, this._then);

  final BazarEntry _self;
  final $Res Function(BazarEntry) _then;

/// Create a copy of BazarEntry
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? memberId = null,Object? date = null,Object? amount = null,Object? description = freezed,Object? items = null,Object? isItemized = null,Object? photoUrls = null,Object? receiptUrls = null,Object? createdAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,memberId: null == memberId ? _self.memberId : memberId // ignore: cast_nullable_to_non_nullable
as String,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as double,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<BazarItem>,isItemized: null == isItemized ? _self.isItemized : isItemized // ignore: cast_nullable_to_non_nullable
as bool,photoUrls: null == photoUrls ? _self.photoUrls : photoUrls // ignore: cast_nullable_to_non_nullable
as List<String>,receiptUrls: null == receiptUrls ? _self.receiptUrls : receiptUrls // ignore: cast_nullable_to_non_nullable
as List<String>,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [BazarEntry].
extension BazarEntryPatterns on BazarEntry {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BazarEntry value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BazarEntry() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BazarEntry value)  $default,){
final _that = this;
switch (_that) {
case _BazarEntry():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BazarEntry value)?  $default,){
final _that = this;
switch (_that) {
case _BazarEntry() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String memberId,  DateTime date,  double amount,  String? description,  List<BazarItem> items,  bool isItemized,  List<String> photoUrls,  List<String> receiptUrls,  DateTime? createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BazarEntry() when $default != null:
return $default(_that.id,_that.memberId,_that.date,_that.amount,_that.description,_that.items,_that.isItemized,_that.photoUrls,_that.receiptUrls,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String memberId,  DateTime date,  double amount,  String? description,  List<BazarItem> items,  bool isItemized,  List<String> photoUrls,  List<String> receiptUrls,  DateTime? createdAt)  $default,) {final _that = this;
switch (_that) {
case _BazarEntry():
return $default(_that.id,_that.memberId,_that.date,_that.amount,_that.description,_that.items,_that.isItemized,_that.photoUrls,_that.receiptUrls,_that.createdAt);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String memberId,  DateTime date,  double amount,  String? description,  List<BazarItem> items,  bool isItemized,  List<String> photoUrls,  List<String> receiptUrls,  DateTime? createdAt)?  $default,) {final _that = this;
switch (_that) {
case _BazarEntry() when $default != null:
return $default(_that.id,_that.memberId,_that.date,_that.amount,_that.description,_that.items,_that.isItemized,_that.photoUrls,_that.receiptUrls,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _BazarEntry implements BazarEntry {
  const _BazarEntry({required this.id, required this.memberId, required this.date, required this.amount, this.description, final  List<BazarItem> items = const [], this.isItemized = false, final  List<String> photoUrls = const [], final  List<String> receiptUrls = const [], this.createdAt}): _items = items,_photoUrls = photoUrls,_receiptUrls = receiptUrls;
  factory _BazarEntry.fromJson(Map<String, dynamic> json) => _$BazarEntryFromJson(json);

@override final  String id;
@override final  String memberId;
@override final  DateTime date;
@override final  double amount;
@override final  String? description;
 final  List<BazarItem> _items;
@override@JsonKey() List<BazarItem> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}

// For itemized entries
@override@JsonKey() final  bool isItemized;
 final  List<String> _photoUrls;
@override@JsonKey() List<String> get photoUrls {
  if (_photoUrls is EqualUnmodifiableListView) return _photoUrls;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_photoUrls);
}

// Bazar photos (multiple)
 final  List<String> _receiptUrls;
// Bazar photos (multiple)
@override@JsonKey() List<String> get receiptUrls {
  if (_receiptUrls is EqualUnmodifiableListView) return _receiptUrls;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_receiptUrls);
}

// Receipt images (separate section)
@override final  DateTime? createdAt;

/// Create a copy of BazarEntry
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BazarEntryCopyWith<_BazarEntry> get copyWith => __$BazarEntryCopyWithImpl<_BazarEntry>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BazarEntryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BazarEntry&&(identical(other.id, id) || other.id == id)&&(identical(other.memberId, memberId) || other.memberId == memberId)&&(identical(other.date, date) || other.date == date)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.description, description) || other.description == description)&&const DeepCollectionEquality().equals(other._items, _items)&&(identical(other.isItemized, isItemized) || other.isItemized == isItemized)&&const DeepCollectionEquality().equals(other._photoUrls, _photoUrls)&&const DeepCollectionEquality().equals(other._receiptUrls, _receiptUrls)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,memberId,date,amount,description,const DeepCollectionEquality().hash(_items),isItemized,const DeepCollectionEquality().hash(_photoUrls),const DeepCollectionEquality().hash(_receiptUrls),createdAt);

@override
String toString() {
  return 'BazarEntry(id: $id, memberId: $memberId, date: $date, amount: $amount, description: $description, items: $items, isItemized: $isItemized, photoUrls: $photoUrls, receiptUrls: $receiptUrls, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$BazarEntryCopyWith<$Res> implements $BazarEntryCopyWith<$Res> {
  factory _$BazarEntryCopyWith(_BazarEntry value, $Res Function(_BazarEntry) _then) = __$BazarEntryCopyWithImpl;
@override @useResult
$Res call({
 String id, String memberId, DateTime date, double amount, String? description, List<BazarItem> items, bool isItemized, List<String> photoUrls, List<String> receiptUrls, DateTime? createdAt
});




}
/// @nodoc
class __$BazarEntryCopyWithImpl<$Res>
    implements _$BazarEntryCopyWith<$Res> {
  __$BazarEntryCopyWithImpl(this._self, this._then);

  final _BazarEntry _self;
  final $Res Function(_BazarEntry) _then;

/// Create a copy of BazarEntry
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? memberId = null,Object? date = null,Object? amount = null,Object? description = freezed,Object? items = null,Object? isItemized = null,Object? photoUrls = null,Object? receiptUrls = null,Object? createdAt = freezed,}) {
  return _then(_BazarEntry(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,memberId: null == memberId ? _self.memberId : memberId // ignore: cast_nullable_to_non_nullable
as String,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as double,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<BazarItem>,isItemized: null == isItemized ? _self.isItemized : isItemized // ignore: cast_nullable_to_non_nullable
as bool,photoUrls: null == photoUrls ? _self._photoUrls : photoUrls // ignore: cast_nullable_to_non_nullable
as List<String>,receiptUrls: null == receiptUrls ? _self._receiptUrls : receiptUrls // ignore: cast_nullable_to_non_nullable
as List<String>,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
