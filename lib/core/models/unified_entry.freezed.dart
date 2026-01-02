// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'unified_entry.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UnifiedEntry {

 String get id; String get memberId; DateTime get date; double get amount; String? get description; EntryType get type; MonthlyCategory? get monthlyCategory;// For monthly/fixed entries
 List<String> get photoUrls; List<String> get receiptUrls; bool get isAutoDetected;// Was type auto-detected by NLP?
 List<UnifiedEntryItem> get items;// For itemized entries
 DateTime? get createdAt;
/// Create a copy of UnifiedEntry
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UnifiedEntryCopyWith<UnifiedEntry> get copyWith => _$UnifiedEntryCopyWithImpl<UnifiedEntry>(this as UnifiedEntry, _$identity);

  /// Serializes this UnifiedEntry to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UnifiedEntry&&(identical(other.id, id) || other.id == id)&&(identical(other.memberId, memberId) || other.memberId == memberId)&&(identical(other.date, date) || other.date == date)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.description, description) || other.description == description)&&(identical(other.type, type) || other.type == type)&&(identical(other.monthlyCategory, monthlyCategory) || other.monthlyCategory == monthlyCategory)&&const DeepCollectionEquality().equals(other.photoUrls, photoUrls)&&const DeepCollectionEquality().equals(other.receiptUrls, receiptUrls)&&(identical(other.isAutoDetected, isAutoDetected) || other.isAutoDetected == isAutoDetected)&&const DeepCollectionEquality().equals(other.items, items)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,memberId,date,amount,description,type,monthlyCategory,const DeepCollectionEquality().hash(photoUrls),const DeepCollectionEquality().hash(receiptUrls),isAutoDetected,const DeepCollectionEquality().hash(items),createdAt);

