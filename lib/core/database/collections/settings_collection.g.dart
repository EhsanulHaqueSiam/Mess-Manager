// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings_collection.dart';

// **************************************************************************
// _IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, invalid_use_of_protected_member, lines_longer_than_80_chars, constant_identifier_names, avoid_js_rounded_ints, no_leading_underscores_for_local_identifiers, require_trailing_commas, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_in_if_null_operators, library_private_types_in_public_api, prefer_const_constructors
// ignore_for_file: type=lint

extension GetSettingsCollectionCollection on Isar {
  IsarCollection<int, SettingsCollection> get settingsCollections =>
      this.collection();
}

final SettingsCollectionSchema = IsarGeneratedSchema(
  schema: IsarSchema(
    name: 'SettingsCollection',
    idName: 'id',
    embedded: false,
    properties: [
      IsarPropertySchema(name: 'key', type: IsarType.string),
      IsarPropertySchema(name: 'valueJson', type: IsarType.string),
      IsarPropertySchema(name: 'valueType', type: IsarType.string),
    ],
    indexes: [
      IsarIndexSchema(
        name: 'key',
        properties: ["key"],
        unique: true,
        hash: false,
      ),
    ],
  ),
  converter: IsarObjectConverter<int, SettingsCollection>(
    serialize: serializeSettingsCollection,
    deserialize: deserializeSettingsCollection,
    deserializeProperty: deserializeSettingsCollectionProp,
  ),
  getEmbeddedSchemas: () => [],
);

@isarProtected
int serializeSettingsCollection(IsarWriter writer, SettingsCollection object) {
  IsarCore.writeString(writer, 1, object.key);
  {
    final value = object.valueJson;
    if (value == null) {
      IsarCore.writeNull(writer, 2);
    } else {
      IsarCore.writeString(writer, 2, value);
    }
  }
  IsarCore.writeString(writer, 3, object.valueType);
  return object.id;
}

@isarProtected
SettingsCollection deserializeSettingsCollection(IsarReader reader) {
  final object = SettingsCollection();
  object.id = IsarCore.readId(reader);
  object.key = IsarCore.readString(reader, 1) ?? '';
  object.valueJson = IsarCore.readString(reader, 2);
  object.valueType = IsarCore.readString(reader, 3) ?? '';
  return object;
}

@isarProtected
dynamic deserializeSettingsCollectionProp(IsarReader reader, int property) {
  switch (property) {
    case 0:
      return IsarCore.readId(reader);
    case 1:
      return IsarCore.readString(reader, 1) ?? '';
    case 2:
      return IsarCore.readString(reader, 2);
    case 3:
      return IsarCore.readString(reader, 3) ?? '';
    default:
      throw ArgumentError('Unknown property: $property');
  }
}

sealed class _SettingsCollectionUpdate {
  bool call({
    required int id,
    String? key,
    String? valueJson,
    String? valueType,
  });
}

class _SettingsCollectionUpdateImpl implements _SettingsCollectionUpdate {
  const _SettingsCollectionUpdateImpl(this.collection);

  final IsarCollection<int, SettingsCollection> collection;

  @override
  bool call({
    required int id,
    Object? key = ignore,
    Object? valueJson = ignore,
    Object? valueType = ignore,
  }) {
    return collection.updateProperties(
          [id],
          {
            if (key != ignore) 1: key as String?,
            if (valueJson != ignore) 2: valueJson as String?,
            if (valueType != ignore) 3: valueType as String?,
          },
        ) >
        0;
  }
}

sealed class _SettingsCollectionUpdateAll {
  int call({
    required List<int> id,
    String? key,
    String? valueJson,
    String? valueType,
  });
}

class _SettingsCollectionUpdateAllImpl implements _SettingsCollectionUpdateAll {
  const _SettingsCollectionUpdateAllImpl(this.collection);

  final IsarCollection<int, SettingsCollection> collection;

  @override
  int call({
    required List<int> id,
    Object? key = ignore,
    Object? valueJson = ignore,
    Object? valueType = ignore,
  }) {
    return collection.updateProperties(id, {
      if (key != ignore) 1: key as String?,
      if (valueJson != ignore) 2: valueJson as String?,
      if (valueType != ignore) 3: valueType as String?,
    });
  }
}

extension SettingsCollectionUpdate on IsarCollection<int, SettingsCollection> {
  _SettingsCollectionUpdate get update => _SettingsCollectionUpdateImpl(this);

  _SettingsCollectionUpdateAll get updateAll =>
      _SettingsCollectionUpdateAllImpl(this);
}

