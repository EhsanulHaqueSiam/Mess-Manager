// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'member_collection.dart';

// **************************************************************************
// _IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, invalid_use_of_protected_member, lines_longer_than_80_chars, constant_identifier_names, avoid_js_rounded_ints, no_leading_underscores_for_local_identifiers, require_trailing_commas, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_in_if_null_operators, library_private_types_in_public_api, prefer_const_constructors
// ignore_for_file: type=lint

extension GetMemberCollectionCollection on Isar {
  IsarCollection<int, MemberCollection> get memberCollections =>
      this.collection();
}

final MemberCollectionSchema = IsarGeneratedSchema(
  schema: IsarSchema(
    name: 'MemberCollection',
    idName: 'id',
    embedded: false,
    properties: [
      IsarPropertySchema(name: 'memberId', type: IsarType.string),
      IsarPropertySchema(name: 'name', type: IsarType.string),
      IsarPropertySchema(name: 'roleIndex', type: IsarType.long),
      IsarPropertySchema(name: 'avatarUrl', type: IsarType.string),
      IsarPropertySchema(name: 'phone', type: IsarType.string),
      IsarPropertySchema(name: 'balance', type: IsarType.double),
      IsarPropertySchema(name: 'joinedAt', type: IsarType.dateTime),
      IsarPropertySchema(name: 'activeFromDate', type: IsarType.dateTime),
      IsarPropertySchema(name: 'activeToDate', type: IsarType.dateTime),
      IsarPropertySchema(name: 'isActive', type: IsarType.bool),
      IsarPropertySchema(name: 'preferencesJson', type: IsarType.string),
    ],
    indexes: [
      IsarIndexSchema(
        name: 'memberId',
        properties: ["memberId"],
        unique: true,
        hash: false,
      ),
    ],
  ),
  converter: IsarObjectConverter<int, MemberCollection>(
    serialize: serializeMemberCollection,
    deserialize: deserializeMemberCollection,
    deserializeProperty: deserializeMemberCollectionProp,
  ),
  getEmbeddedSchemas: () => [],
);

@isarProtected
int serializeMemberCollection(IsarWriter writer, MemberCollection object) {
  IsarCore.writeString(writer, 1, object.memberId);
  IsarCore.writeString(writer, 2, object.name);
  IsarCore.writeLong(writer, 3, object.roleIndex);
  {
    final value = object.avatarUrl;
    if (value == null) {
      IsarCore.writeNull(writer, 4);
    } else {
      IsarCore.writeString(writer, 4, value);
    }
  }
  {
    final value = object.phone;
    if (value == null) {
      IsarCore.writeNull(writer, 5);
    } else {
      IsarCore.writeString(writer, 5, value);
    }
  }
  IsarCore.writeDouble(writer, 6, object.balance);
  IsarCore.writeLong(
    writer,
    7,
    object.joinedAt?.toUtc().microsecondsSinceEpoch ?? -9223372036854775808,
  );
  IsarCore.writeLong(
    writer,
    8,
    object.activeFromDate?.toUtc().microsecondsSinceEpoch ??
        -9223372036854775808,
  );
  IsarCore.writeLong(
    writer,
    9,
    object.activeToDate?.toUtc().microsecondsSinceEpoch ?? -9223372036854775808,
  );
  IsarCore.writeBool(writer, 10, value: object.isActive);
  {
    final value = object.preferencesJson;
    if (value == null) {
      IsarCore.writeNull(writer, 11);
    } else {
      IsarCore.writeString(writer, 11, value);
    }
  }
  return object.id;
}

@isarProtected
MemberCollection deserializeMemberCollection(IsarReader reader) {
  final object = MemberCollection();
  object.id = IsarCore.readId(reader);
  object.memberId = IsarCore.readString(reader, 1) ?? '';
  object.name = IsarCore.readString(reader, 2) ?? '';
  object.roleIndex = IsarCore.readLong(reader, 3);
  object.avatarUrl = IsarCore.readString(reader, 4);
  object.phone = IsarCore.readString(reader, 5);
  object.balance = IsarCore.readDouble(reader, 6);
  {
    final value = IsarCore.readLong(reader, 7);
    if (value == -9223372036854775808) {
      object.joinedAt = null;
    } else {
      object.joinedAt = DateTime.fromMicrosecondsSinceEpoch(
        value,
        isUtc: true,
      ).toLocal();
    }
  }
  {
    final value = IsarCore.readLong(reader, 8);
    if (value == -9223372036854775808) {
      object.activeFromDate = null;
    } else {
      object.activeFromDate = DateTime.fromMicrosecondsSinceEpoch(
        value,
        isUtc: true,
      ).toLocal();
    }
  }
  {
    final value = IsarCore.readLong(reader, 9);
    if (value == -9223372036854775808) {
      object.activeToDate = null;
    } else {
      object.activeToDate = DateTime.fromMicrosecondsSinceEpoch(
        value,
        isUtc: true,
      ).toLocal();
    }
  }
  object.isActive = IsarCore.readBool(reader, 10);
  object.preferencesJson = IsarCore.readString(reader, 11);
  return object;
}

@isarProtected
dynamic deserializeMemberCollectionProp(IsarReader reader, int property) {
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
      return IsarCore.readString(reader, 4);
    case 5:
      return IsarCore.readString(reader, 5);
    case 6:
      return IsarCore.readDouble(reader, 6);
    case 7:
      {
        final value = IsarCore.readLong(reader, 7);
        if (value == -9223372036854775808) {
          return null;
        } else {
          return DateTime.fromMicrosecondsSinceEpoch(
            value,
            isUtc: true,
          ).toLocal();
        }
      }
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
    case 10:
      return IsarCore.readBool(reader, 10);
    case 11:
      return IsarCore.readString(reader, 11);
    default:
      throw ArgumentError('Unknown property: $property');
  }
}

