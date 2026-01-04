// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ramadan_collection.dart';

// **************************************************************************
// _IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, invalid_use_of_protected_member, lines_longer_than_80_chars, constant_identifier_names, avoid_js_rounded_ints, no_leading_underscores_for_local_identifiers, require_trailing_commas, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_in_if_null_operators, library_private_types_in_public_api, prefer_const_constructors
// ignore_for_file: type=lint

extension GetRamadanSeasonCollectionCollection on Isar {
  IsarCollection<int, RamadanSeasonCollection> get ramadanSeasonCollections =>
      this.collection();
}

final RamadanSeasonCollectionSchema = IsarGeneratedSchema(
  schema: IsarSchema(
    name: 'RamadanSeasonCollection',
    idName: 'id',
    embedded: false,
    properties: [
      IsarPropertySchema(name: 'seasonId', type: IsarType.string),
      IsarPropertySchema(name: 'messId', type: IsarType.string),
      IsarPropertySchema(name: 'startDate', type: IsarType.dateTime),
      IsarPropertySchema(name: 'endDate', type: IsarType.dateTime),
      IsarPropertySchema(name: 'year', type: IsarType.long),
      IsarPropertySchema(name: 'optedInMemberIdsJson', type: IsarType.string),
      IsarPropertySchema(name: 'isActive', type: IsarType.bool),
      IsarPropertySchema(name: 'isSettled', type: IsarType.bool),
      IsarPropertySchema(name: 'createdAt', type: IsarType.dateTime),
    ],
    indexes: [
      IsarIndexSchema(
        name: 'seasonId',
        properties: ["seasonId"],
        unique: false,
        hash: false,
      ),
    ],
  ),
  converter: IsarObjectConverter<int, RamadanSeasonCollection>(
    serialize: serializeRamadanSeasonCollection,
    deserialize: deserializeRamadanSeasonCollection,
    deserializeProperty: deserializeRamadanSeasonCollectionProp,
  ),
  getEmbeddedSchemas: () => [],
);

@isarProtected
int serializeRamadanSeasonCollection(
  IsarWriter writer,
  RamadanSeasonCollection object,
) {
  IsarCore.writeString(writer, 1, object.seasonId);
  IsarCore.writeString(writer, 2, object.messId);
  IsarCore.writeLong(
    writer,
    3,
    object.startDate.toUtc().microsecondsSinceEpoch,
  );
  IsarCore.writeLong(writer, 4, object.endDate.toUtc().microsecondsSinceEpoch);
  IsarCore.writeLong(writer, 5, object.year);
  IsarCore.writeString(writer, 6, object.optedInMemberIdsJson);
  IsarCore.writeBool(writer, 7, value: object.isActive);
  IsarCore.writeBool(writer, 8, value: object.isSettled);
  IsarCore.writeLong(
    writer,
    9,
    object.createdAt?.toUtc().microsecondsSinceEpoch ?? -9223372036854775808,
  );
  return object.id;
}

