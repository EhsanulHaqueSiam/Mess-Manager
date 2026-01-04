// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'unified_entry_collection.dart';

// **************************************************************************
// _IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, invalid_use_of_protected_member, lines_longer_than_80_chars, constant_identifier_names, avoid_js_rounded_ints, no_leading_underscores_for_local_identifiers, require_trailing_commas, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_in_if_null_operators, library_private_types_in_public_api, prefer_const_constructors
// ignore_for_file: type=lint

extension GetUnifiedEntryCollectionCollection on Isar {
  IsarCollection<int, UnifiedEntryCollection> get unifiedEntryCollections =>
      this.collection();
}

final UnifiedEntryCollectionSchema = IsarGeneratedSchema(
  schema: IsarSchema(
    name: 'UnifiedEntryCollection',
    idName: 'id',
    embedded: false,
    properties: [
      IsarPropertySchema(name: 'entryId', type: IsarType.string),
      IsarPropertySchema(name: 'memberId', type: IsarType.string),
      IsarPropertySchema(name: 'date', type: IsarType.dateTime),
      IsarPropertySchema(name: 'amount', type: IsarType.double),
      IsarPropertySchema(name: 'description', type: IsarType.string),
      IsarPropertySchema(name: 'typeIndex', type: IsarType.long),
      IsarPropertySchema(name: 'monthlyCategoryIndex', type: IsarType.long),
      IsarPropertySchema(name: 'photoUrlsJson', type: IsarType.string),
      IsarPropertySchema(name: 'receiptUrlsJson', type: IsarType.string),
      IsarPropertySchema(name: 'isAutoDetected', type: IsarType.bool),
      IsarPropertySchema(name: 'itemsJson', type: IsarType.string),
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
  converter: IsarObjectConverter<int, UnifiedEntryCollection>(
    serialize: serializeUnifiedEntryCollection,
    deserialize: deserializeUnifiedEntryCollection,
    deserializeProperty: deserializeUnifiedEntryCollectionProp,
  ),
  getEmbeddedSchemas: () => [],
);

@isarProtected
int serializeUnifiedEntryCollection(
  IsarWriter writer,
  UnifiedEntryCollection object,
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
  IsarCore.writeLong(writer, 6, object.typeIndex);
  IsarCore.writeLong(writer, 7, object.monthlyCategoryIndex);
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
  IsarCore.writeBool(writer, 10, value: object.isAutoDetected);
  {
    final value = object.itemsJson;
    if (value == null) {
      IsarCore.writeNull(writer, 11);
    } else {
      IsarCore.writeString(writer, 11, value);
    }
  }
  IsarCore.writeLong(
    writer,
    12,
    object.createdAt?.toUtc().microsecondsSinceEpoch ?? -9223372036854775808,
  );
  return object.id;
}

@isarProtected
UnifiedEntryCollection deserializeUnifiedEntryCollection(IsarReader reader) {
  final object = UnifiedEntryCollection();
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
  object.typeIndex = IsarCore.readLong(reader, 6);
  object.monthlyCategoryIndex = IsarCore.readLong(reader, 7);
  object.photoUrlsJson = IsarCore.readString(reader, 8);
  object.receiptUrlsJson = IsarCore.readString(reader, 9);
  object.isAutoDetected = IsarCore.readBool(reader, 10);
  object.itemsJson = IsarCore.readString(reader, 11);
  {
    final value = IsarCore.readLong(reader, 12);
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
dynamic deserializeUnifiedEntryCollectionProp(IsarReader reader, int property) {
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
      return IsarCore.readLong(reader, 6);
    case 7:
      return IsarCore.readLong(reader, 7);
    case 8:
      return IsarCore.readString(reader, 8);
    case 9:
      return IsarCore.readString(reader, 9);
    case 10:
      return IsarCore.readBool(reader, 10);
    case 11:
      return IsarCore.readString(reader, 11);
    case 12:
      {
        final value = IsarCore.readLong(reader, 12);
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

sealed class _UnifiedEntryCollectionUpdate {
  bool call({
    required int id,
    String? entryId,
    String? memberId,
    DateTime? date,
    double? amount,
    String? description,
    int? typeIndex,
    int? monthlyCategoryIndex,
    String? photoUrlsJson,
    String? receiptUrlsJson,
    bool? isAutoDetected,
    String? itemsJson,
    DateTime? createdAt,
  });
}

class _UnifiedEntryCollectionUpdateImpl
    implements _UnifiedEntryCollectionUpdate {
  const _UnifiedEntryCollectionUpdateImpl(this.collection);

  final IsarCollection<int, UnifiedEntryCollection> collection;

  @override
  bool call({
    required int id,
    Object? entryId = ignore,
    Object? memberId = ignore,
    Object? date = ignore,
    Object? amount = ignore,
    Object? description = ignore,
    Object? typeIndex = ignore,
    Object? monthlyCategoryIndex = ignore,
    Object? photoUrlsJson = ignore,
    Object? receiptUrlsJson = ignore,
    Object? isAutoDetected = ignore,
    Object? itemsJson = ignore,
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
            if (typeIndex != ignore) 6: typeIndex as int?,
            if (monthlyCategoryIndex != ignore) 7: monthlyCategoryIndex as int?,
            if (photoUrlsJson != ignore) 8: photoUrlsJson as String?,
            if (receiptUrlsJson != ignore) 9: receiptUrlsJson as String?,
            if (isAutoDetected != ignore) 10: isAutoDetected as bool?,
            if (itemsJson != ignore) 11: itemsJson as String?,
            if (createdAt != ignore) 12: createdAt as DateTime?,
          },
        ) >
        0;
  }
}

sealed class _UnifiedEntryCollectionUpdateAll {
  int call({
    required List<int> id,
    String? entryId,
    String? memberId,
    DateTime? date,
    double? amount,
    String? description,
    int? typeIndex,
    int? monthlyCategoryIndex,
    String? photoUrlsJson,
    String? receiptUrlsJson,
    bool? isAutoDetected,
    String? itemsJson,
    DateTime? createdAt,
  });
}

class _UnifiedEntryCollectionUpdateAllImpl
    implements _UnifiedEntryCollectionUpdateAll {
  const _UnifiedEntryCollectionUpdateAllImpl(this.collection);

  final IsarCollection<int, UnifiedEntryCollection> collection;

  @override
  int call({
    required List<int> id,
    Object? entryId = ignore,
    Object? memberId = ignore,
    Object? date = ignore,
    Object? amount = ignore,
    Object? description = ignore,
    Object? typeIndex = ignore,
    Object? monthlyCategoryIndex = ignore,
    Object? photoUrlsJson = ignore,
    Object? receiptUrlsJson = ignore,
    Object? isAutoDetected = ignore,
    Object? itemsJson = ignore,
    Object? createdAt = ignore,
  }) {
    return collection.updateProperties(id, {
      if (entryId != ignore) 1: entryId as String?,
      if (memberId != ignore) 2: memberId as String?,
      if (date != ignore) 3: date as DateTime?,
      if (amount != ignore) 4: amount as double?,
      if (description != ignore) 5: description as String?,
      if (typeIndex != ignore) 6: typeIndex as int?,
      if (monthlyCategoryIndex != ignore) 7: monthlyCategoryIndex as int?,
      if (photoUrlsJson != ignore) 8: photoUrlsJson as String?,
      if (receiptUrlsJson != ignore) 9: receiptUrlsJson as String?,
      if (isAutoDetected != ignore) 10: isAutoDetected as bool?,
      if (itemsJson != ignore) 11: itemsJson as String?,
      if (createdAt != ignore) 12: createdAt as DateTime?,
    });
  }
}

extension UnifiedEntryCollectionUpdate
    on IsarCollection<int, UnifiedEntryCollection> {
  _UnifiedEntryCollectionUpdate get update =>
      _UnifiedEntryCollectionUpdateImpl(this);

  _UnifiedEntryCollectionUpdateAll get updateAll =>
      _UnifiedEntryCollectionUpdateAllImpl(this);
}

sealed class _UnifiedEntryCollectionQueryUpdate {
  int call({
    String? entryId,
    String? memberId,
    DateTime? date,
    double? amount,
    String? description,
    int? typeIndex,
    int? monthlyCategoryIndex,
    String? photoUrlsJson,
    String? receiptUrlsJson,
    bool? isAutoDetected,
    String? itemsJson,
    DateTime? createdAt,
  });
}

class _UnifiedEntryCollectionQueryUpdateImpl
    implements _UnifiedEntryCollectionQueryUpdate {
  const _UnifiedEntryCollectionQueryUpdateImpl(this.query, {this.limit});

  final IsarQuery<UnifiedEntryCollection> query;
  final int? limit;

  @override
  int call({
    Object? entryId = ignore,
    Object? memberId = ignore,
    Object? date = ignore,
    Object? amount = ignore,
    Object? description = ignore,
    Object? typeIndex = ignore,
    Object? monthlyCategoryIndex = ignore,
    Object? photoUrlsJson = ignore,
    Object? receiptUrlsJson = ignore,
    Object? isAutoDetected = ignore,
    Object? itemsJson = ignore,
    Object? createdAt = ignore,
  }) {
    return query.updateProperties(limit: limit, {
      if (entryId != ignore) 1: entryId as String?,
      if (memberId != ignore) 2: memberId as String?,
      if (date != ignore) 3: date as DateTime?,
      if (amount != ignore) 4: amount as double?,
      if (description != ignore) 5: description as String?,
      if (typeIndex != ignore) 6: typeIndex as int?,
      if (monthlyCategoryIndex != ignore) 7: monthlyCategoryIndex as int?,
      if (photoUrlsJson != ignore) 8: photoUrlsJson as String?,
      if (receiptUrlsJson != ignore) 9: receiptUrlsJson as String?,
      if (isAutoDetected != ignore) 10: isAutoDetected as bool?,
      if (itemsJson != ignore) 11: itemsJson as String?,
      if (createdAt != ignore) 12: createdAt as DateTime?,
    });
  }
}

extension UnifiedEntryCollectionQueryUpdate
    on IsarQuery<UnifiedEntryCollection> {
  _UnifiedEntryCollectionQueryUpdate get updateFirst =>
      _UnifiedEntryCollectionQueryUpdateImpl(this, limit: 1);

  _UnifiedEntryCollectionQueryUpdate get updateAll =>
      _UnifiedEntryCollectionQueryUpdateImpl(this);
}

class _UnifiedEntryCollectionQueryBuilderUpdateImpl
    implements _UnifiedEntryCollectionQueryUpdate {
  const _UnifiedEntryCollectionQueryBuilderUpdateImpl(this.query, {this.limit});

  final QueryBuilder<
    UnifiedEntryCollection,
    UnifiedEntryCollection,
    QOperations
  >
  query;
  final int? limit;

  @override
  int call({
    Object? entryId = ignore,
    Object? memberId = ignore,
    Object? date = ignore,
    Object? amount = ignore,
    Object? description = ignore,
    Object? typeIndex = ignore,
    Object? monthlyCategoryIndex = ignore,
    Object? photoUrlsJson = ignore,
    Object? receiptUrlsJson = ignore,
    Object? isAutoDetected = ignore,
    Object? itemsJson = ignore,
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
        if (typeIndex != ignore) 6: typeIndex as int?,
        if (monthlyCategoryIndex != ignore) 7: monthlyCategoryIndex as int?,
        if (photoUrlsJson != ignore) 8: photoUrlsJson as String?,
        if (receiptUrlsJson != ignore) 9: receiptUrlsJson as String?,
        if (isAutoDetected != ignore) 10: isAutoDetected as bool?,
        if (itemsJson != ignore) 11: itemsJson as String?,
        if (createdAt != ignore) 12: createdAt as DateTime?,
      });
    } finally {
      q.close();
    }
  }
}

extension UnifiedEntryCollectionQueryBuilderUpdate
    on
        QueryBuilder<
          UnifiedEntryCollection,
          UnifiedEntryCollection,
          QOperations
        > {
  _UnifiedEntryCollectionQueryUpdate get updateFirst =>
      _UnifiedEntryCollectionQueryBuilderUpdateImpl(this, limit: 1);

  _UnifiedEntryCollectionQueryUpdate get updateAll =>
      _UnifiedEntryCollectionQueryBuilderUpdateImpl(this);
}

extension UnifiedEntryCollectionQueryFilter
    on
        QueryBuilder<
          UnifiedEntryCollection,
          UnifiedEntryCollection,
          QFilterCondition
        > {
  QueryBuilder<
    UnifiedEntryCollection,
    UnifiedEntryCollection,
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
    UnifiedEntryCollection,
    UnifiedEntryCollection,
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
    UnifiedEntryCollection,
    UnifiedEntryCollection,
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
    UnifiedEntryCollection,
    UnifiedEntryCollection,
    QAfterFilterCondition
  >
  idLessThan(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(LessCondition(property: 0, value: value));
    });
  }

  QueryBuilder<
    UnifiedEntryCollection,
    UnifiedEntryCollection,
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
    UnifiedEntryCollection,
    UnifiedEntryCollection,
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
    UnifiedEntryCollection,
    UnifiedEntryCollection,
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
    UnifiedEntryCollection,
    UnifiedEntryCollection,
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
    UnifiedEntryCollection,
    UnifiedEntryCollection,
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
    UnifiedEntryCollection,
    UnifiedEntryCollection,
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
    UnifiedEntryCollection,
    UnifiedEntryCollection,
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
    UnifiedEntryCollection,
    UnifiedEntryCollection,
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
    UnifiedEntryCollection,
    UnifiedEntryCollection,
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
    UnifiedEntryCollection,
    UnifiedEntryCollection,
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
    UnifiedEntryCollection,
    UnifiedEntryCollection,
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
    UnifiedEntryCollection,
    UnifiedEntryCollection,
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
    UnifiedEntryCollection,
    UnifiedEntryCollection,
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
    UnifiedEntryCollection,
    UnifiedEntryCollection,
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
    UnifiedEntryCollection,
    UnifiedEntryCollection,
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
    UnifiedEntryCollection,
    UnifiedEntryCollection,
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
    UnifiedEntryCollection,
    UnifiedEntryCollection,
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
    UnifiedEntryCollection,
    UnifiedEntryCollection,
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
    UnifiedEntryCollection,
    UnifiedEntryCollection,
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
    UnifiedEntryCollection,
    UnifiedEntryCollection,
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
    UnifiedEntryCollection,
    UnifiedEntryCollection,
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
    UnifiedEntryCollection,
    UnifiedEntryCollection,
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
    UnifiedEntryCollection,
    UnifiedEntryCollection,
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
    UnifiedEntryCollection,
    UnifiedEntryCollection,
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
    UnifiedEntryCollection,
    UnifiedEntryCollection,
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
    UnifiedEntryCollection,
    UnifiedEntryCollection,
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
    UnifiedEntryCollection,
    UnifiedEntryCollection,
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
    UnifiedEntryCollection,
    UnifiedEntryCollection,
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
    UnifiedEntryCollection,
    UnifiedEntryCollection,
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
    UnifiedEntryCollection,
    UnifiedEntryCollection,
    QAfterFilterCondition
  >
  dateLessThan(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(LessCondition(property: 3, value: value));
    });
  }

  QueryBuilder<
    UnifiedEntryCollection,
    UnifiedEntryCollection,
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
    UnifiedEntryCollection,
    UnifiedEntryCollection,
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
    UnifiedEntryCollection,
    UnifiedEntryCollection,
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
    UnifiedEntryCollection,
    UnifiedEntryCollection,
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
    UnifiedEntryCollection,
    UnifiedEntryCollection,
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
    UnifiedEntryCollection,
    UnifiedEntryCollection,
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
    UnifiedEntryCollection,
    UnifiedEntryCollection,
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
    UnifiedEntryCollection,
    UnifiedEntryCollection,
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
    UnifiedEntryCollection,
    UnifiedEntryCollection,
    QAfterFilterCondition
  >
  descriptionIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const IsNullCondition(property: 5));
    });
  }

  QueryBuilder<
    UnifiedEntryCollection,
    UnifiedEntryCollection,
    QAfterFilterCondition
  >
  descriptionIsNotNull() {
    return QueryBuilder.apply(not(), (query) {
      return query.addFilterCondition(const IsNullCondition(property: 5));
    });
  }

  QueryBuilder<
    UnifiedEntryCollection,
    UnifiedEntryCollection,
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
    UnifiedEntryCollection,
    UnifiedEntryCollection,
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
    UnifiedEntryCollection,
    UnifiedEntryCollection,
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
    UnifiedEntryCollection,
    UnifiedEntryCollection,
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
    UnifiedEntryCollection,
    UnifiedEntryCollection,
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
    UnifiedEntryCollection,
    UnifiedEntryCollection,
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
    UnifiedEntryCollection,
    UnifiedEntryCollection,
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
    UnifiedEntryCollection,
    UnifiedEntryCollection,
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
    UnifiedEntryCollection,
    UnifiedEntryCollection,
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
    UnifiedEntryCollection,
    UnifiedEntryCollection,
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
    UnifiedEntryCollection,
    UnifiedEntryCollection,
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
    UnifiedEntryCollection,
    UnifiedEntryCollection,
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
    UnifiedEntryCollection,
    UnifiedEntryCollection,
    QAfterFilterCondition
  >
  typeIndexEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(property: 6, value: value),
      );
    });
  }

  QueryBuilder<
    UnifiedEntryCollection,
    UnifiedEntryCollection,
    QAfterFilterCondition
  >
  typeIndexGreaterThan(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(property: 6, value: value),
      );
    });
  }

  QueryBuilder<
    UnifiedEntryCollection,
    UnifiedEntryCollection,
    QAfterFilterCondition
  >
  typeIndexGreaterThanOrEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(property: 6, value: value),
      );
    });
  }

  QueryBuilder<
    UnifiedEntryCollection,
    UnifiedEntryCollection,
    QAfterFilterCondition
  >
  typeIndexLessThan(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(LessCondition(property: 6, value: value));
    });
  }

  QueryBuilder<
    UnifiedEntryCollection,
    UnifiedEntryCollection,
    QAfterFilterCondition
  >
  typeIndexLessThanOrEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(property: 6, value: value),
      );
    });
  }

  QueryBuilder<
    UnifiedEntryCollection,
    UnifiedEntryCollection,
    QAfterFilterCondition
  >
  typeIndexBetween(int lower, int upper) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(property: 6, lower: lower, upper: upper),
      );
    });
  }

  QueryBuilder<
    UnifiedEntryCollection,
    UnifiedEntryCollection,
    QAfterFilterCondition
  >
  monthlyCategoryIndexEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(property: 7, value: value),
      );
    });
  }

  QueryBuilder<
    UnifiedEntryCollection,
    UnifiedEntryCollection,
    QAfterFilterCondition
  >
  monthlyCategoryIndexGreaterThan(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(property: 7, value: value),
      );
    });
  }

  QueryBuilder<
    UnifiedEntryCollection,
    UnifiedEntryCollection,
    QAfterFilterCondition
  >
  monthlyCategoryIndexGreaterThanOrEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(property: 7, value: value),
      );
    });
  }

  QueryBuilder<
    UnifiedEntryCollection,
    UnifiedEntryCollection,
    QAfterFilterCondition
  >
  monthlyCategoryIndexLessThan(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(LessCondition(property: 7, value: value));
    });
  }

  QueryBuilder<
    UnifiedEntryCollection,
    UnifiedEntryCollection,
    QAfterFilterCondition
  >
  monthlyCategoryIndexLessThanOrEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(property: 7, value: value),
      );
    });
  }

  QueryBuilder<
    UnifiedEntryCollection,
    UnifiedEntryCollection,
    QAfterFilterCondition
  >
  monthlyCategoryIndexBetween(int lower, int upper) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(property: 7, lower: lower, upper: upper),
      );
    });
  }

  QueryBuilder<
    UnifiedEntryCollection,
    UnifiedEntryCollection,
    QAfterFilterCondition
  >
  photoUrlsJsonIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const IsNullCondition(property: 8));
    });
  }

  QueryBuilder<
    UnifiedEntryCollection,
    UnifiedEntryCollection,
    QAfterFilterCondition
  >
  photoUrlsJsonIsNotNull() {
    return QueryBuilder.apply(not(), (query) {
      return query.addFilterCondition(const IsNullCondition(property: 8));
    });
  }

  QueryBuilder<
    UnifiedEntryCollection,
    UnifiedEntryCollection,
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
    UnifiedEntryCollection,
    UnifiedEntryCollection,
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
    UnifiedEntryCollection,
    UnifiedEntryCollection,
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
    UnifiedEntryCollection,
    UnifiedEntryCollection,
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
    UnifiedEntryCollection,
    UnifiedEntryCollection,
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
    UnifiedEntryCollection,
    UnifiedEntryCollection,
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
    UnifiedEntryCollection,
    UnifiedEntryCollection,
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
    UnifiedEntryCollection,
    UnifiedEntryCollection,
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
    UnifiedEntryCollection,
    UnifiedEntryCollection,
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
    UnifiedEntryCollection,
    UnifiedEntryCollection,
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
    UnifiedEntryCollection,
    UnifiedEntryCollection,
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
    UnifiedEntryCollection,
    UnifiedEntryCollection,
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
    UnifiedEntryCollection,
    UnifiedEntryCollection,
    QAfterFilterCondition
  >
  receiptUrlsJsonIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const IsNullCondition(property: 9));
    });
  }

  QueryBuilder<
    UnifiedEntryCollection,
    UnifiedEntryCollection,
    QAfterFilterCondition
  >
  receiptUrlsJsonIsNotNull() {
    return QueryBuilder.apply(not(), (query) {
      return query.addFilterCondition(const IsNullCondition(property: 9));
    });
  }

  QueryBuilder<
    UnifiedEntryCollection,
    UnifiedEntryCollection,
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
    UnifiedEntryCollection,
    UnifiedEntryCollection,
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
    UnifiedEntryCollection,
    UnifiedEntryCollection,
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
    UnifiedEntryCollection,
    UnifiedEntryCollection,
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
    UnifiedEntryCollection,
    UnifiedEntryCollection,
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
    UnifiedEntryCollection,
    UnifiedEntryCollection,
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
    UnifiedEntryCollection,
    UnifiedEntryCollection,
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
    UnifiedEntryCollection,
    UnifiedEntryCollection,
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
    UnifiedEntryCollection,
    UnifiedEntryCollection,
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
    UnifiedEntryCollection,
    UnifiedEntryCollection,
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
    UnifiedEntryCollection,
    UnifiedEntryCollection,
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
    UnifiedEntryCollection,
    UnifiedEntryCollection,
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
    UnifiedEntryCollection,
    UnifiedEntryCollection,
    QAfterFilterCondition
  >
  isAutoDetectedEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(property: 10, value: value),
      );
    });
  }

  QueryBuilder<
    UnifiedEntryCollection,
    UnifiedEntryCollection,
    QAfterFilterCondition
  >
  itemsJsonIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const IsNullCondition(property: 11));
    });
  }

  QueryBuilder<
    UnifiedEntryCollection,
    UnifiedEntryCollection,
    QAfterFilterCondition
  >
  itemsJsonIsNotNull() {
    return QueryBuilder.apply(not(), (query) {
      return query.addFilterCondition(const IsNullCondition(property: 11));
    });
  }

  QueryBuilder<
    UnifiedEntryCollection,
    UnifiedEntryCollection,
    QAfterFilterCondition
  >
  itemsJsonEqualTo(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(
          property: 11,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    UnifiedEntryCollection,
    UnifiedEntryCollection,
    QAfterFilterCondition
  >
  itemsJsonGreaterThan(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(
          property: 11,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    UnifiedEntryCollection,
    UnifiedEntryCollection,
    QAfterFilterCondition
  >
  itemsJsonGreaterThanOrEqualTo(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(
          property: 11,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    UnifiedEntryCollection,
    UnifiedEntryCollection,
    QAfterFilterCondition
  >
  itemsJsonLessThan(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(property: 11, value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<
    UnifiedEntryCollection,
    UnifiedEntryCollection,
    QAfterFilterCondition
  >
  itemsJsonLessThanOrEqualTo(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(
          property: 11,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    UnifiedEntryCollection,
    UnifiedEntryCollection,
    QAfterFilterCondition
  >
  itemsJsonBetween(String? lower, String? upper, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(
          property: 11,
          lower: lower,
          upper: upper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    UnifiedEntryCollection,
    UnifiedEntryCollection,
    QAfterFilterCondition
  >
  itemsJsonStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        StartsWithCondition(
          property: 11,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    UnifiedEntryCollection,
    UnifiedEntryCollection,
    QAfterFilterCondition
  >
  itemsJsonEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EndsWithCondition(
          property: 11,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    UnifiedEntryCollection,
    UnifiedEntryCollection,
    QAfterFilterCondition
  >
  itemsJsonContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        ContainsCondition(
          property: 11,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    UnifiedEntryCollection,
    UnifiedEntryCollection,
    QAfterFilterCondition
  >
  itemsJsonMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        MatchesCondition(
          property: 11,
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    UnifiedEntryCollection,
    UnifiedEntryCollection,
    QAfterFilterCondition
  >
  itemsJsonIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const EqualCondition(property: 11, value: ''),
      );
    });
  }

  QueryBuilder<
    UnifiedEntryCollection,
    UnifiedEntryCollection,
    QAfterFilterCondition
  >
  itemsJsonIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const GreaterCondition(property: 11, value: ''),
      );
    });
  }

  QueryBuilder<
    UnifiedEntryCollection,
    UnifiedEntryCollection,
    QAfterFilterCondition
  >
  createdAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const IsNullCondition(property: 12));
    });
  }

  QueryBuilder<
    UnifiedEntryCollection,
    UnifiedEntryCollection,
    QAfterFilterCondition
  >
  createdAtIsNotNull() {
    return QueryBuilder.apply(not(), (query) {
      return query.addFilterCondition(const IsNullCondition(property: 12));
    });
  }

  QueryBuilder<
    UnifiedEntryCollection,
    UnifiedEntryCollection,
    QAfterFilterCondition
  >
  createdAtEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(property: 12, value: value),
      );
    });
  }

  QueryBuilder<
    UnifiedEntryCollection,
    UnifiedEntryCollection,
    QAfterFilterCondition
  >
  createdAtGreaterThan(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(property: 12, value: value),
      );
    });
  }

  QueryBuilder<
    UnifiedEntryCollection,
    UnifiedEntryCollection,
    QAfterFilterCondition
  >
  createdAtGreaterThanOrEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(property: 12, value: value),
      );
    });
  }

  QueryBuilder<
    UnifiedEntryCollection,
    UnifiedEntryCollection,
    QAfterFilterCondition
  >
  createdAtLessThan(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(property: 12, value: value),
      );
    });
  }

  QueryBuilder<
    UnifiedEntryCollection,
    UnifiedEntryCollection,
    QAfterFilterCondition
  >
  createdAtLessThanOrEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(property: 12, value: value),
      );
    });
  }

  QueryBuilder<
    UnifiedEntryCollection,
    UnifiedEntryCollection,
    QAfterFilterCondition
  >
  createdAtBetween(DateTime? lower, DateTime? upper) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(property: 12, lower: lower, upper: upper),
      );
    });
  }
}