sealed class _SettingsCollectionQueryUpdate {
  int call({String? key, String? valueJson, String? valueType});
}

class _SettingsCollectionQueryUpdateImpl
    implements _SettingsCollectionQueryUpdate {
  const _SettingsCollectionQueryUpdateImpl(this.query, {this.limit});

  final IsarQuery<SettingsCollection> query;
  final int? limit;

  @override
  int call({
    Object? key = ignore,
    Object? valueJson = ignore,
    Object? valueType = ignore,
  }) {
    return query.updateProperties(limit: limit, {
      if (key != ignore) 1: key as String?,
      if (valueJson != ignore) 2: valueJson as String?,
      if (valueType != ignore) 3: valueType as String?,
    });
  }
}

extension SettingsCollectionQueryUpdate on IsarQuery<SettingsCollection> {
  _SettingsCollectionQueryUpdate get updateFirst =>
      _SettingsCollectionQueryUpdateImpl(this, limit: 1);

  _SettingsCollectionQueryUpdate get updateAll =>
      _SettingsCollectionQueryUpdateImpl(this);
}

class _SettingsCollectionQueryBuilderUpdateImpl
    implements _SettingsCollectionQueryUpdate {
  const _SettingsCollectionQueryBuilderUpdateImpl(this.query, {this.limit});

  final QueryBuilder<SettingsCollection, SettingsCollection, QOperations> query;
  final int? limit;

  @override
  int call({
    Object? key = ignore,
    Object? valueJson = ignore,
    Object? valueType = ignore,
  }) {
    final q = query.build();
    try {
      return q.updateProperties(limit: limit, {
        if (key != ignore) 1: key as String?,
        if (valueJson != ignore) 2: valueJson as String?,
        if (valueType != ignore) 3: valueType as String?,
      });
    } finally {
      q.close();
    }
  }
}

extension SettingsCollectionQueryBuilderUpdate
    on QueryBuilder<SettingsCollection, SettingsCollection, QOperations> {
  _SettingsCollectionQueryUpdate get updateFirst =>
      _SettingsCollectionQueryBuilderUpdateImpl(this, limit: 1);

  _SettingsCollectionQueryUpdate get updateAll =>
      _SettingsCollectionQueryBuilderUpdateImpl(this);
}

