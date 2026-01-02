import 'package:mess_manager/core/models/unified_entry.dart';

/// NLP-based categorizer for auto-detecting entry type
/// Uses keyword matching initially, can be enhanced with ML later
class NLPCategorizer {
  // Keywords that indicate monthly/amenity items
  static const _monthlyKeywords = {
    // Amenities
    'soap': MonthlyCategory.soap,
    'সাবান': MonthlyCategory.soap,
    'tissue': MonthlyCategory.tissue,
    'টিস্যু': MonthlyCategory.tissue,
    'toothpaste': MonthlyCategory.toothpaste,
    'পেস্ট': MonthlyCategory.toothpaste,
    'colgate': MonthlyCategory.toothpaste,
    'filter': MonthlyCategory.filter,
    'ফিল্টার': MonthlyCategory.filter,
    'coil': MonthlyCategory.coil,
    'কয়েল': MonthlyCategory.coil,
    'wheel': MonthlyCategory.other,
    'vim': MonthlyCategory.other,
    'harpic': MonthlyCategory.other,
    'shampoo': MonthlyCategory.other,
    'শ্যাম্পু': MonthlyCategory.other,
  };

  // Keywords that indicate fixed bills
  static const _fixedKeywords = {
    'rent': MonthlyCategory.rent,
    'ভাড়া': MonthlyCategory.rent,
    'বাড়ি': MonthlyCategory.rent,
    'electricity': MonthlyCategory.electricity,
    'বিদ্যুৎ': MonthlyCategory.electricity,
    'desco': MonthlyCategory.electricity,
    'gas': MonthlyCategory.gas,
    'গ্যাস': MonthlyCategory.gas,
    'wifi': MonthlyCategory.wifi,
    'ওয়াইফাই': MonthlyCategory.wifi,
    'internet': MonthlyCategory.wifi,
    'ইন্টারনেট': MonthlyCategory.wifi,
    'water': MonthlyCategory.water,
    'পানি': MonthlyCategory.water,
    'maid': MonthlyCategory.maid,
    'বুয়া': MonthlyCategory.maid,
    'bua': MonthlyCategory.maid,
    'garbage': MonthlyCategory.garbage,
    'ময়লা': MonthlyCategory.garbage,
  };

  // Keywords that indicate meal bazar
  static const _mealBazarKeywords = [
    'rice',
    'চাল',
    'fish',
    'মাছ',
    'meat',
    'মাংস',
    'গোশত',
    'chicken',
    'মুরগি',
    'egg',
    'ডিম',
    'oil',
    'তেল',
    'vegetables',
    'সবজি',
    'onion',
    'পেঁয়াজ',
    'potato',
    'আলু',
    'tomato',
    'টমেটো',
    'garlic',
    'রসুন',
    'ginger',
    'আদা',
    'dal',
    'ডাল',
    'salt',
    'লবণ',
    'sugar',
    'চিনি',
    'spice',
    'মশলা',
    'bazar',
    'বাজার',
  ];

  /// Categorize description and return detected type
  static NLPResult categorize(String description) {
    final lower = description.toLowerCase().trim();

    // Check for fixed bills first (highest priority)
    for (final entry in _fixedKeywords.entries) {
      if (lower.contains(entry.key)) {
        return NLPResult(
          type: EntryType.fixed,
          category: entry.value,
          confidence: 0.9,
        );
      }
    }

    // Check for monthly/amenity items
    for (final entry in _monthlyKeywords.entries) {
      if (lower.contains(entry.key)) {
        return NLPResult(
          type: EntryType.monthly,
          category: entry.value,
          confidence: 0.85,
        );
      }
    }

    // Check for meal bazar keywords
    for (final keyword in _mealBazarKeywords) {
      if (lower.contains(keyword)) {
        return NLPResult(
          type: EntryType.mealBazar,
          category: null,
          confidence: 0.8,
        );
      }
    }

    // Default to meal bazar (most common)
    return NLPResult(
      type: EntryType.mealBazar,
      category: null,
      confidence: 0.5,
    );
  }

  /// Get display name for entry type
  static String getTypeName(EntryType type) {
    switch (type) {
      case EntryType.mealBazar:
        return 'Meal Bazar';
      case EntryType.monthly:
        return 'Monthly';
      case EntryType.fixed:
        return 'Fixed Bill';
    }
  }

  /// Get display name for category
  static String getCategoryName(MonthlyCategory category) {
    switch (category) {
      case MonthlyCategory.rent:
        return 'ভাড়া (Rent)';
      case MonthlyCategory.electricity:
        return 'বিদ্যুৎ (Electricity)';
      case MonthlyCategory.gas:
        return 'গ্যাস (Gas)';
      case MonthlyCategory.wifi:
        return 'ওয়াইফাই (WiFi)';
      case MonthlyCategory.water:
        return 'পানি (Water)';
      case MonthlyCategory.maid:
        return 'বুয়া (Maid)';
      case MonthlyCategory.garbage:
        return 'ময়লা (Garbage)';
      case MonthlyCategory.soap:
        return 'সাবান (Soap)';
      case MonthlyCategory.tissue:
        return 'টিস্যু (Tissue)';
      case MonthlyCategory.toothpaste:
        return 'পেস্ট (Toothpaste)';
      case MonthlyCategory.filter:
        return 'ফিল্টার (Filter)';
      case MonthlyCategory.coil:
        return 'কয়েল (Coil)';
      case MonthlyCategory.other:
        return 'অন্যান্য (Other)';
    }
  }
}

/// Result of NLP categorization
class NLPResult {
  final EntryType type;
  final MonthlyCategory? category;
  final double confidence; // 0.0 to 1.0

  NLPResult({required this.type, this.category, required this.confidence});

  bool get isHighConfidence => confidence >= 0.7;
}
