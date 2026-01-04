// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'meal_collection.dart';

// **************************************************************************
// _IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, invalid_use_of_protected_member, lines_longer_than_80_chars, constant_identifier_names, avoid_js_rounded_ints, no_leading_underscores_for_local_identifiers, require_trailing_commas, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_in_if_null_operators, library_private_types_in_public_api, prefer_const_constructors
// ignore_for_file: type=lint

extension GetMealCollectionCollection on Isar {
  IsarCollection<int, MealCollection> get mealCollections => this.collection();
}

final MealCollectionSchema = IsarGeneratedSchema(
  schema: IsarSchema(
    name: 'MealCollection',
    idName: 'id',
    embedded: false,
    properties: [
      IsarPropertySchema(name: 'mealId', type: IsarType.string),
      IsarPropertySchema(name: 'memberId', type: IsarType.string),
      IsarPropertySchema(name: 'date', type: IsarType.dateTime),
      IsarPropertySchema(name: 'count', type: IsarType.long),
      IsarPropertySchema(name: 'typeIndex', type: IsarType.long),
      IsarPropertySchema(name: 'statusIndex', type: IsarType.long),
      IsarPropertySchema(name: 'isFromSchedule', type: IsarType.bool),
      IsarPropertySchema(name: 'guestCount', type: IsarType.long),
      IsarPropertySchema(name: 'guestName', type: IsarType.string),
      IsarPropertySchema(
        name: 'sharedWithMemberIdsJson',
        type: IsarType.string,
      ),
      IsarPropertySchema(name: 'note', type: IsarType.string),
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
  converter: IsarObjectConverter<int, MealCollection>(
    serialize: serializeMealCollection,
    deserialize: deserializeMealCollection,
    deserializeProperty: deserializeMealCollectionProp,
  ),
  getEmbeddedSchemas: () => [],
);

@isarProtected
int serializeMealCollection(IsarWriter writer, MealCollection object) {
  IsarCore.writeString(writer, 1, object.mealId);
  IsarCore.writeString(writer, 2, object.memberId);
  IsarCore.writeLong(writer, 3, object.date.toUtc().microsecondsSinceEpoch);
  IsarCore.writeLong(writer, 4, object.count);
  IsarCore.writeLong(writer, 5, object.typeIndex);
  IsarCore.writeLong(writer, 6, object.statusIndex);
  IsarCore.writeBool(writer, 7, value: object.isFromSchedule);
  IsarCore.writeLong(writer, 8, object.guestCount);
  {
    final value = object.guestName;
    if (value == null) {
      IsarCore.writeNull(writer, 9);
    } else {
      IsarCore.writeString(writer, 9, value);
    }
  }
  {
    final value = object.sharedWithMemberIdsJson;
    if (value == null) {
      IsarCore.writeNull(writer, 10);
    } else {
      IsarCore.writeString(writer, 10, value);
    }
  }
  {
    final value = object.note;
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
MealCollection deserializeMealCollection(IsarReader reader) {
  final object = MealCollection();
  object.id = IsarCore.readId(reader);
  object.mealId = IsarCore.readString(reader, 1) ?? '';
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
  object.count = IsarCore.readLong(reader, 4);
  object.typeIndex = IsarCore.readLong(reader, 5);
  object.statusIndex = IsarCore.readLong(reader, 6);
  object.isFromSchedule = IsarCore.readBool(reader, 7);
  object.guestCount = IsarCore.readLong(reader, 8);
  object.guestName = IsarCore.readString(reader, 9);
  object.sharedWithMemberIdsJson = IsarCore.readString(reader, 10);
  object.note = IsarCore.readString(reader, 11);
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
dynamic deserializeMealCollectionProp(IsarReader reader, int property) {
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
      return IsarCore.readLong(reader, 4);
    case 5:
      return IsarCore.readLong(reader, 5);
    case 6:
      return IsarCore.readLong(reader, 6);
    case 7:
      return IsarCore.readBool(reader, 7);
    case 8:
      return IsarCore.readLong(reader, 8);
    case 9:
      return IsarCore.readString(reader, 9);
    case 10:
      return IsarCore.readString(reader, 10);
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

sealed class _MealCollectionUpdate {
  bool call({
    required int id,
    String? mealId,
    String? memberId,
    DateTime? date,
    int? count,
    int? typeIndex,
    int? statusIndex,
    bool? isFromSchedule,
    int? guestCount,
    String? guestName,
    String? sharedWithMemberIdsJson,
    String? note,
    DateTime? createdAt,
  });
}

class _MealCollectionUpdateImpl implements _MealCollectionUpdate {
  const _MealCollectionUpdateImpl(this.collection);

  final IsarCollection<int, MealCollection> collection;

  @override
  bool call({
    required int id,
    Object? mealId = ignore,
    Object? memberId = ignore,
    Object? date = ignore,
    Object? count = ignore,
    Object? typeIndex = ignore,
    Object? statusIndex = ignore,
    Object? isFromSchedule = ignore,
    Object? guestCount = ignore,
    Object? guestName = ignore,
    Object? sharedWithMemberIdsJson = ignore,
    Object? note = ignore,
    Object? createdAt = ignore,
  }) {
    return collection.updateProperties(
          [id],
          {
            if (mealId != ignore) 1: mealId as String?,
            if (memberId != ignore) 2: memberId as String?,
            if (date != ignore) 3: date as DateTime?,
            if (count != ignore) 4: count as int?,
            if (typeIndex != ignore) 5: typeIndex as int?,
            if (statusIndex != ignore) 6: statusIndex as int?,
            if (isFromSchedule != ignore) 7: isFromSchedule as bool?,
            if (guestCount != ignore) 8: guestCount as int?,
            if (guestName != ignore) 9: guestName as String?,
            if (sharedWithMemberIdsJson != ignore)
              10: sharedWithMemberIdsJson as String?,
            if (note != ignore) 11: note as String?,
            if (createdAt != ignore) 12: createdAt as DateTime?,
          },
        ) >
        0;
  }
}

sealed class _MealCollectionUpdateAll {
  int call({
    required List<int> id,
    String? mealId,
    String? memberId,
    DateTime? date,
    int? count,
    int? typeIndex,
    int? statusIndex,
    bool? isFromSchedule,
    int? guestCount,
    String? guestName,
    String? sharedWithMemberIdsJson,
    String? note,
    DateTime? createdAt,
  });
}

class _MealCollectionUpdateAllImpl implements _MealCollectionUpdateAll {
  const _MealCollectionUpdateAllImpl(this.collection);

  final IsarCollection<int, MealCollection> collection;

  @override
  int call({
    required List<int> id,
    Object? mealId = ignore,
    Object? memberId = ignore,
    Object? date = ignore,
    Object? count = ignore,
    Object? typeIndex = ignore,
    Object? statusIndex = ignore,
    Object? isFromSchedule = ignore,
    Object? guestCount = ignore,
    Object? guestName = ignore,
    Object? sharedWithMemberIdsJson = ignore,
    Object? note = ignore,
    Object? createdAt = ignore,
  }) {
    return collection.updateProperties(id, {
      if (mealId != ignore) 1: mealId as String?,
      if (memberId != ignore) 2: memberId as String?,
      if (date != ignore) 3: date as DateTime?,
      if (count != ignore) 4: count as int?,
      if (typeIndex != ignore) 5: typeIndex as int?,
      if (statusIndex != ignore) 6: statusIndex as int?,
      if (isFromSchedule != ignore) 7: isFromSchedule as bool?,
      if (guestCount != ignore) 8: guestCount as int?,
      if (guestName != ignore) 9: guestName as String?,
      if (sharedWithMemberIdsJson != ignore)
        10: sharedWithMemberIdsJson as String?,
      if (note != ignore) 11: note as String?,
      if (createdAt != ignore) 12: createdAt as DateTime?,
    });
  }
}

extension MealCollectionUpdate on IsarCollection<int, MealCollection> {
  _MealCollectionUpdate get update => _MealCollectionUpdateImpl(this);

  _MealCollectionUpdateAll get updateAll => _MealCollectionUpdateAllImpl(this);
}

sealed class _MealCollectionQueryUpdate {
  int call({
    String? mealId,
    String? memberId,
    DateTime? date,
    int? count,
    int? typeIndex,
    int? statusIndex,
    bool? isFromSchedule,
    int? guestCount,
    String? guestName,
    String? sharedWithMemberIdsJson,
    String? note,
    DateTime? createdAt,
  });
}

class _MealCollectionQueryUpdateImpl implements _MealCollectionQueryUpdate {
  const _MealCollectionQueryUpdateImpl(this.query, {this.limit});

  final IsarQuery<MealCollection> query;
  final int? limit;

  @override
  int call({
    Object? mealId = ignore,
    Object? memberId = ignore,
    Object? date = ignore,
    Object? count = ignore,
    Object? typeIndex = ignore,
    Object? statusIndex = ignore,
    Object? isFromSchedule = ignore,
    Object? guestCount = ignore,
    Object? guestName = ignore,
    Object? sharedWithMemberIdsJson = ignore,
    Object? note = ignore,
    Object? createdAt = ignore,
  }) {
    return query.updateProperties(limit: limit, {
      if (mealId != ignore) 1: mealId as String?,
      if (memberId != ignore) 2: memberId as String?,
      if (date != ignore) 3: date as DateTime?,
      if (count != ignore) 4: count as int?,
      if (typeIndex != ignore) 5: typeIndex as int?,
      if (statusIndex != ignore) 6: statusIndex as int?,
      if (isFromSchedule != ignore) 7: isFromSchedule as bool?,
      if (guestCount != ignore) 8: guestCount as int?,
      if (guestName != ignore) 9: guestName as String?,
      if (sharedWithMemberIdsJson != ignore)
        10: sharedWithMemberIdsJson as String?,
      if (note != ignore) 11: note as String?,
      if (createdAt != ignore) 12: createdAt as DateTime?,
    });
  }
}

extension MealCollectionQueryUpdate on IsarQuery<MealCollection> {
  _MealCollectionQueryUpdate get updateFirst =>
      _MealCollectionQueryUpdateImpl(this, limit: 1);

  _MealCollectionQueryUpdate get updateAll =>
      _MealCollectionQueryUpdateImpl(this);
}

class _MealCollectionQueryBuilderUpdateImpl
    implements _MealCollectionQueryUpdate {
  const _MealCollectionQueryBuilderUpdateImpl(this.query, {this.limit});

  final QueryBuilder<MealCollection, MealCollection, QOperations> query;
  final int? limit;

  @override
  int call({
    Object? mealId = ignore,
    Object? memberId = ignore,
    Object? date = ignore,
    Object? count = ignore,
    Object? typeIndex = ignore,
    Object? statusIndex = ignore,
    Object? isFromSchedule = ignore,
    Object? guestCount = ignore,
    Object? guestName = ignore,
    Object? sharedWithMemberIdsJson = ignore,
    Object? note = ignore,
    Object? createdAt = ignore,
  }) {
    final q = query.build();
    try {
      return q.updateProperties(limit: limit, {
        if (mealId != ignore) 1: mealId as String?,
        if (memberId != ignore) 2: memberId as String?,
        if (date != ignore) 3: date as DateTime?,
        if (count != ignore) 4: count as int?,
        if (typeIndex != ignore) 5: typeIndex as int?,
        if (statusIndex != ignore) 6: statusIndex as int?,
        if (isFromSchedule != ignore) 7: isFromSchedule as bool?,
        if (guestCount != ignore) 8: guestCount as int?,
        if (guestName != ignore) 9: guestName as String?,
        if (sharedWithMemberIdsJson != ignore)
          10: sharedWithMemberIdsJson as String?,
        if (note != ignore) 11: note as String?,
        if (createdAt != ignore) 12: createdAt as DateTime?,
      });
    } finally {
      q.close();
    }
  }
}

extension MealCollectionQueryBuilderUpdate
    on QueryBuilder<MealCollection, MealCollection, QOperations> {
  _MealCollectionQueryUpdate get updateFirst =>
      _MealCollectionQueryBuilderUpdateImpl(this, limit: 1);

  _MealCollectionQueryUpdate get updateAll =>
      _MealCollectionQueryBuilderUpdateImpl(this);
}

extension MealCollectionQueryFilter
    on QueryBuilder<MealCollection, MealCollection, QFilterCondition> {
  QueryBuilder<MealCollection, MealCollection, QAfterFilterCondition> idEqualTo(
    int value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(property: 0, value: value),
      );
    });
  }

  QueryBuilder<MealCollection, MealCollection, QAfterFilterCondition>
  idGreaterThan(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(property: 0, value: value),
      );
    });
  }

  QueryBuilder<MealCollection, MealCollection, QAfterFilterCondition>
  idGreaterThanOrEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(property: 0, value: value),
      );
    });
  }

  QueryBuilder<MealCollection, MealCollection, QAfterFilterCondition>
  idLessThan(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(LessCondition(property: 0, value: value));
    });
  }

  QueryBuilder<MealCollection, MealCollection, QAfterFilterCondition>
  idLessThanOrEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(property: 0, value: value),
      );
    });
  }

  QueryBuilder<MealCollection, MealCollection, QAfterFilterCondition> idBetween(
    int lower,
    int upper,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(property: 0, lower: lower, upper: upper),
      );
    });
  }

  QueryBuilder<MealCollection, MealCollection, QAfterFilterCondition>
  mealIdEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(property: 1, value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<MealCollection, MealCollection, QAfterFilterCondition>
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

  QueryBuilder<MealCollection, MealCollection, QAfterFilterCondition>
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

  QueryBuilder<MealCollection, MealCollection, QAfterFilterCondition>
  mealIdLessThan(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(property: 1, value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<MealCollection, MealCollection, QAfterFilterCondition>
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

  QueryBuilder<MealCollection, MealCollection, QAfterFilterCondition>
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

  QueryBuilder<MealCollection, MealCollection, QAfterFilterCondition>
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

  QueryBuilder<MealCollection, MealCollection, QAfterFilterCondition>
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

  QueryBuilder<MealCollection, MealCollection, QAfterFilterCondition>
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

  QueryBuilder<MealCollection, MealCollection, QAfterFilterCondition>
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

  QueryBuilder<MealCollection, MealCollection, QAfterFilterCondition>
  mealIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const EqualCondition(property: 1, value: ''),
      );
    });
  }

  QueryBuilder<MealCollection, MealCollection, QAfterFilterCondition>
  mealIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const GreaterCondition(property: 1, value: ''),
      );
    });
  }

  QueryBuilder<MealCollection, MealCollection, QAfterFilterCondition>
  memberIdEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(property: 2, value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<MealCollection, MealCollection, QAfterFilterCondition>
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

  QueryBuilder<MealCollection, MealCollection, QAfterFilterCondition>
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

  QueryBuilder<MealCollection, MealCollection, QAfterFilterCondition>
  memberIdLessThan(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(property: 2, value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<MealCollection, MealCollection, QAfterFilterCondition>
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

  QueryBuilder<MealCollection, MealCollection, QAfterFilterCondition>
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

  QueryBuilder<MealCollection, MealCollection, QAfterFilterCondition>
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

  QueryBuilder<MealCollection, MealCollection, QAfterFilterCondition>
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

  QueryBuilder<MealCollection, MealCollection, QAfterFilterCondition>
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

  QueryBuilder<MealCollection, MealCollection, QAfterFilterCondition>
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

  QueryBuilder<MealCollection, MealCollection, QAfterFilterCondition>
  memberIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const EqualCondition(property: 2, value: ''),
      );
    });
  }

  QueryBuilder<MealCollection, MealCollection, QAfterFilterCondition>
  memberIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const GreaterCondition(property: 2, value: ''),
      );
    });
  }

  QueryBuilder<MealCollection, MealCollection, QAfterFilterCondition>
  dateEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(property: 3, value: value),
      );
    });
  }

  QueryBuilder<MealCollection, MealCollection, QAfterFilterCondition>
  dateGreaterThan(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(property: 3, value: value),
      );
    });
  }

  QueryBuilder<MealCollection, MealCollection, QAfterFilterCondition>
  dateGreaterThanOrEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(property: 3, value: value),
      );
    });
  }

  QueryBuilder<MealCollection, MealCollection, QAfterFilterCondition>
  dateLessThan(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(LessCondition(property: 3, value: value));
    });
  }

  QueryBuilder<MealCollection, MealCollection, QAfterFilterCondition>
  dateLessThanOrEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(property: 3, value: value),
      );
    });
  }

  QueryBuilder<MealCollection, MealCollection, QAfterFilterCondition>
  dateBetween(DateTime lower, DateTime upper) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(property: 3, lower: lower, upper: upper),
      );
    });
  }

  QueryBuilder<MealCollection, MealCollection, QAfterFilterCondition>
  countEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(property: 4, value: value),
      );
    });
  }

  QueryBuilder<MealCollection, MealCollection, QAfterFilterCondition>
  countGreaterThan(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(property: 4, value: value),
      );
    });
  }

  QueryBuilder<MealCollection, MealCollection, QAfterFilterCondition>
  countGreaterThanOrEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(property: 4, value: value),
      );
    });
  }

  QueryBuilder<MealCollection, MealCollection, QAfterFilterCondition>
  countLessThan(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(LessCondition(property: 4, value: value));
    });
  }

  QueryBuilder<MealCollection, MealCollection, QAfterFilterCondition>
  countLessThanOrEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(property: 4, value: value),
      );
    });
  }

  QueryBuilder<MealCollection, MealCollection, QAfterFilterCondition>
  countBetween(int lower, int upper) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(property: 4, lower: lower, upper: upper),
      );
    });
  }

  QueryBuilder<MealCollection, MealCollection, QAfterFilterCondition>
  typeIndexEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(property: 5, value: value),
      );
    });
  }

  QueryBuilder<MealCollection, MealCollection, QAfterFilterCondition>
  typeIndexGreaterThan(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(property: 5, value: value),
      );
    });
  }

  QueryBuilder<MealCollection, MealCollection, QAfterFilterCondition>
  typeIndexGreaterThanOrEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(property: 5, value: value),
      );
    });
  }

  QueryBuilder<MealCollection, MealCollection, QAfterFilterCondition>
  typeIndexLessThan(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(LessCondition(property: 5, value: value));
    });
  }

  QueryBuilder<MealCollection, MealCollection, QAfterFilterCondition>
  typeIndexLessThanOrEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(property: 5, value: value),
      );
    });
  }

  QueryBuilder<MealCollection, MealCollection, QAfterFilterCondition>
  typeIndexBetween(int lower, int upper) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(property: 5, lower: lower, upper: upper),
      );
    });
  }

  QueryBuilder<MealCollection, MealCollection, QAfterFilterCondition>
  statusIndexEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(property: 6, value: value),
      );
    });
  }

  QueryBuilder<MealCollection, MealCollection, QAfterFilterCondition>
  statusIndexGreaterThan(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(property: 6, value: value),
      );
    });
  }

  QueryBuilder<MealCollection, MealCollection, QAfterFilterCondition>
  statusIndexGreaterThanOrEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(property: 6, value: value),
      );
    });
  }

  QueryBuilder<MealCollection, MealCollection, QAfterFilterCondition>
  statusIndexLessThan(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(LessCondition(property: 6, value: value));
    });
  }

  QueryBuilder<MealCollection, MealCollection, QAfterFilterCondition>
  statusIndexLessThanOrEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(property: 6, value: value),
      );
    });
  }

  QueryBuilder<MealCollection, MealCollection, QAfterFilterCondition>
  statusIndexBetween(int lower, int upper) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(property: 6, lower: lower, upper: upper),
      );
    });
  }

  QueryBuilder<MealCollection, MealCollection, QAfterFilterCondition>
  isFromScheduleEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(property: 7, value: value),
      );
    });
  }

  QueryBuilder<MealCollection, MealCollection, QAfterFilterCondition>
  guestCountEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(property: 8, value: value),
      );
    });
  }

  QueryBuilder<MealCollection, MealCollection, QAfterFilterCondition>
  guestCountGreaterThan(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(property: 8, value: value),
      );
    });
  }

  QueryBuilder<MealCollection, MealCollection, QAfterFilterCondition>
  guestCountGreaterThanOrEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(property: 8, value: value),
      );
    });
  }

  QueryBuilder<MealCollection, MealCollection, QAfterFilterCondition>
  guestCountLessThan(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(LessCondition(property: 8, value: value));
    });
  }

  QueryBuilder<MealCollection, MealCollection, QAfterFilterCondition>
  guestCountLessThanOrEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(property: 8, value: value),
      );
    });
  }

  QueryBuilder<MealCollection, MealCollection, QAfterFilterCondition>
  guestCountBetween(int lower, int upper) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(property: 8, lower: lower, upper: upper),
      );
    });
  }

  QueryBuilder<MealCollection, MealCollection, QAfterFilterCondition>
  guestNameIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const IsNullCondition(property: 9));
    });
  }

  QueryBuilder<MealCollection, MealCollection, QAfterFilterCondition>
  guestNameIsNotNull() {
    return QueryBuilder.apply(not(), (query) {
      return query.addFilterCondition(const IsNullCondition(property: 9));
    });
  }

  QueryBuilder<MealCollection, MealCollection, QAfterFilterCondition>
  guestNameEqualTo(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(property: 9, value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<MealCollection, MealCollection, QAfterFilterCondition>
  guestNameGreaterThan(String? value, {bool caseSensitive = true}) {
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

  QueryBuilder<MealCollection, MealCollection, QAfterFilterCondition>
  guestNameGreaterThanOrEqualTo(String? value, {bool caseSensitive = true}) {
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

  QueryBuilder<MealCollection, MealCollection, QAfterFilterCondition>
  guestNameLessThan(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(property: 9, value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<MealCollection, MealCollection, QAfterFilterCondition>
  guestNameLessThanOrEqualTo(String? value, {bool caseSensitive = true}) {
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

  QueryBuilder<MealCollection, MealCollection, QAfterFilterCondition>
  guestNameBetween(String? lower, String? upper, {bool caseSensitive = true}) {
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

  QueryBuilder<MealCollection, MealCollection, QAfterFilterCondition>
  guestNameStartsWith(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<MealCollection, MealCollection, QAfterFilterCondition>
  guestNameEndsWith(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<MealCollection, MealCollection, QAfterFilterCondition>
  guestNameContains(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<MealCollection, MealCollection, QAfterFilterCondition>
  guestNameMatches(String pattern, {bool caseSensitive = true}) {
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

  QueryBuilder<MealCollection, MealCollection, QAfterFilterCondition>
  guestNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const EqualCondition(property: 9, value: ''),
      );
    });
  }

  QueryBuilder<MealCollection, MealCollection, QAfterFilterCondition>
  guestNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const GreaterCondition(property: 9, value: ''),
      );
    });
  }

  QueryBuilder<MealCollection, MealCollection, QAfterFilterCondition>
  sharedWithMemberIdsJsonIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const IsNullCondition(property: 10));
    });
  }

  QueryBuilder<MealCollection, MealCollection, QAfterFilterCondition>
  sharedWithMemberIdsJsonIsNotNull() {
    return QueryBuilder.apply(not(), (query) {
      return query.addFilterCondition(const IsNullCondition(property: 10));
    });
  }

  QueryBuilder<MealCollection, MealCollection, QAfterFilterCondition>
  sharedWithMemberIdsJsonEqualTo(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(
          property: 10,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<MealCollection, MealCollection, QAfterFilterCondition>
  sharedWithMemberIdsJsonGreaterThan(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(
          property: 10,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<MealCollection, MealCollection, QAfterFilterCondition>
  sharedWithMemberIdsJsonGreaterThanOrEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(
          property: 10,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<MealCollection, MealCollection, QAfterFilterCondition>
  sharedWithMemberIdsJsonLessThan(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(property: 10, value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<MealCollection, MealCollection, QAfterFilterCondition>
  sharedWithMemberIdsJsonLessThanOrEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(
          property: 10,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<MealCollection, MealCollection, QAfterFilterCondition>
  sharedWithMemberIdsJsonBetween(
    String? lower,
    String? upper, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(
          property: 10,
          lower: lower,
          upper: upper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<MealCollection, MealCollection, QAfterFilterCondition>
  sharedWithMemberIdsJsonStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        StartsWithCondition(
          property: 10,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<MealCollection, MealCollection, QAfterFilterCondition>
  sharedWithMemberIdsJsonEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EndsWithCondition(
          property: 10,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<MealCollection, MealCollection, QAfterFilterCondition>
  sharedWithMemberIdsJsonContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        ContainsCondition(
          property: 10,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<MealCollection, MealCollection, QAfterFilterCondition>
  sharedWithMemberIdsJsonMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        MatchesCondition(
          property: 10,
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<MealCollection, MealCollection, QAfterFilterCondition>
  sharedWithMemberIdsJsonIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const EqualCondition(property: 10, value: ''),
      );
    });
  }

  QueryBuilder<MealCollection, MealCollection, QAfterFilterCondition>
  sharedWithMemberIdsJsonIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const GreaterCondition(property: 10, value: ''),
      );
    });
  }

  QueryBuilder<MealCollection, MealCollection, QAfterFilterCondition>
  noteIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const IsNullCondition(property: 11));
    });
  }

  QueryBuilder<MealCollection, MealCollection, QAfterFilterCondition>
  noteIsNotNull() {
    return QueryBuilder.apply(not(), (query) {
      return query.addFilterCondition(const IsNullCondition(property: 11));
    });
  }

  QueryBuilder<MealCollection, MealCollection, QAfterFilterCondition>
  noteEqualTo(String? value, {bool caseSensitive = true}) {
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

  QueryBuilder<MealCollection, MealCollection, QAfterFilterCondition>
  noteGreaterThan(String? value, {bool caseSensitive = true}) {
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

  QueryBuilder<MealCollection, MealCollection, QAfterFilterCondition>
  noteGreaterThanOrEqualTo(String? value, {bool caseSensitive = true}) {
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

  QueryBuilder<MealCollection, MealCollection, QAfterFilterCondition>
  noteLessThan(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(property: 11, value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<MealCollection, MealCollection, QAfterFilterCondition>
  noteLessThanOrEqualTo(String? value, {bool caseSensitive = true}) {
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

  QueryBuilder<MealCollection, MealCollection, QAfterFilterCondition>
  noteBetween(String? lower, String? upper, {bool caseSensitive = true}) {
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

  QueryBuilder<MealCollection, MealCollection, QAfterFilterCondition>
  noteStartsWith(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<MealCollection, MealCollection, QAfterFilterCondition>
  noteEndsWith(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<MealCollection, MealCollection, QAfterFilterCondition>
  noteContains(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<MealCollection, MealCollection, QAfterFilterCondition>
  noteMatches(String pattern, {bool caseSensitive = true}) {
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

  QueryBuilder<MealCollection, MealCollection, QAfterFilterCondition>
  noteIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const EqualCondition(property: 11, value: ''),
      );
    });
  }

  QueryBuilder<MealCollection, MealCollection, QAfterFilterCondition>
  noteIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const GreaterCondition(property: 11, value: ''),
      );
    });
  }

  QueryBuilder<MealCollection, MealCollection, QAfterFilterCondition>
  createdAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const IsNullCondition(property: 12));
    });
  }

  QueryBuilder<MealCollection, MealCollection, QAfterFilterCondition>
  createdAtIsNotNull() {
    return QueryBuilder.apply(not(), (query) {
      return query.addFilterCondition(const IsNullCondition(property: 12));
    });
  }

  QueryBuilder<MealCollection, MealCollection, QAfterFilterCondition>
  createdAtEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(property: 12, value: value),
      );
    });
  }

  QueryBuilder<MealCollection, MealCollection, QAfterFilterCondition>
  createdAtGreaterThan(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(property: 12, value: value),
      );
    });
  }

  QueryBuilder<MealCollection, MealCollection, QAfterFilterCondition>
  createdAtGreaterThanOrEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(property: 12, value: value),
      );
    });
  }

  QueryBuilder<MealCollection, MealCollection, QAfterFilterCondition>
  createdAtLessThan(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(property: 12, value: value),
      );
    });
  }

  QueryBuilder<MealCollection, MealCollection, QAfterFilterCondition>
  createdAtLessThanOrEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(property: 12, value: value),
      );
    });
  }

  QueryBuilder<MealCollection, MealCollection, QAfterFilterCondition>
  createdAtBetween(DateTime? lower, DateTime? upper) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(property: 12, lower: lower, upper: upper),
      );
    });
  }
}

