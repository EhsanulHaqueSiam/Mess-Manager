/// Member roles in the mess
enum MemberRole {
  superAdmin, // Everything + transfer ownership
  admin, // Edit past, bypass time lock
  mealManager, // Bulk meal ops only
  maintenance, // Fixed expenses only
  member, // Own entries, add guest meals
  temp, // Member + active dates
  guest, // View only
}

/// Food restriction types
enum RestrictionType {
  none,
  noBeef,
  noPork,
  vegetarian,
  vegan,
  allergic,
  other,
}

/// Food preference/restriction
class FoodPreference {
  final RestrictionType type;
  final String? allergen;
  final String? notes;
  final List<int> daysActive; // 1=Mon, 7=Sun (for part-time vegetarians)

  const FoodPreference({
    required this.type,
    this.allergen,
    this.notes,
    this.daysActive = const [],
  });

  FoodPreference copyWith({
    RestrictionType? type,
    String? allergen,
    String? notes,
    List<int>? daysActive,
  }) {
    return FoodPreference(
      type: type ?? this.type,
      allergen: allergen ?? this.allergen,
      notes: notes ?? this.notes,
      daysActive: daysActive ?? this.daysActive,
    );
  }

  factory FoodPreference.fromJson(Map<String, dynamic> json) {
    return FoodPreference(
      type: _restrictionTypeFromJson(json['type']),
      allergen: json['allergen'] as String?,
      notes: json['notes'] as String?,
      daysActive: (json['daysActive'] as List?)?.map((e) => (e as num).toInt()).toList() ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type.name,
      'allergen': allergen,
      'notes': notes,
      'daysActive': daysActive,
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FoodPreference &&
          runtimeType == other.runtimeType &&
          type == other.type &&
          allergen == other.allergen &&
          notes == other.notes;

  @override
  int get hashCode => Object.hash(type, allergen, notes);

  @override
  String toString() => 'FoodPreference(type: $type, allergen: $allergen)';
}

/// Room split groups for unequal bill splitting (e.g., AC vs Non-AC)
enum SplitGroup {
  standard, // Default group - 1.0x multiplier
  premium, // Premium rooms (AC) - configurable multiplier
  economy, // Economy rooms - configurable multiplier
}

/// Mess member
class Member {
  final String id;
  final String name;
  final MemberRole role;
  final String? avatarUrl;
  final String? phone;
  final String? email; // For auth user linking
  final List<FoodPreference> preferences;
  final double balance; // Positive = will receive, Negative = owes
  final DateTime? joinedAt;
  // Temporary member fields
  final DateTime? activeFromDate; // For temp members
  final DateTime? activeToDate; // For temp members
  final bool isActive;
  // Split group for unequal fixed cost distribution
  final SplitGroup splitGroup;

  const Member({
    required this.id,
    required this.name,
    this.role = MemberRole.member,
    this.avatarUrl,
    this.phone,
    this.email,
    this.preferences = const [],
    this.balance = 0.0,
    this.joinedAt,
    this.activeFromDate,
    this.activeToDate,
    this.isActive = true,
    this.splitGroup = SplitGroup.standard,
  });

  Member copyWith({
    String? id,
    String? name,
    MemberRole? role,
    String? avatarUrl,
    String? phone,
    String? email,
    List<FoodPreference>? preferences,
    double? balance,
    DateTime? joinedAt,
    DateTime? activeFromDate,
    DateTime? activeToDate,
    bool? isActive,
    SplitGroup? splitGroup,
  }) {
    return Member(
      id: id ?? this.id,
      name: name ?? this.name,
      role: role ?? this.role,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      preferences: preferences ?? this.preferences,
      balance: balance ?? this.balance,
      joinedAt: joinedAt ?? this.joinedAt,
      activeFromDate: activeFromDate ?? this.activeFromDate,
      activeToDate: activeToDate ?? this.activeToDate,
      isActive: isActive ?? this.isActive,
      splitGroup: splitGroup ?? this.splitGroup,
    );
  }

  factory Member.fromJson(Map<String, dynamic> json) {
    return Member(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      role: _memberRoleFromJson(json['role']),
      avatarUrl: json['avatarUrl'] as String?,
      phone: json['phone'] as String?,
      email: json['email'] as String?,
      preferences: (json['preferences'] as List?)
              ?.map((e) => FoodPreference.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      balance: (json['balance'] ?? 0.0).toDouble(),
      joinedAt: json['joinedAt'] != null
          ? DateTime.parse(json['joinedAt'] as String)
          : null,
      activeFromDate: json['activeFromDate'] != null
          ? DateTime.parse(json['activeFromDate'] as String)
          : null,
      activeToDate: json['activeToDate'] != null
          ? DateTime.parse(json['activeToDate'] as String)
          : null,
      isActive: json['isActive'] ?? true,
      splitGroup: _splitGroupFromJson(json['splitGroup']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'role': role.name,
      'avatarUrl': avatarUrl,
      'phone': phone,
      'email': email,
      'preferences': preferences.map((e) => e.toJson()).toList(),
      'balance': balance,
      'joinedAt': joinedAt?.toIso8601String(),
      'activeFromDate': activeFromDate?.toIso8601String(),
      'activeToDate': activeToDate?.toIso8601String(),
      'isActive': isActive,
      'splitGroup': splitGroup.name,
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Member &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          role == other.role &&
          avatarUrl == other.avatarUrl &&
          phone == other.phone &&
          email == other.email &&
          balance == other.balance &&
          joinedAt == other.joinedAt &&
          activeFromDate == other.activeFromDate &&
          activeToDate == other.activeToDate &&
          isActive == other.isActive &&
          splitGroup == other.splitGroup;

  @override
  int get hashCode => Object.hash(
        id,
        name,
        role,
        avatarUrl,
        phone,
        email,
        balance,
        joinedAt,
        activeFromDate,
        activeToDate,
        isActive,
        splitGroup,
      );

  @override
  String toString() =>
      'Member(id: $id, name: $name, role: $role, balance: $balance, active: $isActive)';
}

// Helper functions for enum parsing
MemberRole _memberRoleFromJson(dynamic value) {
  if (value == null) return MemberRole.member;
  try {
    return MemberRole.values.byName(value as String);
  } catch (_) {
    return MemberRole.member;
  }
}

RestrictionType _restrictionTypeFromJson(dynamic value) {
  if (value == null) return RestrictionType.none;
  try {
    return RestrictionType.values.byName(value as String);
  } catch (_) {
    return RestrictionType.none;
  }
}

SplitGroup _splitGroupFromJson(dynamic value) {
  if (value == null) return SplitGroup.standard;
  try {
    return SplitGroup.values.byName(value as String);
  } catch (_) {
    return SplitGroup.standard;
  }
}
