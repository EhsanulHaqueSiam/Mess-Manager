// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_collection.dart';

// **************************************************************************
// _IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, invalid_use_of_protected_member, lines_longer_than_80_chars, constant_identifier_names, avoid_js_rounded_ints, no_leading_underscores_for_local_identifiers, require_trailing_commas, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_in_if_null_operators, library_private_types_in_public_api, prefer_const_constructors
// ignore_for_file: type=lint

extension GetTransactionCollectionCollection on Isar {
  IsarCollection<int, TransactionCollection> get transactionCollections =>
      this.collection();
}

final TransactionCollectionSchema = IsarGeneratedSchema(
  schema: IsarSchema(
    name: 'TransactionCollection',
    idName: 'id',
    embedded: false,
    properties: [
      IsarPropertySchema(name: 'transactionId', type: IsarType.string),
      IsarPropertySchema(name: 'fromMemberId', type: IsarType.string),
      IsarPropertySchema(name: 'toMemberId', type: IsarType.string),
      IsarPropertySchema(name: 'amount', type: IsarType.double),
      IsarPropertySchema(name: 'date', type: IsarType.dateTime),
      IsarPropertySchema(name: 'description', type: IsarType.string),
      IsarPropertySchema(name: 'note', type: IsarType.string),
      IsarPropertySchema(name: 'isSettled', type: IsarType.bool),
      IsarPropertySchema(name: 'settledAt', type: IsarType.dateTime),
      IsarPropertySchema(name: 'createdAt', type: IsarType.dateTime),
    ],
    indexes: [
      IsarIndexSchema(
        name: 'transactionId',
        properties: ["transactionId"],
        unique: false,
        hash: false,
      ),
      IsarIndexSchema(
        name: 'fromMemberId',
        properties: ["fromMemberId"],
        unique: false,
        hash: false,
      ),
      IsarIndexSchema(
        name: 'toMemberId',
        properties: ["toMemberId"],
        unique: false,
        hash: false,
      ),
    ],
  ),
  converter: IsarObjectConverter<int, TransactionCollection>(
    serialize: serializeTransactionCollection,
    deserialize: deserializeTransactionCollection,
    deserializeProperty: deserializeTransactionCollectionProp,
  ),
  getEmbeddedSchemas: () => [],
);

@isarProtected
int serializeTransactionCollection(
  IsarWriter writer,
  TransactionCollection object,
) {
  IsarCore.writeString(writer, 1, object.transactionId);
  IsarCore.writeString(writer, 2, object.fromMemberId);
  IsarCore.writeString(writer, 3, object.toMemberId);
  IsarCore.writeDouble(writer, 4, object.amount);
  IsarCore.writeLong(writer, 5, object.date.toUtc().microsecondsSinceEpoch);
  {
    final value = object.description;
    if (value == null) {
      IsarCore.writeNull(writer, 6);
    } else {
      IsarCore.writeString(writer, 6, value);
    }
  }
  {
    final value = object.note;
    if (value == null) {
      IsarCore.writeNull(writer, 7);
    } else {
      IsarCore.writeString(writer, 7, value);
    }
  }
  IsarCore.writeBool(writer, 8, value: object.isSettled);
  IsarCore.writeLong(
    writer,
    9,
    object.settledAt?.toUtc().microsecondsSinceEpoch ?? -9223372036854775808,
  );
  IsarCore.writeLong(
    writer,
    10,
    object.createdAt?.toUtc().microsecondsSinceEpoch ?? -9223372036854775808,
  );
  return object.id;
}