extension MealCollectionQueryObject
    on QueryBuilder<MealCollection, MealCollection, QFilterCondition> {}

extension MealCollectionQuerySortBy
    on QueryBuilder<MealCollection, MealCollection, QSortBy> {
  QueryBuilder<MealCollection, MealCollection, QAfterSortBy> sortById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(0);
    });
  }

  QueryBuilder<MealCollection, MealCollection, QAfterSortBy> sortByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(0, sort: Sort.desc);
    });
  }

  QueryBuilder<MealCollection, MealCollection, QAfterSortBy> sortByMealId({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(1, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<MealCollection, MealCollection, QAfterSortBy> sortByMealIdDesc({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(1, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<MealCollection, MealCollection, QAfterSortBy> sortByMemberId({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(2, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<MealCollection, MealCollection, QAfterSortBy>
  sortByMemberIdDesc({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(2, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<MealCollection, MealCollection, QAfterSortBy> sortByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(3);
    });
  }

  QueryBuilder<MealCollection, MealCollection, QAfterSortBy> sortByDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(3, sort: Sort.desc);
    });
  }

  QueryBuilder<MealCollection, MealCollection, QAfterSortBy> sortByCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(4);
    });
  }

  QueryBuilder<MealCollection, MealCollection, QAfterSortBy> sortByCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(4, sort: Sort.desc);
    });
  }

  QueryBuilder<MealCollection, MealCollection, QAfterSortBy> sortByTypeIndex() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(5);
    });
  }

  QueryBuilder<MealCollection, MealCollection, QAfterSortBy>
  sortByTypeIndexDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(5, sort: Sort.desc);
    });
  }

  QueryBuilder<MealCollection, MealCollection, QAfterSortBy>
  sortByStatusIndex() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(6);
    });
  }

  QueryBuilder<MealCollection, MealCollection, QAfterSortBy>
  sortByStatusIndexDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(6, sort: Sort.desc);
    });
  }

  QueryBuilder<MealCollection, MealCollection, QAfterSortBy>
  sortByIsFromSchedule() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(7);
    });
  }

  QueryBuilder<MealCollection, MealCollection, QAfterSortBy>
  sortByIsFromScheduleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(7, sort: Sort.desc);
    });
  }

  QueryBuilder<MealCollection, MealCollection, QAfterSortBy>
  sortByGuestCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(8);
    });
  }

  QueryBuilder<MealCollection, MealCollection, QAfterSortBy>
  sortByGuestCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(8, sort: Sort.desc);
    });
  }

  QueryBuilder<MealCollection, MealCollection, QAfterSortBy> sortByGuestName({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(9, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<MealCollection, MealCollection, QAfterSortBy>
  sortByGuestNameDesc({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(9, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<MealCollection, MealCollection, QAfterSortBy>
  sortBySharedWithMemberIdsJson({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(10, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<MealCollection, MealCollection, QAfterSortBy>
  sortBySharedWithMemberIdsJsonDesc({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(10, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<MealCollection, MealCollection, QAfterSortBy> sortByNote({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(11, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<MealCollection, MealCollection, QAfterSortBy> sortByNoteDesc({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(11, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<MealCollection, MealCollection, QAfterSortBy> sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(12);
    });
  }

  QueryBuilder<MealCollection, MealCollection, QAfterSortBy>
  sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(12, sort: Sort.desc);
    });
  }
}

extension MealCollectionQuerySortThenBy
    on QueryBuilder<MealCollection, MealCollection, QSortThenBy> {
  QueryBuilder<MealCollection, MealCollection, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(0);
    });
  }

  QueryBuilder<MealCollection, MealCollection, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(0, sort: Sort.desc);
    });
  }

  QueryBuilder<MealCollection, MealCollection, QAfterSortBy> thenByMealId({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(1, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<MealCollection, MealCollection, QAfterSortBy> thenByMealIdDesc({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(1, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<MealCollection, MealCollection, QAfterSortBy> thenByMemberId({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(2, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<MealCollection, MealCollection, QAfterSortBy>
  thenByMemberIdDesc({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(2, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<MealCollection, MealCollection, QAfterSortBy> thenByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(3);
    });
  }

  QueryBuilder<MealCollection, MealCollection, QAfterSortBy> thenByDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(3, sort: Sort.desc);
    });
  }

  QueryBuilder<MealCollection, MealCollection, QAfterSortBy> thenByCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(4);
    });
  }

  QueryBuilder<MealCollection, MealCollection, QAfterSortBy> thenByCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(4, sort: Sort.desc);
    });
  }

  QueryBuilder<MealCollection, MealCollection, QAfterSortBy> thenByTypeIndex() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(5);
    });
  }

  QueryBuilder<MealCollection, MealCollection, QAfterSortBy>
  thenByTypeIndexDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(5, sort: Sort.desc);
    });
  }

  QueryBuilder<MealCollection, MealCollection, QAfterSortBy>
  thenByStatusIndex() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(6);
    });
  }

  QueryBuilder<MealCollection, MealCollection, QAfterSortBy>
  thenByStatusIndexDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(6, sort: Sort.desc);
    });
  }

  QueryBuilder<MealCollection, MealCollection, QAfterSortBy>
  thenByIsFromSchedule() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(7);
    });
  }

  QueryBuilder<MealCollection, MealCollection, QAfterSortBy>
  thenByIsFromScheduleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(7, sort: Sort.desc);
    });
  }

  QueryBuilder<MealCollection, MealCollection, QAfterSortBy>
  thenByGuestCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(8);
    });
  }

  QueryBuilder<MealCollection, MealCollection, QAfterSortBy>
  thenByGuestCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(8, sort: Sort.desc);
    });
  }

  QueryBuilder<MealCollection, MealCollection, QAfterSortBy> thenByGuestName({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(9, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<MealCollection, MealCollection, QAfterSortBy>
  thenByGuestNameDesc({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(9, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<MealCollection, MealCollection, QAfterSortBy>
  thenBySharedWithMemberIdsJson({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(10, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<MealCollection, MealCollection, QAfterSortBy>
  thenBySharedWithMemberIdsJsonDesc({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(10, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<MealCollection, MealCollection, QAfterSortBy> thenByNote({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(11, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<MealCollection, MealCollection, QAfterSortBy> thenByNoteDesc({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(11, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<MealCollection, MealCollection, QAfterSortBy> thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(12);
    });
  }

  QueryBuilder<MealCollection, MealCollection, QAfterSortBy>
  thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(12, sort: Sort.desc);
    });
  }
}

extension MealCollectionQueryWhereDistinct
    on QueryBuilder<MealCollection, MealCollection, QDistinct> {
  QueryBuilder<MealCollection, MealCollection, QAfterDistinct>
  distinctByMealId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(1, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<MealCollection, MealCollection, QAfterDistinct>
  distinctByMemberId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(2, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<MealCollection, MealCollection, QAfterDistinct>
  distinctByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(3);
    });
  }

  QueryBuilder<MealCollection, MealCollection, QAfterDistinct>
  distinctByCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(4);
    });
  }

  QueryBuilder<MealCollection, MealCollection, QAfterDistinct>
  distinctByTypeIndex() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(5);
    });
  }

  QueryBuilder<MealCollection, MealCollection, QAfterDistinct>
  distinctByStatusIndex() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(6);
    });
  }

  QueryBuilder<MealCollection, MealCollection, QAfterDistinct>
  distinctByIsFromSchedule() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(7);
    });
  }

  QueryBuilder<MealCollection, MealCollection, QAfterDistinct>
  distinctByGuestCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(8);
    });
  }

  QueryBuilder<MealCollection, MealCollection, QAfterDistinct>
  distinctByGuestName({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(9, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<MealCollection, MealCollection, QAfterDistinct>
  distinctBySharedWithMemberIdsJson({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(10, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<MealCollection, MealCollection, QAfterDistinct> distinctByNote({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(11, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<MealCollection, MealCollection, QAfterDistinct>
  distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(12);
    });
  }
}

extension MealCollectionQueryProperty1
    on QueryBuilder<MealCollection, MealCollection, QProperty> {
  QueryBuilder<MealCollection, int, QAfterProperty> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(0);
    });
  }

  QueryBuilder<MealCollection, String, QAfterProperty> mealIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(1);
    });
  }

  QueryBuilder<MealCollection, String, QAfterProperty> memberIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(2);
    });
  }

  QueryBuilder<MealCollection, DateTime, QAfterProperty> dateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(3);
    });
  }

  QueryBuilder<MealCollection, int, QAfterProperty> countProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(4);
    });
  }

  QueryBuilder<MealCollection, int, QAfterProperty> typeIndexProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(5);
    });
  }

  QueryBuilder<MealCollection, int, QAfterProperty> statusIndexProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(6);
    });
  }

  QueryBuilder<MealCollection, bool, QAfterProperty> isFromScheduleProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(7);
    });
  }

  QueryBuilder<MealCollection, int, QAfterProperty> guestCountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(8);
    });
  }

  QueryBuilder<MealCollection, String?, QAfterProperty> guestNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(9);
    });
  }

  QueryBuilder<MealCollection, String?, QAfterProperty>
  sharedWithMemberIdsJsonProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(10);
    });
  }

  QueryBuilder<MealCollection, String?, QAfterProperty> noteProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(11);
    });
  }

  QueryBuilder<MealCollection, DateTime?, QAfterProperty> createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(12);
    });
  }
}

