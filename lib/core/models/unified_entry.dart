import 'package:freezed_annotation/freezed_annotation.dart';

part 'unified_entry.freezed.dart';
part 'unified_entry.g.dart';

/// Entry type - auto-detected by NLP or user-selected
enum EntryType {
  mealBazar, // Divided by meal ratio
  monthly, // Divided equally (soap, tissue, etc.)
  fixed, // Fixed bills (rent, wifi, electricity)
}

/// Category for monthly/fixed entries
enum MonthlyCategory {
  rent,
  electricity,
  gas,
  wifi,
  water,
  maid,
  garbage,
  soap,
  tissue,
  toothpaste,
  filter,
  coil,
  other,
}

/// Unified entry model - single entry point for bazar and monthly
@freezed
sealed class UnifiedEntry with _$UnifiedEntry {
  const factory UnifiedEntry({
    required String id,
    required String memberId,
    required DateTime date,
    required double amount,
    String? description,
    @Default(EntryType.mealBazar) EntryType type,
    MonthlyCategory? monthlyCategory, // For monthly/fixed entries
    @Default([]) List<String> photoUrls,
    @Default([]) List<String> receiptUrls,
    @Default(true) bool isAutoDetected, // Was type auto-detected by NLP?
    @Default([]) List<UnifiedEntryItem> items, // For itemized entries
    DateTime? createdAt,
  }) = _UnifiedEntry;

  factory UnifiedEntry.fromJson(Map<String, dynamic> json) =>
      _$UnifiedEntryFromJson(json);
}

/// Individual item in an itemized entry
@freezed
sealed class UnifiedEntryItem with _$UnifiedEntryItem {
  const factory UnifiedEntryItem({
    required String name,
    required double price,
    EntryType? type, // Can have different types per item
    MonthlyCategory? category,
  }) = _UnifiedEntryItem;

  factory UnifiedEntryItem.fromJson(Map<String, dynamic> json) =>
      _$UnifiedEntryItemFromJson(json);
}