@isarProtected
TransactionCollection deserializeTransactionCollection(IsarReader reader) {
  final object = TransactionCollection();
  object.id = IsarCore.readId(reader);
  object.transactionId = IsarCore.readString(reader, 1) ?? '';
  object.fromMemberId = IsarCore.readString(reader, 2) ?? '';
  object.toMemberId = IsarCore.readString(reader, 3) ?? '';
  object.amount = IsarCore.readDouble(reader, 4);
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
  object.description = IsarCore.readString(reader, 6);
  object.note = IsarCore.readString(reader, 7);
  object.isSettled = IsarCore.readBool(reader, 8);
  {
    final value = IsarCore.readLong(reader, 9);
    if (value == -9223372036854775808) {
      object.settledAt = null;
    } else {
      object.settledAt = DateTime.fromMicrosecondsSinceEpoch(
        value,
        isUtc: true,
      ).toLocal();
    }
  }
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
dynamic deserializeTransactionCollectionProp(IsarReader reader, int property) {
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
      return IsarCore.readDouble(reader, 4);
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
      return IsarCore.readString(reader, 6);
    case 7:
      return IsarCore.readString(reader, 7);
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

sealed class _TransactionCollectionUpdate {
  bool call({
    required int id,
    String? transactionId,
    String? fromMemberId,
    String? toMemberId,
    double? amount,
    DateTime? date,
    String? description,
    String? note,
    bool? isSettled,
    DateTime? settledAt,
    DateTime? createdAt,
  });
}

class _TransactionCollectionUpdateImpl implements _TransactionCollectionUpdate {
  const _TransactionCollectionUpdateImpl(this.collection);

  final IsarCollection<int, TransactionCollection> collection;

  @override
  bool call({
    required int id,
    Object? transactionId = ignore,
    Object? fromMemberId = ignore,
    Object? toMemberId = ignore,
    Object? amount = ignore,
    Object? date = ignore,
    Object? description = ignore,
    Object? note = ignore,
    Object? isSettled = ignore,
    Object? settledAt = ignore,
    Object? createdAt = ignore,
  }) {
    return collection.updateProperties(
          [id],
          {
            if (transactionId != ignore) 1: transactionId as String?,
            if (fromMemberId != ignore) 2: fromMemberId as String?,
            if (toMemberId != ignore) 3: toMemberId as String?,
            if (amount != ignore) 4: amount as double?,
            if (date != ignore) 5: date as DateTime?,
            if (description != ignore) 6: description as String?,
            if (note != ignore) 7: note as String?,
            if (isSettled != ignore) 8: isSettled as bool?,
            if (settledAt != ignore) 9: settledAt as DateTime?,
            if (createdAt != ignore) 10: createdAt as DateTime?,
          },
        ) >
        0;
  }
}

sealed class _TransactionCollectionUpdateAll {
  int call({
    required List<int> id,
    String? transactionId,
    String? fromMemberId,
    String? toMemberId,
    double? amount,
    DateTime? date,
    String? description,
    String? note,
    bool? isSettled,
    DateTime? settledAt,
    DateTime? createdAt,
  });
}

class _TransactionCollectionUpdateAllImpl
    implements _TransactionCollectionUpdateAll {
  const _TransactionCollectionUpdateAllImpl(this.collection);

  final IsarCollection<int, TransactionCollection> collection;

  @override
  int call({
    required List<int> id,
    Object? transactionId = ignore,
    Object? fromMemberId = ignore,
    Object? toMemberId = ignore,
    Object? amount = ignore,
    Object? date = ignore,
    Object? description = ignore,
    Object? note = ignore,
    Object? isSettled = ignore,
    Object? settledAt = ignore,
    Object? createdAt = ignore,
  }) {
    return collection.updateProperties(id, {
      if (transactionId != ignore) 1: transactionId as String?,
      if (fromMemberId != ignore) 2: fromMemberId as String?,
      if (toMemberId != ignore) 3: toMemberId as String?,
      if (amount != ignore) 4: amount as double?,
      if (date != ignore) 5: date as DateTime?,
      if (description != ignore) 6: description as String?,
      if (note != ignore) 7: note as String?,
      if (isSettled != ignore) 8: isSettled as bool?,
      if (settledAt != ignore) 9: settledAt as DateTime?,
      if (createdAt != ignore) 10: createdAt as DateTime?,
    });
  }
}

extension TransactionCollectionUpdate
    on IsarCollection<int, TransactionCollection> {
  _TransactionCollectionUpdate get update =>
      _TransactionCollectionUpdateImpl(this);

  _TransactionCollectionUpdateAll get updateAll =>
      _TransactionCollectionUpdateAllImpl(this);
}

sealed class _TransactionCollectionQueryUpdate {
  int call({
    String? transactionId,
    String? fromMemberId,
    String? toMemberId,
    double? amount,
    DateTime? date,
    String? description,
    String? note,
    bool? isSettled,
    DateTime? settledAt,
    DateTime? createdAt,
  });
}

class _TransactionCollectionQueryUpdateImpl
    implements _TransactionCollectionQueryUpdate {
  const _TransactionCollectionQueryUpdateImpl(this.query, {this.limit});

  final IsarQuery<TransactionCollection> query;
  final int? limit;

  @override
  int call({
    Object? transactionId = ignore,
    Object? fromMemberId = ignore,
    Object? toMemberId = ignore,
    Object? amount = ignore,
    Object? date = ignore,
    Object? description = ignore,
    Object? note = ignore,
    Object? isSettled = ignore,
    Object? settledAt = ignore,
    Object? createdAt = ignore,
  }) {
    return query.updateProperties(limit: limit, {
      if (transactionId != ignore) 1: transactionId as String?,
      if (fromMemberId != ignore) 2: fromMemberId as String?,
      if (toMemberId != ignore) 3: toMemberId as String?,
      if (amount != ignore) 4: amount as double?,
      if (date != ignore) 5: date as DateTime?,
      if (description != ignore) 6: description as String?,
      if (note != ignore) 7: note as String?,
      if (isSettled != ignore) 8: isSettled as bool?,
      if (settledAt != ignore) 9: settledAt as DateTime?,
      if (createdAt != ignore) 10: createdAt as DateTime?,
    });
  }
}

extension TransactionCollectionQueryUpdate on IsarQuery<TransactionCollection> {
  _TransactionCollectionQueryUpdate get updateFirst =>
      _TransactionCollectionQueryUpdateImpl(this, limit: 1);

  _TransactionCollectionQueryUpdate get updateAll =>
      _TransactionCollectionQueryUpdateImpl(this);
}

class _TransactionCollectionQueryBuilderUpdateImpl
    implements _TransactionCollectionQueryUpdate {
  const _TransactionCollectionQueryBuilderUpdateImpl(this.query, {this.limit});

  final QueryBuilder<TransactionCollection, TransactionCollection, QOperations>
  query;
  final int? limit;

  @override
  int call({
    Object? transactionId = ignore,
    Object? fromMemberId = ignore,
    Object? toMemberId = ignore,
    Object? amount = ignore,
    Object? date = ignore,
    Object? description = ignore,
    Object? note = ignore,
    Object? isSettled = ignore,
    Object? settledAt = ignore,
    Object? createdAt = ignore,
  }) {
    final q = query.build();
    try {
      return q.updateProperties(limit: limit, {
        if (transactionId != ignore) 1: transactionId as String?,
        if (fromMemberId != ignore) 2: fromMemberId as String?,
        if (toMemberId != ignore) 3: toMemberId as String?,
        if (amount != ignore) 4: amount as double?,
        if (date != ignore) 5: date as DateTime?,
        if (description != ignore) 6: description as String?,
        if (note != ignore) 7: note as String?,
        if (isSettled != ignore) 8: isSettled as bool?,
        if (settledAt != ignore) 9: settledAt as DateTime?,
        if (createdAt != ignore) 10: createdAt as DateTime?,
      });
    } finally {
      q.close();
    }
  }
}

extension TransactionCollectionQueryBuilderUpdate
    on QueryBuilder<TransactionCollection, TransactionCollection, QOperations> {
  _TransactionCollectionQueryUpdate get updateFirst =>
      _TransactionCollectionQueryBuilderUpdateImpl(this, limit: 1);

  _TransactionCollectionQueryUpdate get updateAll =>
      _TransactionCollectionQueryBuilderUpdateImpl(this);
}

extension TransactionCollectionQueryFilter
    on
        QueryBuilder<
          TransactionCollection,
          TransactionCollection,
          QFilterCondition
        > {
  QueryBuilder<
    TransactionCollection,
    TransactionCollection,
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
    TransactionCollection,
    TransactionCollection,
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
    TransactionCollection,
    TransactionCollection,
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
    TransactionCollection,
    TransactionCollection,
    QAfterFilterCondition
  >
  idLessThan(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(LessCondition(property: 0, value: value));
    });
  }

  QueryBuilder<
    TransactionCollection,
    TransactionCollection,
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
    TransactionCollection,
    TransactionCollection,
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
    TransactionCollection,
    TransactionCollection,
    QAfterFilterCondition
  >
  transactionIdEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(property: 1, value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<
    TransactionCollection,
    TransactionCollection,
    QAfterFilterCondition
  >
  transactionIdGreaterThan(String value, {bool caseSensitive = true}) {
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
    TransactionCollection,
    TransactionCollection,
    QAfterFilterCondition
  >
  transactionIdGreaterThanOrEqualTo(String value, {bool caseSensitive = true}) {
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
    TransactionCollection,
    TransactionCollection,
    QAfterFilterCondition
  >
  transactionIdLessThan(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(property: 1, value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<
    TransactionCollection,
    TransactionCollection,
    QAfterFilterCondition
  >
  transactionIdLessThanOrEqualTo(String value, {bool caseSensitive = true}) {
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
    TransactionCollection,
    TransactionCollection,
    QAfterFilterCondition
  >
  transactionIdBetween(
    String lower,
    String upper, {
    bool caseSensitive = true,
  }) {
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
    TransactionCollection,
    TransactionCollection,
    QAfterFilterCondition
  >
  transactionIdStartsWith(String value, {bool caseSensitive = true}) {
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
    TransactionCollection,
    TransactionCollection,
    QAfterFilterCondition
  >
  transactionIdEndsWith(String value, {bool caseSensitive = true}) {
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
    TransactionCollection,
    TransactionCollection,
    QAfterFilterCondition
  >
  transactionIdContains(String value, {bool caseSensitive = true}) {
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
    TransactionCollection,
    TransactionCollection,
    QAfterFilterCondition
  >
  transactionIdMatches(String pattern, {bool caseSensitive = true}) {
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
    TransactionCollection,
    TransactionCollection,
    QAfterFilterCondition
  >
  transactionIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const EqualCondition(property: 1, value: ''),
      );
    });
  }

  QueryBuilder<
    TransactionCollection,
    TransactionCollection,
    QAfterFilterCondition
  >
  transactionIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const GreaterCondition(property: 1, value: ''),
      );
    });
  }

  QueryBuilder<
    TransactionCollection,
    TransactionCollection,
    QAfterFilterCondition
  >
  fromMemberIdEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(property: 2, value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<
    TransactionCollection,
    TransactionCollection,
    QAfterFilterCondition
  >
  fromMemberIdGreaterThan(String value, {bool caseSensitive = true}) {
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
    TransactionCollection,
    TransactionCollection,
    QAfterFilterCondition
  >
  fromMemberIdGreaterThanOrEqualTo(String value, {bool caseSensitive = true}) {
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
    TransactionCollection,
    TransactionCollection,
    QAfterFilterCondition
  >
  fromMemberIdLessThan(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(property: 2, value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<
    TransactionCollection,
    TransactionCollection,
    QAfterFilterCondition
  >
  fromMemberIdLessThanOrEqualTo(String value, {bool caseSensitive = true}) {
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
    TransactionCollection,
    TransactionCollection,
    QAfterFilterCondition
  >
  fromMemberIdBetween(String lower, String upper, {bool caseSensitive = true}) {
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
    TransactionCollection,
    TransactionCollection,
    QAfterFilterCondition
  >
  fromMemberIdStartsWith(String value, {bool caseSensitive = true}) {
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
    TransactionCollection,
    TransactionCollection,
    QAfterFilterCondition
  >
  fromMemberIdEndsWith(String value, {bool caseSensitive = true}) {
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
    TransactionCollection,
    TransactionCollection,
    QAfterFilterCondition
  >
  fromMemberIdContains(String value, {bool caseSensitive = true}) {
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
    TransactionCollection,
    TransactionCollection,
    QAfterFilterCondition
  >
  fromMemberIdMatches(String pattern, {bool caseSensitive = true}) {
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
    TransactionCollection,
    TransactionCollection,
    QAfterFilterCondition
  >
  fromMemberIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const EqualCondition(property: 2, value: ''),
      );
    });
  }

  QueryBuilder<
    TransactionCollection,
    TransactionCollection,
    QAfterFilterCondition
  >
  fromMemberIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const GreaterCondition(property: 2, value: ''),
      );
    });
  }

  QueryBuilder<
    TransactionCollection,
    TransactionCollection,
    QAfterFilterCondition
  >
  toMemberIdEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(property: 3, value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<
    TransactionCollection,
    TransactionCollection,
    QAfterFilterCondition
  >
  toMemberIdGreaterThan(String value, {bool caseSensitive = true}) {
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
    TransactionCollection,
    TransactionCollection,
    QAfterFilterCondition
  >
  toMemberIdGreaterThanOrEqualTo(String value, {bool caseSensitive = true}) {
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
    TransactionCollection,
    TransactionCollection,
    QAfterFilterCondition
  >
  toMemberIdLessThan(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(property: 3, value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<
    TransactionCollection,
    TransactionCollection,
    QAfterFilterCondition
  >
  toMemberIdLessThanOrEqualTo(String value, {bool caseSensitive = true}) {
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
    TransactionCollection,
    TransactionCollection,
    QAfterFilterCondition
  >
  toMemberIdBetween(String lower, String upper, {bool caseSensitive = true}) {
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
    TransactionCollection,
    TransactionCollection,
    QAfterFilterCondition
  >
  toMemberIdStartsWith(String value, {bool caseSensitive = true}) {
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
    TransactionCollection,
    TransactionCollection,
    QAfterFilterCondition
  >
  toMemberIdEndsWith(String value, {bool caseSensitive = true}) {
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
    TransactionCollection,
    TransactionCollection,
    QAfterFilterCondition
  >
  toMemberIdContains(String value, {bool caseSensitive = true}) {
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
    TransactionCollection,
    TransactionCollection,
    QAfterFilterCondition
  >
  toMemberIdMatches(String pattern, {bool caseSensitive = true}) {
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
    TransactionCollection,
    TransactionCollection,
    QAfterFilterCondition
  >
  toMemberIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const EqualCondition(property: 3, value: ''),
      );
    });
  }

  QueryBuilder<
    TransactionCollection,
    TransactionCollection,
    QAfterFilterCondition
  >
  toMemberIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const GreaterCondition(property: 3, value: ''),
      );
    });
  }

  QueryBuilder<
    TransactionCollection,
    TransactionCollection,
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
    TransactionCollection,
    TransactionCollection,
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
    TransactionCollection,
    TransactionCollection,
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
    TransactionCollection,
    TransactionCollection,
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
    TransactionCollection,
    TransactionCollection,
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
    TransactionCollection,
    TransactionCollection,
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
    TransactionCollection,
    TransactionCollection,
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
    TransactionCollection,
    TransactionCollection,
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
    TransactionCollection,
    TransactionCollection,
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
    TransactionCollection,
    TransactionCollection,
    QAfterFilterCondition
  >
  dateLessThan(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(LessCondition(property: 5, value: value));
    });
  }

  QueryBuilder<
    TransactionCollection,
    TransactionCollection,
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
    TransactionCollection,
    TransactionCollection,
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
    TransactionCollection,
    TransactionCollection,
    QAfterFilterCondition
  >
  descriptionIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const IsNullCondition(property: 6));
    });
  }

  QueryBuilder<
    TransactionCollection,
    TransactionCollection,
    QAfterFilterCondition
  >
  descriptionIsNotNull() {
    return QueryBuilder.apply(not(), (query) {
      return query.addFilterCondition(const IsNullCondition(property: 6));
    });
  }

  QueryBuilder<
    TransactionCollection,
    TransactionCollection,
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
    TransactionCollection,
    TransactionCollection,
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
    TransactionCollection,
    TransactionCollection,
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
    TransactionCollection,
    TransactionCollection,
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
    TransactionCollection,
    TransactionCollection,
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
    TransactionCollection,
    TransactionCollection,
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
    TransactionCollection,
    TransactionCollection,
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
    TransactionCollection,
    TransactionCollection,
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
    TransactionCollection,
    TransactionCollection,
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
    TransactionCollection,
    TransactionCollection,
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
    TransactionCollection,
    TransactionCollection,
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
    TransactionCollection,
    TransactionCollection,
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
    TransactionCollection,
    TransactionCollection,
    QAfterFilterCondition
  >
  noteIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const IsNullCondition(property: 7));
    });
  }

  QueryBuilder<
    TransactionCollection,
    TransactionCollection,
    QAfterFilterCondition
  >
  noteIsNotNull() {
    return QueryBuilder.apply(not(), (query) {
      return query.addFilterCondition(const IsNullCondition(property: 7));
    });
  }

  QueryBuilder<
    TransactionCollection,
    TransactionCollection,
    QAfterFilterCondition
  >
  noteEqualTo(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(property: 7, value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<
    TransactionCollection,
    TransactionCollection,
    QAfterFilterCondition
  >
  noteGreaterThan(String? value, {bool caseSensitive = true}) {
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
    TransactionCollection,
    TransactionCollection,
    QAfterFilterCondition
  >
  noteGreaterThanOrEqualTo(String? value, {bool caseSensitive = true}) {
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
    TransactionCollection,
    TransactionCollection,
    QAfterFilterCondition
  >
  noteLessThan(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(property: 7, value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<
    TransactionCollection,
    TransactionCollection,
    QAfterFilterCondition
  >
  noteLessThanOrEqualTo(String? value, {bool caseSensitive = true}) {
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
    TransactionCollection,
    TransactionCollection,
    QAfterFilterCondition
  >
  noteBetween(String? lower, String? upper, {bool caseSensitive = true}) {
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
    TransactionCollection,
    TransactionCollection,
    QAfterFilterCondition
  >
  noteStartsWith(String value, {bool caseSensitive = true}) {
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
    TransactionCollection,
    TransactionCollection,
    QAfterFilterCondition
  >
  noteEndsWith(String value, {bool caseSensitive = true}) {
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
    TransactionCollection,
    TransactionCollection,
    QAfterFilterCondition
  >
  noteContains(String value, {bool caseSensitive = true}) {
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
    TransactionCollection,
    TransactionCollection,
    QAfterFilterCondition
  >
  noteMatches(String pattern, {bool caseSensitive = true}) {
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
    TransactionCollection,
    TransactionCollection,
    QAfterFilterCondition
  >
  noteIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const EqualCondition(property: 7, value: ''),
      );
    });
  }

  QueryBuilder<
    TransactionCollection,
    TransactionCollection,
    QAfterFilterCondition
  >
  noteIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const GreaterCondition(property: 7, value: ''),
      );
    });
  }

  QueryBuilder<
    TransactionCollection,
    TransactionCollection,
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
    TransactionCollection,
    TransactionCollection,
    QAfterFilterCondition
  >
  settledAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const IsNullCondition(property: 9));
    });
  }

  QueryBuilder<
    TransactionCollection,
    TransactionCollection,
    QAfterFilterCondition
  >
  settledAtIsNotNull() {
    return QueryBuilder.apply(not(), (query) {
      return query.addFilterCondition(const IsNullCondition(property: 9));
    });
  }

  QueryBuilder<
    TransactionCollection,
    TransactionCollection,
    QAfterFilterCondition
  >
  settledAtEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(property: 9, value: value),
      );
    });
  }

  QueryBuilder<
    TransactionCollection,
    TransactionCollection,
    QAfterFilterCondition
  >
  settledAtGreaterThan(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(property: 9, value: value),
      );
    });
  }

  QueryBuilder<
    TransactionCollection,
    TransactionCollection,
    QAfterFilterCondition
  >
  settledAtGreaterThanOrEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(property: 9, value: value),
      );
    });
  }

  QueryBuilder<
    TransactionCollection,
    TransactionCollection,
    QAfterFilterCondition
  >
  settledAtLessThan(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(LessCondition(property: 9, value: value));
    });
  }

  QueryBuilder<
    TransactionCollection,
    TransactionCollection,
    QAfterFilterCondition
  >
  settledAtLessThanOrEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(property: 9, value: value),
      );
    });
  }

  QueryBuilder<
    TransactionCollection,
    TransactionCollection,
    QAfterFilterCondition
  >
  settledAtBetween(DateTime? lower, DateTime? upper) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(property: 9, lower: lower, upper: upper),
      );
    });
  }

  QueryBuilder<
    TransactionCollection,
    TransactionCollection,
    QAfterFilterCondition
  >
  createdAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const IsNullCondition(property: 10));
    });
  }

  QueryBuilder<
    TransactionCollection,
    TransactionCollection,
    QAfterFilterCondition
  >
  createdAtIsNotNull() {
    return QueryBuilder.apply(not(), (query) {
      return query.addFilterCondition(const IsNullCondition(property: 10));
    });
  }

  QueryBuilder<
    TransactionCollection,
    TransactionCollection,
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
    TransactionCollection,
    TransactionCollection,
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
    TransactionCollection,
    TransactionCollection,
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
    TransactionCollection,
    TransactionCollection,
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
    TransactionCollection,
    TransactionCollection,
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
    TransactionCollection,
    TransactionCollection,
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