extension MealCollectionQueryProperty2<R>
    on QueryBuilder<MealCollection, R, QAfterProperty> {
  QueryBuilder<MealCollection, (R, int), QAfterProperty> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(0);
    });
  }

  QueryBuilder<MealCollection, (R, String), QAfterProperty> mealIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(1);
    });
  }

  QueryBuilder<MealCollection, (R, String), QAfterProperty> memberIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(2);
    });
  }

  QueryBuilder<MealCollection, (R, DateTime), QAfterProperty> dateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(3);
    });
  }

  QueryBuilder<MealCollection, (R, int), QAfterProperty> countProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(4);
    });
  }

  QueryBuilder<MealCollection, (R, int), QAfterProperty> typeIndexProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(5);
    });
  }

  QueryBuilder<MealCollection, (R, int), QAfterProperty> statusIndexProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(6);
    });
  }

  QueryBuilder<MealCollection, (R, bool), QAfterProperty>
  isFromScheduleProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(7);
    });
  }

  QueryBuilder<MealCollection, (R, int), QAfterProperty> guestCountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(8);
    });
  }

  QueryBuilder<MealCollection, (R, String?), QAfterProperty>
  guestNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(9);
    });
  }

  QueryBuilder<MealCollection, (R, String?), QAfterProperty>
  sharedWithMemberIdsJsonProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(10);
    });
  }

  QueryBuilder<MealCollection, (R, String?), QAfterProperty> noteProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(11);
    });
  }

  QueryBuilder<MealCollection, (R, DateTime?), QAfterProperty>
  createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(12);
    });
  }
}

