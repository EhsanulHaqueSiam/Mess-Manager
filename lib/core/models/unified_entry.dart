/// Entry type - auto-detected by NLP or user-selected
enum EntryType {
  mealBazar, // Divided by meal ratio
  monthly, // Divided equally (soap, tissue, etc.)
  fixed, // Fixed bills (rent, wifi, electricity)
}

/// Category for monthly/fixed entries
enum MonthlyCategory {
  rent,
  electricity,
  gas,
  wifi,
  water,
  maid,
  garbage,
  soap,
  tissue,
  toothpaste,
  filter,
  coil,
  other,
}

/// Unified entry model - single entry point for bazar and monthly
class UnifiedEntry {
  final String id;
  final String memberId;
  final DateTime date;
  final double amount;
  final String? description;
  final EntryType type;
  final MonthlyCategory? monthlyCategory; // For monthly/fixed entries
  final List<String> photoUrls;
  final List<String> receiptUrls;
  final bool isAutoDetected; // Was type auto-detected by NLP?
  final List<UnifiedEntryItem> items; // For itemized entries
  final DateTime? createdAt;

  const UnifiedEntry({
    required this.id,
    required this.memberId,
    required this.date,
    required this.amount,
    this.description,
    this.type = EntryType.mealBazar,
    this.monthlyCategory,
    this.photoUrls = const [],
    this.receiptUrls = const [],
    this.isAutoDetected = true,
    this.items = const [],
    this.createdAt,
  });

  UnifiedEntry copyWith({
    String? id,
    String? memberId,
    DateTime? date,
    double? amount,
    String? description,
    EntryType? type,
    MonthlyCategory? monthlyCategory,
    List<String>? photoUrls,
    List<String>? receiptUrls,
    bool? isAutoDetected,
    List<UnifiedEntryItem>? items,
    DateTime? createdAt,
  }) {
    return UnifiedEntry(
      id: id ?? this.id,
      memberId: memberId ?? this.memberId,
      date: date ?? this.date,
      amount: amount ?? this.amount,
      description: description ?? this.description,
      type: type ?? this.type,
      monthlyCategory: monthlyCategory ?? this.monthlyCategory,
      photoUrls: photoUrls ?? this.photoUrls,
      receiptUrls: receiptUrls ?? this.receiptUrls,
      isAutoDetected: isAutoDetected ?? this.isAutoDetected,
      items: items ?? this.items,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  factory UnifiedEntry.fromJson(Map<String, dynamic> json) {
    return UnifiedEntry(
      id: json['id'] as String? ?? '',
      memberId: json['memberId'] as String? ?? '',
      date: DateTime.parse(json['date'] as String),
      amount: (json['amount'] ?? 0).toDouble(),
      description: json['description'] as String?,
      type: _entryTypeFromJson(json['type']),
      monthlyCategory: json['monthlyCategory'] != null
          ? _monthlyCategoryFromJson(json['monthlyCategory'])
          : null,
      photoUrls: List<String>.from(json['photoUrls'] ?? []),
      receiptUrls: List<String>.from(json['receiptUrls'] ?? []),
      isAutoDetected: json['isAutoDetected'] ?? true,
      items: (json['items'] as List?)
              ?.map((e) =>
                  UnifiedEntryItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'memberId': memberId,
      'date': date.toIso8601String(),
      'amount': amount,
      'description': description,
      'type': type.name,
      'monthlyCategory': monthlyCategory?.name,
      'photoUrls': photoUrls,
      'receiptUrls': receiptUrls,
      'isAutoDetected': isAutoDetected,
      'items': items.map((e) => e.toJson()).toList(),
      'createdAt': createdAt?.toIso8601String(),
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UnifiedEntry &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          memberId == other.memberId &&
          date == other.date &&
          amount == other.amount &&
          description == other.description &&
          type == other.type &&
          monthlyCategory == other.monthlyCategory &&
          isAutoDetected == other.isAutoDetected &&
          createdAt == other.createdAt;

  @override
  int get hashCode => Object.hash(
        id,
        memberId,
        date,
        amount,
        description,
        type,
        monthlyCategory,
        isAutoDetected,
        createdAt,
      );

  @override
  String toString() =>
      'UnifiedEntry(id: $id, memberId: $memberId, date: $date, amount: $amount, type: $type)';
}

/// Individual item in an itemized entry
class UnifiedEntryItem {
  final String name;
  final double price;
  final EntryType? type; // Can have different types per item
  final MonthlyCategory? category;

  const UnifiedEntryItem({
    required this.name,
    required this.price,
    this.type,
    this.category,
  });

  UnifiedEntryItem copyWith({
    String? name,
    double? price,
    EntryType? type,
    MonthlyCategory? category,
  }) {
    return UnifiedEntryItem(
      name: name ?? this.name,
      price: price ?? this.price,
      type: type ?? this.type,
      category: category ?? this.category,
    );
  }

  factory UnifiedEntryItem.fromJson(Map<String, dynamic> json) {
    return UnifiedEntryItem(
      name: json['name'] as String? ?? '',
      price: (json['price'] ?? 0).toDouble(),
      type: json['type'] != null ? _entryTypeFromJson(json['type']) : null,
      category: json['category'] != null
          ? _monthlyCategoryFromJson(json['category'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'price': price,
      'type': type?.name,
      'category': category?.name,
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UnifiedEntryItem &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          price == other.price &&
          type == other.type &&
          category == other.category;

  @override
  int get hashCode => Object.hash(name, price, type, category);

  @override
  String toString() =>
      'UnifiedEntryItem(name: $name, price: $price, type: $type)';
}

// Helper functions for enum parsing
EntryType _entryTypeFromJson(dynamic value) {
  if (value == null) return EntryType.mealBazar;
  try {
    return EntryType.values.byName(value as String);
  } catch (_) {
    return EntryType.mealBazar;
  }
}

MonthlyCategory _monthlyCategoryFromJson(dynamic value) {
  if (value == null) return MonthlyCategory.other;
  try {
    return MonthlyCategory.values.byName(value as String);
  } catch (_) {
    return MonthlyCategory.other;
  }
}
