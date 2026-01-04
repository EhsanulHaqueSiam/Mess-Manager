// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'duty_collection.dart';

// **************************************************************************
// _IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, invalid_use_of_protected_member, lines_longer_than_80_chars, constant_identifier_names, avoid_js_rounded_ints, no_leading_underscores_for_local_identifiers, require_trailing_commas, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_in_if_null_operators, library_private_types_in_public_api, prefer_const_constructors
// ignore_for_file: type=lint

extension GetDutyAssignmentCollectionCollection on Isar {
  IsarCollection<int, DutyAssignmentCollection> get dutyAssignmentCollections =>
      this.collection();
}

final DutyAssignmentCollectionSchema = IsarGeneratedSchema(
  schema: IsarSchema(
    name: 'DutyAssignmentCollection',
    idName: 'id',
    embedded: false,
    properties: [
      IsarPropertySchema(name: 'assignmentId', type: IsarType.string),
      IsarPropertySchema(name: 'messId', type: IsarType.string),
      IsarPropertySchema(name: 'memberId', type: IsarType.string),
      IsarPropertySchema(name: 'typeIndex', type: IsarType.long),
      IsarPropertySchema(name: 'date', type: IsarType.dateTime),
      IsarPropertySchema(name: 'statusIndex', type: IsarType.long),
      IsarPropertySchema(name: 'completedAt', type: IsarType.dateTime),
      IsarPropertySchema(name: 'proofImagePath', type: IsarType.string),
      IsarPropertySchema(name: 'note', type: IsarType.string),
      IsarPropertySchema(name: 'swappedWithMemberId', type: IsarType.string),
      IsarPropertySchema(name: 'disputedBy', type: IsarType.string),
      IsarPropertySchema(name: 'disputePhotoPath', type: IsarType.string),
      IsarPropertySchema(name: 'disputeReason', type: IsarType.string),
      IsarPropertySchema(name: 'disputedAt', type: IsarType.dateTime),
      IsarPropertySchema(name: 'adminNotes', type: IsarType.string),
      IsarPropertySchema(name: 'reviewedBy', type: IsarType.string),
      IsarPropertySchema(name: 'reviewedAt', type: IsarType.dateTime),
      IsarPropertySchema(name: 'completedByMemberId', type: IsarType.string),
    ],
    indexes: [
      IsarIndexSchema(
        name: 'assignmentId',
        properties: ["assignmentId"],
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
  converter: IsarObjectConverter<int, DutyAssignmentCollection>(
    serialize: serializeDutyAssignmentCollection,
    deserialize: deserializeDutyAssignmentCollection,
    deserializeProperty: deserializeDutyAssignmentCollectionProp,
  ),
  getEmbeddedSchemas: () => [],
);

@isarProtected
int serializeDutyAssignmentCollection(
  IsarWriter writer,
  DutyAssignmentCollection object,
) {
  IsarCore.writeString(writer, 1, object.assignmentId);
  IsarCore.writeString(writer, 2, object.messId);
  IsarCore.writeString(writer, 3, object.memberId);
  IsarCore.writeLong(writer, 4, object.typeIndex);
  IsarCore.writeLong(writer, 5, object.date.toUtc().microsecondsSinceEpoch);
  IsarCore.writeLong(writer, 6, object.statusIndex);
  IsarCore.writeLong(
    writer,
    7,
    object.completedAt?.toUtc().microsecondsSinceEpoch ?? -9223372036854775808,
  );
  {
    final value = object.proofImagePath;
    if (value == null) {
      IsarCore.writeNull(writer, 8);
    } else {
      IsarCore.writeString(writer, 8, value);
    }
  }
  {
    final value = object.note;
    if (value == null) {
      IsarCore.writeNull(writer, 9);
    } else {
      IsarCore.writeString(writer, 9, value);
    }
  }
  {
    final value = object.swappedWithMemberId;
    if (value == null) {
      IsarCore.writeNull(writer, 10);
    } else {
      IsarCore.writeString(writer, 10, value);
    }
  }
  {
    final value = object.disputedBy;
    if (value == null) {
      IsarCore.writeNull(writer, 11);
    } else {
      IsarCore.writeString(writer, 11, value);
    }
  }
  {
    final value = object.disputePhotoPath;
    if (value == null) {
      IsarCore.writeNull(writer, 12);
    } else {
      IsarCore.writeString(writer, 12, value);
    }
  }
  {
    final value = object.disputeReason;
    if (value == null) {
      IsarCore.writeNull(writer, 13);
    } else {
      IsarCore.writeString(writer, 13, value);
    }
  }
  IsarCore.writeLong(
    writer,
    14,
    object.disputedAt?.toUtc().microsecondsSinceEpoch ?? -9223372036854775808,
  );
  {
    final value = object.adminNotes;
    if (value == null) {
      IsarCore.writeNull(writer, 15);
    } else {
      IsarCore.writeString(writer, 15, value);
    }
  }
  {
    final value = object.reviewedBy;
    if (value == null) {
      IsarCore.writeNull(writer, 16);
    } else {
      IsarCore.writeString(writer, 16, value);
    }
  }
  IsarCore.writeLong(
    writer,
    17,
    object.reviewedAt?.toUtc().microsecondsSinceEpoch ?? -9223372036854775808,
  );
  {
    final value = object.completedByMemberId;
    if (value == null) {
      IsarCore.writeNull(writer, 18);
    } else {
      IsarCore.writeString(writer, 18, value);
    }
  }
  return object.id;
}

@isarProtected
DutyAssignmentCollection deserializeDutyAssignmentCollection(
  IsarReader reader,
) {
  final object = DutyAssignmentCollection();
  object.id = IsarCore.readId(reader);
  object.assignmentId = IsarCore.readString(reader, 1) ?? '';
  object.messId = IsarCore.readString(reader, 2) ?? '';
  object.memberId = IsarCore.readString(reader, 3) ?? '';
  object.typeIndex = IsarCore.readLong(reader, 4);
  {
    final value = IsarCore.readLong(reader, 5);
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
  object.statusIndex = IsarCore.readLong(reader, 6);
  {
    final value = IsarCore.readLong(reader, 7);
    if (value == -9223372036854775808) {
      object.completedAt = null;
    } else {
      object.completedAt = DateTime.fromMicrosecondsSinceEpoch(
        value,
        isUtc: true,
      ).toLocal();
    }
  }
  object.proofImagePath = IsarCore.readString(reader, 8);
  object.note = IsarCore.readString(reader, 9);
  object.swappedWithMemberId = IsarCore.readString(reader, 10);
  object.disputedBy = IsarCore.readString(reader, 11);
  object.disputePhotoPath = IsarCore.readString(reader, 12);
  object.disputeReason = IsarCore.readString(reader, 13);
  {
    final value = IsarCore.readLong(reader, 14);
    if (value == -9223372036854775808) {
      object.disputedAt = null;
    } else {
      object.disputedAt = DateTime.fromMicrosecondsSinceEpoch(
        value,
        isUtc: true,
      ).toLocal();
    }
  }
  object.adminNotes = IsarCore.readString(reader, 15);
  object.reviewedBy = IsarCore.readString(reader, 16);
  {
    final value = IsarCore.readLong(reader, 17);
    if (value == -9223372036854775808) {
      object.reviewedAt = null;
    } else {
      object.reviewedAt = DateTime.fromMicrosecondsSinceEpoch(
        value,
        isUtc: true,
      ).toLocal();
    }
  }
  object.completedByMemberId = IsarCore.readString(reader, 18);
  return object;
}

@isarProtected
dynamic deserializeDutyAssignmentCollectionProp(
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
      return IsarCore.readLong(reader, 6);
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
      return IsarCore.readString(reader, 8);
    case 9:
      return IsarCore.readString(reader, 9);
    case 10:
      return IsarCore.readString(reader, 10);
    case 11:
      return IsarCore.readString(reader, 11);
    case 12:
      return IsarCore.readString(reader, 12);
    case 13:
      return IsarCore.readString(reader, 13);
    case 14:
      {
        final value = IsarCore.readLong(reader, 14);
        if (value == -9223372036854775808) {
          return null;
        } else {
          return DateTime.fromMicrosecondsSinceEpoch(
            value,
            isUtc: true,
          ).toLocal();
        }
      }
    case 15:
      return IsarCore.readString(reader, 15);
    case 16:
      return IsarCore.readString(reader, 16);
    case 17:
      {
        final value = IsarCore.readLong(reader, 17);
        if (value == -9223372036854775808) {
          return null;
        } else {
          return DateTime.fromMicrosecondsSinceEpoch(
            value,
            isUtc: true,
          ).toLocal();
        }
      }
    case 18:
      return IsarCore.readString(reader, 18);
    default:
      throw ArgumentError('Unknown property: $property');
  }
}

sealed class _DutyAssignmentCollectionUpdate {
  bool call({
    required int id,
    String? assignmentId,
    String? messId,
    String? memberId,
    int? typeIndex,
    DateTime? date,
    int? statusIndex,
    DateTime? completedAt,
    String? proofImagePath,
    String? note,
    String? swappedWithMemberId,
    String? disputedBy,
    String? disputePhotoPath,
    String? disputeReason,
    DateTime? disputedAt,
    String? adminNotes,
    String? reviewedBy,
    DateTime? reviewedAt,
    String? completedByMemberId,
  });
}

class _DutyAssignmentCollectionUpdateImpl
    implements _DutyAssignmentCollectionUpdate {
  const _DutyAssignmentCollectionUpdateImpl(this.collection);

  final IsarCollection<int, DutyAssignmentCollection> collection;

  @override
  bool call({
    required int id,
    Object? assignmentId = ignore,
    Object? messId = ignore,
    Object? memberId = ignore,
    Object? typeIndex = ignore,
    Object? date = ignore,
    Object? statusIndex = ignore,
    Object? completedAt = ignore,
    Object? proofImagePath = ignore,
    Object? note = ignore,
    Object? swappedWithMemberId = ignore,
    Object? disputedBy = ignore,
    Object? disputePhotoPath = ignore,
    Object? disputeReason = ignore,
    Object? disputedAt = ignore,
    Object? adminNotes = ignore,
    Object? reviewedBy = ignore,
    Object? reviewedAt = ignore,
    Object? completedByMemberId = ignore,
  }) {
    return collection.updateProperties(
          [id],
          {
            if (assignmentId != ignore) 1: assignmentId as String?,
            if (messId != ignore) 2: messId as String?,
            if (memberId != ignore) 3: memberId as String?,
            if (typeIndex != ignore) 4: typeIndex as int?,
            if (date != ignore) 5: date as DateTime?,
            if (statusIndex != ignore) 6: statusIndex as int?,
            if (completedAt != ignore) 7: completedAt as DateTime?,
            if (proofImagePath != ignore) 8: proofImagePath as String?,
            if (note != ignore) 9: note as String?,
            if (swappedWithMemberId != ignore)
              10: swappedWithMemberId as String?,
            if (disputedBy != ignore) 11: disputedBy as String?,
            if (disputePhotoPath != ignore) 12: disputePhotoPath as String?,
            if (disputeReason != ignore) 13: disputeReason as String?,
            if (disputedAt != ignore) 14: disputedAt as DateTime?,
            if (adminNotes != ignore) 15: adminNotes as String?,
            if (reviewedBy != ignore) 16: reviewedBy as String?,
            if (reviewedAt != ignore) 17: reviewedAt as DateTime?,
            if (completedByMemberId != ignore)
              18: completedByMemberId as String?,
          },
        ) >
        0;
  }
}

sealed class _DutyAssignmentCollectionUpdateAll {
  int call({
    required List<int> id,
    String? assignmentId,
    String? messId,
    String? memberId,
    int? typeIndex,
    DateTime? date,
    int? statusIndex,
    DateTime? completedAt,
    String? proofImagePath,
    String? note,
    String? swappedWithMemberId,
    String? disputedBy,
    String? disputePhotoPath,
    String? disputeReason,
    DateTime? disputedAt,
    String? adminNotes,
    String? reviewedBy,
    DateTime? reviewedAt,
    String? completedByMemberId,
  });
}

class _DutyAssignmentCollectionUpdateAllImpl
    implements _DutyAssignmentCollectionUpdateAll {
  const _DutyAssignmentCollectionUpdateAllImpl(this.collection);

  final IsarCollection<int, DutyAssignmentCollection> collection;

  @override
  int call({
    required List<int> id,
    Object? assignmentId = ignore,
    Object? messId = ignore,
    Object? memberId = ignore,
    Object? typeIndex = ignore,
    Object? date = ignore,
    Object? statusIndex = ignore,
    Object? completedAt = ignore,
    Object? proofImagePath = ignore,
    Object? note = ignore,
    Object? swappedWithMemberId = ignore,
    Object? disputedBy = ignore,
    Object? disputePhotoPath = ignore,
    Object? disputeReason = ignore,
    Object? disputedAt = ignore,
    Object? adminNotes = ignore,
    Object? reviewedBy = ignore,
    Object? reviewedAt = ignore,
    Object? completedByMemberId = ignore,
  }) {
    return collection.updateProperties(id, {
      if (assignmentId != ignore) 1: assignmentId as String?,
      if (messId != ignore) 2: messId as String?,
      if (memberId != ignore) 3: memberId as String?,
      if (typeIndex != ignore) 4: typeIndex as int?,
      if (date != ignore) 5: date as DateTime?,
      if (statusIndex != ignore) 6: statusIndex as int?,
      if (completedAt != ignore) 7: completedAt as DateTime?,
      if (proofImagePath != ignore) 8: proofImagePath as String?,
      if (note != ignore) 9: note as String?,
      if (swappedWithMemberId != ignore) 10: swappedWithMemberId as String?,
      if (disputedBy != ignore) 11: disputedBy as String?,
      if (disputePhotoPath != ignore) 12: disputePhotoPath as String?,
      if (disputeReason != ignore) 13: disputeReason as String?,
      if (disputedAt != ignore) 14: disputedAt as DateTime?,
      if (adminNotes != ignore) 15: adminNotes as String?,
      if (reviewedBy != ignore) 16: reviewedBy as String?,
      if (reviewedAt != ignore) 17: reviewedAt as DateTime?,
      if (completedByMemberId != ignore) 18: completedByMemberId as String?,
    });
  }
}

extension DutyAssignmentCollectionUpdate
    on IsarCollection<int, DutyAssignmentCollection> {
  _DutyAssignmentCollectionUpdate get update =>
      _DutyAssignmentCollectionUpdateImpl(this);

  _DutyAssignmentCollectionUpdateAll get updateAll =>
      _DutyAssignmentCollectionUpdateAllImpl(this);
}

sealed class _DutyAssignmentCollectionQueryUpdate {
  int call({
    String? assignmentId,
    String? messId,
    String? memberId,
    int? typeIndex,
    DateTime? date,
    int? statusIndex,
    DateTime? completedAt,
    String? proofImagePath,
    String? note,
    String? swappedWithMemberId,
    String? disputedBy,
    String? disputePhotoPath,
    String? disputeReason,
    DateTime? disputedAt,
    String? adminNotes,
    String? reviewedBy,
    DateTime? reviewedAt,
    String? completedByMemberId,
  });
}

class _DutyAssignmentCollectionQueryUpdateImpl
    implements _DutyAssignmentCollectionQueryUpdate {
  const _DutyAssignmentCollectionQueryUpdateImpl(this.query, {this.limit});

  final IsarQuery<DutyAssignmentCollection> query;
  final int? limit;

  @override
  int call({
    Object? assignmentId = ignore,
    Object? messId = ignore,
    Object? memberId = ignore,
    Object? typeIndex = ignore,
    Object? date = ignore,
    Object? statusIndex = ignore,
    Object? completedAt = ignore,
    Object? proofImagePath = ignore,
    Object? note = ignore,
    Object? swappedWithMemberId = ignore,
    Object? disputedBy = ignore,
    Object? disputePhotoPath = ignore,
    Object? disputeReason = ignore,
    Object? disputedAt = ignore,
    Object? adminNotes = ignore,
    Object? reviewedBy = ignore,
    Object? reviewedAt = ignore,
    Object? completedByMemberId = ignore,
  }) {
    return query.updateProperties(limit: limit, {
      if (assignmentId != ignore) 1: assignmentId as String?,
      if (messId != ignore) 2: messId as String?,
      if (memberId != ignore) 3: memberId as String?,
      if (typeIndex != ignore) 4: typeIndex as int?,
      if (date != ignore) 5: date as DateTime?,
      if (statusIndex != ignore) 6: statusIndex as int?,
      if (completedAt != ignore) 7: completedAt as DateTime?,
      if (proofImagePath != ignore) 8: proofImagePath as String?,
      if (note != ignore) 9: note as String?,
      if (swappedWithMemberId != ignore) 10: swappedWithMemberId as String?,
      if (disputedBy != ignore) 11: disputedBy as String?,
      if (disputePhotoPath != ignore) 12: disputePhotoPath as String?,
      if (disputeReason != ignore) 13: disputeReason as String?,
      if (disputedAt != ignore) 14: disputedAt as DateTime?,
      if (adminNotes != ignore) 15: adminNotes as String?,
      if (reviewedBy != ignore) 16: reviewedBy as String?,
      if (reviewedAt != ignore) 17: reviewedAt as DateTime?,
      if (completedByMemberId != ignore) 18: completedByMemberId as String?,
    });
  }
}

extension DutyAssignmentCollectionQueryUpdate
    on IsarQuery<DutyAssignmentCollection> {
  _DutyAssignmentCollectionQueryUpdate get updateFirst =>
      _DutyAssignmentCollectionQueryUpdateImpl(this, limit: 1);

  _DutyAssignmentCollectionQueryUpdate get updateAll =>
      _DutyAssignmentCollectionQueryUpdateImpl(this);
}

class _DutyAssignmentCollectionQueryBuilderUpdateImpl
    implements _DutyAssignmentCollectionQueryUpdate {
  const _DutyAssignmentCollectionQueryBuilderUpdateImpl(
    this.query, {
    this.limit,
  });

  final QueryBuilder<
    DutyAssignmentCollection,
    DutyAssignmentCollection,
    QOperations
  >
  query;
  final int? limit;

  @override
  int call({
    Object? assignmentId = ignore,
    Object? messId = ignore,
    Object? memberId = ignore,
    Object? typeIndex = ignore,
    Object? date = ignore,
    Object? statusIndex = ignore,
    Object? completedAt = ignore,
    Object? proofImagePath = ignore,
    Object? note = ignore,
    Object? swappedWithMemberId = ignore,
    Object? disputedBy = ignore,
    Object? disputePhotoPath = ignore,
    Object? disputeReason = ignore,
    Object? disputedAt = ignore,
    Object? adminNotes = ignore,
    Object? reviewedBy = ignore,
    Object? reviewedAt = ignore,
    Object? completedByMemberId = ignore,
  }) {
    final q = query.build();
    try {
      return q.updateProperties(limit: limit, {
        if (assignmentId != ignore) 1: assignmentId as String?,
        if (messId != ignore) 2: messId as String?,
        if (memberId != ignore) 3: memberId as String?,
        if (typeIndex != ignore) 4: typeIndex as int?,
        if (date != ignore) 5: date as DateTime?,
        if (statusIndex != ignore) 6: statusIndex as int?,
        if (completedAt != ignore) 7: completedAt as DateTime?,
        if (proofImagePath != ignore) 8: proofImagePath as String?,
        if (note != ignore) 9: note as String?,
        if (swappedWithMemberId != ignore) 10: swappedWithMemberId as String?,
        if (disputedBy != ignore) 11: disputedBy as String?,
        if (disputePhotoPath != ignore) 12: disputePhotoPath as String?,
        if (disputeReason != ignore) 13: disputeReason as String?,
        if (disputedAt != ignore) 14: disputedAt as DateTime?,
        if (adminNotes != ignore) 15: adminNotes as String?,
        if (reviewedBy != ignore) 16: reviewedBy as String?,
        if (reviewedAt != ignore) 17: reviewedAt as DateTime?,
        if (completedByMemberId != ignore) 18: completedByMemberId as String?,
      });
    } finally {
      q.close();
    }
  }
}

extension DutyAssignmentCollectionQueryBuilderUpdate
    on
        QueryBuilder<
          DutyAssignmentCollection,
          DutyAssignmentCollection,
          QOperations
        > {
  _DutyAssignmentCollectionQueryUpdate get updateFirst =>
      _DutyAssignmentCollectionQueryBuilderUpdateImpl(this, limit: 1);

  _DutyAssignmentCollectionQueryUpdate get updateAll =>
      _DutyAssignmentCollectionQueryBuilderUpdateImpl(this);
}

extension DutyAssignmentCollectionQueryFilter
    on
        QueryBuilder<
          DutyAssignmentCollection,
          DutyAssignmentCollection,
          QFilterCondition
        > {
  QueryBuilder<
    DutyAssignmentCollection,
    DutyAssignmentCollection,
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
    DutyAssignmentCollection,
    DutyAssignmentCollection,
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
    DutyAssignmentCollection,
    DutyAssignmentCollection,
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
    DutyAssignmentCollection,
    DutyAssignmentCollection,
    QAfterFilterCondition
  >
  idLessThan(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(LessCondition(property: 0, value: value));
    });
  }

  QueryBuilder<
    DutyAssignmentCollection,
    DutyAssignmentCollection,
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
    DutyAssignmentCollection,
    DutyAssignmentCollection,
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
    DutyAssignmentCollection,
    DutyAssignmentCollection,
    QAfterFilterCondition
  >
  assignmentIdEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(property: 1, value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<
    DutyAssignmentCollection,
    DutyAssignmentCollection,
    QAfterFilterCondition
  >
  assignmentIdGreaterThan(String value, {bool caseSensitive = true}) {
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
    DutyAssignmentCollection,
    DutyAssignmentCollection,
    QAfterFilterCondition
  >
  assignmentIdGreaterThanOrEqualTo(String value, {bool caseSensitive = true}) {
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
    DutyAssignmentCollection,
    DutyAssignmentCollection,
    QAfterFilterCondition
  >
  assignmentIdLessThan(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(property: 1, value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<
    DutyAssignmentCollection,
    DutyAssignmentCollection,
    QAfterFilterCondition
  >
  assignmentIdLessThanOrEqualTo(String value, {bool caseSensitive = true}) {
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
    DutyAssignmentCollection,
    DutyAssignmentCollection,
    QAfterFilterCondition
  >
  assignmentIdBetween(String lower, String upper, {bool caseSensitive = true}) {
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
    DutyAssignmentCollection,
    DutyAssignmentCollection,
    QAfterFilterCondition
  >
  assignmentIdStartsWith(String value, {bool caseSensitive = true}) {
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
    DutyAssignmentCollection,
    DutyAssignmentCollection,
    QAfterFilterCondition
  >
  assignmentIdEndsWith(String value, {bool caseSensitive = true}) {
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
    DutyAssignmentCollection,
    DutyAssignmentCollection,
    QAfterFilterCondition
  >
  assignmentIdContains(String value, {bool caseSensitive = true}) {
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
    DutyAssignmentCollection,
    DutyAssignmentCollection,
    QAfterFilterCondition
  >
  assignmentIdMatches(String pattern, {bool caseSensitive = true}) {
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
    DutyAssignmentCollection,
    DutyAssignmentCollection,
    QAfterFilterCondition
  >
  assignmentIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const EqualCondition(property: 1, value: ''),
      );
    });
  }

  QueryBuilder<
    DutyAssignmentCollection,
    DutyAssignmentCollection,
    QAfterFilterCondition
  >
  assignmentIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const GreaterCondition(property: 1, value: ''),
      );
    });
  }

  QueryBuilder<
    DutyAssignmentCollection,
    DutyAssignmentCollection,
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
    DutyAssignmentCollection,
    DutyAssignmentCollection,
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
    DutyAssignmentCollection,
    DutyAssignmentCollection,
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
    DutyAssignmentCollection,
    DutyAssignmentCollection,
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
    DutyAssignmentCollection,
    DutyAssignmentCollection,
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
    DutyAssignmentCollection,
    DutyAssignmentCollection,
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
    DutyAssignmentCollection,
    DutyAssignmentCollection,
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
    DutyAssignmentCollection,
    DutyAssignmentCollection,
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
    DutyAssignmentCollection,
    DutyAssignmentCollection,
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
    DutyAssignmentCollection,
    DutyAssignmentCollection,
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
    DutyAssignmentCollection,
    DutyAssignmentCollection,
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
    DutyAssignmentCollection,
    DutyAssignmentCollection,
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
    DutyAssignmentCollection,
    DutyAssignmentCollection,
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
    DutyAssignmentCollection,
    DutyAssignmentCollection,
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
    DutyAssignmentCollection,
    DutyAssignmentCollection,
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
    DutyAssignmentCollection,
    DutyAssignmentCollection,
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
    DutyAssignmentCollection,
    DutyAssignmentCollection,
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
    DutyAssignmentCollection,
    DutyAssignmentCollection,
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
    DutyAssignmentCollection,
    DutyAssignmentCollection,
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
    DutyAssignmentCollection,
    DutyAssignmentCollection,
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
    DutyAssignmentCollection,
    DutyAssignmentCollection,
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
    DutyAssignmentCollection,
    DutyAssignmentCollection,
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
    DutyAssignmentCollection,
    DutyAssignmentCollection,
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
    DutyAssignmentCollection,
    DutyAssignmentCollection,
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
    DutyAssignmentCollection,
    DutyAssignmentCollection,
    QAfterFilterCondition
  >
  typeIndexEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(property: 4, value: value),
      );
    });
  }

  QueryBuilder<
    DutyAssignmentCollection,
    DutyAssignmentCollection,
    QAfterFilterCondition
  >
  typeIndexGreaterThan(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(property: 4, value: value),
      );
    });
  }

  QueryBuilder<
    DutyAssignmentCollection,
    DutyAssignmentCollection,
    QAfterFilterCondition
  >
  typeIndexGreaterThanOrEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(property: 4, value: value),
      );
    });
  }

  QueryBuilder<
    DutyAssignmentCollection,
    DutyAssignmentCollection,
    QAfterFilterCondition
  >
  typeIndexLessThan(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(LessCondition(property: 4, value: value));
    });
  }

  QueryBuilder<
    DutyAssignmentCollection,
    DutyAssignmentCollection,
    QAfterFilterCondition
  >
  typeIndexLessThanOrEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(property: 4, value: value),
      );
    });
  }

  QueryBuilder<
    DutyAssignmentCollection,
    DutyAssignmentCollection,
    QAfterFilterCondition
  >
  typeIndexBetween(int lower, int upper) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(property: 4, lower: lower, upper: upper),
      );
    });
  }

  QueryBuilder<
    DutyAssignmentCollection,
    DutyAssignmentCollection,
    QAfterFilterCondition
  >
  dateEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(property: 5, value: value),
      );
    });
  }

  QueryBuilder<
    DutyAssignmentCollection,
    DutyAssignmentCollection,
    QAfterFilterCondition
  >
  dateGreaterThan(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(property: 5, value: value),
      );
    });
  }

  QueryBuilder<
    DutyAssignmentCollection,
    DutyAssignmentCollection,
    QAfterFilterCondition
  >
  dateGreaterThanOrEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(property: 5, value: value),
      );
    });
  }

  QueryBuilder<
    DutyAssignmentCollection,
    DutyAssignmentCollection,
    QAfterFilterCondition
  >
  dateLessThan(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(LessCondition(property: 5, value: value));
    });
  }

  QueryBuilder<
    DutyAssignmentCollection,
    DutyAssignmentCollection,
    QAfterFilterCondition
  >
  dateLessThanOrEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(property: 5, value: value),
      );
    });
  }

  QueryBuilder<
    DutyAssignmentCollection,
    DutyAssignmentCollection,
    QAfterFilterCondition
  >
  dateBetween(DateTime lower, DateTime upper) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(property: 5, lower: lower, upper: upper),
      );
    });
  }

  QueryBuilder<
    DutyAssignmentCollection,
    DutyAssignmentCollection,
    QAfterFilterCondition
  >
  statusIndexEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(property: 6, value: value),
      );
    });
  }

  QueryBuilder<
    DutyAssignmentCollection,
    DutyAssignmentCollection,
    QAfterFilterCondition
  >
  statusIndexGreaterThan(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(property: 6, value: value),
      );
    });
  }

  QueryBuilder<
    DutyAssignmentCollection,
    DutyAssignmentCollection,
    QAfterFilterCondition
  >
  statusIndexGreaterThanOrEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(property: 6, value: value),
      );
    });
  }

  QueryBuilder<
    DutyAssignmentCollection,
    DutyAssignmentCollection,
    QAfterFilterCondition
  >
  statusIndexLessThan(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(LessCondition(property: 6, value: value));
    });
  }

  QueryBuilder<
    DutyAssignmentCollection,
    DutyAssignmentCollection,
    QAfterFilterCondition
  >
  statusIndexLessThanOrEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(property: 6, value: value),
      );
    });
  }

  QueryBuilder<
    DutyAssignmentCollection,
    DutyAssignmentCollection,
    QAfterFilterCondition
  >
  statusIndexBetween(int lower, int upper) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(property: 6, lower: lower, upper: upper),
      );
    });
  }

  QueryBuilder<
    DutyAssignmentCollection,
    DutyAssignmentCollection,
    QAfterFilterCondition
  >
  completedAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const IsNullCondition(property: 7));
    });
  }

  QueryBuilder<
    DutyAssignmentCollection,
    DutyAssignmentCollection,
    QAfterFilterCondition
  >
  completedAtIsNotNull() {
    return QueryBuilder.apply(not(), (query) {
      return query.addFilterCondition(const IsNullCondition(property: 7));
    });
  }

  QueryBuilder<
    DutyAssignmentCollection,
    DutyAssignmentCollection,
    QAfterFilterCondition
  >
  completedAtEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(property: 7, value: value),
      );
    });
  }

  QueryBuilder<
    DutyAssignmentCollection,
    DutyAssignmentCollection,
    QAfterFilterCondition
  >
  completedAtGreaterThan(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(property: 7, value: value),
      );
    });
  }

  QueryBuilder<
    DutyAssignmentCollection,
    DutyAssignmentCollection,
    QAfterFilterCondition
  >
  completedAtGreaterThanOrEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(property: 7, value: value),
      );
    });
  }

  QueryBuilder<
    DutyAssignmentCollection,
    DutyAssignmentCollection,
    QAfterFilterCondition
  >
  completedAtLessThan(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(LessCondition(property: 7, value: value));
    });
  }

  QueryBuilder<
    DutyAssignmentCollection,
    DutyAssignmentCollection,
    QAfterFilterCondition
  >
  completedAtLessThanOrEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(property: 7, value: value),
      );
    });
  }

  QueryBuilder<
    DutyAssignmentCollection,
    DutyAssignmentCollection,
    QAfterFilterCondition
  >
  completedAtBetween(DateTime? lower, DateTime? upper) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(property: 7, lower: lower, upper: upper),
      );
    });
  }

  QueryBuilder<
    DutyAssignmentCollection,
    DutyAssignmentCollection,
    QAfterFilterCondition
  >
  proofImagePathIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const IsNullCondition(property: 8));
    });
  }

  QueryBuilder<
    DutyAssignmentCollection,
    DutyAssignmentCollection,
    QAfterFilterCondition
  >
  proofImagePathIsNotNull() {
    return QueryBuilder.apply(not(), (query) {
      return query.addFilterCondition(const IsNullCondition(property: 8));
    });
  }

  QueryBuilder<
    DutyAssignmentCollection,
    DutyAssignmentCollection,
    QAfterFilterCondition
  >
  proofImagePathEqualTo(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(property: 8, value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<
    DutyAssignmentCollection,
    DutyAssignmentCollection,
    QAfterFilterCondition
  >
  proofImagePathGreaterThan(String? value, {bool caseSensitive = true}) {
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
    DutyAssignmentCollection,
    DutyAssignmentCollection,
    QAfterFilterCondition
  >
  proofImagePathGreaterThanOrEqualTo(
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
    DutyAssignmentCollection,
    DutyAssignmentCollection,
    QAfterFilterCondition
  >
  proofImagePathLessThan(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(property: 8, value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<
    DutyAssignmentCollection,
    DutyAssignmentCollection,
    QAfterFilterCondition
  >
  proofImagePathLessThanOrEqualTo(String? value, {bool caseSensitive = true}) {
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
    DutyAssignmentCollection,
    DutyAssignmentCollection,
    QAfterFilterCondition
  >
  proofImagePathBetween(
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
    DutyAssignmentCollection,
    DutyAssignmentCollection,
    QAfterFilterCondition
  >
  proofImagePathStartsWith(String value, {bool caseSensitive = true}) {
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
    DutyAssignmentCollection,
    DutyAssignmentCollection,
    QAfterFilterCondition
  >
  proofImagePathEndsWith(String value, {bool caseSensitive = true}) {
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
    DutyAssignmentCollection,
    DutyAssignmentCollection,
    QAfterFilterCondition
  >
  proofImagePathContains(String value, {bool caseSensitive = true}) {
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
    DutyAssignmentCollection,
    DutyAssignmentCollection,
    QAfterFilterCondition
  >
  proofImagePathMatches(String pattern, {bool caseSensitive = true}) {
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
    DutyAssignmentCollection,
    DutyAssignmentCollection,
    QAfterFilterCondition
  >
  proofImagePathIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const EqualCondition(property: 8, value: ''),
      );
    });
  }

  QueryBuilder<
    DutyAssignmentCollection,
    DutyAssignmentCollection,
    QAfterFilterCondition
  >
  proofImagePathIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const GreaterCondition(property: 8, value: ''),
      );
    });
  }

  QueryBuilder<
    DutyAssignmentCollection,
    DutyAssignmentCollection,
    QAfterFilterCondition
  >
  noteIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const IsNullCondition(property: 9));
    });
  }

  QueryBuilder<
    DutyAssignmentCollection,
    DutyAssignmentCollection,
    QAfterFilterCondition
  >
  noteIsNotNull() {
    return QueryBuilder.apply(not(), (query) {
      return query.addFilterCondition(const IsNullCondition(property: 9));
    });
  }

  QueryBuilder<
    DutyAssignmentCollection,
    DutyAssignmentCollection,
    QAfterFilterCondition
  >
  noteEqualTo(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(property: 9, value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<
    DutyAssignmentCollection,
    DutyAssignmentCollection,
    QAfterFilterCondition
  >
  noteGreaterThan(String? value, {bool caseSensitive = true}) {
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
    DutyAssignmentCollection,
    DutyAssignmentCollection,
    QAfterFilterCondition
  >
  noteGreaterThanOrEqualTo(String? value, {bool caseSensitive = true}) {
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
    DutyAssignmentCollection,
    DutyAssignmentCollection,
    QAfterFilterCondition
  >
  noteLessThan(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(property: 9, value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<
    DutyAssignmentCollection,
    DutyAssignmentCollection,
    QAfterFilterCondition
  >
  noteLessThanOrEqualTo(String? value, {bool caseSensitive = true}) {
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
    DutyAssignmentCollection,
    DutyAssignmentCollection,
    QAfterFilterCondition
  >
  noteBetween(String? lower, String? upper, {bool caseSensitive = true}) {
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
    DutyAssignmentCollection,
    DutyAssignmentCollection,
    QAfterFilterCondition
  >
  noteStartsWith(String value, {bool caseSensitive = true}) {
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
    DutyAssignmentCollection,
    DutyAssignmentCollection,
    QAfterFilterCondition
  >
  noteEndsWith(String value, {bool caseSensitive = true}) {
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
    DutyAssignmentCollection,
    DutyAssignmentCollection,
    QAfterFilterCondition
  >
  noteContains(String value, {bool caseSensitive = true}) {
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
    DutyAssignmentCollection,
    DutyAssignmentCollection,
    QAfterFilterCondition
  >
  noteMatches(String pattern, {bool caseSensitive = true}) {
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
    DutyAssignmentCollection,
    DutyAssignmentCollection,
    QAfterFilterCondition
  >
  noteIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const EqualCondition(property: 9, value: ''),
      );
    });
  }

  QueryBuilder<
    DutyAssignmentCollection,
    DutyAssignmentCollection,
    QAfterFilterCondition
  >
  noteIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const GreaterCondition(property: 9, value: ''),
      );
    });
  }

  QueryBuilder<
    DutyAssignmentCollection,
    DutyAssignmentCollection,
    QAfterFilterCondition
  >
  swappedWithMemberIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const IsNullCondition(property: 10));
    });
  }

  QueryBuilder<
    DutyAssignmentCollection,
    DutyAssignmentCollection,
    QAfterFilterCondition
  >
  swappedWithMemberIdIsNotNull() {
    return QueryBuilder.apply(not(), (query) {
      return query.addFilterCondition(const IsNullCondition(property: 10));
    });
  }

  QueryBuilder<
    DutyAssignmentCollection,
    DutyAssignmentCollection,
    QAfterFilterCondition
  >
  swappedWithMemberIdEqualTo(String? value, {bool caseSensitive = true}) {
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

  QueryBuilder<
    DutyAssignmentCollection,
    DutyAssignmentCollection,
    QAfterFilterCondition
  >
  swappedWithMemberIdGreaterThan(String? value, {bool caseSensitive = true}) {
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

  QueryBuilder<
    DutyAssignmentCollection,
    DutyAssignmentCollection,
    QAfterFilterCondition
  >
  swappedWithMemberIdGreaterThanOrEqualTo(
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

  QueryBuilder<
    DutyAssignmentCollection,
    DutyAssignmentCollection,
    QAfterFilterCondition
  >
  swappedWithMemberIdLessThan(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(property: 10, value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<
    DutyAssignmentCollection,
    DutyAssignmentCollection,
    QAfterFilterCondition
  >
  swappedWithMemberIdLessThanOrEqualTo(
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

  QueryBuilder<
    DutyAssignmentCollection,
    DutyAssignmentCollection,
    QAfterFilterCondition
  >
  swappedWithMemberIdBetween(
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

  QueryBuilder<
    DutyAssignmentCollection,
    DutyAssignmentCollection,
    QAfterFilterCondition
  >
  swappedWithMemberIdStartsWith(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<
    DutyAssignmentCollection,
    DutyAssignmentCollection,
    QAfterFilterCondition
  >
  swappedWithMemberIdEndsWith(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<
    DutyAssignmentCollection,
    DutyAssignmentCollection,
    QAfterFilterCondition
  >
  swappedWithMemberIdContains(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<
    DutyAssignmentCollection,
    DutyAssignmentCollection,
    QAfterFilterCondition
  >
  swappedWithMemberIdMatches(String pattern, {bool caseSensitive = true}) {
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

  QueryBuilder<
    DutyAssignmentCollection,
    DutyAssignmentCollection,
    QAfterFilterCondition
  >
  swappedWithMemberIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const EqualCondition(property: 10, value: ''),
      );
    });
  }

  QueryBuilder<
    DutyAssignmentCollection,
    DutyAssignmentCollection,
    QAfterFilterCondition
  >
  swappedWithMemberIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const GreaterCondition(property: 10, value: ''),
      );
    });
  }

  QueryBuilder<
    DutyAssignmentCollection,
    DutyAssignmentCollection,
    QAfterFilterCondition
  >
  disputedByIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const IsNullCondition(property: 11));
    });
  }

  QueryBuilder<
    DutyAssignmentCollection,
    DutyAssignmentCollection,
    QAfterFilterCondition
  >
  disputedByIsNotNull() {
    return QueryBuilder.apply(not(), (query) {
      return query.addFilterCondition(const IsNullCondition(property: 11));
    });
  }

  QueryBuilder<
    DutyAssignmentCollection,
    DutyAssignmentCollection,
    QAfterFilterCondition
  >
  disputedByEqualTo(String? value, {bool caseSensitive = true}) {
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
    DutyAssignmentCollection,
    DutyAssignmentCollection,
    QAfterFilterCondition
  >
  disputedByGreaterThan(String? value, {bool caseSensitive = true}) {
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
    DutyAssignmentCollection,
    DutyAssignmentCollection,
    QAfterFilterCondition
  >
  disputedByGreaterThanOrEqualTo(String? value, {bool caseSensitive = true}) {
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
    DutyAssignmentCollection,
    DutyAssignmentCollection,
    QAfterFilterCondition
  >
  disputedByLessThan(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(property: 11, value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<
    DutyAssignmentCollection,
    DutyAssignmentCollection,
    QAfterFilterCondition
  >
  disputedByLessThanOrEqualTo(String? value, {bool caseSensitive = true}) {
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
    DutyAssignmentCollection,
    DutyAssignmentCollection,
    QAfterFilterCondition
  >
  disputedByBetween(String? lower, String? upper, {bool caseSensitive = true}) {
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
    DutyAssignmentCollection,
    DutyAssignmentCollection,
    QAfterFilterCondition
  >
  disputedByStartsWith(String value, {bool caseSensitive = true}) {
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
    DutyAssignmentCollection,
    DutyAssignmentCollection,
    QAfterFilterCondition
  >
  disputedByEndsWith(String value, {bool caseSensitive = true}) {
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
    DutyAssignmentCollection,
    DutyAssignmentCollection,
    QAfterFilterCondition
  >
  disputedByContains(String value, {bool caseSensitive = true}) {
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
    DutyAssignmentCollection,
    DutyAssignmentCollection,
    QAfterFilterCondition
  >
  disputedByMatches(String pattern, {bool caseSensitive = true}) {
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
    DutyAssignmentCollection,
    DutyAssignmentCollection,
    QAfterFilterCondition
  >
  disputedByIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const EqualCondition(property: 11, value: ''),
      );
    });
  }

  QueryBuilder<
    DutyAssignmentCollection,
    DutyAssignmentCollection,
    QAfterFilterCondition
  >
  disputedByIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const GreaterCondition(property: 11, value: ''),
      );
    });
  }

  QueryBuilder<
    DutyAssignmentCollection,
    DutyAssignmentCollection,
    QAfterFilterCondition
  >
  disputePhotoPathIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const IsNullCondition(property: 12));
    });
  }

  QueryBuilder<
    DutyAssignmentCollection,
    DutyAssignmentCollection,
    QAfterFilterCondition
  >
  disputePhotoPathIsNotNull() {
    return QueryBuilder.apply(not(), (query) {
      return query.addFilterCondition(const IsNullCondition(property: 12));
    });
  }

  QueryBuilder<
    DutyAssignmentCollection,
    DutyAssignmentCollection,
    QAfterFilterCondition
  >
  disputePhotoPathEqualTo(String? value, {bool caseSensitive = true}) {
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
    DutyAssignmentCollection,
    DutyAssignmentCollection,
    QAfterFilterCondition
  >
  disputePhotoPathGreaterThan(String? value, {bool caseSensitive = true}) {
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
    DutyAssignmentCollection,
    DutyAssignmentCollection,
    QAfterFilterCondition
  >
  disputePhotoPathGreaterThanOrEqualTo(
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
    DutyAssignmentCollection,
    DutyAssignmentCollection,
    QAfterFilterCondition
  >
  disputePhotoPathLessThan(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(property: 12, value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<
    DutyAssignmentCollection,
    DutyAssignmentCollection,
    QAfterFilterCondition
  >
  disputePhotoPathLessThanOrEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
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
    DutyAssignmentCollection,
    DutyAssignmentCollection,
    QAfterFilterCondition
  >
  disputePhotoPathBetween(
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
    DutyAssignmentCollection,
    DutyAssignmentCollection,
    QAfterFilterCondition
  >
  disputePhotoPathStartsWith(String value, {bool caseSensitive = true}) {
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
    DutyAssignmentCollection,
    DutyAssignmentCollection,
    QAfterFilterCondition
  >
  disputePhotoPathEndsWith(String value, {bool caseSensitive = true}) {
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
    DutyAssignmentCollection,
    DutyAssignmentCollection,
    QAfterFilterCondition
  >
  disputePhotoPathContains(String value, {bool caseSensitive = true}) {
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
    DutyAssignmentCollection,
    DutyAssignmentCollection,
    QAfterFilterCondition
  >
  disputePhotoPathMatches(String pattern, {bool caseSensitive = true}) {
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
    DutyAssignmentCollection,
    DutyAssignmentCollection,
    QAfterFilterCondition
  >
  disputePhotoPathIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const EqualCondition(property: 12, value: ''),
      );
    });
  }

  QueryBuilder<
    DutyAssignmentCollection,
    DutyAssignmentCollection,
    QAfterFilterCondition
  >
  disputePhotoPathIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const GreaterCondition(property: 12, value: ''),
      );
    });
  }

  QueryBuilder<
    DutyAssignmentCollection,
    DutyAssignmentCollection,
    QAfterFilterCondition
  >
  disputeReasonIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const IsNullCondition(property: 13));
    });
  }

  QueryBuilder<
    DutyAssignmentCollection,
    DutyAssignmentCollection,
    QAfterFilterCondition
  >
  disputeReasonIsNotNull() {
    return QueryBuilder.apply(not(), (query) {
      return query.addFilterCondition(const IsNullCondition(property: 13));
    });
  }

  QueryBuilder<
    DutyAssignmentCollection,
    DutyAssignmentCollection,
    QAfterFilterCondition
  >
  disputeReasonEqualTo(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(
          property: 13,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    DutyAssignmentCollection,
    DutyAssignmentCollection,
    QAfterFilterCondition
  >
  disputeReasonGreaterThan(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(
          property: 13,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    DutyAssignmentCollection,
    DutyAssignmentCollection,
    QAfterFilterCondition
  >
  disputeReasonGreaterThanOrEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(
          property: 13,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    DutyAssignmentCollection,
    DutyAssignmentCollection,
    QAfterFilterCondition
  >
  disputeReasonLessThan(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(property: 13, value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<
    DutyAssignmentCollection,
    DutyAssignmentCollection,
    QAfterFilterCondition
  >
  disputeReasonLessThanOrEqualTo(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(
          property: 13,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    DutyAssignmentCollection,
    DutyAssignmentCollection,
    QAfterFilterCondition
  >
  disputeReasonBetween(
    String? lower,
    String? upper, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(
          property: 13,
          lower: lower,
          upper: upper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    DutyAssignmentCollection,
    DutyAssignmentCollection,
    QAfterFilterCondition
  >
  disputeReasonStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        StartsWithCondition(
          property: 13,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    DutyAssignmentCollection,
    DutyAssignmentCollection,
    QAfterFilterCondition
  >
  disputeReasonEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EndsWithCondition(
          property: 13,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    DutyAssignmentCollection,
    DutyAssignmentCollection,
    QAfterFilterCondition
  >
  disputeReasonContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        ContainsCondition(
          property: 13,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    DutyAssignmentCollection,
    DutyAssignmentCollection,
    QAfterFilterCondition
  >
  disputeReasonMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        MatchesCondition(
          property: 13,
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    DutyAssignmentCollection,
    DutyAssignmentCollection,
    QAfterFilterCondition
  >
  disputeReasonIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const EqualCondition(property: 13, value: ''),
      );
    });
  }

  QueryBuilder<
    DutyAssignmentCollection,
    DutyAssignmentCollection,
    QAfterFilterCondition
  >
  disputeReasonIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const GreaterCondition(property: 13, value: ''),
      );
    });
  }

  QueryBuilder<
    DutyAssignmentCollection,
    DutyAssignmentCollection,
    QAfterFilterCondition
  >
  disputedAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const IsNullCondition(property: 14));
    });
  }

  QueryBuilder<
    DutyAssignmentCollection,
    DutyAssignmentCollection,
    QAfterFilterCondition
  >
  disputedAtIsNotNull() {
    return QueryBuilder.apply(not(), (query) {
      return query.addFilterCondition(const IsNullCondition(property: 14));
    });
  }

  QueryBuilder<
    DutyAssignmentCollection,
    DutyAssignmentCollection,
    QAfterFilterCondition
  >
  disputedAtEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(property: 14, value: value),
      );
    });
  }

  QueryBuilder<
    DutyAssignmentCollection,
    DutyAssignmentCollection,
    QAfterFilterCondition
  >
  disputedAtGreaterThan(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(property: 14, value: value),
      );
    });
  }

  QueryBuilder<
    DutyAssignmentCollection,
    DutyAssignmentCollection,
    QAfterFilterCondition
  >
  disputedAtGreaterThanOrEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(property: 14, value: value),
      );
    });
  }

  QueryBuilder<
    DutyAssignmentCollection,
    DutyAssignmentCollection,
    QAfterFilterCondition
  >
  disputedAtLessThan(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(property: 14, value: value),
      );
    });
  }

  QueryBuilder<
    DutyAssignmentCollection,
    DutyAssignmentCollection,
    QAfterFilterCondition
  >
  disputedAtLessThanOrEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(property: 14, value: value),
      );
    });
  }

  QueryBuilder<
    DutyAssignmentCollection,
    DutyAssignmentCollection,
    QAfterFilterCondition
  >
  disputedAtBetween(DateTime? lower, DateTime? upper) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(property: 14, lower: lower, upper: upper),
      );
    });
  }

  QueryBuilder<
    DutyAssignmentCollection,
    DutyAssignmentCollection,
    QAfterFilterCondition
  >
  adminNotesIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const IsNullCondition(property: 15));
    });
  }

  QueryBuilder<
    DutyAssignmentCollection,
    DutyAssignmentCollection,
    QAfterFilterCondition
  >
  adminNotesIsNotNull() {
    return QueryBuilder.apply(not(), (query) {
      return query.addFilterCondition(const IsNullCondition(property: 15));
    });
  }

  QueryBuilder<
    DutyAssignmentCollection,
    DutyAssignmentCollection,
    QAfterFilterCondition
  >
  adminNotesEqualTo(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(
          property: 15,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    DutyAssignmentCollection,
    DutyAssignmentCollection,
    QAfterFilterCondition
  >
  adminNotesGreaterThan(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(
          property: 15,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    DutyAssignmentCollection,
    DutyAssignmentCollection,
    QAfterFilterCondition
  >
  adminNotesGreaterThanOrEqualTo(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(
          property: 15,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    DutyAssignmentCollection,
    DutyAssignmentCollection,
    QAfterFilterCondition
  >
  adminNotesLessThan(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(property: 15, value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<
    DutyAssignmentCollection,
    DutyAssignmentCollection,
    QAfterFilterCondition
  >
  adminNotesLessThanOrEqualTo(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(
          property: 15,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    DutyAssignmentCollection,
    DutyAssignmentCollection,
    QAfterFilterCondition
  >
  adminNotesBetween(String? lower, String? upper, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(
          property: 15,
          lower: lower,
          upper: upper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    DutyAssignmentCollection,
    DutyAssignmentCollection,
    QAfterFilterCondition
  >
  adminNotesStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        StartsWithCondition(
          property: 15,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    DutyAssignmentCollection,
    DutyAssignmentCollection,
    QAfterFilterCondition
  >
  adminNotesEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EndsWithCondition(
          property: 15,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    DutyAssignmentCollection,
    DutyAssignmentCollection,
    QAfterFilterCondition
  >
  adminNotesContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        ContainsCondition(
          property: 15,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    DutyAssignmentCollection,
    DutyAssignmentCollection,
    QAfterFilterCondition
  >
  adminNotesMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        MatchesCondition(
          property: 15,
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    DutyAssignmentCollection,
    DutyAssignmentCollection,
    QAfterFilterCondition
  >
  adminNotesIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const EqualCondition(property: 15, value: ''),
      );
    });
  }

  QueryBuilder<
    DutyAssignmentCollection,
    DutyAssignmentCollection,
    QAfterFilterCondition
  >
  adminNotesIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const GreaterCondition(property: 15, value: ''),
      );
    });
  }

  QueryBuilder<
    DutyAssignmentCollection,
    DutyAssignmentCollection,
    QAfterFilterCondition
  >
  reviewedByIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const IsNullCondition(property: 16));
    });
  }

  QueryBuilder<
    DutyAssignmentCollection,
    DutyAssignmentCollection,
    QAfterFilterCondition
  >
  reviewedByIsNotNull() {
    return QueryBuilder.apply(not(), (query) {
      return query.addFilterCondition(const IsNullCondition(property: 16));
    });
  }

  QueryBuilder<
    DutyAssignmentCollection,
    DutyAssignmentCollection,
    QAfterFilterCondition
  >
  reviewedByEqualTo(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(
          property: 16,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    DutyAssignmentCollection,
    DutyAssignmentCollection,
    QAfterFilterCondition
  >
  reviewedByGreaterThan(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(
          property: 16,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    DutyAssignmentCollection,
    DutyAssignmentCollection,
    QAfterFilterCondition
  >
  reviewedByGreaterThanOrEqualTo(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(
          property: 16,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    DutyAssignmentCollection,
    DutyAssignmentCollection,
    QAfterFilterCondition
  >
  reviewedByLessThan(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(property: 16, value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<
    DutyAssignmentCollection,
    DutyAssignmentCollection,
    QAfterFilterCondition
  >
  reviewedByLessThanOrEqualTo(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(
          property: 16,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    DutyAssignmentCollection,
    DutyAssignmentCollection,
    QAfterFilterCondition
  >
  reviewedByBetween(String? lower, String? upper, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(
          property: 16,
          lower: lower,
          upper: upper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    DutyAssignmentCollection,
    DutyAssignmentCollection,
    QAfterFilterCondition
  >
  reviewedByStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        StartsWithCondition(
          property: 16,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    DutyAssignmentCollection,
    DutyAssignmentCollection,
    QAfterFilterCondition
  >
  reviewedByEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EndsWithCondition(
          property: 16,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    DutyAssignmentCollection,
    DutyAssignmentCollection,
    QAfterFilterCondition
  >
  reviewedByContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        ContainsCondition(
          property: 16,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    DutyAssignmentCollection,
    DutyAssignmentCollection,
    QAfterFilterCondition
  >
  reviewedByMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        MatchesCondition(
          property: 16,
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    DutyAssignmentCollection,
    DutyAssignmentCollection,
    QAfterFilterCondition
  >
  reviewedByIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const EqualCondition(property: 16, value: ''),
      );
    });
  }

  QueryBuilder<
    DutyAssignmentCollection,
    DutyAssignmentCollection,
    QAfterFilterCondition
  >
  reviewedByIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const GreaterCondition(property: 16, value: ''),
      );
    });
  }

  QueryBuilder<
    DutyAssignmentCollection,
    DutyAssignmentCollection,
    QAfterFilterCondition
  >
  reviewedAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const IsNullCondition(property: 17));
    });
  }

  QueryBuilder<
    DutyAssignmentCollection,
    DutyAssignmentCollection,
    QAfterFilterCondition
  >
  reviewedAtIsNotNull() {
    return QueryBuilder.apply(not(), (query) {
      return query.addFilterCondition(const IsNullCondition(property: 17));
    });
  }

  QueryBuilder<
    DutyAssignmentCollection,
    DutyAssignmentCollection,
    QAfterFilterCondition
  >
  reviewedAtEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(property: 17, value: value),
      );
    });
  }

  QueryBuilder<
    DutyAssignmentCollection,
    DutyAssignmentCollection,
    QAfterFilterCondition
  >
  reviewedAtGreaterThan(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(property: 17, value: value),
      );
    });
  }

  QueryBuilder<
    DutyAssignmentCollection,
    DutyAssignmentCollection,
    QAfterFilterCondition
  >
  reviewedAtGreaterThanOrEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(property: 17, value: value),
      );
    });
  }

  QueryBuilder<
    DutyAssignmentCollection,
    DutyAssignmentCollection,
    QAfterFilterCondition
  >
  reviewedAtLessThan(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(property: 17, value: value),
      );
    });
  }

  QueryBuilder<
    DutyAssignmentCollection,
    DutyAssignmentCollection,
    QAfterFilterCondition
  >
  reviewedAtLessThanOrEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(property: 17, value: value),
      );
    });
  }

  QueryBuilder<
    DutyAssignmentCollection,
    DutyAssignmentCollection,
    QAfterFilterCondition
  >
  reviewedAtBetween(DateTime? lower, DateTime? upper) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(property: 17, lower: lower, upper: upper),
      );
    });
  }

  QueryBuilder<
    DutyAssignmentCollection,
    DutyAssignmentCollection,
    QAfterFilterCondition
  >
  completedByMemberIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const IsNullCondition(property: 18));
    });
  }

  QueryBuilder<
    DutyAssignmentCollection,
    DutyAssignmentCollection,
    QAfterFilterCondition
  >
  completedByMemberIdIsNotNull() {
    return QueryBuilder.apply(not(), (query) {
      return query.addFilterCondition(const IsNullCondition(property: 18));
    });
  }

  QueryBuilder<
    DutyAssignmentCollection,
    DutyAssignmentCollection,
    QAfterFilterCondition
  >
  completedByMemberIdEqualTo(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(
          property: 18,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    DutyAssignmentCollection,
    DutyAssignmentCollection,
    QAfterFilterCondition
  >
  completedByMemberIdGreaterThan(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(
          property: 18,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    DutyAssignmentCollection,
    DutyAssignmentCollection,
    QAfterFilterCondition
  >
  completedByMemberIdGreaterThanOrEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(
          property: 18,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    DutyAssignmentCollection,
    DutyAssignmentCollection,
    QAfterFilterCondition
  >
  completedByMemberIdLessThan(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(property: 18, value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<
    DutyAssignmentCollection,
    DutyAssignmentCollection,
    QAfterFilterCondition
  >
  completedByMemberIdLessThanOrEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(
          property: 18,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    DutyAssignmentCollection,
    DutyAssignmentCollection,
    QAfterFilterCondition
  >
  completedByMemberIdBetween(
    String? lower,
    String? upper, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(
          property: 18,
          lower: lower,
          upper: upper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    DutyAssignmentCollection,
    DutyAssignmentCollection,
    QAfterFilterCondition
  >
  completedByMemberIdStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        StartsWithCondition(
          property: 18,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    DutyAssignmentCollection,
    DutyAssignmentCollection,
    QAfterFilterCondition
  >
  completedByMemberIdEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EndsWithCondition(
          property: 18,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    DutyAssignmentCollection,
    DutyAssignmentCollection,
    QAfterFilterCondition
  >
  completedByMemberIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        ContainsCondition(
          property: 18,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    DutyAssignmentCollection,
    DutyAssignmentCollection,
    QAfterFilterCondition
  >
  completedByMemberIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        MatchesCondition(
          property: 18,
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    DutyAssignmentCollection,
    DutyAssignmentCollection,
    QAfterFilterCondition
  >
  completedByMemberIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const EqualCondition(property: 18, value: ''),
      );
    });
  }

  QueryBuilder<
    DutyAssignmentCollection,
    DutyAssignmentCollection,
    QAfterFilterCondition
  >
  completedByMemberIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const GreaterCondition(property: 18, value: ''),
      );
    });
  }
}

extension DutyAssignmentCollectionQueryObject
    on
        QueryBuilder<
          DutyAssignmentCollection,
          DutyAssignmentCollection,
          QFilterCondition
        > {}

extension DutyAssignmentCollectionQuerySortBy
    on
        QueryBuilder<
          DutyAssignmentCollection,
          DutyAssignmentCollection,
          QSortBy
        > {
  QueryBuilder<DutyAssignmentCollection, DutyAssignmentCollection, QAfterSortBy>
  sortById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(0);
    });
  }

  QueryBuilder<DutyAssignmentCollection, DutyAssignmentCollection, QAfterSortBy>
  sortByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(0, sort: Sort.desc);
    });
  }

  QueryBuilder<DutyAssignmentCollection, DutyAssignmentCollection, QAfterSortBy>
  sortByAssignmentId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(1, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DutyAssignmentCollection, DutyAssignmentCollection, QAfterSortBy>
  sortByAssignmentIdDesc({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(1, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DutyAssignmentCollection, DutyAssignmentCollection, QAfterSortBy>
  sortByMessId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(2, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DutyAssignmentCollection, DutyAssignmentCollection, QAfterSortBy>
  sortByMessIdDesc({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(2, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DutyAssignmentCollection, DutyAssignmentCollection, QAfterSortBy>
  sortByMemberId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(3, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DutyAssignmentCollection, DutyAssignmentCollection, QAfterSortBy>
  sortByMemberIdDesc({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(3, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DutyAssignmentCollection, DutyAssignmentCollection, QAfterSortBy>
  sortByTypeIndex() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(4);
    });
  }

  QueryBuilder<DutyAssignmentCollection, DutyAssignmentCollection, QAfterSortBy>
  sortByTypeIndexDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(4, sort: Sort.desc);
    });
  }

  QueryBuilder<DutyAssignmentCollection, DutyAssignmentCollection, QAfterSortBy>
  sortByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(5);
    });
  }

  QueryBuilder<DutyAssignmentCollection, DutyAssignmentCollection, QAfterSortBy>
  sortByDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(5, sort: Sort.desc);
    });
  }

  QueryBuilder<DutyAssignmentCollection, DutyAssignmentCollection, QAfterSortBy>
  sortByStatusIndex() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(6);
    });
  }

  QueryBuilder<DutyAssignmentCollection, DutyAssignmentCollection, QAfterSortBy>
  sortByStatusIndexDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(6, sort: Sort.desc);
    });
  }

  QueryBuilder<DutyAssignmentCollection, DutyAssignmentCollection, QAfterSortBy>
  sortByCompletedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(7);
    });
  }

  QueryBuilder<DutyAssignmentCollection, DutyAssignmentCollection, QAfterSortBy>
  sortByCompletedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(7, sort: Sort.desc);
    });
  }

  QueryBuilder<DutyAssignmentCollection, DutyAssignmentCollection, QAfterSortBy>
  sortByProofImagePath({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(8, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DutyAssignmentCollection, DutyAssignmentCollection, QAfterSortBy>
  sortByProofImagePathDesc({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(8, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DutyAssignmentCollection, DutyAssignmentCollection, QAfterSortBy>
  sortByNote({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(9, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DutyAssignmentCollection, DutyAssignmentCollection, QAfterSortBy>
  sortByNoteDesc({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(9, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DutyAssignmentCollection, DutyAssignmentCollection, QAfterSortBy>
  sortBySwappedWithMemberId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(10, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DutyAssignmentCollection, DutyAssignmentCollection, QAfterSortBy>
  sortBySwappedWithMemberIdDesc({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(10, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DutyAssignmentCollection, DutyAssignmentCollection, QAfterSortBy>
  sortByDisputedBy({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(11, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DutyAssignmentCollection, DutyAssignmentCollection, QAfterSortBy>
  sortByDisputedByDesc({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(11, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DutyAssignmentCollection, DutyAssignmentCollection, QAfterSortBy>
  sortByDisputePhotoPath({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(12, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DutyAssignmentCollection, DutyAssignmentCollection, QAfterSortBy>
  sortByDisputePhotoPathDesc({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(12, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DutyAssignmentCollection, DutyAssignmentCollection, QAfterSortBy>
  sortByDisputeReason({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(13, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DutyAssignmentCollection, DutyAssignmentCollection, QAfterSortBy>
  sortByDisputeReasonDesc({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(13, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DutyAssignmentCollection, DutyAssignmentCollection, QAfterSortBy>
  sortByDisputedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(14);
    });
  }

  QueryBuilder<DutyAssignmentCollection, DutyAssignmentCollection, QAfterSortBy>
  sortByDisputedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(14, sort: Sort.desc);
    });
  }

  QueryBuilder<DutyAssignmentCollection, DutyAssignmentCollection, QAfterSortBy>
  sortByAdminNotes({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(15, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DutyAssignmentCollection, DutyAssignmentCollection, QAfterSortBy>
  sortByAdminNotesDesc({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(15, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DutyAssignmentCollection, DutyAssignmentCollection, QAfterSortBy>
  sortByReviewedBy({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(16, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DutyAssignmentCollection, DutyAssignmentCollection, QAfterSortBy>
  sortByReviewedByDesc({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(16, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DutyAssignmentCollection, DutyAssignmentCollection, QAfterSortBy>
  sortByReviewedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(17);
    });
  }

  QueryBuilder<DutyAssignmentCollection, DutyAssignmentCollection, QAfterSortBy>
  sortByReviewedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(17, sort: Sort.desc);
    });
  }

  QueryBuilder<DutyAssignmentCollection, DutyAssignmentCollection, QAfterSortBy>
  sortByCompletedByMemberId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(18, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DutyAssignmentCollection, DutyAssignmentCollection, QAfterSortBy>
  sortByCompletedByMemberIdDesc({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(18, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }
}

extension DutyAssignmentCollectionQuerySortThenBy
    on
        QueryBuilder<
          DutyAssignmentCollection,
          DutyAssignmentCollection,
          QSortThenBy
        > {
  QueryBuilder<DutyAssignmentCollection, DutyAssignmentCollection, QAfterSortBy>
  thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(0);
    });
  }

  QueryBuilder<DutyAssignmentCollection, DutyAssignmentCollection, QAfterSortBy>
  thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(0, sort: Sort.desc);
    });
  }

  QueryBuilder<DutyAssignmentCollection, DutyAssignmentCollection, QAfterSortBy>
  thenByAssignmentId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(1, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DutyAssignmentCollection, DutyAssignmentCollection, QAfterSortBy>
  thenByAssignmentIdDesc({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(1, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DutyAssignmentCollection, DutyAssignmentCollection, QAfterSortBy>
  thenByMessId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(2, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DutyAssignmentCollection, DutyAssignmentCollection, QAfterSortBy>
  thenByMessIdDesc({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(2, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DutyAssignmentCollection, DutyAssignmentCollection, QAfterSortBy>
  thenByMemberId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(3, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DutyAssignmentCollection, DutyAssignmentCollection, QAfterSortBy>
  thenByMemberIdDesc({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(3, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DutyAssignmentCollection, DutyAssignmentCollection, QAfterSortBy>
  thenByTypeIndex() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(4);
    });
  }

  QueryBuilder<DutyAssignmentCollection, DutyAssignmentCollection, QAfterSortBy>
  thenByTypeIndexDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(4, sort: Sort.desc);
    });
  }

  QueryBuilder<DutyAssignmentCollection, DutyAssignmentCollection, QAfterSortBy>
  thenByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(5);
    });
  }

  QueryBuilder<DutyAssignmentCollection, DutyAssignmentCollection, QAfterSortBy>
  thenByDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(5, sort: Sort.desc);
    });
  }

  QueryBuilder<DutyAssignmentCollection, DutyAssignmentCollection, QAfterSortBy>
  thenByStatusIndex() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(6);
    });
  }

  QueryBuilder<DutyAssignmentCollection, DutyAssignmentCollection, QAfterSortBy>
  thenByStatusIndexDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(6, sort: Sort.desc);
    });
  }

  QueryBuilder<DutyAssignmentCollection, DutyAssignmentCollection, QAfterSortBy>
  thenByCompletedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(7);
    });
  }

  QueryBuilder<DutyAssignmentCollection, DutyAssignmentCollection, QAfterSortBy>
  thenByCompletedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(7, sort: Sort.desc);
    });
  }

  QueryBuilder<DutyAssignmentCollection, DutyAssignmentCollection, QAfterSortBy>
  thenByProofImagePath({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(8, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DutyAssignmentCollection, DutyAssignmentCollection, QAfterSortBy>
  thenByProofImagePathDesc({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(8, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DutyAssignmentCollection, DutyAssignmentCollection, QAfterSortBy>
  thenByNote({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(9, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DutyAssignmentCollection, DutyAssignmentCollection, QAfterSortBy>
  thenByNoteDesc({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(9, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DutyAssignmentCollection, DutyAssignmentCollection, QAfterSortBy>
  thenBySwappedWithMemberId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(10, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DutyAssignmentCollection, DutyAssignmentCollection, QAfterSortBy>
  thenBySwappedWithMemberIdDesc({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(10, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DutyAssignmentCollection, DutyAssignmentCollection, QAfterSortBy>
  thenByDisputedBy({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(11, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DutyAssignmentCollection, DutyAssignmentCollection, QAfterSortBy>
  thenByDisputedByDesc({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(11, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DutyAssignmentCollection, DutyAssignmentCollection, QAfterSortBy>
  thenByDisputePhotoPath({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(12, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DutyAssignmentCollection, DutyAssignmentCollection, QAfterSortBy>
  thenByDisputePhotoPathDesc({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(12, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DutyAssignmentCollection, DutyAssignmentCollection, QAfterSortBy>
  thenByDisputeReason({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(13, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DutyAssignmentCollection, DutyAssignmentCollection, QAfterSortBy>
  thenByDisputeReasonDesc({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(13, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DutyAssignmentCollection, DutyAssignmentCollection, QAfterSortBy>
  thenByDisputedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(14);
    });
  }

  QueryBuilder<DutyAssignmentCollection, DutyAssignmentCollection, QAfterSortBy>
  thenByDisputedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(14, sort: Sort.desc);
    });
  }

  QueryBuilder<DutyAssignmentCollection, DutyAssignmentCollection, QAfterSortBy>
  thenByAdminNotes({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(15, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DutyAssignmentCollection, DutyAssignmentCollection, QAfterSortBy>
  thenByAdminNotesDesc({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(15, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DutyAssignmentCollection, DutyAssignmentCollection, QAfterSortBy>
  thenByReviewedBy({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(16, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DutyAssignmentCollection, DutyAssignmentCollection, QAfterSortBy>
  thenByReviewedByDesc({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(16, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DutyAssignmentCollection, DutyAssignmentCollection, QAfterSortBy>
  thenByReviewedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(17);
    });
  }

  QueryBuilder<DutyAssignmentCollection, DutyAssignmentCollection, QAfterSortBy>
  thenByReviewedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(17, sort: Sort.desc);
    });
  }

  QueryBuilder<DutyAssignmentCollection, DutyAssignmentCollection, QAfterSortBy>
  thenByCompletedByMemberId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(18, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DutyAssignmentCollection, DutyAssignmentCollection, QAfterSortBy>
  thenByCompletedByMemberIdDesc({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(18, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }
}

extension DutyAssignmentCollectionQueryWhereDistinct
    on
        QueryBuilder<
          DutyAssignmentCollection,
          DutyAssignmentCollection,
          QDistinct
        > {
  QueryBuilder<
    DutyAssignmentCollection,
    DutyAssignmentCollection,
    QAfterDistinct
  >
  distinctByAssignmentId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(1, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<
    DutyAssignmentCollection,
    DutyAssignmentCollection,
    QAfterDistinct
  >
  distinctByMessId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(2, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<
    DutyAssignmentCollection,
    DutyAssignmentCollection,
    QAfterDistinct
  >
  distinctByMemberId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(3, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<
    DutyAssignmentCollection,
    DutyAssignmentCollection,
    QAfterDistinct
  >
  distinctByTypeIndex() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(4);
    });
  }

  QueryBuilder<
    DutyAssignmentCollection,
    DutyAssignmentCollection,
    QAfterDistinct
  >
  distinctByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(5);
    });
  }

  QueryBuilder<
    DutyAssignmentCollection,
    DutyAssignmentCollection,
    QAfterDistinct
  >
  distinctByStatusIndex() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(6);
    });
  }

  QueryBuilder<
    DutyAssignmentCollection,
    DutyAssignmentCollection,
    QAfterDistinct
  >
  distinctByCompletedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(7);
    });
  }

  QueryBuilder<
    DutyAssignmentCollection,
    DutyAssignmentCollection,
    QAfterDistinct
  >
  distinctByProofImagePath({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(8, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<
    DutyAssignmentCollection,
    DutyAssignmentCollection,
    QAfterDistinct
  >
  distinctByNote({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(9, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<
    DutyAssignmentCollection,
    DutyAssignmentCollection,
    QAfterDistinct
  >
  distinctBySwappedWithMemberId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(10, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<
    DutyAssignmentCollection,
    DutyAssignmentCollection,
    QAfterDistinct
  >
  distinctByDisputedBy({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(11, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<
    DutyAssignmentCollection,
    DutyAssignmentCollection,
    QAfterDistinct
  >
  distinctByDisputePhotoPath({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(12, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<
    DutyAssignmentCollection,
    DutyAssignmentCollection,
    QAfterDistinct
  >
  distinctByDisputeReason({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(13, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<
    DutyAssignmentCollection,
    DutyAssignmentCollection,
    QAfterDistinct
  >
  distinctByDisputedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(14);
    });
  }

  QueryBuilder<
    DutyAssignmentCollection,
    DutyAssignmentCollection,
    QAfterDistinct
  >
  distinctByAdminNotes({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(15, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<
    DutyAssignmentCollection,
    DutyAssignmentCollection,
    QAfterDistinct
  >
  distinctByReviewedBy({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(16, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<
    DutyAssignmentCollection,
    DutyAssignmentCollection,
    QAfterDistinct
  >
  distinctByReviewedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(17);
    });
  }

  QueryBuilder<
    DutyAssignmentCollection,
    DutyAssignmentCollection,
    QAfterDistinct
  >
  distinctByCompletedByMemberId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(18, caseSensitive: caseSensitive);
    });
  }
}

extension DutyAssignmentCollectionQueryProperty1
    on
        QueryBuilder<
          DutyAssignmentCollection,
          DutyAssignmentCollection,
          QProperty
        > {
  QueryBuilder<DutyAssignmentCollection, int, QAfterProperty> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(0);
    });
  }

  QueryBuilder<DutyAssignmentCollection, String, QAfterProperty>
  assignmentIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(1);
    });
  }

  QueryBuilder<DutyAssignmentCollection, String, QAfterProperty>
  messIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(2);
    });
  }

  QueryBuilder<DutyAssignmentCollection, String, QAfterProperty>
  memberIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(3);
    });
  }

  QueryBuilder<DutyAssignmentCollection, int, QAfterProperty>
  typeIndexProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(4);
    });
  }

  QueryBuilder<DutyAssignmentCollection, DateTime, QAfterProperty>
  dateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(5);
    });
  }

  QueryBuilder<DutyAssignmentCollection, int, QAfterProperty>
  statusIndexProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(6);
    });
  }

  QueryBuilder<DutyAssignmentCollection, DateTime?, QAfterProperty>
  completedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(7);
    });
  }

  QueryBuilder<DutyAssignmentCollection, String?, QAfterProperty>
  proofImagePathProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(8);
    });
  }

  QueryBuilder<DutyAssignmentCollection, String?, QAfterProperty>
  noteProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(9);
    });
  }

  QueryBuilder<DutyAssignmentCollection, String?, QAfterProperty>
  swappedWithMemberIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(10);
    });
  }

  QueryBuilder<DutyAssignmentCollection, String?, QAfterProperty>
  disputedByProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(11);
    });
  }

  QueryBuilder<DutyAssignmentCollection, String?, QAfterProperty>
  disputePhotoPathProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(12);
    });
  }

  QueryBuilder<DutyAssignmentCollection, String?, QAfterProperty>
  disputeReasonProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(13);
    });
  }

  QueryBuilder<DutyAssignmentCollection, DateTime?, QAfterProperty>
  disputedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(14);
    });
  }

  QueryBuilder<DutyAssignmentCollection, String?, QAfterProperty>
  adminNotesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(15);
    });
  }

  QueryBuilder<DutyAssignmentCollection, String?, QAfterProperty>
  reviewedByProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(16);
    });
  }

  QueryBuilder<DutyAssignmentCollection, DateTime?, QAfterProperty>
  reviewedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(17);
    });
  }

  QueryBuilder<DutyAssignmentCollection, String?, QAfterProperty>
  completedByMemberIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(18);
    });
  }
}

extension DutyAssignmentCollectionQueryProperty2<R>
    on QueryBuilder<DutyAssignmentCollection, R, QAfterProperty> {
  QueryBuilder<DutyAssignmentCollection, (R, int), QAfterProperty>
  idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(0);
    });
  }

  QueryBuilder<DutyAssignmentCollection, (R, String), QAfterProperty>
  assignmentIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(1);
    });
  }

  QueryBuilder<DutyAssignmentCollection, (R, String), QAfterProperty>
  messIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(2);
    });
  }

  QueryBuilder<DutyAssignmentCollection, (R, String), QAfterProperty>
  memberIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(3);
    });
  }

  QueryBuilder<DutyAssignmentCollection, (R, int), QAfterProperty>
  typeIndexProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(4);
    });
  }

  QueryBuilder<DutyAssignmentCollection, (R, DateTime), QAfterProperty>
  dateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(5);
    });
  }

  QueryBuilder<DutyAssignmentCollection, (R, int), QAfterProperty>
  statusIndexProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(6);
    });
  }

  QueryBuilder<DutyAssignmentCollection, (R, DateTime?), QAfterProperty>
  completedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(7);
    });
  }

  QueryBuilder<DutyAssignmentCollection, (R, String?), QAfterProperty>
  proofImagePathProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(8);
    });
  }

  QueryBuilder<DutyAssignmentCollection, (R, String?), QAfterProperty>
  noteProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(9);
    });
  }

  QueryBuilder<DutyAssignmentCollection, (R, String?), QAfterProperty>
  swappedWithMemberIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(10);
    });
  }

  QueryBuilder<DutyAssignmentCollection, (R, String?), QAfterProperty>
  disputedByProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(11);
    });
  }

  QueryBuilder<DutyAssignmentCollection, (R, String?), QAfterProperty>
  disputePhotoPathProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(12);
    });
  }

  QueryBuilder<DutyAssignmentCollection, (R, String?), QAfterProperty>
  disputeReasonProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(13);
    });
  }

  QueryBuilder<DutyAssignmentCollection, (R, DateTime?), QAfterProperty>
  disputedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(14);
    });
  }

  QueryBuilder<DutyAssignmentCollection, (R, String?), QAfterProperty>
  adminNotesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(15);
    });
  }

  QueryBuilder<DutyAssignmentCollection, (R, String?), QAfterProperty>
  reviewedByProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(16);
    });
  }

  QueryBuilder<DutyAssignmentCollection, (R, DateTime?), QAfterProperty>
  reviewedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(17);
    });
  }

  QueryBuilder<DutyAssignmentCollection, (R, String?), QAfterProperty>
  completedByMemberIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(18);
    });
  }
}