extension MealCollectionQueryProperty3<R1, R2>
    on QueryBuilder<MealCollection, (R1, R2), QAfterProperty> {
  QueryBuilder<MealCollection, (R1, R2, int), QOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(0);
    });
  }

  QueryBuilder<MealCollection, (R1, R2, String), QOperations> mealIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(1);
    });
  }

  QueryBuilder<MealCollection, (R1, R2, String), QOperations>
  memberIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(2);
    });
  }

  QueryBuilder<MealCollection, (R1, R2, DateTime), QOperations> dateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(3);
    });
  }

  QueryBuilder<MealCollection, (R1, R2, int), QOperations> countProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(4);
    });
  }

  QueryBuilder<MealCollection, (R1, R2, int), QOperations> typeIndexProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(5);
    });
  }

  QueryBuilder<MealCollection, (R1, R2, int), QOperations>
  statusIndexProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(6);
    });
  }

  QueryBuilder<MealCollection, (R1, R2, bool), QOperations>
  isFromScheduleProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(7);
    });
  }

  QueryBuilder<MealCollection, (R1, R2, int), QOperations>
  guestCountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(8);
    });
  }

  QueryBuilder<MealCollection, (R1, R2, String?), QOperations>
  guestNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(9);
    });
  }

  QueryBuilder<MealCollection, (R1, R2, String?), QOperations>
  sharedWithMemberIdsJsonProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(10);
    });
  }

  QueryBuilder<MealCollection, (R1, R2, String?), QOperations> noteProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(11);
    });
  }

  QueryBuilder<MealCollection, (R1, R2, DateTime?), QOperations>
  createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(12);
    });
  }
}
