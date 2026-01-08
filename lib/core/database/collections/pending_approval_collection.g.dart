// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pending_approval_collection.dart';

// **************************************************************************
// _IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, invalid_use_of_protected_member, lines_longer_than_80_chars, constant_identifier_names, avoid_js_rounded_ints, no_leading_underscores_for_local_identifiers, require_trailing_commas, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_in_if_null_operators, library_private_types_in_public_api, prefer_const_constructors
// ignore_for_file: type=lint

extension GetPendingApprovalCollectionCollection on Isar {
  IsarCollection<int, PendingApprovalCollection>
  get pendingApprovalCollections => this.collection();
}

final PendingApprovalCollectionSchema = IsarGeneratedSchema(
  schema: IsarSchema(
    name: 'PendingApprovalCollection',
    idName: 'id',
    embedded: false,
    properties: [
      IsarPropertySchema(name: 'approvalId', type: IsarType.string),
      IsarPropertySchema(name: 'name', type: IsarType.string),
      IsarPropertySchema(name: 'email', type: IsarType.string),
      IsarPropertySchema(name: 'phone', type: IsarType.string),
      IsarPropertySchema(name: 'inviteCode', type: IsarType.string),
      IsarPropertySchema(name: 'requestedAt', type: IsarType.dateTime),
      IsarPropertySchema(name: 'requestedRoleIndex', type: IsarType.long),
      IsarPropertySchema(name: 'notes', type: IsarType.string),
      IsarPropertySchema(name: 'statusIndex', type: IsarType.long),
      IsarPropertySchema(name: 'reviewedAt', type: IsarType.dateTime),
      IsarPropertySchema(name: 'reviewedBy', type: IsarType.string),
      IsarPropertySchema(name: 'rejectionReason', type: IsarType.string),
    ],
    indexes: [
      IsarIndexSchema(
        name: 'approvalId',
        properties: ["approvalId"],
        unique: true,
        hash: false,
      ),
    ],
  ),
  converter: IsarObjectConverter<int, PendingApprovalCollection>(
    serialize: serializePendingApprovalCollection,
    deserialize: deserializePendingApprovalCollection,
    deserializeProperty: deserializePendingApprovalCollectionProp,
  ),
  getEmbeddedSchemas: () => [],
);

@isarProtected
int serializePendingApprovalCollection(
  IsarWriter writer,
  PendingApprovalCollection object,
) {
  IsarCore.writeString(writer, 1, object.approvalId);
  IsarCore.writeString(writer, 2, object.name);
  IsarCore.writeString(writer, 3, object.email);
  {
    final value = object.phone;
    if (value == null) {
      IsarCore.writeNull(writer, 4);
    } else {
      IsarCore.writeString(writer, 4, value);
    }
  }
  {
    final value = object.inviteCode;
    if (value == null) {
      IsarCore.writeNull(writer, 5);
    } else {
      IsarCore.writeString(writer, 5, value);
    }
  }
  IsarCore.writeLong(
    writer,
    6,
    object.requestedAt.toUtc().microsecondsSinceEpoch,
  );
  IsarCore.writeLong(writer, 7, object.requestedRoleIndex);
  {
    final value = object.notes;
    if (value == null) {
      IsarCore.writeNull(writer, 8);
    } else {
      IsarCore.writeString(writer, 8, value);
    }
  }
  IsarCore.writeLong(writer, 9, object.statusIndex);
  IsarCore.writeLong(
    writer,
    10,
    object.reviewedAt?.toUtc().microsecondsSinceEpoch ?? -9223372036854775808,
  );
  {
    final value = object.reviewedBy;
    if (value == null) {
      IsarCore.writeNull(writer, 11);
    } else {
      IsarCore.writeString(writer, 11, value);
    }
  }
  {
    final value = object.rejectionReason;
    if (value == null) {
      IsarCore.writeNull(writer, 12);
    } else {
      IsarCore.writeString(writer, 12, value);
    }
  }
  return object.id;
}

@isarProtected
PendingApprovalCollection deserializePendingApprovalCollection(
  IsarReader reader,
) {
  final object = PendingApprovalCollection();
  object.id = IsarCore.readId(reader);
  object.approvalId = IsarCore.readString(reader, 1) ?? '';
  object.name = IsarCore.readString(reader, 2) ?? '';
  object.email = IsarCore.readString(reader, 3) ?? '';
  object.phone = IsarCore.readString(reader, 4);
  object.inviteCode = IsarCore.readString(reader, 5);
  {
    final value = IsarCore.readLong(reader, 6);
    if (value == -9223372036854775808) {
      object.requestedAt = DateTime.fromMillisecondsSinceEpoch(
        0,
        isUtc: true,
      ).toLocal();
    } else {
      object.requestedAt = DateTime.fromMicrosecondsSinceEpoch(
        value,
        isUtc: true,
      ).toLocal();
    }
  }
  object.requestedRoleIndex = IsarCore.readLong(reader, 7);
  object.notes = IsarCore.readString(reader, 8);
  object.statusIndex = IsarCore.readLong(reader, 9);
  {
    final value = IsarCore.readLong(reader, 10);
    if (value == -9223372036854775808) {
      object.reviewedAt = null;
    } else {
      object.reviewedAt = DateTime.fromMicrosecondsSinceEpoch(
        value,
        isUtc: true,
      ).toLocal();
    }
  }
  object.reviewedBy = IsarCore.readString(reader, 11);
  object.rejectionReason = IsarCore.readString(reader, 12);
  return object;
}

@isarProtected
dynamic deserializePendingApprovalCollectionProp(
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
      return IsarCore.readString(reader, 3) ?? '';
    case 4:
      return IsarCore.readString(reader, 4);
    case 5:
      return IsarCore.readString(reader, 5);
    case 6:
      {
        final value = IsarCore.readLong(reader, 6);
        if (value == -9223372036854775808) {
          return DateTime.fromMillisecondsSinceEpoch(0, isUtc: true).toLocal();
        } else {
          return DateTime.fromMicrosecondsSinceEpoch(
            value,
            isUtc: true,
          ).toLocal();
        }
      }
    case 7:
      return IsarCore.readLong(reader, 7);
    case 8:
      return IsarCore.readString(reader, 8);
    case 9:
      return IsarCore.readLong(reader, 9);
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
    case 11:
      return IsarCore.readString(reader, 11);
    case 12:
      return IsarCore.readString(reader, 12);
    default:
      throw ArgumentError('Unknown property: $property');
  }
}

sealed class _PendingApprovalCollectionUpdate {
  bool call({
    required int id,
    String? approvalId,
    String? name,
    String? email,
    String? phone,
    String? inviteCode,
    DateTime? requestedAt,
    int? requestedRoleIndex,
    String? notes,
    int? statusIndex,
    DateTime? reviewedAt,
    String? reviewedBy,
    String? rejectionReason,
  });
}

