// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_notification_collection.dart';

// **************************************************************************
// _IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, invalid_use_of_protected_member, lines_longer_than_80_chars, constant_identifier_names, avoid_js_rounded_ints, no_leading_underscores_for_local_identifiers, require_trailing_commas, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_in_if_null_operators, library_private_types_in_public_api, prefer_const_constructors
// ignore_for_file: type=lint

extension GetAppNotificationCollectionCollection on Isar {
  IsarCollection<int, AppNotificationCollection>
  get appNotificationCollections => this.collection();
}

final AppNotificationCollectionSchema = IsarGeneratedSchema(
  schema: IsarSchema(
    name: 'AppNotificationCollection',
    idName: 'id',
    embedded: false,
    properties: [
      IsarPropertySchema(name: 'notificationId', type: IsarType.string),
      IsarPropertySchema(name: 'title', type: IsarType.string),
      IsarPropertySchema(name: 'body', type: IsarType.string),
      IsarPropertySchema(name: 'type', type: IsarType.string),
      IsarPropertySchema(name: 'timestamp', type: IsarType.dateTime),
      IsarPropertySchema(name: 'isRead', type: IsarType.bool),
      IsarPropertySchema(name: 'payload', type: IsarType.string),
    ],
    indexes: [
      IsarIndexSchema(
        name: 'notificationId',
        properties: ["notificationId"],
        unique: true,
        hash: false,
      ),
      IsarIndexSchema(
        name: 'timestamp',
        properties: ["timestamp"],
        unique: false,
        hash: false,
      ),
    ],
  ),
  converter: IsarObjectConverter<int, AppNotificationCollection>(
    serialize: serializeAppNotificationCollection,
    deserialize: deserializeAppNotificationCollection,
    deserializeProperty: deserializeAppNotificationCollectionProp,
  ),
  getEmbeddedSchemas: () => [],
);

@isarProtected
int serializeAppNotificationCollection(
  IsarWriter writer,
  AppNotificationCollection object,
) {
  IsarCore.writeString(writer, 1, object.notificationId);
  IsarCore.writeString(writer, 2, object.title);
  IsarCore.writeString(writer, 3, object.body);
  IsarCore.writeString(writer, 4, object.type);
  IsarCore.writeLong(
    writer,
    5,
    object.timestamp.toUtc().microsecondsSinceEpoch,
  );
  IsarCore.writeBool(writer, 6, value: object.isRead);
  {
    final value = object.payload;
    if (value == null) {
      IsarCore.writeNull(writer, 7);
    } else {
      IsarCore.writeString(writer, 7, value);
    }
  }
  return object.id;
}

@isarProtected
AppNotificationCollection deserializeAppNotificationCollection(
  IsarReader reader,
) {
  final object = AppNotificationCollection();
  object.id = IsarCore.readId(reader);
  object.notificationId = IsarCore.readString(reader, 1) ?? '';
  object.title = IsarCore.readString(reader, 2) ?? '';
  object.body = IsarCore.readString(reader, 3) ?? '';
  object.type = IsarCore.readString(reader, 4) ?? '';
  {
    final value = IsarCore.readLong(reader, 5);
    if (value == -9223372036854775808) {
      object.timestamp = DateTime.fromMillisecondsSinceEpoch(
        0,
        isUtc: true,
      ).toLocal();
    } else {
      object.timestamp = DateTime.fromMicrosecondsSinceEpoch(
        value,
        isUtc: true,
      ).toLocal();
    }
  }
  object.isRead = IsarCore.readBool(reader, 6);
  object.payload = IsarCore.readString(reader, 7);
  return object;
}

@isarProtected
dynamic deserializeAppNotificationCollectionProp(
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
      return IsarCore.readString(reader, 4) ?? '';
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
      return IsarCore.readBool(reader, 6);
    case 7:
      return IsarCore.readString(reader, 7);
    default:
      throw ArgumentError('Unknown property: $property');
  }
}

sealed class _AppNotificationCollectionUpdate {
  bool call({
    required int id,
    String? notificationId,
    String? title,
    String? body,
    String? type,
    DateTime? timestamp,
    bool? isRead,
    String? payload,
  });
}

