// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settlement_collection.dart';

// **************************************************************************
// _IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, invalid_use_of_protected_member, lines_longer_than_80_chars, constant_identifier_names, avoid_js_rounded_ints, no_leading_underscores_for_local_identifiers, require_trailing_commas, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_in_if_null_operators, library_private_types_in_public_api, prefer_const_constructors
// ignore_for_file: type=lint

extension GetSettlementCollectionCollection on Isar {
  IsarCollection<int, SettlementCollection> get settlementCollections =>
      this.collection();
}

final SettlementCollectionSchema = IsarGeneratedSchema(
  schema: IsarSchema(
    name: 'SettlementCollection',
    idName: 'id',
    embedded: false,
    properties: [
      IsarPropertySchema(name: 'settlementId', type: IsarType.string),
      IsarPropertySchema(name: 'messId', type: IsarType.string),
      IsarPropertySchema(name: 'year', type: IsarType.long),
      IsarPropertySchema(name: 'month', type: IsarType.long),
      IsarPropertySchema(name: 'calculatedAt', type: IsarType.dateTime),
      IsarPropertySchema(name: 'itemsJson', type: IsarType.string),
      IsarPropertySchema(name: 'statusIndex', type: IsarType.long),
      IsarPropertySchema(name: 'settledAt', type: IsarType.dateTime),
    ],
    indexes: [
      IsarIndexSchema(
        name: 'settlementId',
        properties: ["settlementId"],
        unique: false,
        hash: false,
      ),
      IsarIndexSchema(
        name: 'year',
        properties: ["year"],
        unique: false,
        hash: false,
      ),
      IsarIndexSchema(
        name: 'month',
        properties: ["month"],
        unique: false,
        hash: false,
      ),
    ],
  ),
  converter: IsarObjectConverter<int, SettlementCollection>(
    serialize: serializeSettlementCollection,
    deserialize: deserializeSettlementCollection,
    deserializeProperty: deserializeSettlementCollectionProp,
  ),
  getEmbeddedSchemas: () => [],
);

@isarProtected
int serializeSettlementCollection(
  IsarWriter writer,
  SettlementCollection object,
) {
  IsarCore.writeString(writer, 1, object.settlementId);
  IsarCore.writeString(writer, 2, object.messId);
  IsarCore.writeLong(writer, 3, object.year);
  IsarCore.writeLong(writer, 4, object.month);
  IsarCore.writeLong(
    writer,
    5,
    object.calculatedAt.toUtc().microsecondsSinceEpoch,
  );
  IsarCore.writeString(writer, 6, object.itemsJson);
  IsarCore.writeLong(writer, 7, object.statusIndex);
  IsarCore.writeLong(
    writer,
    8,
    object.settledAt?.toUtc().microsecondsSinceEpoch ?? -9223372036854775808,
  );
  return object.id;
}

@isarProtected
SettlementCollection deserializeSettlementCollection(IsarReader reader) {
  final object = SettlementCollection();
  object.id = IsarCore.readId(reader);
  object.settlementId = IsarCore.readString(reader, 1) ?? '';
  object.messId = IsarCore.readString(reader, 2) ?? '';
  object.year = IsarCore.readLong(reader, 3);
  object.month = IsarCore.readLong(reader, 4);
  {
    final value = IsarCore.readLong(reader, 5);
    if (value == -9223372036854775808) {
      object.calculatedAt = DateTime.fromMillisecondsSinceEpoch(
        0,
        isUtc: true,
      ).toLocal();
    } else {
      object.calculatedAt = DateTime.fromMicrosecondsSinceEpoch(
        value,
        isUtc: true,
      ).toLocal();
    }
  }
  object.itemsJson = IsarCore.readString(reader, 6) ?? '';
  object.statusIndex = IsarCore.readLong(reader, 7);
  {
    final value = IsarCore.readLong(reader, 8);
    if (value == -9223372036854775808) {
      object.settledAt = null;
    } else {
      object.settledAt = DateTime.fromMicrosecondsSinceEpoch(
        value,
        isUtc: true,
      ).toLocal();
    }
  }
  return object;
}