sealed class _MemberCollectionUpdate {
  bool call({
    required int id,
    String? memberId,
    String? name,
    int? roleIndex,
    String? avatarUrl,
    String? phone,
    double? balance,
    DateTime? joinedAt,
    DateTime? activeFromDate,
    DateTime? activeToDate,
    bool? isActive,
    String? preferencesJson,
  });
}

class _MemberCollectionUpdateImpl implements _MemberCollectionUpdate {
  const _MemberCollectionUpdateImpl(this.collection);

  final IsarCollection<int, MemberCollection> collection;

  @override
  bool call({
    required int id,
    Object? memberId = ignore,
    Object? name = ignore,
    Object? roleIndex = ignore,
    Object? avatarUrl = ignore,
    Object? phone = ignore,
    Object? balance = ignore,
    Object? joinedAt = ignore,
    Object? activeFromDate = ignore,
    Object? activeToDate = ignore,
    Object? isActive = ignore,
    Object? preferencesJson = ignore,
  }) {
    return collection.updateProperties(
          [id],
          {
            if (memberId != ignore) 1: memberId as String?,
            if (name != ignore) 2: name as String?,
            if (roleIndex != ignore) 3: roleIndex as int?,
            if (avatarUrl != ignore) 4: avatarUrl as String?,
            if (phone != ignore) 5: phone as String?,
            if (balance != ignore) 6: balance as double?,
            if (joinedAt != ignore) 7: joinedAt as DateTime?,
            if (activeFromDate != ignore) 8: activeFromDate as DateTime?,
            if (activeToDate != ignore) 9: activeToDate as DateTime?,
            if (isActive != ignore) 10: isActive as bool?,
            if (preferencesJson != ignore) 11: preferencesJson as String?,
          },
        ) >
        0;
  }
}

sealed class _MemberCollectionUpdateAll {
  int call({
    required List<int> id,
    String? memberId,
    String? name,
    int? roleIndex,
    String? avatarUrl,
    String? phone,
    double? balance,
    DateTime? joinedAt,
    DateTime? activeFromDate,
    DateTime? activeToDate,
    bool? isActive,
    String? preferencesJson,
  });
}

class _MemberCollectionUpdateAllImpl implements _MemberCollectionUpdateAll {
  const _MemberCollectionUpdateAllImpl(this.collection);

  final IsarCollection<int, MemberCollection> collection;

  @override
  int call({
    required List<int> id,
    Object? memberId = ignore,
    Object? name = ignore,
    Object? roleIndex = ignore,
    Object? avatarUrl = ignore,
    Object? phone = ignore,
    Object? balance = ignore,
    Object? joinedAt = ignore,
    Object? activeFromDate = ignore,
    Object? activeToDate = ignore,
    Object? isActive = ignore,
    Object? preferencesJson = ignore,
  }) {
    return collection.updateProperties(id, {
      if (memberId != ignore) 1: memberId as String?,
      if (name != ignore) 2: name as String?,
      if (roleIndex != ignore) 3: roleIndex as int?,
      if (avatarUrl != ignore) 4: avatarUrl as String?,
      if (phone != ignore) 5: phone as String?,
      if (balance != ignore) 6: balance as double?,
      if (joinedAt != ignore) 7: joinedAt as DateTime?,
      if (activeFromDate != ignore) 8: activeFromDate as DateTime?,
      if (activeToDate != ignore) 9: activeToDate as DateTime?,
      if (isActive != ignore) 10: isActive as bool?,
      if (preferencesJson != ignore) 11: preferencesJson as String?,
    });
  }
}

extension MemberCollectionUpdate on IsarCollection<int, MemberCollection> {
  _MemberCollectionUpdate get update => _MemberCollectionUpdateImpl(this);

  _MemberCollectionUpdateAll get updateAll =>
      _MemberCollectionUpdateAllImpl(this);
}

sealed class _MemberCollectionQueryUpdate {
  int call({
    String? memberId,
    String? name,
    int? roleIndex,
    String? avatarUrl,
    String? phone,
    double? balance,
    DateTime? joinedAt,
    DateTime? activeFromDate,
    DateTime? activeToDate,
    bool? isActive,
    String? preferencesJson,
  });
}

class _MemberCollectionQueryUpdateImpl implements _MemberCollectionQueryUpdate {
  const _MemberCollectionQueryUpdateImpl(this.query, {this.limit});

  final IsarQuery<MemberCollection> query;
  final int? limit;

  @override
  int call({
    Object? memberId = ignore,
    Object? name = ignore,
    Object? roleIndex = ignore,
    Object? avatarUrl = ignore,
    Object? phone = ignore,
    Object? balance = ignore,
    Object? joinedAt = ignore,
    Object? activeFromDate = ignore,
    Object? activeToDate = ignore,
    Object? isActive = ignore,
    Object? preferencesJson = ignore,
  }) {
    return query.updateProperties(limit: limit, {
      if (memberId != ignore) 1: memberId as String?,
      if (name != ignore) 2: name as String?,
      if (roleIndex != ignore) 3: roleIndex as int?,
      if (avatarUrl != ignore) 4: avatarUrl as String?,
      if (phone != ignore) 5: phone as String?,
      if (balance != ignore) 6: balance as double?,
      if (joinedAt != ignore) 7: joinedAt as DateTime?,
      if (activeFromDate != ignore) 8: activeFromDate as DateTime?,
      if (activeToDate != ignore) 9: activeToDate as DateTime?,
      if (isActive != ignore) 10: isActive as bool?,
      if (preferencesJson != ignore) 11: preferencesJson as String?,
    });
  }
}