extension DutyAssignmentCollectionQueryProperty3<R1, R2>
    on QueryBuilder<DutyAssignmentCollection, (R1, R2), QAfterProperty> {
  QueryBuilder<DutyAssignmentCollection, (R1, R2, int), QOperations>
  idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(0);
    });
  }

  QueryBuilder<DutyAssignmentCollection, (R1, R2, String), QOperations>
  assignmentIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(1);
    });
  }

  QueryBuilder<DutyAssignmentCollection, (R1, R2, String), QOperations>
  messIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(2);
    });
  }

  QueryBuilder<DutyAssignmentCollection, (R1, R2, String), QOperations>
  memberIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(3);
    });
  }

  QueryBuilder<DutyAssignmentCollection, (R1, R2, int), QOperations>
  typeIndexProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(4);
    });
  }

  QueryBuilder<DutyAssignmentCollection, (R1, R2, DateTime), QOperations>
  dateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(5);
    });
  }

  QueryBuilder<DutyAssignmentCollection, (R1, R2, int), QOperations>
  statusIndexProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(6);
    });
  }

  QueryBuilder<DutyAssignmentCollection, (R1, R2, DateTime?), QOperations>
  completedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(7);
    });
  }

  QueryBuilder<DutyAssignmentCollection, (R1, R2, String?), QOperations>
  proofImagePathProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(8);
    });
  }

  QueryBuilder<DutyAssignmentCollection, (R1, R2, String?), QOperations>
  noteProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(9);
    });
  }

  QueryBuilder<DutyAssignmentCollection, (R1, R2, String?), QOperations>
  swappedWithMemberIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(10);
    });
  }

  QueryBuilder<DutyAssignmentCollection, (R1, R2, String?), QOperations>
  disputedByProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(11);
    });
  }

  QueryBuilder<DutyAssignmentCollection, (R1, R2, String?), QOperations>
  disputePhotoPathProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(12);
    });
  }

  QueryBuilder<DutyAssignmentCollection, (R1, R2, String?), QOperations>
  disputeReasonProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(13);
    });
  }

  QueryBuilder<DutyAssignmentCollection, (R1, R2, DateTime?), QOperations>
  disputedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(14);
    });
  }

  QueryBuilder<DutyAssignmentCollection, (R1, R2, String?), QOperations>
  adminNotesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(15);
    });
  }

  QueryBuilder<DutyAssignmentCollection, (R1, R2, String?), QOperations>
  reviewedByProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(16);
    });
  }

  QueryBuilder<DutyAssignmentCollection, (R1, R2, DateTime?), QOperations>
  reviewedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(17);
    });
  }

  QueryBuilder<DutyAssignmentCollection, (R1, R2, String?), QOperations>
  completedByMemberIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(18);
    });
  }
}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, invalid_use_of_protected_member, lines_longer_than_80_chars, constant_identifier_names, avoid_js_rounded_ints, no_leading_underscores_for_local_identifiers, require_trailing_commas, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_in_if_null_operators, library_private_types_in_public_api, prefer_const_constructors
// ignore_for_file: type=lint