extension UnifiedEntryCollectionQueryObject
    on
        QueryBuilder<
          UnifiedEntryCollection,
          UnifiedEntryCollection,
          QFilterCondition
        > {}

extension UnifiedEntryCollectionQuerySortBy
    on QueryBuilder<UnifiedEntryCollection, UnifiedEntryCollection, QSortBy> {
  QueryBuilder<UnifiedEntryCollection, UnifiedEntryCollection, QAfterSortBy>
  sortById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(0);
    });
  }

  QueryBuilder<UnifiedEntryCollection, UnifiedEntryCollection, QAfterSortBy>
  sortByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(0, sort: Sort.desc);
    });
  }

  QueryBuilder<UnifiedEntryCollection, UnifiedEntryCollection, QAfterSortBy>
  sortByEntryId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(1, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<UnifiedEntryCollection, UnifiedEntryCollection, QAfterSortBy>
  sortByEntryIdDesc({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(1, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<UnifiedEntryCollection, UnifiedEntryCollection, QAfterSortBy>
  sortByMemberId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(2, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<UnifiedEntryCollection, UnifiedEntryCollection, QAfterSortBy>
  sortByMemberIdDesc({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(2, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<UnifiedEntryCollection, UnifiedEntryCollection, QAfterSortBy>
  sortByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(3);
    });
  }

  QueryBuilder<UnifiedEntryCollection, UnifiedEntryCollection, QAfterSortBy>
  sortByDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(3, sort: Sort.desc);
    });
  }

  QueryBuilder<UnifiedEntryCollection, UnifiedEntryCollection, QAfterSortBy>
  sortByAmount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(4);
    });
  }

  QueryBuilder<UnifiedEntryCollection, UnifiedEntryCollection, QAfterSortBy>
  sortByAmountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(4, sort: Sort.desc);
    });
  }

  QueryBuilder<UnifiedEntryCollection, UnifiedEntryCollection, QAfterSortBy>
  sortByDescription({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(5, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<UnifiedEntryCollection, UnifiedEntryCollection, QAfterSortBy>
  sortByDescriptionDesc({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(5, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<UnifiedEntryCollection, UnifiedEntryCollection, QAfterSortBy>
  sortByTypeIndex() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(6);
    });
  }

  QueryBuilder<UnifiedEntryCollection, UnifiedEntryCollection, QAfterSortBy>
  sortByTypeIndexDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(6, sort: Sort.desc);
    });
  }

  QueryBuilder<UnifiedEntryCollection, UnifiedEntryCollection, QAfterSortBy>
  sortByMonthlyCategoryIndex() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(7);
    });
  }

  QueryBuilder<UnifiedEntryCollection, UnifiedEntryCollection, QAfterSortBy>
  sortByMonthlyCategoryIndexDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(7, sort: Sort.desc);
    });
  }

  QueryBuilder<UnifiedEntryCollection, UnifiedEntryCollection, QAfterSortBy>
  sortByPhotoUrlsJson({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(8, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<UnifiedEntryCollection, UnifiedEntryCollection, QAfterSortBy>
  sortByPhotoUrlsJsonDesc({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(8, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<UnifiedEntryCollection, UnifiedEntryCollection, QAfterSortBy>
  sortByReceiptUrlsJson({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(9, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<UnifiedEntryCollection, UnifiedEntryCollection, QAfterSortBy>
  sortByReceiptUrlsJsonDesc({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(9, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<UnifiedEntryCollection, UnifiedEntryCollection, QAfterSortBy>
  sortByIsAutoDetected() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(10);
    });
  }

  QueryBuilder<UnifiedEntryCollection, UnifiedEntryCollection, QAfterSortBy>
  sortByIsAutoDetectedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(10, sort: Sort.desc);
    });
  }

  QueryBuilder<UnifiedEntryCollection, UnifiedEntryCollection, QAfterSortBy>
  sortByItemsJson({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(11, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<UnifiedEntryCollection, UnifiedEntryCollection, QAfterSortBy>
  sortByItemsJsonDesc({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(11, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<UnifiedEntryCollection, UnifiedEntryCollection, QAfterSortBy>
  sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(12);
    });
  }

  QueryBuilder<UnifiedEntryCollection, UnifiedEntryCollection, QAfterSortBy>
  sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(12, sort: Sort.desc);
    });
  }
}

extension UnifiedEntryCollectionQuerySortThenBy
    on
        QueryBuilder<
          UnifiedEntryCollection,
          UnifiedEntryCollection,
          QSortThenBy
        > {
  QueryBuilder<UnifiedEntryCollection, UnifiedEntryCollection, QAfterSortBy>
  thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(0);
    });
  }

  QueryBuilder<UnifiedEntryCollection, UnifiedEntryCollection, QAfterSortBy>
  thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(0, sort: Sort.desc);
    });
  }

  QueryBuilder<UnifiedEntryCollection, UnifiedEntryCollection, QAfterSortBy>
  thenByEntryId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(1, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<UnifiedEntryCollection, UnifiedEntryCollection, QAfterSortBy>
  thenByEntryIdDesc({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(1, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<UnifiedEntryCollection, UnifiedEntryCollection, QAfterSortBy>
  thenByMemberId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(2, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<UnifiedEntryCollection, UnifiedEntryCollection, QAfterSortBy>
  thenByMemberIdDesc({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(2, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<UnifiedEntryCollection, UnifiedEntryCollection, QAfterSortBy>
  thenByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(3);
    });
  }

  QueryBuilder<UnifiedEntryCollection, UnifiedEntryCollection, QAfterSortBy>
  thenByDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(3, sort: Sort.desc);
    });
  }

  QueryBuilder<UnifiedEntryCollection, UnifiedEntryCollection, QAfterSortBy>
  thenByAmount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(4);
    });
  }

  QueryBuilder<UnifiedEntryCollection, UnifiedEntryCollection, QAfterSortBy>
  thenByAmountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(4, sort: Sort.desc);
    });
  }

  QueryBuilder<UnifiedEntryCollection, UnifiedEntryCollection, QAfterSortBy>
  thenByDescription({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(5, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<UnifiedEntryCollection, UnifiedEntryCollection, QAfterSortBy>
  thenByDescriptionDesc({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(5, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<UnifiedEntryCollection, UnifiedEntryCollection, QAfterSortBy>
  thenByTypeIndex() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(6);
    });
  }

  QueryBuilder<UnifiedEntryCollection, UnifiedEntryCollection, QAfterSortBy>
  thenByTypeIndexDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(6, sort: Sort.desc);
    });
  }

  QueryBuilder<UnifiedEntryCollection, UnifiedEntryCollection, QAfterSortBy>
  thenByMonthlyCategoryIndex() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(7);
    });
  }

  QueryBuilder<UnifiedEntryCollection, UnifiedEntryCollection, QAfterSortBy>
  thenByMonthlyCategoryIndexDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(7, sort: Sort.desc);
    });
  }

  QueryBuilder<UnifiedEntryCollection, UnifiedEntryCollection, QAfterSortBy>
  thenByPhotoUrlsJson({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(8, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<UnifiedEntryCollection, UnifiedEntryCollection, QAfterSortBy>
  thenByPhotoUrlsJsonDesc({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(8, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<UnifiedEntryCollection, UnifiedEntryCollection, QAfterSortBy>
  thenByReceiptUrlsJson({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(9, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<UnifiedEntryCollection, UnifiedEntryCollection, QAfterSortBy>
  thenByReceiptUrlsJsonDesc({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(9, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<UnifiedEntryCollection, UnifiedEntryCollection, QAfterSortBy>
  thenByIsAutoDetected() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(10);
    });
  }

  QueryBuilder<UnifiedEntryCollection, UnifiedEntryCollection, QAfterSortBy>
  thenByIsAutoDetectedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(10, sort: Sort.desc);
    });
  }

  QueryBuilder<UnifiedEntryCollection, UnifiedEntryCollection, QAfterSortBy>
  thenByItemsJson({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(11, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<UnifiedEntryCollection, UnifiedEntryCollection, QAfterSortBy>
  thenByItemsJsonDesc({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(11, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<UnifiedEntryCollection, UnifiedEntryCollection, QAfterSortBy>
  thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(12);
    });
  }

  QueryBuilder<UnifiedEntryCollection, UnifiedEntryCollection, QAfterSortBy>
  thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(12, sort: Sort.desc);
    });
  }
}

extension UnifiedEntryCollectionQueryWhereDistinct
    on QueryBuilder<UnifiedEntryCollection, UnifiedEntryCollection, QDistinct> {
  QueryBuilder<UnifiedEntryCollection, UnifiedEntryCollection, QAfterDistinct>
  distinctByEntryId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(1, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<UnifiedEntryCollection, UnifiedEntryCollection, QAfterDistinct>
  distinctByMemberId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(2, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<UnifiedEntryCollection, UnifiedEntryCollection, QAfterDistinct>
  distinctByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(3);
    });
  }

  QueryBuilder<UnifiedEntryCollection, UnifiedEntryCollection, QAfterDistinct>
  distinctByAmount() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(4);
    });
  }

  QueryBuilder<UnifiedEntryCollection, UnifiedEntryCollection, QAfterDistinct>
  distinctByDescription({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(5, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<UnifiedEntryCollection, UnifiedEntryCollection, QAfterDistinct>
  distinctByTypeIndex() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(6);
    });
  }

  QueryBuilder<UnifiedEntryCollection, UnifiedEntryCollection, QAfterDistinct>
  distinctByMonthlyCategoryIndex() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(7);
    });
  }

  QueryBuilder<UnifiedEntryCollection, UnifiedEntryCollection, QAfterDistinct>
  distinctByPhotoUrlsJson({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(8, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<UnifiedEntryCollection, UnifiedEntryCollection, QAfterDistinct>
  distinctByReceiptUrlsJson({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(9, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<UnifiedEntryCollection, UnifiedEntryCollection, QAfterDistinct>
  distinctByIsAutoDetected() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(10);
    });
  }

  QueryBuilder<UnifiedEntryCollection, UnifiedEntryCollection, QAfterDistinct>
  distinctByItemsJson({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(11, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<UnifiedEntryCollection, UnifiedEntryCollection, QAfterDistinct>
  distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(12);
    });
  }
}

extension UnifiedEntryCollectionQueryProperty1
    on QueryBuilder<UnifiedEntryCollection, UnifiedEntryCollection, QProperty> {
  QueryBuilder<UnifiedEntryCollection, int, QAfterProperty> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(0);
    });
  }

  QueryBuilder<UnifiedEntryCollection, String, QAfterProperty>
  entryIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(1);
    });
  }

  QueryBuilder<UnifiedEntryCollection, String, QAfterProperty>
  memberIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(2);
    });
  }

  QueryBuilder<UnifiedEntryCollection, DateTime, QAfterProperty>
  dateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(3);
    });
  }

  QueryBuilder<UnifiedEntryCollection, double, QAfterProperty>
  amountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(4);
    });
  }

  QueryBuilder<UnifiedEntryCollection, String?, QAfterProperty>
  descriptionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(5);
    });
  }

  QueryBuilder<UnifiedEntryCollection, int, QAfterProperty>
  typeIndexProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(6);
    });
  }

  QueryBuilder<UnifiedEntryCollection, int, QAfterProperty>
  monthlyCategoryIndexProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(7);
    });
  }

  QueryBuilder<UnifiedEntryCollection, String?, QAfterProperty>
  photoUrlsJsonProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(8);
    });
  }

  QueryBuilder<UnifiedEntryCollection, String?, QAfterProperty>
  receiptUrlsJsonProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(9);
    });
  }

  QueryBuilder<UnifiedEntryCollection, bool, QAfterProperty>
  isAutoDetectedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(10);
    });
  }

  QueryBuilder<UnifiedEntryCollection, String?, QAfterProperty>
  itemsJsonProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(11);
    });
  }

  QueryBuilder<UnifiedEntryCollection, DateTime?, QAfterProperty>
  createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(12);
    });
  }
}