extension MemberCollectionQueryUpdate on IsarQuery<MemberCollection> {
  _MemberCollectionQueryUpdate get updateFirst =>
      _MemberCollectionQueryUpdateImpl(this, limit: 1);

  _MemberCollectionQueryUpdate get updateAll =>
      _MemberCollectionQueryUpdateImpl(this);
}

class _MemberCollectionQueryBuilderUpdateImpl
    implements _MemberCollectionQueryUpdate {
  const _MemberCollectionQueryBuilderUpdateImpl(this.query, {this.limit});

  final QueryBuilder<MemberCollection, MemberCollection, QOperations> query;
  final int? limit;

  @override
  int call({
    Object? memberId = ignore,
    Object? name = ignore,
    Object? roleIndex = ignore,
    Object? avatarUrl = ignore,
    Object? phone = ignore,
    Object? balance = ignore,
    Object? joinedAt = ignore,
    Object? activeFromDate = ignore,
    Object? activeToDate = ignore,
    Object? isActive = ignore,
    Object? preferencesJson = ignore,
  }) {
    final q = query.build();
    try {
      return q.updateProperties(limit: limit, {
        if (memberId != ignore) 1: memberId as String?,
        if (name != ignore) 2: name as String?,
        if (roleIndex != ignore) 3: roleIndex as int?,
        if (avatarUrl != ignore) 4: avatarUrl as String?,
        if (phone != ignore) 5: phone as String?,
        if (balance != ignore) 6: balance as double?,
        if (joinedAt != ignore) 7: joinedAt as DateTime?,
        if (activeFromDate != ignore) 8: activeFromDate as DateTime?,
        if (activeToDate != ignore) 9: activeToDate as DateTime?,
        if (isActive != ignore) 10: isActive as bool?,
        if (preferencesJson != ignore) 11: preferencesJson as String?,
      });
    } finally {
      q.close();
    }
  }
}

extension MemberCollectionQueryBuilderUpdate
    on QueryBuilder<MemberCollection, MemberCollection, QOperations> {
  _MemberCollectionQueryUpdate get updateFirst =>
      _MemberCollectionQueryBuilderUpdateImpl(this, limit: 1);

  _MemberCollectionQueryUpdate get updateAll =>
      _MemberCollectionQueryBuilderUpdateImpl(this);
}

