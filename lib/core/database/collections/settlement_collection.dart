import 'dart:convert';
import 'package:isar_plus/isar_plus.dart';
import '../../models/settlement.dart';

part 'settlement_collection.g.dart';

/// Isar collection for Settlement data
@collection
class SettlementCollection {
  late int id;

  @Index()
  late String settlementId;

  late String messId;

  @Index()
  late int year;

  @Index()
  late int month;

  late DateTime calculatedAt;

  /// SettlementItems as JSON array
  late String itemsJson;

  /// SettlementStatus as int index
  late int statusIndex;

  DateTime? settledAt;

  // ─────────────────────────────────────────────────────────────────────────
  // Model Converters
  // ─────────────────────────────────────────────────────────────────────────

  Settlement toModel() {
    List<SettlementItem> items = [];
    try {
      final List<dynamic> itemList = jsonDecode(itemsJson);
      items = itemList
          .map((i) => SettlementItem.fromJson(Map<String, dynamic>.from(i)))
          .toList();
    } catch (_) {}

    return Settlement(
      id: settlementId,
      messId: messId,
      year: year,
      month: month,
      calculatedAt: calculatedAt,
      items: items,
      status: SettlementStatus.values[statusIndex],
      settledAt: settledAt,
    );
  }

  static SettlementCollection fromModel(Settlement s) {
    return SettlementCollection()
      ..settlementId = s.id
      ..messId = s.messId
      ..year = s.year
      ..month = s.month
      ..calculatedAt = s.calculatedAt
      ..itemsJson = jsonEncode(s.items.map((i) => i.toJson()).toList())
      ..statusIndex = s.status.index
      ..settledAt = s.settledAt;
  }
}