@isarProtected
dynamic deserializeSettlementCollectionProp(IsarReader reader, int property) {
  switch (property) {
    case 0:
      return IsarCore.readId(reader);
    case 1:
      return IsarCore.readString(reader, 1) ?? '';
    case 2:
      return IsarCore.readString(reader, 2) ?? '';
    case 3:
      return IsarCore.readLong(reader, 3);
    case 4:
      return IsarCore.readLong(reader, 4);
    case 5:
      {
        final value = IsarCore.readLong(reader, 5);
        if (value == -9223372036854775808) {
          return DateTime.fromMillisecondsSinceEpoch(0, isUtc: true).toLocal();
        } else {
          return DateTime.fromMicrosecondsSinceEpoch(
            value,
            isUtc: true,
          ).toLocal();
        }
      }
    case 6:
      return IsarCore.readString(reader, 6) ?? '';
    case 7:
      return IsarCore.readLong(reader, 7);
    case 8:
      {
        final value = IsarCore.readLong(reader, 8);
        if (value == -9223372036854775808) {
          return null;
        } else {
          return DateTime.fromMicrosecondsSinceEpoch(
            value,
            isUtc: true,
          ).toLocal();
        }
      }
    default:
      throw ArgumentError('Unknown property: $property');
  }
}

sealed class _SettlementCollectionUpdate {
  bool call({
    required int id,
    String? settlementId,
    String? messId,
    int? year,
    int? month,
    DateTime? calculatedAt,
    String? itemsJson,
    int? statusIndex,
    DateTime? settledAt,
  });
}

class _SettlementCollectionUpdateImpl implements _SettlementCollectionUpdate {
  const _SettlementCollectionUpdateImpl(this.collection);

  final IsarCollection<int, SettlementCollection> collection;

  @override
  bool call({
    required int id,
    Object? settlementId = ignore,
    Object? messId = ignore,
    Object? year = ignore,
    Object? month = ignore,
    Object? calculatedAt = ignore,
    Object? itemsJson = ignore,
    Object? statusIndex = ignore,
    Object? settledAt = ignore,
  }) {
    return collection.updateProperties(
          [id],
          {
            if (settlementId != ignore) 1: settlementId as String?,
            if (messId != ignore) 2: messId as String?,
            if (year != ignore) 3: year as int?,
            if (month != ignore) 4: month as int?,
            if (calculatedAt != ignore) 5: calculatedAt as DateTime?,
            if (itemsJson != ignore) 6: itemsJson as String?,
            if (statusIndex != ignore) 7: statusIndex as int?,
            if (settledAt != ignore) 8: settledAt as DateTime?,
          },
        ) >
        0;
  }
}

sealed class _SettlementCollectionUpdateAll {
  int call({
    required List<int> id,
    String? settlementId,
    String? messId,
    int? year,
    int? month,
    DateTime? calculatedAt,
    String? itemsJson,
    int? statusIndex,
    DateTime? settledAt,
  });
}

class _SettlementCollectionUpdateAllImpl
    implements _SettlementCollectionUpdateAll {
  const _SettlementCollectionUpdateAllImpl(this.collection);

  final IsarCollection<int, SettlementCollection> collection;

  @override
  int call({
    required List<int> id,
    Object? settlementId = ignore,
    Object? messId = ignore,
    Object? year = ignore,
    Object? month = ignore,
    Object? calculatedAt = ignore,
    Object? itemsJson = ignore,
    Object? statusIndex = ignore,
    Object? settledAt = ignore,
  }) {
    return collection.updateProperties(id, {
      if (settlementId != ignore) 1: settlementId as String?,
      if (messId != ignore) 2: messId as String?,
      if (year != ignore) 3: year as int?,
      if (month != ignore) 4: month as int?,
      if (calculatedAt != ignore) 5: calculatedAt as DateTime?,
      if (itemsJson != ignore) 6: itemsJson as String?,
      if (statusIndex != ignore) 7: statusIndex as int?,
      if (settledAt != ignore) 8: settledAt as DateTime?,
    });
  }
}

extension SettlementCollectionUpdate
    on IsarCollection<int, SettlementCollection> {
  _SettlementCollectionUpdate get update =>
      _SettlementCollectionUpdateImpl(this);

  _SettlementCollectionUpdateAll get updateAll =>
      _SettlementCollectionUpdateAllImpl(this);
}

sealed class _SettlementCollectionQueryUpdate {
  int call({
    String? settlementId,
    String? messId,
    int? year,
    int? month,
    DateTime? calculatedAt,
    String? itemsJson,
    int? statusIndex,
    DateTime? settledAt,
  });
}