extension SettingsCollectionQueryFilter
    on QueryBuilder<SettingsCollection, SettingsCollection, QFilterCondition> {
  QueryBuilder<SettingsCollection, SettingsCollection, QAfterFilterCondition>
  idEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(property: 0, value: value),
      );
    });
  }

  QueryBuilder<SettingsCollection, SettingsCollection, QAfterFilterCondition>
  idGreaterThan(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(property: 0, value: value),
      );
    });
  }

  QueryBuilder<SettingsCollection, SettingsCollection, QAfterFilterCondition>
  idGreaterThanOrEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(property: 0, value: value),
      );
    });
  }

  QueryBuilder<SettingsCollection, SettingsCollection, QAfterFilterCondition>
  idLessThan(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(LessCondition(property: 0, value: value));
    });
  }

  QueryBuilder<SettingsCollection, SettingsCollection, QAfterFilterCondition>
  idLessThanOrEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(property: 0, value: value),
      );
    });
  }

  QueryBuilder<SettingsCollection, SettingsCollection, QAfterFilterCondition>
  idBetween(int lower, int upper) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(property: 0, lower: lower, upper: upper),
      );
    });
  }

  QueryBuilder<SettingsCollection, SettingsCollection, QAfterFilterCondition>
  keyEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(property: 1, value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<SettingsCollection, SettingsCollection, QAfterFilterCondition>
  keyGreaterThan(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(
          property: 1,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SettingsCollection, SettingsCollection, QAfterFilterCondition>
  keyGreaterThanOrEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(
          property: 1,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SettingsCollection, SettingsCollection, QAfterFilterCondition>
  keyLessThan(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(property: 1, value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<SettingsCollection, SettingsCollection, QAfterFilterCondition>
  keyLessThanOrEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(
          property: 1,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SettingsCollection, SettingsCollection, QAfterFilterCondition>
  keyBetween(String lower, String upper, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(
          property: 1,
          lower: lower,
          upper: upper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SettingsCollection, SettingsCollection, QAfterFilterCondition>
  keyStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        StartsWithCondition(
          property: 1,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SettingsCollection, SettingsCollection, QAfterFilterCondition>
  keyEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EndsWithCondition(
          property: 1,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SettingsCollection, SettingsCollection, QAfterFilterCondition>
  keyContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        ContainsCondition(
          property: 1,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SettingsCollection, SettingsCollection, QAfterFilterCondition>
  keyMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        MatchesCondition(
          property: 1,
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SettingsCollection, SettingsCollection, QAfterFilterCondition>
  keyIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const EqualCondition(property: 1, value: ''),
      );
    });
  }

  QueryBuilder<SettingsCollection, SettingsCollection, QAfterFilterCondition>
  keyIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const GreaterCondition(property: 1, value: ''),
      );
    });
  }

  QueryBuilder<SettingsCollection, SettingsCollection, QAfterFilterCondition>
  valueJsonIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const IsNullCondition(property: 2));
    });
  }

  QueryBuilder<SettingsCollection, SettingsCollection, QAfterFilterCondition>
  valueJsonIsNotNull() {
    return QueryBuilder.apply(not(), (query) {
      return query.addFilterCondition(const IsNullCondition(property: 2));
    });
  }

  QueryBuilder<SettingsCollection, SettingsCollection, QAfterFilterCondition>
  valueJsonEqualTo(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(property: 2, value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<SettingsCollection, SettingsCollection, QAfterFilterCondition>
  valueJsonGreaterThan(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(
          property: 2,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SettingsCollection, SettingsCollection, QAfterFilterCondition>
  valueJsonGreaterThanOrEqualTo(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(
          property: 2,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SettingsCollection, SettingsCollection, QAfterFilterCondition>
  valueJsonLessThan(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(property: 2, value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<SettingsCollection, SettingsCollection, QAfterFilterCondition>
  valueJsonLessThanOrEqualTo(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(
          property: 2,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SettingsCollection, SettingsCollection, QAfterFilterCondition>
  valueJsonBetween(String? lower, String? upper, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(
          property: 2,
          lower: lower,
          upper: upper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SettingsCollection, SettingsCollection, QAfterFilterCondition>
  valueJsonStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        StartsWithCondition(
          property: 2,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SettingsCollection, SettingsCollection, QAfterFilterCondition>
  valueJsonEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EndsWithCondition(
          property: 2,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SettingsCollection, SettingsCollection, QAfterFilterCondition>
  valueJsonContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        ContainsCondition(
          property: 2,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SettingsCollection, SettingsCollection, QAfterFilterCondition>
  valueJsonMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        MatchesCondition(
          property: 2,
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SettingsCollection, SettingsCollection, QAfterFilterCondition>
  valueJsonIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const EqualCondition(property: 2, value: ''),
      );
    });
  }

  QueryBuilder<SettingsCollection, SettingsCollection, QAfterFilterCondition>
  valueJsonIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const GreaterCondition(property: 2, value: ''),
      );
    });
  }

  QueryBuilder<SettingsCollection, SettingsCollection, QAfterFilterCondition>
  valueTypeEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(property: 3, value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<SettingsCollection, SettingsCollection, QAfterFilterCondition>
  valueTypeGreaterThan(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(
          property: 3,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SettingsCollection, SettingsCollection, QAfterFilterCondition>
  valueTypeGreaterThanOrEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(
          property: 3,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SettingsCollection, SettingsCollection, QAfterFilterCondition>
  valueTypeLessThan(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(property: 3, value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<SettingsCollection, SettingsCollection, QAfterFilterCondition>
  valueTypeLessThanOrEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(
          property: 3,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SettingsCollection, SettingsCollection, QAfterFilterCondition>
  valueTypeBetween(String lower, String upper, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(
          property: 3,
          lower: lower,
          upper: upper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SettingsCollection, SettingsCollection, QAfterFilterCondition>
  valueTypeStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        StartsWithCondition(
          property: 3,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SettingsCollection, SettingsCollection, QAfterFilterCondition>
  valueTypeEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EndsWithCondition(
          property: 3,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SettingsCollection, SettingsCollection, QAfterFilterCondition>
  valueTypeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        ContainsCondition(
          property: 3,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SettingsCollection, SettingsCollection, QAfterFilterCondition>
  valueTypeMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        MatchesCondition(
          property: 3,
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SettingsCollection, SettingsCollection, QAfterFilterCondition>
  valueTypeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const EqualCondition(property: 3, value: ''),
      );
    });
  }

  QueryBuilder<SettingsCollection, SettingsCollection, QAfterFilterCondition>
  valueTypeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const GreaterCondition(property: 3, value: ''),
      );
    });
  }
}

extension SettingsCollectionQueryObject
    on QueryBuilder<SettingsCollection, SettingsCollection, QFilterCondition> {}

extension SettingsCollectionQuerySortBy
    on QueryBuilder<SettingsCollection, SettingsCollection, QSortBy> {
  QueryBuilder<SettingsCollection, SettingsCollection, QAfterSortBy>
  sortById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(0);
    });
  }

  QueryBuilder<SettingsCollection, SettingsCollection, QAfterSortBy>
  sortByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(0, sort: Sort.desc);
    });
  }

  QueryBuilder<SettingsCollection, SettingsCollection, QAfterSortBy> sortByKey({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(1, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SettingsCollection, SettingsCollection, QAfterSortBy>
  sortByKeyDesc({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(1, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SettingsCollection, SettingsCollection, QAfterSortBy>
  sortByValueJson({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(2, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SettingsCollection, SettingsCollection, QAfterSortBy>
  sortByValueJsonDesc({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(2, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SettingsCollection, SettingsCollection, QAfterSortBy>
  sortByValueType({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(3, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SettingsCollection, SettingsCollection, QAfterSortBy>
  sortByValueTypeDesc({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(3, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }
}

extension SettingsCollectionQuerySortThenBy
    on QueryBuilder<SettingsCollection, SettingsCollection, QSortThenBy> {
  QueryBuilder<SettingsCollection, SettingsCollection, QAfterSortBy>
  thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(0);
    });
  }

  QueryBuilder<SettingsCollection, SettingsCollection, QAfterSortBy>
  thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(0, sort: Sort.desc);
    });
  }

  QueryBuilder<SettingsCollection, SettingsCollection, QAfterSortBy> thenByKey({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(1, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SettingsCollection, SettingsCollection, QAfterSortBy>
  thenByKeyDesc({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(1, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SettingsCollection, SettingsCollection, QAfterSortBy>
  thenByValueJson({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(2, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SettingsCollection, SettingsCollection, QAfterSortBy>
  thenByValueJsonDesc({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(2, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SettingsCollection, SettingsCollection, QAfterSortBy>
  thenByValueType({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(3, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SettingsCollection, SettingsCollection, QAfterSortBy>
  thenByValueTypeDesc({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(3, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }
}

extension SettingsCollectionQueryWhereDistinct
    on QueryBuilder<SettingsCollection, SettingsCollection, QDistinct> {
  QueryBuilder<SettingsCollection, SettingsCollection, QAfterDistinct>
  distinctByKey({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(1, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SettingsCollection, SettingsCollection, QAfterDistinct>
  distinctByValueJson({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(2, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SettingsCollection, SettingsCollection, QAfterDistinct>
  distinctByValueType({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(3, caseSensitive: caseSensitive);
    });
  }
}

extension SettingsCollectionQueryProperty1
    on QueryBuilder<SettingsCollection, SettingsCollection, QProperty> {
  QueryBuilder<SettingsCollection, int, QAfterProperty> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(0);
    });
  }

  QueryBuilder<SettingsCollection, String, QAfterProperty> keyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(1);
    });
  }

  QueryBuilder<SettingsCollection, String?, QAfterProperty>
  valueJsonProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(2);
    });
  }

  QueryBuilder<SettingsCollection, String, QAfterProperty> valueTypeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(3);
    });
  }
}

extension SettingsCollectionQueryProperty2<R>
    on QueryBuilder<SettingsCollection, R, QAfterProperty> {
  QueryBuilder<SettingsCollection, (R, int), QAfterProperty> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(0);
    });
  }

  QueryBuilder<SettingsCollection, (R, String), QAfterProperty> keyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(1);
    });
  }

  QueryBuilder<SettingsCollection, (R, String?), QAfterProperty>
  valueJsonProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(2);
    });
  }

  QueryBuilder<SettingsCollection, (R, String), QAfterProperty>
  valueTypeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(3);
    });
  }
}

extension SettingsCollectionQueryProperty3<R1, R2>
    on QueryBuilder<SettingsCollection, (R1, R2), QAfterProperty> {
  QueryBuilder<SettingsCollection, (R1, R2, int), QOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(0);
    });
  }

  QueryBuilder<SettingsCollection, (R1, R2, String), QOperations>
  keyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(1);
    });
  }

  QueryBuilder<SettingsCollection, (R1, R2, String?), QOperations>
  valueJsonProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(2);
    });
  }

  QueryBuilder<SettingsCollection, (R1, R2, String), QOperations>
  valueTypeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(3);
    });
  }
}
