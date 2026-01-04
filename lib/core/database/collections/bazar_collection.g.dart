// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bazar_collection.dart';

// **************************************************************************
// _IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, invalid_use_of_protected_member, lines_longer_than_80_chars, constant_identifier_names, avoid_js_rounded_ints, no_leading_underscores_for_local_identifiers, require_trailing_commas, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_in_if_null_operators, library_private_types_in_public_api, prefer_const_constructors
// ignore_for_file: type=lint

extension GetBazarEntryCollectionCollection on Isar {
  IsarCollection<int, BazarEntryCollection> get bazarEntryCollections =>
      this.collection();
}

final BazarEntryCollectionSchema = IsarGeneratedSchema(
  schema: IsarSchema(
    name: 'BazarEntryCollection',
    idName: 'id',
    embedded: false,
    properties: [
      IsarPropertySchema(name: 'entryId', type: IsarType.string),
      IsarPropertySchema(name: 'memberId', type: IsarType.string),
      IsarPropertySchema(name: 'date', type: IsarType.dateTime),
      IsarPropertySchema(name: 'amount', type: IsarType.double),
      IsarPropertySchema(name: 'description', type: IsarType.string),
      IsarPropertySchema(name: 'itemsJson', type: IsarType.string),
      IsarPropertySchema(name: 'isItemized', type: IsarType.bool),
      IsarPropertySchema(name: 'photoUrlsJson', type: IsarType.string),
      IsarPropertySchema(name: 'receiptUrlsJson', type: IsarType.string),
      IsarPropertySchema(name: 'createdAt', type: IsarType.dateTime),
    ],
    indexes: [
      IsarIndexSchema(
        name: 'entryId',
        properties: ["entryId"],
        unique: false,
        hash: false,
      ),
      IsarIndexSchema(
        name: 'memberId',
        properties: ["memberId"],
        unique: false,
        hash: false,
      ),
      IsarIndexSchema(
        name: 'date',
        properties: ["date"],
        unique: false,
        hash: false,
      ),
    ],
  ),
  converter: IsarObjectConverter<int, BazarEntryCollection>(
    serialize: serializeBazarEntryCollection,
    deserialize: deserializeBazarEntryCollection,
    deserializeProperty: deserializeBazarEntryCollectionProp,
  ),
  getEmbeddedSchemas: () => [],
);

@isarProtected
int serializeBazarEntryCollection(
  IsarWriter writer,
  BazarEntryCollection object,
) {
  IsarCore.writeString(writer, 1, object.entryId);
  IsarCore.writeString(writer, 2, object.memberId);
  IsarCore.writeLong(writer, 3, object.date.toUtc().microsecondsSinceEpoch);
  IsarCore.writeDouble(writer, 4, object.amount);
  {
    final value = object.description;
    if (value == null) {
      IsarCore.writeNull(writer, 5);
    } else {
      IsarCore.writeString(writer, 5, value);
    }
  }
  {
    final value = object.itemsJson;
    if (value == null) {
      IsarCore.writeNull(writer, 6);
    } else {
      IsarCore.writeString(writer, 6, value);
    }
  }
  IsarCore.writeBool(writer, 7, value: object.isItemized);
  {
    final value = object.photoUrlsJson;
    if (value == null) {
      IsarCore.writeNull(writer, 8);
    } else {
      IsarCore.writeString(writer, 8, value);
    }
  }
  {
    final value = object.receiptUrlsJson;
    if (value == null) {
      IsarCore.writeNull(writer, 9);
    } else {
      IsarCore.writeString(writer, 9, value);
    }
  }
  IsarCore.writeLong(
    writer,
    10,
    object.createdAt?.toUtc().microsecondsSinceEpoch ?? -9223372036854775808,
  );
  return object.id;
}

@isarProtected
BazarEntryCollection deserializeBazarEntryCollection(IsarReader reader) {
  final object = BazarEntryCollection();
  object.id = IsarCore.readId(reader);
  object.entryId = IsarCore.readString(reader, 1) ?? '';
  object.memberId = IsarCore.readString(reader, 2) ?? '';
  {
    final value = IsarCore.readLong(reader, 3);
    if (value == -9223372036854775808) {
      object.date = DateTime.fromMillisecondsSinceEpoch(
        0,
        isUtc: true,
      ).toLocal();
    } else {
      object.date = DateTime.fromMicrosecondsSinceEpoch(
        value,
        isUtc: true,
      ).toLocal();
    }
  }
  object.amount = IsarCore.readDouble(reader, 4);
  object.description = IsarCore.readString(reader, 5);
  object.itemsJson = IsarCore.readString(reader, 6);
  object.isItemized = IsarCore.readBool(reader, 7);
  object.photoUrlsJson = IsarCore.readString(reader, 8);
  object.receiptUrlsJson = IsarCore.readString(reader, 9);
  {
    final value = IsarCore.readLong(reader, 10);
    if (value == -9223372036854775808) {
      object.createdAt = null;
    } else {
      object.createdAt = DateTime.fromMicrosecondsSinceEpoch(
        value,
        isUtc: true,
      ).toLocal();
    }
  }
  return object;
}