class _AppNotificationCollectionUpdateImpl
    implements _AppNotificationCollectionUpdate {
  const _AppNotificationCollectionUpdateImpl(this.collection);

  final IsarCollection<int, AppNotificationCollection> collection;

  @override
  bool call({
    required int id,
    Object? notificationId = ignore,
    Object? title = ignore,
    Object? body = ignore,
    Object? type = ignore,
    Object? timestamp = ignore,
    Object? isRead = ignore,
    Object? payload = ignore,
  }) {
    return collection.updateProperties(
          [id],
          {
            if (notificationId != ignore) 1: notificationId as String?,
            if (title != ignore) 2: title as String?,
            if (body != ignore) 3: body as String?,
            if (type != ignore) 4: type as String?,
            if (timestamp != ignore) 5: timestamp as DateTime?,
            if (isRead != ignore) 6: isRead as bool?,
            if (payload != ignore) 7: payload as String?,
          },
        ) >
        0;
  }
}

sealed class _AppNotificationCollectionUpdateAll {
  int call({
    required List<int> id,
    String? notificationId,
    String? title,
    String? body,
    String? type,
    DateTime? timestamp,
    bool? isRead,
    String? payload,
  });
}

class _AppNotificationCollectionUpdateAllImpl
    implements _AppNotificationCollectionUpdateAll {
  const _AppNotificationCollectionUpdateAllImpl(this.collection);

  final IsarCollection<int, AppNotificationCollection> collection;

  @override
  int call({
    required List<int> id,
    Object? notificationId = ignore,
    Object? title = ignore,
    Object? body = ignore,
    Object? type = ignore,
    Object? timestamp = ignore,
    Object? isRead = ignore,
    Object? payload = ignore,
  }) {
    return collection.updateProperties(id, {
      if (notificationId != ignore) 1: notificationId as String?,
      if (title != ignore) 2: title as String?,
      if (body != ignore) 3: body as String?,
      if (type != ignore) 4: type as String?,
      if (timestamp != ignore) 5: timestamp as DateTime?,
      if (isRead != ignore) 6: isRead as bool?,
      if (payload != ignore) 7: payload as String?,
    });
  }
}

extension AppNotificationCollectionUpdate
    on IsarCollection<int, AppNotificationCollection> {
  _AppNotificationCollectionUpdate get update =>
      _AppNotificationCollectionUpdateImpl(this);

  _AppNotificationCollectionUpdateAll get updateAll =>
      _AppNotificationCollectionUpdateAllImpl(this);
}

sealed class _AppNotificationCollectionQueryUpdate {
  int call({
    String? notificationId,
    String? title,
    String? body,
    String? type,
    DateTime? timestamp,
    bool? isRead,
    String? payload,
  });
}

class _AppNotificationCollectionQueryUpdateImpl
    implements _AppNotificationCollectionQueryUpdate {
  const _AppNotificationCollectionQueryUpdateImpl(this.query, {this.limit});

  final IsarQuery<AppNotificationCollection> query;
  final int? limit;

  @override
  int call({
    Object? notificationId = ignore,
    Object? title = ignore,
    Object? body = ignore,
    Object? type = ignore,
    Object? timestamp = ignore,
    Object? isRead = ignore,
    Object? payload = ignore,
  }) {
    return query.updateProperties(limit: limit, {
      if (notificationId != ignore) 1: notificationId as String?,
      if (title != ignore) 2: title as String?,
      if (body != ignore) 3: body as String?,
      if (type != ignore) 4: type as String?,
      if (timestamp != ignore) 5: timestamp as DateTime?,
      if (isRead != ignore) 6: isRead as bool?,
      if (payload != ignore) 7: payload as String?,
    });
  }
}

extension AppNotificationCollectionQueryUpdate
    on IsarQuery<AppNotificationCollection> {
  _AppNotificationCollectionQueryUpdate get updateFirst =>
      _AppNotificationCollectionQueryUpdateImpl(this, limit: 1);

  _AppNotificationCollectionQueryUpdate get updateAll =>
      _AppNotificationCollectionQueryUpdateImpl(this);
}