@isarProtected
RamadanSeasonCollection deserializeRamadanSeasonCollection(IsarReader reader) {
  final object = RamadanSeasonCollection();
  object.id = IsarCore.readId(reader);
  object.seasonId = IsarCore.readString(reader, 1) ?? '';
  object.messId = IsarCore.readString(reader, 2) ?? '';
  {
    final value = IsarCore.readLong(reader, 3);
    if (value == -9223372036854775808) {
      object.startDate = DateTime.fromMillisecondsSinceEpoch(
        0,
        isUtc: true,
      ).toLocal();
    } else {
      object.startDate = DateTime.fromMicrosecondsSinceEpoch(
        value,
        isUtc: true,
      ).toLocal();
    }
  }
  {
    final value = IsarCore.readLong(reader, 4);
    if (value == -9223372036854775808) {
      object.endDate = DateTime.fromMillisecondsSinceEpoch(
        0,
        isUtc: true,
      ).toLocal();
    } else {
      object.endDate = DateTime.fromMicrosecondsSinceEpoch(
        value,
        isUtc: true,
      ).toLocal();
    }
  }
  object.year = IsarCore.readLong(reader, 5);
  object.optedInMemberIdsJson = IsarCore.readString(reader, 6) ?? '';
  object.isActive = IsarCore.readBool(reader, 7);
  object.isSettled = IsarCore.readBool(reader, 8);
  {
    final value = IsarCore.readLong(reader, 9);
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
dynamic deserializeRamadanSeasonCollectionProp(
  IsarReader reader,
  int property,
) {
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
      {
        final value = IsarCore.readLong(reader, 4);
        if (value == -9223372036854775808) {
          return DateTime.fromMillisecondsSinceEpoch(0, isUtc: true).toLocal();
        } else {
          return DateTime.fromMicrosecondsSinceEpoch(
            value,
            isUtc: true,
          ).toLocal();
        }
      }
    case 5:
      return IsarCore.readLong(reader, 5);
    case 6:
      return IsarCore.readString(reader, 6) ?? '';
    case 7:
      return IsarCore.readBool(reader, 7);
    case 8:
      return IsarCore.readBool(reader, 8);
    case 9:
      {
        final value = IsarCore.readLong(reader, 9);
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

sealed class _RamadanSeasonCollectionUpdate {
  bool call({
    required int id,
    String? seasonId,
    String? messId,
    DateTime? startDate,
    DateTime? endDate,
    int? year,
    String? optedInMemberIdsJson,
    bool? isActive,
    bool? isSettled,
    DateTime? createdAt,
  });
}

class _RamadanSeasonCollectionUpdateImpl
    implements _RamadanSeasonCollectionUpdate {
  const _RamadanSeasonCollectionUpdateImpl(this.collection);

  final IsarCollection<int, RamadanSeasonCollection> collection;

  @override
  bool call({
    required int id,
    Object? seasonId = ignore,
    Object? messId = ignore,
    Object? startDate = ignore,
    Object? endDate = ignore,
    Object? year = ignore,
    Object? optedInMemberIdsJson = ignore,
    Object? isActive = ignore,
    Object? isSettled = ignore,
    Object? createdAt = ignore,
  }) {
    return collection.updateProperties(
          [id],
          {
            if (seasonId != ignore) 1: seasonId as String?,
            if (messId != ignore) 2: messId as String?,
            if (startDate != ignore) 3: startDate as DateTime?,
            if (endDate != ignore) 4: endDate as DateTime?,
            if (year != ignore) 5: year as int?,
            if (optedInMemberIdsJson != ignore)
              6: optedInMemberIdsJson as String?,
            if (isActive != ignore) 7: isActive as bool?,
            if (isSettled != ignore) 8: isSettled as bool?,
            if (createdAt != ignore) 9: createdAt as DateTime?,
          },
        ) >
        0;
  }
}

sealed class _RamadanSeasonCollectionUpdateAll {
  int call({
    required List<int> id,
    String? seasonId,
    String? messId,
    DateTime? startDate,
    DateTime? endDate,
    int? year,
    String? optedInMemberIdsJson,
    bool? isActive,
    bool? isSettled,
    DateTime? createdAt,
  });
}

class _RamadanSeasonCollectionUpdateAllImpl
    implements _RamadanSeasonCollectionUpdateAll {
  const _RamadanSeasonCollectionUpdateAllImpl(this.collection);

  final IsarCollection<int, RamadanSeasonCollection> collection;

  @override
  int call({
    required List<int> id,
    Object? seasonId = ignore,
    Object? messId = ignore,
    Object? startDate = ignore,
    Object? endDate = ignore,
    Object? year = ignore,
    Object? optedInMemberIdsJson = ignore,
    Object? isActive = ignore,
    Object? isSettled = ignore,
    Object? createdAt = ignore,
  }) {
    return collection.updateProperties(id, {
      if (seasonId != ignore) 1: seasonId as String?,
      if (messId != ignore) 2: messId as String?,
      if (startDate != ignore) 3: startDate as DateTime?,
      if (endDate != ignore) 4: endDate as DateTime?,
      if (year != ignore) 5: year as int?,
      if (optedInMemberIdsJson != ignore) 6: optedInMemberIdsJson as String?,
      if (isActive != ignore) 7: isActive as bool?,
      if (isSettled != ignore) 8: isSettled as bool?,
      if (createdAt != ignore) 9: createdAt as DateTime?,
    });
  }
}

extension RamadanSeasonCollectionUpdate
    on IsarCollection<int, RamadanSeasonCollection> {
  _RamadanSeasonCollectionUpdate get update =>
      _RamadanSeasonCollectionUpdateImpl(this);

  _RamadanSeasonCollectionUpdateAll get updateAll =>
      _RamadanSeasonCollectionUpdateAllImpl(this);
}

sealed class _RamadanSeasonCollectionQueryUpdate {
  int call({
    String? seasonId,
    String? messId,
    DateTime? startDate,
    DateTime? endDate,
    int? year,
    String? optedInMemberIdsJson,
    bool? isActive,
    bool? isSettled,
    DateTime? createdAt,
  });
}

class _RamadanSeasonCollectionQueryUpdateImpl
    implements _RamadanSeasonCollectionQueryUpdate {
  const _RamadanSeasonCollectionQueryUpdateImpl(this.query, {this.limit});

  final IsarQuery<RamadanSeasonCollection> query;
  final int? limit;

  @override
  int call({
    Object? seasonId = ignore,
    Object? messId = ignore,
    Object? startDate = ignore,
    Object? endDate = ignore,
    Object? year = ignore,
    Object? optedInMemberIdsJson = ignore,
    Object? isActive = ignore,
    Object? isSettled = ignore,
    Object? createdAt = ignore,
  }) {
    return query.updateProperties(limit: limit, {
      if (seasonId != ignore) 1: seasonId as String?,
      if (messId != ignore) 2: messId as String?,
      if (startDate != ignore) 3: startDate as DateTime?,
      if (endDate != ignore) 4: endDate as DateTime?,
      if (year != ignore) 5: year as int?,
      if (optedInMemberIdsJson != ignore) 6: optedInMemberIdsJson as String?,
      if (isActive != ignore) 7: isActive as bool?,
      if (isSettled != ignore) 8: isSettled as bool?,
      if (createdAt != ignore) 9: createdAt as DateTime?,
    });
  }
}

extension RamadanSeasonCollectionQueryUpdate
    on IsarQuery<RamadanSeasonCollection> {
  _RamadanSeasonCollectionQueryUpdate get updateFirst =>
      _RamadanSeasonCollectionQueryUpdateImpl(this, limit: 1);

  _RamadanSeasonCollectionQueryUpdate get updateAll =>
      _RamadanSeasonCollectionQueryUpdateImpl(this);
}

class _RamadanSeasonCollectionQueryBuilderUpdateImpl
    implements _RamadanSeasonCollectionQueryUpdate {
  const _RamadanSeasonCollectionQueryBuilderUpdateImpl(
    this.query, {
    this.limit,
  });

  final QueryBuilder<
    RamadanSeasonCollection,
    RamadanSeasonCollection,
    QOperations
  >
  query;
  final int? limit;

  @override
  int call({
    Object? seasonId = ignore,
    Object? messId = ignore,
    Object? startDate = ignore,
    Object? endDate = ignore,
    Object? year = ignore,
    Object? optedInMemberIdsJson = ignore,
    Object? isActive = ignore,
    Object? isSettled = ignore,
    Object? createdAt = ignore,
  }) {
    final q = query.build();
    try {
      return q.updateProperties(limit: limit, {
        if (seasonId != ignore) 1: seasonId as String?,
        if (messId != ignore) 2: messId as String?,
        if (startDate != ignore) 3: startDate as DateTime?,
        if (endDate != ignore) 4: endDate as DateTime?,
        if (year != ignore) 5: year as int?,
        if (optedInMemberIdsJson != ignore) 6: optedInMemberIdsJson as String?,
        if (isActive != ignore) 7: isActive as bool?,
        if (isSettled != ignore) 8: isSettled as bool?,
        if (createdAt != ignore) 9: createdAt as DateTime?,
      });
    } finally {
      q.close();
    }
  }
}

extension RamadanSeasonCollectionQueryBuilderUpdate
    on
        QueryBuilder<
          RamadanSeasonCollection,
          RamadanSeasonCollection,
          QOperations
        > {
  _RamadanSeasonCollectionQueryUpdate get updateFirst =>
      _RamadanSeasonCollectionQueryBuilderUpdateImpl(this, limit: 1);

  _RamadanSeasonCollectionQueryUpdate get updateAll =>
      _RamadanSeasonCollectionQueryBuilderUpdateImpl(this);
}

extension RamadanSeasonCollectionQueryFilter
    on
        QueryBuilder<
          RamadanSeasonCollection,
          RamadanSeasonCollection,
          QFilterCondition
        > {
  QueryBuilder<
    RamadanSeasonCollection,
    RamadanSeasonCollection,
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
    RamadanSeasonCollection,
    RamadanSeasonCollection,
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
    RamadanSeasonCollection,
    RamadanSeasonCollection,
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
    RamadanSeasonCollection,
    RamadanSeasonCollection,
    QAfterFilterCondition
  >
  idLessThan(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(LessCondition(property: 0, value: value));
    });
  }

  QueryBuilder<
    RamadanSeasonCollection,
    RamadanSeasonCollection,
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
    RamadanSeasonCollection,
    RamadanSeasonCollection,
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
    RamadanSeasonCollection,
    RamadanSeasonCollection,
    QAfterFilterCondition
  >
  seasonIdEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(property: 1, value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<
    RamadanSeasonCollection,
    RamadanSeasonCollection,
    QAfterFilterCondition
  >
  seasonIdGreaterThan(String value, {bool caseSensitive = true}) {
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
    RamadanSeasonCollection,
    RamadanSeasonCollection,
    QAfterFilterCondition
  >
  seasonIdGreaterThanOrEqualTo(String value, {bool caseSensitive = true}) {
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
    RamadanSeasonCollection,
    RamadanSeasonCollection,
    QAfterFilterCondition
  >
  seasonIdLessThan(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(property: 1, value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<
    RamadanSeasonCollection,
    RamadanSeasonCollection,
    QAfterFilterCondition
  >
  seasonIdLessThanOrEqualTo(String value, {bool caseSensitive = true}) {
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
    RamadanSeasonCollection,
    RamadanSeasonCollection,
    QAfterFilterCondition
  >
  seasonIdBetween(String lower, String upper, {bool caseSensitive = true}) {
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
    RamadanSeasonCollection,
    RamadanSeasonCollection,
    QAfterFilterCondition
  >
  seasonIdStartsWith(String value, {bool caseSensitive = true}) {
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
    RamadanSeasonCollection,
    RamadanSeasonCollection,
    QAfterFilterCondition
  >
  seasonIdEndsWith(String value, {bool caseSensitive = true}) {
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
    RamadanSeasonCollection,
    RamadanSeasonCollection,
    QAfterFilterCondition
  >
  seasonIdContains(String value, {bool caseSensitive = true}) {
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
    RamadanSeasonCollection,
    RamadanSeasonCollection,
    QAfterFilterCondition
  >
  seasonIdMatches(String pattern, {bool caseSensitive = true}) {
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
    RamadanSeasonCollection,
    RamadanSeasonCollection,
    QAfterFilterCondition
  >
  seasonIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const EqualCondition(property: 1, value: ''),
      );
    });
  }

  QueryBuilder<
    RamadanSeasonCollection,
    RamadanSeasonCollection,
    QAfterFilterCondition
  >
  seasonIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const GreaterCondition(property: 1, value: ''),
      );
    });
  }

  QueryBuilder<
    RamadanSeasonCollection,
    RamadanSeasonCollection,
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
    RamadanSeasonCollection,
    RamadanSeasonCollection,
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
    RamadanSeasonCollection,
    RamadanSeasonCollection,
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
    RamadanSeasonCollection,
    RamadanSeasonCollection,
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
    RamadanSeasonCollection,
    RamadanSeasonCollection,
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
    RamadanSeasonCollection,
    RamadanSeasonCollection,
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
    RamadanSeasonCollection,
    RamadanSeasonCollection,
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
    RamadanSeasonCollection,
    RamadanSeasonCollection,
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
    RamadanSeasonCollection,
    RamadanSeasonCollection,
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
    RamadanSeasonCollection,
    RamadanSeasonCollection,
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
    RamadanSeasonCollection,
    RamadanSeasonCollection,
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
    RamadanSeasonCollection,
    RamadanSeasonCollection,
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
    RamadanSeasonCollection,
    RamadanSeasonCollection,
    QAfterFilterCondition
  >
  startDateEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(property: 3, value: value),
      );
    });
  }

  QueryBuilder<
    RamadanSeasonCollection,
    RamadanSeasonCollection,
    QAfterFilterCondition
  >
  startDateGreaterThan(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(property: 3, value: value),
      );
    });
  }

  QueryBuilder<
    RamadanSeasonCollection,
    RamadanSeasonCollection,
    QAfterFilterCondition
  >
  startDateGreaterThanOrEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(property: 3, value: value),
      );
    });
  }

  QueryBuilder<
    RamadanSeasonCollection,
    RamadanSeasonCollection,
    QAfterFilterCondition
  >
  startDateLessThan(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(LessCondition(property: 3, value: value));
    });
  }

  QueryBuilder<
    RamadanSeasonCollection,
    RamadanSeasonCollection,
    QAfterFilterCondition
  >
  startDateLessThanOrEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(property: 3, value: value),
      );
    });
  }

  QueryBuilder<
    RamadanSeasonCollection,
    RamadanSeasonCollection,
    QAfterFilterCondition
  >
  startDateBetween(DateTime lower, DateTime upper) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(property: 3, lower: lower, upper: upper),
      );
    });
  }

  QueryBuilder<
    RamadanSeasonCollection,
    RamadanSeasonCollection,
    QAfterFilterCondition
  >
  endDateEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(property: 4, value: value),
      );
    });
  }

  QueryBuilder<
    RamadanSeasonCollection,
    RamadanSeasonCollection,
    QAfterFilterCondition
  >
  endDateGreaterThan(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(property: 4, value: value),
      );
    });
  }

  QueryBuilder<
    RamadanSeasonCollection,
    RamadanSeasonCollection,
    QAfterFilterCondition
  >
  endDateGreaterThanOrEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(property: 4, value: value),
      );
    });
  }

  QueryBuilder<
    RamadanSeasonCollection,
    RamadanSeasonCollection,
    QAfterFilterCondition
  >
  endDateLessThan(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(LessCondition(property: 4, value: value));
    });
  }

  QueryBuilder<
    RamadanSeasonCollection,
    RamadanSeasonCollection,
    QAfterFilterCondition
  >
  endDateLessThanOrEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(property: 4, value: value),
      );
    });
  }

  QueryBuilder<
    RamadanSeasonCollection,
    RamadanSeasonCollection,
    QAfterFilterCondition
  >
  endDateBetween(DateTime lower, DateTime upper) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(property: 4, lower: lower, upper: upper),
      );
    });
  }

  QueryBuilder<
    RamadanSeasonCollection,
    RamadanSeasonCollection,
    QAfterFilterCondition
  >
  yearEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(property: 5, value: value),
      );
    });
  }

  QueryBuilder<
    RamadanSeasonCollection,
    RamadanSeasonCollection,
    QAfterFilterCondition
  >
  yearGreaterThan(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(property: 5, value: value),
      );
    });
  }

  QueryBuilder<
    RamadanSeasonCollection,
    RamadanSeasonCollection,
    QAfterFilterCondition
  >
  yearGreaterThanOrEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(property: 5, value: value),
      );
    });
  }

  QueryBuilder<
    RamadanSeasonCollection,
    RamadanSeasonCollection,
    QAfterFilterCondition
  >
  yearLessThan(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(LessCondition(property: 5, value: value));
    });
  }

  QueryBuilder<
    RamadanSeasonCollection,
    RamadanSeasonCollection,
    QAfterFilterCondition
  >
  yearLessThanOrEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(property: 5, value: value),
      );
    });
  }

  QueryBuilder<
    RamadanSeasonCollection,
    RamadanSeasonCollection,
    QAfterFilterCondition
  >
  yearBetween(int lower, int upper) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(property: 5, lower: lower, upper: upper),
      );
    });
  }

  QueryBuilder<
    RamadanSeasonCollection,
    RamadanSeasonCollection,
    QAfterFilterCondition
  >
  optedInMemberIdsJsonEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(property: 6, value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<
    RamadanSeasonCollection,
    RamadanSeasonCollection,
    QAfterFilterCondition
  >
  optedInMemberIdsJsonGreaterThan(String value, {bool caseSensitive = true}) {
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
    RamadanSeasonCollection,
    RamadanSeasonCollection,
    QAfterFilterCondition
  >
  optedInMemberIdsJsonGreaterThanOrEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
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
    RamadanSeasonCollection,
    RamadanSeasonCollection,
    QAfterFilterCondition
  >
  optedInMemberIdsJsonLessThan(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(property: 6, value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<
    RamadanSeasonCollection,
    RamadanSeasonCollection,
    QAfterFilterCondition
  >
  optedInMemberIdsJsonLessThanOrEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
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
    RamadanSeasonCollection,
    RamadanSeasonCollection,
    QAfterFilterCondition
  >
  optedInMemberIdsJsonBetween(
    String lower,
    String upper, {
    bool caseSensitive = true,
  }) {
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
    RamadanSeasonCollection,
    RamadanSeasonCollection,
    QAfterFilterCondition
  >
  optedInMemberIdsJsonStartsWith(String value, {bool caseSensitive = true}) {
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
    RamadanSeasonCollection,
    RamadanSeasonCollection,
    QAfterFilterCondition
  >
  optedInMemberIdsJsonEndsWith(String value, {bool caseSensitive = true}) {
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
    RamadanSeasonCollection,
    RamadanSeasonCollection,
    QAfterFilterCondition
  >
  optedInMemberIdsJsonContains(String value, {bool caseSensitive = true}) {
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
    RamadanSeasonCollection,
    RamadanSeasonCollection,
    QAfterFilterCondition
  >
  optedInMemberIdsJsonMatches(String pattern, {bool caseSensitive = true}) {
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
    RamadanSeasonCollection,
    RamadanSeasonCollection,
    QAfterFilterCondition
  >
  optedInMemberIdsJsonIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const EqualCondition(property: 6, value: ''),
      );
    });
  }

  QueryBuilder<
    RamadanSeasonCollection,
    RamadanSeasonCollection,
    QAfterFilterCondition
  >
  optedInMemberIdsJsonIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const GreaterCondition(property: 6, value: ''),
      );
    });
  }

  QueryBuilder<
    RamadanSeasonCollection,
    RamadanSeasonCollection,
    QAfterFilterCondition
  >
  isActiveEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(property: 7, value: value),
      );
    });
  }

  QueryBuilder<
    RamadanSeasonCollection,
    RamadanSeasonCollection,
    QAfterFilterCondition
  >
  isSettledEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(property: 8, value: value),
      );
    });
  }

  QueryBuilder<
    RamadanSeasonCollection,
    RamadanSeasonCollection,
    QAfterFilterCondition
  >
  createdAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const IsNullCondition(property: 9));
    });
  }

  QueryBuilder<
    RamadanSeasonCollection,
    RamadanSeasonCollection,
    QAfterFilterCondition
  >
  createdAtIsNotNull() {
    return QueryBuilder.apply(not(), (query) {
      return query.addFilterCondition(const IsNullCondition(property: 9));
    });
  }

  QueryBuilder<
    RamadanSeasonCollection,
    RamadanSeasonCollection,
    QAfterFilterCondition
  >
  createdAtEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(property: 9, value: value),
      );
    });
  }

  QueryBuilder<
    RamadanSeasonCollection,
    RamadanSeasonCollection,
    QAfterFilterCondition
  >
  createdAtGreaterThan(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(property: 9, value: value),
      );
    });
  }

  QueryBuilder<
    RamadanSeasonCollection,
    RamadanSeasonCollection,
    QAfterFilterCondition
  >
  createdAtGreaterThanOrEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(property: 9, value: value),
      );
    });
  }

  QueryBuilder<
    RamadanSeasonCollection,
    RamadanSeasonCollection,
    QAfterFilterCondition
  >
  createdAtLessThan(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(LessCondition(property: 9, value: value));
    });
  }

  QueryBuilder<
    RamadanSeasonCollection,
    RamadanSeasonCollection,
    QAfterFilterCondition
  >
  createdAtLessThanOrEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(property: 9, value: value),
      );
    });
  }

  QueryBuilder<
    RamadanSeasonCollection,
    RamadanSeasonCollection,
    QAfterFilterCondition
  >
  createdAtBetween(DateTime? lower, DateTime? upper) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(property: 9, lower: lower, upper: upper),
      );
    });
  }
}

extension RamadanSeasonCollectionQueryObject
    on
        QueryBuilder<
          RamadanSeasonCollection,
          RamadanSeasonCollection,
          QFilterCondition
        > {}

extension RamadanSeasonCollectionQuerySortBy
    on QueryBuilder<RamadanSeasonCollection, RamadanSeasonCollection, QSortBy> {
  QueryBuilder<RamadanSeasonCollection, RamadanSeasonCollection, QAfterSortBy>
  sortById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(0);
    });
  }

  QueryBuilder<RamadanSeasonCollection, RamadanSeasonCollection, QAfterSortBy>
  sortByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(0, sort: Sort.desc);
    });
  }

  QueryBuilder<RamadanSeasonCollection, RamadanSeasonCollection, QAfterSortBy>
  sortBySeasonId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(1, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<RamadanSeasonCollection, RamadanSeasonCollection, QAfterSortBy>
  sortBySeasonIdDesc({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(1, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<RamadanSeasonCollection, RamadanSeasonCollection, QAfterSortBy>
  sortByMessId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(2, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<RamadanSeasonCollection, RamadanSeasonCollection, QAfterSortBy>
  sortByMessIdDesc({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(2, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<RamadanSeasonCollection, RamadanSeasonCollection, QAfterSortBy>
  sortByStartDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(3);
    });
  }

  QueryBuilder<RamadanSeasonCollection, RamadanSeasonCollection, QAfterSortBy>
  sortByStartDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(3, sort: Sort.desc);
    });
  }

  QueryBuilder<RamadanSeasonCollection, RamadanSeasonCollection, QAfterSortBy>
  sortByEndDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(4);
    });
  }

  QueryBuilder<RamadanSeasonCollection, RamadanSeasonCollection, QAfterSortBy>
  sortByEndDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(4, sort: Sort.desc);
    });
  }

  QueryBuilder<RamadanSeasonCollection, RamadanSeasonCollection, QAfterSortBy>
  sortByYear() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(5);
    });
  }

  QueryBuilder<RamadanSeasonCollection, RamadanSeasonCollection, QAfterSortBy>
  sortByYearDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(5, sort: Sort.desc);
    });
  }

  QueryBuilder<RamadanSeasonCollection, RamadanSeasonCollection, QAfterSortBy>
  sortByOptedInMemberIdsJson({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(6, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<RamadanSeasonCollection, RamadanSeasonCollection, QAfterSortBy>
  sortByOptedInMemberIdsJsonDesc({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(6, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<RamadanSeasonCollection, RamadanSeasonCollection, QAfterSortBy>
  sortByIsActive() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(7);
    });
  }

  QueryBuilder<RamadanSeasonCollection, RamadanSeasonCollection, QAfterSortBy>
  sortByIsActiveDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(7, sort: Sort.desc);
    });
  }

  QueryBuilder<RamadanSeasonCollection, RamadanSeasonCollection, QAfterSortBy>
  sortByIsSettled() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(8);
    });
  }

  QueryBuilder<RamadanSeasonCollection, RamadanSeasonCollection, QAfterSortBy>
  sortByIsSettledDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(8, sort: Sort.desc);
    });
  }

  QueryBuilder<RamadanSeasonCollection, RamadanSeasonCollection, QAfterSortBy>
  sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(9);
    });
  }

  QueryBuilder<RamadanSeasonCollection, RamadanSeasonCollection, QAfterSortBy>
  sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(9, sort: Sort.desc);
    });
  }
}