class _SettlementCollectionQueryUpdateImpl
    implements _SettlementCollectionQueryUpdate {
  const _SettlementCollectionQueryUpdateImpl(this.query, {this.limit});

  final IsarQuery<SettlementCollection> query;
  final int? limit;

  @override
  int call({
    Object? settlementId = ignore,
    Object? messId = ignore,
    Object? year = ignore,
    Object? month = ignore,
    Object? calculatedAt = ignore,
    Object? itemsJson = ignore,
    Object? statusIndex = ignore,
    Object? settledAt = ignore,
  }) {
    return query.updateProperties(limit: limit, {
      if (settlementId != ignore) 1: settlementId as String?,
      if (messId != ignore) 2: messId as String?,
      if (year != ignore) 3: year as int?,
      if (month != ignore) 4: month as int?,
      if (calculatedAt != ignore) 5: calculatedAt as DateTime?,
      if (itemsJson != ignore) 6: itemsJson as String?,
      if (statusIndex != ignore) 7: statusIndex as int?,
      if (settledAt != ignore) 8: settledAt as DateTime?,
    });
  }
}

extension SettlementCollectionQueryUpdate on IsarQuery<SettlementCollection> {
  _SettlementCollectionQueryUpdate get updateFirst =>
      _SettlementCollectionQueryUpdateImpl(this, limit: 1);

  _SettlementCollectionQueryUpdate get updateAll =>
      _SettlementCollectionQueryUpdateImpl(this);
}

class _SettlementCollectionQueryBuilderUpdateImpl
    implements _SettlementCollectionQueryUpdate {
  const _SettlementCollectionQueryBuilderUpdateImpl(this.query, {this.limit});

  final QueryBuilder<SettlementCollection, SettlementCollection, QOperations>
  query;
  final int? limit;

  @override
  int call({
    Object? settlementId = ignore,
    Object? messId = ignore,
    Object? year = ignore,
    Object? month = ignore,
    Object? calculatedAt = ignore,
    Object? itemsJson = ignore,
    Object? statusIndex = ignore,
    Object? settledAt = ignore,
  }) {
    final q = query.build();
    try {
      return q.updateProperties(limit: limit, {
        if (settlementId != ignore) 1: settlementId as String?,
        if (messId != ignore) 2: messId as String?,
        if (year != ignore) 3: year as int?,
        if (month != ignore) 4: month as int?,
        if (calculatedAt != ignore) 5: calculatedAt as DateTime?,
        if (itemsJson != ignore) 6: itemsJson as String?,
        if (statusIndex != ignore) 7: statusIndex as int?,
        if (settledAt != ignore) 8: settledAt as DateTime?,
      });
    } finally {
      q.close();
    }
  }
}

extension SettlementCollectionQueryBuilderUpdate
    on QueryBuilder<SettlementCollection, SettlementCollection, QOperations> {
  _SettlementCollectionQueryUpdate get updateFirst =>
      _SettlementCollectionQueryBuilderUpdateImpl(this, limit: 1);

  _SettlementCollectionQueryUpdate get updateAll =>
      _SettlementCollectionQueryBuilderUpdateImpl(this);
}