extension TransactionCollectionQueryObject
    on
        QueryBuilder<
          TransactionCollection,
          TransactionCollection,
          QFilterCondition
        > {}

extension TransactionCollectionQuerySortBy
    on QueryBuilder<TransactionCollection, TransactionCollection, QSortBy> {
  QueryBuilder<TransactionCollection, TransactionCollection, QAfterSortBy>
  sortById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(0);
    });
  }

  QueryBuilder<TransactionCollection, TransactionCollection, QAfterSortBy>
  sortByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(0, sort: Sort.desc);
    });
  }

  QueryBuilder<TransactionCollection, TransactionCollection, QAfterSortBy>
  sortByTransactionId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(1, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TransactionCollection, TransactionCollection, QAfterSortBy>
  sortByTransactionIdDesc({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(1, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TransactionCollection, TransactionCollection, QAfterSortBy>
  sortByFromMemberId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(2, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TransactionCollection, TransactionCollection, QAfterSortBy>
  sortByFromMemberIdDesc({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(2, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TransactionCollection, TransactionCollection, QAfterSortBy>
  sortByToMemberId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(3, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TransactionCollection, TransactionCollection, QAfterSortBy>
  sortByToMemberIdDesc({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(3, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TransactionCollection, TransactionCollection, QAfterSortBy>
  sortByAmount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(4);
    });
  }

  QueryBuilder<TransactionCollection, TransactionCollection, QAfterSortBy>
  sortByAmountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(4, sort: Sort.desc);
    });
  }

  QueryBuilder<TransactionCollection, TransactionCollection, QAfterSortBy>
  sortByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(5);
    });
  }

  QueryBuilder<TransactionCollection, TransactionCollection, QAfterSortBy>
  sortByDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(5, sort: Sort.desc);
    });
  }

  QueryBuilder<TransactionCollection, TransactionCollection, QAfterSortBy>
  sortByDescription({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(6, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TransactionCollection, TransactionCollection, QAfterSortBy>
  sortByDescriptionDesc({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(6, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TransactionCollection, TransactionCollection, QAfterSortBy>
  sortByNote({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(7, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TransactionCollection, TransactionCollection, QAfterSortBy>
  sortByNoteDesc({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(7, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TransactionCollection, TransactionCollection, QAfterSortBy>
  sortByIsSettled() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(8);
    });
  }

  QueryBuilder<TransactionCollection, TransactionCollection, QAfterSortBy>
  sortByIsSettledDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(8, sort: Sort.desc);
    });
  }

  QueryBuilder<TransactionCollection, TransactionCollection, QAfterSortBy>
  sortBySettledAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(9);
    });
  }

  QueryBuilder<TransactionCollection, TransactionCollection, QAfterSortBy>
  sortBySettledAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(9, sort: Sort.desc);
    });
  }

  QueryBuilder<TransactionCollection, TransactionCollection, QAfterSortBy>
  sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(10);
    });
  }

  QueryBuilder<TransactionCollection, TransactionCollection, QAfterSortBy>
  sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(10, sort: Sort.desc);
    });
  }
}