@isarProtected
dynamic deserializeBazarEntryCollectionProp(IsarReader reader, int property) {
  switch (property) {
    case 0:
      return IsarCore.readId(reader);
    case 1:
      return IsarCore.readString(reader, 1) ?? '';
    case 2:
      return IsarCore.readString(reader, 2) ?? '';
    case 3:
      {
        final value = IsarCore.readLong(reader, 3);
        if (value == -9223372036854775808) {
          return DateTime.fromMillisecondsSinceEpoch(0, isUtc: true).toLocal();
        } else {
          return DateTime.fromMicrosecondsSinceEpoch(
            value,
            isUtc: true,
          ).toLocal();
        }
      }
    case 4:
      return IsarCore.readDouble(reader, 4);
    case 5:
      return IsarCore.readString(reader, 5);
    case 6:
      return IsarCore.readString(reader, 6);
    case 7:
      return IsarCore.readBool(reader, 7);
    case 8:
      return IsarCore.readString(reader, 8);
    case 9:
      return IsarCore.readString(reader, 9);
    case 10:
      {
        final value = IsarCore.readLong(reader, 10);
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

sealed class _BazarEntryCollectionUpdate {
  bool call({
    required int id,
    String? entryId,
    String? memberId,
    DateTime? date,
    double? amount,
    String? description,
    String? itemsJson,
    bool? isItemized,
    String? photoUrlsJson,
    String? receiptUrlsJson,
    DateTime? createdAt,
  });
}

class _BazarEntryCollectionUpdateImpl implements _BazarEntryCollectionUpdate {
  const _BazarEntryCollectionUpdateImpl(this.collection);

  final IsarCollection<int, BazarEntryCollection> collection;

  @override
  bool call({
    required int id,
    Object? entryId = ignore,
    Object? memberId = ignore,
    Object? date = ignore,
    Object? amount = ignore,
    Object? description = ignore,
    Object? itemsJson = ignore,
    Object? isItemized = ignore,
    Object? photoUrlsJson = ignore,
    Object? receiptUrlsJson = ignore,
    Object? createdAt = ignore,
  }) {
    return collection.updateProperties(
          [id],
          {
            if (entryId != ignore) 1: entryId as String?,
            if (memberId != ignore) 2: memberId as String?,
            if (date != ignore) 3: date as DateTime?,
            if (amount != ignore) 4: amount as double?,
            if (description != ignore) 5: description as String?,
            if (itemsJson != ignore) 6: itemsJson as String?,
            if (isItemized != ignore) 7: isItemized as bool?,
            if (photoUrlsJson != ignore) 8: photoUrlsJson as String?,
            if (receiptUrlsJson != ignore) 9: receiptUrlsJson as String?,
            if (createdAt != ignore) 10: createdAt as DateTime?,
          },
        ) >
        0;
  }
}

sealed class _BazarEntryCollectionUpdateAll {
  int call({
    required List<int> id,
    String? entryId,
    String? memberId,
    DateTime? date,
    double? amount,
    String? description,
    String? itemsJson,
    bool? isItemized,
    String? photoUrlsJson,
    String? receiptUrlsJson,
    DateTime? createdAt,
  });
}

class _BazarEntryCollectionUpdateAllImpl
    implements _BazarEntryCollectionUpdateAll {
  const _BazarEntryCollectionUpdateAllImpl(this.collection);

  final IsarCollection<int, BazarEntryCollection> collection;

  @override
  int call({
    required List<int> id,
    Object? entryId = ignore,
    Object? memberId = ignore,
    Object? date = ignore,
    Object? amount = ignore,
    Object? description = ignore,
    Object? itemsJson = ignore,
    Object? isItemized = ignore,
    Object? photoUrlsJson = ignore,
    Object? receiptUrlsJson = ignore,
    Object? createdAt = ignore,
  }) {
    return collection.updateProperties(id, {
      if (entryId != ignore) 1: entryId as String?,
      if (memberId != ignore) 2: memberId as String?,
      if (date != ignore) 3: date as DateTime?,
      if (amount != ignore) 4: amount as double?,
      if (description != ignore) 5: description as String?,
      if (itemsJson != ignore) 6: itemsJson as String?,
      if (isItemized != ignore) 7: isItemized as bool?,
      if (photoUrlsJson != ignore) 8: photoUrlsJson as String?,
      if (receiptUrlsJson != ignore) 9: receiptUrlsJson as String?,
      if (createdAt != ignore) 10: createdAt as DateTime?,
    });
  }
}

extension BazarEntryCollectionUpdate
    on IsarCollection<int, BazarEntryCollection> {
  _BazarEntryCollectionUpdate get update =>
      _BazarEntryCollectionUpdateImpl(this);

  _BazarEntryCollectionUpdateAll get updateAll =>
      _BazarEntryCollectionUpdateAllImpl(this);
}

sealed class _BazarEntryCollectionQueryUpdate {
  int call({
    String? entryId,
    String? memberId,
    DateTime? date,
    double? amount,
    String? description,
    String? itemsJson,
    bool? isItemized,
    String? photoUrlsJson,
    String? receiptUrlsJson,
    DateTime? createdAt,
  });
}

class _BazarEntryCollectionQueryUpdateImpl
    implements _BazarEntryCollectionQueryUpdate {
  const _BazarEntryCollectionQueryUpdateImpl(this.query, {this.limit});

  final IsarQuery<BazarEntryCollection> query;
  final int? limit;

  @override
  int call({
    Object? entryId = ignore,
    Object? memberId = ignore,
    Object? date = ignore,
    Object? amount = ignore,
    Object? description = ignore,
    Object? itemsJson = ignore,
    Object? isItemized = ignore,
    Object? photoUrlsJson = ignore,
    Object? receiptUrlsJson = ignore,
    Object? createdAt = ignore,
  }) {
    return query.updateProperties(limit: limit, {
      if (entryId != ignore) 1: entryId as String?,
      if (memberId != ignore) 2: memberId as String?,
      if (date != ignore) 3: date as DateTime?,
      if (amount != ignore) 4: amount as double?,
      if (description != ignore) 5: description as String?,
      if (itemsJson != ignore) 6: itemsJson as String?,
      if (isItemized != ignore) 7: isItemized as bool?,
      if (photoUrlsJson != ignore) 8: photoUrlsJson as String?,
      if (receiptUrlsJson != ignore) 9: receiptUrlsJson as String?,
      if (createdAt != ignore) 10: createdAt as DateTime?,
    });
  }
}

extension BazarEntryCollectionQueryUpdate on IsarQuery<BazarEntryCollection> {
  _BazarEntryCollectionQueryUpdate get updateFirst =>
      _BazarEntryCollectionQueryUpdateImpl(this, limit: 1);

  _BazarEntryCollectionQueryUpdate get updateAll =>
      _BazarEntryCollectionQueryUpdateImpl(this);
}

class _BazarEntryCollectionQueryBuilderUpdateImpl
    implements _BazarEntryCollectionQueryUpdate {
  const _BazarEntryCollectionQueryBuilderUpdateImpl(this.query, {this.limit});

  final QueryBuilder<BazarEntryCollection, BazarEntryCollection, QOperations>
  query;
  final int? limit;

  @override
  int call({
    Object? entryId = ignore,
    Object? memberId = ignore,
    Object? date = ignore,
    Object? amount = ignore,
    Object? description = ignore,
    Object? itemsJson = ignore,
    Object? isItemized = ignore,
    Object? photoUrlsJson = ignore,
    Object? receiptUrlsJson = ignore,
    Object? createdAt = ignore,
  }) {
    final q = query.build();
    try {
      return q.updateProperties(limit: limit, {
        if (entryId != ignore) 1: entryId as String?,
        if (memberId != ignore) 2: memberId as String?,
        if (date != ignore) 3: date as DateTime?,
        if (amount != ignore) 4: amount as double?,
        if (description != ignore) 5: description as String?,
        if (itemsJson != ignore) 6: itemsJson as String?,
        if (isItemized != ignore) 7: isItemized as bool?,
        if (photoUrlsJson != ignore) 8: photoUrlsJson as String?,
        if (receiptUrlsJson != ignore) 9: receiptUrlsJson as String?,
        if (createdAt != ignore) 10: createdAt as DateTime?,
      });
    } finally {
      q.close();
    }
  }
}

extension BazarEntryCollectionQueryBuilderUpdate
    on QueryBuilder<BazarEntryCollection, BazarEntryCollection, QOperations> {
  _BazarEntryCollectionQueryUpdate get updateFirst =>
      _BazarEntryCollectionQueryBuilderUpdateImpl(this, limit: 1);

  _BazarEntryCollectionQueryUpdate get updateAll =>
      _BazarEntryCollectionQueryBuilderUpdateImpl(this);
}

extension BazarEntryCollectionQueryFilter
    on
        QueryBuilder<
          BazarEntryCollection,
          BazarEntryCollection,
          QFilterCondition
        > {
  QueryBuilder<
    BazarEntryCollection,
    BazarEntryCollection,
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
    BazarEntryCollection,
    BazarEntryCollection,
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
    BazarEntryCollection,
    BazarEntryCollection,
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
    BazarEntryCollection,
    BazarEntryCollection,
    QAfterFilterCondition
  >
  idLessThan(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(LessCondition(property: 0, value: value));
    });
  }

  QueryBuilder<
    BazarEntryCollection,
    BazarEntryCollection,
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
    BazarEntryCollection,
    BazarEntryCollection,
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
    BazarEntryCollection,
    BazarEntryCollection,
    QAfterFilterCondition
  >
  entryIdEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(property: 1, value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<
    BazarEntryCollection,
    BazarEntryCollection,
    QAfterFilterCondition
  >
  entryIdGreaterThan(String value, {bool caseSensitive = true}) {
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
    BazarEntryCollection,
    BazarEntryCollection,
    QAfterFilterCondition
  >
  entryIdGreaterThanOrEqualTo(String value, {bool caseSensitive = true}) {
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
    BazarEntryCollection,
    BazarEntryCollection,
    QAfterFilterCondition
  >
  entryIdLessThan(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(property: 1, value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<
    BazarEntryCollection,
    BazarEntryCollection,
    QAfterFilterCondition
  >
  entryIdLessThanOrEqualTo(String value, {bool caseSensitive = true}) {
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
    BazarEntryCollection,
    BazarEntryCollection,
    QAfterFilterCondition
  >
  entryIdBetween(String lower, String upper, {bool caseSensitive = true}) {
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
    BazarEntryCollection,
    BazarEntryCollection,
    QAfterFilterCondition
  >
  entryIdStartsWith(String value, {bool caseSensitive = true}) {
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
    BazarEntryCollection,
    BazarEntryCollection,
    QAfterFilterCondition
  >
  entryIdEndsWith(String value, {bool caseSensitive = true}) {
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
    BazarEntryCollection,
    BazarEntryCollection,
    QAfterFilterCondition
  >
  entryIdContains(String value, {bool caseSensitive = true}) {
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
    BazarEntryCollection,
    BazarEntryCollection,
    QAfterFilterCondition
  >
  entryIdMatches(String pattern, {bool caseSensitive = true}) {
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
    BazarEntryCollection,
    BazarEntryCollection,
    QAfterFilterCondition
  >
  entryIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const EqualCondition(property: 1, value: ''),
      );
    });
  }

  QueryBuilder<
    BazarEntryCollection,
    BazarEntryCollection,
    QAfterFilterCondition
  >
  entryIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const GreaterCondition(property: 1, value: ''),
      );
    });
  }

  QueryBuilder<
    BazarEntryCollection,
    BazarEntryCollection,
    QAfterFilterCondition
  >
  memberIdEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(property: 2, value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<
    BazarEntryCollection,
    BazarEntryCollection,
    QAfterFilterCondition
  >
  memberIdGreaterThan(String value, {bool caseSensitive = true}) {
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
    BazarEntryCollection,
    BazarEntryCollection,
    QAfterFilterCondition
  >
  memberIdGreaterThanOrEqualTo(String value, {bool caseSensitive = true}) {
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
    BazarEntryCollection,
    BazarEntryCollection,
    QAfterFilterCondition
  >
  memberIdLessThan(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(property: 2, value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<
    BazarEntryCollection,
    BazarEntryCollection,
    QAfterFilterCondition
  >
  memberIdLessThanOrEqualTo(String value, {bool caseSensitive = true}) {
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
    BazarEntryCollection,
    BazarEntryCollection,
    QAfterFilterCondition
  >
  memberIdBetween(String lower, String upper, {bool caseSensitive = true}) {
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
    BazarEntryCollection,
    BazarEntryCollection,
    QAfterFilterCondition
  >
  memberIdStartsWith(String value, {bool caseSensitive = true}) {
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
    BazarEntryCollection,
    BazarEntryCollection,
    QAfterFilterCondition
  >
  memberIdEndsWith(String value, {bool caseSensitive = true}) {
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
    BazarEntryCollection,
    BazarEntryCollection,
    QAfterFilterCondition
  >
  memberIdContains(String value, {bool caseSensitive = true}) {
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
    BazarEntryCollection,
    BazarEntryCollection,
    QAfterFilterCondition
  >
  memberIdMatches(String pattern, {bool caseSensitive = true}) {
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
    BazarEntryCollection,
    BazarEntryCollection,
    QAfterFilterCondition
  >
  memberIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const EqualCondition(property: 2, value: ''),
      );
    });
  }

  QueryBuilder<
    BazarEntryCollection,
    BazarEntryCollection,
    QAfterFilterCondition
  >
  memberIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const GreaterCondition(property: 2, value: ''),
      );
    });
  }

  QueryBuilder<
    BazarEntryCollection,
    BazarEntryCollection,
    QAfterFilterCondition
  >
  dateEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(property: 3, value: value),
      );
    });
  }

  QueryBuilder<
    BazarEntryCollection,
    BazarEntryCollection,
    QAfterFilterCondition
  >
  dateGreaterThan(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(property: 3, value: value),
      );
    });
  }

  QueryBuilder<
    BazarEntryCollection,
    BazarEntryCollection,
    QAfterFilterCondition
  >
  dateGreaterThanOrEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(property: 3, value: value),
      );
    });
  }

  QueryBuilder<
    BazarEntryCollection,
    BazarEntryCollection,
    QAfterFilterCondition
  >
  dateLessThan(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(LessCondition(property: 3, value: value));
    });
  }

  QueryBuilder<
    BazarEntryCollection,
    BazarEntryCollection,
    QAfterFilterCondition
  >
  dateLessThanOrEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(property: 3, value: value),
      );
    });
  }

  QueryBuilder<
    BazarEntryCollection,
    BazarEntryCollection,
    QAfterFilterCondition
  >
  dateBetween(DateTime lower, DateTime upper) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(property: 3, lower: lower, upper: upper),
      );
    });
  }

  QueryBuilder<
    BazarEntryCollection,
    BazarEntryCollection,
    QAfterFilterCondition
  >
  amountEqualTo(double value, {double epsilon = Filter.epsilon}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(property: 4, value: value, epsilon: epsilon),
      );
    });
  }

  QueryBuilder<
    BazarEntryCollection,
    BazarEntryCollection,
    QAfterFilterCondition
  >
  amountGreaterThan(double value, {double epsilon = Filter.epsilon}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(property: 4, value: value, epsilon: epsilon),
      );
    });
  }

  QueryBuilder<
    BazarEntryCollection,
    BazarEntryCollection,
    QAfterFilterCondition
  >
  amountGreaterThanOrEqualTo(double value, {double epsilon = Filter.epsilon}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(property: 4, value: value, epsilon: epsilon),
      );
    });
  }

  QueryBuilder<
    BazarEntryCollection,
    BazarEntryCollection,
    QAfterFilterCondition
  >
  amountLessThan(double value, {double epsilon = Filter.epsilon}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(property: 4, value: value, epsilon: epsilon),
      );
    });
  }

  QueryBuilder<
    BazarEntryCollection,
    BazarEntryCollection,
    QAfterFilterCondition
  >
  amountLessThanOrEqualTo(double value, {double epsilon = Filter.epsilon}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(property: 4, value: value, epsilon: epsilon),
      );
    });
  }

  QueryBuilder<
    BazarEntryCollection,
    BazarEntryCollection,
    QAfterFilterCondition
  >
  amountBetween(double lower, double upper, {double epsilon = Filter.epsilon}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(
          property: 4,
          lower: lower,
          upper: upper,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<
    BazarEntryCollection,
    BazarEntryCollection,
    QAfterFilterCondition
  >
  descriptionIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const IsNullCondition(property: 5));
    });
  }

  QueryBuilder<
    BazarEntryCollection,
    BazarEntryCollection,
    QAfterFilterCondition
  >
  descriptionIsNotNull() {
    return QueryBuilder.apply(not(), (query) {
      return query.addFilterCondition(const IsNullCondition(property: 5));
    });
  }

  QueryBuilder<
    BazarEntryCollection,
    BazarEntryCollection,
    QAfterFilterCondition
  >
  descriptionEqualTo(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(property: 5, value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<
    BazarEntryCollection,
    BazarEntryCollection,
    QAfterFilterCondition
  >
  descriptionGreaterThan(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(
          property: 5,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    BazarEntryCollection,
    BazarEntryCollection,
    QAfterFilterCondition
  >
  descriptionGreaterThanOrEqualTo(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(
          property: 5,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    BazarEntryCollection,
    BazarEntryCollection,
    QAfterFilterCondition
  >
  descriptionLessThan(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(property: 5, value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<
    BazarEntryCollection,
    BazarEntryCollection,
    QAfterFilterCondition
  >
  descriptionLessThanOrEqualTo(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(
          property: 5,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    BazarEntryCollection,
    BazarEntryCollection,
    QAfterFilterCondition
  >
  descriptionBetween(
    String? lower,
    String? upper, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(
          property: 5,
          lower: lower,
          upper: upper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    BazarEntryCollection,
    BazarEntryCollection,
    QAfterFilterCondition
  >
  descriptionStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        StartsWithCondition(
          property: 5,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    BazarEntryCollection,
    BazarEntryCollection,
    QAfterFilterCondition
  >
  descriptionEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EndsWithCondition(
          property: 5,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    BazarEntryCollection,
    BazarEntryCollection,
    QAfterFilterCondition
  >
  descriptionContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        ContainsCondition(
          property: 5,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    BazarEntryCollection,
    BazarEntryCollection,
    QAfterFilterCondition
  >
  descriptionMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        MatchesCondition(
          property: 5,
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    BazarEntryCollection,
    BazarEntryCollection,
    QAfterFilterCondition
  >
  descriptionIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const EqualCondition(property: 5, value: ''),
      );
    });
  }

  QueryBuilder<
    BazarEntryCollection,
    BazarEntryCollection,
    QAfterFilterCondition
  >
  descriptionIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const GreaterCondition(property: 5, value: ''),
      );
    });
  }

  QueryBuilder<
    BazarEntryCollection,
    BazarEntryCollection,
    QAfterFilterCondition
  >
  itemsJsonIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const IsNullCondition(property: 6));
    });
  }

  QueryBuilder<
    BazarEntryCollection,
    BazarEntryCollection,
    QAfterFilterCondition
  >
  itemsJsonIsNotNull() {
    return QueryBuilder.apply(not(), (query) {
      return query.addFilterCondition(const IsNullCondition(property: 6));
    });
  }

  QueryBuilder<
    BazarEntryCollection,
    BazarEntryCollection,
    QAfterFilterCondition
  >
  itemsJsonEqualTo(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(property: 6, value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<
    BazarEntryCollection,
    BazarEntryCollection,
    QAfterFilterCondition
  >
  itemsJsonGreaterThan(String? value, {bool caseSensitive = true}) {
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
    BazarEntryCollection,
    BazarEntryCollection,
    QAfterFilterCondition
  >
  itemsJsonGreaterThanOrEqualTo(String? value, {bool caseSensitive = true}) {
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
    BazarEntryCollection,
    BazarEntryCollection,
    QAfterFilterCondition
  >
  itemsJsonLessThan(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(property: 6, value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<
    BazarEntryCollection,
    BazarEntryCollection,
    QAfterFilterCondition
  >
  itemsJsonLessThanOrEqualTo(String? value, {bool caseSensitive = true}) {
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
    BazarEntryCollection,
    BazarEntryCollection,
    QAfterFilterCondition
  >
  itemsJsonBetween(String? lower, String? upper, {bool caseSensitive = true}) {
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
    BazarEntryCollection,
    BazarEntryCollection,
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
    BazarEntryCollection,
    BazarEntryCollection,
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
    BazarEntryCollection,
    BazarEntryCollection,
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
    BazarEntryCollection,
    BazarEntryCollection,
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
    BazarEntryCollection,
    BazarEntryCollection,
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
    BazarEntryCollection,
    BazarEntryCollection,
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
    BazarEntryCollection,
    BazarEntryCollection,
    QAfterFilterCondition
  >
  isItemizedEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(property: 7, value: value),
      );
    });
  }

  QueryBuilder<
    BazarEntryCollection,
    BazarEntryCollection,
    QAfterFilterCondition
  >
  photoUrlsJsonIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const IsNullCondition(property: 8));
    });
  }

  QueryBuilder<
    BazarEntryCollection,
    BazarEntryCollection,
    QAfterFilterCondition
  >
  photoUrlsJsonIsNotNull() {
    return QueryBuilder.apply(not(), (query) {
      return query.addFilterCondition(const IsNullCondition(property: 8));
    });
  }

  QueryBuilder<
    BazarEntryCollection,
    BazarEntryCollection,
    QAfterFilterCondition
  >
  photoUrlsJsonEqualTo(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(property: 8, value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<
    BazarEntryCollection,
    BazarEntryCollection,
    QAfterFilterCondition
  >
  photoUrlsJsonGreaterThan(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(
          property: 8,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    BazarEntryCollection,
    BazarEntryCollection,
    QAfterFilterCondition
  >
  photoUrlsJsonGreaterThanOrEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(
          property: 8,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    BazarEntryCollection,
    BazarEntryCollection,
    QAfterFilterCondition
  >
  photoUrlsJsonLessThan(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(property: 8, value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<
    BazarEntryCollection,
    BazarEntryCollection,
    QAfterFilterCondition
  >
  photoUrlsJsonLessThanOrEqualTo(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(
          property: 8,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    BazarEntryCollection,
    BazarEntryCollection,
    QAfterFilterCondition
  >
  photoUrlsJsonBetween(
    String? lower,
    String? upper, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(
          property: 8,
          lower: lower,
          upper: upper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    BazarEntryCollection,
    BazarEntryCollection,
    QAfterFilterCondition
  >
  photoUrlsJsonStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        StartsWithCondition(
          property: 8,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    BazarEntryCollection,
    BazarEntryCollection,
    QAfterFilterCondition
  >
  photoUrlsJsonEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EndsWithCondition(
          property: 8,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    BazarEntryCollection,
    BazarEntryCollection,
    QAfterFilterCondition
  >
  photoUrlsJsonContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        ContainsCondition(
          property: 8,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    BazarEntryCollection,
    BazarEntryCollection,
    QAfterFilterCondition
  >
  photoUrlsJsonMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        MatchesCondition(
          property: 8,
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    BazarEntryCollection,
    BazarEntryCollection,
    QAfterFilterCondition
  >
  photoUrlsJsonIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const EqualCondition(property: 8, value: ''),
      );
    });
  }

  QueryBuilder<
    BazarEntryCollection,
    BazarEntryCollection,
    QAfterFilterCondition
  >
  photoUrlsJsonIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const GreaterCondition(property: 8, value: ''),
      );
    });
  }

  QueryBuilder<
    BazarEntryCollection,
    BazarEntryCollection,
    QAfterFilterCondition
  >
  receiptUrlsJsonIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const IsNullCondition(property: 9));
    });
  }

  QueryBuilder<
    BazarEntryCollection,
    BazarEntryCollection,
    QAfterFilterCondition
  >
  receiptUrlsJsonIsNotNull() {
    return QueryBuilder.apply(not(), (query) {
      return query.addFilterCondition(const IsNullCondition(property: 9));
    });
  }

  QueryBuilder<
    BazarEntryCollection,
    BazarEntryCollection,
    QAfterFilterCondition
  >
  receiptUrlsJsonEqualTo(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(property: 9, value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<
    BazarEntryCollection,
    BazarEntryCollection,
    QAfterFilterCondition
  >
  receiptUrlsJsonGreaterThan(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(
          property: 9,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    BazarEntryCollection,
    BazarEntryCollection,
    QAfterFilterCondition
  >
  receiptUrlsJsonGreaterThanOrEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(
          property: 9,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    BazarEntryCollection,
    BazarEntryCollection,
    QAfterFilterCondition
  >
  receiptUrlsJsonLessThan(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(property: 9, value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<
    BazarEntryCollection,
    BazarEntryCollection,
    QAfterFilterCondition
  >
  receiptUrlsJsonLessThanOrEqualTo(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(
          property: 9,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    BazarEntryCollection,
    BazarEntryCollection,
    QAfterFilterCondition
  >
  receiptUrlsJsonBetween(
    String? lower,
    String? upper, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(
          property: 9,
          lower: lower,
          upper: upper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    BazarEntryCollection,
    BazarEntryCollection,
    QAfterFilterCondition
  >
  receiptUrlsJsonStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        StartsWithCondition(
          property: 9,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    BazarEntryCollection,
    BazarEntryCollection,
    QAfterFilterCondition
  >
  receiptUrlsJsonEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EndsWithCondition(
          property: 9,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    BazarEntryCollection,
    BazarEntryCollection,
    QAfterFilterCondition
  >
  receiptUrlsJsonContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        ContainsCondition(
          property: 9,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    BazarEntryCollection,
    BazarEntryCollection,
    QAfterFilterCondition
  >
  receiptUrlsJsonMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        MatchesCondition(
          property: 9,
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    BazarEntryCollection,
    BazarEntryCollection,
    QAfterFilterCondition
  >
  receiptUrlsJsonIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const EqualCondition(property: 9, value: ''),
      );
    });
  }

  QueryBuilder<
    BazarEntryCollection,
    BazarEntryCollection,
    QAfterFilterCondition
  >
  receiptUrlsJsonIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const GreaterCondition(property: 9, value: ''),
      );
    });
  }

  QueryBuilder<
    BazarEntryCollection,
    BazarEntryCollection,
    QAfterFilterCondition
  >
  createdAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const IsNullCondition(property: 10));
    });
  }

  QueryBuilder<
    BazarEntryCollection,
    BazarEntryCollection,
    QAfterFilterCondition
  >
  createdAtIsNotNull() {
    return QueryBuilder.apply(not(), (query) {
      return query.addFilterCondition(const IsNullCondition(property: 10));
    });
  }

  QueryBuilder<
    BazarEntryCollection,
    BazarEntryCollection,
    QAfterFilterCondition
  >
  createdAtEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(property: 10, value: value),
      );
    });
  }

  QueryBuilder<
    BazarEntryCollection,
    BazarEntryCollection,
    QAfterFilterCondition
  >
  createdAtGreaterThan(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(property: 10, value: value),
      );
    });
  }

  QueryBuilder<
    BazarEntryCollection,
    BazarEntryCollection,
    QAfterFilterCondition
  >
  createdAtGreaterThanOrEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(property: 10, value: value),
      );
    });
  }

  QueryBuilder<
    BazarEntryCollection,
    BazarEntryCollection,
    QAfterFilterCondition
  >
  createdAtLessThan(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(property: 10, value: value),
      );
    });
  }

  QueryBuilder<
    BazarEntryCollection,
    BazarEntryCollection,
    QAfterFilterCondition
  >
  createdAtLessThanOrEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(property: 10, value: value),
      );
    });
  }

  QueryBuilder<
    BazarEntryCollection,
    BazarEntryCollection,
    QAfterFilterCondition
  >
  createdAtBetween(DateTime? lower, DateTime? upper) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(property: 10, lower: lower, upper: upper),
      );
    });
  }
}