extension SettlementCollectionQueryFilter
    on
        QueryBuilder<
          SettlementCollection,
          SettlementCollection,
          QFilterCondition
        > {
  QueryBuilder<
    SettlementCollection,
    SettlementCollection,
    QAfterFilterCondition
  >
  idEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(property: 0, value: value),
      );
    });
  }

  QueryBuilder<
    SettlementCollection,
    SettlementCollection,
    QAfterFilterCondition
  >
  idGreaterThan(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(property: 0, value: value),
      );
    });
  }

  QueryBuilder<
    SettlementCollection,
    SettlementCollection,
    QAfterFilterCondition
  >
  idGreaterThanOrEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(property: 0, value: value),
      );
    });
  }

  QueryBuilder<
    SettlementCollection,
    SettlementCollection,
    QAfterFilterCondition
  >
  idLessThan(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(LessCondition(property: 0, value: value));
    });
  }

  QueryBuilder<
    SettlementCollection,
    SettlementCollection,
    QAfterFilterCondition
  >
  idLessThanOrEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(property: 0, value: value),
      );
    });
  }

  QueryBuilder<
    SettlementCollection,
    SettlementCollection,
    QAfterFilterCondition
  >
  idBetween(int lower, int upper) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(property: 0, lower: lower, upper: upper),
      );
    });
  }

  QueryBuilder<
    SettlementCollection,
    SettlementCollection,
    QAfterFilterCondition
  >
  settlementIdEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(property: 1, value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<
    SettlementCollection,
    SettlementCollection,
    QAfterFilterCondition
  >
  settlementIdGreaterThan(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<
    SettlementCollection,
    SettlementCollection,
    QAfterFilterCondition
  >
  settlementIdGreaterThanOrEqualTo(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<
    SettlementCollection,
    SettlementCollection,
    QAfterFilterCondition
  >
  settlementIdLessThan(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(property: 1, value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<
    SettlementCollection,
    SettlementCollection,
    QAfterFilterCondition
  >
  settlementIdLessThanOrEqualTo(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<
    SettlementCollection,
    SettlementCollection,
    QAfterFilterCondition
  >
  settlementIdBetween(String lower, String upper, {bool caseSensitive = true}) {
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

  QueryBuilder<
    SettlementCollection,
    SettlementCollection,
    QAfterFilterCondition
  >
  settlementIdStartsWith(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<
    SettlementCollection,
    SettlementCollection,
    QAfterFilterCondition
  >
  settlementIdEndsWith(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<
    SettlementCollection,
    SettlementCollection,
    QAfterFilterCondition
  >
  settlementIdContains(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<
    SettlementCollection,
    SettlementCollection,
    QAfterFilterCondition
  >
  settlementIdMatches(String pattern, {bool caseSensitive = true}) {
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

  QueryBuilder<
    SettlementCollection,
    SettlementCollection,
    QAfterFilterCondition
  >
  settlementIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const EqualCondition(property: 1, value: ''),
      );
    });
  }

  QueryBuilder<
    SettlementCollection,
    SettlementCollection,
    QAfterFilterCondition
  >
  settlementIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const GreaterCondition(property: 1, value: ''),
      );
    });
  }

  QueryBuilder<
    SettlementCollection,
    SettlementCollection,
    QAfterFilterCondition
  >
  messIdEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(property: 2, value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<
    SettlementCollection,
    SettlementCollection,
    QAfterFilterCondition
  >
  messIdGreaterThan(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<
    SettlementCollection,
    SettlementCollection,
    QAfterFilterCondition
  >
  messIdGreaterThanOrEqualTo(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<
    SettlementCollection,
    SettlementCollection,
    QAfterFilterCondition
  >
  messIdLessThan(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(property: 2, value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<
    SettlementCollection,
    SettlementCollection,
    QAfterFilterCondition
  >
  messIdLessThanOrEqualTo(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<
    SettlementCollection,
    SettlementCollection,
    QAfterFilterCondition
  >
  messIdBetween(String lower, String upper, {bool caseSensitive = true}) {
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

  QueryBuilder<
    SettlementCollection,
    SettlementCollection,
    QAfterFilterCondition
  >
  messIdStartsWith(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<
    SettlementCollection,
    SettlementCollection,
    QAfterFilterCondition
  >
  messIdEndsWith(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<
    SettlementCollection,
    SettlementCollection,
    QAfterFilterCondition
  >
  messIdContains(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<
    SettlementCollection,
    SettlementCollection,
    QAfterFilterCondition
  >
  messIdMatches(String pattern, {bool caseSensitive = true}) {
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

  QueryBuilder<
    SettlementCollection,
    SettlementCollection,
    QAfterFilterCondition
  >
  messIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const EqualCondition(property: 2, value: ''),
      );
    });
  }

  QueryBuilder<
    SettlementCollection,
    SettlementCollection,
    QAfterFilterCondition
  >
  messIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const GreaterCondition(property: 2, value: ''),
      );
    });
  }

  QueryBuilder<
    SettlementCollection,
    SettlementCollection,
    QAfterFilterCondition
  >
  yearEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(property: 3, value: value),
      );
    });
  }

  QueryBuilder<
    SettlementCollection,
    SettlementCollection,
    QAfterFilterCondition
  >
  yearGreaterThan(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(property: 3, value: value),
      );
    });
  }

  QueryBuilder<
    SettlementCollection,
    SettlementCollection,
    QAfterFilterCondition
  >
  yearGreaterThanOrEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(property: 3, value: value),
      );
    });
  }

  QueryBuilder<
    SettlementCollection,
    SettlementCollection,
    QAfterFilterCondition
  >
  yearLessThan(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(LessCondition(property: 3, value: value));
    });
  }

  QueryBuilder<
    SettlementCollection,
    SettlementCollection,
    QAfterFilterCondition
  >
  yearLessThanOrEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(property: 3, value: value),
      );
    });
  }

  QueryBuilder<
    SettlementCollection,
    SettlementCollection,
    QAfterFilterCondition
  >
  yearBetween(int lower, int upper) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(property: 3, lower: lower, upper: upper),
      );
    });
  }

  QueryBuilder<
    SettlementCollection,
    SettlementCollection,
    QAfterFilterCondition
  >
  monthEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(property: 4, value: value),
      );
    });
  }

  QueryBuilder<
    SettlementCollection,
    SettlementCollection,
    QAfterFilterCondition
  >
  monthGreaterThan(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(property: 4, value: value),
      );
    });
  }

  QueryBuilder<
    SettlementCollection,
    SettlementCollection,
    QAfterFilterCondition
  >
  monthGreaterThanOrEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(property: 4, value: value),
      );
    });
  }

  QueryBuilder<
    SettlementCollection,
    SettlementCollection,
    QAfterFilterCondition
  >
  monthLessThan(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(LessCondition(property: 4, value: value));
    });
  }

  QueryBuilder<
    SettlementCollection,
    SettlementCollection,
    QAfterFilterCondition
  >
  monthLessThanOrEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(property: 4, value: value),
      );
    });
  }

  QueryBuilder<
    SettlementCollection,
    SettlementCollection,
    QAfterFilterCondition
  >
  monthBetween(int lower, int upper) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(property: 4, lower: lower, upper: upper),
      );
    });
  }

  QueryBuilder<
    SettlementCollection,
    SettlementCollection,
    QAfterFilterCondition
  >
  calculatedAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(property: 5, value: value),
      );
    });
  }

  QueryBuilder<
    SettlementCollection,
    SettlementCollection,
    QAfterFilterCondition
  >
  calculatedAtGreaterThan(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(property: 5, value: value),
      );
    });
  }

  QueryBuilder<
    SettlementCollection,
    SettlementCollection,
    QAfterFilterCondition
  >
  calculatedAtGreaterThanOrEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(property: 5, value: value),
      );
    });
  }

  QueryBuilder<
    SettlementCollection,
    SettlementCollection,
    QAfterFilterCondition
  >
  calculatedAtLessThan(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(LessCondition(property: 5, value: value));
    });
  }

  QueryBuilder<
    SettlementCollection,
    SettlementCollection,
    QAfterFilterCondition
  >
  calculatedAtLessThanOrEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(property: 5, value: value),
      );
    });
  }

  QueryBuilder<
    SettlementCollection,
    SettlementCollection,
    QAfterFilterCondition
  >
  calculatedAtBetween(DateTime lower, DateTime upper) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(property: 5, lower: lower, upper: upper),
      );
    });
  }

  QueryBuilder<
    SettlementCollection,
    SettlementCollection,
    QAfterFilterCondition
  >
  itemsJsonEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(property: 6, value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<
    SettlementCollection,
    SettlementCollection,
    QAfterFilterCondition
  >
  itemsJsonGreaterThan(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(
          property: 6,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    SettlementCollection,
    SettlementCollection,
    QAfterFilterCondition
  >
  itemsJsonGreaterThanOrEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(
          property: 6,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    SettlementCollection,
    SettlementCollection,
    QAfterFilterCondition
  >
  itemsJsonLessThan(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(property: 6, value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<
    SettlementCollection,
    SettlementCollection,
    QAfterFilterCondition
  >
  itemsJsonLessThanOrEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(
          property: 6,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    SettlementCollection,
    SettlementCollection,
    QAfterFilterCondition
  >
  itemsJsonBetween(String lower, String upper, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(
          property: 6,
          lower: lower,
          upper: upper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    SettlementCollection,
    SettlementCollection,
    QAfterFilterCondition
  >
  itemsJsonStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        StartsWithCondition(
          property: 6,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    SettlementCollection,
    SettlementCollection,
    QAfterFilterCondition
  >
  itemsJsonEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EndsWithCondition(
          property: 6,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    SettlementCollection,
    SettlementCollection,
    QAfterFilterCondition
  >
  itemsJsonContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        ContainsCondition(
          property: 6,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    SettlementCollection,
    SettlementCollection,
    QAfterFilterCondition
  >
  itemsJsonMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        MatchesCondition(
          property: 6,
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    SettlementCollection,
    SettlementCollection,
    QAfterFilterCondition
  >
  itemsJsonIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const EqualCondition(property: 6, value: ''),
      );
    });
  }

  QueryBuilder<
    SettlementCollection,
    SettlementCollection,
    QAfterFilterCondition
  >
  itemsJsonIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const GreaterCondition(property: 6, value: ''),
      );
    });
  }

  QueryBuilder<
    SettlementCollection,
    SettlementCollection,
    QAfterFilterCondition
  >
  statusIndexEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(property: 7, value: value),
      );
    });
  }

  QueryBuilder<
    SettlementCollection,
    SettlementCollection,
    QAfterFilterCondition
  >
  statusIndexGreaterThan(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(property: 7, value: value),
      );
    });
  }

  QueryBuilder<
    SettlementCollection,
    SettlementCollection,
    QAfterFilterCondition
  >
  statusIndexGreaterThanOrEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(property: 7, value: value),
      );
    });
  }

  QueryBuilder<
    SettlementCollection,
    SettlementCollection,
    QAfterFilterCondition
  >
  statusIndexLessThan(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(LessCondition(property: 7, value: value));
    });
  }

  QueryBuilder<
    SettlementCollection,
    SettlementCollection,
    QAfterFilterCondition
  >
  statusIndexLessThanOrEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(property: 7, value: value),
      );
    });
  }

  QueryBuilder<
    SettlementCollection,
    SettlementCollection,
    QAfterFilterCondition
  >
  statusIndexBetween(int lower, int upper) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(property: 7, lower: lower, upper: upper),
      );
    });
  }

  QueryBuilder<
    SettlementCollection,
    SettlementCollection,
    QAfterFilterCondition
  >
  settledAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const IsNullCondition(property: 8));
    });
  }

  QueryBuilder<
    SettlementCollection,
    SettlementCollection,
    QAfterFilterCondition
  >
  settledAtIsNotNull() {
    return QueryBuilder.apply(not(), (query) {
      return query.addFilterCondition(const IsNullCondition(property: 8));
    });
  }

  QueryBuilder<
    SettlementCollection,
    SettlementCollection,
    QAfterFilterCondition
  >
  settledAtEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(property: 8, value: value),
      );
    });
  }

  QueryBuilder<
    SettlementCollection,
    SettlementCollection,
    QAfterFilterCondition
  >
  settledAtGreaterThan(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(property: 8, value: value),
      );
    });
  }

  QueryBuilder<
    SettlementCollection,
    SettlementCollection,
    QAfterFilterCondition
  >
  settledAtGreaterThanOrEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(property: 8, value: value),
      );
    });
  }

  QueryBuilder<
    SettlementCollection,
    SettlementCollection,
    QAfterFilterCondition
  >
  settledAtLessThan(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(LessCondition(property: 8, value: value));
    });
  }

  QueryBuilder<
    SettlementCollection,
    SettlementCollection,
    QAfterFilterCondition
  >
  settledAtLessThanOrEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(property: 8, value: value),
      );
    });
  }

  QueryBuilder<
    SettlementCollection,
    SettlementCollection,
    QAfterFilterCondition
  >
  settledAtBetween(DateTime? lower, DateTime? upper) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(property: 8, lower: lower, upper: upper),
      );
    });
  }
}