extension TransactionCollectionQuerySortThenBy
    on QueryBuilder<TransactionCollection, TransactionCollection, QSortThenBy> {
  QueryBuilder<TransactionCollection, TransactionCollection, QAfterSortBy>
  thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(0);
    });
  }

  QueryBuilder<TransactionCollection, TransactionCollection, QAfterSortBy>
  thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(0, sort: Sort.desc);
    });
  }

  QueryBuilder<TransactionCollection, TransactionCollection, QAfterSortBy>
  thenByTransactionId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(1, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TransactionCollection, TransactionCollection, QAfterSortBy>
  thenByTransactionIdDesc({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(1, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TransactionCollection, TransactionCollection, QAfterSortBy>
  thenByFromMemberId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(2, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TransactionCollection, TransactionCollection, QAfterSortBy>
  thenByFromMemberIdDesc({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(2, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TransactionCollection, TransactionCollection, QAfterSortBy>
  thenByToMemberId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(3, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TransactionCollection, TransactionCollection, QAfterSortBy>
  thenByToMemberIdDesc({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(3, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TransactionCollection, TransactionCollection, QAfterSortBy>
  thenByAmount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(4);
    });
  }

  QueryBuilder<TransactionCollection, TransactionCollection, QAfterSortBy>
  thenByAmountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(4, sort: Sort.desc);
    });
  }

  QueryBuilder<TransactionCollection, TransactionCollection, QAfterSortBy>
  thenByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(5);
    });
  }

  QueryBuilder<TransactionCollection, TransactionCollection, QAfterSortBy>
  thenByDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(5, sort: Sort.desc);
    });
  }

  QueryBuilder<TransactionCollection, TransactionCollection, QAfterSortBy>
  thenByDescription({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(6, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TransactionCollection, TransactionCollection, QAfterSortBy>
  thenByDescriptionDesc({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(6, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TransactionCollection, TransactionCollection, QAfterSortBy>
  thenByNote({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(7, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TransactionCollection, TransactionCollection, QAfterSortBy>
  thenByNoteDesc({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(7, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TransactionCollection, TransactionCollection, QAfterSortBy>
  thenByIsSettled() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(8);
    });
  }

  QueryBuilder<TransactionCollection, TransactionCollection, QAfterSortBy>
  thenByIsSettledDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(8, sort: Sort.desc);
    });
  }

  QueryBuilder<TransactionCollection, TransactionCollection, QAfterSortBy>
  thenBySettledAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(9);
    });
  }

  QueryBuilder<TransactionCollection, TransactionCollection, QAfterSortBy>
  thenBySettledAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(9, sort: Sort.desc);
    });
  }

  QueryBuilder<TransactionCollection, TransactionCollection, QAfterSortBy>
  thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(10);
    });
  }

  QueryBuilder<TransactionCollection, TransactionCollection, QAfterSortBy>
  thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(10, sort: Sort.desc);
    });
  }
}