extension GetDutyScheduleCollectionCollection on Isar {
  IsarCollection<int, DutyScheduleCollection> get dutyScheduleCollections =>
      this.collection();
}

final DutyScheduleCollectionSchema = IsarGeneratedSchema(
  schema: IsarSchema(
    name: 'DutyScheduleCollection',
    idName: 'id',
    embedded: false,
    properties: [
      IsarPropertySchema(name: 'scheduleId', type: IsarType.string),
      IsarPropertySchema(name: 'messId', type: IsarType.string),
      IsarPropertySchema(name: 'typeIndex', type: IsarType.long),
      IsarPropertySchema(name: 'rotationOrderJson', type: IsarType.string),
      IsarPropertySchema(name: 'rotationIntervalDays', type: IsarType.long),
      IsarPropertySchema(name: 'lastRotatedAt', type: IsarType.dateTime),
      IsarPropertySchema(name: 'isActive', type: IsarType.bool),
    ],
    indexes: [
      IsarIndexSchema(
        name: 'scheduleId',
        properties: ["scheduleId"],
        unique: false,
        hash: false,
      ),
    ],
  ),
  converter: IsarObjectConverter<int, DutyScheduleCollection>(
    serialize: serializeDutyScheduleCollection,
    deserialize: deserializeDutyScheduleCollection,
    deserializeProperty: deserializeDutyScheduleCollectionProp,
  ),
  getEmbeddedSchemas: () => [],
);