extension SettlementCollectionQueryObject
    on
        QueryBuilder<
          SettlementCollection,
          SettlementCollection,
          QFilterCondition
        > {}

extension SettlementCollectionQuerySortBy
    on QueryBuilder<SettlementCollection, SettlementCollection, QSortBy> {
  QueryBuilder<SettlementCollection, SettlementCollection, QAfterSortBy>
  sortById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(0);
    });
  }

  QueryBuilder<SettlementCollection, SettlementCollection, QAfterSortBy>
  sortByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(0, sort: Sort.desc);
    });
  }

  QueryBuilder<SettlementCollection, SettlementCollection, QAfterSortBy>
  sortBySettlementId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(1, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SettlementCollection, SettlementCollection, QAfterSortBy>
  sortBySettlementIdDesc({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(1, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SettlementCollection, SettlementCollection, QAfterSortBy>
  sortByMessId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(2, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SettlementCollection, SettlementCollection, QAfterSortBy>
  sortByMessIdDesc({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(2, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SettlementCollection, SettlementCollection, QAfterSortBy>
  sortByYear() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(3);
    });
  }

  QueryBuilder<SettlementCollection, SettlementCollection, QAfterSortBy>
  sortByYearDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(3, sort: Sort.desc);
    });
  }

  QueryBuilder<SettlementCollection, SettlementCollection, QAfterSortBy>
  sortByMonth() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(4);
    });
  }

  QueryBuilder<SettlementCollection, SettlementCollection, QAfterSortBy>
  sortByMonthDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(4, sort: Sort.desc);
    });
  }

  QueryBuilder<SettlementCollection, SettlementCollection, QAfterSortBy>
  sortByCalculatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(5);
    });
  }

  QueryBuilder<SettlementCollection, SettlementCollection, QAfterSortBy>
  sortByCalculatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(5, sort: Sort.desc);
    });
  }

  QueryBuilder<SettlementCollection, SettlementCollection, QAfterSortBy>
  sortByItemsJson({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(6, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SettlementCollection, SettlementCollection, QAfterSortBy>
  sortByItemsJsonDesc({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(6, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SettlementCollection, SettlementCollection, QAfterSortBy>
  sortByStatusIndex() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(7);
    });
  }

  QueryBuilder<SettlementCollection, SettlementCollection, QAfterSortBy>
  sortByStatusIndexDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(7, sort: Sort.desc);
    });
  }

  QueryBuilder<SettlementCollection, SettlementCollection, QAfterSortBy>
  sortBySettledAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(8);
    });
  }

  QueryBuilder<SettlementCollection, SettlementCollection, QAfterSortBy>
  sortBySettledAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(8, sort: Sort.desc);
    });
  }
}