extension BazarEntryCollectionQueryObject
    on
        QueryBuilder<
          BazarEntryCollection,
          BazarEntryCollection,
          QFilterCondition
        > {}

extension BazarEntryCollectionQuerySortBy
    on QueryBuilder<BazarEntryCollection, BazarEntryCollection, QSortBy> {
  QueryBuilder<BazarEntryCollection, BazarEntryCollection, QAfterSortBy>
  sortById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(0);
    });
  }

  QueryBuilder<BazarEntryCollection, BazarEntryCollection, QAfterSortBy>
  sortByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(0, sort: Sort.desc);
    });
  }

  QueryBuilder<BazarEntryCollection, BazarEntryCollection, QAfterSortBy>
  sortByEntryId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(1, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<BazarEntryCollection, BazarEntryCollection, QAfterSortBy>
  sortByEntryIdDesc({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(1, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<BazarEntryCollection, BazarEntryCollection, QAfterSortBy>
  sortByMemberId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(2, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<BazarEntryCollection, BazarEntryCollection, QAfterSortBy>
  sortByMemberIdDesc({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(2, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<BazarEntryCollection, BazarEntryCollection, QAfterSortBy>
  sortByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(3);
    });
  }

  QueryBuilder<BazarEntryCollection, BazarEntryCollection, QAfterSortBy>
  sortByDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(3, sort: Sort.desc);
    });
  }

  QueryBuilder<BazarEntryCollection, BazarEntryCollection, QAfterSortBy>
  sortByAmount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(4);
    });
  }

  QueryBuilder<BazarEntryCollection, BazarEntryCollection, QAfterSortBy>
  sortByAmountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(4, sort: Sort.desc);
    });
  }

  QueryBuilder<BazarEntryCollection, BazarEntryCollection, QAfterSortBy>
  sortByDescription({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(5, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<BazarEntryCollection, BazarEntryCollection, QAfterSortBy>
  sortByDescriptionDesc({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(5, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<BazarEntryCollection, BazarEntryCollection, QAfterSortBy>
  sortByItemsJson({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(6, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<BazarEntryCollection, BazarEntryCollection, QAfterSortBy>
  sortByItemsJsonDesc({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(6, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<BazarEntryCollection, BazarEntryCollection, QAfterSortBy>
  sortByIsItemized() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(7);
    });
  }

  QueryBuilder<BazarEntryCollection, BazarEntryCollection, QAfterSortBy>
  sortByIsItemizedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(7, sort: Sort.desc);
    });
  }

  QueryBuilder<BazarEntryCollection, BazarEntryCollection, QAfterSortBy>
  sortByPhotoUrlsJson({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(8, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<BazarEntryCollection, BazarEntryCollection, QAfterSortBy>
  sortByPhotoUrlsJsonDesc({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(8, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<BazarEntryCollection, BazarEntryCollection, QAfterSortBy>
  sortByReceiptUrlsJson({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(9, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<BazarEntryCollection, BazarEntryCollection, QAfterSortBy>
  sortByReceiptUrlsJsonDesc({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(9, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<BazarEntryCollection, BazarEntryCollection, QAfterSortBy>
  sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(10);
    });
  }

  QueryBuilder<BazarEntryCollection, BazarEntryCollection, QAfterSortBy>
  sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(10, sort: Sort.desc);
    });
  }
}

extension BazarEntryCollectionQuerySortThenBy
    on QueryBuilder<BazarEntryCollection, BazarEntryCollection, QSortThenBy> {
  QueryBuilder<BazarEntryCollection, BazarEntryCollection, QAfterSortBy>
  thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(0);
    });
  }

  QueryBuilder<BazarEntryCollection, BazarEntryCollection, QAfterSortBy>
  thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(0, sort: Sort.desc);
    });
  }

  QueryBuilder<BazarEntryCollection, BazarEntryCollection, QAfterSortBy>
  thenByEntryId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(1, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<BazarEntryCollection, BazarEntryCollection, QAfterSortBy>
  thenByEntryIdDesc({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(1, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<BazarEntryCollection, BazarEntryCollection, QAfterSortBy>
  thenByMemberId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(2, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<BazarEntryCollection, BazarEntryCollection, QAfterSortBy>
  thenByMemberIdDesc({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(2, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<BazarEntryCollection, BazarEntryCollection, QAfterSortBy>
  thenByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(3);
    });
  }

  QueryBuilder<BazarEntryCollection, BazarEntryCollection, QAfterSortBy>
  thenByDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(3, sort: Sort.desc);
    });
  }

  QueryBuilder<BazarEntryCollection, BazarEntryCollection, QAfterSortBy>
  thenByAmount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(4);
    });
  }

  QueryBuilder<BazarEntryCollection, BazarEntryCollection, QAfterSortBy>
  thenByAmountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(4, sort: Sort.desc);
    });
  }

  QueryBuilder<BazarEntryCollection, BazarEntryCollection, QAfterSortBy>
  thenByDescription({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(5, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<BazarEntryCollection, BazarEntryCollection, QAfterSortBy>
  thenByDescriptionDesc({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(5, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<BazarEntryCollection, BazarEntryCollection, QAfterSortBy>
  thenByItemsJson({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(6, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<BazarEntryCollection, BazarEntryCollection, QAfterSortBy>
  thenByItemsJsonDesc({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(6, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<BazarEntryCollection, BazarEntryCollection, QAfterSortBy>
  thenByIsItemized() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(7);
    });
  }

  QueryBuilder<BazarEntryCollection, BazarEntryCollection, QAfterSortBy>
  thenByIsItemizedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(7, sort: Sort.desc);
    });
  }

  QueryBuilder<BazarEntryCollection, BazarEntryCollection, QAfterSortBy>
  thenByPhotoUrlsJson({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(8, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<BazarEntryCollection, BazarEntryCollection, QAfterSortBy>
  thenByPhotoUrlsJsonDesc({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(8, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<BazarEntryCollection, BazarEntryCollection, QAfterSortBy>
  thenByReceiptUrlsJson({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(9, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<BazarEntryCollection, BazarEntryCollection, QAfterSortBy>
  thenByReceiptUrlsJsonDesc({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(9, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<BazarEntryCollection, BazarEntryCollection, QAfterSortBy>
  thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(10);
    });
  }

  QueryBuilder<BazarEntryCollection, BazarEntryCollection, QAfterSortBy>
  thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(10, sort: Sort.desc);
    });
  }
}

extension BazarEntryCollectionQueryWhereDistinct
    on QueryBuilder<BazarEntryCollection, BazarEntryCollection, QDistinct> {
  QueryBuilder<BazarEntryCollection, BazarEntryCollection, QAfterDistinct>
  distinctByEntryId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(1, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<BazarEntryCollection, BazarEntryCollection, QAfterDistinct>
  distinctByMemberId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(2, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<BazarEntryCollection, BazarEntryCollection, QAfterDistinct>
  distinctByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(3);
    });
  }

  QueryBuilder<BazarEntryCollection, BazarEntryCollection, QAfterDistinct>
  distinctByAmount() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(4);
    });
  }

  QueryBuilder<BazarEntryCollection, BazarEntryCollection, QAfterDistinct>
  distinctByDescription({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(5, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<BazarEntryCollection, BazarEntryCollection, QAfterDistinct>
  distinctByItemsJson({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(6, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<BazarEntryCollection, BazarEntryCollection, QAfterDistinct>
  distinctByIsItemized() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(7);
    });
  }

  QueryBuilder<BazarEntryCollection, BazarEntryCollection, QAfterDistinct>
  distinctByPhotoUrlsJson({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(8, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<BazarEntryCollection, BazarEntryCollection, QAfterDistinct>
  distinctByReceiptUrlsJson({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(9, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<BazarEntryCollection, BazarEntryCollection, QAfterDistinct>
  distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(10);
    });
  }
}

extension BazarEntryCollectionQueryProperty1
    on QueryBuilder<BazarEntryCollection, BazarEntryCollection, QProperty> {
  QueryBuilder<BazarEntryCollection, int, QAfterProperty> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(0);
    });
  }

  QueryBuilder<BazarEntryCollection, String, QAfterProperty> entryIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(1);
    });
  }

  QueryBuilder<BazarEntryCollection, String, QAfterProperty>
  memberIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(2);
    });
  }

  QueryBuilder<BazarEntryCollection, DateTime, QAfterProperty> dateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(3);
    });
  }

  QueryBuilder<BazarEntryCollection, double, QAfterProperty> amountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(4);
    });
  }

  QueryBuilder<BazarEntryCollection, String?, QAfterProperty>
  descriptionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(5);
    });
  }

  QueryBuilder<BazarEntryCollection, String?, QAfterProperty>
  itemsJsonProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(6);
    });
  }

  QueryBuilder<BazarEntryCollection, bool, QAfterProperty>
  isItemizedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(7);
    });
  }

  QueryBuilder<BazarEntryCollection, String?, QAfterProperty>
  photoUrlsJsonProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(8);
    });
  }

  QueryBuilder<BazarEntryCollection, String?, QAfterProperty>
  receiptUrlsJsonProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(9);
    });
  }

  QueryBuilder<BazarEntryCollection, DateTime?, QAfterProperty>
  createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(10);
    });
  }
}