extension UnifiedEntryCollectionQueryProperty2<R>
    on QueryBuilder<UnifiedEntryCollection, R, QAfterProperty> {
  QueryBuilder<UnifiedEntryCollection, (R, int), QAfterProperty> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(0);
    });
  }

  QueryBuilder<UnifiedEntryCollection, (R, String), QAfterProperty>
  entryIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(1);
    });
  }

  QueryBuilder<UnifiedEntryCollection, (R, String), QAfterProperty>
  memberIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(2);
    });
  }

  QueryBuilder<UnifiedEntryCollection, (R, DateTime), QAfterProperty>
  dateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(3);
    });
  }

  QueryBuilder<UnifiedEntryCollection, (R, double), QAfterProperty>
  amountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(4);
    });
  }

  QueryBuilder<UnifiedEntryCollection, (R, String?), QAfterProperty>
  descriptionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(5);
    });
  }

  QueryBuilder<UnifiedEntryCollection, (R, int), QAfterProperty>
  typeIndexProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(6);
    });
  }

  QueryBuilder<UnifiedEntryCollection, (R, int), QAfterProperty>
  monthlyCategoryIndexProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(7);
    });
  }

  QueryBuilder<UnifiedEntryCollection, (R, String?), QAfterProperty>
  photoUrlsJsonProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(8);
    });
  }

  QueryBuilder<UnifiedEntryCollection, (R, String?), QAfterProperty>
  receiptUrlsJsonProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(9);
    });
  }

  QueryBuilder<UnifiedEntryCollection, (R, bool), QAfterProperty>
  isAutoDetectedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(10);
    });
  }

  QueryBuilder<UnifiedEntryCollection, (R, String?), QAfterProperty>
  itemsJsonProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(11);
    });
  }

  QueryBuilder<UnifiedEntryCollection, (R, DateTime?), QAfterProperty>
  createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(12);
    });
  }
}