extension SettlementCollectionQuerySortThenBy
    on QueryBuilder<SettlementCollection, SettlementCollection, QSortThenBy> {
  QueryBuilder<SettlementCollection, SettlementCollection, QAfterSortBy>
  thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(0);
    });
  }

  QueryBuilder<SettlementCollection, SettlementCollection, QAfterSortBy>
  thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(0, sort: Sort.desc);
    });
  }

  QueryBuilder<SettlementCollection, SettlementCollection, QAfterSortBy>
  thenBySettlementId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(1, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SettlementCollection, SettlementCollection, QAfterSortBy>
  thenBySettlementIdDesc({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(1, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SettlementCollection, SettlementCollection, QAfterSortBy>
  thenByMessId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(2, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SettlementCollection, SettlementCollection, QAfterSortBy>
  thenByMessIdDesc({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(2, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SettlementCollection, SettlementCollection, QAfterSortBy>
  thenByYear() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(3);
    });
  }

  QueryBuilder<SettlementCollection, SettlementCollection, QAfterSortBy>
  thenByYearDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(3, sort: Sort.desc);
    });
  }

  QueryBuilder<SettlementCollection, SettlementCollection, QAfterSortBy>
  thenByMonth() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(4);
    });
  }

  QueryBuilder<SettlementCollection, SettlementCollection, QAfterSortBy>
  thenByMonthDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(4, sort: Sort.desc);
    });
  }

  QueryBuilder<SettlementCollection, SettlementCollection, QAfterSortBy>
  thenByCalculatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(5);
    });
  }

  QueryBuilder<SettlementCollection, SettlementCollection, QAfterSortBy>
  thenByCalculatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(5, sort: Sort.desc);
    });
  }

  QueryBuilder<SettlementCollection, SettlementCollection, QAfterSortBy>
  thenByItemsJson({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(6, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SettlementCollection, SettlementCollection, QAfterSortBy>
  thenByItemsJsonDesc({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(6, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SettlementCollection, SettlementCollection, QAfterSortBy>
  thenByStatusIndex() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(7);
    });
  }

  QueryBuilder<SettlementCollection, SettlementCollection, QAfterSortBy>
  thenByStatusIndexDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(7, sort: Sort.desc);
    });
  }

  QueryBuilder<SettlementCollection, SettlementCollection, QAfterSortBy>
  thenBySettledAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(8);
    });
  }

  QueryBuilder<SettlementCollection, SettlementCollection, QAfterSortBy>
  thenBySettledAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(8, sort: Sort.desc);
    });
  }
}