extension BazarEntryCollectionQueryProperty2<R>
    on QueryBuilder<BazarEntryCollection, R, QAfterProperty> {
  QueryBuilder<BazarEntryCollection, (R, int), QAfterProperty> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(0);
    });
  }

  QueryBuilder<BazarEntryCollection, (R, String), QAfterProperty>
  entryIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(1);
    });
  }

  QueryBuilder<BazarEntryCollection, (R, String), QAfterProperty>
  memberIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(2);
    });
  }

  QueryBuilder<BazarEntryCollection, (R, DateTime), QAfterProperty>
  dateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(3);
    });
  }

  QueryBuilder<BazarEntryCollection, (R, double), QAfterProperty>
  amountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(4);
    });
  }

  QueryBuilder<BazarEntryCollection, (R, String?), QAfterProperty>
  descriptionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(5);
    });
  }

  QueryBuilder<BazarEntryCollection, (R, String?), QAfterProperty>
  itemsJsonProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(6);
    });
  }

  QueryBuilder<BazarEntryCollection, (R, bool), QAfterProperty>
  isItemizedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(7);
    });
  }

  QueryBuilder<BazarEntryCollection, (R, String?), QAfterProperty>
  photoUrlsJsonProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(8);
    });
  }

  QueryBuilder<BazarEntryCollection, (R, String?), QAfterProperty>
  receiptUrlsJsonProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(9);
    });
  }

  QueryBuilder<BazarEntryCollection, (R, DateTime?), QAfterProperty>
  createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(10);
    });
  }
}

