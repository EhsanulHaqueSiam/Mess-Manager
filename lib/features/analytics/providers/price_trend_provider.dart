/// Price Trend Provider - Expense Watchlist & Price Alerts
///
/// Tracks historical prices of bazar items and alerts when prices
/// exceed typical values. Helps members spot price gouging or unusual expenses.
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mess_manager/features/bazar/providers/bazar_provider.dart';

/// Represents a price trend for a single item
class ItemPriceTrend {
  final String itemName;
  final double averagePrice;
  final double lastPrice;
  final double percentChange;
  final int sampleCount;
  final bool isSpike;
  final DateTime? lastPurchaseDate;

  const ItemPriceTrend({
    required this.itemName,
    required this.averagePrice,
    required this.lastPrice,
    required this.percentChange,
    required this.sampleCount,
    required this.isSpike,
    this.lastPurchaseDate,
  });

  /// Creates a trend showing no price change
  factory ItemPriceTrend.noData(String itemName, double price) {
    return ItemPriceTrend(
      itemName: itemName,
      averagePrice: price,
      lastPrice: price,
      percentChange: 0,
      sampleCount: 1,
      isSpike: false,
    );
  }
}

/// Alert threshold for price spike detection (15% above average)
const double _spikeThreshold = 0.15;

/// Minimum samples needed for meaningful trend analysis
const int _minSamplesForTrend = 3;

/// Provider for item price history grouped by item name
final itemPriceHistoryProvider = Provider<Map<String, List<double>>>((ref) {
  final entries = ref.watch(bazarEntriesProvider);
  final priceHistory = <String, List<double>>{};

  for (final entry in entries) {
    if (!entry.isItemized) continue;

    for (final item in entry.items) {
      final normalizedName = item.name.toLowerCase().trim();
      if (normalizedName.isEmpty) continue;

      priceHistory.putIfAbsent(normalizedName, () => []);
      priceHistory[normalizedName]!.add(item.price);
    }
  }

  return priceHistory;
});

/// Provider for average prices per item
final averagePricesProvider = Provider<Map<String, double>>((ref) {
  final priceHistory = ref.watch(itemPriceHistoryProvider);
  final averages = <String, double>{};

  for (final entry in priceHistory.entries) {
    if (entry.value.isEmpty) continue;
    final sum = entry.value.reduce((a, b) => a + b);
    averages[entry.key] = sum / entry.value.length;
  }

  return averages;
});

/// Provider for price trends with spike detection
final priceTrendsProvider = Provider<List<ItemPriceTrend>>((ref) {
  final entries = ref.watch(bazarEntriesProvider);
  final averages = ref.watch(averagePricesProvider);
  final priceHistory = ref.watch(itemPriceHistoryProvider);

  // Build map of latest prices and dates
  final latestPrices = <String, double>{};
  final latestDates = <String, DateTime>{};

  // Process entries in reverse chronological order to get latest prices
  final sortedEntries = [...entries]..sort((a, b) => b.date.compareTo(a.date));

  for (final entry in sortedEntries) {
    if (!entry.isItemized) continue;

    for (final item in entry.items) {
      final normalizedName = item.name.toLowerCase().trim();
      if (normalizedName.isEmpty) continue;

      // Only keep the first (latest) occurrence
      if (!latestPrices.containsKey(normalizedName)) {
        latestPrices[normalizedName] = item.price;
        latestDates[normalizedName] = entry.date;
      }
    }
  }

  // Generate trends
  final trends = <ItemPriceTrend>[];

  for (final entry in latestPrices.entries) {
    final itemName = entry.key;
    final lastPrice = entry.value;
    final avgPrice = averages[itemName] ?? lastPrice;
    final sampleCount = priceHistory[itemName]?.length ?? 1;

    // Calculate percent change from average
    double percentChange = 0;
    if (avgPrice > 0) {
      percentChange = ((lastPrice - avgPrice) / avgPrice);
    }

    // Detect spike only if we have enough samples
    final isSpike =
        sampleCount >= _minSamplesForTrend && percentChange > _spikeThreshold;

    trends.add(
      ItemPriceTrend(
        itemName: itemName,
        averagePrice: avgPrice,
        lastPrice: lastPrice,
        percentChange: percentChange,
        sampleCount: sampleCount,
        isSpike: isSpike,
        lastPurchaseDate: latestDates[itemName],
      ),
    );
  }

  // Sort by percent change descending (biggest increases first)
  trends.sort((a, b) => b.percentChange.compareTo(a.percentChange));

  return trends;
});

/// Provider for items with price spikes (alerts)
final priceSpikesProvider = Provider<List<ItemPriceTrend>>((ref) {
  final trends = ref.watch(priceTrendsProvider);
  return trends.where((t) => t.isSpike).toList();
});

/// Provider for spike count (for badge display)
final priceSpikeCountProvider = Provider<int>((ref) {
  return ref.watch(priceSpikesProvider).length;
});

/// Check if a specific item has a price spike
final hasSpikeFamilyProvider = Provider.family<bool, String>((ref, itemName) {
  final spikes = ref.watch(priceSpikesProvider);
  return spikes.any((s) => s.itemName == itemName.toLowerCase().trim());
});

/// Get trend for a specific item
final itemTrendFamilyProvider = Provider.family<ItemPriceTrend?, String>((
  ref,
  itemName,
) {
  final trends = ref.watch(priceTrendsProvider);
  final normalized = itemName.toLowerCase().trim();
  try {
    return trends.firstWhere((t) => t.itemName == normalized);
  } catch (_) {
    return null;
  }
});

/// Formatted spike alert message for UI display
final spikeAlertMessageProvider = Provider<String?>((ref) {
  final spikes = ref.watch(priceSpikesProvider);
  if (spikes.isEmpty) return null;

  if (spikes.length == 1) {
    final spike = spikes.first;
    final percent = (spike.percentChange * 100).toStringAsFixed(0);
    return '⚠️ ${_capitalize(spike.itemName)} is $percent% more expensive than usual';
  }

  return '⚠️ ${spikes.length} items have unusual price increases';
});

String _capitalize(String s) {
  if (s.isEmpty) return s;
  return s[0].toUpperCase() + s.substring(1);
}