extension SettlementCollectionQueryWhereDistinct
    on QueryBuilder<SettlementCollection, SettlementCollection, QDistinct> {
  QueryBuilder<SettlementCollection, SettlementCollection, QAfterDistinct>
  distinctBySettlementId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(1, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SettlementCollection, SettlementCollection, QAfterDistinct>
  distinctByMessId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(2, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SettlementCollection, SettlementCollection, QAfterDistinct>
  distinctByYear() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(3);
    });
  }

  QueryBuilder<SettlementCollection, SettlementCollection, QAfterDistinct>
  distinctByMonth() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(4);
    });
  }

  QueryBuilder<SettlementCollection, SettlementCollection, QAfterDistinct>
  distinctByCalculatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(5);
    });
  }

  QueryBuilder<SettlementCollection, SettlementCollection, QAfterDistinct>
  distinctByItemsJson({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(6, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SettlementCollection, SettlementCollection, QAfterDistinct>
  distinctByStatusIndex() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(7);
    });
  }

  QueryBuilder<SettlementCollection, SettlementCollection, QAfterDistinct>
  distinctBySettledAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(8);
    });
  }
}

extension SettlementCollectionQueryProperty1
    on QueryBuilder<SettlementCollection, SettlementCollection, QProperty> {
  QueryBuilder<SettlementCollection, int, QAfterProperty> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(0);
    });
  }

  QueryBuilder<SettlementCollection, String, QAfterProperty>
  settlementIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(1);
    });
  }

  QueryBuilder<SettlementCollection, String, QAfterProperty> messIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(2);
    });
  }

  QueryBuilder<SettlementCollection, int, QAfterProperty> yearProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(3);
    });
  }

  QueryBuilder<SettlementCollection, int, QAfterProperty> monthProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(4);
    });
  }

  QueryBuilder<SettlementCollection, DateTime, QAfterProperty>
  calculatedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(5);
    });
  }

  QueryBuilder<SettlementCollection, String, QAfterProperty>
  itemsJsonProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(6);
    });
  }

  QueryBuilder<SettlementCollection, int, QAfterProperty>
  statusIndexProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(7);
    });
  }

  QueryBuilder<SettlementCollection, DateTime?, QAfterProperty>
  settledAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(8);
    });
  }
}