@isarProtected
int serializeDutyScheduleCollection(
  IsarWriter writer,
  DutyScheduleCollection object,
) {
  IsarCore.writeString(writer, 1, object.scheduleId);
  IsarCore.writeString(writer, 2, object.messId);
  IsarCore.writeLong(writer, 3, object.typeIndex);
  IsarCore.writeString(writer, 4, object.rotationOrderJson);
  IsarCore.writeLong(writer, 5, object.rotationIntervalDays);
  IsarCore.writeLong(
    writer,
    6,
    object.lastRotatedAt?.toUtc().microsecondsSinceEpoch ??
        -9223372036854775808,
  );
  IsarCore.writeBool(writer, 7, value: object.isActive);
  return object.id;
}

@isarProtected
DutyScheduleCollection deserializeDutyScheduleCollection(IsarReader reader) {
  final object = DutyScheduleCollection();
  object.id = IsarCore.readId(reader);
  object.scheduleId = IsarCore.readString(reader, 1) ?? '';
  object.messId = IsarCore.readString(reader, 2) ?? '';
  object.typeIndex = IsarCore.readLong(reader, 3);
  object.rotationOrderJson = IsarCore.readString(reader, 4) ?? '';
  object.rotationIntervalDays = IsarCore.readLong(reader, 5);
  {
    final value = IsarCore.readLong(reader, 6);
    if (value == -9223372036854775808) {
      object.lastRotatedAt = null;
    } else {
      object.lastRotatedAt = DateTime.fromMicrosecondsSinceEpoch(
        value,
        isUtc: true,
      ).toLocal();
    }
  }
  object.isActive = IsarCore.readBool(reader, 7);
  return object;
}