extension RamadanSeasonCollectionQuerySortThenBy
    on
        QueryBuilder<
          RamadanSeasonCollection,
          RamadanSeasonCollection,
          QSortThenBy
        > {
  QueryBuilder<RamadanSeasonCollection, RamadanSeasonCollection, QAfterSortBy>
  thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(0);
    });
  }

  QueryBuilder<RamadanSeasonCollection, RamadanSeasonCollection, QAfterSortBy>
  thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(0, sort: Sort.desc);
    });
  }

  QueryBuilder<RamadanSeasonCollection, RamadanSeasonCollection, QAfterSortBy>
  thenBySeasonId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(1, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<RamadanSeasonCollection, RamadanSeasonCollection, QAfterSortBy>
  thenBySeasonIdDesc({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(1, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<RamadanSeasonCollection, RamadanSeasonCollection, QAfterSortBy>
  thenByMessId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(2, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<RamadanSeasonCollection, RamadanSeasonCollection, QAfterSortBy>
  thenByMessIdDesc({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(2, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<RamadanSeasonCollection, RamadanSeasonCollection, QAfterSortBy>
  thenByStartDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(3);
    });
  }

  QueryBuilder<RamadanSeasonCollection, RamadanSeasonCollection, QAfterSortBy>
  thenByStartDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(3, sort: Sort.desc);
    });
  }

  QueryBuilder<RamadanSeasonCollection, RamadanSeasonCollection, QAfterSortBy>
  thenByEndDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(4);
    });
  }

  QueryBuilder<RamadanSeasonCollection, RamadanSeasonCollection, QAfterSortBy>
  thenByEndDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(4, sort: Sort.desc);
    });
  }

  QueryBuilder<RamadanSeasonCollection, RamadanSeasonCollection, QAfterSortBy>
  thenByYear() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(5);
    });
  }

  QueryBuilder<RamadanSeasonCollection, RamadanSeasonCollection, QAfterSortBy>
  thenByYearDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(5, sort: Sort.desc);
    });
  }

  QueryBuilder<RamadanSeasonCollection, RamadanSeasonCollection, QAfterSortBy>
  thenByOptedInMemberIdsJson({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(6, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<RamadanSeasonCollection, RamadanSeasonCollection, QAfterSortBy>
  thenByOptedInMemberIdsJsonDesc({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(6, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<RamadanSeasonCollection, RamadanSeasonCollection, QAfterSortBy>
  thenByIsActive() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(7);
    });
  }

  QueryBuilder<RamadanSeasonCollection, RamadanSeasonCollection, QAfterSortBy>
  thenByIsActiveDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(7, sort: Sort.desc);
    });
  }

  QueryBuilder<RamadanSeasonCollection, RamadanSeasonCollection, QAfterSortBy>
  thenByIsSettled() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(8);
    });
  }

  QueryBuilder<RamadanSeasonCollection, RamadanSeasonCollection, QAfterSortBy>
  thenByIsSettledDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(8, sort: Sort.desc);
    });
  }

  QueryBuilder<RamadanSeasonCollection, RamadanSeasonCollection, QAfterSortBy>
  thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(9);
    });
  }

  QueryBuilder<RamadanSeasonCollection, RamadanSeasonCollection, QAfterSortBy>
  thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(9, sort: Sort.desc);
    });
  }
}

extension RamadanSeasonCollectionQueryWhereDistinct
    on
        QueryBuilder<
          RamadanSeasonCollection,
          RamadanSeasonCollection,
          QDistinct
        > {
  QueryBuilder<RamadanSeasonCollection, RamadanSeasonCollection, QAfterDistinct>
  distinctBySeasonId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(1, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<RamadanSeasonCollection, RamadanSeasonCollection, QAfterDistinct>
  distinctByMessId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(2, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<RamadanSeasonCollection, RamadanSeasonCollection, QAfterDistinct>
  distinctByStartDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(3);
    });
  }

  QueryBuilder<RamadanSeasonCollection, RamadanSeasonCollection, QAfterDistinct>
  distinctByEndDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(4);
    });
  }

  QueryBuilder<RamadanSeasonCollection, RamadanSeasonCollection, QAfterDistinct>
  distinctByYear() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(5);
    });
  }

  QueryBuilder<RamadanSeasonCollection, RamadanSeasonCollection, QAfterDistinct>
  distinctByOptedInMemberIdsJson({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(6, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<RamadanSeasonCollection, RamadanSeasonCollection, QAfterDistinct>
  distinctByIsActive() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(7);
    });
  }

  QueryBuilder<RamadanSeasonCollection, RamadanSeasonCollection, QAfterDistinct>
  distinctByIsSettled() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(8);
    });
  }

  QueryBuilder<RamadanSeasonCollection, RamadanSeasonCollection, QAfterDistinct>
  distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(9);
    });
  }
}

extension RamadanSeasonCollectionQueryProperty1
    on
        QueryBuilder<
          RamadanSeasonCollection,
          RamadanSeasonCollection,
          QProperty
        > {
  QueryBuilder<RamadanSeasonCollection, int, QAfterProperty> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(0);
    });
  }

  QueryBuilder<RamadanSeasonCollection, String, QAfterProperty>
  seasonIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(1);
    });
  }

  QueryBuilder<RamadanSeasonCollection, String, QAfterProperty>
  messIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(2);
    });
  }

  QueryBuilder<RamadanSeasonCollection, DateTime, QAfterProperty>
  startDateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(3);
    });
  }

  QueryBuilder<RamadanSeasonCollection, DateTime, QAfterProperty>
  endDateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(4);
    });
  }

  QueryBuilder<RamadanSeasonCollection, int, QAfterProperty> yearProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(5);
    });
  }

  QueryBuilder<RamadanSeasonCollection, String, QAfterProperty>
  optedInMemberIdsJsonProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(6);
    });
  }

  QueryBuilder<RamadanSeasonCollection, bool, QAfterProperty>
  isActiveProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(7);
    });
  }

  QueryBuilder<RamadanSeasonCollection, bool, QAfterProperty>
  isSettledProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(8);
    });
  }

  QueryBuilder<RamadanSeasonCollection, DateTime?, QAfterProperty>
  createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(9);
    });
  }
}

extension RamadanSeasonCollectionQueryProperty2<R>
    on QueryBuilder<RamadanSeasonCollection, R, QAfterProperty> {
  QueryBuilder<RamadanSeasonCollection, (R, int), QAfterProperty> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(0);
    });
  }

  QueryBuilder<RamadanSeasonCollection, (R, String), QAfterProperty>
  seasonIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(1);
    });
  }

  QueryBuilder<RamadanSeasonCollection, (R, String), QAfterProperty>
  messIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(2);
    });
  }

  QueryBuilder<RamadanSeasonCollection, (R, DateTime), QAfterProperty>
  startDateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(3);
    });
  }

  QueryBuilder<RamadanSeasonCollection, (R, DateTime), QAfterProperty>
  endDateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(4);
    });
  }

  QueryBuilder<RamadanSeasonCollection, (R, int), QAfterProperty>
  yearProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(5);
    });
  }

  QueryBuilder<RamadanSeasonCollection, (R, String), QAfterProperty>
  optedInMemberIdsJsonProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(6);
    });
  }

  QueryBuilder<RamadanSeasonCollection, (R, bool), QAfterProperty>
  isActiveProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(7);
    });
  }

  QueryBuilder<RamadanSeasonCollection, (R, bool), QAfterProperty>
  isSettledProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(8);
    });
  }

  QueryBuilder<RamadanSeasonCollection, (R, DateTime?), QAfterProperty>
  createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(9);
    });
  }
}

extension RamadanSeasonCollectionQueryProperty3<R1, R2>
    on QueryBuilder<RamadanSeasonCollection, (R1, R2), QAfterProperty> {
  QueryBuilder<RamadanSeasonCollection, (R1, R2, int), QOperations>
  idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(0);
    });
  }

  QueryBuilder<RamadanSeasonCollection, (R1, R2, String), QOperations>
  seasonIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(1);
    });
  }

  QueryBuilder<RamadanSeasonCollection, (R1, R2, String), QOperations>
  messIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(2);
    });
  }

  QueryBuilder<RamadanSeasonCollection, (R1, R2, DateTime), QOperations>
  startDateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(3);
    });
  }

  QueryBuilder<RamadanSeasonCollection, (R1, R2, DateTime), QOperations>
  endDateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(4);
    });
  }

  QueryBuilder<RamadanSeasonCollection, (R1, R2, int), QOperations>
  yearProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(5);
    });
  }

  QueryBuilder<RamadanSeasonCollection, (R1, R2, String), QOperations>
  optedInMemberIdsJsonProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(6);
    });
  }

  QueryBuilder<RamadanSeasonCollection, (R1, R2, bool), QOperations>
  isActiveProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(7);
    });
  }

  QueryBuilder<RamadanSeasonCollection, (R1, R2, bool), QOperations>
  isSettledProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(8);
    });
  }

  QueryBuilder<RamadanSeasonCollection, (R1, R2, DateTime?), QOperations>
  createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(9);
    });
  }
}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, invalid_use_of_protected_member, lines_longer_than_80_chars, constant_identifier_names, avoid_js_rounded_ints, no_leading_underscores_for_local_identifiers, require_trailing_commas, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_in_if_null_operators, library_private_types_in_public_api, prefer_const_constructors
// ignore_for_file: type=lint

extension GetRamadanMealCollectionCollection on Isar {
  IsarCollection<int, RamadanMealCollection> get ramadanMealCollections =>
      this.collection();
}

final RamadanMealCollectionSchema = IsarGeneratedSchema(
  schema: IsarSchema(
    name: 'RamadanMealCollection',
    idName: 'id',
    embedded: false,
    properties: [
      IsarPropertySchema(name: 'mealId', type: IsarType.string),
      IsarPropertySchema(name: 'seasonId', type: IsarType.string),
      IsarPropertySchema(name: 'memberId', type: IsarType.string),
      IsarPropertySchema(name: 'date', type: IsarType.dateTime),
      IsarPropertySchema(name: 'typeIndex', type: IsarType.long),
      IsarPropertySchema(name: 'count', type: IsarType.long),
      IsarPropertySchema(name: 'guestName', type: IsarType.string),
      IsarPropertySchema(name: 'createdAt', type: IsarType.dateTime),
    ],
    indexes: [
      IsarIndexSchema(
        name: 'mealId',
        properties: ["mealId"],
        unique: false,
        hash: false,
      ),
      IsarIndexSchema(
        name: 'seasonId',
        properties: ["seasonId"],
        unique: false,
        hash: false,
      ),
      IsarIndexSchema(
        name: 'memberId',
        properties: ["memberId"],
        unique: false,
        hash: false,
      ),
    ],
  ),
  converter: IsarObjectConverter<int, RamadanMealCollection>(
    serialize: serializeRamadanMealCollection,
    deserialize: deserializeRamadanMealCollection,
    deserializeProperty: deserializeRamadanMealCollectionProp,
  ),
  getEmbeddedSchemas: () => [],
);

@isarProtected
int serializeRamadanMealCollection(
  IsarWriter writer,
  RamadanMealCollection object,
) {
  IsarCore.writeString(writer, 1, object.mealId);
  IsarCore.writeString(writer, 2, object.seasonId);
  IsarCore.writeString(writer, 3, object.memberId);
  IsarCore.writeLong(writer, 4, object.date.toUtc().microsecondsSinceEpoch);
  IsarCore.writeLong(writer, 5, object.typeIndex);
  IsarCore.writeLong(writer, 6, object.count);
  {
    final value = object.guestName;
    if (value == null) {
      IsarCore.writeNull(writer, 7);
    } else {
      IsarCore.writeString(writer, 7, value);
    }
  }
  IsarCore.writeLong(
    writer,
    8,
    object.createdAt?.toUtc().microsecondsSinceEpoch ?? -9223372036854775808,
  );
  return object.id;
}