class _PendingApprovalCollectionUpdateImpl
    implements _PendingApprovalCollectionUpdate {
  const _PendingApprovalCollectionUpdateImpl(this.collection);

  final IsarCollection<int, PendingApprovalCollection> collection;

  @override
  bool call({
    required int id,
    Object? approvalId = ignore,
    Object? name = ignore,
    Object? email = ignore,
    Object? phone = ignore,
    Object? inviteCode = ignore,
    Object? requestedAt = ignore,
    Object? requestedRoleIndex = ignore,
    Object? notes = ignore,
    Object? statusIndex = ignore,
    Object? reviewedAt = ignore,
    Object? reviewedBy = ignore,
    Object? rejectionReason = ignore,
  }) {
    return collection.updateProperties(
          [id],
          {
            if (approvalId != ignore) 1: approvalId as String?,
            if (name != ignore) 2: name as String?,
            if (email != ignore) 3: email as String?,
            if (phone != ignore) 4: phone as String?,
            if (inviteCode != ignore) 5: inviteCode as String?,
            if (requestedAt != ignore) 6: requestedAt as DateTime?,
            if (requestedRoleIndex != ignore) 7: requestedRoleIndex as int?,
            if (notes != ignore) 8: notes as String?,
            if (statusIndex != ignore) 9: statusIndex as int?,
            if (reviewedAt != ignore) 10: reviewedAt as DateTime?,
            if (reviewedBy != ignore) 11: reviewedBy as String?,
            if (rejectionReason != ignore) 12: rejectionReason as String?,
          },
        ) >
        0;
  }
}

sealed class _PendingApprovalCollectionUpdateAll {
  int call({
    required List<int> id,
    String? approvalId,
    String? name,
    String? email,
    String? phone,
    String? inviteCode,
    DateTime? requestedAt,
    int? requestedRoleIndex,
    String? notes,
    int? statusIndex,
    DateTime? reviewedAt,
    String? reviewedBy,
    String? rejectionReason,
  });
}

class _PendingApprovalCollectionUpdateAllImpl
    implements _PendingApprovalCollectionUpdateAll {
  const _PendingApprovalCollectionUpdateAllImpl(this.collection);

  final IsarCollection<int, PendingApprovalCollection> collection;

  @override
  int call({
    required List<int> id,
    Object? approvalId = ignore,
    Object? name = ignore,
    Object? email = ignore,
    Object? phone = ignore,
    Object? inviteCode = ignore,
    Object? requestedAt = ignore,
    Object? requestedRoleIndex = ignore,
    Object? notes = ignore,
    Object? statusIndex = ignore,
    Object? reviewedAt = ignore,
    Object? reviewedBy = ignore,
    Object? rejectionReason = ignore,
  }) {
    return collection.updateProperties(id, {
      if (approvalId != ignore) 1: approvalId as String?,
      if (name != ignore) 2: name as String?,
      if (email != ignore) 3: email as String?,
      if (phone != ignore) 4: phone as String?,
      if (inviteCode != ignore) 5: inviteCode as String?,
      if (requestedAt != ignore) 6: requestedAt as DateTime?,
      if (requestedRoleIndex != ignore) 7: requestedRoleIndex as int?,
      if (notes != ignore) 8: notes as String?,
      if (statusIndex != ignore) 9: statusIndex as int?,
      if (reviewedAt != ignore) 10: reviewedAt as DateTime?,
      if (reviewedBy != ignore) 11: reviewedBy as String?,
      if (rejectionReason != ignore) 12: rejectionReason as String?,
    });
  }
}

extension PendingApprovalCollectionUpdate
    on IsarCollection<int, PendingApprovalCollection> {
  _PendingApprovalCollectionUpdate get update =>
      _PendingApprovalCollectionUpdateImpl(this);

  _PendingApprovalCollectionUpdateAll get updateAll =>
      _PendingApprovalCollectionUpdateAllImpl(this);
}

sealed class _PendingApprovalCollectionQueryUpdate {
  int call({
    String? approvalId,
    String? name,
    String? email,
    String? phone,
    String? inviteCode,
    DateTime? requestedAt,
    int? requestedRoleIndex,
    String? notes,
    int? statusIndex,
    DateTime? reviewedAt,
    String? reviewedBy,
    String? rejectionReason,
  });
}

class _PendingApprovalCollectionQueryUpdateImpl
    implements _PendingApprovalCollectionQueryUpdate {
  const _PendingApprovalCollectionQueryUpdateImpl(this.query, {this.limit});

  final IsarQuery<PendingApprovalCollection> query;
  final int? limit;

  @override
  int call({
    Object? approvalId = ignore,
    Object? name = ignore,
    Object? email = ignore,
    Object? phone = ignore,
    Object? inviteCode = ignore,
    Object? requestedAt = ignore,
    Object? requestedRoleIndex = ignore,
    Object? notes = ignore,
    Object? statusIndex = ignore,
    Object? reviewedAt = ignore,
    Object? reviewedBy = ignore,
    Object? rejectionReason = ignore,
  }) {
    return query.updateProperties(limit: limit, {
      if (approvalId != ignore) 1: approvalId as String?,
      if (name != ignore) 2: name as String?,
      if (email != ignore) 3: email as String?,
      if (phone != ignore) 4: phone as String?,
      if (inviteCode != ignore) 5: inviteCode as String?,
      if (requestedAt != ignore) 6: requestedAt as DateTime?,
      if (requestedRoleIndex != ignore) 7: requestedRoleIndex as int?,
      if (notes != ignore) 8: notes as String?,
      if (statusIndex != ignore) 9: statusIndex as int?,
      if (reviewedAt != ignore) 10: reviewedAt as DateTime?,
      if (reviewedBy != ignore) 11: reviewedBy as String?,
      if (rejectionReason != ignore) 12: rejectionReason as String?,
    });
  }
}

extension PendingApprovalCollectionQueryUpdate
    on IsarQuery<PendingApprovalCollection> {
  _PendingApprovalCollectionQueryUpdate get updateFirst =>
      _PendingApprovalCollectionQueryUpdateImpl(this, limit: 1);

  _PendingApprovalCollectionQueryUpdate get updateAll =>
      _PendingApprovalCollectionQueryUpdateImpl(this);
}

class _PendingApprovalCollectionQueryBuilderUpdateImpl
    implements _PendingApprovalCollectionQueryUpdate {
  const _PendingApprovalCollectionQueryBuilderUpdateImpl(
    this.query, {
    this.limit,
  });

  final QueryBuilder<
    PendingApprovalCollection,
    PendingApprovalCollection,
    QOperations
  >
  query;
  final int? limit;

  @override
  int call({
    Object? approvalId = ignore,
    Object? name = ignore,
    Object? email = ignore,
    Object? phone = ignore,
    Object? inviteCode = ignore,
    Object? requestedAt = ignore,
    Object? requestedRoleIndex = ignore,
    Object? notes = ignore,
    Object? statusIndex = ignore,
    Object? reviewedAt = ignore,
    Object? reviewedBy = ignore,
    Object? rejectionReason = ignore,
  }) {
    final q = query.build();
    try {
      return q.updateProperties(limit: limit, {
        if (approvalId != ignore) 1: approvalId as String?,
        if (name != ignore) 2: name as String?,
        if (email != ignore) 3: email as String?,
        if (phone != ignore) 4: phone as String?,
        if (inviteCode != ignore) 5: inviteCode as String?,
        if (requestedAt != ignore) 6: requestedAt as DateTime?,
        if (requestedRoleIndex != ignore) 7: requestedRoleIndex as int?,
        if (notes != ignore) 8: notes as String?,
        if (statusIndex != ignore) 9: statusIndex as int?,
        if (reviewedAt != ignore) 10: reviewedAt as DateTime?,
        if (reviewedBy != ignore) 11: reviewedBy as String?,
        if (rejectionReason != ignore) 12: rejectionReason as String?,
      });
    } finally {
      q.close();
    }
  }
}

