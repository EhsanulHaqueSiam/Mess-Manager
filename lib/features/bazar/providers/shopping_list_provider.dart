/// Shopping List Provider - Firestore-Synced Shopping List
///
/// Allows mess members to collaboratively manage a shopping list
/// that syncs to Firestore in real-time.
library;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mess_manager/core/database/isar_service.dart';

/// Shopping list item model
class ShoppingItem {
  final String id;
  final String name;
  final String? quantity;
  final String? unit;
  final String? category;
  final bool isCompleted;
  final String? addedBy;
  final DateTime createdAt;
  final String? completedBy;
  final DateTime? completedAt;

  const ShoppingItem({
    required this.id,
    required this.name,
    this.quantity,
    this.unit,
    this.category,
    this.isCompleted = false,
    this.addedBy,
    required this.createdAt,
    this.completedBy,
    this.completedAt,
  });

  ShoppingItem copyWith({
    String? id,
    String? name,
    String? quantity,
    String? unit,
    String? category,
    bool? isCompleted,
    String? addedBy,
    DateTime? createdAt,
    String? completedBy,
    DateTime? completedAt,
  }) {
    return ShoppingItem(
      id: id ?? this.id,
      name: name ?? this.name,
      quantity: quantity ?? this.quantity,
      unit: unit ?? this.unit,
      category: category ?? this.category,
      isCompleted: isCompleted ?? this.isCompleted,
      addedBy: addedBy ?? this.addedBy,
      createdAt: createdAt ?? this.createdAt,
      completedBy: completedBy ?? this.completedBy,
      completedAt: completedAt ?? this.completedAt,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'quantity': quantity,
    'unit': unit,
    'category': category,
    'isCompleted': isCompleted,
    'addedBy': addedBy,
    'createdAt': createdAt.toIso8601String(),
    'completedBy': completedBy,
    'completedAt': completedAt?.toIso8601String(),
  };

  factory ShoppingItem.fromJson(Map<String, dynamic> json) => ShoppingItem(
    id: json['id'] as String,
    name: json['name'] as String,
    quantity: json['quantity'] as String?,
    unit: json['unit'] as String?,
    category: json['category'] as String?,
    isCompleted: json['isCompleted'] as bool? ?? false,
    addedBy: json['addedBy'] as String?,
    createdAt: DateTime.parse(json['createdAt'] as String),
    completedBy: json['completedBy'] as String?,
    completedAt: json['completedAt'] != null
        ? DateTime.parse(json['completedAt'] as String)
        : null,
  );
}

/// Common shopping categories for mess groceries
class ShoppingCategories {
  static const vegetables = 'সবজি';
  static const fish = 'মাছ';
  static const meat = 'মাংস';
  static const rice = 'চাল';
  static const oil = 'তেল';
  static const spices = 'মশলা';
  static const grocery = 'মুদি';
  static const dairy = 'দুধ';
  static const other = 'অন্যান্য';

  static const List<String> all = [
    vegetables,
    fish,
    meat,
    rice,
    oil,
    spices,
    grocery,
    dairy,
    other,
  ];
}

/// Shopping list Firestore collection reference
CollectionReference<Map<String, dynamic>> _shoppingCollection(String messId) {
  return FirebaseFirestore.instance
      .collection('messes')
      .doc(messId)
      .collection('shopping_list');
}

/// Provider for shopping list items
final shoppingListProvider =
    NotifierProvider<ShoppingListNotifier, List<ShoppingItem>>(
      ShoppingListNotifier.new,
    );

class ShoppingListNotifier extends Notifier<List<ShoppingItem>> {
  String? _messId;

  @override
  List<ShoppingItem> build() {
    // Load from local storage initially
    _loadFromLocal();
    return [];
  }

  /// Set the mess ID and start listening to Firestore
  void setMessId(String messId) {
    _messId = messId;
    _listenToFirestore();
  }

  /// Load from local cache
  void _loadFromLocal() {
    // For now, start with empty list
    // Could integrate with Isar for offline caching
    state = [];
  }

  /// Listen to Firestore updates in real-time
  void _listenToFirestore() {
    if (_messId == null) return;

    _shoppingCollection(_messId!)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .listen(
          (snapshot) {
            state = snapshot.docs.map((doc) {
              return ShoppingItem.fromJson(doc.data());
            }).toList();
          },
          onError: (e) {
            debugPrint('⚠️ Shopping list Firestore error: $e');
          },
        );
  }