extension UnifiedEntryCollectionQueryProperty3<R1, R2>
    on QueryBuilder<UnifiedEntryCollection, (R1, R2), QAfterProperty> {
  QueryBuilder<UnifiedEntryCollection, (R1, R2, int), QOperations>
  idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(0);
    });
  }

  QueryBuilder<UnifiedEntryCollection, (R1, R2, String), QOperations>
  entryIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(1);
    });
  }

  QueryBuilder<UnifiedEntryCollection, (R1, R2, String), QOperations>
  memberIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(2);
    });
  }

  QueryBuilder<UnifiedEntryCollection, (R1, R2, DateTime), QOperations>
  dateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(3);
    });
  }

  QueryBuilder<UnifiedEntryCollection, (R1, R2, double), QOperations>
  amountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(4);
    });
  }

  QueryBuilder<UnifiedEntryCollection, (R1, R2, String?), QOperations>
  descriptionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(5);
    });
  }

  QueryBuilder<UnifiedEntryCollection, (R1, R2, int), QOperations>
  typeIndexProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(6);
    });
  }

  QueryBuilder<UnifiedEntryCollection, (R1, R2, int), QOperations>
  monthlyCategoryIndexProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(7);
    });
  }

  QueryBuilder<UnifiedEntryCollection, (R1, R2, String?), QOperations>
  photoUrlsJsonProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(8);
    });
  }

  QueryBuilder<UnifiedEntryCollection, (R1, R2, String?), QOperations>
  receiptUrlsJsonProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(9);
    });
  }

  QueryBuilder<UnifiedEntryCollection, (R1, R2, bool), QOperations>
  isAutoDetectedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(10);
    });
  }

  QueryBuilder<UnifiedEntryCollection, (R1, R2, String?), QOperations>
  itemsJsonProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(11);
    });
  }

  QueryBuilder<UnifiedEntryCollection, (R1, R2, DateTime?), QOperations>
  createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(12);
    });
  }
}
