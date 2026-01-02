import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mess_manager/core/models/bazar_entry.dart';

/// Generate sample bazar entries
List<BazarEntry> _generateSampleBazarEntries() {
  final now = DateTime.now();
  return [
    BazarEntry(
      id: 'bazar_1',
      memberId: '1', // Siam
      date: now.subtract(const Duration(days: 2)),
      amount: 1200,
      description: 'Weekly groceries',
      isItemized: true,
      items: const [
        BazarItem(name: 'Rice', price: 400, quantity: '5', unit: 'kg'),
        BazarItem(name: 'Oil', price: 350, quantity: '2', unit: 'ltr'),
        BazarItem(name: 'Vegetables', price: 250),
        BazarItem(name: 'Spices', price: 200),
      ],
      createdAt: now.subtract(const Duration(days: 2)),
    ),
    BazarEntry(
      id: 'bazar_2',
      memberId: '2', // Tanmoy
      date: now.subtract(const Duration(days: 4)),
      amount: 850,
      description: 'Fish and meat',
      isItemized: true,
      items: const [
        BazarItem(name: 'Fish (Rui)', price: 450, quantity: '1', unit: 'kg'),
        BazarItem(name: 'Chicken', price: 400, quantity: '1', unit: 'kg'),
      ],
      createdAt: now.subtract(const Duration(days: 4)),
    ),
    BazarEntry(
      id: 'bazar_3',
      memberId: '3', // Sarkar
      date: now.subtract(const Duration(days: 1)),
      amount: 500,
      description: 'Fruits and snacks',
      isItemized: false,
      createdAt: now.subtract(const Duration(days: 1)),
    ),
    BazarEntry(
      id: 'bazar_4',
      memberId: '1', // Siam
      date: now.subtract(const Duration(days: 6)),
      amount: 2000,
      description: 'Monthly stock',
      isItemized: false,
      createdAt: now.subtract(const Duration(days: 6)),
    ),
  ];
}

/// Provider for all bazar entries
final bazarEntriesProvider =
    NotifierProvider<BazarEntriesNotifier, List<BazarEntry>>(
      BazarEntriesNotifier.new,
    );

class BazarEntriesNotifier extends Notifier<List<BazarEntry>> {
  @override
  List<BazarEntry> build() => _generateSampleBazarEntries();

  void addEntry(BazarEntry entry) {
    state = [...state, entry];
  }

  void removeEntry(String id) {
    state = state.where((e) => e.id != id).toList();
  }

  void updateEntry(BazarEntry entry) {
    state = [
      for (final e in state)
        if (e.id == entry.id) entry else e,
    ];
  }

  List<BazarEntry> getEntriesForMember(String memberId) {
    return state.where((e) => e.memberId == memberId).toList();
  }

  double getTotalBazarForMember(String memberId) {
    return state
        .where((e) => e.memberId == memberId)
        .fold(0.0, (sum, e) => sum + e.amount);
  }
}

/// Total bazar amount
final totalBazarProvider = Provider<double>((ref) {
  final entries = ref.watch(bazarEntriesProvider);
  return entries.fold(0.0, (sum, e) => sum + e.amount);
});

/// Bazar per member
final bazarByMemberProvider = Provider<Map<String, double>>((ref) {
  final entries = ref.watch(bazarEntriesProvider);
  final result = <String, double>{};
  for (final entry in entries) {
    result[entry.memberId] = (result[entry.memberId] ?? 0) + entry.amount;
  }
  return result;
});
