import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mess_manager/core/models/bazar_list_item.dart';
import 'package:mess_manager/core/database/isar_service.dart';

const _bazarListKey = 'bazar_shopping_list';

/// Sample shopping list items (used only for first-time setup)
List<BazarListItem> _generateSampleShoppingList() {
  final now = DateTime.now();
  return [
    BazarListItem(
      id: 'list_1',
      name: 'Rice (25kg bag)',
      addedById: '2', // Tanmoy
      status: BazarListStatus.pending,
      createdAt: now.subtract(const Duration(hours: 5)),
    ),
    BazarListItem(
      id: 'list_2',
      name: 'Fish 2kg',
      addedById: '3', // Sarkar
      claimedById: '1', // Siam will get it
      status: BazarListStatus.claimed,
      createdAt: now.subtract(const Duration(hours: 3)),
    ),
    BazarListItem(
      id: 'list_3',
      name: 'Cooking Oil',
      addedById: '1', // Siam
      status: BazarListStatus.pending,
      quantity: '5 liters',
      createdAt: now.subtract(const Duration(hours: 1)),
    ),
  ];
}

/// Provider for shared shopping list
final bazarListProvider =
    NotifierProvider<BazarListNotifier, List<BazarListItem>>(
      BazarListNotifier.new,
    );

class BazarListNotifier extends Notifier<List<BazarListItem>> {
  @override
  List<BazarListItem> build() {
    // Load from Isar
    final savedData = IsarService.getSetting<List<dynamic>>(_bazarListKey);
    if (savedData != null && savedData.isNotEmpty) {
      try {
        return savedData
            .map(
              (item) => BazarListItem.fromJson(Map<String, dynamic>.from(item)),
            )
            .toList();
      } catch (_) {
        // Fall back to sample if parsing fails
      }
    }
    // First time setup - use sample data
    final sample = _generateSampleShoppingList();
    _saveList(sample);
    return sample;
  }

  void _save() {
    _saveList(state);
  }

  static void _saveList(List<BazarListItem> items) {
    IsarService.saveSetting(
      _bazarListKey,
      items.map((i) => i.toJson()).toList(),
    );
  }

  void addItem(BazarListItem item) {
    state = [...state, item];
    _save();
  }

  void removeItem(String id) {
    state = state.where((i) => i.id != id).toList();
    _save();
  }

  void claimItem(String id, String memberId) {
    state = [
      for (final item in state)
        if (item.id == id)
          item.copyWith(claimedById: memberId, status: BazarListStatus.claimed)
        else
          item,
    ];
    _save();
  }

  void unclaimItem(String id) {
    state = [
      for (final item in state)
        if (item.id == id)
          item.copyWith(claimedById: null, status: BazarListStatus.pending)
        else
          item,
    ];
    _save();
  }

  void markPurchased(String id) {
    state = [
      for (final item in state)
        if (item.id == id)
          item.copyWith(
            status: BazarListStatus.purchased,
            purchasedAt: DateTime.now(),
          )
        else
          item,
    ];
    _save();
  }

  void clearPurchased() {
    state = state.where((i) => i.status != BazarListStatus.purchased).toList();
    _save();
  }

  void updateItem(BazarListItem item) {
    state = [
      for (final i in state)
        if (i.id == item.id) item else i,
    ];
    _save();
  }
}

/// Pending items count
final pendingItemsCountProvider = Provider<int>((ref) {
  final list = ref.watch(bazarListProvider);
  return list.where((i) => i.status == BazarListStatus.pending).length;
});