@isarProtected
RamadanMealCollection deserializeRamadanMealCollection(IsarReader reader) {
  final object = RamadanMealCollection();
  object.id = IsarCore.readId(reader);
  object.mealId = IsarCore.readString(reader, 1) ?? '';
  object.seasonId = IsarCore.readString(reader, 2) ?? '';
  object.memberId = IsarCore.readString(reader, 3) ?? '';
  {
    final value = IsarCore.readLong(reader, 4);
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
  object.typeIndex = IsarCore.readLong(reader, 5);
  object.count = IsarCore.readLong(reader, 6);
  object.guestName = IsarCore.readString(reader, 7);
  {
    final value = IsarCore.readLong(reader, 8);
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
dynamic deserializeRamadanMealCollectionProp(IsarReader reader, int property) {
  switch (property) {
    case 0:
      return IsarCore.readId(reader);
    case 1:
      return IsarCore.readString(reader, 1) ?? '';
    case 2:
      return IsarCore.readString(reader, 2) ?? '';
    case 3:
      return IsarCore.readString(reader, 3) ?? '';
    case 4:
      {
        final value = IsarCore.readLong(reader, 4);
        if (value == -9223372036854775808) {
          return DateTime.fromMillisecondsSinceEpoch(0, isUtc: true).toLocal();
        } else {
          return DateTime.fromMicrosecondsSinceEpoch(
            value,
            isUtc: true,
          ).toLocal();
        }
      }
    case 5:
      return IsarCore.readLong(reader, 5);
    case 6:
      return IsarCore.readLong(reader, 6);
    case 7:
      return IsarCore.readString(reader, 7);
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

sealed class _RamadanMealCollectionUpdate {
  bool call({
    required int id,
    String? mealId,
    String? seasonId,
    String? memberId,
    DateTime? date,
    int? typeIndex,
    int? count,
    String? guestName,
    DateTime? createdAt,
  });
}

class _RamadanMealCollectionUpdateImpl implements _RamadanMealCollectionUpdate {
  const _RamadanMealCollectionUpdateImpl(this.collection);

  final IsarCollection<int, RamadanMealCollection> collection;

  @override
  bool call({
    required int id,
    Object? mealId = ignore,
    Object? seasonId = ignore,
    Object? memberId = ignore,
    Object? date = ignore,
    Object? typeIndex = ignore,
    Object? count = ignore,
    Object? guestName = ignore,
    Object? createdAt = ignore,
  }) {
    return collection.updateProperties(
          [id],
          {
            if (mealId != ignore) 1: mealId as String?,
            if (seasonId != ignore) 2: seasonId as String?,
            if (memberId != ignore) 3: memberId as String?,
            if (date != ignore) 4: date as DateTime?,
            if (typeIndex != ignore) 5: typeIndex as int?,
            if (count != ignore) 6: count as int?,
            if (guestName != ignore) 7: guestName as String?,
            if (createdAt != ignore) 8: createdAt as DateTime?,
          },
        ) >
        0;
  }
}

sealed class _RamadanMealCollectionUpdateAll {
  int call({
    required List<int> id,
    String? mealId,
    String? seasonId,
    String? memberId,
    DateTime? date,
    int? typeIndex,
    int? count,
    String? guestName,
    DateTime? createdAt,
  });
}

class _RamadanMealCollectionUpdateAllImpl
    implements _RamadanMealCollectionUpdateAll {
  const _RamadanMealCollectionUpdateAllImpl(this.collection);

  final IsarCollection<int, RamadanMealCollection> collection;

  @override
  int call({
    required List<int> id,
    Object? mealId = ignore,
    Object? seasonId = ignore,
    Object? memberId = ignore,
    Object? date = ignore,
    Object? typeIndex = ignore,
    Object? count = ignore,
    Object? guestName = ignore,
    Object? createdAt = ignore,
  }) {
    return collection.updateProperties(id, {
      if (mealId != ignore) 1: mealId as String?,
      if (seasonId != ignore) 2: seasonId as String?,
      if (memberId != ignore) 3: memberId as String?,
      if (date != ignore) 4: date as DateTime?,
      if (typeIndex != ignore) 5: typeIndex as int?,
      if (count != ignore) 6: count as int?,
      if (guestName != ignore) 7: guestName as String?,
      if (createdAt != ignore) 8: createdAt as DateTime?,
    });
  }
}

extension RamadanMealCollectionUpdate
    on IsarCollection<int, RamadanMealCollection> {
  _RamadanMealCollectionUpdate get update =>
      _RamadanMealCollectionUpdateImpl(this);

  _RamadanMealCollectionUpdateAll get updateAll =>
      _RamadanMealCollectionUpdateAllImpl(this);
}

sealed class _RamadanMealCollectionQueryUpdate {
  int call({
    String? mealId,
    String? seasonId,
    String? memberId,
    DateTime? date,
    int? typeIndex,
    int? count,
    String? guestName,
    DateTime? createdAt,
  });
}

class _RamadanMealCollectionQueryUpdateImpl
    implements _RamadanMealCollectionQueryUpdate {
  const _RamadanMealCollectionQueryUpdateImpl(this.query, {this.limit});

  final IsarQuery<RamadanMealCollection> query;
  final int? limit;

  @override
  int call({
    Object? mealId = ignore,
    Object? seasonId = ignore,
    Object? memberId = ignore,
    Object? date = ignore,
    Object? typeIndex = ignore,
    Object? count = ignore,
    Object? guestName = ignore,
    Object? createdAt = ignore,
  }) {
    return query.updateProperties(limit: limit, {
      if (mealId != ignore) 1: mealId as String?,
      if (seasonId != ignore) 2: seasonId as String?,
      if (memberId != ignore) 3: memberId as String?,
      if (date != ignore) 4: date as DateTime?,
      if (typeIndex != ignore) 5: typeIndex as int?,
      if (count != ignore) 6: count as int?,
      if (guestName != ignore) 7: guestName as String?,
      if (createdAt != ignore) 8: createdAt as DateTime?,
    });
  }
}

extension RamadanMealCollectionQueryUpdate on IsarQuery<RamadanMealCollection> {
  _RamadanMealCollectionQueryUpdate get updateFirst =>
      _RamadanMealCollectionQueryUpdateImpl(this, limit: 1);

  _RamadanMealCollectionQueryUpdate get updateAll =>
      _RamadanMealCollectionQueryUpdateImpl(this);
}

class _RamadanMealCollectionQueryBuilderUpdateImpl
    implements _RamadanMealCollectionQueryUpdate {
  const _RamadanMealCollectionQueryBuilderUpdateImpl(this.query, {this.limit});

  final QueryBuilder<RamadanMealCollection, RamadanMealCollection, QOperations>
  query;
  final int? limit;

  @override
  int call({
    Object? mealId = ignore,
    Object? seasonId = ignore,
    Object? memberId = ignore,
    Object? date = ignore,
    Object? typeIndex = ignore,
    Object? count = ignore,
    Object? guestName = ignore,
    Object? createdAt = ignore,
  }) {
    final q = query.build();
    try {
      return q.updateProperties(limit: limit, {
        if (mealId != ignore) 1: mealId as String?,
        if (seasonId != ignore) 2: seasonId as String?,
        if (memberId != ignore) 3: memberId as String?,
        if (date != ignore) 4: date as DateTime?,
        if (typeIndex != ignore) 5: typeIndex as int?,
        if (count != ignore) 6: count as int?,
        if (guestName != ignore) 7: guestName as String?,
        if (createdAt != ignore) 8: createdAt as DateTime?,
      });
    } finally {
      q.close();
    }
  }
}

extension RamadanMealCollectionQueryBuilderUpdate
    on QueryBuilder<RamadanMealCollection, RamadanMealCollection, QOperations> {
  _RamadanMealCollectionQueryUpdate get updateFirst =>
      _RamadanMealCollectionQueryBuilderUpdateImpl(this, limit: 1);

  _RamadanMealCollectionQueryUpdate get updateAll =>
      _RamadanMealCollectionQueryBuilderUpdateImpl(this);
}

extension RamadanMealCollectionQueryFilter
    on
        QueryBuilder<
          RamadanMealCollection,
          RamadanMealCollection,
          QFilterCondition
        > {
  QueryBuilder<
    RamadanMealCollection,
    RamadanMealCollection,
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
    RamadanMealCollection,
    RamadanMealCollection,
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
    RamadanMealCollection,
    RamadanMealCollection,
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
    RamadanMealCollection,
    RamadanMealCollection,
    QAfterFilterCondition
  >
  idLessThan(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(LessCondition(property: 0, value: value));
    });
  }

  QueryBuilder<
    RamadanMealCollection,
    RamadanMealCollection,
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
    RamadanMealCollection,
    RamadanMealCollection,
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
    RamadanMealCollection,
    RamadanMealCollection,
    QAfterFilterCondition
  >
  mealIdEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(property: 1, value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<
    RamadanMealCollection,
    RamadanMealCollection,
    QAfterFilterCondition
  >
  mealIdGreaterThan(String value, {bool caseSensitive = true}) {
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
    RamadanMealCollection,
    RamadanMealCollection,
    QAfterFilterCondition
  >
  mealIdGreaterThanOrEqualTo(String value, {bool caseSensitive = true}) {
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
    RamadanMealCollection,
    RamadanMealCollection,
    QAfterFilterCondition
  >
  mealIdLessThan(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(property: 1, value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<
    RamadanMealCollection,
    RamadanMealCollection,
    QAfterFilterCondition
  >
  mealIdLessThanOrEqualTo(String value, {bool caseSensitive = true}) {
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
    RamadanMealCollection,
    RamadanMealCollection,
    QAfterFilterCondition
  >
  mealIdBetween(String lower, String upper, {bool caseSensitive = true}) {
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
    RamadanMealCollection,
    RamadanMealCollection,
    QAfterFilterCondition
  >
  mealIdStartsWith(String value, {bool caseSensitive = true}) {
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
    RamadanMealCollection,
    RamadanMealCollection,
    QAfterFilterCondition
  >
  mealIdEndsWith(String value, {bool caseSensitive = true}) {
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
    RamadanMealCollection,
    RamadanMealCollection,
    QAfterFilterCondition
  >
  mealIdContains(String value, {bool caseSensitive = true}) {
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
    RamadanMealCollection,
    RamadanMealCollection,
    QAfterFilterCondition
  >
  mealIdMatches(String pattern, {bool caseSensitive = true}) {
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
    RamadanMealCollection,
    RamadanMealCollection,
    QAfterFilterCondition
  >
  mealIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const EqualCondition(property: 1, value: ''),
      );
    });
  }

  QueryBuilder<
    RamadanMealCollection,
    RamadanMealCollection,
    QAfterFilterCondition
  >
  mealIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const GreaterCondition(property: 1, value: ''),
      );
    });
  }

  QueryBuilder<
    RamadanMealCollection,
    RamadanMealCollection,
    QAfterFilterCondition
  >
  seasonIdEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(property: 2, value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<
    RamadanMealCollection,
    RamadanMealCollection,
    QAfterFilterCondition
  >
  seasonIdGreaterThan(String value, {bool caseSensitive = true}) {
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
    RamadanMealCollection,
    RamadanMealCollection,
    QAfterFilterCondition
  >
  seasonIdGreaterThanOrEqualTo(String value, {bool caseSensitive = true}) {
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
    RamadanMealCollection,
    RamadanMealCollection,
    QAfterFilterCondition
  >
  seasonIdLessThan(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(property: 2, value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<
    RamadanMealCollection,
    RamadanMealCollection,
    QAfterFilterCondition
  >
  seasonIdLessThanOrEqualTo(String value, {bool caseSensitive = true}) {
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
    RamadanMealCollection,
    RamadanMealCollection,
    QAfterFilterCondition
  >
  seasonIdBetween(String lower, String upper, {bool caseSensitive = true}) {
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
    RamadanMealCollection,
    RamadanMealCollection,
    QAfterFilterCondition
  >
  seasonIdStartsWith(String value, {bool caseSensitive = true}) {
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
    RamadanMealCollection,
    RamadanMealCollection,
    QAfterFilterCondition
  >
  seasonIdEndsWith(String value, {bool caseSensitive = true}) {
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
    RamadanMealCollection,
    RamadanMealCollection,
    QAfterFilterCondition
  >
  seasonIdContains(String value, {bool caseSensitive = true}) {
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
    RamadanMealCollection,
    RamadanMealCollection,
    QAfterFilterCondition
  >
  seasonIdMatches(String pattern, {bool caseSensitive = true}) {
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
    RamadanMealCollection,
    RamadanMealCollection,
    QAfterFilterCondition
  >
  seasonIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const EqualCondition(property: 2, value: ''),
      );
    });
  }

  QueryBuilder<
    RamadanMealCollection,
    RamadanMealCollection,
    QAfterFilterCondition
  >
  seasonIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const GreaterCondition(property: 2, value: ''),
      );
    });
  }

  QueryBuilder<
    RamadanMealCollection,
    RamadanMealCollection,
    QAfterFilterCondition
  >
  memberIdEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(property: 3, value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<
    RamadanMealCollection,
    RamadanMealCollection,
    QAfterFilterCondition
  >
  memberIdGreaterThan(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<
    RamadanMealCollection,
    RamadanMealCollection,
    QAfterFilterCondition
  >
  memberIdGreaterThanOrEqualTo(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<
    RamadanMealCollection,
    RamadanMealCollection,
    QAfterFilterCondition
  >
  memberIdLessThan(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(property: 3, value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<
    RamadanMealCollection,
    RamadanMealCollection,
    QAfterFilterCondition
  >
  memberIdLessThanOrEqualTo(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<
    RamadanMealCollection,
    RamadanMealCollection,
    QAfterFilterCondition
  >
  memberIdBetween(String lower, String upper, {bool caseSensitive = true}) {
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

  QueryBuilder<
    RamadanMealCollection,
    RamadanMealCollection,
    QAfterFilterCondition
  >
  memberIdStartsWith(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<
    RamadanMealCollection,
    RamadanMealCollection,
    QAfterFilterCondition
  >
  memberIdEndsWith(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<
    RamadanMealCollection,
    RamadanMealCollection,
    QAfterFilterCondition
  >
  memberIdContains(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<
    RamadanMealCollection,
    RamadanMealCollection,
    QAfterFilterCondition
  >
  memberIdMatches(String pattern, {bool caseSensitive = true}) {
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

  QueryBuilder<
    RamadanMealCollection,
    RamadanMealCollection,
    QAfterFilterCondition
  >
  memberIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const EqualCondition(property: 3, value: ''),
      );
    });
  }

  QueryBuilder<
    RamadanMealCollection,
    RamadanMealCollection,
    QAfterFilterCondition
  >
  memberIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const GreaterCondition(property: 3, value: ''),
      );
    });
  }

  QueryBuilder<
    RamadanMealCollection,
    RamadanMealCollection,
    QAfterFilterCondition
  >
  dateEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(property: 4, value: value),
      );
    });
  }

  QueryBuilder<
    RamadanMealCollection,
    RamadanMealCollection,
    QAfterFilterCondition
  >
  dateGreaterThan(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(property: 4, value: value),
      );
    });
  }

  QueryBuilder<
    RamadanMealCollection,
    RamadanMealCollection,
    QAfterFilterCondition
  >
  dateGreaterThanOrEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(property: 4, value: value),
      );
    });
  }

  QueryBuilder<
    RamadanMealCollection,
    RamadanMealCollection,
    QAfterFilterCondition
  >
  dateLessThan(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(LessCondition(property: 4, value: value));
    });
  }

  QueryBuilder<
    RamadanMealCollection,
    RamadanMealCollection,
    QAfterFilterCondition
  >
  dateLessThanOrEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(property: 4, value: value),
      );
    });
  }

  QueryBuilder<
    RamadanMealCollection,
    RamadanMealCollection,
    QAfterFilterCondition
  >
  dateBetween(DateTime lower, DateTime upper) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(property: 4, lower: lower, upper: upper),
      );
    });
  }

  QueryBuilder<
    RamadanMealCollection,
    RamadanMealCollection,
    QAfterFilterCondition
  >
  typeIndexEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(property: 5, value: value),
      );
    });
  }

  QueryBuilder<
    RamadanMealCollection,
    RamadanMealCollection,
    QAfterFilterCondition
  >
  typeIndexGreaterThan(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(property: 5, value: value),
      );
    });
  }

  QueryBuilder<
    RamadanMealCollection,
    RamadanMealCollection,
    QAfterFilterCondition
  >
  typeIndexGreaterThanOrEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(property: 5, value: value),
      );
    });
  }

  QueryBuilder<
    RamadanMealCollection,
    RamadanMealCollection,
    QAfterFilterCondition
  >
  typeIndexLessThan(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(LessCondition(property: 5, value: value));
    });
  }

  QueryBuilder<
    RamadanMealCollection,
    RamadanMealCollection,
    QAfterFilterCondition
  >
  typeIndexLessThanOrEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(property: 5, value: value),
      );
    });
  }

  QueryBuilder<
    RamadanMealCollection,
    RamadanMealCollection,
    QAfterFilterCondition
  >
  typeIndexBetween(int lower, int upper) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(property: 5, lower: lower, upper: upper),
      );
    });
  }

  QueryBuilder<
    RamadanMealCollection,
    RamadanMealCollection,
    QAfterFilterCondition
  >
  countEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(property: 6, value: value),
      );
    });
  }

  QueryBuilder<
    RamadanMealCollection,
    RamadanMealCollection,
    QAfterFilterCondition
  >
  countGreaterThan(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(property: 6, value: value),
      );
    });
  }

  QueryBuilder<
    RamadanMealCollection,
    RamadanMealCollection,
    QAfterFilterCondition
  >
  countGreaterThanOrEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(property: 6, value: value),
      );
    });
  }

  QueryBuilder<
    RamadanMealCollection,
    RamadanMealCollection,
    QAfterFilterCondition
  >
  countLessThan(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(LessCondition(property: 6, value: value));
    });
  }

  QueryBuilder<
    RamadanMealCollection,
    RamadanMealCollection,
    QAfterFilterCondition
  >
  countLessThanOrEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(property: 6, value: value),
      );
    });
  }

  QueryBuilder<
    RamadanMealCollection,
    RamadanMealCollection,
    QAfterFilterCondition
  >
  countBetween(int lower, int upper) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(property: 6, lower: lower, upper: upper),
      );
    });
  }

  QueryBuilder<
    RamadanMealCollection,
    RamadanMealCollection,
    QAfterFilterCondition
  >
  guestNameIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const IsNullCondition(property: 7));
    });
  }

  QueryBuilder<
    RamadanMealCollection,
    RamadanMealCollection,
    QAfterFilterCondition
  >
  guestNameIsNotNull() {
    return QueryBuilder.apply(not(), (query) {
      return query.addFilterCondition(const IsNullCondition(property: 7));
    });
  }

  QueryBuilder<
    RamadanMealCollection,
    RamadanMealCollection,
    QAfterFilterCondition
  >
  guestNameEqualTo(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(property: 7, value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<
    RamadanMealCollection,
    RamadanMealCollection,
    QAfterFilterCondition
  >
  guestNameGreaterThan(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(
          property: 7,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    RamadanMealCollection,
    RamadanMealCollection,
    QAfterFilterCondition
  >
  guestNameGreaterThanOrEqualTo(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(
          property: 7,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    RamadanMealCollection,
    RamadanMealCollection,
    QAfterFilterCondition
  >
  guestNameLessThan(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(property: 7, value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<
    RamadanMealCollection,
    RamadanMealCollection,
    QAfterFilterCondition
  >
  guestNameLessThanOrEqualTo(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(
          property: 7,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    RamadanMealCollection,
    RamadanMealCollection,
    QAfterFilterCondition
  >
  guestNameBetween(String? lower, String? upper, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(
          property: 7,
          lower: lower,
          upper: upper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    RamadanMealCollection,
    RamadanMealCollection,
    QAfterFilterCondition
  >
  guestNameStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        StartsWithCondition(
          property: 7,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    RamadanMealCollection,
    RamadanMealCollection,
    QAfterFilterCondition
  >
  guestNameEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EndsWithCondition(
          property: 7,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    RamadanMealCollection,
    RamadanMealCollection,
    QAfterFilterCondition
  >
  guestNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        ContainsCondition(
          property: 7,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    RamadanMealCollection,
    RamadanMealCollection,
    QAfterFilterCondition
  >
  guestNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        MatchesCondition(
          property: 7,
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    RamadanMealCollection,
    RamadanMealCollection,
    QAfterFilterCondition
  >
  guestNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const EqualCondition(property: 7, value: ''),
      );
    });
  }

  QueryBuilder<
    RamadanMealCollection,
    RamadanMealCollection,
    QAfterFilterCondition
  >
  guestNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const GreaterCondition(property: 7, value: ''),
      );
    });
  }

  QueryBuilder<
    RamadanMealCollection,
    RamadanMealCollection,
    QAfterFilterCondition
  >
  createdAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const IsNullCondition(property: 8));
    });
  }

  QueryBuilder<
    RamadanMealCollection,
    RamadanMealCollection,
    QAfterFilterCondition
  >
  createdAtIsNotNull() {
    return QueryBuilder.apply(not(), (query) {
      return query.addFilterCondition(const IsNullCondition(property: 8));
    });
  }

  QueryBuilder<
    RamadanMealCollection,
    RamadanMealCollection,
    QAfterFilterCondition
  >
  createdAtEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(property: 8, value: value),
      );
    });
  }

  QueryBuilder<
    RamadanMealCollection,
    RamadanMealCollection,
    QAfterFilterCondition
  >
  createdAtGreaterThan(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(property: 8, value: value),
      );
    });
  }

  QueryBuilder<
    RamadanMealCollection,
    RamadanMealCollection,
    QAfterFilterCondition
  >
  createdAtGreaterThanOrEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(property: 8, value: value),
      );
    });
  }

  QueryBuilder<
    RamadanMealCollection,
    RamadanMealCollection,
    QAfterFilterCondition
  >
  createdAtLessThan(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(LessCondition(property: 8, value: value));
    });
  }

  QueryBuilder<
    RamadanMealCollection,
    RamadanMealCollection,
    QAfterFilterCondition
  >
  createdAtLessThanOrEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(property: 8, value: value),
      );
    });
  }

  QueryBuilder<
    RamadanMealCollection,
    RamadanMealCollection,
    QAfterFilterCondition
  >
  createdAtBetween(DateTime? lower, DateTime? upper) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(property: 8, lower: lower, upper: upper),
      );
    });
  }
}