class _AppNotificationCollectionQueryBuilderUpdateImpl
    implements _AppNotificationCollectionQueryUpdate {
  const _AppNotificationCollectionQueryBuilderUpdateImpl(
    this.query, {
    this.limit,
  });

  final QueryBuilder<
    AppNotificationCollection,
    AppNotificationCollection,
    QOperations
  >
  query;
  final int? limit;

  @override
  int call({
    Object? notificationId = ignore,
    Object? title = ignore,
    Object? body = ignore,
    Object? type = ignore,
    Object? timestamp = ignore,
    Object? isRead = ignore,
    Object? payload = ignore,
  }) {
    final q = query.build();
    try {
      return q.updateProperties(limit: limit, {
        if (notificationId != ignore) 1: notificationId as String?,
        if (title != ignore) 2: title as String?,
        if (body != ignore) 3: body as String?,
        if (type != ignore) 4: type as String?,
        if (timestamp != ignore) 5: timestamp as DateTime?,
        if (isRead != ignore) 6: isRead as bool?,
        if (payload != ignore) 7: payload as String?,
      });
    } finally {
      q.close();
    }
  }
}

extension AppNotificationCollectionQueryBuilderUpdate
    on
        QueryBuilder<
          AppNotificationCollection,
          AppNotificationCollection,
          QOperations
        > {
  _AppNotificationCollectionQueryUpdate get updateFirst =>
      _AppNotificationCollectionQueryBuilderUpdateImpl(this, limit: 1);

  _AppNotificationCollectionQueryUpdate get updateAll =>
      _AppNotificationCollectionQueryBuilderUpdateImpl(this);
}