@isarProtected
dynamic deserializeDutyScheduleCollectionProp(IsarReader reader, int property) {
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
      return IsarCore.readString(reader, 4) ?? '';
    case 5:
      return IsarCore.readLong(reader, 5);
    case 6:
      {
        final value = IsarCore.readLong(reader, 6);
        if (value == -9223372036854775808) {
          return null;
        } else {
          return DateTime.fromMicrosecondsSinceEpoch(
            value,
            isUtc: true,
          ).toLocal();
        }
      }
    case 7:
      return IsarCore.readBool(reader, 7);
    default:
      throw ArgumentError('Unknown property: $property');
  }
}

sealed class _DutyScheduleCollectionUpdate {
  bool call({
    required int id,
    String? scheduleId,
    String? messId,
    int? typeIndex,
    String? rotationOrderJson,
    int? rotationIntervalDays,
    DateTime? lastRotatedAt,
    bool? isActive,
  });
}

class _DutyScheduleCollectionUpdateImpl
    implements _DutyScheduleCollectionUpdate {
  const _DutyScheduleCollectionUpdateImpl(this.collection);

  final IsarCollection<int, DutyScheduleCollection> collection;

  @override
  bool call({
    required int id,
    Object? scheduleId = ignore,
    Object? messId = ignore,
    Object? typeIndex = ignore,
    Object? rotationOrderJson = ignore,
    Object? rotationIntervalDays = ignore,
    Object? lastRotatedAt = ignore,
    Object? isActive = ignore,
  }) {
    return collection.updateProperties(
          [id],
          {
            if (scheduleId != ignore) 1: scheduleId as String?,
            if (messId != ignore) 2: messId as String?,
            if (typeIndex != ignore) 3: typeIndex as int?,
            if (rotationOrderJson != ignore) 4: rotationOrderJson as String?,
            if (rotationIntervalDays != ignore) 5: rotationIntervalDays as int?,
            if (lastRotatedAt != ignore) 6: lastRotatedAt as DateTime?,
            if (isActive != ignore) 7: isActive as bool?,
          },
        ) >
        0;
  }
}

sealed class _DutyScheduleCollectionUpdateAll {
  int call({
    required List<int> id,
    String? scheduleId,
    String? messId,
    int? typeIndex,
    String? rotationOrderJson,
    int? rotationIntervalDays,
    DateTime? lastRotatedAt,
    bool? isActive,
  });
}

class _DutyScheduleCollectionUpdateAllImpl
    implements _DutyScheduleCollectionUpdateAll {
  const _DutyScheduleCollectionUpdateAllImpl(this.collection);

  final IsarCollection<int, DutyScheduleCollection> collection;

  @override
  int call({
    required List<int> id,
    Object? scheduleId = ignore,
    Object? messId = ignore,
    Object? typeIndex = ignore,
    Object? rotationOrderJson = ignore,
    Object? rotationIntervalDays = ignore,
    Object? lastRotatedAt = ignore,
    Object? isActive = ignore,
  }) {
    return collection.updateProperties(id, {
      if (scheduleId != ignore) 1: scheduleId as String?,
      if (messId != ignore) 2: messId as String?,
      if (typeIndex != ignore) 3: typeIndex as int?,
      if (rotationOrderJson != ignore) 4: rotationOrderJson as String?,
      if (rotationIntervalDays != ignore) 5: rotationIntervalDays as int?,
      if (lastRotatedAt != ignore) 6: lastRotatedAt as DateTime?,
      if (isActive != ignore) 7: isActive as bool?,
    });
  }
}

extension DutyScheduleCollectionUpdate
    on IsarCollection<int, DutyScheduleCollection> {
  _DutyScheduleCollectionUpdate get update =>
      _DutyScheduleCollectionUpdateImpl(this);

  _DutyScheduleCollectionUpdateAll get updateAll =>
      _DutyScheduleCollectionUpdateAllImpl(this);
}

sealed class _DutyScheduleCollectionQueryUpdate {
  int call({
    String? scheduleId,
    String? messId,
    int? typeIndex,
    String? rotationOrderJson,
    int? rotationIntervalDays,
    DateTime? lastRotatedAt,
    bool? isActive,
  });
}

class _DutyScheduleCollectionQueryUpdateImpl
    implements _DutyScheduleCollectionQueryUpdate {
  const _DutyScheduleCollectionQueryUpdateImpl(this.query, {this.limit});

  final IsarQuery<DutyScheduleCollection> query;
  final int? limit;

  @override
  int call({
    Object? scheduleId = ignore,
    Object? messId = ignore,
    Object? typeIndex = ignore,
    Object? rotationOrderJson = ignore,
    Object? rotationIntervalDays = ignore,
    Object? lastRotatedAt = ignore,
    Object? isActive = ignore,
  }) {
    return query.updateProperties(limit: limit, {
      if (scheduleId != ignore) 1: scheduleId as String?,
      if (messId != ignore) 2: messId as String?,
      if (typeIndex != ignore) 3: typeIndex as int?,
      if (rotationOrderJson != ignore) 4: rotationOrderJson as String?,
      if (rotationIntervalDays != ignore) 5: rotationIntervalDays as int?,
      if (lastRotatedAt != ignore) 6: lastRotatedAt as DateTime?,
      if (isActive != ignore) 7: isActive as bool?,
    });
  }
}

extension DutyScheduleCollectionQueryUpdate
    on IsarQuery<DutyScheduleCollection> {
  _DutyScheduleCollectionQueryUpdate get updateFirst =>
      _DutyScheduleCollectionQueryUpdateImpl(this, limit: 1);

  _DutyScheduleCollectionQueryUpdate get updateAll =>
      _DutyScheduleCollectionQueryUpdateImpl(this);
}

class _DutyScheduleCollectionQueryBuilderUpdateImpl
    implements _DutyScheduleCollectionQueryUpdate {
  const _DutyScheduleCollectionQueryBuilderUpdateImpl(this.query, {this.limit});

  final QueryBuilder<
    DutyScheduleCollection,
    DutyScheduleCollection,
    QOperations
  >
  query;
  final int? limit;

  @override
  int call({
    Object? scheduleId = ignore,
    Object? messId = ignore,
    Object? typeIndex = ignore,
    Object? rotationOrderJson = ignore,
    Object? rotationIntervalDays = ignore,
    Object? lastRotatedAt = ignore,
    Object? isActive = ignore,
  }) {
    final q = query.build();
    try {
      return q.updateProperties(limit: limit, {
        if (scheduleId != ignore) 1: scheduleId as String?,
        if (messId != ignore) 2: messId as String?,
        if (typeIndex != ignore) 3: typeIndex as int?,
        if (rotationOrderJson != ignore) 4: rotationOrderJson as String?,
        if (rotationIntervalDays != ignore) 5: rotationIntervalDays as int?,
        if (lastRotatedAt != ignore) 6: lastRotatedAt as DateTime?,
        if (isActive != ignore) 7: isActive as bool?,
      });
    } finally {
      q.close();
    }
  }
}

extension DutyScheduleCollectionQueryBuilderUpdate
    on
        QueryBuilder<
          DutyScheduleCollection,
          DutyScheduleCollection,
          QOperations
        > {
  _DutyScheduleCollectionQueryUpdate get updateFirst =>
      _DutyScheduleCollectionQueryBuilderUpdateImpl(this, limit: 1);

  _DutyScheduleCollectionQueryUpdate get updateAll =>
      _DutyScheduleCollectionQueryBuilderUpdateImpl(this);
}