extension RamadanMealCollectionQueryObject
    on
        QueryBuilder<
          RamadanMealCollection,
          RamadanMealCollection,
          QFilterCondition
        > {}

extension RamadanMealCollectionQuerySortBy
    on QueryBuilder<RamadanMealCollection, RamadanMealCollection, QSortBy> {
  QueryBuilder<RamadanMealCollection, RamadanMealCollection, QAfterSortBy>
  sortById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(0);
    });
  }

  QueryBuilder<RamadanMealCollection, RamadanMealCollection, QAfterSortBy>
  sortByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(0, sort: Sort.desc);
    });
  }

  QueryBuilder<RamadanMealCollection, RamadanMealCollection, QAfterSortBy>
  sortByMealId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(1, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<RamadanMealCollection, RamadanMealCollection, QAfterSortBy>
  sortByMealIdDesc({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(1, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<RamadanMealCollection, RamadanMealCollection, QAfterSortBy>
  sortBySeasonId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(2, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<RamadanMealCollection, RamadanMealCollection, QAfterSortBy>
  sortBySeasonIdDesc({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(2, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<RamadanMealCollection, RamadanMealCollection, QAfterSortBy>
  sortByMemberId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(3, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<RamadanMealCollection, RamadanMealCollection, QAfterSortBy>
  sortByMemberIdDesc({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(3, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<RamadanMealCollection, RamadanMealCollection, QAfterSortBy>
  sortByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(4);
    });
  }

  QueryBuilder<RamadanMealCollection, RamadanMealCollection, QAfterSortBy>
  sortByDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(4, sort: Sort.desc);
    });
  }

  QueryBuilder<RamadanMealCollection, RamadanMealCollection, QAfterSortBy>
  sortByTypeIndex() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(5);
    });
  }

  QueryBuilder<RamadanMealCollection, RamadanMealCollection, QAfterSortBy>
  sortByTypeIndexDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(5, sort: Sort.desc);
    });
  }

  QueryBuilder<RamadanMealCollection, RamadanMealCollection, QAfterSortBy>
  sortByCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(6);
    });
  }

  QueryBuilder<RamadanMealCollection, RamadanMealCollection, QAfterSortBy>
  sortByCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(6, sort: Sort.desc);
    });
  }

  QueryBuilder<RamadanMealCollection, RamadanMealCollection, QAfterSortBy>
  sortByGuestName({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(7, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<RamadanMealCollection, RamadanMealCollection, QAfterSortBy>
  sortByGuestNameDesc({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(7, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<RamadanMealCollection, RamadanMealCollection, QAfterSortBy>
  sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(8);
    });
  }

  QueryBuilder<RamadanMealCollection, RamadanMealCollection, QAfterSortBy>
  sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(8, sort: Sort.desc);
    });
  }
}

extension RamadanMealCollectionQuerySortThenBy
    on QueryBuilder<RamadanMealCollection, RamadanMealCollection, QSortThenBy> {
  QueryBuilder<RamadanMealCollection, RamadanMealCollection, QAfterSortBy>
  thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(0);
    });
  }

  QueryBuilder<RamadanMealCollection, RamadanMealCollection, QAfterSortBy>
  thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(0, sort: Sort.desc);
    });
  }

  QueryBuilder<RamadanMealCollection, RamadanMealCollection, QAfterSortBy>
  thenByMealId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(1, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<RamadanMealCollection, RamadanMealCollection, QAfterSortBy>
  thenByMealIdDesc({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(1, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<RamadanMealCollection, RamadanMealCollection, QAfterSortBy>
  thenBySeasonId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(2, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<RamadanMealCollection, RamadanMealCollection, QAfterSortBy>
  thenBySeasonIdDesc({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(2, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<RamadanMealCollection, RamadanMealCollection, QAfterSortBy>
  thenByMemberId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(3, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<RamadanMealCollection, RamadanMealCollection, QAfterSortBy>
  thenByMemberIdDesc({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(3, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<RamadanMealCollection, RamadanMealCollection, QAfterSortBy>
  thenByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(4);
    });
  }

  QueryBuilder<RamadanMealCollection, RamadanMealCollection, QAfterSortBy>
  thenByDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(4, sort: Sort.desc);
    });
  }

  QueryBuilder<RamadanMealCollection, RamadanMealCollection, QAfterSortBy>
  thenByTypeIndex() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(5);
    });
  }

  QueryBuilder<RamadanMealCollection, RamadanMealCollection, QAfterSortBy>
  thenByTypeIndexDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(5, sort: Sort.desc);
    });
  }

  QueryBuilder<RamadanMealCollection, RamadanMealCollection, QAfterSortBy>
  thenByCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(6);
    });
  }

  QueryBuilder<RamadanMealCollection, RamadanMealCollection, QAfterSortBy>
  thenByCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(6, sort: Sort.desc);
    });
  }

  QueryBuilder<RamadanMealCollection, RamadanMealCollection, QAfterSortBy>
  thenByGuestName({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(7, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<RamadanMealCollection, RamadanMealCollection, QAfterSortBy>
  thenByGuestNameDesc({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(7, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<RamadanMealCollection, RamadanMealCollection, QAfterSortBy>
  thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(8);
    });
  }

  QueryBuilder<RamadanMealCollection, RamadanMealCollection, QAfterSortBy>
  thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(8, sort: Sort.desc);
    });
  }
}

