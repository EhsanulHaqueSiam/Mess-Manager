import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mess_manager/core/models/unified_entry.dart';
import 'package:mess_manager/core/providers/members_provider.dart';
import 'package:mess_manager/core/database/isar_service.dart';

/// Sample unified entries
final _sampleEntries = <UnifiedEntry>[
  UnifiedEntry(
    id: 'ue1',
    memberId: '1',
    date: DateTime.now().subtract(const Duration(days: 2)),
    amount: 850,
    description: 'চাল, তেল, মাছ',
    type: EntryType.mealBazar,
    createdAt: DateTime.now().subtract(const Duration(days: 2)),
  ),
  UnifiedEntry(
    id: 'ue2',
    memberId: '2',
    date: DateTime.now().subtract(const Duration(days: 1)),
    amount: 120,
    description: 'সাবান, টিস্যু',
    type: EntryType.monthly,
    monthlyCategory: MonthlyCategory.soap,
    createdAt: DateTime.now().subtract(const Duration(days: 1)),
  ),
  UnifiedEntry(
    id: 'ue3',
    memberId: '3',
    date: DateTime.now(),
    amount: 800,
    description: 'ওয়াইফাই বিল',
    type: EntryType.fixed,
    monthlyCategory: MonthlyCategory.wifi,
    createdAt: DateTime.now(),
  ),
];

/// Unified entries notifier
class UnifiedEntriesNotifier extends Notifier<List<UnifiedEntry>> {
  @override
  List<UnifiedEntry> build() {
    // Try load from Isar first
    final saved = IsarService.getAllUnifiedEntries();
    if (saved.isNotEmpty) {
      return saved;
    }
    return List.from(_sampleEntries);
  }

  void addEntry(UnifiedEntry entry) {
    state = [...state, entry];
    IsarService.saveUnifiedEntry(entry);
  }

  void updateEntry(UnifiedEntry entry) {
    state = [
      for (final e in state)
        if (e.id == entry.id) entry else e,
    ];
    IsarService.saveUnifiedEntry(entry);
  }

  void removeEntry(String id) {
    state = state.where((e) => e.id != id).toList();
    IsarService.deleteUnifiedEntry(id);
  }
}

final unifiedEntriesProvider =
    NotifierProvider<UnifiedEntriesNotifier, List<UnifiedEntry>>(() {
      return UnifiedEntriesNotifier();
    });

/// Current month entries
final currentMonthEntriesProvider = Provider<List<UnifiedEntry>>((ref) {
  final entries = ref.watch(unifiedEntriesProvider);
  final now = DateTime.now();
  return entries
      .where((e) => e.date.month == now.month && e.date.year == now.year)
      .toList();
});

/// Meal bazar entries only
final mealBazarEntriesProvider = Provider<List<UnifiedEntry>>((ref) {
  final entries = ref.watch(currentMonthEntriesProvider);
  return entries.where((e) => e.type == EntryType.mealBazar).toList();
});

/// Monthly entries only
final monthlyEntriesProvider = Provider<List<UnifiedEntry>>((ref) {
  final entries = ref.watch(currentMonthEntriesProvider);
  return entries.where((e) => e.type == EntryType.monthly).toList();
});

/// Fixed entries only
final fixedEntriesProvider = Provider<List<UnifiedEntry>>((ref) {
  final entries = ref.watch(currentMonthEntriesProvider);
  return entries.where((e) => e.type == EntryType.fixed).toList();
});

/// Total meal bazar this month
final totalMealBazarProvider = Provider<double>((ref) {
  final entries = ref.watch(mealBazarEntriesProvider);
  return entries.fold(0.0, (sum, e) => sum + e.amount);
});

/// Total monthly expenses (equally divided)
final totalMonthlyProvider = Provider<double>((ref) {
  final entries = ref.watch(monthlyEntriesProvider);
  final fixed = ref.watch(fixedEntriesProvider);
  return entries.fold(0.0, (sum, e) => sum + e.amount) +
      fixed.fold(0.0, (sum, e) => sum + e.amount);
});

/// Per-member monthly share (equal split)
final monthlyPerMemberProvider = Provider<double>((ref) {
  final total = ref.watch(totalMonthlyProvider);
  final members = ref.watch(membersProvider);
  if (members.isEmpty) return 0;
  return total / members.length;
});

/// Entries by member
final entriesByMemberProvider = Provider.family<List<UnifiedEntry>, String>((
  ref,
  memberId,
) {
  final entries = ref.watch(currentMonthEntriesProvider);
  return entries.where((e) => e.memberId == memberId).toList();
});

/// Total contributed by member
final totalContributedByMemberProvider = Provider.family<double, String>((
  ref,
  memberId,
) {
  final entries = ref.watch(entriesByMemberProvider(memberId));
  return entries.fold(0.0, (sum, e) => sum + e.amount);
});