extension DutyScheduleCollectionQueryFilter
    on
        QueryBuilder<
          DutyScheduleCollection,
          DutyScheduleCollection,
          QFilterCondition
        > {
  QueryBuilder<
    DutyScheduleCollection,
    DutyScheduleCollection,
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
    DutyScheduleCollection,
    DutyScheduleCollection,
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
    DutyScheduleCollection,
    DutyScheduleCollection,
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
    DutyScheduleCollection,
    DutyScheduleCollection,
    QAfterFilterCondition
  >
  idLessThan(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(LessCondition(property: 0, value: value));
    });
  }

  QueryBuilder<
    DutyScheduleCollection,
    DutyScheduleCollection,
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
    DutyScheduleCollection,
    DutyScheduleCollection,
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
    DutyScheduleCollection,
    DutyScheduleCollection,
    QAfterFilterCondition
  >
  scheduleIdEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(property: 1, value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<
    DutyScheduleCollection,
    DutyScheduleCollection,
    QAfterFilterCondition
  >
  scheduleIdGreaterThan(String value, {bool caseSensitive = true}) {
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
    DutyScheduleCollection,
    DutyScheduleCollection,
    QAfterFilterCondition
  >
  scheduleIdGreaterThanOrEqualTo(String value, {bool caseSensitive = true}) {
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
    DutyScheduleCollection,
    DutyScheduleCollection,
    QAfterFilterCondition
  >
  scheduleIdLessThan(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(property: 1, value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<
    DutyScheduleCollection,
    DutyScheduleCollection,
    QAfterFilterCondition
  >
  scheduleIdLessThanOrEqualTo(String value, {bool caseSensitive = true}) {
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
    DutyScheduleCollection,
    DutyScheduleCollection,
    QAfterFilterCondition
  >
  scheduleIdBetween(String lower, String upper, {bool caseSensitive = true}) {
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
    DutyScheduleCollection,
    DutyScheduleCollection,
    QAfterFilterCondition
  >
  scheduleIdStartsWith(String value, {bool caseSensitive = true}) {
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
    DutyScheduleCollection,
    DutyScheduleCollection,
    QAfterFilterCondition
  >
  scheduleIdEndsWith(String value, {bool caseSensitive = true}) {
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
    DutyScheduleCollection,
    DutyScheduleCollection,
    QAfterFilterCondition
  >
  scheduleIdContains(String value, {bool caseSensitive = true}) {
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
    DutyScheduleCollection,
    DutyScheduleCollection,
    QAfterFilterCondition
  >
  scheduleIdMatches(String pattern, {bool caseSensitive = true}) {
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
    DutyScheduleCollection,
    DutyScheduleCollection,
    QAfterFilterCondition
  >
  scheduleIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const EqualCondition(property: 1, value: ''),
      );
    });
  }

  QueryBuilder<
    DutyScheduleCollection,
    DutyScheduleCollection,
    QAfterFilterCondition
  >
  scheduleIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const GreaterCondition(property: 1, value: ''),
      );
    });
  }

  QueryBuilder<
    DutyScheduleCollection,
    DutyScheduleCollection,
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
    DutyScheduleCollection,
    DutyScheduleCollection,
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
    DutyScheduleCollection,
    DutyScheduleCollection,
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
    DutyScheduleCollection,
    DutyScheduleCollection,
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
    DutyScheduleCollection,
    DutyScheduleCollection,
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
    DutyScheduleCollection,
    DutyScheduleCollection,
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
    DutyScheduleCollection,
    DutyScheduleCollection,
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
    DutyScheduleCollection,
    DutyScheduleCollection,
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
    DutyScheduleCollection,
    DutyScheduleCollection,
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
    DutyScheduleCollection,
    DutyScheduleCollection,
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
    DutyScheduleCollection,
    DutyScheduleCollection,
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
    DutyScheduleCollection,
    DutyScheduleCollection,
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
    DutyScheduleCollection,
    DutyScheduleCollection,
    QAfterFilterCondition
  >
  typeIndexEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(property: 3, value: value),
      );
    });
  }

  QueryBuilder<
    DutyScheduleCollection,
    DutyScheduleCollection,
    QAfterFilterCondition
  >
  typeIndexGreaterThan(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(property: 3, value: value),
      );
    });
  }

  QueryBuilder<
    DutyScheduleCollection,
    DutyScheduleCollection,
    QAfterFilterCondition
  >
  typeIndexGreaterThanOrEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(property: 3, value: value),
      );
    });
  }

  QueryBuilder<
    DutyScheduleCollection,
    DutyScheduleCollection,
    QAfterFilterCondition
  >
  typeIndexLessThan(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(LessCondition(property: 3, value: value));
    });
  }

  QueryBuilder<
    DutyScheduleCollection,
    DutyScheduleCollection,
    QAfterFilterCondition
  >
  typeIndexLessThanOrEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(property: 3, value: value),
      );
    });
  }

  QueryBuilder<
    DutyScheduleCollection,
    DutyScheduleCollection,
    QAfterFilterCondition
  >
  typeIndexBetween(int lower, int upper) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(property: 3, lower: lower, upper: upper),
      );
    });
  }

  QueryBuilder<
    DutyScheduleCollection,
    DutyScheduleCollection,
    QAfterFilterCondition
  >
  rotationOrderJsonEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(property: 4, value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<
    DutyScheduleCollection,
    DutyScheduleCollection,
    QAfterFilterCondition
  >
  rotationOrderJsonGreaterThan(String value, {bool caseSensitive = true}) {
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
    DutyScheduleCollection,
    DutyScheduleCollection,
    QAfterFilterCondition
  >
  rotationOrderJsonGreaterThanOrEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
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
    DutyScheduleCollection,
    DutyScheduleCollection,
    QAfterFilterCondition
  >
  rotationOrderJsonLessThan(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(property: 4, value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<
    DutyScheduleCollection,
    DutyScheduleCollection,
    QAfterFilterCondition
  >
  rotationOrderJsonLessThanOrEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
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
    DutyScheduleCollection,
    DutyScheduleCollection,
    QAfterFilterCondition
  >
  rotationOrderJsonBetween(
    String lower,
    String upper, {
    bool caseSensitive = true,
  }) {
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
    DutyScheduleCollection,
    DutyScheduleCollection,
    QAfterFilterCondition
  >
  rotationOrderJsonStartsWith(String value, {bool caseSensitive = true}) {
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
    DutyScheduleCollection,
    DutyScheduleCollection,
    QAfterFilterCondition
  >
  rotationOrderJsonEndsWith(String value, {bool caseSensitive = true}) {
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
    DutyScheduleCollection,
    DutyScheduleCollection,
    QAfterFilterCondition
  >
  rotationOrderJsonContains(String value, {bool caseSensitive = true}) {
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
    DutyScheduleCollection,
    DutyScheduleCollection,
    QAfterFilterCondition
  >
  rotationOrderJsonMatches(String pattern, {bool caseSensitive = true}) {
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
    DutyScheduleCollection,
    DutyScheduleCollection,
    QAfterFilterCondition
  >
  rotationOrderJsonIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const EqualCondition(property: 4, value: ''),
      );
    });
  }

  QueryBuilder<
    DutyScheduleCollection,
    DutyScheduleCollection,
    QAfterFilterCondition
  >
  rotationOrderJsonIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const GreaterCondition(property: 4, value: ''),
      );
    });
  }

  QueryBuilder<
    DutyScheduleCollection,
    DutyScheduleCollection,
    QAfterFilterCondition
  >
  rotationIntervalDaysEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(property: 5, value: value),
      );
    });
  }

  QueryBuilder<
    DutyScheduleCollection,
    DutyScheduleCollection,
    QAfterFilterCondition
  >
  rotationIntervalDaysGreaterThan(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(property: 5, value: value),
      );
    });
  }

  QueryBuilder<
    DutyScheduleCollection,
    DutyScheduleCollection,
    QAfterFilterCondition
  >
  rotationIntervalDaysGreaterThanOrEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(property: 5, value: value),
      );
    });
  }

  QueryBuilder<
    DutyScheduleCollection,
    DutyScheduleCollection,
    QAfterFilterCondition
  >
  rotationIntervalDaysLessThan(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(LessCondition(property: 5, value: value));
    });
  }

  QueryBuilder<
    DutyScheduleCollection,
    DutyScheduleCollection,
    QAfterFilterCondition
  >
  rotationIntervalDaysLessThanOrEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(property: 5, value: value),
      );
    });
  }

  QueryBuilder<
    DutyScheduleCollection,
    DutyScheduleCollection,
    QAfterFilterCondition
  >
  rotationIntervalDaysBetween(int lower, int upper) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(property: 5, lower: lower, upper: upper),
      );
    });
  }

  QueryBuilder<
    DutyScheduleCollection,
    DutyScheduleCollection,
    QAfterFilterCondition
  >
  lastRotatedAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const IsNullCondition(property: 6));
    });
  }

  QueryBuilder<
    DutyScheduleCollection,
    DutyScheduleCollection,
    QAfterFilterCondition
  >
  lastRotatedAtIsNotNull() {
    return QueryBuilder.apply(not(), (query) {
      return query.addFilterCondition(const IsNullCondition(property: 6));
    });
  }

  QueryBuilder<
    DutyScheduleCollection,
    DutyScheduleCollection,
    QAfterFilterCondition
  >
  lastRotatedAtEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(property: 6, value: value),
      );
    });
  }

  QueryBuilder<
    DutyScheduleCollection,
    DutyScheduleCollection,
    QAfterFilterCondition
  >
  lastRotatedAtGreaterThan(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(property: 6, value: value),
      );
    });
  }

  QueryBuilder<
    DutyScheduleCollection,
    DutyScheduleCollection,
    QAfterFilterCondition
  >
  lastRotatedAtGreaterThanOrEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(property: 6, value: value),
      );
    });
  }

  QueryBuilder<
    DutyScheduleCollection,
    DutyScheduleCollection,
    QAfterFilterCondition
  >
  lastRotatedAtLessThan(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(LessCondition(property: 6, value: value));
    });
  }

  QueryBuilder<
    DutyScheduleCollection,
    DutyScheduleCollection,
    QAfterFilterCondition
  >
  lastRotatedAtLessThanOrEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(property: 6, value: value),
      );
    });
  }

  QueryBuilder<
    DutyScheduleCollection,
    DutyScheduleCollection,
    QAfterFilterCondition
  >
  lastRotatedAtBetween(DateTime? lower, DateTime? upper) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(property: 6, lower: lower, upper: upper),
      );
    });
  }

  QueryBuilder<
    DutyScheduleCollection,
    DutyScheduleCollection,
    QAfterFilterCondition
  >
  isActiveEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(property: 7, value: value),
      );
    });
  }
}

extension DutyScheduleCollectionQueryObject
    on
        QueryBuilder<
          DutyScheduleCollection,
          DutyScheduleCollection,
          QFilterCondition
        > {}

extension DutyScheduleCollectionQuerySortBy
    on QueryBuilder<DutyScheduleCollection, DutyScheduleCollection, QSortBy> {
  QueryBuilder<DutyScheduleCollection, DutyScheduleCollection, QAfterSortBy>
  sortById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(0);
    });
  }

  QueryBuilder<DutyScheduleCollection, DutyScheduleCollection, QAfterSortBy>
  sortByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(0, sort: Sort.desc);
    });
  }

  QueryBuilder<DutyScheduleCollection, DutyScheduleCollection, QAfterSortBy>
  sortByScheduleId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(1, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DutyScheduleCollection, DutyScheduleCollection, QAfterSortBy>
  sortByScheduleIdDesc({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(1, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DutyScheduleCollection, DutyScheduleCollection, QAfterSortBy>
  sortByMessId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(2, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DutyScheduleCollection, DutyScheduleCollection, QAfterSortBy>
  sortByMessIdDesc({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(2, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DutyScheduleCollection, DutyScheduleCollection, QAfterSortBy>
  sortByTypeIndex() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(3);
    });
  }

  QueryBuilder<DutyScheduleCollection, DutyScheduleCollection, QAfterSortBy>
  sortByTypeIndexDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(3, sort: Sort.desc);
    });
  }

  QueryBuilder<DutyScheduleCollection, DutyScheduleCollection, QAfterSortBy>
  sortByRotationOrderJson({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(4, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DutyScheduleCollection, DutyScheduleCollection, QAfterSortBy>
  sortByRotationOrderJsonDesc({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(4, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DutyScheduleCollection, DutyScheduleCollection, QAfterSortBy>
  sortByRotationIntervalDays() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(5);
    });
  }

  QueryBuilder<DutyScheduleCollection, DutyScheduleCollection, QAfterSortBy>
  sortByRotationIntervalDaysDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(5, sort: Sort.desc);
    });
  }

  QueryBuilder<DutyScheduleCollection, DutyScheduleCollection, QAfterSortBy>
  sortByLastRotatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(6);
    });
  }

  QueryBuilder<DutyScheduleCollection, DutyScheduleCollection, QAfterSortBy>
  sortByLastRotatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(6, sort: Sort.desc);
    });
  }

  QueryBuilder<DutyScheduleCollection, DutyScheduleCollection, QAfterSortBy>
  sortByIsActive() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(7);
    });
  }

  QueryBuilder<DutyScheduleCollection, DutyScheduleCollection, QAfterSortBy>
  sortByIsActiveDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(7, sort: Sort.desc);
    });
  }
}

extension DutyScheduleCollectionQuerySortThenBy
    on
        QueryBuilder<
          DutyScheduleCollection,
          DutyScheduleCollection,
          QSortThenBy
        > {
  QueryBuilder<DutyScheduleCollection, DutyScheduleCollection, QAfterSortBy>
  thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(0);
    });
  }

  QueryBuilder<DutyScheduleCollection, DutyScheduleCollection, QAfterSortBy>
  thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(0, sort: Sort.desc);
    });
  }

  QueryBuilder<DutyScheduleCollection, DutyScheduleCollection, QAfterSortBy>
  thenByScheduleId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(1, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DutyScheduleCollection, DutyScheduleCollection, QAfterSortBy>
  thenByScheduleIdDesc({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(1, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DutyScheduleCollection, DutyScheduleCollection, QAfterSortBy>
  thenByMessId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(2, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DutyScheduleCollection, DutyScheduleCollection, QAfterSortBy>
  thenByMessIdDesc({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(2, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DutyScheduleCollection, DutyScheduleCollection, QAfterSortBy>
  thenByTypeIndex() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(3);
    });
  }

  QueryBuilder<DutyScheduleCollection, DutyScheduleCollection, QAfterSortBy>
  thenByTypeIndexDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(3, sort: Sort.desc);
    });
  }

  QueryBuilder<DutyScheduleCollection, DutyScheduleCollection, QAfterSortBy>
  thenByRotationOrderJson({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(4, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DutyScheduleCollection, DutyScheduleCollection, QAfterSortBy>
  thenByRotationOrderJsonDesc({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(4, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DutyScheduleCollection, DutyScheduleCollection, QAfterSortBy>
  thenByRotationIntervalDays() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(5);
    });
  }

  QueryBuilder<DutyScheduleCollection, DutyScheduleCollection, QAfterSortBy>
  thenByRotationIntervalDaysDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(5, sort: Sort.desc);
    });
  }

  QueryBuilder<DutyScheduleCollection, DutyScheduleCollection, QAfterSortBy>
  thenByLastRotatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(6);
    });
  }

  QueryBuilder<DutyScheduleCollection, DutyScheduleCollection, QAfterSortBy>
  thenByLastRotatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(6, sort: Sort.desc);
    });
  }

  QueryBuilder<DutyScheduleCollection, DutyScheduleCollection, QAfterSortBy>
  thenByIsActive() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(7);
    });
  }

  QueryBuilder<DutyScheduleCollection, DutyScheduleCollection, QAfterSortBy>
  thenByIsActiveDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(7, sort: Sort.desc);
    });
  }
}

extension DutyScheduleCollectionQueryWhereDistinct
    on QueryBuilder<DutyScheduleCollection, DutyScheduleCollection, QDistinct> {
  QueryBuilder<DutyScheduleCollection, DutyScheduleCollection, QAfterDistinct>
  distinctByScheduleId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(1, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DutyScheduleCollection, DutyScheduleCollection, QAfterDistinct>
  distinctByMessId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(2, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DutyScheduleCollection, DutyScheduleCollection, QAfterDistinct>
  distinctByTypeIndex() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(3);
    });
  }

  QueryBuilder<DutyScheduleCollection, DutyScheduleCollection, QAfterDistinct>
  distinctByRotationOrderJson({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(4, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DutyScheduleCollection, DutyScheduleCollection, QAfterDistinct>
  distinctByRotationIntervalDays() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(5);
    });
  }

  QueryBuilder<DutyScheduleCollection, DutyScheduleCollection, QAfterDistinct>
  distinctByLastRotatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(6);
    });
  }

  QueryBuilder<DutyScheduleCollection, DutyScheduleCollection, QAfterDistinct>
  distinctByIsActive() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(7);
    });
  }
}

extension DutyScheduleCollectionQueryProperty1
    on QueryBuilder<DutyScheduleCollection, DutyScheduleCollection, QProperty> {
  QueryBuilder<DutyScheduleCollection, int, QAfterProperty> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(0);
    });
  }

  QueryBuilder<DutyScheduleCollection, String, QAfterProperty>
  scheduleIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(1);
    });
  }

  QueryBuilder<DutyScheduleCollection, String, QAfterProperty>
  messIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(2);
    });
  }

  QueryBuilder<DutyScheduleCollection, int, QAfterProperty>
  typeIndexProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(3);
    });
  }

  QueryBuilder<DutyScheduleCollection, String, QAfterProperty>
  rotationOrderJsonProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(4);
    });
  }

  QueryBuilder<DutyScheduleCollection, int, QAfterProperty>
  rotationIntervalDaysProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(5);
    });
  }

  QueryBuilder<DutyScheduleCollection, DateTime?, QAfterProperty>
  lastRotatedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(6);
    });
  }

  QueryBuilder<DutyScheduleCollection, bool, QAfterProperty>
  isActiveProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(7);
    });
  }
}

extension DutyScheduleCollectionQueryProperty2<R>
    on QueryBuilder<DutyScheduleCollection, R, QAfterProperty> {
  QueryBuilder<DutyScheduleCollection, (R, int), QAfterProperty> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(0);
    });
  }

  QueryBuilder<DutyScheduleCollection, (R, String), QAfterProperty>
  scheduleIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(1);
    });
  }

  QueryBuilder<DutyScheduleCollection, (R, String), QAfterProperty>
  messIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(2);
    });
  }

  QueryBuilder<DutyScheduleCollection, (R, int), QAfterProperty>
  typeIndexProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(3);
    });
  }

  QueryBuilder<DutyScheduleCollection, (R, String), QAfterProperty>
  rotationOrderJsonProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(4);
    });
  }

  QueryBuilder<DutyScheduleCollection, (R, int), QAfterProperty>
  rotationIntervalDaysProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(5);
    });
  }

  QueryBuilder<DutyScheduleCollection, (R, DateTime?), QAfterProperty>
  lastRotatedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(6);
    });
  }

  QueryBuilder<DutyScheduleCollection, (R, bool), QAfterProperty>
  isActiveProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(7);
    });
  }
}

extension DutyScheduleCollectionQueryProperty3<R1, R2>
    on QueryBuilder<DutyScheduleCollection, (R1, R2), QAfterProperty> {
  QueryBuilder<DutyScheduleCollection, (R1, R2, int), QOperations>
  idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(0);
    });
  }

  QueryBuilder<DutyScheduleCollection, (R1, R2, String), QOperations>
  scheduleIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(1);
    });
  }

  QueryBuilder<DutyScheduleCollection, (R1, R2, String), QOperations>
  messIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(2);
    });
  }

  QueryBuilder<DutyScheduleCollection, (R1, R2, int), QOperations>
  typeIndexProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(3);
    });
  }

  QueryBuilder<DutyScheduleCollection, (R1, R2, String), QOperations>
  rotationOrderJsonProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(4);
    });
  }

  QueryBuilder<DutyScheduleCollection, (R1, R2, int), QOperations>
  rotationIntervalDaysProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(5);
    });
  }

  QueryBuilder<DutyScheduleCollection, (R1, R2, DateTime?), QOperations>
  lastRotatedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(6);
    });
  }

  QueryBuilder<DutyScheduleCollection, (R1, R2, bool), QOperations>
  isActiveProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(7);
    });
  }
}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, invalid_use_of_protected_member, lines_longer_than_80_chars, constant_identifier_names, avoid_js_rounded_ints, no_leading_underscores_for_local_identifiers, require_trailing_commas, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_in_if_null_operators, library_private_types_in_public_api, prefer_const_constructors
// ignore_for_file: type=lint

