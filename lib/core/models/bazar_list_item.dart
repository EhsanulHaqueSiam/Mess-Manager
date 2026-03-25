/// Status of a shopping list item
enum BazarListStatus { pending, claimed, purchased }

/// Shared shopping list item
class BazarListItem {
  final String id;
  final String name;
  final String addedById;
  final String? claimedById;
  final BazarListStatus status;
  final String? quantity;
  final String? note;
  final DateTime? createdAt;
  final DateTime? purchasedAt;

  const BazarListItem({
    required this.id,
    required this.name,
    required this.addedById,
    this.claimedById,
    this.status = BazarListStatus.pending,
    this.quantity,
    this.note,
    this.createdAt,
    this.purchasedAt,
  });

  BazarListItem copyWith({
    String? id,
    String? name,
    String? addedById,
    String? claimedById,
    BazarListStatus? status,
    String? quantity,
    String? note,
    DateTime? createdAt,
    DateTime? purchasedAt,
  }) {
    return BazarListItem(
      id: id ?? this.id,
      name: name ?? this.name,
      addedById: addedById ?? this.addedById,
      claimedById: claimedById ?? this.claimedById,
      status: status ?? this.status,
      quantity: quantity ?? this.quantity,
      note: note ?? this.note,
      createdAt: createdAt ?? this.createdAt,
      purchasedAt: purchasedAt ?? this.purchasedAt,
    );
  }

  factory BazarListItem.fromJson(Map<String, dynamic> json) {
    return BazarListItem(
      id: json['id'] as String,
      name: json['name'] as String,
      addedById: json['addedById'] as String,
      claimedById: json['claimedById'] as String?,
      status: BazarListStatus.values.byName(
        json['status'] as String? ?? 'pending',
      ),
      quantity: json['quantity'] as String?,
      note: json['note'] as String?,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : null,
      purchasedAt: json['purchasedAt'] != null
          ? DateTime.parse(json['purchasedAt'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'addedById': addedById,
      'claimedById': claimedById,
      'status': status.name,
      'quantity': quantity,
      'note': note,
      'createdAt': createdAt?.toIso8601String(),
      'purchasedAt': purchasedAt?.toIso8601String(),
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BazarListItem &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          addedById == other.addedById &&
          claimedById == other.claimedById &&
          status == other.status &&
          quantity == other.quantity &&
          note == other.note &&
          createdAt == other.createdAt &&
          purchasedAt == other.purchasedAt;

  @override
  int get hashCode => Object.hash(
        id,
        name,
        addedById,
        claimedById,
        status,
        quantity,
        note,
        createdAt,
        purchasedAt,
      );

  @override
  String toString() {
    return 'BazarListItem(id: $id, name: $name, addedById: $addedById, claimedById: $claimedById, status: $status, quantity: $quantity, note: $note, createdAt: $createdAt, purchasedAt: $purchasedAt)';
  }
}