extension MemberCollectionQueryFilter
    on QueryBuilder<MemberCollection, MemberCollection, QFilterCondition> {
  QueryBuilder<MemberCollection, MemberCollection, QAfterFilterCondition>
  idEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(property: 0, value: value),
      );
    });
  }

  QueryBuilder<MemberCollection, MemberCollection, QAfterFilterCondition>
  idGreaterThan(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(property: 0, value: value),
      );
    });
  }

  QueryBuilder<MemberCollection, MemberCollection, QAfterFilterCondition>
  idGreaterThanOrEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(property: 0, value: value),
      );
    });
  }

  QueryBuilder<MemberCollection, MemberCollection, QAfterFilterCondition>
  idLessThan(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(LessCondition(property: 0, value: value));
    });
  }

  QueryBuilder<MemberCollection, MemberCollection, QAfterFilterCondition>
  idLessThanOrEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(property: 0, value: value),
      );
    });
  }

  QueryBuilder<MemberCollection, MemberCollection, QAfterFilterCondition>
  idBetween(int lower, int upper) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(property: 0, lower: lower, upper: upper),
      );
    });
  }

  QueryBuilder<MemberCollection, MemberCollection, QAfterFilterCondition>
  memberIdEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(property: 1, value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<MemberCollection, MemberCollection, QAfterFilterCondition>
  memberIdGreaterThan(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<MemberCollection, MemberCollection, QAfterFilterCondition>
  memberIdGreaterThanOrEqualTo(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<MemberCollection, MemberCollection, QAfterFilterCondition>
  memberIdLessThan(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(property: 1, value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<MemberCollection, MemberCollection, QAfterFilterCondition>
  memberIdLessThanOrEqualTo(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<MemberCollection, MemberCollection, QAfterFilterCondition>
  memberIdBetween(String lower, String upper, {bool caseSensitive = true}) {
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

  QueryBuilder<MemberCollection, MemberCollection, QAfterFilterCondition>
  memberIdStartsWith(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<MemberCollection, MemberCollection, QAfterFilterCondition>
  memberIdEndsWith(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<MemberCollection, MemberCollection, QAfterFilterCondition>
  memberIdContains(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<MemberCollection, MemberCollection, QAfterFilterCondition>
  memberIdMatches(String pattern, {bool caseSensitive = true}) {
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

  QueryBuilder<MemberCollection, MemberCollection, QAfterFilterCondition>
  memberIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const EqualCondition(property: 1, value: ''),
      );
    });
  }

  QueryBuilder<MemberCollection, MemberCollection, QAfterFilterCondition>
  memberIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const GreaterCondition(property: 1, value: ''),
      );
    });
  }

  QueryBuilder<MemberCollection, MemberCollection, QAfterFilterCondition>
  nameEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(property: 2, value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<MemberCollection, MemberCollection, QAfterFilterCondition>
  nameGreaterThan(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<MemberCollection, MemberCollection, QAfterFilterCondition>
  nameGreaterThanOrEqualTo(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<MemberCollection, MemberCollection, QAfterFilterCondition>
  nameLessThan(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(property: 2, value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<MemberCollection, MemberCollection, QAfterFilterCondition>
  nameLessThanOrEqualTo(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<MemberCollection, MemberCollection, QAfterFilterCondition>
  nameBetween(String lower, String upper, {bool caseSensitive = true}) {
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

  QueryBuilder<MemberCollection, MemberCollection, QAfterFilterCondition>
  nameStartsWith(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<MemberCollection, MemberCollection, QAfterFilterCondition>
  nameEndsWith(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<MemberCollection, MemberCollection, QAfterFilterCondition>
  nameContains(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<MemberCollection, MemberCollection, QAfterFilterCondition>
  nameMatches(String pattern, {bool caseSensitive = true}) {
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

  QueryBuilder<MemberCollection, MemberCollection, QAfterFilterCondition>
  nameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const EqualCondition(property: 2, value: ''),
      );
    });
  }

  QueryBuilder<MemberCollection, MemberCollection, QAfterFilterCondition>
  nameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const GreaterCondition(property: 2, value: ''),
      );
    });
  }

  QueryBuilder<MemberCollection, MemberCollection, QAfterFilterCondition>
  roleIndexEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(property: 3, value: value),
      );
    });
  }

  QueryBuilder<MemberCollection, MemberCollection, QAfterFilterCondition>
  roleIndexGreaterThan(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(property: 3, value: value),
      );
    });
  }

  QueryBuilder<MemberCollection, MemberCollection, QAfterFilterCondition>
  roleIndexGreaterThanOrEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(property: 3, value: value),
      );
    });
  }

  QueryBuilder<MemberCollection, MemberCollection, QAfterFilterCondition>
  roleIndexLessThan(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(LessCondition(property: 3, value: value));
    });
  }

  QueryBuilder<MemberCollection, MemberCollection, QAfterFilterCondition>
  roleIndexLessThanOrEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(property: 3, value: value),
      );
    });
  }

  QueryBuilder<MemberCollection, MemberCollection, QAfterFilterCondition>
  roleIndexBetween(int lower, int upper) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(property: 3, lower: lower, upper: upper),
      );
    });
  }

  QueryBuilder<MemberCollection, MemberCollection, QAfterFilterCondition>
  avatarUrlIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const IsNullCondition(property: 4));
    });
  }

  QueryBuilder<MemberCollection, MemberCollection, QAfterFilterCondition>
  avatarUrlIsNotNull() {
    return QueryBuilder.apply(not(), (query) {
      return query.addFilterCondition(const IsNullCondition(property: 4));
    });
  }

  QueryBuilder<MemberCollection, MemberCollection, QAfterFilterCondition>
  avatarUrlEqualTo(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(property: 4, value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<MemberCollection, MemberCollection, QAfterFilterCondition>
  avatarUrlGreaterThan(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(
          property: 4,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<MemberCollection, MemberCollection, QAfterFilterCondition>
  avatarUrlGreaterThanOrEqualTo(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(
          property: 4,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<MemberCollection, MemberCollection, QAfterFilterCondition>
  avatarUrlLessThan(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(property: 4, value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<MemberCollection, MemberCollection, QAfterFilterCondition>
  avatarUrlLessThanOrEqualTo(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(
          property: 4,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<MemberCollection, MemberCollection, QAfterFilterCondition>
  avatarUrlBetween(String? lower, String? upper, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(
          property: 4,
          lower: lower,
          upper: upper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<MemberCollection, MemberCollection, QAfterFilterCondition>
  avatarUrlStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        StartsWithCondition(
          property: 4,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<MemberCollection, MemberCollection, QAfterFilterCondition>
  avatarUrlEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EndsWithCondition(
          property: 4,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<MemberCollection, MemberCollection, QAfterFilterCondition>
  avatarUrlContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        ContainsCondition(
          property: 4,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<MemberCollection, MemberCollection, QAfterFilterCondition>
  avatarUrlMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        MatchesCondition(
          property: 4,
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<MemberCollection, MemberCollection, QAfterFilterCondition>
  avatarUrlIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const EqualCondition(property: 4, value: ''),
      );
    });
  }

  QueryBuilder<MemberCollection, MemberCollection, QAfterFilterCondition>
  avatarUrlIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const GreaterCondition(property: 4, value: ''),
      );
    });
  }

  QueryBuilder<MemberCollection, MemberCollection, QAfterFilterCondition>
  phoneIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const IsNullCondition(property: 5));
    });
  }

  QueryBuilder<MemberCollection, MemberCollection, QAfterFilterCondition>
  phoneIsNotNull() {
    return QueryBuilder.apply(not(), (query) {
      return query.addFilterCondition(const IsNullCondition(property: 5));
    });
  }

  QueryBuilder<MemberCollection, MemberCollection, QAfterFilterCondition>
  phoneEqualTo(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(property: 5, value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<MemberCollection, MemberCollection, QAfterFilterCondition>
  phoneGreaterThan(String? value, {bool caseSensitive = true}) {
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

  QueryBuilder<MemberCollection, MemberCollection, QAfterFilterCondition>
  phoneGreaterThanOrEqualTo(String? value, {bool caseSensitive = true}) {
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

  QueryBuilder<MemberCollection, MemberCollection, QAfterFilterCondition>
  phoneLessThan(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(property: 5, value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<MemberCollection, MemberCollection, QAfterFilterCondition>
  phoneLessThanOrEqualTo(String? value, {bool caseSensitive = true}) {
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

  QueryBuilder<MemberCollection, MemberCollection, QAfterFilterCondition>
  phoneBetween(String? lower, String? upper, {bool caseSensitive = true}) {
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

  QueryBuilder<MemberCollection, MemberCollection, QAfterFilterCondition>
  phoneStartsWith(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<MemberCollection, MemberCollection, QAfterFilterCondition>
  phoneEndsWith(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<MemberCollection, MemberCollection, QAfterFilterCondition>
  phoneContains(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<MemberCollection, MemberCollection, QAfterFilterCondition>
  phoneMatches(String pattern, {bool caseSensitive = true}) {
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

  QueryBuilder<MemberCollection, MemberCollection, QAfterFilterCondition>
  phoneIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const EqualCondition(property: 5, value: ''),
      );
    });
  }

  QueryBuilder<MemberCollection, MemberCollection, QAfterFilterCondition>
  phoneIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const GreaterCondition(property: 5, value: ''),
      );
    });
  }

  QueryBuilder<MemberCollection, MemberCollection, QAfterFilterCondition>
  balanceEqualTo(double value, {double epsilon = Filter.epsilon}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(property: 6, value: value, epsilon: epsilon),
      );
    });
  }

  QueryBuilder<MemberCollection, MemberCollection, QAfterFilterCondition>
  balanceGreaterThan(double value, {double epsilon = Filter.epsilon}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(property: 6, value: value, epsilon: epsilon),
      );
    });
  }

  QueryBuilder<MemberCollection, MemberCollection, QAfterFilterCondition>
  balanceGreaterThanOrEqualTo(double value, {double epsilon = Filter.epsilon}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(property: 6, value: value, epsilon: epsilon),
      );
    });
  }

  QueryBuilder<MemberCollection, MemberCollection, QAfterFilterCondition>
  balanceLessThan(double value, {double epsilon = Filter.epsilon}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(property: 6, value: value, epsilon: epsilon),
      );
    });
  }

  QueryBuilder<MemberCollection, MemberCollection, QAfterFilterCondition>
  balanceLessThanOrEqualTo(double value, {double epsilon = Filter.epsilon}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(property: 6, value: value, epsilon: epsilon),
      );
    });
  }

  QueryBuilder<MemberCollection, MemberCollection, QAfterFilterCondition>
  balanceBetween(
    double lower,
    double upper, {
    double epsilon = Filter.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(
          property: 6,
          lower: lower,
          upper: upper,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<MemberCollection, MemberCollection, QAfterFilterCondition>
  joinedAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const IsNullCondition(property: 7));
    });
  }

  QueryBuilder<MemberCollection, MemberCollection, QAfterFilterCondition>
  joinedAtIsNotNull() {
    return QueryBuilder.apply(not(), (query) {
      return query.addFilterCondition(const IsNullCondition(property: 7));
    });
  }

  QueryBuilder<MemberCollection, MemberCollection, QAfterFilterCondition>
  joinedAtEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(property: 7, value: value),
      );
    });
  }

  QueryBuilder<MemberCollection, MemberCollection, QAfterFilterCondition>
  joinedAtGreaterThan(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(property: 7, value: value),
      );
    });
  }

  QueryBuilder<MemberCollection, MemberCollection, QAfterFilterCondition>
  joinedAtGreaterThanOrEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(property: 7, value: value),
      );
    });
  }

  QueryBuilder<MemberCollection, MemberCollection, QAfterFilterCondition>
  joinedAtLessThan(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(LessCondition(property: 7, value: value));
    });
  }

  QueryBuilder<MemberCollection, MemberCollection, QAfterFilterCondition>
  joinedAtLessThanOrEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(property: 7, value: value),
      );
    });
  }

  QueryBuilder<MemberCollection, MemberCollection, QAfterFilterCondition>
  joinedAtBetween(DateTime? lower, DateTime? upper) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(property: 7, lower: lower, upper: upper),
      );
    });
  }

  QueryBuilder<MemberCollection, MemberCollection, QAfterFilterCondition>
  activeFromDateIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const IsNullCondition(property: 8));
    });
  }

  QueryBuilder<MemberCollection, MemberCollection, QAfterFilterCondition>
  activeFromDateIsNotNull() {
    return QueryBuilder.apply(not(), (query) {
      return query.addFilterCondition(const IsNullCondition(property: 8));
    });
  }

  QueryBuilder<MemberCollection, MemberCollection, QAfterFilterCondition>
  activeFromDateEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(property: 8, value: value),
      );
    });
  }

  QueryBuilder<MemberCollection, MemberCollection, QAfterFilterCondition>
  activeFromDateGreaterThan(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(property: 8, value: value),
      );
    });
  }

  QueryBuilder<MemberCollection, MemberCollection, QAfterFilterCondition>
  activeFromDateGreaterThanOrEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(property: 8, value: value),
      );
    });
  }

  QueryBuilder<MemberCollection, MemberCollection, QAfterFilterCondition>
  activeFromDateLessThan(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(LessCondition(property: 8, value: value));
    });
  }

  QueryBuilder<MemberCollection, MemberCollection, QAfterFilterCondition>
  activeFromDateLessThanOrEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(property: 8, value: value),
      );
    });
  }

  QueryBuilder<MemberCollection, MemberCollection, QAfterFilterCondition>
  activeFromDateBetween(DateTime? lower, DateTime? upper) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(property: 8, lower: lower, upper: upper),
      );
    });
  }

  QueryBuilder<MemberCollection, MemberCollection, QAfterFilterCondition>
  activeToDateIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const IsNullCondition(property: 9));
    });
  }

  QueryBuilder<MemberCollection, MemberCollection, QAfterFilterCondition>
  activeToDateIsNotNull() {
    return QueryBuilder.apply(not(), (query) {
      return query.addFilterCondition(const IsNullCondition(property: 9));
    });
  }

  QueryBuilder<MemberCollection, MemberCollection, QAfterFilterCondition>
  activeToDateEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(property: 9, value: value),
      );
    });
  }

  QueryBuilder<MemberCollection, MemberCollection, QAfterFilterCondition>
  activeToDateGreaterThan(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(property: 9, value: value),
      );
    });
  }

  QueryBuilder<MemberCollection, MemberCollection, QAfterFilterCondition>
  activeToDateGreaterThanOrEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(property: 9, value: value),
      );
    });
  }

  QueryBuilder<MemberCollection, MemberCollection, QAfterFilterCondition>
  activeToDateLessThan(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(LessCondition(property: 9, value: value));
    });
  }

  QueryBuilder<MemberCollection, MemberCollection, QAfterFilterCondition>
  activeToDateLessThanOrEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(property: 9, value: value),
      );
    });
  }

  QueryBuilder<MemberCollection, MemberCollection, QAfterFilterCondition>
  activeToDateBetween(DateTime? lower, DateTime? upper) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(property: 9, lower: lower, upper: upper),
      );
    });
  }

  QueryBuilder<MemberCollection, MemberCollection, QAfterFilterCondition>
  isActiveEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(property: 10, value: value),
      );
    });
  }

  QueryBuilder<MemberCollection, MemberCollection, QAfterFilterCondition>
  preferencesJsonIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const IsNullCondition(property: 11));
    });
  }

  QueryBuilder<MemberCollection, MemberCollection, QAfterFilterCondition>
  preferencesJsonIsNotNull() {
    return QueryBuilder.apply(not(), (query) {
      return query.addFilterCondition(const IsNullCondition(property: 11));
    });
  }

  QueryBuilder<MemberCollection, MemberCollection, QAfterFilterCondition>
  preferencesJsonEqualTo(String? value, {bool caseSensitive = true}) {
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

  QueryBuilder<MemberCollection, MemberCollection, QAfterFilterCondition>
  preferencesJsonGreaterThan(String? value, {bool caseSensitive = true}) {
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

  QueryBuilder<MemberCollection, MemberCollection, QAfterFilterCondition>
  preferencesJsonGreaterThanOrEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
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

  QueryBuilder<MemberCollection, MemberCollection, QAfterFilterCondition>
  preferencesJsonLessThan(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(property: 11, value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<MemberCollection, MemberCollection, QAfterFilterCondition>
  preferencesJsonLessThanOrEqualTo(String? value, {bool caseSensitive = true}) {
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

  QueryBuilder<MemberCollection, MemberCollection, QAfterFilterCondition>
  preferencesJsonBetween(
    String? lower,
    String? upper, {
    bool caseSensitive = true,
  }) {
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

  QueryBuilder<MemberCollection, MemberCollection, QAfterFilterCondition>
  preferencesJsonStartsWith(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<MemberCollection, MemberCollection, QAfterFilterCondition>
  preferencesJsonEndsWith(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<MemberCollection, MemberCollection, QAfterFilterCondition>
  preferencesJsonContains(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<MemberCollection, MemberCollection, QAfterFilterCondition>
  preferencesJsonMatches(String pattern, {bool caseSensitive = true}) {
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

  QueryBuilder<MemberCollection, MemberCollection, QAfterFilterCondition>
  preferencesJsonIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const EqualCondition(property: 11, value: ''),
      );
    });
  }

  QueryBuilder<MemberCollection, MemberCollection, QAfterFilterCondition>
  preferencesJsonIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const GreaterCondition(property: 11, value: ''),
      );
    });
  }
}

extension MemberCollectionQueryObject
    on QueryBuilder<MemberCollection, MemberCollection, QFilterCondition> {}

extension MemberCollectionQuerySortBy
    on QueryBuilder<MemberCollection, MemberCollection, QSortBy> {
  QueryBuilder<MemberCollection, MemberCollection, QAfterSortBy> sortById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(0);
    });
  }

  QueryBuilder<MemberCollection, MemberCollection, QAfterSortBy>
  sortByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(0, sort: Sort.desc);
    });
  }

  QueryBuilder<MemberCollection, MemberCollection, QAfterSortBy>
  sortByMemberId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(1, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<MemberCollection, MemberCollection, QAfterSortBy>
  sortByMemberIdDesc({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(1, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<MemberCollection, MemberCollection, QAfterSortBy> sortByName({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(2, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<MemberCollection, MemberCollection, QAfterSortBy>
  sortByNameDesc({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(2, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<MemberCollection, MemberCollection, QAfterSortBy>
  sortByRoleIndex() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(3);
    });
  }

  QueryBuilder<MemberCollection, MemberCollection, QAfterSortBy>
  sortByRoleIndexDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(3, sort: Sort.desc);
    });
  }

  QueryBuilder<MemberCollection, MemberCollection, QAfterSortBy>
  sortByAvatarUrl({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(4, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<MemberCollection, MemberCollection, QAfterSortBy>
  sortByAvatarUrlDesc({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(4, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<MemberCollection, MemberCollection, QAfterSortBy> sortByPhone({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(5, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<MemberCollection, MemberCollection, QAfterSortBy>
  sortByPhoneDesc({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(5, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<MemberCollection, MemberCollection, QAfterSortBy>
  sortByBalance() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(6);
    });
  }

  QueryBuilder<MemberCollection, MemberCollection, QAfterSortBy>
  sortByBalanceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(6, sort: Sort.desc);
    });
  }

  QueryBuilder<MemberCollection, MemberCollection, QAfterSortBy>
  sortByJoinedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(7);
    });
  }

  QueryBuilder<MemberCollection, MemberCollection, QAfterSortBy>
  sortByJoinedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(7, sort: Sort.desc);
    });
  }

  QueryBuilder<MemberCollection, MemberCollection, QAfterSortBy>
  sortByActiveFromDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(8);
    });
  }

  QueryBuilder<MemberCollection, MemberCollection, QAfterSortBy>
  sortByActiveFromDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(8, sort: Sort.desc);
    });
  }

  QueryBuilder<MemberCollection, MemberCollection, QAfterSortBy>
  sortByActiveToDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(9);
    });
  }

  QueryBuilder<MemberCollection, MemberCollection, QAfterSortBy>
  sortByActiveToDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(9, sort: Sort.desc);
    });
  }

  QueryBuilder<MemberCollection, MemberCollection, QAfterSortBy>
  sortByIsActive() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(10);
    });
  }

  QueryBuilder<MemberCollection, MemberCollection, QAfterSortBy>
  sortByIsActiveDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(10, sort: Sort.desc);
    });
  }

  QueryBuilder<MemberCollection, MemberCollection, QAfterSortBy>
  sortByPreferencesJson({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(11, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<MemberCollection, MemberCollection, QAfterSortBy>
  sortByPreferencesJsonDesc({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(11, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }
}

extension MemberCollectionQuerySortThenBy
    on QueryBuilder<MemberCollection, MemberCollection, QSortThenBy> {
  QueryBuilder<MemberCollection, MemberCollection, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(0);
    });
  }

  QueryBuilder<MemberCollection, MemberCollection, QAfterSortBy>
  thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(0, sort: Sort.desc);
    });
  }

  QueryBuilder<MemberCollection, MemberCollection, QAfterSortBy>
  thenByMemberId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(1, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<MemberCollection, MemberCollection, QAfterSortBy>
  thenByMemberIdDesc({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(1, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<MemberCollection, MemberCollection, QAfterSortBy> thenByName({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(2, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<MemberCollection, MemberCollection, QAfterSortBy>
  thenByNameDesc({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(2, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<MemberCollection, MemberCollection, QAfterSortBy>
  thenByRoleIndex() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(3);
    });
  }

  QueryBuilder<MemberCollection, MemberCollection, QAfterSortBy>
  thenByRoleIndexDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(3, sort: Sort.desc);
    });
  }

  QueryBuilder<MemberCollection, MemberCollection, QAfterSortBy>
  thenByAvatarUrl({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(4, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<MemberCollection, MemberCollection, QAfterSortBy>
  thenByAvatarUrlDesc({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(4, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<MemberCollection, MemberCollection, QAfterSortBy> thenByPhone({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(5, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<MemberCollection, MemberCollection, QAfterSortBy>
  thenByPhoneDesc({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(5, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<MemberCollection, MemberCollection, QAfterSortBy>
  thenByBalance() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(6);
    });
  }

  QueryBuilder<MemberCollection, MemberCollection, QAfterSortBy>
  thenByBalanceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(6, sort: Sort.desc);
    });
  }

  QueryBuilder<MemberCollection, MemberCollection, QAfterSortBy>
  thenByJoinedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(7);
    });
  }

  QueryBuilder<MemberCollection, MemberCollection, QAfterSortBy>
  thenByJoinedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(7, sort: Sort.desc);
    });
  }

  QueryBuilder<MemberCollection, MemberCollection, QAfterSortBy>
  thenByActiveFromDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(8);
    });
  }

  QueryBuilder<MemberCollection, MemberCollection, QAfterSortBy>
  thenByActiveFromDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(8, sort: Sort.desc);
    });
  }

  QueryBuilder<MemberCollection, MemberCollection, QAfterSortBy>
  thenByActiveToDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(9);
    });
  }

  QueryBuilder<MemberCollection, MemberCollection, QAfterSortBy>
  thenByActiveToDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(9, sort: Sort.desc);
    });
  }

  QueryBuilder<MemberCollection, MemberCollection, QAfterSortBy>
  thenByIsActive() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(10);
    });
  }

  QueryBuilder<MemberCollection, MemberCollection, QAfterSortBy>
  thenByIsActiveDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(10, sort: Sort.desc);
    });
  }

  QueryBuilder<MemberCollection, MemberCollection, QAfterSortBy>
  thenByPreferencesJson({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(11, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<MemberCollection, MemberCollection, QAfterSortBy>
  thenByPreferencesJsonDesc({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(11, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }
}

extension MemberCollectionQueryWhereDistinct
    on QueryBuilder<MemberCollection, MemberCollection, QDistinct> {
  QueryBuilder<MemberCollection, MemberCollection, QAfterDistinct>
  distinctByMemberId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(1, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<MemberCollection, MemberCollection, QAfterDistinct>
  distinctByName({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(2, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<MemberCollection, MemberCollection, QAfterDistinct>
  distinctByRoleIndex() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(3);
    });
  }

  QueryBuilder<MemberCollection, MemberCollection, QAfterDistinct>
  distinctByAvatarUrl({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(4, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<MemberCollection, MemberCollection, QAfterDistinct>
  distinctByPhone({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(5, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<MemberCollection, MemberCollection, QAfterDistinct>
  distinctByBalance() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(6);
    });
  }

  QueryBuilder<MemberCollection, MemberCollection, QAfterDistinct>
  distinctByJoinedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(7);
    });
  }

  QueryBuilder<MemberCollection, MemberCollection, QAfterDistinct>
  distinctByActiveFromDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(8);
    });
  }

  QueryBuilder<MemberCollection, MemberCollection, QAfterDistinct>
  distinctByActiveToDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(9);
    });
  }

  QueryBuilder<MemberCollection, MemberCollection, QAfterDistinct>
  distinctByIsActive() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(10);
    });
  }

  QueryBuilder<MemberCollection, MemberCollection, QAfterDistinct>
  distinctByPreferencesJson({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(11, caseSensitive: caseSensitive);
    });
  }
}