extension GetDutyDebtCollectionCollection on Isar {
  IsarCollection<int, DutyDebtCollection> get dutyDebtCollections =>
      this.collection();
}

final DutyDebtCollectionSchema = IsarGeneratedSchema(
  schema: IsarSchema(
    name: 'DutyDebtCollection',
    idName: 'id',
    embedded: false,
    properties: [
      IsarPropertySchema(name: 'debtId', type: IsarType.string),
      IsarPropertySchema(name: 'debtorId', type: IsarType.string),
      IsarPropertySchema(name: 'creditorId', type: IsarType.string),
      IsarPropertySchema(name: 'dutyTypeIndex', type: IsarType.long),
      IsarPropertySchema(name: 'date', type: IsarType.dateTime),
      IsarPropertySchema(name: 'originalDutyId', type: IsarType.string),
      IsarPropertySchema(name: 'isSettled', type: IsarType.bool),
      IsarPropertySchema(name: 'settledAt', type: IsarType.dateTime),
      IsarPropertySchema(name: 'settledByDutyId', type: IsarType.string),
    ],
    indexes: [
      IsarIndexSchema(
        name: 'debtId',
        properties: ["debtId"],
        unique: false,
        hash: false,
      ),
      IsarIndexSchema(
        name: 'debtorId',
        properties: ["debtorId"],
        unique: false,
        hash: false,
      ),
      IsarIndexSchema(
        name: 'creditorId',
        properties: ["creditorId"],
        unique: false,
        hash: false,
      ),
    ],
  ),
  converter: IsarObjectConverter<int, DutyDebtCollection>(
    serialize: serializeDutyDebtCollection,
    deserialize: deserializeDutyDebtCollection,
    deserializeProperty: deserializeDutyDebtCollectionProp,
  ),
  getEmbeddedSchemas: () => [],
);

@isarProtected
int serializeDutyDebtCollection(IsarWriter writer, DutyDebtCollection object) {
  IsarCore.writeString(writer, 1, object.debtId);
  IsarCore.writeString(writer, 2, object.debtorId);
  IsarCore.writeString(writer, 3, object.creditorId);
  IsarCore.writeLong(writer, 4, object.dutyTypeIndex);
  IsarCore.writeLong(writer, 5, object.date.toUtc().microsecondsSinceEpoch);
  IsarCore.writeString(writer, 6, object.originalDutyId);
  IsarCore.writeBool(writer, 7, value: object.isSettled);
  IsarCore.writeLong(
    writer,
    8,
    object.settledAt?.toUtc().microsecondsSinceEpoch ?? -9223372036854775808,
  );
  {
    final value = object.settledByDutyId;
    if (value == null) {
      IsarCore.writeNull(writer, 9);
    } else {
      IsarCore.writeString(writer, 9, value);
    }
  }
  return object.id;
}

@isarProtected
DutyDebtCollection deserializeDutyDebtCollection(IsarReader reader) {
  final object = DutyDebtCollection();
  object.id = IsarCore.readId(reader);
  object.debtId = IsarCore.readString(reader, 1) ?? '';
  object.debtorId = IsarCore.readString(reader, 2) ?? '';
  object.creditorId = IsarCore.readString(reader, 3) ?? '';
  object.dutyTypeIndex = IsarCore.readLong(reader, 4);
  {
    final value = IsarCore.readLong(reader, 5);
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
  object.originalDutyId = IsarCore.readString(reader, 6) ?? '';
  object.isSettled = IsarCore.readBool(reader, 7);
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
  object.settledByDutyId = IsarCore.readString(reader, 9);
  return object;
}

@isarProtected
dynamic deserializeDutyDebtCollectionProp(IsarReader reader, int property) {
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
    case 9:
      return IsarCore.readString(reader, 9);
    default:
      throw ArgumentError('Unknown property: $property');
  }
}

sealed class _DutyDebtCollectionUpdate {
  bool call({
    required int id,
    String? debtId,
    String? debtorId,
    String? creditorId,
    int? dutyTypeIndex,
    DateTime? date,
    String? originalDutyId,
    bool? isSettled,
    DateTime? settledAt,
    String? settledByDutyId,
  });
}

class _DutyDebtCollectionUpdateImpl implements _DutyDebtCollectionUpdate {
  const _DutyDebtCollectionUpdateImpl(this.collection);

  final IsarCollection<int, DutyDebtCollection> collection;

  @override
  bool call({
    required int id,
    Object? debtId = ignore,
    Object? debtorId = ignore,
    Object? creditorId = ignore,
    Object? dutyTypeIndex = ignore,
    Object? date = ignore,
    Object? originalDutyId = ignore,
    Object? isSettled = ignore,
    Object? settledAt = ignore,
    Object? settledByDutyId = ignore,
  }) {
    return collection.updateProperties(
          [id],
          {
            if (debtId != ignore) 1: debtId as String?,
            if (debtorId != ignore) 2: debtorId as String?,
            if (creditorId != ignore) 3: creditorId as String?,
            if (dutyTypeIndex != ignore) 4: dutyTypeIndex as int?,
            if (date != ignore) 5: date as DateTime?,
            if (originalDutyId != ignore) 6: originalDutyId as String?,
            if (isSettled != ignore) 7: isSettled as bool?,
            if (settledAt != ignore) 8: settledAt as DateTime?,
            if (settledByDutyId != ignore) 9: settledByDutyId as String?,
          },
        ) >
        0;
  }
}

sealed class _DutyDebtCollectionUpdateAll {
  int call({
    required List<int> id,
    String? debtId,
    String? debtorId,
    String? creditorId,
    int? dutyTypeIndex,
    DateTime? date,
    String? originalDutyId,
    bool? isSettled,
    DateTime? settledAt,
    String? settledByDutyId,
  });
}

class _DutyDebtCollectionUpdateAllImpl implements _DutyDebtCollectionUpdateAll {
  const _DutyDebtCollectionUpdateAllImpl(this.collection);

  final IsarCollection<int, DutyDebtCollection> collection;

  @override
  int call({
    required List<int> id,
    Object? debtId = ignore,
    Object? debtorId = ignore,
    Object? creditorId = ignore,
    Object? dutyTypeIndex = ignore,
    Object? date = ignore,
    Object? originalDutyId = ignore,
    Object? isSettled = ignore,
    Object? settledAt = ignore,
    Object? settledByDutyId = ignore,
  }) {
    return collection.updateProperties(id, {
      if (debtId != ignore) 1: debtId as String?,
      if (debtorId != ignore) 2: debtorId as String?,
      if (creditorId != ignore) 3: creditorId as String?,
      if (dutyTypeIndex != ignore) 4: dutyTypeIndex as int?,
      if (date != ignore) 5: date as DateTime?,
      if (originalDutyId != ignore) 6: originalDutyId as String?,
      if (isSettled != ignore) 7: isSettled as bool?,
      if (settledAt != ignore) 8: settledAt as DateTime?,
      if (settledByDutyId != ignore) 9: settledByDutyId as String?,
    });
  }
}

extension DutyDebtCollectionUpdate on IsarCollection<int, DutyDebtCollection> {
  _DutyDebtCollectionUpdate get update => _DutyDebtCollectionUpdateImpl(this);

  _DutyDebtCollectionUpdateAll get updateAll =>
      _DutyDebtCollectionUpdateAllImpl(this);
}

sealed class _DutyDebtCollectionQueryUpdate {
  int call({
    String? debtId,
    String? debtorId,
    String? creditorId,
    int? dutyTypeIndex,
    DateTime? date,
    String? originalDutyId,
    bool? isSettled,
    DateTime? settledAt,
    String? settledByDutyId,
  });
}

class _DutyDebtCollectionQueryUpdateImpl
    implements _DutyDebtCollectionQueryUpdate {
  const _DutyDebtCollectionQueryUpdateImpl(this.query, {this.limit});

  final IsarQuery<DutyDebtCollection> query;
  final int? limit;

  @override
  int call({
    Object? debtId = ignore,
    Object? debtorId = ignore,
    Object? creditorId = ignore,
    Object? dutyTypeIndex = ignore,
    Object? date = ignore,
    Object? originalDutyId = ignore,
    Object? isSettled = ignore,
    Object? settledAt = ignore,
    Object? settledByDutyId = ignore,
  }) {
    return query.updateProperties(limit: limit, {
      if (debtId != ignore) 1: debtId as String?,
      if (debtorId != ignore) 2: debtorId as String?,
      if (creditorId != ignore) 3: creditorId as String?,
      if (dutyTypeIndex != ignore) 4: dutyTypeIndex as int?,
      if (date != ignore) 5: date as DateTime?,
      if (originalDutyId != ignore) 6: originalDutyId as String?,
      if (isSettled != ignore) 7: isSettled as bool?,
      if (settledAt != ignore) 8: settledAt as DateTime?,
      if (settledByDutyId != ignore) 9: settledByDutyId as String?,
    });
  }
}

extension DutyDebtCollectionQueryUpdate on IsarQuery<DutyDebtCollection> {
  _DutyDebtCollectionQueryUpdate get updateFirst =>
      _DutyDebtCollectionQueryUpdateImpl(this, limit: 1);

  _DutyDebtCollectionQueryUpdate get updateAll =>
      _DutyDebtCollectionQueryUpdateImpl(this);
}

class _DutyDebtCollectionQueryBuilderUpdateImpl
    implements _DutyDebtCollectionQueryUpdate {
  const _DutyDebtCollectionQueryBuilderUpdateImpl(this.query, {this.limit});

  final QueryBuilder<DutyDebtCollection, DutyDebtCollection, QOperations> query;
  final int? limit;

  @override
  int call({
    Object? debtId = ignore,
    Object? debtorId = ignore,
    Object? creditorId = ignore,
    Object? dutyTypeIndex = ignore,
    Object? date = ignore,
    Object? originalDutyId = ignore,
    Object? isSettled = ignore,
    Object? settledAt = ignore,
    Object? settledByDutyId = ignore,
  }) {
    final q = query.build();
    try {
      return q.updateProperties(limit: limit, {
        if (debtId != ignore) 1: debtId as String?,
        if (debtorId != ignore) 2: debtorId as String?,
        if (creditorId != ignore) 3: creditorId as String?,
        if (dutyTypeIndex != ignore) 4: dutyTypeIndex as int?,
        if (date != ignore) 5: date as DateTime?,
        if (originalDutyId != ignore) 6: originalDutyId as String?,
        if (isSettled != ignore) 7: isSettled as bool?,
        if (settledAt != ignore) 8: settledAt as DateTime?,
        if (settledByDutyId != ignore) 9: settledByDutyId as String?,
      });
    } finally {
      q.close();
    }
  }
}

extension DutyDebtCollectionQueryBuilderUpdate
    on QueryBuilder<DutyDebtCollection, DutyDebtCollection, QOperations> {
  _DutyDebtCollectionQueryUpdate get updateFirst =>
      _DutyDebtCollectionQueryBuilderUpdateImpl(this, limit: 1);

  _DutyDebtCollectionQueryUpdate get updateAll =>
      _DutyDebtCollectionQueryBuilderUpdateImpl(this);
}