extension RamadanMealCollectionQueryWhereDistinct
    on QueryBuilder<RamadanMealCollection, RamadanMealCollection, QDistinct> {
  QueryBuilder<RamadanMealCollection, RamadanMealCollection, QAfterDistinct>
  distinctByMealId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(1, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<RamadanMealCollection, RamadanMealCollection, QAfterDistinct>
  distinctBySeasonId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(2, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<RamadanMealCollection, RamadanMealCollection, QAfterDistinct>
  distinctByMemberId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(3, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<RamadanMealCollection, RamadanMealCollection, QAfterDistinct>
  distinctByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(4);
    });
  }

  QueryBuilder<RamadanMealCollection, RamadanMealCollection, QAfterDistinct>
  distinctByTypeIndex() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(5);
    });
  }

  QueryBuilder<RamadanMealCollection, RamadanMealCollection, QAfterDistinct>
  distinctByCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(6);
    });
  }

  QueryBuilder<RamadanMealCollection, RamadanMealCollection, QAfterDistinct>
  distinctByGuestName({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(7, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<RamadanMealCollection, RamadanMealCollection, QAfterDistinct>
  distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(8);
    });
  }
}

extension RamadanMealCollectionQueryProperty1
    on QueryBuilder<RamadanMealCollection, RamadanMealCollection, QProperty> {
  QueryBuilder<RamadanMealCollection, int, QAfterProperty> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(0);
    });
  }

  QueryBuilder<RamadanMealCollection, String, QAfterProperty> mealIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(1);
    });
  }

  QueryBuilder<RamadanMealCollection, String, QAfterProperty>
  seasonIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(2);
    });
  }

  QueryBuilder<RamadanMealCollection, String, QAfterProperty>
  memberIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(3);
    });
  }

  QueryBuilder<RamadanMealCollection, DateTime, QAfterProperty> dateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(4);
    });
  }

  QueryBuilder<RamadanMealCollection, int, QAfterProperty> typeIndexProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(5);
    });
  }

  QueryBuilder<RamadanMealCollection, int, QAfterProperty> countProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(6);
    });
  }

  QueryBuilder<RamadanMealCollection, String?, QAfterProperty>
  guestNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(7);
    });
  }

  QueryBuilder<RamadanMealCollection, DateTime?, QAfterProperty>
  createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(8);
    });
  }
}

extension RamadanMealCollectionQueryProperty2<R>
    on QueryBuilder<RamadanMealCollection, R, QAfterProperty> {
  QueryBuilder<RamadanMealCollection, (R, int), QAfterProperty> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(0);
    });
  }

  QueryBuilder<RamadanMealCollection, (R, String), QAfterProperty>
  mealIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(1);
    });
  }

  QueryBuilder<RamadanMealCollection, (R, String), QAfterProperty>
  seasonIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(2);
    });
  }

  QueryBuilder<RamadanMealCollection, (R, String), QAfterProperty>
  memberIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(3);
    });
  }

  QueryBuilder<RamadanMealCollection, (R, DateTime), QAfterProperty>
  dateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(4);
    });
  }

  QueryBuilder<RamadanMealCollection, (R, int), QAfterProperty>
  typeIndexProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(5);
    });
  }

  QueryBuilder<RamadanMealCollection, (R, int), QAfterProperty>
  countProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(6);
    });
  }

  QueryBuilder<RamadanMealCollection, (R, String?), QAfterProperty>
  guestNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(7);
    });
  }

  QueryBuilder<RamadanMealCollection, (R, DateTime?), QAfterProperty>
  createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(8);
    });
  }
}

extension RamadanMealCollectionQueryProperty3<R1, R2>
    on QueryBuilder<RamadanMealCollection, (R1, R2), QAfterProperty> {
  QueryBuilder<RamadanMealCollection, (R1, R2, int), QOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(0);
    });
  }

  QueryBuilder<RamadanMealCollection, (R1, R2, String), QOperations>
  mealIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(1);
    });
  }

  QueryBuilder<RamadanMealCollection, (R1, R2, String), QOperations>
  seasonIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(2);
    });
  }

  QueryBuilder<RamadanMealCollection, (R1, R2, String), QOperations>
  memberIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(3);
    });
  }

  QueryBuilder<RamadanMealCollection, (R1, R2, DateTime), QOperations>
  dateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(4);
    });
  }

  QueryBuilder<RamadanMealCollection, (R1, R2, int), QOperations>
  typeIndexProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(5);
    });
  }

  QueryBuilder<RamadanMealCollection, (R1, R2, int), QOperations>
  countProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(6);
    });
  }

  QueryBuilder<RamadanMealCollection, (R1, R2, String?), QOperations>
  guestNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(7);
    });
  }

  QueryBuilder<RamadanMealCollection, (R1, R2, DateTime?), QOperations>
  createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(8);
    });
  }
}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, invalid_use_of_protected_member, lines_longer_than_80_chars, constant_identifier_names, avoid_js_rounded_ints, no_leading_underscores_for_local_identifiers, require_trailing_commas, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_in_if_null_operators, library_private_types_in_public_api, prefer_const_constructors
// ignore_for_file: type=lint

extension GetRamadanBazarCollectionCollection on Isar {
  IsarCollection<int, RamadanBazarCollection> get ramadanBazarCollections =>
      this.collection();
}

final RamadanBazarCollectionSchema = IsarGeneratedSchema(
  schema: IsarSchema(
    name: 'RamadanBazarCollection',
    idName: 'id',
    embedded: false,
    properties: [
      IsarPropertySchema(name: 'bazarId', type: IsarType.string),
      IsarPropertySchema(name: 'seasonId', type: IsarType.string),
      IsarPropertySchema(name: 'memberId', type: IsarType.string),
      IsarPropertySchema(name: 'date', type: IsarType.dateTime),
      IsarPropertySchema(name: 'amount', type: IsarType.double),
      IsarPropertySchema(name: 'description', type: IsarType.string),
      IsarPropertySchema(name: 'isForSehri', type: IsarType.bool),
      IsarPropertySchema(name: 'createdAt', type: IsarType.dateTime),
    ],
    indexes: [
      IsarIndexSchema(
        name: 'bazarId',
        properties: ["bazarId"],
        unique: false,
        hash: false,
      ),
      IsarIndexSchema(
        name: 'seasonId',
        properties: ["seasonId"],
        unique: false,
        hash: false,
      ),
      IsarIndexSchema(
        name: 'memberId',
        properties: ["memberId"],
        unique: false,
        hash: false,
      ),
    ],
  ),
  converter: IsarObjectConverter<int, RamadanBazarCollection>(
    serialize: serializeRamadanBazarCollection,
    deserialize: deserializeRamadanBazarCollection,
    deserializeProperty: deserializeRamadanBazarCollectionProp,
  ),
  getEmbeddedSchemas: () => [],
);

@isarProtected
int serializeRamadanBazarCollection(
  IsarWriter writer,
  RamadanBazarCollection object,
) {
  IsarCore.writeString(writer, 1, object.bazarId);
  IsarCore.writeString(writer, 2, object.seasonId);
  IsarCore.writeString(writer, 3, object.memberId);
  IsarCore.writeLong(writer, 4, object.date.toUtc().microsecondsSinceEpoch);
  IsarCore.writeDouble(writer, 5, object.amount);
  {
    final value = object.description;
    if (value == null) {
      IsarCore.writeNull(writer, 6);
    } else {
      IsarCore.writeString(writer, 6, value);
    }
  }
  IsarCore.writeBool(writer, 7, value: object.isForSehri);
  IsarCore.writeLong(
    writer,
    8,
    object.createdAt?.toUtc().microsecondsSinceEpoch ?? -9223372036854775808,
  );
  return object.id;
}