extension BazarEntryCollectionQueryProperty3<R1, R2>
    on QueryBuilder<BazarEntryCollection, (R1, R2), QAfterProperty> {
  QueryBuilder<BazarEntryCollection, (R1, R2, int), QOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(0);
    });
  }

  QueryBuilder<BazarEntryCollection, (R1, R2, String), QOperations>
  entryIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(1);
    });
  }

  QueryBuilder<BazarEntryCollection, (R1, R2, String), QOperations>
  memberIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(2);
    });
  }

  QueryBuilder<BazarEntryCollection, (R1, R2, DateTime), QOperations>
  dateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(3);
    });
  }

  QueryBuilder<BazarEntryCollection, (R1, R2, double), QOperations>
  amountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(4);
    });
  }

  QueryBuilder<BazarEntryCollection, (R1, R2, String?), QOperations>
  descriptionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(5);
    });
  }

  QueryBuilder<BazarEntryCollection, (R1, R2, String?), QOperations>
  itemsJsonProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(6);
    });
  }

  QueryBuilder<BazarEntryCollection, (R1, R2, bool), QOperations>
  isItemizedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(7);
    });
  }

  QueryBuilder<BazarEntryCollection, (R1, R2, String?), QOperations>
  photoUrlsJsonProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(8);
    });
  }

  QueryBuilder<BazarEntryCollection, (R1, R2, String?), QOperations>
  receiptUrlsJsonProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(9);
    });
  }

  QueryBuilder<BazarEntryCollection, (R1, R2, DateTime?), QOperations>
  createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(10);
    });
  }
}