extension AppNotificationCollectionQueryFilter
    on
        QueryBuilder<
          AppNotificationCollection,
          AppNotificationCollection,
          QFilterCondition
        > {
  QueryBuilder<
    AppNotificationCollection,
    AppNotificationCollection,
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
    AppNotificationCollection,
    AppNotificationCollection,
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
    AppNotificationCollection,
    AppNotificationCollection,
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
    AppNotificationCollection,
    AppNotificationCollection,
    QAfterFilterCondition
  >
  idLessThan(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(LessCondition(property: 0, value: value));
    });
  }

  QueryBuilder<
    AppNotificationCollection,
    AppNotificationCollection,
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
    AppNotificationCollection,
    AppNotificationCollection,
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
    AppNotificationCollection,
    AppNotificationCollection,
    QAfterFilterCondition
  >
  notificationIdEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(property: 1, value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<
    AppNotificationCollection,
    AppNotificationCollection,
    QAfterFilterCondition
  >
  notificationIdGreaterThan(String value, {bool caseSensitive = true}) {
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
    AppNotificationCollection,
    AppNotificationCollection,
    QAfterFilterCondition
  >
  notificationIdGreaterThanOrEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
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
    AppNotificationCollection,
    AppNotificationCollection,
    QAfterFilterCondition
  >
  notificationIdLessThan(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(property: 1, value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<
    AppNotificationCollection,
    AppNotificationCollection,
    QAfterFilterCondition
  >
  notificationIdLessThanOrEqualTo(String value, {bool caseSensitive = true}) {
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
    AppNotificationCollection,
    AppNotificationCollection,
    QAfterFilterCondition
  >
  notificationIdBetween(
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
    AppNotificationCollection,
    AppNotificationCollection,
    QAfterFilterCondition
  >
  notificationIdStartsWith(String value, {bool caseSensitive = true}) {
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
    AppNotificationCollection,
    AppNotificationCollection,
    QAfterFilterCondition
  >
  notificationIdEndsWith(String value, {bool caseSensitive = true}) {
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
    AppNotificationCollection,
    AppNotificationCollection,
    QAfterFilterCondition
  >
  notificationIdContains(String value, {bool caseSensitive = true}) {
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
    AppNotificationCollection,
    AppNotificationCollection,
    QAfterFilterCondition
  >
  notificationIdMatches(String pattern, {bool caseSensitive = true}) {
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
    AppNotificationCollection,
    AppNotificationCollection,
    QAfterFilterCondition
  >
  notificationIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const EqualCondition(property: 1, value: ''),
      );
    });
  }

  QueryBuilder<
    AppNotificationCollection,
    AppNotificationCollection,
    QAfterFilterCondition
  >
  notificationIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const GreaterCondition(property: 1, value: ''),
      );
    });
  }

  QueryBuilder<
    AppNotificationCollection,
    AppNotificationCollection,
    QAfterFilterCondition
  >
  titleEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(property: 2, value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<
    AppNotificationCollection,
    AppNotificationCollection,
    QAfterFilterCondition
  >
  titleGreaterThan(String value, {bool caseSensitive = true}) {
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
    AppNotificationCollection,
    AppNotificationCollection,
    QAfterFilterCondition
  >
  titleGreaterThanOrEqualTo(String value, {bool caseSensitive = true}) {
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
    AppNotificationCollection,
    AppNotificationCollection,
    QAfterFilterCondition
  >
  titleLessThan(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(property: 2, value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<
    AppNotificationCollection,
    AppNotificationCollection,
    QAfterFilterCondition
  >
  titleLessThanOrEqualTo(String value, {bool caseSensitive = true}) {
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
    AppNotificationCollection,
    AppNotificationCollection,
    QAfterFilterCondition
  >
  titleBetween(String lower, String upper, {bool caseSensitive = true}) {
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
    AppNotificationCollection,
    AppNotificationCollection,
    QAfterFilterCondition
  >
  titleStartsWith(String value, {bool caseSensitive = true}) {
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
    AppNotificationCollection,
    AppNotificationCollection,
    QAfterFilterCondition
  >
  titleEndsWith(String value, {bool caseSensitive = true}) {
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
    AppNotificationCollection,
    AppNotificationCollection,
    QAfterFilterCondition
  >
  titleContains(String value, {bool caseSensitive = true}) {
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
    AppNotificationCollection,
    AppNotificationCollection,
    QAfterFilterCondition
  >
  titleMatches(String pattern, {bool caseSensitive = true}) {
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
    AppNotificationCollection,
    AppNotificationCollection,
    QAfterFilterCondition
  >
  titleIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const EqualCondition(property: 2, value: ''),
      );
    });
  }

  QueryBuilder<
    AppNotificationCollection,
    AppNotificationCollection,
    QAfterFilterCondition
  >
  titleIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const GreaterCondition(property: 2, value: ''),
      );
    });
  }

  QueryBuilder<
    AppNotificationCollection,
    AppNotificationCollection,
    QAfterFilterCondition
  >
  bodyEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(property: 3, value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<
    AppNotificationCollection,
    AppNotificationCollection,
    QAfterFilterCondition
  >
  bodyGreaterThan(String value, {bool caseSensitive = true}) {
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
    AppNotificationCollection,
    AppNotificationCollection,
    QAfterFilterCondition
  >
  bodyGreaterThanOrEqualTo(String value, {bool caseSensitive = true}) {
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
    AppNotificationCollection,
    AppNotificationCollection,
    QAfterFilterCondition
  >
  bodyLessThan(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(property: 3, value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<
    AppNotificationCollection,
    AppNotificationCollection,
    QAfterFilterCondition
  >
  bodyLessThanOrEqualTo(String value, {bool caseSensitive = true}) {
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
    AppNotificationCollection,
    AppNotificationCollection,
    QAfterFilterCondition
  >
  bodyBetween(String lower, String upper, {bool caseSensitive = true}) {
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
    AppNotificationCollection,
    AppNotificationCollection,
    QAfterFilterCondition
  >
  bodyStartsWith(String value, {bool caseSensitive = true}) {
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
    AppNotificationCollection,
    AppNotificationCollection,
    QAfterFilterCondition
  >
  bodyEndsWith(String value, {bool caseSensitive = true}) {
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
    AppNotificationCollection,
    AppNotificationCollection,
    QAfterFilterCondition
  >
  bodyContains(String value, {bool caseSensitive = true}) {
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
    AppNotificationCollection,
    AppNotificationCollection,
    QAfterFilterCondition
  >
  bodyMatches(String pattern, {bool caseSensitive = true}) {
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
    AppNotificationCollection,
    AppNotificationCollection,
    QAfterFilterCondition
  >
  bodyIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const EqualCondition(property: 3, value: ''),
      );
    });
  }

  QueryBuilder<
    AppNotificationCollection,
    AppNotificationCollection,
    QAfterFilterCondition
  >
  bodyIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const GreaterCondition(property: 3, value: ''),
      );
    });
  }

  QueryBuilder<
    AppNotificationCollection,
    AppNotificationCollection,
    QAfterFilterCondition
  >
  typeEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(property: 4, value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<
    AppNotificationCollection,
    AppNotificationCollection,
    QAfterFilterCondition
  >
  typeGreaterThan(String value, {bool caseSensitive = true}) {
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
    AppNotificationCollection,
    AppNotificationCollection,
    QAfterFilterCondition
  >
  typeGreaterThanOrEqualTo(String value, {bool caseSensitive = true}) {
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
    AppNotificationCollection,
    AppNotificationCollection,
    QAfterFilterCondition
  >
  typeLessThan(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(property: 4, value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<
    AppNotificationCollection,
    AppNotificationCollection,
    QAfterFilterCondition
  >
  typeLessThanOrEqualTo(String value, {bool caseSensitive = true}) {
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
    AppNotificationCollection,
    AppNotificationCollection,
    QAfterFilterCondition
  >
  typeBetween(String lower, String upper, {bool caseSensitive = true}) {
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
    AppNotificationCollection,
    AppNotificationCollection,
    QAfterFilterCondition
  >
  typeStartsWith(String value, {bool caseSensitive = true}) {
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
    AppNotificationCollection,
    AppNotificationCollection,
    QAfterFilterCondition
  >
  typeEndsWith(String value, {bool caseSensitive = true}) {
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
    AppNotificationCollection,
    AppNotificationCollection,
    QAfterFilterCondition
  >
  typeContains(String value, {bool caseSensitive = true}) {
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
    AppNotificationCollection,
    AppNotificationCollection,
    QAfterFilterCondition
  >
  typeMatches(String pattern, {bool caseSensitive = true}) {
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
    AppNotificationCollection,
    AppNotificationCollection,
    QAfterFilterCondition
  >
  typeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const EqualCondition(property: 4, value: ''),
      );
    });
  }

  QueryBuilder<
    AppNotificationCollection,
    AppNotificationCollection,
    QAfterFilterCondition
  >
  typeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const GreaterCondition(property: 4, value: ''),
      );
    });
  }

  QueryBuilder<
    AppNotificationCollection,
    AppNotificationCollection,
    QAfterFilterCondition
  >
  timestampEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(property: 5, value: value),
      );
    });
  }

  QueryBuilder<
    AppNotificationCollection,
    AppNotificationCollection,
    QAfterFilterCondition
  >
  timestampGreaterThan(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(property: 5, value: value),
      );
    });
  }

  QueryBuilder<
    AppNotificationCollection,
    AppNotificationCollection,
    QAfterFilterCondition
  >
  timestampGreaterThanOrEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(property: 5, value: value),
      );
    });
  }

  QueryBuilder<
    AppNotificationCollection,
    AppNotificationCollection,
    QAfterFilterCondition
  >
  timestampLessThan(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(LessCondition(property: 5, value: value));
    });
  }

  QueryBuilder<
    AppNotificationCollection,
    AppNotificationCollection,
    QAfterFilterCondition
  >
  timestampLessThanOrEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(property: 5, value: value),
      );
    });
  }

  QueryBuilder<
    AppNotificationCollection,
    AppNotificationCollection,
    QAfterFilterCondition
  >
  timestampBetween(DateTime lower, DateTime upper) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(property: 5, lower: lower, upper: upper),
      );
    });
  }

  QueryBuilder<
    AppNotificationCollection,
    AppNotificationCollection,
    QAfterFilterCondition
  >
  isReadEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(property: 6, value: value),
      );
    });
  }

  QueryBuilder<
    AppNotificationCollection,
    AppNotificationCollection,
    QAfterFilterCondition
  >
  payloadIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const IsNullCondition(property: 7));
    });
  }

  QueryBuilder<
    AppNotificationCollection,
    AppNotificationCollection,
    QAfterFilterCondition
  >
  payloadIsNotNull() {
    return QueryBuilder.apply(not(), (query) {
      return query.addFilterCondition(const IsNullCondition(property: 7));
    });
  }

  QueryBuilder<
    AppNotificationCollection,
    AppNotificationCollection,
    QAfterFilterCondition
  >
  payloadEqualTo(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(property: 7, value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<
    AppNotificationCollection,
    AppNotificationCollection,
    QAfterFilterCondition
  >
  payloadGreaterThan(String? value, {bool caseSensitive = true}) {
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
    AppNotificationCollection,
    AppNotificationCollection,
    QAfterFilterCondition
  >
  payloadGreaterThanOrEqualTo(String? value, {bool caseSensitive = true}) {
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
    AppNotificationCollection,
    AppNotificationCollection,
    QAfterFilterCondition
  >
  payloadLessThan(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(property: 7, value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<
    AppNotificationCollection,
    AppNotificationCollection,
    QAfterFilterCondition
  >
  payloadLessThanOrEqualTo(String? value, {bool caseSensitive = true}) {
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
    AppNotificationCollection,
    AppNotificationCollection,
    QAfterFilterCondition
  >
  payloadBetween(String? lower, String? upper, {bool caseSensitive = true}) {
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
    AppNotificationCollection,
    AppNotificationCollection,
    QAfterFilterCondition
  >
  payloadStartsWith(String value, {bool caseSensitive = true}) {
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
    AppNotificationCollection,
    AppNotificationCollection,
    QAfterFilterCondition
  >
  payloadEndsWith(String value, {bool caseSensitive = true}) {
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
    AppNotificationCollection,
    AppNotificationCollection,
    QAfterFilterCondition
  >
  payloadContains(String value, {bool caseSensitive = true}) {
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
    AppNotificationCollection,
    AppNotificationCollection,
    QAfterFilterCondition
  >
  payloadMatches(String pattern, {bool caseSensitive = true}) {
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
    AppNotificationCollection,
    AppNotificationCollection,
    QAfterFilterCondition
  >
  payloadIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const EqualCondition(property: 7, value: ''),
      );
    });
  }

  QueryBuilder<
    AppNotificationCollection,
    AppNotificationCollection,
    QAfterFilterCondition
  >
  payloadIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const GreaterCondition(property: 7, value: ''),
      );
    });
  }
}

extension AppNotificationCollectionQueryObject
    on
        QueryBuilder<
          AppNotificationCollection,
          AppNotificationCollection,
          QFilterCondition
        > {}

extension AppNotificationCollectionQuerySortBy
    on
        QueryBuilder<
          AppNotificationCollection,
          AppNotificationCollection,
          QSortBy
        > {
  QueryBuilder<
    AppNotificationCollection,
    AppNotificationCollection,
    QAfterSortBy
  >
  sortById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(0);
    });
  }

  QueryBuilder<
    AppNotificationCollection,
    AppNotificationCollection,
    QAfterSortBy
  >
  sortByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(0, sort: Sort.desc);
    });
  }

  QueryBuilder<
    AppNotificationCollection,
    AppNotificationCollection,
    QAfterSortBy
  >
  sortByNotificationId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(1, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<
    AppNotificationCollection,
    AppNotificationCollection,
    QAfterSortBy
  >
  sortByNotificationIdDesc({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(1, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<
    AppNotificationCollection,
    AppNotificationCollection,
    QAfterSortBy
  >
  sortByTitle({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(2, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<
    AppNotificationCollection,
    AppNotificationCollection,
    QAfterSortBy
  >
  sortByTitleDesc({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(2, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<
    AppNotificationCollection,
    AppNotificationCollection,
    QAfterSortBy
  >
  sortByBody({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(3, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<
    AppNotificationCollection,
    AppNotificationCollection,
    QAfterSortBy
  >
  sortByBodyDesc({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(3, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<
    AppNotificationCollection,
    AppNotificationCollection,
    QAfterSortBy
  >
  sortByType({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(4, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<
    AppNotificationCollection,
    AppNotificationCollection,
    QAfterSortBy
  >
  sortByTypeDesc({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(4, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<
    AppNotificationCollection,
    AppNotificationCollection,
    QAfterSortBy
  >
  sortByTimestamp() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(5);
    });
  }

  QueryBuilder<
    AppNotificationCollection,
    AppNotificationCollection,
    QAfterSortBy
  >
  sortByTimestampDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(5, sort: Sort.desc);
    });
  }

  QueryBuilder<
    AppNotificationCollection,
    AppNotificationCollection,
    QAfterSortBy
  >
  sortByIsRead() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(6);
    });
  }

  QueryBuilder<
    AppNotificationCollection,
    AppNotificationCollection,
    QAfterSortBy
  >
  sortByIsReadDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(6, sort: Sort.desc);
    });
  }

  QueryBuilder<
    AppNotificationCollection,
    AppNotificationCollection,
    QAfterSortBy
  >
  sortByPayload({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(7, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<
    AppNotificationCollection,
    AppNotificationCollection,
    QAfterSortBy
  >
  sortByPayloadDesc({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(7, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }
}

extension AppNotificationCollectionQuerySortThenBy
    on
        QueryBuilder<
          AppNotificationCollection,
          AppNotificationCollection,
          QSortThenBy
        > {
  QueryBuilder<
    AppNotificationCollection,
    AppNotificationCollection,
    QAfterSortBy
  >
  thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(0);
    });
  }

  QueryBuilder<
    AppNotificationCollection,
    AppNotificationCollection,
    QAfterSortBy
  >
  thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(0, sort: Sort.desc);
    });
  }

  QueryBuilder<
    AppNotificationCollection,
    AppNotificationCollection,
    QAfterSortBy
  >
  thenByNotificationId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(1, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<
    AppNotificationCollection,
    AppNotificationCollection,
    QAfterSortBy
  >
  thenByNotificationIdDesc({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(1, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<
    AppNotificationCollection,
    AppNotificationCollection,
    QAfterSortBy
  >
  thenByTitle({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(2, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<
    AppNotificationCollection,
    AppNotificationCollection,
    QAfterSortBy
  >
  thenByTitleDesc({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(2, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<
    AppNotificationCollection,
    AppNotificationCollection,
    QAfterSortBy
  >
  thenByBody({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(3, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<
    AppNotificationCollection,
    AppNotificationCollection,
    QAfterSortBy
  >
  thenByBodyDesc({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(3, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<
    AppNotificationCollection,
    AppNotificationCollection,
    QAfterSortBy
  >
  thenByType({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(4, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<
    AppNotificationCollection,
    AppNotificationCollection,
    QAfterSortBy
  >
  thenByTypeDesc({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(4, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<
    AppNotificationCollection,
    AppNotificationCollection,
    QAfterSortBy
  >
  thenByTimestamp() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(5);
    });
  }

  QueryBuilder<
    AppNotificationCollection,
    AppNotificationCollection,
    QAfterSortBy
  >
  thenByTimestampDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(5, sort: Sort.desc);
    });
  }

  QueryBuilder<
    AppNotificationCollection,
    AppNotificationCollection,
    QAfterSortBy
  >
  thenByIsRead() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(6);
    });
  }

  QueryBuilder<
    AppNotificationCollection,
    AppNotificationCollection,
    QAfterSortBy
  >
  thenByIsReadDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(6, sort: Sort.desc);
    });
  }

  QueryBuilder<
    AppNotificationCollection,
    AppNotificationCollection,
    QAfterSortBy
  >
  thenByPayload({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(7, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<
    AppNotificationCollection,
    AppNotificationCollection,
    QAfterSortBy
  >
  thenByPayloadDesc({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(7, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }
}

extension AppNotificationCollectionQueryWhereDistinct
    on
        QueryBuilder<
          AppNotificationCollection,
          AppNotificationCollection,
          QDistinct
        > {
  QueryBuilder<
    AppNotificationCollection,
    AppNotificationCollection,
    QAfterDistinct
  >
  distinctByNotificationId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(1, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<
    AppNotificationCollection,
    AppNotificationCollection,
    QAfterDistinct
  >
  distinctByTitle({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(2, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<
    AppNotificationCollection,
    AppNotificationCollection,
    QAfterDistinct
  >
  distinctByBody({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(3, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<
    AppNotificationCollection,
    AppNotificationCollection,
    QAfterDistinct
  >
  distinctByType({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(4, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<
    AppNotificationCollection,
    AppNotificationCollection,
    QAfterDistinct
  >
  distinctByTimestamp() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(5);
    });
  }

  QueryBuilder<
    AppNotificationCollection,
    AppNotificationCollection,
    QAfterDistinct
  >
  distinctByIsRead() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(6);
    });
  }

  QueryBuilder<
    AppNotificationCollection,
    AppNotificationCollection,
    QAfterDistinct
  >
  distinctByPayload({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(7, caseSensitive: caseSensitive);
    });
  }
}

extension AppNotificationCollectionQueryProperty1
    on
        QueryBuilder<
          AppNotificationCollection,
          AppNotificationCollection,
          QProperty
        > {
  QueryBuilder<AppNotificationCollection, int, QAfterProperty> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(0);
    });
  }

  QueryBuilder<AppNotificationCollection, String, QAfterProperty>
  notificationIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(1);
    });
  }

  QueryBuilder<AppNotificationCollection, String, QAfterProperty>
  titleProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(2);
    });
  }

  QueryBuilder<AppNotificationCollection, String, QAfterProperty>
  bodyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(3);
    });
  }

  QueryBuilder<AppNotificationCollection, String, QAfterProperty>
  typeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(4);
    });
  }

  QueryBuilder<AppNotificationCollection, DateTime, QAfterProperty>
  timestampProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(5);
    });
  }

  QueryBuilder<AppNotificationCollection, bool, QAfterProperty>
  isReadProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(6);
    });
  }

  QueryBuilder<AppNotificationCollection, String?, QAfterProperty>
  payloadProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(7);
    });
  }
}

extension AppNotificationCollectionQueryProperty2<R>
    on QueryBuilder<AppNotificationCollection, R, QAfterProperty> {
  QueryBuilder<AppNotificationCollection, (R, int), QAfterProperty>
  idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(0);
    });
  }

  QueryBuilder<AppNotificationCollection, (R, String), QAfterProperty>
  notificationIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(1);
    });
  }

  QueryBuilder<AppNotificationCollection, (R, String), QAfterProperty>
  titleProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(2);
    });
  }

  QueryBuilder<AppNotificationCollection, (R, String), QAfterProperty>
  bodyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(3);
    });
  }

  QueryBuilder<AppNotificationCollection, (R, String), QAfterProperty>
  typeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(4);
    });
  }

  QueryBuilder<AppNotificationCollection, (R, DateTime), QAfterProperty>
  timestampProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(5);
    });
  }

  QueryBuilder<AppNotificationCollection, (R, bool), QAfterProperty>
  isReadProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(6);
    });
  }

  QueryBuilder<AppNotificationCollection, (R, String?), QAfterProperty>
  payloadProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(7);
    });
  }
}

extension AppNotificationCollectionQueryProperty3<R1, R2>
    on QueryBuilder<AppNotificationCollection, (R1, R2), QAfterProperty> {
  QueryBuilder<AppNotificationCollection, (R1, R2, int), QOperations>
  idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(0);
    });
  }

  QueryBuilder<AppNotificationCollection, (R1, R2, String), QOperations>
  notificationIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(1);
    });
  }

  QueryBuilder<AppNotificationCollection, (R1, R2, String), QOperations>
  titleProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(2);
    });
  }

  QueryBuilder<AppNotificationCollection, (R1, R2, String), QOperations>
  bodyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(3);
    });
  }

  QueryBuilder<AppNotificationCollection, (R1, R2, String), QOperations>
  typeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(4);
    });
  }

  QueryBuilder<AppNotificationCollection, (R1, R2, DateTime), QOperations>
  timestampProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(5);
    });
  }

  QueryBuilder<AppNotificationCollection, (R1, R2, bool), QOperations>
  isReadProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(6);
    });
  }

  QueryBuilder<AppNotificationCollection, (R1, R2, String?), QOperations>
  payloadProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(7);
    });
  }
}