extension PendingApprovalCollectionQueryBuilderUpdate
    on
        QueryBuilder<
          PendingApprovalCollection,
          PendingApprovalCollection,
          QOperations
        > {
  _PendingApprovalCollectionQueryUpdate get updateFirst =>
      _PendingApprovalCollectionQueryBuilderUpdateImpl(this, limit: 1);

  _PendingApprovalCollectionQueryUpdate get updateAll =>
      _PendingApprovalCollectionQueryBuilderUpdateImpl(this);
}

extension PendingApprovalCollectionQueryFilter
    on
        QueryBuilder<
          PendingApprovalCollection,
          PendingApprovalCollection,
          QFilterCondition
        > {
  QueryBuilder<
    PendingApprovalCollection,
    PendingApprovalCollection,
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
    PendingApprovalCollection,
    PendingApprovalCollection,
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
    PendingApprovalCollection,
    PendingApprovalCollection,
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
    PendingApprovalCollection,
    PendingApprovalCollection,
    QAfterFilterCondition
  >
  idLessThan(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(LessCondition(property: 0, value: value));
    });
  }

  QueryBuilder<
    PendingApprovalCollection,
    PendingApprovalCollection,
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
    PendingApprovalCollection,
    PendingApprovalCollection,
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
    PendingApprovalCollection,
    PendingApprovalCollection,
    QAfterFilterCondition
  >
  approvalIdEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(property: 1, value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<
    PendingApprovalCollection,
    PendingApprovalCollection,
    QAfterFilterCondition
  >
  approvalIdGreaterThan(String value, {bool caseSensitive = true}) {
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
    PendingApprovalCollection,
    PendingApprovalCollection,
    QAfterFilterCondition
  >
  approvalIdGreaterThanOrEqualTo(String value, {bool caseSensitive = true}) {
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
    PendingApprovalCollection,
    PendingApprovalCollection,
    QAfterFilterCondition
  >
  approvalIdLessThan(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(property: 1, value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<
    PendingApprovalCollection,
    PendingApprovalCollection,
    QAfterFilterCondition
  >
  approvalIdLessThanOrEqualTo(String value, {bool caseSensitive = true}) {
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
    PendingApprovalCollection,
    PendingApprovalCollection,
    QAfterFilterCondition
  >
  approvalIdBetween(String lower, String upper, {bool caseSensitive = true}) {
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
    PendingApprovalCollection,
    PendingApprovalCollection,
    QAfterFilterCondition
  >
  approvalIdStartsWith(String value, {bool caseSensitive = true}) {
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
    PendingApprovalCollection,
    PendingApprovalCollection,
    QAfterFilterCondition
  >
  approvalIdEndsWith(String value, {bool caseSensitive = true}) {
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
    PendingApprovalCollection,
    PendingApprovalCollection,
    QAfterFilterCondition
  >
  approvalIdContains(String value, {bool caseSensitive = true}) {
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
    PendingApprovalCollection,
    PendingApprovalCollection,
    QAfterFilterCondition
  >
  approvalIdMatches(String pattern, {bool caseSensitive = true}) {
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
    PendingApprovalCollection,
    PendingApprovalCollection,
    QAfterFilterCondition
  >
  approvalIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const EqualCondition(property: 1, value: ''),
      );
    });
  }

  QueryBuilder<
    PendingApprovalCollection,
    PendingApprovalCollection,
    QAfterFilterCondition
  >
  approvalIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const GreaterCondition(property: 1, value: ''),
      );
    });
  }

  QueryBuilder<
    PendingApprovalCollection,
    PendingApprovalCollection,
    QAfterFilterCondition
  >
  nameEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(property: 2, value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<
    PendingApprovalCollection,
    PendingApprovalCollection,
    QAfterFilterCondition
  >
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

  QueryBuilder<
    PendingApprovalCollection,
    PendingApprovalCollection,
    QAfterFilterCondition
  >
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

  QueryBuilder<
    PendingApprovalCollection,
    PendingApprovalCollection,
    QAfterFilterCondition
  >
  nameLessThan(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(property: 2, value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<
    PendingApprovalCollection,
    PendingApprovalCollection,
    QAfterFilterCondition
  >
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

  QueryBuilder<
    PendingApprovalCollection,
    PendingApprovalCollection,
    QAfterFilterCondition
  >
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

  QueryBuilder<
    PendingApprovalCollection,
    PendingApprovalCollection,
    QAfterFilterCondition
  >
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

  QueryBuilder<
    PendingApprovalCollection,
    PendingApprovalCollection,
    QAfterFilterCondition
  >
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

  QueryBuilder<
    PendingApprovalCollection,
    PendingApprovalCollection,
    QAfterFilterCondition
  >
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

  QueryBuilder<
    PendingApprovalCollection,
    PendingApprovalCollection,
    QAfterFilterCondition
  >
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

  QueryBuilder<
    PendingApprovalCollection,
    PendingApprovalCollection,
    QAfterFilterCondition
  >
  nameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const EqualCondition(property: 2, value: ''),
      );
    });
  }

  QueryBuilder<
    PendingApprovalCollection,
    PendingApprovalCollection,
    QAfterFilterCondition
  >
  nameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const GreaterCondition(property: 2, value: ''),
      );
    });
  }

  QueryBuilder<
    PendingApprovalCollection,
    PendingApprovalCollection,
    QAfterFilterCondition
  >
  emailEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(property: 3, value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<
    PendingApprovalCollection,
    PendingApprovalCollection,
    QAfterFilterCondition
  >
  emailGreaterThan(String value, {bool caseSensitive = true}) {
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
    PendingApprovalCollection,
    PendingApprovalCollection,
    QAfterFilterCondition
  >
  emailGreaterThanOrEqualTo(String value, {bool caseSensitive = true}) {
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
    PendingApprovalCollection,
    PendingApprovalCollection,
    QAfterFilterCondition
  >
  emailLessThan(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(property: 3, value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<
    PendingApprovalCollection,
    PendingApprovalCollection,
    QAfterFilterCondition
  >
  emailLessThanOrEqualTo(String value, {bool caseSensitive = true}) {
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
    PendingApprovalCollection,
    PendingApprovalCollection,
    QAfterFilterCondition
  >
  emailBetween(String lower, String upper, {bool caseSensitive = true}) {
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
    PendingApprovalCollection,
    PendingApprovalCollection,
    QAfterFilterCondition
  >
  emailStartsWith(String value, {bool caseSensitive = true}) {
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
    PendingApprovalCollection,
    PendingApprovalCollection,
    QAfterFilterCondition
  >
  emailEndsWith(String value, {bool caseSensitive = true}) {
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
    PendingApprovalCollection,
    PendingApprovalCollection,
    QAfterFilterCondition
  >
  emailContains(String value, {bool caseSensitive = true}) {
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
    PendingApprovalCollection,
    PendingApprovalCollection,
    QAfterFilterCondition
  >
  emailMatches(String pattern, {bool caseSensitive = true}) {
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
    PendingApprovalCollection,
    PendingApprovalCollection,
    QAfterFilterCondition
  >
  emailIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const EqualCondition(property: 3, value: ''),
      );
    });
  }

  QueryBuilder<
    PendingApprovalCollection,
    PendingApprovalCollection,
    QAfterFilterCondition
  >
  emailIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const GreaterCondition(property: 3, value: ''),
      );
    });
  }

  QueryBuilder<
    PendingApprovalCollection,
    PendingApprovalCollection,
    QAfterFilterCondition
  >
  phoneIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const IsNullCondition(property: 4));
    });
  }

  QueryBuilder<
    PendingApprovalCollection,
    PendingApprovalCollection,
    QAfterFilterCondition
  >
  phoneIsNotNull() {
    return QueryBuilder.apply(not(), (query) {
      return query.addFilterCondition(const IsNullCondition(property: 4));
    });
  }

  QueryBuilder<
    PendingApprovalCollection,
    PendingApprovalCollection,
    QAfterFilterCondition
  >
  phoneEqualTo(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(property: 4, value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<
    PendingApprovalCollection,
    PendingApprovalCollection,
    QAfterFilterCondition
  >
  phoneGreaterThan(String? value, {bool caseSensitive = true}) {
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

  QueryBuilder<
    PendingApprovalCollection,
    PendingApprovalCollection,
    QAfterFilterCondition
  >
  phoneGreaterThanOrEqualTo(String? value, {bool caseSensitive = true}) {
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

  QueryBuilder<
    PendingApprovalCollection,
    PendingApprovalCollection,
    QAfterFilterCondition
  >
  phoneLessThan(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(property: 4, value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<
    PendingApprovalCollection,
    PendingApprovalCollection,
    QAfterFilterCondition
  >
  phoneLessThanOrEqualTo(String? value, {bool caseSensitive = true}) {
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

  QueryBuilder<
    PendingApprovalCollection,
    PendingApprovalCollection,
    QAfterFilterCondition
  >
  phoneBetween(String? lower, String? upper, {bool caseSensitive = true}) {
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

  QueryBuilder<
    PendingApprovalCollection,
    PendingApprovalCollection,
    QAfterFilterCondition
  >
  phoneStartsWith(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<
    PendingApprovalCollection,
    PendingApprovalCollection,
    QAfterFilterCondition
  >
  phoneEndsWith(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<
    PendingApprovalCollection,
    PendingApprovalCollection,
    QAfterFilterCondition
  >
  phoneContains(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<
    PendingApprovalCollection,
    PendingApprovalCollection,
    QAfterFilterCondition
  >
  phoneMatches(String pattern, {bool caseSensitive = true}) {
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

  QueryBuilder<
    PendingApprovalCollection,
    PendingApprovalCollection,
    QAfterFilterCondition
  >
  phoneIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const EqualCondition(property: 4, value: ''),
      );
    });
  }

  QueryBuilder<
    PendingApprovalCollection,
    PendingApprovalCollection,
    QAfterFilterCondition
  >
  phoneIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const GreaterCondition(property: 4, value: ''),
      );
    });
  }

  QueryBuilder<
    PendingApprovalCollection,
    PendingApprovalCollection,
    QAfterFilterCondition
  >
  inviteCodeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const IsNullCondition(property: 5));
    });
  }

  QueryBuilder<
    PendingApprovalCollection,
    PendingApprovalCollection,
    QAfterFilterCondition
  >
  inviteCodeIsNotNull() {
    return QueryBuilder.apply(not(), (query) {
      return query.addFilterCondition(const IsNullCondition(property: 5));
    });
  }

  QueryBuilder<
    PendingApprovalCollection,
    PendingApprovalCollection,
    QAfterFilterCondition
  >
  inviteCodeEqualTo(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(property: 5, value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<
    PendingApprovalCollection,
    PendingApprovalCollection,
    QAfterFilterCondition
  >
  inviteCodeGreaterThan(String? value, {bool caseSensitive = true}) {
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
    PendingApprovalCollection,
    PendingApprovalCollection,
    QAfterFilterCondition
  >
  inviteCodeGreaterThanOrEqualTo(String? value, {bool caseSensitive = true}) {
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
    PendingApprovalCollection,
    PendingApprovalCollection,
    QAfterFilterCondition
  >
  inviteCodeLessThan(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(property: 5, value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<
    PendingApprovalCollection,
    PendingApprovalCollection,
    QAfterFilterCondition
  >
  inviteCodeLessThanOrEqualTo(String? value, {bool caseSensitive = true}) {
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
    PendingApprovalCollection,
    PendingApprovalCollection,
    QAfterFilterCondition
  >
  inviteCodeBetween(String? lower, String? upper, {bool caseSensitive = true}) {
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
    PendingApprovalCollection,
    PendingApprovalCollection,
    QAfterFilterCondition
  >
  inviteCodeStartsWith(String value, {bool caseSensitive = true}) {
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
    PendingApprovalCollection,
    PendingApprovalCollection,
    QAfterFilterCondition
  >
  inviteCodeEndsWith(String value, {bool caseSensitive = true}) {
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
    PendingApprovalCollection,
    PendingApprovalCollection,
    QAfterFilterCondition
  >
  inviteCodeContains(String value, {bool caseSensitive = true}) {
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
    PendingApprovalCollection,
    PendingApprovalCollection,
    QAfterFilterCondition
  >
  inviteCodeMatches(String pattern, {bool caseSensitive = true}) {
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
    PendingApprovalCollection,
    PendingApprovalCollection,
    QAfterFilterCondition
  >
  inviteCodeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const EqualCondition(property: 5, value: ''),
      );
    });
  }

  QueryBuilder<
    PendingApprovalCollection,
    PendingApprovalCollection,
    QAfterFilterCondition
  >
  inviteCodeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const GreaterCondition(property: 5, value: ''),
      );
    });
  }

  QueryBuilder<
    PendingApprovalCollection,
    PendingApprovalCollection,
    QAfterFilterCondition
  >
  requestedAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(property: 6, value: value),
      );
    });
  }

  QueryBuilder<
    PendingApprovalCollection,
    PendingApprovalCollection,
    QAfterFilterCondition
  >
  requestedAtGreaterThan(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(property: 6, value: value),
      );
    });
  }

  QueryBuilder<
    PendingApprovalCollection,
    PendingApprovalCollection,
    QAfterFilterCondition
  >
  requestedAtGreaterThanOrEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(property: 6, value: value),
      );
    });
  }

  QueryBuilder<
    PendingApprovalCollection,
    PendingApprovalCollection,
    QAfterFilterCondition
  >
  requestedAtLessThan(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(LessCondition(property: 6, value: value));
    });
  }

  QueryBuilder<
    PendingApprovalCollection,
    PendingApprovalCollection,
    QAfterFilterCondition
  >
  requestedAtLessThanOrEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(property: 6, value: value),
      );
    });
  }

  QueryBuilder<
    PendingApprovalCollection,
    PendingApprovalCollection,
    QAfterFilterCondition
  >
  requestedAtBetween(DateTime lower, DateTime upper) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(property: 6, lower: lower, upper: upper),
      );
    });
  }

  QueryBuilder<
    PendingApprovalCollection,
    PendingApprovalCollection,
    QAfterFilterCondition
  >
  requestedRoleIndexEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(property: 7, value: value),
      );
    });
  }

  QueryBuilder<
    PendingApprovalCollection,
    PendingApprovalCollection,
    QAfterFilterCondition
  >
  requestedRoleIndexGreaterThan(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(property: 7, value: value),
      );
    });
  }

  QueryBuilder<
    PendingApprovalCollection,
    PendingApprovalCollection,
    QAfterFilterCondition
  >
  requestedRoleIndexGreaterThanOrEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(property: 7, value: value),
      );
    });
  }

  QueryBuilder<
    PendingApprovalCollection,
    PendingApprovalCollection,
    QAfterFilterCondition
  >
  requestedRoleIndexLessThan(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(LessCondition(property: 7, value: value));
    });
  }

  QueryBuilder<
    PendingApprovalCollection,
    PendingApprovalCollection,
    QAfterFilterCondition
  >
  requestedRoleIndexLessThanOrEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(property: 7, value: value),
      );
    });
  }

  QueryBuilder<
    PendingApprovalCollection,
    PendingApprovalCollection,
    QAfterFilterCondition
  >
  requestedRoleIndexBetween(int lower, int upper) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(property: 7, lower: lower, upper: upper),
      );
    });
  }

  QueryBuilder<
    PendingApprovalCollection,
    PendingApprovalCollection,
    QAfterFilterCondition
  >
  notesIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const IsNullCondition(property: 8));
    });
  }

  QueryBuilder<
    PendingApprovalCollection,
    PendingApprovalCollection,
    QAfterFilterCondition
  >
  notesIsNotNull() {
    return QueryBuilder.apply(not(), (query) {
      return query.addFilterCondition(const IsNullCondition(property: 8));
    });
  }

  QueryBuilder<
    PendingApprovalCollection,
    PendingApprovalCollection,
    QAfterFilterCondition
  >
  notesEqualTo(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(property: 8, value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<
    PendingApprovalCollection,
    PendingApprovalCollection,
    QAfterFilterCondition
  >
  notesGreaterThan(String? value, {bool caseSensitive = true}) {
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
    PendingApprovalCollection,
    PendingApprovalCollection,
    QAfterFilterCondition
  >
  notesGreaterThanOrEqualTo(String? value, {bool caseSensitive = true}) {
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
    PendingApprovalCollection,
    PendingApprovalCollection,
    QAfterFilterCondition
  >
  notesLessThan(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(property: 8, value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<
    PendingApprovalCollection,
    PendingApprovalCollection,
    QAfterFilterCondition
  >
  notesLessThanOrEqualTo(String? value, {bool caseSensitive = true}) {
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
    PendingApprovalCollection,
    PendingApprovalCollection,
    QAfterFilterCondition
  >
  notesBetween(String? lower, String? upper, {bool caseSensitive = true}) {
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
    PendingApprovalCollection,
    PendingApprovalCollection,
    QAfterFilterCondition
  >
  notesStartsWith(String value, {bool caseSensitive = true}) {
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
    PendingApprovalCollection,
    PendingApprovalCollection,
    QAfterFilterCondition
  >
  notesEndsWith(String value, {bool caseSensitive = true}) {
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
    PendingApprovalCollection,
    PendingApprovalCollection,
    QAfterFilterCondition
  >
  notesContains(String value, {bool caseSensitive = true}) {
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
    PendingApprovalCollection,
    PendingApprovalCollection,
    QAfterFilterCondition
  >
  notesMatches(String pattern, {bool caseSensitive = true}) {
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
    PendingApprovalCollection,
    PendingApprovalCollection,
    QAfterFilterCondition
  >
  notesIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const EqualCondition(property: 8, value: ''),
      );
    });
  }

  QueryBuilder<
    PendingApprovalCollection,
    PendingApprovalCollection,
    QAfterFilterCondition
  >
  notesIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const GreaterCondition(property: 8, value: ''),
      );
    });
  }

  QueryBuilder<
    PendingApprovalCollection,
    PendingApprovalCollection,
    QAfterFilterCondition
  >
  statusIndexEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(property: 9, value: value),
      );
    });
  }

  QueryBuilder<
    PendingApprovalCollection,
    PendingApprovalCollection,
    QAfterFilterCondition
  >
  statusIndexGreaterThan(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(property: 9, value: value),
      );
    });
  }

  QueryBuilder<
    PendingApprovalCollection,
    PendingApprovalCollection,
    QAfterFilterCondition
  >
  statusIndexGreaterThanOrEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(property: 9, value: value),
      );
    });
  }

  QueryBuilder<
    PendingApprovalCollection,
    PendingApprovalCollection,
    QAfterFilterCondition
  >
  statusIndexLessThan(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(LessCondition(property: 9, value: value));
    });
  }

  QueryBuilder<
    PendingApprovalCollection,
    PendingApprovalCollection,
    QAfterFilterCondition
  >
  statusIndexLessThanOrEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(property: 9, value: value),
      );
    });
  }

  QueryBuilder<
    PendingApprovalCollection,
    PendingApprovalCollection,
    QAfterFilterCondition
  >
  statusIndexBetween(int lower, int upper) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(property: 9, lower: lower, upper: upper),
      );
    });
  }

  QueryBuilder<
    PendingApprovalCollection,
    PendingApprovalCollection,
    QAfterFilterCondition
  >
  reviewedAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const IsNullCondition(property: 10));
    });
  }

  QueryBuilder<
    PendingApprovalCollection,
    PendingApprovalCollection,
    QAfterFilterCondition
  >
  reviewedAtIsNotNull() {
    return QueryBuilder.apply(not(), (query) {
      return query.addFilterCondition(const IsNullCondition(property: 10));
    });
  }

  QueryBuilder<
    PendingApprovalCollection,
    PendingApprovalCollection,
    QAfterFilterCondition
  >
  reviewedAtEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(property: 10, value: value),
      );
    });
  }

  QueryBuilder<
    PendingApprovalCollection,
    PendingApprovalCollection,
    QAfterFilterCondition
  >
  reviewedAtGreaterThan(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(property: 10, value: value),
      );
    });
  }

  QueryBuilder<
    PendingApprovalCollection,
    PendingApprovalCollection,
    QAfterFilterCondition
  >
  reviewedAtGreaterThanOrEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(property: 10, value: value),
      );
    });
  }

  QueryBuilder<
    PendingApprovalCollection,
    PendingApprovalCollection,
    QAfterFilterCondition
  >
  reviewedAtLessThan(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(property: 10, value: value),
      );
    });
  }

  QueryBuilder<
    PendingApprovalCollection,
    PendingApprovalCollection,
    QAfterFilterCondition
  >
  reviewedAtLessThanOrEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(property: 10, value: value),
      );
    });
  }

  QueryBuilder<
    PendingApprovalCollection,
    PendingApprovalCollection,
    QAfterFilterCondition
  >
  reviewedAtBetween(DateTime? lower, DateTime? upper) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(property: 10, lower: lower, upper: upper),
      );
    });
  }

  QueryBuilder<
    PendingApprovalCollection,
    PendingApprovalCollection,
    QAfterFilterCondition
  >
  reviewedByIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const IsNullCondition(property: 11));
    });
  }

  QueryBuilder<
    PendingApprovalCollection,
    PendingApprovalCollection,
    QAfterFilterCondition
  >
  reviewedByIsNotNull() {
    return QueryBuilder.apply(not(), (query) {
      return query.addFilterCondition(const IsNullCondition(property: 11));
    });
  }

  QueryBuilder<
    PendingApprovalCollection,
    PendingApprovalCollection,
    QAfterFilterCondition
  >
  reviewedByEqualTo(String? value, {bool caseSensitive = true}) {
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
    PendingApprovalCollection,
    PendingApprovalCollection,
    QAfterFilterCondition
  >
  reviewedByGreaterThan(String? value, {bool caseSensitive = true}) {
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
    PendingApprovalCollection,
    PendingApprovalCollection,
    QAfterFilterCondition
  >
  reviewedByGreaterThanOrEqualTo(String? value, {bool caseSensitive = true}) {
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
    PendingApprovalCollection,
    PendingApprovalCollection,
    QAfterFilterCondition
  >
  reviewedByLessThan(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(property: 11, value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<
    PendingApprovalCollection,
    PendingApprovalCollection,
    QAfterFilterCondition
  >
  reviewedByLessThanOrEqualTo(String? value, {bool caseSensitive = true}) {
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
    PendingApprovalCollection,
    PendingApprovalCollection,
    QAfterFilterCondition
  >
  reviewedByBetween(String? lower, String? upper, {bool caseSensitive = true}) {
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
    PendingApprovalCollection,
    PendingApprovalCollection,
    QAfterFilterCondition
  >
  reviewedByStartsWith(String value, {bool caseSensitive = true}) {
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
    PendingApprovalCollection,
    PendingApprovalCollection,
    QAfterFilterCondition
  >
  reviewedByEndsWith(String value, {bool caseSensitive = true}) {
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
    PendingApprovalCollection,
    PendingApprovalCollection,
    QAfterFilterCondition
  >
  reviewedByContains(String value, {bool caseSensitive = true}) {
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
    PendingApprovalCollection,
    PendingApprovalCollection,
    QAfterFilterCondition
  >
  reviewedByMatches(String pattern, {bool caseSensitive = true}) {
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
    PendingApprovalCollection,
    PendingApprovalCollection,
    QAfterFilterCondition
  >
  reviewedByIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const EqualCondition(property: 11, value: ''),
      );
    });
  }

  QueryBuilder<
    PendingApprovalCollection,
    PendingApprovalCollection,
    QAfterFilterCondition
  >
  reviewedByIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const GreaterCondition(property: 11, value: ''),
      );
    });
  }

  QueryBuilder<
    PendingApprovalCollection,
    PendingApprovalCollection,
    QAfterFilterCondition
  >
  rejectionReasonIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const IsNullCondition(property: 12));
    });
  }

  QueryBuilder<
    PendingApprovalCollection,
    PendingApprovalCollection,
    QAfterFilterCondition
  >
  rejectionReasonIsNotNull() {
    return QueryBuilder.apply(not(), (query) {
      return query.addFilterCondition(const IsNullCondition(property: 12));
    });
  }

  QueryBuilder<
    PendingApprovalCollection,
    PendingApprovalCollection,
    QAfterFilterCondition
  >
  rejectionReasonEqualTo(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(
          property: 12,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    PendingApprovalCollection,
    PendingApprovalCollection,
    QAfterFilterCondition
  >
  rejectionReasonGreaterThan(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(
          property: 12,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    PendingApprovalCollection,
    PendingApprovalCollection,
    QAfterFilterCondition
  >
  rejectionReasonGreaterThanOrEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(
          property: 12,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    PendingApprovalCollection,
    PendingApprovalCollection,
    QAfterFilterCondition
  >
  rejectionReasonLessThan(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(property: 12, value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<
    PendingApprovalCollection,
    PendingApprovalCollection,
    QAfterFilterCondition
  >
  rejectionReasonLessThanOrEqualTo(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(
          property: 12,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    PendingApprovalCollection,
    PendingApprovalCollection,
    QAfterFilterCondition
  >
  rejectionReasonBetween(
    String? lower,
    String? upper, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(
          property: 12,
          lower: lower,
          upper: upper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    PendingApprovalCollection,
    PendingApprovalCollection,
    QAfterFilterCondition
  >
  rejectionReasonStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        StartsWithCondition(
          property: 12,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    PendingApprovalCollection,
    PendingApprovalCollection,
    QAfterFilterCondition
  >
  rejectionReasonEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EndsWithCondition(
          property: 12,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    PendingApprovalCollection,
    PendingApprovalCollection,
    QAfterFilterCondition
  >
  rejectionReasonContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        ContainsCondition(
          property: 12,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    PendingApprovalCollection,
    PendingApprovalCollection,
    QAfterFilterCondition
  >
  rejectionReasonMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        MatchesCondition(
          property: 12,
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    PendingApprovalCollection,
    PendingApprovalCollection,
    QAfterFilterCondition
  >
  rejectionReasonIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const EqualCondition(property: 12, value: ''),
      );
    });
  }

  QueryBuilder<
    PendingApprovalCollection,
    PendingApprovalCollection,
    QAfterFilterCondition
  >
  rejectionReasonIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const GreaterCondition(property: 12, value: ''),
      );
    });
  }
}

extension PendingApprovalCollectionQueryObject
    on
        QueryBuilder<
          PendingApprovalCollection,
          PendingApprovalCollection,
          QFilterCondition
        > {}

extension PendingApprovalCollectionQuerySortBy
    on
        QueryBuilder<
          PendingApprovalCollection,
          PendingApprovalCollection,
          QSortBy
        > {
  QueryBuilder<
    PendingApprovalCollection,
    PendingApprovalCollection,
    QAfterSortBy
  >
  sortById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(0);
    });
  }

  QueryBuilder<
    PendingApprovalCollection,
    PendingApprovalCollection,
    QAfterSortBy
  >
  sortByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(0, sort: Sort.desc);
    });
  }

  QueryBuilder<
    PendingApprovalCollection,
    PendingApprovalCollection,
    QAfterSortBy
  >
  sortByApprovalId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(1, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<
    PendingApprovalCollection,
    PendingApprovalCollection,
    QAfterSortBy
  >
  sortByApprovalIdDesc({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(1, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<
    PendingApprovalCollection,
    PendingApprovalCollection,
    QAfterSortBy
  >
  sortByName({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(2, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<
    PendingApprovalCollection,
    PendingApprovalCollection,
    QAfterSortBy
  >
  sortByNameDesc({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(2, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<
    PendingApprovalCollection,
    PendingApprovalCollection,
    QAfterSortBy
  >
  sortByEmail({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(3, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<
    PendingApprovalCollection,
    PendingApprovalCollection,
    QAfterSortBy
  >
  sortByEmailDesc({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(3, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<
    PendingApprovalCollection,
    PendingApprovalCollection,
    QAfterSortBy
  >
  sortByPhone({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(4, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<
    PendingApprovalCollection,
    PendingApprovalCollection,
    QAfterSortBy
  >
  sortByPhoneDesc({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(4, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<
    PendingApprovalCollection,
    PendingApprovalCollection,
    QAfterSortBy
  >
  sortByInviteCode({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(5, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<
    PendingApprovalCollection,
    PendingApprovalCollection,
    QAfterSortBy
  >
  sortByInviteCodeDesc({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(5, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<
    PendingApprovalCollection,
    PendingApprovalCollection,
    QAfterSortBy
  >
  sortByRequestedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(6);
    });
  }

  QueryBuilder<
    PendingApprovalCollection,
    PendingApprovalCollection,
    QAfterSortBy
  >
  sortByRequestedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(6, sort: Sort.desc);
    });
  }

  QueryBuilder<
    PendingApprovalCollection,
    PendingApprovalCollection,
    QAfterSortBy
  >
  sortByRequestedRoleIndex() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(7);
    });
  }

  QueryBuilder<
    PendingApprovalCollection,
    PendingApprovalCollection,
    QAfterSortBy
  >
  sortByRequestedRoleIndexDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(7, sort: Sort.desc);
    });
  }

  QueryBuilder<
    PendingApprovalCollection,
    PendingApprovalCollection,
    QAfterSortBy
  >
  sortByNotes({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(8, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<
    PendingApprovalCollection,
    PendingApprovalCollection,
    QAfterSortBy
  >
  sortByNotesDesc({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(8, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<
    PendingApprovalCollection,
    PendingApprovalCollection,
    QAfterSortBy
  >
  sortByStatusIndex() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(9);
    });
  }

  QueryBuilder<
    PendingApprovalCollection,
    PendingApprovalCollection,
    QAfterSortBy
  >
  sortByStatusIndexDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(9, sort: Sort.desc);
    });
  }

  QueryBuilder<
    PendingApprovalCollection,
    PendingApprovalCollection,
    QAfterSortBy
  >
  sortByReviewedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(10);
    });
  }

  QueryBuilder<
    PendingApprovalCollection,
    PendingApprovalCollection,
    QAfterSortBy
  >
  sortByReviewedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(10, sort: Sort.desc);
    });
  }

  QueryBuilder<
    PendingApprovalCollection,
    PendingApprovalCollection,
    QAfterSortBy
  >
  sortByReviewedBy({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(11, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<
    PendingApprovalCollection,
    PendingApprovalCollection,
    QAfterSortBy
  >
  sortByReviewedByDesc({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(11, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<
    PendingApprovalCollection,
    PendingApprovalCollection,
    QAfterSortBy
  >
  sortByRejectionReason({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(12, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<
    PendingApprovalCollection,
    PendingApprovalCollection,
    QAfterSortBy
  >
  sortByRejectionReasonDesc({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(12, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }
}

extension PendingApprovalCollectionQuerySortThenBy
    on
        QueryBuilder<
          PendingApprovalCollection,
          PendingApprovalCollection,
          QSortThenBy
        > {
  QueryBuilder<
    PendingApprovalCollection,
    PendingApprovalCollection,
    QAfterSortBy
  >
  thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(0);
    });
  }

  QueryBuilder<
    PendingApprovalCollection,
    PendingApprovalCollection,
    QAfterSortBy
  >
  thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(0, sort: Sort.desc);
    });
  }

  QueryBuilder<
    PendingApprovalCollection,
    PendingApprovalCollection,
    QAfterSortBy
  >
  thenByApprovalId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(1, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<
    PendingApprovalCollection,
    PendingApprovalCollection,
    QAfterSortBy
  >
  thenByApprovalIdDesc({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(1, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<
    PendingApprovalCollection,
    PendingApprovalCollection,
    QAfterSortBy
  >
  thenByName({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(2, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<
    PendingApprovalCollection,
    PendingApprovalCollection,
    QAfterSortBy
  >
  thenByNameDesc({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(2, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<
    PendingApprovalCollection,
    PendingApprovalCollection,
    QAfterSortBy
  >
  thenByEmail({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(3, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<
    PendingApprovalCollection,
    PendingApprovalCollection,
    QAfterSortBy
  >
  thenByEmailDesc({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(3, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<
    PendingApprovalCollection,
    PendingApprovalCollection,
    QAfterSortBy
  >
  thenByPhone({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(4, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<
    PendingApprovalCollection,
    PendingApprovalCollection,
    QAfterSortBy
  >
  thenByPhoneDesc({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(4, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<
    PendingApprovalCollection,
    PendingApprovalCollection,
    QAfterSortBy
  >
  thenByInviteCode({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(5, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<
    PendingApprovalCollection,
    PendingApprovalCollection,
    QAfterSortBy
  >
  thenByInviteCodeDesc({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(5, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<
    PendingApprovalCollection,
    PendingApprovalCollection,
    QAfterSortBy
  >
  thenByRequestedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(6);
    });
  }

  QueryBuilder<
    PendingApprovalCollection,
    PendingApprovalCollection,
    QAfterSortBy
  >
  thenByRequestedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(6, sort: Sort.desc);
    });
  }

  QueryBuilder<
    PendingApprovalCollection,
    PendingApprovalCollection,
    QAfterSortBy
  >
  thenByRequestedRoleIndex() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(7);
    });
  }

  QueryBuilder<
    PendingApprovalCollection,
    PendingApprovalCollection,
    QAfterSortBy
  >
  thenByRequestedRoleIndexDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(7, sort: Sort.desc);
    });
  }

  QueryBuilder<
    PendingApprovalCollection,
    PendingApprovalCollection,
    QAfterSortBy
  >
  thenByNotes({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(8, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<
    PendingApprovalCollection,
    PendingApprovalCollection,
    QAfterSortBy
  >
  thenByNotesDesc({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(8, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<
    PendingApprovalCollection,
    PendingApprovalCollection,
    QAfterSortBy
  >
  thenByStatusIndex() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(9);
    });
  }

  QueryBuilder<
    PendingApprovalCollection,
    PendingApprovalCollection,
    QAfterSortBy
  >
  thenByStatusIndexDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(9, sort: Sort.desc);
    });
  }

  QueryBuilder<
    PendingApprovalCollection,
    PendingApprovalCollection,
    QAfterSortBy
  >
  thenByReviewedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(10);
    });
  }

  QueryBuilder<
    PendingApprovalCollection,
    PendingApprovalCollection,
    QAfterSortBy
  >
  thenByReviewedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(10, sort: Sort.desc);
    });
  }

  QueryBuilder<
    PendingApprovalCollection,
    PendingApprovalCollection,
    QAfterSortBy
  >
  thenByReviewedBy({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(11, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<
    PendingApprovalCollection,
    PendingApprovalCollection,
    QAfterSortBy
  >
  thenByReviewedByDesc({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(11, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<
    PendingApprovalCollection,
    PendingApprovalCollection,
    QAfterSortBy
  >
  thenByRejectionReason({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(12, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<
    PendingApprovalCollection,
    PendingApprovalCollection,
    QAfterSortBy
  >
  thenByRejectionReasonDesc({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(12, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }
}

extension PendingApprovalCollectionQueryWhereDistinct
    on
        QueryBuilder<
          PendingApprovalCollection,
          PendingApprovalCollection,
          QDistinct
        > {
  QueryBuilder<
    PendingApprovalCollection,
    PendingApprovalCollection,
    QAfterDistinct
  >
  distinctByApprovalId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(1, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<
    PendingApprovalCollection,
    PendingApprovalCollection,
    QAfterDistinct
  >
  distinctByName({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(2, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<
    PendingApprovalCollection,
    PendingApprovalCollection,
    QAfterDistinct
  >
  distinctByEmail({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(3, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<
    PendingApprovalCollection,
    PendingApprovalCollection,
    QAfterDistinct
  >
  distinctByPhone({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(4, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<
    PendingApprovalCollection,
    PendingApprovalCollection,
    QAfterDistinct
  >
  distinctByInviteCode({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(5, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<
    PendingApprovalCollection,
    PendingApprovalCollection,
    QAfterDistinct
  >
  distinctByRequestedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(6);
    });
  }

  QueryBuilder<
    PendingApprovalCollection,
    PendingApprovalCollection,
    QAfterDistinct
  >
  distinctByRequestedRoleIndex() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(7);
    });
  }

  QueryBuilder<
    PendingApprovalCollection,
    PendingApprovalCollection,
    QAfterDistinct
  >
  distinctByNotes({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(8, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<
    PendingApprovalCollection,
    PendingApprovalCollection,
    QAfterDistinct
  >
  distinctByStatusIndex() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(9);
    });
  }

  QueryBuilder<
    PendingApprovalCollection,
    PendingApprovalCollection,
    QAfterDistinct
  >
  distinctByReviewedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(10);
    });
  }

  QueryBuilder<
    PendingApprovalCollection,
    PendingApprovalCollection,
    QAfterDistinct
  >
  distinctByReviewedBy({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(11, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<
    PendingApprovalCollection,
    PendingApprovalCollection,
    QAfterDistinct
  >
  distinctByRejectionReason({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(12, caseSensitive: caseSensitive);
    });
  }
}

extension PendingApprovalCollectionQueryProperty1
    on
        QueryBuilder<
          PendingApprovalCollection,
          PendingApprovalCollection,
          QProperty
        > {
  QueryBuilder<PendingApprovalCollection, int, QAfterProperty> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(0);
    });
  }

  QueryBuilder<PendingApprovalCollection, String, QAfterProperty>
  approvalIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(1);
    });
  }

  QueryBuilder<PendingApprovalCollection, String, QAfterProperty>
  nameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(2);
    });
  }

  QueryBuilder<PendingApprovalCollection, String, QAfterProperty>
  emailProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(3);
    });
  }

  QueryBuilder<PendingApprovalCollection, String?, QAfterProperty>
  phoneProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(4);
    });
  }

  QueryBuilder<PendingApprovalCollection, String?, QAfterProperty>
  inviteCodeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(5);
    });
  }

  QueryBuilder<PendingApprovalCollection, DateTime, QAfterProperty>
  requestedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(6);
    });
  }

  QueryBuilder<PendingApprovalCollection, int, QAfterProperty>
  requestedRoleIndexProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(7);
    });
  }

  QueryBuilder<PendingApprovalCollection, String?, QAfterProperty>
  notesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(8);
    });
  }

  QueryBuilder<PendingApprovalCollection, int, QAfterProperty>
  statusIndexProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(9);
    });
  }

  QueryBuilder<PendingApprovalCollection, DateTime?, QAfterProperty>
  reviewedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(10);
    });
  }

  QueryBuilder<PendingApprovalCollection, String?, QAfterProperty>
  reviewedByProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(11);
    });
  }

  QueryBuilder<PendingApprovalCollection, String?, QAfterProperty>
  rejectionReasonProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(12);
    });
  }
}

extension PendingApprovalCollectionQueryProperty2<R>
    on QueryBuilder<PendingApprovalCollection, R, QAfterProperty> {
  QueryBuilder<PendingApprovalCollection, (R, int), QAfterProperty>
  idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(0);
    });
  }

  QueryBuilder<PendingApprovalCollection, (R, String), QAfterProperty>
  approvalIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(1);
    });
  }

  QueryBuilder<PendingApprovalCollection, (R, String), QAfterProperty>
  nameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(2);
    });
  }

  QueryBuilder<PendingApprovalCollection, (R, String), QAfterProperty>
  emailProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(3);
    });
  }

  QueryBuilder<PendingApprovalCollection, (R, String?), QAfterProperty>
  phoneProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(4);
    });
  }

  QueryBuilder<PendingApprovalCollection, (R, String?), QAfterProperty>
  inviteCodeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(5);
    });
  }

  QueryBuilder<PendingApprovalCollection, (R, DateTime), QAfterProperty>
  requestedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(6);
    });
  }

  QueryBuilder<PendingApprovalCollection, (R, int), QAfterProperty>
  requestedRoleIndexProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(7);
    });
  }

  QueryBuilder<PendingApprovalCollection, (R, String?), QAfterProperty>
  notesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(8);
    });
  }

  QueryBuilder<PendingApprovalCollection, (R, int), QAfterProperty>
  statusIndexProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(9);
    });
  }

  QueryBuilder<PendingApprovalCollection, (R, DateTime?), QAfterProperty>
  reviewedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(10);
    });
  }

  QueryBuilder<PendingApprovalCollection, (R, String?), QAfterProperty>
  reviewedByProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(11);
    });
  }

  QueryBuilder<PendingApprovalCollection, (R, String?), QAfterProperty>
  rejectionReasonProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(12);
    });
  }
}