extension TransactionCollectionQueryWhereDistinct
    on QueryBuilder<TransactionCollection, TransactionCollection, QDistinct> {
  QueryBuilder<TransactionCollection, TransactionCollection, QAfterDistinct>
  distinctByTransactionId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(1, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TransactionCollection, TransactionCollection, QAfterDistinct>
  distinctByFromMemberId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(2, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TransactionCollection, TransactionCollection, QAfterDistinct>
  distinctByToMemberId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(3, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TransactionCollection, TransactionCollection, QAfterDistinct>
  distinctByAmount() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(4);
    });
  }

  QueryBuilder<TransactionCollection, TransactionCollection, QAfterDistinct>
  distinctByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(5);
    });
  }

  QueryBuilder<TransactionCollection, TransactionCollection, QAfterDistinct>
  distinctByDescription({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(6, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TransactionCollection, TransactionCollection, QAfterDistinct>
  distinctByNote({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(7, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TransactionCollection, TransactionCollection, QAfterDistinct>
  distinctByIsSettled() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(8);
    });
  }

  QueryBuilder<TransactionCollection, TransactionCollection, QAfterDistinct>
  distinctBySettledAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(9);
    });
  }

  QueryBuilder<TransactionCollection, TransactionCollection, QAfterDistinct>
  distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(10);
    });
  }
}

