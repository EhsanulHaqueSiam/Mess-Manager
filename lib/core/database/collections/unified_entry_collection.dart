import 'dart:convert';
import 'package:isar_plus/isar_plus.dart';
import '../../models/unified_entry.dart';

part 'unified_entry_collection.g.dart';

/// Isar collection for UnifiedEntry data
@collection
class UnifiedEntryCollection {
  late int id;

  @Index()
  late String entryId;

  @Index()
  late String memberId;

  @Index()
  late DateTime date;

  late double amount;

  String? description;

  /// EntryType as int index
  late int typeIndex;

  /// MonthlyCategory as int index (-1 if null)
  late int monthlyCategoryIndex;

  /// Photo URLs as JSON array
  String? photoUrlsJson;

  /// Receipt URLs as JSON array
  String? receiptUrlsJson;

  late bool isAutoDetected;

  /// Items as JSON array
  String? itemsJson;

  DateTime? createdAt;

  // ─────────────────────────────────────────────────────────────────────────
  // Model Converters
  // ─────────────────────────────────────────────────────────────────────────

  UnifiedEntry toModel() {
    List<String> photoUrls = [];
    if (photoUrlsJson != null && photoUrlsJson!.isNotEmpty) {
      try {
        photoUrls = List<String>.from(jsonDecode(photoUrlsJson!));
      } catch (_) {}
    }

    List<String> receiptUrls = [];
    if (receiptUrlsJson != null && receiptUrlsJson!.isNotEmpty) {
      try {
        receiptUrls = List<String>.from(jsonDecode(receiptUrlsJson!));
      } catch (_) {}
    }

    List<UnifiedEntryItem> items = [];
    if (itemsJson != null && itemsJson!.isNotEmpty) {
      try {
        final List<dynamic> itemList = jsonDecode(itemsJson!);
        items = itemList
            .map((i) => UnifiedEntryItem.fromJson(Map<String, dynamic>.from(i)))
            .toList();
      } catch (_) {}
    }

    return UnifiedEntry(
      id: entryId,
      memberId: memberId,
      date: date,
      amount: amount,
      description: description,
      type: EntryType.values[typeIndex],
      monthlyCategory: monthlyCategoryIndex >= 0
          ? MonthlyCategory.values[monthlyCategoryIndex]
          : null,
      photoUrls: photoUrls,
      receiptUrls: receiptUrls,
      isAutoDetected: isAutoDetected,
      items: items,
      createdAt: createdAt,
    );
  }

  static UnifiedEntryCollection fromModel(UnifiedEntry e) {
    String? photoJson;
    if (e.photoUrls.isNotEmpty) {
      photoJson = jsonEncode(e.photoUrls);
    }

    String? receiptJson;
    if (e.receiptUrls.isNotEmpty) {
      receiptJson = jsonEncode(e.receiptUrls);
    }

    String? itemsJson;
    if (e.items.isNotEmpty) {
      itemsJson = jsonEncode(e.items.map((i) => i.toJson()).toList());
    }

    return UnifiedEntryCollection()
      ..entryId = e.id
      ..memberId = e.memberId
      ..date = e.date
      ..amount = e.amount
      ..description = e.description
      ..typeIndex = e.type.index
      ..monthlyCategoryIndex = e.monthlyCategory?.index ?? -1
      ..photoUrlsJson = photoJson
      ..receiptUrlsJson = receiptJson
      ..isAutoDetected = e.isAutoDetected
      ..itemsJson = itemsJson
      ..createdAt = e.createdAt;
  }
}
