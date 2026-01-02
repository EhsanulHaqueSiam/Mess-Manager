import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mess_manager/core/providers/members_provider.dart';
import 'package:mess_manager/features/bazar/providers/bazar_provider.dart';

/// Search query notifier
class SearchQueryNotifier extends Notifier<String> {
  @override
  String build() => '';

  void setQuery(String query) => state = query;
  void clear() => state = '';
}

final searchQueryProvider = NotifierProvider<SearchQueryNotifier, String>(() {
  return SearchQueryNotifier();
});

/// Search result types
enum SearchResultType { member, meal, bazar, shoppingItem }

class SearchResult {
  final SearchResultType type;
  final String id;
  final String title;
  final String subtitle;
  final DateTime? date;
  final double? amount;

  SearchResult({
    required this.type,
    required this.id,
    required this.title,
    required this.subtitle,
    this.date,
    this.amount,
  });
}

/// Global search provider
final searchResultsProvider = Provider<List<SearchResult>>((ref) {
  final query = ref.watch(searchQueryProvider).toLowerCase().trim();
  if (query.isEmpty) return [];

  final results = <SearchResult>[];
  final members = ref.watch(membersProvider);
  final bazarEntries = ref.watch(bazarEntriesProvider);

  // Search members
  for (final member in members) {
    if (member.name.toLowerCase().contains(query)) {
      results.add(
        SearchResult(
          type: SearchResultType.member,
          id: member.id,
          title: member.name,
          subtitle: member.role.name,
        ),
      );
    }
  }

  // Search bazar entries
  for (final entry in bazarEntries) {
    final member = members.firstWhere(
      (m) => m.id == entry.memberId,
      orElse: () => members.first,
    );

    // Search by description
    if (entry.description?.toLowerCase().contains(query) ?? false) {
      results.add(
        SearchResult(
          type: SearchResultType.bazar,
          id: entry.id,
          title: entry.description ?? 'Bazar',
          subtitle: '${member.name} • ৳${entry.amount.toStringAsFixed(0)}',
          date: entry.date,
          amount: entry.amount,
        ),
      );
    }

    // Search by items
    for (final item in entry.items) {
      if (item.name.toLowerCase().contains(query)) {
        results.add(
          SearchResult(
            type: SearchResultType.bazar,
            id: entry.id,
            title: item.name,
            subtitle: '${member.name} • ৳${item.price.toStringAsFixed(0)}',
            date: entry.date,
            amount: item.price,
          ),
        );
      }
    }
  }

  // Sort by date (newest first)
  results.sort((a, b) {
    if (a.date == null && b.date == null) return 0;
    if (a.date == null) return 1;
    if (b.date == null) return -1;
    return b.date!.compareTo(a.date!);
  });

  return results.take(20).toList();
});

/// Recent searches notifier
class RecentSearchesNotifier extends Notifier<List<String>> {
  @override
  List<String> build() => [];

  void addSearch(String query) {
    if (query.trim().isEmpty) return;
    final current = List<String>.from(state);
    current.remove(query);
    current.insert(0, query);
    state = current.take(5).toList();
  }

  void clearSearches() => state = [];
}

final recentSearchesProvider =
    NotifierProvider<RecentSearchesNotifier, List<String>>(() {
      return RecentSearchesNotifier();
    });