@override
String toString() {
  return 'UnifiedEntry(id: $id, memberId: $memberId, date: $date, amount: $amount, description: $description, type: $type, monthlyCategory: $monthlyCategory, photoUrls: $photoUrls, receiptUrls: $receiptUrls, isAutoDetected: $isAutoDetected, items: $items, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $UnifiedEntryCopyWith<$Res>  {
  factory $UnifiedEntryCopyWith(UnifiedEntry value, $Res Function(UnifiedEntry) _then) = _$UnifiedEntryCopyWithImpl;
@useResult
$Res call({
 String id, String memberId, DateTime date, double amount, String? description, EntryType type, MonthlyCategory? monthlyCategory, List<String> photoUrls, List<String> receiptUrls, bool isAutoDetected, List<UnifiedEntryItem> items, DateTime? createdAt
});




}
/// @nodoc
class _$UnifiedEntryCopyWithImpl<$Res>
    implements $UnifiedEntryCopyWith<$Res> {
  _$UnifiedEntryCopyWithImpl(this._self, this._then);

  final UnifiedEntry _self;
  final $Res Function(UnifiedEntry) _then;

/// Create a copy of UnifiedEntry
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? memberId = null,Object? date = null,Object? amount = null,Object? description = freezed,Object? type = null,Object? monthlyCategory = freezed,Object? photoUrls = null,Object? receiptUrls = null,Object? isAutoDetected = null,Object? items = null,Object? createdAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,memberId: null == memberId ? _self.memberId : memberId // ignore: cast_nullable_to_non_nullable
as String,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as double,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as EntryType,monthlyCategory: freezed == monthlyCategory ? _self.monthlyCategory : monthlyCategory // ignore: cast_nullable_to_non_nullable
as MonthlyCategory?,photoUrls: null == photoUrls ? _self.photoUrls : photoUrls // ignore: cast_nullable_to_non_nullable
as List<String>,receiptUrls: null == receiptUrls ? _self.receiptUrls : receiptUrls // ignore: cast_nullable_to_non_nullable
as List<String>,isAutoDetected: null == isAutoDetected ? _self.isAutoDetected : isAutoDetected // ignore: cast_nullable_to_non_nullable
as bool,items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<UnifiedEntryItem>,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [UnifiedEntry].
extension UnifiedEntryPatterns on UnifiedEntry {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UnifiedEntry value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UnifiedEntry() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UnifiedEntry value)  $default,){
final _that = this;
switch (_that) {
case _UnifiedEntry():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UnifiedEntry value)?  $default,){
final _that = this;
switch (_that) {
case _UnifiedEntry() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String memberId,  DateTime date,  double amount,  String? description,  EntryType type,  MonthlyCategory? monthlyCategory,  List<String> photoUrls,  List<String> receiptUrls,  bool isAutoDetected,  List<UnifiedEntryItem> items,  DateTime? createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UnifiedEntry() when $default != null:
return $default(_that.id,_that.memberId,_that.date,_that.amount,_that.description,_that.type,_that.monthlyCategory,_that.photoUrls,_that.receiptUrls,_that.isAutoDetected,_that.items,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String memberId,  DateTime date,  double amount,  String? description,  EntryType type,  MonthlyCategory? monthlyCategory,  List<String> photoUrls,  List<String> receiptUrls,  bool isAutoDetected,  List<UnifiedEntryItem> items,  DateTime? createdAt)  $default,) {final _that = this;
switch (_that) {
case _UnifiedEntry():
return $default(_that.id,_that.memberId,_that.date,_that.amount,_that.description,_that.type,_that.monthlyCategory,_that.photoUrls,_that.receiptUrls,_that.isAutoDetected,_that.items,_that.createdAt);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String memberId,  DateTime date,  double amount,  String? description,  EntryType type,  MonthlyCategory? monthlyCategory,  List<String> photoUrls,  List<String> receiptUrls,  bool isAutoDetected,  List<UnifiedEntryItem> items,  DateTime? createdAt)?  $default,) {final _that = this;
switch (_that) {
case _UnifiedEntry() when $default != null:
return $default(_that.id,_that.memberId,_that.date,_that.amount,_that.description,_that.type,_that.monthlyCategory,_that.photoUrls,_that.receiptUrls,_that.isAutoDetected,_that.items,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UnifiedEntry implements UnifiedEntry {
  const _UnifiedEntry({required this.id, required this.memberId, required this.date, required this.amount, this.description, this.type = EntryType.mealBazar, this.monthlyCategory, final  List<String> photoUrls = const [], final  List<String> receiptUrls = const [], this.isAutoDetected = true, final  List<UnifiedEntryItem> items = const [], this.createdAt}): _photoUrls = photoUrls,_receiptUrls = receiptUrls,_items = items;
  factory _UnifiedEntry.fromJson(Map<String, dynamic> json) => _$UnifiedEntryFromJson(json);

@override final  String id;
@override final  String memberId;
@override final  DateTime date;
@override final  double amount;
@override final  String? description;
@override@JsonKey() final  EntryType type;
@override final  MonthlyCategory? monthlyCategory;
// For monthly/fixed entries
 final  List<String> _photoUrls;
// For monthly/fixed entries
@override@JsonKey() List<String> get photoUrls {
  if (_photoUrls is EqualUnmodifiableListView) return _photoUrls;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_photoUrls);
}

 final  List<String> _receiptUrls;
@override@JsonKey() List<String> get receiptUrls {
  if (_receiptUrls is EqualUnmodifiableListView) return _receiptUrls;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_receiptUrls);
}

@override@JsonKey() final  bool isAutoDetected;
// Was type auto-detected by NLP?
 final  List<UnifiedEntryItem> _items;
// Was type auto-detected by NLP?
@override@JsonKey() List<UnifiedEntryItem> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}

// For itemized entries
@override final  DateTime? createdAt;

/// Create a copy of UnifiedEntry
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UnifiedEntryCopyWith<_UnifiedEntry> get copyWith => __$UnifiedEntryCopyWithImpl<_UnifiedEntry>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UnifiedEntryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UnifiedEntry&&(identical(other.id, id) || other.id == id)&&(identical(other.memberId, memberId) || other.memberId == memberId)&&(identical(other.date, date) || other.date == date)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.description, description) || other.description == description)&&(identical(other.type, type) || other.type == type)&&(identical(other.monthlyCategory, monthlyCategory) || other.monthlyCategory == monthlyCategory)&&const DeepCollectionEquality().equals(other._photoUrls, _photoUrls)&&const DeepCollectionEquality().equals(other._receiptUrls, _receiptUrls)&&(identical(other.isAutoDetected, isAutoDetected) || other.isAutoDetected == isAutoDetected)&&const DeepCollectionEquality().equals(other._items, _items)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,memberId,date,amount,description,type,monthlyCategory,const DeepCollectionEquality().hash(_photoUrls),const DeepCollectionEquality().hash(_receiptUrls),isAutoDetected,const DeepCollectionEquality().hash(_items),createdAt);