extension TransactionCollectionQueryProperty1
    on QueryBuilder<TransactionCollection, TransactionCollection, QProperty> {
  QueryBuilder<TransactionCollection, int, QAfterProperty> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(0);
    });
  }

  QueryBuilder<TransactionCollection, String, QAfterProperty>
  transactionIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(1);
    });
  }

  QueryBuilder<TransactionCollection, String, QAfterProperty>
  fromMemberIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(2);
    });
  }

  QueryBuilder<TransactionCollection, String, QAfterProperty>
  toMemberIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(3);
    });
  }

  QueryBuilder<TransactionCollection, double, QAfterProperty> amountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(4);
    });
  }

  QueryBuilder<TransactionCollection, DateTime, QAfterProperty> dateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(5);
    });
  }

  QueryBuilder<TransactionCollection, String?, QAfterProperty>
  descriptionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(6);
    });
  }

  QueryBuilder<TransactionCollection, String?, QAfterProperty> noteProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(7);
    });
  }

  QueryBuilder<TransactionCollection, bool, QAfterProperty>
  isSettledProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(8);
    });
  }

  QueryBuilder<TransactionCollection, DateTime?, QAfterProperty>
  settledAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(9);
    });
  }

  QueryBuilder<TransactionCollection, DateTime?, QAfterProperty>
  createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(10);
    });
  }
}

