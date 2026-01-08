import 'package:freezed_annotation/freezed_annotation.dart';

part 'bazar_entry.freezed.dart';
part 'bazar_entry.g.dart';

/// Individual item in an itemized bazar entry
@freezed
sealed class BazarItem with _$BazarItem {
  const factory BazarItem({
    required String name,
    required double price,
    String? quantity,
    String? unit,
  }) = _BazarItem;

  factory BazarItem.fromJson(Map<String, dynamic> json) =>
      _$BazarItemFromJson(json);
}

/// Bazar expense entry
@freezed
sealed class BazarEntry with _$BazarEntry {
  @JsonSerializable(explicitToJson: true)
  const factory BazarEntry({
    required String id,
    required String memberId,
    required DateTime date,
    required double amount,
    String? description,
    @Default([]) List<BazarItem> items, // For itemized entries
    @Default(false) bool isItemized,
    @Default([]) List<String> photoUrls, // Bazar photos (multiple)
    @Default([]) List<String> receiptUrls, // Receipt images (separate section)
    DateTime? createdAt,
  }) = _BazarEntry;

  factory BazarEntry.fromJson(Map<String, dynamic> json) =>
      _$BazarEntryFromJson(json);
}