@isarProtected
RamadanBazarCollection deserializeRamadanBazarCollection(IsarReader reader) {
  final object = RamadanBazarCollection();
  object.id = IsarCore.readId(reader);
  object.bazarId = IsarCore.readString(reader, 1) ?? '';
  object.seasonId = IsarCore.readString(reader, 2) ?? '';
  object.memberId = IsarCore.readString(reader, 3) ?? '';
  {
    final value = IsarCore.readLong(reader, 4);
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
  object.amount = IsarCore.readDouble(reader, 5);
  object.description = IsarCore.readString(reader, 6);
  object.isForSehri = IsarCore.readBool(reader, 7);
  {
    final value = IsarCore.readLong(reader, 8);
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
dynamic deserializeRamadanBazarCollectionProp(IsarReader reader, int property) {
  switch (property) {
    case 0:
      return IsarCore.readId(reader);
    case 1:
      return IsarCore.readString(reader, 1) ?? '';
    case 2:
      return IsarCore.readString(reader, 2) ?? '';
    case 3:
      return IsarCore.readString(reader, 3) ?? '';
    case 4:
      {
        final value = IsarCore.readLong(reader, 4);
        if (value == -9223372036854775808) {
          return DateTime.fromMillisecondsSinceEpoch(0, isUtc: true).toLocal();
        } else {
          return DateTime.fromMicrosecondsSinceEpoch(
            value,
            isUtc: true,
          ).toLocal();
        }
      }
    case 5:
      return IsarCore.readDouble(reader, 5);
    case 6:
      return IsarCore.readString(reader, 6);
    case 7:
      return IsarCore.readBool(reader, 7);
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

sealed class _RamadanBazarCollectionUpdate {
  bool call({
    required int id,
    String? bazarId,
    String? seasonId,
    String? memberId,
    DateTime? date,
    double? amount,
    String? description,
    bool? isForSehri,
    DateTime? createdAt,
  });
}

class _RamadanBazarCollectionUpdateImpl
    implements _RamadanBazarCollectionUpdate {
  const _RamadanBazarCollectionUpdateImpl(this.collection);

  final IsarCollection<int, RamadanBazarCollection> collection;

  @override
  bool call({
    required int id,
    Object? bazarId = ignore,
    Object? seasonId = ignore,
    Object? memberId = ignore,
    Object? date = ignore,
    Object? amount = ignore,
    Object? description = ignore,
    Object? isForSehri = ignore,
    Object? createdAt = ignore,
  }) {
    return collection.updateProperties(
          [id],
          {
            if (bazarId != ignore) 1: bazarId as String?,
            if (seasonId != ignore) 2: seasonId as String?,
            if (memberId != ignore) 3: memberId as String?,
            if (date != ignore) 4: date as DateTime?,
            if (amount != ignore) 5: amount as double?,
            if (description != ignore) 6: description as String?,
            if (isForSehri != ignore) 7: isForSehri as bool?,
            if (createdAt != ignore) 8: createdAt as DateTime?,
          },
        ) >
        0;
  }
}

sealed class _RamadanBazarCollectionUpdateAll {
  int call({
    required List<int> id,
    String? bazarId,
    String? seasonId,
    String? memberId,
    DateTime? date,
    double? amount,
    String? description,
    bool? isForSehri,
    DateTime? createdAt,
  });
}

class _RamadanBazarCollectionUpdateAllImpl
    implements _RamadanBazarCollectionUpdateAll {
  const _RamadanBazarCollectionUpdateAllImpl(this.collection);

  final IsarCollection<int, RamadanBazarCollection> collection;

  @override
  int call({
    required List<int> id,
    Object? bazarId = ignore,
    Object? seasonId = ignore,
    Object? memberId = ignore,
    Object? date = ignore,
    Object? amount = ignore,
    Object? description = ignore,
    Object? isForSehri = ignore,
    Object? createdAt = ignore,
  }) {
    return collection.updateProperties(id, {
      if (bazarId != ignore) 1: bazarId as String?,
      if (seasonId != ignore) 2: seasonId as String?,
      if (memberId != ignore) 3: memberId as String?,
      if (date != ignore) 4: date as DateTime?,
      if (amount != ignore) 5: amount as double?,
      if (description != ignore) 6: description as String?,
      if (isForSehri != ignore) 7: isForSehri as bool?,
      if (createdAt != ignore) 8: createdAt as DateTime?,
    });
  }
}

extension RamadanBazarCollectionUpdate
    on IsarCollection<int, RamadanBazarCollection> {
  _RamadanBazarCollectionUpdate get update =>
      _RamadanBazarCollectionUpdateImpl(this);

  _RamadanBazarCollectionUpdateAll get updateAll =>
      _RamadanBazarCollectionUpdateAllImpl(this);
}

sealed class _RamadanBazarCollectionQueryUpdate {
  int call({
    String? bazarId,
    String? seasonId,
    String? memberId,
    DateTime? date,
    double? amount,
    String? description,
    bool? isForSehri,
    DateTime? createdAt,
  });
}

class _RamadanBazarCollectionQueryUpdateImpl
    implements _RamadanBazarCollectionQueryUpdate {
  const _RamadanBazarCollectionQueryUpdateImpl(this.query, {this.limit});

  final IsarQuery<RamadanBazarCollection> query;
  final int? limit;

  @override
  int call({
    Object? bazarId = ignore,
    Object? seasonId = ignore,
    Object? memberId = ignore,
    Object? date = ignore,
    Object? amount = ignore,
    Object? description = ignore,
    Object? isForSehri = ignore,
    Object? createdAt = ignore,
  }) {
    return query.updateProperties(limit: limit, {
      if (bazarId != ignore) 1: bazarId as String?,
      if (seasonId != ignore) 2: seasonId as String?,
      if (memberId != ignore) 3: memberId as String?,
      if (date != ignore) 4: date as DateTime?,
      if (amount != ignore) 5: amount as double?,
      if (description != ignore) 6: description as String?,
      if (isForSehri != ignore) 7: isForSehri as bool?,
      if (createdAt != ignore) 8: createdAt as DateTime?,
    });
  }
}

extension RamadanBazarCollectionQueryUpdate
    on IsarQuery<RamadanBazarCollection> {
  _RamadanBazarCollectionQueryUpdate get updateFirst =>
      _RamadanBazarCollectionQueryUpdateImpl(this, limit: 1);

  _RamadanBazarCollectionQueryUpdate get updateAll =>
      _RamadanBazarCollectionQueryUpdateImpl(this);
}

class _RamadanBazarCollectionQueryBuilderUpdateImpl
    implements _RamadanBazarCollectionQueryUpdate {
  const _RamadanBazarCollectionQueryBuilderUpdateImpl(this.query, {this.limit});

  final QueryBuilder<
    RamadanBazarCollection,
    RamadanBazarCollection,
    QOperations
  >
  query;
  final int? limit;

  @override
  int call({
    Object? bazarId = ignore,
    Object? seasonId = ignore,
    Object? memberId = ignore,
    Object? date = ignore,
    Object? amount = ignore,
    Object? description = ignore,
    Object? isForSehri = ignore,
    Object? createdAt = ignore,
  }) {
    final q = query.build();
    try {
      return q.updateProperties(limit: limit, {
        if (bazarId != ignore) 1: bazarId as String?,
        if (seasonId != ignore) 2: seasonId as String?,
        if (memberId != ignore) 3: memberId as String?,
        if (date != ignore) 4: date as DateTime?,
        if (amount != ignore) 5: amount as double?,
        if (description != ignore) 6: description as String?,
        if (isForSehri != ignore) 7: isForSehri as bool?,
        if (createdAt != ignore) 8: createdAt as DateTime?,
      });
    } finally {
      q.close();
    }
  }
}

extension RamadanBazarCollectionQueryBuilderUpdate
    on
        QueryBuilder<
          RamadanBazarCollection,
          RamadanBazarCollection,
          QOperations
        > {
  _RamadanBazarCollectionQueryUpdate get updateFirst =>
      _RamadanBazarCollectionQueryBuilderUpdateImpl(this, limit: 1);

  _RamadanBazarCollectionQueryUpdate get updateAll =>
      _RamadanBazarCollectionQueryBuilderUpdateImpl(this);
}

extension RamadanBazarCollectionQueryFilter
    on
        QueryBuilder<
          RamadanBazarCollection,
          RamadanBazarCollection,
          QFilterCondition
        > {
  QueryBuilder<
    RamadanBazarCollection,
    RamadanBazarCollection,
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
    RamadanBazarCollection,
    RamadanBazarCollection,
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
    RamadanBazarCollection,
    RamadanBazarCollection,
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
    RamadanBazarCollection,
    RamadanBazarCollection,
    QAfterFilterCondition
  >
  idLessThan(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(LessCondition(property: 0, value: value));
    });
  }

  QueryBuilder<
    RamadanBazarCollection,
    RamadanBazarCollection,
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
    RamadanBazarCollection,
    RamadanBazarCollection,
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
    RamadanBazarCollection,
    RamadanBazarCollection,
    QAfterFilterCondition
  >
  bazarIdEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(property: 1, value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<
    RamadanBazarCollection,
    RamadanBazarCollection,
    QAfterFilterCondition
  >
  bazarIdGreaterThan(String value, {bool caseSensitive = true}) {
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
    RamadanBazarCollection,
    RamadanBazarCollection,
    QAfterFilterCondition
  >
  bazarIdGreaterThanOrEqualTo(String value, {bool caseSensitive = true}) {
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
    RamadanBazarCollection,
    RamadanBazarCollection,
    QAfterFilterCondition
  >
  bazarIdLessThan(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(property: 1, value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<
    RamadanBazarCollection,
    RamadanBazarCollection,
    QAfterFilterCondition
  >
  bazarIdLessThanOrEqualTo(String value, {bool caseSensitive = true}) {
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
    RamadanBazarCollection,
    RamadanBazarCollection,
    QAfterFilterCondition
  >
  bazarIdBetween(String lower, String upper, {bool caseSensitive = true}) {
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
    RamadanBazarCollection,
    RamadanBazarCollection,
    QAfterFilterCondition
  >
  bazarIdStartsWith(String value, {bool caseSensitive = true}) {
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
    RamadanBazarCollection,
    RamadanBazarCollection,
    QAfterFilterCondition
  >
  bazarIdEndsWith(String value, {bool caseSensitive = true}) {
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
    RamadanBazarCollection,
    RamadanBazarCollection,
    QAfterFilterCondition
  >
  bazarIdContains(String value, {bool caseSensitive = true}) {
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
    RamadanBazarCollection,
    RamadanBazarCollection,
    QAfterFilterCondition
  >
  bazarIdMatches(String pattern, {bool caseSensitive = true}) {
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
    RamadanBazarCollection,
    RamadanBazarCollection,
    QAfterFilterCondition
  >
  bazarIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const EqualCondition(property: 1, value: ''),
      );
    });
  }

  QueryBuilder<
    RamadanBazarCollection,
    RamadanBazarCollection,
    QAfterFilterCondition
  >
  bazarIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const GreaterCondition(property: 1, value: ''),
      );
    });
  }

  QueryBuilder<
    RamadanBazarCollection,
    RamadanBazarCollection,
    QAfterFilterCondition
  >
  seasonIdEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(property: 2, value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<
    RamadanBazarCollection,
    RamadanBazarCollection,
    QAfterFilterCondition
  >
  seasonIdGreaterThan(String value, {bool caseSensitive = true}) {
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
    RamadanBazarCollection,
    RamadanBazarCollection,
    QAfterFilterCondition
  >
  seasonIdGreaterThanOrEqualTo(String value, {bool caseSensitive = true}) {
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
    RamadanBazarCollection,
    RamadanBazarCollection,
    QAfterFilterCondition
  >
  seasonIdLessThan(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(property: 2, value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<
    RamadanBazarCollection,
    RamadanBazarCollection,
    QAfterFilterCondition
  >
  seasonIdLessThanOrEqualTo(String value, {bool caseSensitive = true}) {
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
    RamadanBazarCollection,
    RamadanBazarCollection,
    QAfterFilterCondition
  >
  seasonIdBetween(String lower, String upper, {bool caseSensitive = true}) {
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
    RamadanBazarCollection,
    RamadanBazarCollection,
    QAfterFilterCondition
  >
  seasonIdStartsWith(String value, {bool caseSensitive = true}) {
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
    RamadanBazarCollection,
    RamadanBazarCollection,
    QAfterFilterCondition
  >
  seasonIdEndsWith(String value, {bool caseSensitive = true}) {
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
    RamadanBazarCollection,
    RamadanBazarCollection,
    QAfterFilterCondition
  >
  seasonIdContains(String value, {bool caseSensitive = true}) {
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
    RamadanBazarCollection,
    RamadanBazarCollection,
    QAfterFilterCondition
  >
  seasonIdMatches(String pattern, {bool caseSensitive = true}) {
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
    RamadanBazarCollection,
    RamadanBazarCollection,
    QAfterFilterCondition
  >
  seasonIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const EqualCondition(property: 2, value: ''),
      );
    });
  }

  QueryBuilder<
    RamadanBazarCollection,
    RamadanBazarCollection,
    QAfterFilterCondition
  >
  seasonIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const GreaterCondition(property: 2, value: ''),
      );
    });
  }

  QueryBuilder<
    RamadanBazarCollection,
    RamadanBazarCollection,
    QAfterFilterCondition
  >
  memberIdEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(property: 3, value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<
    RamadanBazarCollection,
    RamadanBazarCollection,
    QAfterFilterCondition
  >
  memberIdGreaterThan(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<
    RamadanBazarCollection,
    RamadanBazarCollection,
    QAfterFilterCondition
  >
  memberIdGreaterThanOrEqualTo(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<
    RamadanBazarCollection,
    RamadanBazarCollection,
    QAfterFilterCondition
  >
  memberIdLessThan(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(property: 3, value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<
    RamadanBazarCollection,
    RamadanBazarCollection,
    QAfterFilterCondition
  >
  memberIdLessThanOrEqualTo(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<
    RamadanBazarCollection,
    RamadanBazarCollection,
    QAfterFilterCondition
  >
  memberIdBetween(String lower, String upper, {bool caseSensitive = true}) {
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

  QueryBuilder<
    RamadanBazarCollection,
    RamadanBazarCollection,
    QAfterFilterCondition
  >
  memberIdStartsWith(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<
    RamadanBazarCollection,
    RamadanBazarCollection,
    QAfterFilterCondition
  >
  memberIdEndsWith(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<
    RamadanBazarCollection,
    RamadanBazarCollection,
    QAfterFilterCondition
  >
  memberIdContains(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<
    RamadanBazarCollection,
    RamadanBazarCollection,
    QAfterFilterCondition
  >
  memberIdMatches(String pattern, {bool caseSensitive = true}) {
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

  QueryBuilder<
    RamadanBazarCollection,
    RamadanBazarCollection,
    QAfterFilterCondition
  >
  memberIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const EqualCondition(property: 3, value: ''),
      );
    });
  }

  QueryBuilder<
    RamadanBazarCollection,
    RamadanBazarCollection,
    QAfterFilterCondition
  >
  memberIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const GreaterCondition(property: 3, value: ''),
      );
    });
  }

  QueryBuilder<
    RamadanBazarCollection,
    RamadanBazarCollection,
    QAfterFilterCondition
  >
  dateEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(property: 4, value: value),
      );
    });
  }

  QueryBuilder<
    RamadanBazarCollection,
    RamadanBazarCollection,
    QAfterFilterCondition
  >
  dateGreaterThan(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(property: 4, value: value),
      );
    });
  }

  QueryBuilder<
    RamadanBazarCollection,
    RamadanBazarCollection,
    QAfterFilterCondition
  >
  dateGreaterThanOrEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(property: 4, value: value),
      );
    });
  }

  QueryBuilder<
    RamadanBazarCollection,
    RamadanBazarCollection,
    QAfterFilterCondition
  >
  dateLessThan(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(LessCondition(property: 4, value: value));
    });
  }

  QueryBuilder<
    RamadanBazarCollection,
    RamadanBazarCollection,
    QAfterFilterCondition
  >
  dateLessThanOrEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(property: 4, value: value),
      );
    });
  }

  QueryBuilder<
    RamadanBazarCollection,
    RamadanBazarCollection,
    QAfterFilterCondition
  >
  dateBetween(DateTime lower, DateTime upper) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(property: 4, lower: lower, upper: upper),
      );
    });
  }

  QueryBuilder<
    RamadanBazarCollection,
    RamadanBazarCollection,
    QAfterFilterCondition
  >
  amountEqualTo(double value, {double epsilon = Filter.epsilon}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(property: 5, value: value, epsilon: epsilon),
      );
    });
  }

  QueryBuilder<
    RamadanBazarCollection,
    RamadanBazarCollection,
    QAfterFilterCondition
  >
  amountGreaterThan(double value, {double epsilon = Filter.epsilon}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(property: 5, value: value, epsilon: epsilon),
      );
    });
  }

  QueryBuilder<
    RamadanBazarCollection,
    RamadanBazarCollection,
    QAfterFilterCondition
  >
  amountGreaterThanOrEqualTo(double value, {double epsilon = Filter.epsilon}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(property: 5, value: value, epsilon: epsilon),
      );
    });
  }

  QueryBuilder<
    RamadanBazarCollection,
    RamadanBazarCollection,
    QAfterFilterCondition
  >
  amountLessThan(double value, {double epsilon = Filter.epsilon}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(property: 5, value: value, epsilon: epsilon),
      );
    });
  }

  QueryBuilder<
    RamadanBazarCollection,
    RamadanBazarCollection,
    QAfterFilterCondition
  >
  amountLessThanOrEqualTo(double value, {double epsilon = Filter.epsilon}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(property: 5, value: value, epsilon: epsilon),
      );
    });
  }

  QueryBuilder<
    RamadanBazarCollection,
    RamadanBazarCollection,
    QAfterFilterCondition
  >
  amountBetween(double lower, double upper, {double epsilon = Filter.epsilon}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(
          property: 5,
          lower: lower,
          upper: upper,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<
    RamadanBazarCollection,
    RamadanBazarCollection,
    QAfterFilterCondition
  >
  descriptionIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const IsNullCondition(property: 6));
    });
  }

  QueryBuilder<
    RamadanBazarCollection,
    RamadanBazarCollection,
    QAfterFilterCondition
  >
  descriptionIsNotNull() {
    return QueryBuilder.apply(not(), (query) {
      return query.addFilterCondition(const IsNullCondition(property: 6));
    });
  }

  QueryBuilder<
    RamadanBazarCollection,
    RamadanBazarCollection,
    QAfterFilterCondition
  >
  descriptionEqualTo(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(property: 6, value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<
    RamadanBazarCollection,
    RamadanBazarCollection,
    QAfterFilterCondition
  >
  descriptionGreaterThan(String? value, {bool caseSensitive = true}) {
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
    RamadanBazarCollection,
    RamadanBazarCollection,
    QAfterFilterCondition
  >
  descriptionGreaterThanOrEqualTo(String? value, {bool caseSensitive = true}) {
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
    RamadanBazarCollection,
    RamadanBazarCollection,
    QAfterFilterCondition
  >
  descriptionLessThan(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(property: 6, value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<
    RamadanBazarCollection,
    RamadanBazarCollection,
    QAfterFilterCondition
  >
  descriptionLessThanOrEqualTo(String? value, {bool caseSensitive = true}) {
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
    RamadanBazarCollection,
    RamadanBazarCollection,
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
          property: 6,
          lower: lower,
          upper: upper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    RamadanBazarCollection,
    RamadanBazarCollection,
    QAfterFilterCondition
  >
  descriptionStartsWith(String value, {bool caseSensitive = true}) {
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
    RamadanBazarCollection,
    RamadanBazarCollection,
    QAfterFilterCondition
  >
  descriptionEndsWith(String value, {bool caseSensitive = true}) {
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
    RamadanBazarCollection,
    RamadanBazarCollection,
    QAfterFilterCondition
  >
  descriptionContains(String value, {bool caseSensitive = true}) {
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
    RamadanBazarCollection,
    RamadanBazarCollection,
    QAfterFilterCondition
  >
  descriptionMatches(String pattern, {bool caseSensitive = true}) {
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
    RamadanBazarCollection,
    RamadanBazarCollection,
    QAfterFilterCondition
  >
  descriptionIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const EqualCondition(property: 6, value: ''),
      );
    });
  }

  QueryBuilder<
    RamadanBazarCollection,
    RamadanBazarCollection,
    QAfterFilterCondition
  >
  descriptionIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const GreaterCondition(property: 6, value: ''),
      );
    });
  }

  QueryBuilder<
    RamadanBazarCollection,
    RamadanBazarCollection,
    QAfterFilterCondition
  >
  isForSehriEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(property: 7, value: value),
      );
    });
  }

  QueryBuilder<
    RamadanBazarCollection,
    RamadanBazarCollection,
    QAfterFilterCondition
  >
  createdAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const IsNullCondition(property: 8));
    });
  }

  QueryBuilder<
    RamadanBazarCollection,
    RamadanBazarCollection,
    QAfterFilterCondition
  >
  createdAtIsNotNull() {
    return QueryBuilder.apply(not(), (query) {
      return query.addFilterCondition(const IsNullCondition(property: 8));
    });
  }

  QueryBuilder<
    RamadanBazarCollection,
    RamadanBazarCollection,
    QAfterFilterCondition
  >
  createdAtEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(property: 8, value: value),
      );
    });
  }

  QueryBuilder<
    RamadanBazarCollection,
    RamadanBazarCollection,
    QAfterFilterCondition
  >
  createdAtGreaterThan(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(property: 8, value: value),
      );
    });
  }

  QueryBuilder<
    RamadanBazarCollection,
    RamadanBazarCollection,
    QAfterFilterCondition
  >
  createdAtGreaterThanOrEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(property: 8, value: value),
      );
    });
  }

  QueryBuilder<
    RamadanBazarCollection,
    RamadanBazarCollection,
    QAfterFilterCondition
  >
  createdAtLessThan(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(LessCondition(property: 8, value: value));
    });
  }

  QueryBuilder<
    RamadanBazarCollection,
    RamadanBazarCollection,
    QAfterFilterCondition
  >
  createdAtLessThanOrEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(property: 8, value: value),
      );
    });
  }

  QueryBuilder<
    RamadanBazarCollection,
    RamadanBazarCollection,
    QAfterFilterCondition
  >
  createdAtBetween(DateTime? lower, DateTime? upper) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(property: 8, lower: lower, upper: upper),
      );
    });
  }
}