extension MemberCollectionQueryProperty1
    on QueryBuilder<MemberCollection, MemberCollection, QProperty> {
  QueryBuilder<MemberCollection, int, QAfterProperty> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(0);
    });
  }

  QueryBuilder<MemberCollection, String, QAfterProperty> memberIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(1);
    });
  }

  QueryBuilder<MemberCollection, String, QAfterProperty> nameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(2);
    });
  }

  QueryBuilder<MemberCollection, int, QAfterProperty> roleIndexProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(3);
    });
  }

  QueryBuilder<MemberCollection, String?, QAfterProperty> avatarUrlProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(4);
    });
  }

  QueryBuilder<MemberCollection, String?, QAfterProperty> phoneProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(5);
    });
  }

  QueryBuilder<MemberCollection, double, QAfterProperty> balanceProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(6);
    });
  }

  QueryBuilder<MemberCollection, DateTime?, QAfterProperty> joinedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(7);
    });
  }

  QueryBuilder<MemberCollection, DateTime?, QAfterProperty>
  activeFromDateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(8);
    });
  }

  QueryBuilder<MemberCollection, DateTime?, QAfterProperty>
  activeToDateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(9);
    });
  }

  QueryBuilder<MemberCollection, bool, QAfterProperty> isActiveProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(10);
    });
  }

  QueryBuilder<MemberCollection, String?, QAfterProperty>
  preferencesJsonProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(11);
    });
  }
}