@override
String toString() {
  return 'UnifiedEntry(id: $id, memberId: $memberId, date: $date, amount: $amount, description: $description, type: $type, monthlyCategory: $monthlyCategory, photoUrls: $photoUrls, receiptUrls: $receiptUrls, isAutoDetected: $isAutoDetected, items: $items, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$UnifiedEntryCopyWith<$Res> implements $UnifiedEntryCopyWith<$Res> {
  factory _$UnifiedEntryCopyWith(_UnifiedEntry value, $Res Function(_UnifiedEntry) _then) = __$UnifiedEntryCopyWithImpl;
@override @useResult
$Res call({
 String id, String memberId, DateTime date, double amount, String? description, EntryType type, MonthlyCategory? monthlyCategory, List<String> photoUrls, List<String> receiptUrls, bool isAutoDetected, List<UnifiedEntryItem> items, DateTime? createdAt
});




}
/// @nodoc
class __$UnifiedEntryCopyWithImpl<$Res>
    implements _$UnifiedEntryCopyWith<$Res> {
  __$UnifiedEntryCopyWithImpl(this._self, this._then);

  final _UnifiedEntry _self;
  final $Res Function(_UnifiedEntry) _then;

/// Create a copy of UnifiedEntry
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? memberId = null,Object? date = null,Object? amount = null,Object? description = freezed,Object? type = null,Object? monthlyCategory = freezed,Object? photoUrls = null,Object? receiptUrls = null,Object? isAutoDetected = null,Object? items = null,Object? createdAt = freezed,}) {
  return _then(_UnifiedEntry(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,memberId: null == memberId ? _self.memberId : memberId // ignore: cast_nullable_to_non_nullable
as String,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as double,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as EntryType,monthlyCategory: freezed == monthlyCategory ? _self.monthlyCategory : monthlyCategory // ignore: cast_nullable_to_non_nullable
as MonthlyCategory?,photoUrls: null == photoUrls ? _self._photoUrls : photoUrls // ignore: cast_nullable_to_non_nullable
as List<String>,receiptUrls: null == receiptUrls ? _self._receiptUrls : receiptUrls // ignore: cast_nullable_to_non_nullable
as List<String>,isAutoDetected: null == isAutoDetected ? _self.isAutoDetected : isAutoDetected // ignore: cast_nullable_to_non_nullable
as bool,items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<UnifiedEntryItem>,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}


/// @nodoc
mixin _$UnifiedEntryItem {

 String get name; double get price; EntryType? get type;// Can have different types per item
 MonthlyCategory? get category;
/// Create a copy of UnifiedEntryItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UnifiedEntryItemCopyWith<UnifiedEntryItem> get copyWith => _$UnifiedEntryItemCopyWithImpl<UnifiedEntryItem>(this as UnifiedEntryItem, _$identity);

  /// Serializes this UnifiedEntryItem to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UnifiedEntryItem&&(identical(other.name, name) || other.name == name)&&(identical(other.price, price) || other.price == price)&&(identical(other.type, type) || other.type == type)&&(identical(other.category, category) || other.category == category));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,price,type,category);

@override
String toString() {
  return 'UnifiedEntryItem(name: $name, price: $price, type: $type, category: $category)';
}


}

/// @nodoc
abstract mixin class $UnifiedEntryItemCopyWith<$Res>  {
  factory $UnifiedEntryItemCopyWith(UnifiedEntryItem value, $Res Function(UnifiedEntryItem) _then) = _$UnifiedEntryItemCopyWithImpl;
@useResult
$Res call({
 String name, double price, EntryType? type, MonthlyCategory? category
});




}
/// @nodoc
class _$UnifiedEntryItemCopyWithImpl<$Res>
    implements $UnifiedEntryItemCopyWith<$Res> {
  _$UnifiedEntryItemCopyWithImpl(this._self, this._then);

  final UnifiedEntryItem _self;
  final $Res Function(UnifiedEntryItem) _then;

/// Create a copy of UnifiedEntryItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? price = null,Object? type = freezed,Object? category = freezed,}) {
  return _then(_self.copyWith(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,price: null == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as double,type: freezed == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as EntryType?,category: freezed == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as MonthlyCategory?,
  ));
}

}


/// Adds pattern-matching-related methods to [UnifiedEntryItem].
extension UnifiedEntryItemPatterns on UnifiedEntryItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UnifiedEntryItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UnifiedEntryItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UnifiedEntryItem value)  $default,){
final _that = this;
switch (_that) {
case _UnifiedEntryItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UnifiedEntryItem value)?  $default,){
final _that = this;
switch (_that) {
case _UnifiedEntryItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  double price,  EntryType? type,  MonthlyCategory? category)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UnifiedEntryItem() when $default != null:
return $default(_that.name,_that.price,_that.type,_that.category);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  double price,  EntryType? type,  MonthlyCategory? category)  $default,) {final _that = this;
switch (_that) {
case _UnifiedEntryItem():
return $default(_that.name,_that.price,_that.type,_that.category);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  double price,  EntryType? type,  MonthlyCategory? category)?  $default,) {final _that = this;
switch (_that) {
case _UnifiedEntryItem() when $default != null:
return $default(_that.name,_that.price,_that.type,_that.category);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UnifiedEntryItem implements UnifiedEntryItem {
  const _UnifiedEntryItem({required this.name, required this.price, this.type, this.category});
  factory _UnifiedEntryItem.fromJson(Map<String, dynamic> json) => _$UnifiedEntryItemFromJson(json);

@override final  String name;
@override final  double price;
@override final  EntryType? type;
// Can have different types per item
@override final  MonthlyCategory? category;

/// Create a copy of UnifiedEntryItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UnifiedEntryItemCopyWith<_UnifiedEntryItem> get copyWith => __$UnifiedEntryItemCopyWithImpl<_UnifiedEntryItem>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UnifiedEntryItemToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UnifiedEntryItem&&(identical(other.name, name) || other.name == name)&&(identical(other.price, price) || other.price == price)&&(identical(other.type, type) || other.type == type)&&(identical(other.category, category) || other.category == category));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,price,type,category);

@override
String toString() {
  return 'UnifiedEntryItem(name: $name, price: $price, type: $type, category: $category)';
}


}

/// @nodoc
abstract mixin class _$UnifiedEntryItemCopyWith<$Res> implements $UnifiedEntryItemCopyWith<$Res> {
  factory _$UnifiedEntryItemCopyWith(_UnifiedEntryItem value, $Res Function(_UnifiedEntryItem) _then) = __$UnifiedEntryItemCopyWithImpl;
@override @useResult
$Res call({
 String name, double price, EntryType? type, MonthlyCategory? category
});




}
/// @nodoc
class __$UnifiedEntryItemCopyWithImpl<$Res>
    implements _$UnifiedEntryItemCopyWith<$Res> {
  __$UnifiedEntryItemCopyWithImpl(this._self, this._then);

  final _UnifiedEntryItem _self;
  final $Res Function(_UnifiedEntryItem) _then;

/// Create a copy of UnifiedEntryItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? price = null,Object? type = freezed,Object? category = freezed,}) {
  return _then(_UnifiedEntryItem(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,price: null == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as double,type: freezed == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as EntryType?,category: freezed == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as MonthlyCategory?,
  ));
}


}

// dart format on