extension TransactionCollectionQueryProperty2<R>
    on QueryBuilder<TransactionCollection, R, QAfterProperty> {
  QueryBuilder<TransactionCollection, (R, int), QAfterProperty> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(0);
    });
  }

  QueryBuilder<TransactionCollection, (R, String), QAfterProperty>
  transactionIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(1);
    });
  }

  QueryBuilder<TransactionCollection, (R, String), QAfterProperty>
  fromMemberIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(2);
    });
  }

  QueryBuilder<TransactionCollection, (R, String), QAfterProperty>
  toMemberIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(3);
    });
  }

  QueryBuilder<TransactionCollection, (R, double), QAfterProperty>
  amountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(4);
    });
  }

  QueryBuilder<TransactionCollection, (R, DateTime), QAfterProperty>
  dateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(5);
    });
  }

  QueryBuilder<TransactionCollection, (R, String?), QAfterProperty>
  descriptionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(6);
    });
  }

  QueryBuilder<TransactionCollection, (R, String?), QAfterProperty>
  noteProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(7);
    });
  }

  QueryBuilder<TransactionCollection, (R, bool), QAfterProperty>
  isSettledProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(8);
    });
  }

  QueryBuilder<TransactionCollection, (R, DateTime?), QAfterProperty>
  settledAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(9);
    });
  }

  QueryBuilder<TransactionCollection, (R, DateTime?), QAfterProperty>
  createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(10);
    });
  }
}