  /// Add new item to shopping list
  Future<void> addItem({
    required String name,
    String? quantity,
    String? unit,
    String? category,
    String? addedBy,
  }) async {
    final item = ShoppingItem(
      id: 'shop_${DateTime.now().millisecondsSinceEpoch}',
      name: name,
      quantity: quantity,
      unit: unit,
      category: category ?? ShoppingCategories.other,
      addedBy: addedBy,
      createdAt: DateTime.now(),
    );

    // Optimistic update
    state = [item, ...state];

    // Sync to Firestore
    if (_messId != null) {
      try {
        await _shoppingCollection(_messId!).doc(item.id).set(item.toJson());
        debugPrint('✅ Shopping item added to Firestore');
      } catch (e) {
        debugPrint('⚠️ Failed to sync shopping item: $e');
      }
    }
  }

  /// Mark item as completed/purchased
  Future<void> toggleComplete(String itemId, {String? completedBy}) async {
    final index = state.indexWhere((i) => i.id == itemId);
    if (index == -1) return;

    final item = state[index];
    final updated = item.copyWith(
      isCompleted: !item.isCompleted,
      completedBy: item.isCompleted ? null : completedBy,
      completedAt: item.isCompleted ? null : DateTime.now(),
    );

    // Optimistic update
    state = [
      for (int i = 0; i < state.length; i++)
        if (i == index) updated else state[i],
    ];

    // Sync to Firestore
    if (_messId != null) {
      try {
        await _shoppingCollection(_messId!).doc(itemId).update({
          'isCompleted': updated.isCompleted,
          'completedBy': updated.completedBy,
          'completedAt': updated.completedAt?.toIso8601String(),
        });
      } catch (e) {
        debugPrint('⚠️ Failed to sync shopping item: $e');
      }
    }
  }

  /// Remove item from list
  Future<void> removeItem(String itemId) async {
    // Optimistic update
    state = state.where((i) => i.id != itemId).toList();

    // Sync to Firestore
    if (_messId != null) {
      try {
        await _shoppingCollection(_messId!).doc(itemId).delete();
        debugPrint('✅ Shopping item removed from Firestore');
      } catch (e) {
        debugPrint('⚠️ Failed to delete shopping item: $e');
      }
    }
  }

  /// Clear all completed items
  Future<void> clearCompleted() async {
    final completedIds = state
        .where((i) => i.isCompleted)
        .map((i) => i.id)
        .toList();

    // Optimistic update
    state = state.where((i) => !i.isCompleted).toList();

    // Batch delete from Firestore
    if (_messId != null && completedIds.isNotEmpty) {
      try {
        final batch = FirebaseFirestore.instance.batch();
        for (final id in completedIds) {
          batch.delete(_shoppingCollection(_messId!).doc(id));
        }
        await batch.commit();
        debugPrint('✅ Cleared ${completedIds.length} completed items');
      } catch (e) {
        debugPrint('⚠️ Failed to clear completed items: $e');
      }
    }
  }

  /// Add multiple items at once (e.g., from previous bazar entries)
  Future<void> addMultiple(List<String> names) async {
    final items = names
        .map(
          (name) => ShoppingItem(
            id: 'shop_${DateTime.now().millisecondsSinceEpoch}_${names.indexOf(name)}',
            name: name,
            createdAt: DateTime.now(),
          ),
        )
        .toList();

    // Optimistic update
    state = [...items, ...state];

    // Batch add to Firestore
    if (_messId != null) {
      try {
        final batch = FirebaseFirestore.instance.batch();
        for (final item in items) {
          batch.set(_shoppingCollection(_messId!).doc(item.id), item.toJson());
        }
        await batch.commit();
        debugPrint('✅ Added ${items.length} shopping items');
      } catch (e) {
        debugPrint('⚠️ Failed to batch add shopping items: $e');
      }
    }
  }
}

/// Pending (uncompleted) items count
final pendingShoppingCountProvider = Provider<int>((ref) {
  final items = ref.watch(shoppingListProvider);
  return items.where((i) => !i.isCompleted).length;
});

/// Items grouped by category
final shoppingByCategoryProvider = Provider<Map<String, List<ShoppingItem>>>((
  ref,
) {
  final items = ref.watch(shoppingListProvider);
  final grouped = <String, List<ShoppingItem>>{};

  for (final item in items) {
    final category = item.category ?? ShoppingCategories.other;
    grouped.putIfAbsent(category, () => []);
    grouped[category]!.add(item);
  }

  return grouped;
});

/// Completed items only (for history)
final completedShoppingProvider = Provider<List<ShoppingItem>>((ref) {
  final items = ref.watch(shoppingListProvider);
  return items.where((i) => i.isCompleted).toList();
});