extension PendingApprovalCollectionQueryProperty3<R1, R2>
    on QueryBuilder<PendingApprovalCollection, (R1, R2), QAfterProperty> {
  QueryBuilder<PendingApprovalCollection, (R1, R2, int), QOperations>
  idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(0);
    });
  }

  QueryBuilder<PendingApprovalCollection, (R1, R2, String), QOperations>
  approvalIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(1);
    });
  }

  QueryBuilder<PendingApprovalCollection, (R1, R2, String), QOperations>
  nameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(2);
    });
  }

  QueryBuilder<PendingApprovalCollection, (R1, R2, String), QOperations>
  emailProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(3);
    });
  }

  QueryBuilder<PendingApprovalCollection, (R1, R2, String?), QOperations>
  phoneProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(4);
    });
  }

  QueryBuilder<PendingApprovalCollection, (R1, R2, String?), QOperations>
  inviteCodeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(5);
    });
  }

  QueryBuilder<PendingApprovalCollection, (R1, R2, DateTime), QOperations>
  requestedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(6);
    });
  }

  QueryBuilder<PendingApprovalCollection, (R1, R2, int), QOperations>
  requestedRoleIndexProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(7);
    });
  }

  QueryBuilder<PendingApprovalCollection, (R1, R2, String?), QOperations>
  notesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(8);
    });
  }

  QueryBuilder<PendingApprovalCollection, (R1, R2, int), QOperations>
  statusIndexProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(9);
    });
  }

  QueryBuilder<PendingApprovalCollection, (R1, R2, DateTime?), QOperations>
  reviewedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(10);
    });
  }

  QueryBuilder<PendingApprovalCollection, (R1, R2, String?), QOperations>
  reviewedByProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(11);
    });
  }

  QueryBuilder<PendingApprovalCollection, (R1, R2, String?), QOperations>
  rejectionReasonProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(12);
    });
  }
}