extension MemberCollectionQueryProperty2<R>
    on QueryBuilder<MemberCollection, R, QAfterProperty> {
  QueryBuilder<MemberCollection, (R, int), QAfterProperty> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(0);
    });
  }

  QueryBuilder<MemberCollection, (R, String), QAfterProperty>
  memberIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(1);
    });
  }

  QueryBuilder<MemberCollection, (R, String), QAfterProperty> nameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(2);
    });
  }

  QueryBuilder<MemberCollection, (R, int), QAfterProperty> roleIndexProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(3);
    });
  }

  QueryBuilder<MemberCollection, (R, String?), QAfterProperty>
  avatarUrlProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(4);
    });
  }

  QueryBuilder<MemberCollection, (R, String?), QAfterProperty> phoneProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(5);
    });
  }

  QueryBuilder<MemberCollection, (R, double), QAfterProperty>
  balanceProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(6);
    });
  }

  QueryBuilder<MemberCollection, (R, DateTime?), QAfterProperty>
  joinedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(7);
    });
  }

  QueryBuilder<MemberCollection, (R, DateTime?), QAfterProperty>
  activeFromDateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(8);
    });
  }

  QueryBuilder<MemberCollection, (R, DateTime?), QAfterProperty>
  activeToDateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(9);
    });
  }

  QueryBuilder<MemberCollection, (R, bool), QAfterProperty> isActiveProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(10);
    });
  }

  QueryBuilder<MemberCollection, (R, String?), QAfterProperty>
  preferencesJsonProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(11);
    });
  }
}

