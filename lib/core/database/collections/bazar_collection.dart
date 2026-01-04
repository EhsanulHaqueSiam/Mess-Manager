import 'dart:convert';
import 'package:isar_plus/isar_plus.dart';
import '../../models/bazar_entry.dart';

part 'bazar_collection.g.dart';

/// Isar collection for BazarEntry data
@collection
class BazarEntryCollection {
  late int id;

  @Index()
  late String entryId;

  @Index()
  late String memberId;

  @Index()
  late DateTime date;

  late double amount;

  String? description;

  /// Items stored as JSON string (List<BazarItem>)
  String? itemsJson;

  late bool isItemized;

  /// Photo URLs stored as JSON array
  String? photoUrlsJson;

  /// Receipt URLs stored as JSON array
  String? receiptUrlsJson;

  DateTime? createdAt;

  // ─────────────────────────────────────────────────────────────────────────
  // Model Converters
  // ─────────────────────────────────────────────────────────────────────────

  /// Convert to Freezed BazarEntry model
  BazarEntry toModel() {
    List<BazarItem> items = [];
    if (itemsJson != null && itemsJson!.isNotEmpty) {
      try {
        final List<dynamic> itemList = jsonDecode(itemsJson!);
        items = itemList
            .map((i) => BazarItem.fromJson(Map<String, dynamic>.from(i)))
            .toList();
      } catch (_) {}
    }

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

    return BazarEntry(
      id: entryId,
      memberId: memberId,
      date: date,
      amount: amount,
      description: description,
      items: items,
      isItemized: isItemized,
      photoUrls: photoUrls,
      receiptUrls: receiptUrls,
      createdAt: createdAt,
    );
  }

  /// Create from Freezed BazarEntry model
  static BazarEntryCollection fromModel(BazarEntry e) {
    String? itemsJson;
    if (e.items.isNotEmpty) {
      itemsJson = jsonEncode(e.items.map((i) => i.toJson()).toList());
    }

    String? photoJson;
    if (e.photoUrls.isNotEmpty) {
      photoJson = jsonEncode(e.photoUrls);
    }

    String? receiptJson;
    if (e.receiptUrls.isNotEmpty) {
      receiptJson = jsonEncode(e.receiptUrls);
    }

    return BazarEntryCollection()
      ..entryId = e.id
      ..memberId = e.memberId
      ..date = e.date
      ..amount = e.amount
      ..description = e.description
      ..itemsJson = itemsJson
      ..isItemized = e.isItemized
      ..photoUrlsJson = photoJson
      ..receiptUrlsJson = receiptJson
      ..createdAt = e.createdAt;
  }
}
