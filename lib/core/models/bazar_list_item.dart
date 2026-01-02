import 'package:freezed_annotation/freezed_annotation.dart';

part 'bazar_list_item.freezed.dart';
part 'bazar_list_item.g.dart';

/// Status of a shopping list item
enum BazarListStatus { pending, claimed, purchased }

/// Shared shopping list item
@freezed
sealed class BazarListItem with _$BazarListItem {
  const factory BazarListItem({
    required String id,
    required String name,
    required String addedById,
    String? claimedById,
    @Default(BazarListStatus.pending) BazarListStatus status,
    String? quantity,
    String? note,
    DateTime? createdAt,
    DateTime? purchasedAt,
  }) = _BazarListItem;

  factory BazarListItem.fromJson(Map<String, dynamic> json) =>
      _$BazarListItemFromJson(json);
}