extension DutyDebtCollectionQueryFilter
    on QueryBuilder<DutyDebtCollection, DutyDebtCollection, QFilterCondition> {
  QueryBuilder<DutyDebtCollection, DutyDebtCollection, QAfterFilterCondition>
  idEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(property: 0, value: value),
      );
    });
  }

  QueryBuilder<DutyDebtCollection, DutyDebtCollection, QAfterFilterCondition>
  idGreaterThan(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(property: 0, value: value),
      );
    });
  }

  QueryBuilder<DutyDebtCollection, DutyDebtCollection, QAfterFilterCondition>
  idGreaterThanOrEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(property: 0, value: value),
      );
    });
  }

  QueryBuilder<DutyDebtCollection, DutyDebtCollection, QAfterFilterCondition>
  idLessThan(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(LessCondition(property: 0, value: value));
    });
  }

  QueryBuilder<DutyDebtCollection, DutyDebtCollection, QAfterFilterCondition>
  idLessThanOrEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(property: 0, value: value),
      );
    });
  }

  QueryBuilder<DutyDebtCollection, DutyDebtCollection, QAfterFilterCondition>
  idBetween(int lower, int upper) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(property: 0, lower: lower, upper: upper),
      );
    });
  }

  QueryBuilder<DutyDebtCollection, DutyDebtCollection, QAfterFilterCondition>
  debtIdEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(property: 1, value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<DutyDebtCollection, DutyDebtCollection, QAfterFilterCondition>
  debtIdGreaterThan(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<DutyDebtCollection, DutyDebtCollection, QAfterFilterCondition>
  debtIdGreaterThanOrEqualTo(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<DutyDebtCollection, DutyDebtCollection, QAfterFilterCondition>
  debtIdLessThan(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(property: 1, value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<DutyDebtCollection, DutyDebtCollection, QAfterFilterCondition>
  debtIdLessThanOrEqualTo(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<DutyDebtCollection, DutyDebtCollection, QAfterFilterCondition>
  debtIdBetween(String lower, String upper, {bool caseSensitive = true}) {
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

  QueryBuilder<DutyDebtCollection, DutyDebtCollection, QAfterFilterCondition>
  debtIdStartsWith(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<DutyDebtCollection, DutyDebtCollection, QAfterFilterCondition>
  debtIdEndsWith(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<DutyDebtCollection, DutyDebtCollection, QAfterFilterCondition>
  debtIdContains(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<DutyDebtCollection, DutyDebtCollection, QAfterFilterCondition>
  debtIdMatches(String pattern, {bool caseSensitive = true}) {
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

  QueryBuilder<DutyDebtCollection, DutyDebtCollection, QAfterFilterCondition>
  debtIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const EqualCondition(property: 1, value: ''),
      );
    });
  }

  QueryBuilder<DutyDebtCollection, DutyDebtCollection, QAfterFilterCondition>
  debtIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const GreaterCondition(property: 1, value: ''),
      );
    });
  }

  QueryBuilder<DutyDebtCollection, DutyDebtCollection, QAfterFilterCondition>
  debtorIdEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(property: 2, value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<DutyDebtCollection, DutyDebtCollection, QAfterFilterCondition>
  debtorIdGreaterThan(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<DutyDebtCollection, DutyDebtCollection, QAfterFilterCondition>
  debtorIdGreaterThanOrEqualTo(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<DutyDebtCollection, DutyDebtCollection, QAfterFilterCondition>
  debtorIdLessThan(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(property: 2, value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<DutyDebtCollection, DutyDebtCollection, QAfterFilterCondition>
  debtorIdLessThanOrEqualTo(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<DutyDebtCollection, DutyDebtCollection, QAfterFilterCondition>
  debtorIdBetween(String lower, String upper, {bool caseSensitive = true}) {
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

  QueryBuilder<DutyDebtCollection, DutyDebtCollection, QAfterFilterCondition>
  debtorIdStartsWith(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<DutyDebtCollection, DutyDebtCollection, QAfterFilterCondition>
  debtorIdEndsWith(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<DutyDebtCollection, DutyDebtCollection, QAfterFilterCondition>
  debtorIdContains(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<DutyDebtCollection, DutyDebtCollection, QAfterFilterCondition>
  debtorIdMatches(String pattern, {bool caseSensitive = true}) {
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

  QueryBuilder<DutyDebtCollection, DutyDebtCollection, QAfterFilterCondition>
  debtorIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const EqualCondition(property: 2, value: ''),
      );
    });
  }

  QueryBuilder<DutyDebtCollection, DutyDebtCollection, QAfterFilterCondition>
  debtorIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const GreaterCondition(property: 2, value: ''),
      );
    });
  }

  QueryBuilder<DutyDebtCollection, DutyDebtCollection, QAfterFilterCondition>
  creditorIdEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(property: 3, value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<DutyDebtCollection, DutyDebtCollection, QAfterFilterCondition>
  creditorIdGreaterThan(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<DutyDebtCollection, DutyDebtCollection, QAfterFilterCondition>
  creditorIdGreaterThanOrEqualTo(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<DutyDebtCollection, DutyDebtCollection, QAfterFilterCondition>
  creditorIdLessThan(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(property: 3, value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<DutyDebtCollection, DutyDebtCollection, QAfterFilterCondition>
  creditorIdLessThanOrEqualTo(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<DutyDebtCollection, DutyDebtCollection, QAfterFilterCondition>
  creditorIdBetween(String lower, String upper, {bool caseSensitive = true}) {
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

  QueryBuilder<DutyDebtCollection, DutyDebtCollection, QAfterFilterCondition>
  creditorIdStartsWith(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<DutyDebtCollection, DutyDebtCollection, QAfterFilterCondition>
  creditorIdEndsWith(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<DutyDebtCollection, DutyDebtCollection, QAfterFilterCondition>
  creditorIdContains(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<DutyDebtCollection, DutyDebtCollection, QAfterFilterCondition>
  creditorIdMatches(String pattern, {bool caseSensitive = true}) {
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

  QueryBuilder<DutyDebtCollection, DutyDebtCollection, QAfterFilterCondition>
  creditorIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const EqualCondition(property: 3, value: ''),
      );
    });
  }

  QueryBuilder<DutyDebtCollection, DutyDebtCollection, QAfterFilterCondition>
  creditorIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const GreaterCondition(property: 3, value: ''),
      );
    });
  }

  QueryBuilder<DutyDebtCollection, DutyDebtCollection, QAfterFilterCondition>
  dutyTypeIndexEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(property: 4, value: value),
      );
    });
  }

  QueryBuilder<DutyDebtCollection, DutyDebtCollection, QAfterFilterCondition>
  dutyTypeIndexGreaterThan(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(property: 4, value: value),
      );
    });
  }

  QueryBuilder<DutyDebtCollection, DutyDebtCollection, QAfterFilterCondition>
  dutyTypeIndexGreaterThanOrEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(property: 4, value: value),
      );
    });
  }

  QueryBuilder<DutyDebtCollection, DutyDebtCollection, QAfterFilterCondition>
  dutyTypeIndexLessThan(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(LessCondition(property: 4, value: value));
    });
  }

  QueryBuilder<DutyDebtCollection, DutyDebtCollection, QAfterFilterCondition>
  dutyTypeIndexLessThanOrEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(property: 4, value: value),
      );
    });
  }

  QueryBuilder<DutyDebtCollection, DutyDebtCollection, QAfterFilterCondition>
  dutyTypeIndexBetween(int lower, int upper) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(property: 4, lower: lower, upper: upper),
      );
    });
  }

  QueryBuilder<DutyDebtCollection, DutyDebtCollection, QAfterFilterCondition>
  dateEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(property: 5, value: value),
      );
    });
  }

  QueryBuilder<DutyDebtCollection, DutyDebtCollection, QAfterFilterCondition>
  dateGreaterThan(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(property: 5, value: value),
      );
    });
  }

  QueryBuilder<DutyDebtCollection, DutyDebtCollection, QAfterFilterCondition>
  dateGreaterThanOrEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(property: 5, value: value),
      );
    });
  }

  QueryBuilder<DutyDebtCollection, DutyDebtCollection, QAfterFilterCondition>
  dateLessThan(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(LessCondition(property: 5, value: value));
    });
  }

  QueryBuilder<DutyDebtCollection, DutyDebtCollection, QAfterFilterCondition>
  dateLessThanOrEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(property: 5, value: value),
      );
    });
  }

  QueryBuilder<DutyDebtCollection, DutyDebtCollection, QAfterFilterCondition>
  dateBetween(DateTime lower, DateTime upper) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(property: 5, lower: lower, upper: upper),
      );
    });
  }

  QueryBuilder<DutyDebtCollection, DutyDebtCollection, QAfterFilterCondition>
  originalDutyIdEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(property: 6, value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<DutyDebtCollection, DutyDebtCollection, QAfterFilterCondition>
  originalDutyIdGreaterThan(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<DutyDebtCollection, DutyDebtCollection, QAfterFilterCondition>
  originalDutyIdGreaterThanOrEqualTo(
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

  QueryBuilder<DutyDebtCollection, DutyDebtCollection, QAfterFilterCondition>
  originalDutyIdLessThan(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(property: 6, value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<DutyDebtCollection, DutyDebtCollection, QAfterFilterCondition>
  originalDutyIdLessThanOrEqualTo(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<DutyDebtCollection, DutyDebtCollection, QAfterFilterCondition>
  originalDutyIdBetween(
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

  QueryBuilder<DutyDebtCollection, DutyDebtCollection, QAfterFilterCondition>
  originalDutyIdStartsWith(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<DutyDebtCollection, DutyDebtCollection, QAfterFilterCondition>
  originalDutyIdEndsWith(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<DutyDebtCollection, DutyDebtCollection, QAfterFilterCondition>
  originalDutyIdContains(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<DutyDebtCollection, DutyDebtCollection, QAfterFilterCondition>
  originalDutyIdMatches(String pattern, {bool caseSensitive = true}) {
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

  QueryBuilder<DutyDebtCollection, DutyDebtCollection, QAfterFilterCondition>
  originalDutyIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const EqualCondition(property: 6, value: ''),
      );
    });
  }

  QueryBuilder<DutyDebtCollection, DutyDebtCollection, QAfterFilterCondition>
  originalDutyIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const GreaterCondition(property: 6, value: ''),
      );
    });
  }

  QueryBuilder<DutyDebtCollection, DutyDebtCollection, QAfterFilterCondition>
  isSettledEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(property: 7, value: value),
      );
    });
  }

  QueryBuilder<DutyDebtCollection, DutyDebtCollection, QAfterFilterCondition>
  settledAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const IsNullCondition(property: 8));
    });
  }

  QueryBuilder<DutyDebtCollection, DutyDebtCollection, QAfterFilterCondition>
  settledAtIsNotNull() {
    return QueryBuilder.apply(not(), (query) {
      return query.addFilterCondition(const IsNullCondition(property: 8));
    });
  }

  QueryBuilder<DutyDebtCollection, DutyDebtCollection, QAfterFilterCondition>
  settledAtEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(property: 8, value: value),
      );
    });
  }

  QueryBuilder<DutyDebtCollection, DutyDebtCollection, QAfterFilterCondition>
  settledAtGreaterThan(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(property: 8, value: value),
      );
    });
  }

  QueryBuilder<DutyDebtCollection, DutyDebtCollection, QAfterFilterCondition>
  settledAtGreaterThanOrEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(property: 8, value: value),
      );
    });
  }

  QueryBuilder<DutyDebtCollection, DutyDebtCollection, QAfterFilterCondition>
  settledAtLessThan(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(LessCondition(property: 8, value: value));
    });
  }

  QueryBuilder<DutyDebtCollection, DutyDebtCollection, QAfterFilterCondition>
  settledAtLessThanOrEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(property: 8, value: value),
      );
    });
  }

  QueryBuilder<DutyDebtCollection, DutyDebtCollection, QAfterFilterCondition>
  settledAtBetween(DateTime? lower, DateTime? upper) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(property: 8, lower: lower, upper: upper),
      );
    });
  }

  QueryBuilder<DutyDebtCollection, DutyDebtCollection, QAfterFilterCondition>
  settledByDutyIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const IsNullCondition(property: 9));
    });
  }

  QueryBuilder<DutyDebtCollection, DutyDebtCollection, QAfterFilterCondition>
  settledByDutyIdIsNotNull() {
    return QueryBuilder.apply(not(), (query) {
      return query.addFilterCondition(const IsNullCondition(property: 9));
    });
  }

  QueryBuilder<DutyDebtCollection, DutyDebtCollection, QAfterFilterCondition>
  settledByDutyIdEqualTo(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(property: 9, value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<DutyDebtCollection, DutyDebtCollection, QAfterFilterCondition>
  settledByDutyIdGreaterThan(String? value, {bool caseSensitive = true}) {
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

  QueryBuilder<DutyDebtCollection, DutyDebtCollection, QAfterFilterCondition>
  settledByDutyIdGreaterThanOrEqualTo(
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

  QueryBuilder<DutyDebtCollection, DutyDebtCollection, QAfterFilterCondition>
  settledByDutyIdLessThan(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(property: 9, value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<DutyDebtCollection, DutyDebtCollection, QAfterFilterCondition>
  settledByDutyIdLessThanOrEqualTo(String? value, {bool caseSensitive = true}) {
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

  QueryBuilder<DutyDebtCollection, DutyDebtCollection, QAfterFilterCondition>
  settledByDutyIdBetween(
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

  QueryBuilder<DutyDebtCollection, DutyDebtCollection, QAfterFilterCondition>
  settledByDutyIdStartsWith(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<DutyDebtCollection, DutyDebtCollection, QAfterFilterCondition>
  settledByDutyIdEndsWith(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<DutyDebtCollection, DutyDebtCollection, QAfterFilterCondition>
  settledByDutyIdContains(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<DutyDebtCollection, DutyDebtCollection, QAfterFilterCondition>
  settledByDutyIdMatches(String pattern, {bool caseSensitive = true}) {
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

  QueryBuilder<DutyDebtCollection, DutyDebtCollection, QAfterFilterCondition>
  settledByDutyIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const EqualCondition(property: 9, value: ''),
      );
    });
  }

  QueryBuilder<DutyDebtCollection, DutyDebtCollection, QAfterFilterCondition>
  settledByDutyIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const GreaterCondition(property: 9, value: ''),
      );
    });
  }
}

extension DutyDebtCollectionQueryObject
    on QueryBuilder<DutyDebtCollection, DutyDebtCollection, QFilterCondition> {}

extension DutyDebtCollectionQuerySortBy
    on QueryBuilder<DutyDebtCollection, DutyDebtCollection, QSortBy> {
  QueryBuilder<DutyDebtCollection, DutyDebtCollection, QAfterSortBy>
  sortById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(0);
    });
  }

  QueryBuilder<DutyDebtCollection, DutyDebtCollection, QAfterSortBy>
  sortByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(0, sort: Sort.desc);
    });
  }

  QueryBuilder<DutyDebtCollection, DutyDebtCollection, QAfterSortBy>
  sortByDebtId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(1, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DutyDebtCollection, DutyDebtCollection, QAfterSortBy>
  sortByDebtIdDesc({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(1, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DutyDebtCollection, DutyDebtCollection, QAfterSortBy>
  sortByDebtorId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(2, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DutyDebtCollection, DutyDebtCollection, QAfterSortBy>
  sortByDebtorIdDesc({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(2, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DutyDebtCollection, DutyDebtCollection, QAfterSortBy>
  sortByCreditorId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(3, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DutyDebtCollection, DutyDebtCollection, QAfterSortBy>
  sortByCreditorIdDesc({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(3, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DutyDebtCollection, DutyDebtCollection, QAfterSortBy>
  sortByDutyTypeIndex() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(4);
    });
  }

  QueryBuilder<DutyDebtCollection, DutyDebtCollection, QAfterSortBy>
  sortByDutyTypeIndexDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(4, sort: Sort.desc);
    });
  }

  QueryBuilder<DutyDebtCollection, DutyDebtCollection, QAfterSortBy>
  sortByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(5);
    });
  }

  QueryBuilder<DutyDebtCollection, DutyDebtCollection, QAfterSortBy>
  sortByDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(5, sort: Sort.desc);
    });
  }

  QueryBuilder<DutyDebtCollection, DutyDebtCollection, QAfterSortBy>
  sortByOriginalDutyId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(6, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DutyDebtCollection, DutyDebtCollection, QAfterSortBy>
  sortByOriginalDutyIdDesc({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(6, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DutyDebtCollection, DutyDebtCollection, QAfterSortBy>
  sortByIsSettled() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(7);
    });
  }

  QueryBuilder<DutyDebtCollection, DutyDebtCollection, QAfterSortBy>
  sortByIsSettledDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(7, sort: Sort.desc);
    });
  }

  QueryBuilder<DutyDebtCollection, DutyDebtCollection, QAfterSortBy>
  sortBySettledAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(8);
    });
  }

  QueryBuilder<DutyDebtCollection, DutyDebtCollection, QAfterSortBy>
  sortBySettledAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(8, sort: Sort.desc);
    });
  }

  QueryBuilder<DutyDebtCollection, DutyDebtCollection, QAfterSortBy>
  sortBySettledByDutyId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(9, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DutyDebtCollection, DutyDebtCollection, QAfterSortBy>
  sortBySettledByDutyIdDesc({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(9, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }
}

extension DutyDebtCollectionQuerySortThenBy
    on QueryBuilder<DutyDebtCollection, DutyDebtCollection, QSortThenBy> {
  QueryBuilder<DutyDebtCollection, DutyDebtCollection, QAfterSortBy>
  thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(0);
    });
  }

  QueryBuilder<DutyDebtCollection, DutyDebtCollection, QAfterSortBy>
  thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(0, sort: Sort.desc);
    });
  }

  QueryBuilder<DutyDebtCollection, DutyDebtCollection, QAfterSortBy>
  thenByDebtId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(1, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DutyDebtCollection, DutyDebtCollection, QAfterSortBy>
  thenByDebtIdDesc({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(1, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DutyDebtCollection, DutyDebtCollection, QAfterSortBy>
  thenByDebtorId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(2, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DutyDebtCollection, DutyDebtCollection, QAfterSortBy>
  thenByDebtorIdDesc({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(2, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DutyDebtCollection, DutyDebtCollection, QAfterSortBy>
  thenByCreditorId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(3, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DutyDebtCollection, DutyDebtCollection, QAfterSortBy>
  thenByCreditorIdDesc({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(3, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DutyDebtCollection, DutyDebtCollection, QAfterSortBy>
  thenByDutyTypeIndex() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(4);
    });
  }

  QueryBuilder<DutyDebtCollection, DutyDebtCollection, QAfterSortBy>
  thenByDutyTypeIndexDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(4, sort: Sort.desc);
    });
  }

  QueryBuilder<DutyDebtCollection, DutyDebtCollection, QAfterSortBy>
  thenByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(5);
    });
  }

  QueryBuilder<DutyDebtCollection, DutyDebtCollection, QAfterSortBy>
  thenByDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(5, sort: Sort.desc);
    });
  }

  QueryBuilder<DutyDebtCollection, DutyDebtCollection, QAfterSortBy>
  thenByOriginalDutyId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(6, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DutyDebtCollection, DutyDebtCollection, QAfterSortBy>
  thenByOriginalDutyIdDesc({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(6, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DutyDebtCollection, DutyDebtCollection, QAfterSortBy>
  thenByIsSettled() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(7);
    });
  }

  QueryBuilder<DutyDebtCollection, DutyDebtCollection, QAfterSortBy>
  thenByIsSettledDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(7, sort: Sort.desc);
    });
  }

  QueryBuilder<DutyDebtCollection, DutyDebtCollection, QAfterSortBy>
  thenBySettledAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(8);
    });
  }

  QueryBuilder<DutyDebtCollection, DutyDebtCollection, QAfterSortBy>
  thenBySettledAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(8, sort: Sort.desc);
    });
  }

  QueryBuilder<DutyDebtCollection, DutyDebtCollection, QAfterSortBy>
  thenBySettledByDutyId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(9, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DutyDebtCollection, DutyDebtCollection, QAfterSortBy>
  thenBySettledByDutyIdDesc({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(9, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }
}

extension DutyDebtCollectionQueryWhereDistinct
    on QueryBuilder<DutyDebtCollection, DutyDebtCollection, QDistinct> {
  QueryBuilder<DutyDebtCollection, DutyDebtCollection, QAfterDistinct>
  distinctByDebtId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(1, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DutyDebtCollection, DutyDebtCollection, QAfterDistinct>
  distinctByDebtorId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(2, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DutyDebtCollection, DutyDebtCollection, QAfterDistinct>
  distinctByCreditorId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(3, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DutyDebtCollection, DutyDebtCollection, QAfterDistinct>
  distinctByDutyTypeIndex() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(4);
    });
  }

  QueryBuilder<DutyDebtCollection, DutyDebtCollection, QAfterDistinct>
  distinctByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(5);
    });
  }

  QueryBuilder<DutyDebtCollection, DutyDebtCollection, QAfterDistinct>
  distinctByOriginalDutyId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(6, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DutyDebtCollection, DutyDebtCollection, QAfterDistinct>
  distinctByIsSettled() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(7);
    });
  }

  QueryBuilder<DutyDebtCollection, DutyDebtCollection, QAfterDistinct>
  distinctBySettledAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(8);
    });
  }

  QueryBuilder<DutyDebtCollection, DutyDebtCollection, QAfterDistinct>
  distinctBySettledByDutyId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(9, caseSensitive: caseSensitive);
    });
  }
}

extension DutyDebtCollectionQueryProperty1
    on QueryBuilder<DutyDebtCollection, DutyDebtCollection, QProperty> {
  QueryBuilder<DutyDebtCollection, int, QAfterProperty> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(0);
    });
  }

  QueryBuilder<DutyDebtCollection, String, QAfterProperty> debtIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(1);
    });
  }

  QueryBuilder<DutyDebtCollection, String, QAfterProperty> debtorIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(2);
    });
  }

  QueryBuilder<DutyDebtCollection, String, QAfterProperty>
  creditorIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(3);
    });
  }

  QueryBuilder<DutyDebtCollection, int, QAfterProperty>
  dutyTypeIndexProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(4);
    });
  }

  QueryBuilder<DutyDebtCollection, DateTime, QAfterProperty> dateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(5);
    });
  }

  QueryBuilder<DutyDebtCollection, String, QAfterProperty>
  originalDutyIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(6);
    });
  }

  QueryBuilder<DutyDebtCollection, bool, QAfterProperty> isSettledProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(7);
    });
  }

  QueryBuilder<DutyDebtCollection, DateTime?, QAfterProperty>
  settledAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(8);
    });
  }

  QueryBuilder<DutyDebtCollection, String?, QAfterProperty>
  settledByDutyIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(9);
    });
  }
}

extension DutyDebtCollectionQueryProperty2<R>
    on QueryBuilder<DutyDebtCollection, R, QAfterProperty> {
  QueryBuilder<DutyDebtCollection, (R, int), QAfterProperty> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(0);
    });
  }

  QueryBuilder<DutyDebtCollection, (R, String), QAfterProperty>
  debtIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(1);
    });
  }

  QueryBuilder<DutyDebtCollection, (R, String), QAfterProperty>
  debtorIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(2);
    });
  }

  QueryBuilder<DutyDebtCollection, (R, String), QAfterProperty>
  creditorIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(3);
    });
  }

  QueryBuilder<DutyDebtCollection, (R, int), QAfterProperty>
  dutyTypeIndexProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(4);
    });
  }

  QueryBuilder<DutyDebtCollection, (R, DateTime), QAfterProperty>
  dateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(5);
    });
  }

  QueryBuilder<DutyDebtCollection, (R, String), QAfterProperty>
  originalDutyIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(6);
    });
  }

  QueryBuilder<DutyDebtCollection, (R, bool), QAfterProperty>
  isSettledProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(7);
    });
  }

  QueryBuilder<DutyDebtCollection, (R, DateTime?), QAfterProperty>
  settledAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(8);
    });
  }

  QueryBuilder<DutyDebtCollection, (R, String?), QAfterProperty>
  settledByDutyIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(9);
    });
  }
}

extension DutyDebtCollectionQueryProperty3<R1, R2>
    on QueryBuilder<DutyDebtCollection, (R1, R2), QAfterProperty> {
  QueryBuilder<DutyDebtCollection, (R1, R2, int), QOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(0);
    });
  }

  QueryBuilder<DutyDebtCollection, (R1, R2, String), QOperations>
  debtIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(1);
    });
  }

  QueryBuilder<DutyDebtCollection, (R1, R2, String), QOperations>
  debtorIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(2);
    });
  }

  QueryBuilder<DutyDebtCollection, (R1, R2, String), QOperations>
  creditorIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(3);
    });
  }

  QueryBuilder<DutyDebtCollection, (R1, R2, int), QOperations>
  dutyTypeIndexProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(4);
    });
  }

  QueryBuilder<DutyDebtCollection, (R1, R2, DateTime), QOperations>
  dateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(5);
    });
  }

  QueryBuilder<DutyDebtCollection, (R1, R2, String), QOperations>
  originalDutyIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(6);
    });
  }

  QueryBuilder<DutyDebtCollection, (R1, R2, bool), QOperations>
  isSettledProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(7);
    });
  }

  QueryBuilder<DutyDebtCollection, (R1, R2, DateTime?), QOperations>
  settledAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(8);
    });
  }

  QueryBuilder<DutyDebtCollection, (R1, R2, String?), QOperations>
  settledByDutyIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(9);
    });
  }
}