extension TransactionCollectionQueryProperty3<R1, R2>
    on QueryBuilder<TransactionCollection, (R1, R2), QAfterProperty> {
  QueryBuilder<TransactionCollection, (R1, R2, int), QOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(0);
    });
  }

  QueryBuilder<TransactionCollection, (R1, R2, String), QOperations>
  transactionIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(1);
    });
  }

  QueryBuilder<TransactionCollection, (R1, R2, String), QOperations>
  fromMemberIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(2);
    });
  }

  QueryBuilder<TransactionCollection, (R1, R2, String), QOperations>
  toMemberIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(3);
    });
  }

  QueryBuilder<TransactionCollection, (R1, R2, double), QOperations>
  amountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(4);
    });
  }

  QueryBuilder<TransactionCollection, (R1, R2, DateTime), QOperations>
  dateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(5);
    });
  }

  QueryBuilder<TransactionCollection, (R1, R2, String?), QOperations>
  descriptionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(6);
    });
  }

  QueryBuilder<TransactionCollection, (R1, R2, String?), QOperations>
  noteProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(7);
    });
  }

  QueryBuilder<TransactionCollection, (R1, R2, bool), QOperations>
  isSettledProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(8);
    });
  }

  QueryBuilder<TransactionCollection, (R1, R2, DateTime?), QOperations>
  settledAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(9);
    });
  }

  QueryBuilder<TransactionCollection, (R1, R2, DateTime?), QOperations>
  createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(10);
    });
  }
}