extension SettlementCollectionQueryProperty2<R>
    on QueryBuilder<SettlementCollection, R, QAfterProperty> {
  QueryBuilder<SettlementCollection, (R, int), QAfterProperty> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(0);
    });
  }

  QueryBuilder<SettlementCollection, (R, String), QAfterProperty>
  settlementIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(1);
    });
  }

  QueryBuilder<SettlementCollection, (R, String), QAfterProperty>
  messIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(2);
    });
  }

  QueryBuilder<SettlementCollection, (R, int), QAfterProperty> yearProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(3);
    });
  }

  QueryBuilder<SettlementCollection, (R, int), QAfterProperty> monthProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(4);
    });
  }

  QueryBuilder<SettlementCollection, (R, DateTime), QAfterProperty>
  calculatedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(5);
    });
  }

  QueryBuilder<SettlementCollection, (R, String), QAfterProperty>
  itemsJsonProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(6);
    });
  }

  QueryBuilder<SettlementCollection, (R, int), QAfterProperty>
  statusIndexProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(7);
    });
  }

  QueryBuilder<SettlementCollection, (R, DateTime?), QAfterProperty>
  settledAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(8);
    });
  }
}

extension SettlementCollectionQueryProperty3<R1, R2>
    on QueryBuilder<SettlementCollection, (R1, R2), QAfterProperty> {
  QueryBuilder<SettlementCollection, (R1, R2, int), QOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(0);
    });
  }

  QueryBuilder<SettlementCollection, (R1, R2, String), QOperations>
  settlementIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(1);
    });
  }

  QueryBuilder<SettlementCollection, (R1, R2, String), QOperations>
  messIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(2);
    });
  }

  QueryBuilder<SettlementCollection, (R1, R2, int), QOperations>
  yearProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(3);
    });
  }

  QueryBuilder<SettlementCollection, (R1, R2, int), QOperations>
  monthProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(4);
    });
  }

  QueryBuilder<SettlementCollection, (R1, R2, DateTime), QOperations>
  calculatedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(5);
    });
  }

  QueryBuilder<SettlementCollection, (R1, R2, String), QOperations>
  itemsJsonProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(6);
    });
  }

  QueryBuilder<SettlementCollection, (R1, R2, int), QOperations>
  statusIndexProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(7);
    });
  }

  QueryBuilder<SettlementCollection, (R1, R2, DateTime?), QOperations>
  settledAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(8);
    });
  }
}