extension MemberCollectionQueryProperty3<R1, R2>
    on QueryBuilder<MemberCollection, (R1, R2), QAfterProperty> {
  QueryBuilder<MemberCollection, (R1, R2, int), QOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(0);
    });
  }

  QueryBuilder<MemberCollection, (R1, R2, String), QOperations>
  memberIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(1);
    });
  }

  QueryBuilder<MemberCollection, (R1, R2, String), QOperations> nameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(2);
    });
  }

  QueryBuilder<MemberCollection, (R1, R2, int), QOperations>
  roleIndexProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(3);
    });
  }

  QueryBuilder<MemberCollection, (R1, R2, String?), QOperations>
  avatarUrlProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(4);
    });
  }

  QueryBuilder<MemberCollection, (R1, R2, String?), QOperations>
  phoneProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(5);
    });
  }

  QueryBuilder<MemberCollection, (R1, R2, double), QOperations>
  balanceProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(6);
    });
  }

  QueryBuilder<MemberCollection, (R1, R2, DateTime?), QOperations>
  joinedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(7);
    });
  }

  QueryBuilder<MemberCollection, (R1, R2, DateTime?), QOperations>
  activeFromDateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(8);
    });
  }

  QueryBuilder<MemberCollection, (R1, R2, DateTime?), QOperations>
  activeToDateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(9);
    });
  }

  QueryBuilder<MemberCollection, (R1, R2, bool), QOperations>
  isActiveProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(10);
    });
  }

  QueryBuilder<MemberCollection, (R1, R2, String?), QOperations>
  preferencesJsonProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(11);
    });
  }
}
