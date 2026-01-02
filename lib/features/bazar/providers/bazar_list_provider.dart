import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mess_manager/core/models/bazar_list_item.dart';

/// Sample shopping list items
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
  List<BazarListItem> build() => _generateSampleShoppingList();

  void addItem(BazarListItem item) {
    state = [...state, item];
  }

  void removeItem(String id) {
    state = state.where((i) => i.id != id).toList();
  }

  void claimItem(String id, String memberId) {
    state = [
      for (final item in state)
        if (item.id == id)
          item.copyWith(claimedById: memberId, status: BazarListStatus.claimed)
        else
          item,
    ];
  }

  void unclaimItem(String id) {
    state = [
      for (final item in state)
        if (item.id == id)
          item.copyWith(claimedById: null, status: BazarListStatus.pending)
        else
          item,
    ];
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
  }

  void clearPurchased() {
    state = state.where((i) => i.status != BazarListStatus.purchased).toList();
  }
}

/// Pending items count
final pendingItemsCountProvider = Provider<int>((ref) {
  final list = ref.watch(bazarListProvider);
  return list.where((i) => i.status == BazarListStatus.pending).length;
});
