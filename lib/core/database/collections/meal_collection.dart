import 'dart:convert';
import 'package:isar_plus/isar_plus.dart';
import '../../models/meal.dart';

part 'meal_collection.g.dart';

/// Isar collection for Meal data
@collection
class MealCollection {
  late int id;

  @Index()
  late String mealId;

  @Index()
  late String memberId;

  @Index()
  late DateTime date;

  late int count;

  /// MealType stored as int (0=breakfast, 1=lunch, 2=dinner)
  late int typeIndex;

  /// MealStatus stored as int (0=scheduled, 1=confirmed, 2=cancelled)
  late int statusIndex;

  late bool isFromSchedule;

  late int guestCount;
  String? guestName;

  /// JSON array of member IDs for shared guests
  String? sharedWithMemberIdsJson;

  String? note;
  DateTime? createdAt;

  // ─────────────────────────────────────────────────────────────────────────
  // Model Converters
  // ─────────────────────────────────────────────────────────────────────────

  /// Convert to Freezed Meal model
  Meal toModel() {
    List<String> sharedWith = [];
    if (sharedWithMemberIdsJson != null &&
        sharedWithMemberIdsJson!.isNotEmpty) {
      try {
        sharedWith = List<String>.from(jsonDecode(sharedWithMemberIdsJson!));
      } catch (_) {}
    }

    return Meal(
      id: mealId,
      memberId: memberId,
      date: date,
      count: count,
      type: MealType.values[typeIndex],
      status: MealStatus.values[statusIndex],
      isFromSchedule: isFromSchedule,
      guestCount: guestCount,
      guestName: guestName,
      sharedWithMemberIds: sharedWith,
      note: note,
      createdAt: createdAt,
    );
  }

  /// Create from Freezed Meal model
  static MealCollection fromModel(Meal m) {
    String? sharedJson;
    if (m.sharedWithMemberIds.isNotEmpty) {
      sharedJson = jsonEncode(m.sharedWithMemberIds);
    }

    return MealCollection()
      ..mealId = m.id
      ..memberId = m.memberId
      ..date = m.date
      ..count = m.count
      ..typeIndex = m.type.index
      ..statusIndex = m.status.index
      ..isFromSchedule = m.isFromSchedule
      ..guestCount = m.guestCount
      ..guestName = m.guestName
      ..sharedWithMemberIdsJson = sharedJson
      ..note = m.note
      ..createdAt = m.createdAt;
  }
}
