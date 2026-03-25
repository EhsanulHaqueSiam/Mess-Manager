/// Individual item in an itemized bazar entry
class BazarItem {
  final String name;
  final double price;
  final String? quantity;
  final String? unit;

  const BazarItem({
    required this.name,
    required this.price,
    this.quantity,
    this.unit,
  });

  BazarItem copyWith({
    String? name,
    double? price,
    String? quantity,
    String? unit,
  }) {
    return BazarItem(
      name: name ?? this.name,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
      unit: unit ?? this.unit,
    );
  }

  factory BazarItem.fromJson(Map<String, dynamic> json) {
    return BazarItem(
      name: json['name'] as String,
      price: (json['price'] ?? 0).toDouble(),
      quantity: json['quantity'] as String?,
      unit: json['unit'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'price': price,
      'quantity': quantity,
      'unit': unit,
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BazarItem &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          price == other.price &&
          quantity == other.quantity &&
          unit == other.unit;

  @override
  int get hashCode => Object.hash(name, price, quantity, unit);

  @override
  String toString() {
    return 'BazarItem(name: $name, price: $price, quantity: $quantity, unit: $unit)';
  }
}

/// Bazar expense entry
class BazarEntry {
  final String id;
  final String memberId;
  final DateTime date;
  final double amount;
  final String? description;
  final List<BazarItem> items;
  final bool isItemized;
  final List<String> photoUrls;
  final List<String> receiptUrls;
  final DateTime? createdAt;

  const BazarEntry({
    required this.id,
    required this.memberId,
    required this.date,
    required this.amount,
    this.description,
    this.items = const [],
    this.isItemized = false,
    this.photoUrls = const [],
    this.receiptUrls = const [],
    this.createdAt,
  });

  BazarEntry copyWith({
    String? id,
    String? memberId,
    DateTime? date,
    double? amount,
    String? description,
    List<BazarItem>? items,
    bool? isItemized,
    List<String>? photoUrls,
    List<String>? receiptUrls,
    DateTime? createdAt,
  }) {
    return BazarEntry(
      id: id ?? this.id,
      memberId: memberId ?? this.memberId,
      date: date ?? this.date,
      amount: amount ?? this.amount,
      description: description ?? this.description,
      items: items ?? this.items,
      isItemized: isItemized ?? this.isItemized,
      photoUrls: photoUrls ?? this.photoUrls,
      receiptUrls: receiptUrls ?? this.receiptUrls,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  factory BazarEntry.fromJson(Map<String, dynamic> json) {
    return BazarEntry(
      id: json['id'] as String,
      memberId: json['memberId'] as String,
      date: DateTime.parse(json['date'] as String),
      amount: (json['amount'] ?? 0).toDouble(),
      description: json['description'] as String?,
      items: (json['items'] as List?)
              ?.map((e) => BazarItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      isItemized: json['isItemized'] as bool? ?? false,
      photoUrls: List<String>.from(json['photoUrls'] ?? []),
      receiptUrls: List<String>.from(json['receiptUrls'] ?? []),
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
      'items': items.map((e) => e.toJson()).toList(),
      'isItemized': isItemized,
      'photoUrls': photoUrls,
      'receiptUrls': receiptUrls,
      'createdAt': createdAt?.toIso8601String(),
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BazarEntry &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          memberId == other.memberId &&
          date == other.date &&
          amount == other.amount &&
          description == other.description &&
          items.length == other.items.length &&
          isItemized == other.isItemized &&
          photoUrls.length == other.photoUrls.length &&
          receiptUrls.length == other.receiptUrls.length &&
          createdAt == other.createdAt;

  @override
  int get hashCode => Object.hash(
        id,
        memberId,
        date,
        amount,
        description,
        Object.hashAll(items),
        isItemized,
        Object.hashAll(photoUrls),
        Object.hashAll(receiptUrls),
        createdAt,
      );

  @override
  String toString() {
    return 'BazarEntry(id: $id, memberId: $memberId, date: $date, amount: $amount, description: $description, items: $items, isItemized: $isItemized, photoUrls: $photoUrls, receiptUrls: $receiptUrls, createdAt: $createdAt)';
  }
}