extension RamadanBazarCollectionQueryObject
    on
        QueryBuilder<
          RamadanBazarCollection,
          RamadanBazarCollection,
          QFilterCondition
        > {}

extension RamadanBazarCollectionQuerySortBy
    on QueryBuilder<RamadanBazarCollection, RamadanBazarCollection, QSortBy> {
  QueryBuilder<RamadanBazarCollection, RamadanBazarCollection, QAfterSortBy>
  sortById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(0);
    });
  }

  QueryBuilder<RamadanBazarCollection, RamadanBazarCollection, QAfterSortBy>
  sortByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(0, sort: Sort.desc);
    });
  }

  QueryBuilder<RamadanBazarCollection, RamadanBazarCollection, QAfterSortBy>
  sortByBazarId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(1, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<RamadanBazarCollection, RamadanBazarCollection, QAfterSortBy>
  sortByBazarIdDesc({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(1, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<RamadanBazarCollection, RamadanBazarCollection, QAfterSortBy>
  sortBySeasonId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(2, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<RamadanBazarCollection, RamadanBazarCollection, QAfterSortBy>
  sortBySeasonIdDesc({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(2, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<RamadanBazarCollection, RamadanBazarCollection, QAfterSortBy>
  sortByMemberId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(3, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<RamadanBazarCollection, RamadanBazarCollection, QAfterSortBy>
  sortByMemberIdDesc({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(3, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<RamadanBazarCollection, RamadanBazarCollection, QAfterSortBy>
  sortByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(4);
    });
  }

  QueryBuilder<RamadanBazarCollection, RamadanBazarCollection, QAfterSortBy>
  sortByDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(4, sort: Sort.desc);
    });
  }

  QueryBuilder<RamadanBazarCollection, RamadanBazarCollection, QAfterSortBy>
  sortByAmount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(5);
    });
  }

  QueryBuilder<RamadanBazarCollection, RamadanBazarCollection, QAfterSortBy>
  sortByAmountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(5, sort: Sort.desc);
    });
  }

  QueryBuilder<RamadanBazarCollection, RamadanBazarCollection, QAfterSortBy>
  sortByDescription({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(6, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<RamadanBazarCollection, RamadanBazarCollection, QAfterSortBy>
  sortByDescriptionDesc({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(6, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<RamadanBazarCollection, RamadanBazarCollection, QAfterSortBy>
  sortByIsForSehri() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(7);
    });
  }

  QueryBuilder<RamadanBazarCollection, RamadanBazarCollection, QAfterSortBy>
  sortByIsForSehriDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(7, sort: Sort.desc);
    });
  }

  QueryBuilder<RamadanBazarCollection, RamadanBazarCollection, QAfterSortBy>
  sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(8);
    });
  }

  QueryBuilder<RamadanBazarCollection, RamadanBazarCollection, QAfterSortBy>
  sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(8, sort: Sort.desc);
    });
  }
}

extension RamadanBazarCollectionQuerySortThenBy
    on
        QueryBuilder<
          RamadanBazarCollection,
          RamadanBazarCollection,
          QSortThenBy
        > {
  QueryBuilder<RamadanBazarCollection, RamadanBazarCollection, QAfterSortBy>
  thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(0);
    });
  }

  QueryBuilder<RamadanBazarCollection, RamadanBazarCollection, QAfterSortBy>
  thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(0, sort: Sort.desc);
    });
  }

  QueryBuilder<RamadanBazarCollection, RamadanBazarCollection, QAfterSortBy>
  thenByBazarId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(1, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<RamadanBazarCollection, RamadanBazarCollection, QAfterSortBy>
  thenByBazarIdDesc({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(1, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<RamadanBazarCollection, RamadanBazarCollection, QAfterSortBy>
  thenBySeasonId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(2, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<RamadanBazarCollection, RamadanBazarCollection, QAfterSortBy>
  thenBySeasonIdDesc({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(2, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<RamadanBazarCollection, RamadanBazarCollection, QAfterSortBy>
  thenByMemberId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(3, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<RamadanBazarCollection, RamadanBazarCollection, QAfterSortBy>
  thenByMemberIdDesc({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(3, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<RamadanBazarCollection, RamadanBazarCollection, QAfterSortBy>
  thenByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(4);
    });
  }

  QueryBuilder<RamadanBazarCollection, RamadanBazarCollection, QAfterSortBy>
  thenByDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(4, sort: Sort.desc);
    });
  }

  QueryBuilder<RamadanBazarCollection, RamadanBazarCollection, QAfterSortBy>
  thenByAmount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(5);
    });
  }

  QueryBuilder<RamadanBazarCollection, RamadanBazarCollection, QAfterSortBy>
  thenByAmountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(5, sort: Sort.desc);
    });
  }

  QueryBuilder<RamadanBazarCollection, RamadanBazarCollection, QAfterSortBy>
  thenByDescription({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(6, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<RamadanBazarCollection, RamadanBazarCollection, QAfterSortBy>
  thenByDescriptionDesc({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(6, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<RamadanBazarCollection, RamadanBazarCollection, QAfterSortBy>
  thenByIsForSehri() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(7);
    });
  }

  QueryBuilder<RamadanBazarCollection, RamadanBazarCollection, QAfterSortBy>
  thenByIsForSehriDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(7, sort: Sort.desc);
    });
  }

  QueryBuilder<RamadanBazarCollection, RamadanBazarCollection, QAfterSortBy>
  thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(8);
    });
  }

  QueryBuilder<RamadanBazarCollection, RamadanBazarCollection, QAfterSortBy>
  thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(8, sort: Sort.desc);
    });
  }
}

extension RamadanBazarCollectionQueryWhereDistinct
    on QueryBuilder<RamadanBazarCollection, RamadanBazarCollection, QDistinct> {
  QueryBuilder<RamadanBazarCollection, RamadanBazarCollection, QAfterDistinct>
  distinctByBazarId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(1, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<RamadanBazarCollection, RamadanBazarCollection, QAfterDistinct>
  distinctBySeasonId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(2, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<RamadanBazarCollection, RamadanBazarCollection, QAfterDistinct>
  distinctByMemberId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(3, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<RamadanBazarCollection, RamadanBazarCollection, QAfterDistinct>
  distinctByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(4);
    });
  }

  QueryBuilder<RamadanBazarCollection, RamadanBazarCollection, QAfterDistinct>
  distinctByAmount() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(5);
    });
  }

  QueryBuilder<RamadanBazarCollection, RamadanBazarCollection, QAfterDistinct>
  distinctByDescription({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(6, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<RamadanBazarCollection, RamadanBazarCollection, QAfterDistinct>
  distinctByIsForSehri() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(7);
    });
  }

  QueryBuilder<RamadanBazarCollection, RamadanBazarCollection, QAfterDistinct>
  distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(8);
    });
  }
}

extension RamadanBazarCollectionQueryProperty1
    on QueryBuilder<RamadanBazarCollection, RamadanBazarCollection, QProperty> {
  QueryBuilder<RamadanBazarCollection, int, QAfterProperty> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(0);
    });
  }

  QueryBuilder<RamadanBazarCollection, String, QAfterProperty>
  bazarIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(1);
    });
  }

  QueryBuilder<RamadanBazarCollection, String, QAfterProperty>
  seasonIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(2);
    });
  }

  QueryBuilder<RamadanBazarCollection, String, QAfterProperty>
  memberIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(3);
    });
  }

  QueryBuilder<RamadanBazarCollection, DateTime, QAfterProperty>
  dateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(4);
    });
  }

  QueryBuilder<RamadanBazarCollection, double, QAfterProperty>
  amountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(5);
    });
  }

  QueryBuilder<RamadanBazarCollection, String?, QAfterProperty>
  descriptionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(6);
    });
  }

  QueryBuilder<RamadanBazarCollection, bool, QAfterProperty>
  isForSehriProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(7);
    });
  }

  QueryBuilder<RamadanBazarCollection, DateTime?, QAfterProperty>
  createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(8);
    });
  }
}

extension RamadanBazarCollectionQueryProperty2<R>
    on QueryBuilder<RamadanBazarCollection, R, QAfterProperty> {
  QueryBuilder<RamadanBazarCollection, (R, int), QAfterProperty> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(0);
    });
  }

  QueryBuilder<RamadanBazarCollection, (R, String), QAfterProperty>
  bazarIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(1);
    });
  }

  QueryBuilder<RamadanBazarCollection, (R, String), QAfterProperty>
  seasonIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(2);
    });
  }

  QueryBuilder<RamadanBazarCollection, (R, String), QAfterProperty>
  memberIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(3);
    });
  }

  QueryBuilder<RamadanBazarCollection, (R, DateTime), QAfterProperty>
  dateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(4);
    });
  }

  QueryBuilder<RamadanBazarCollection, (R, double), QAfterProperty>
  amountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(5);
    });
  }

  QueryBuilder<RamadanBazarCollection, (R, String?), QAfterProperty>
  descriptionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(6);
    });
  }

  QueryBuilder<RamadanBazarCollection, (R, bool), QAfterProperty>
  isForSehriProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(7);
    });
  }

  QueryBuilder<RamadanBazarCollection, (R, DateTime?), QAfterProperty>
  createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(8);
    });
  }
}

extension RamadanBazarCollectionQueryProperty3<R1, R2>
    on QueryBuilder<RamadanBazarCollection, (R1, R2), QAfterProperty> {
  QueryBuilder<RamadanBazarCollection, (R1, R2, int), QOperations>
  idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(0);
    });
  }

  QueryBuilder<RamadanBazarCollection, (R1, R2, String), QOperations>
  bazarIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(1);
    });
  }

  QueryBuilder<RamadanBazarCollection, (R1, R2, String), QOperations>
  seasonIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(2);
    });
  }

  QueryBuilder<RamadanBazarCollection, (R1, R2, String), QOperations>
  memberIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(3);
    });
  }

  QueryBuilder<RamadanBazarCollection, (R1, R2, DateTime), QOperations>
  dateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(4);
    });
  }

  QueryBuilder<RamadanBazarCollection, (R1, R2, double), QOperations>
  amountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(5);
    });
  }

  QueryBuilder<RamadanBazarCollection, (R1, R2, String?), QOperations>
  descriptionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(6);
    });
  }

  QueryBuilder<RamadanBazarCollection, (R1, R2, bool), QOperations>
  isForSehriProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(7);
    });
  }

  QueryBuilder<RamadanBazarCollection, (R1, R2, DateTime?), QOperations>
  createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(8);
    });
  }
}
