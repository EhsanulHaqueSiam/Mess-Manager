import 'dart:convert';
import 'package:isar_plus/isar_plus.dart';
import '../../models/ramadan.dart';

part 'ramadan_collection.g.dart';

/// Isar collection for RamadanSeason data
@collection
class RamadanSeasonCollection {
  late int id;

  @Index()
  late String seasonId;

  late String messId;

  late DateTime startDate;

  late DateTime endDate;

  late int year;

  /// Opted-in member IDs as JSON array
  late String optedInMemberIdsJson;

  late bool isActive;

  late bool isSettled;

  DateTime? createdAt;

  // ─────────────────────────────────────────────────────────────────────────
  // Model Converters
  // ─────────────────────────────────────────────────────────────────────────

  RamadanSeason toModel() {
    List<String> optedInMemberIds = [];
    try {
      optedInMemberIds = List<String>.from(jsonDecode(optedInMemberIdsJson));
    } catch (_) {}

    return RamadanSeason(
      id: seasonId,
      messId: messId,
      startDate: startDate,
      endDate: endDate,
      year: year,
      optedInMemberIds: optedInMemberIds,
      isActive: isActive,
      isSettled: isSettled,
      createdAt: createdAt,
    );
  }

  static RamadanSeasonCollection fromModel(RamadanSeason s) {
    return RamadanSeasonCollection()
      ..seasonId = s.id
      ..messId = s.messId
      ..startDate = s.startDate
      ..endDate = s.endDate
      ..year = s.year
      ..optedInMemberIdsJson = jsonEncode(s.optedInMemberIds)
      ..isActive = s.isActive
      ..isSettled = s.isSettled
      ..createdAt = s.createdAt;
  }
}

/// Isar collection for RamadanMeal data
@collection
class RamadanMealCollection {
  late int id;

  @Index()
  late String mealId;

  @Index()
  late String seasonId;

  @Index()
  late String memberId;

  late DateTime date;

  /// RamadanMealType as int index
  late int typeIndex;

  late int count;

  String? guestName;

  DateTime? createdAt;

  // ─────────────────────────────────────────────────────────────────────────
  // Model Converters
  // ─────────────────────────────────────────────────────────────────────────

  RamadanMeal toModel() {
    return RamadanMeal(
      id: mealId,
      seasonId: seasonId,
      memberId: memberId,
      date: date,
      type: RamadanMealType.values[typeIndex],
      count: count,
      guestName: guestName,
      createdAt: createdAt,
    );
  }

  static RamadanMealCollection fromModel(RamadanMeal m) {
    return RamadanMealCollection()
      ..mealId = m.id
      ..seasonId = m.seasonId
      ..memberId = m.memberId
      ..date = m.date
      ..typeIndex = m.type.index
      ..count = m.count
      ..guestName = m.guestName
      ..createdAt = m.createdAt;
  }
}

/// Isar collection for RamadanBazar data
@collection
class RamadanBazarCollection {
  late int id;

  @Index()
  late String bazarId;

  @Index()
  late String seasonId;

  @Index()
  late String memberId;

  late DateTime date;

  late double amount;

  String? description;

  late bool isForSehri;

  DateTime? createdAt;

  // ─────────────────────────────────────────────────────────────────────────
  // Model Converters
  // ─────────────────────────────────────────────────────────────────────────

  RamadanBazar toModel() {
    return RamadanBazar(
      id: bazarId,
      seasonId: seasonId,
      memberId: memberId,
      date: date,
      amount: amount,
      description: description,
      isForSehri: isForSehri,
      createdAt: createdAt,
    );
  }

  static RamadanBazarCollection fromModel(RamadanBazar b) {
    return RamadanBazarCollection()
      ..bazarId = b.id
      ..seasonId = b.seasonId
      ..memberId = b.memberId
      ..date = b.date
      ..amount = b.amount
      ..description = b.description
      ..isForSehri = b.isForSehri
      ..createdAt = b.createdAt;
  }
}
