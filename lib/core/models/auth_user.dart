/// User model for authentication
class AuthUser {
  final String id;
  final String email;
  final String name;
  final String? phone;
  final String? avatarUrl;
  final DateTime createdAt;
  final String? currentMessId;

  const AuthUser({
    required this.id,
    required this.email,
    required this.name,
    this.phone,
    this.avatarUrl,
    required this.createdAt,
    this.currentMessId,
  });

  AuthUser copyWith({
    String? id,
    String? email,
    String? name,
    String? phone,
    String? avatarUrl,
    DateTime? createdAt,
    String? currentMessId,
  }) {
    return AuthUser(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      createdAt: createdAt ?? this.createdAt,
      currentMessId: currentMessId ?? this.currentMessId,
    );
  }

  factory AuthUser.fromJson(Map<String, dynamic> json) {
    return AuthUser(
      id: json['id'] as String,
      email: json['email'] as String,
      name: json['name'] as String,
      phone: json['phone'] as String?,
      avatarUrl: json['avatarUrl'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      currentMessId: json['currentMessId'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'phone': phone,
      'avatarUrl': avatarUrl,
      'createdAt': createdAt.toIso8601String(),
      'currentMessId': currentMessId,
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AuthUser &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          email == other.email &&
          name == other.name &&
          phone == other.phone &&
          avatarUrl == other.avatarUrl &&
          createdAt == other.createdAt &&
          currentMessId == other.currentMessId;

  @override
  int get hashCode => Object.hash(
        id,
        email,
        name,
        phone,
        avatarUrl,
        createdAt,
        currentMessId,
      );

  @override
  String toString() {
    return 'AuthUser(id: $id, email: $email, name: $name, phone: $phone, avatarUrl: $avatarUrl, createdAt: $createdAt, currentMessId: $currentMessId)';
  }
}

/// Mess model for mess selection
class Mess {
  final String id;
  final String name;
  final String address;
  final String createdById;
  final DateTime createdAt;
  final List<String> memberIds;
  final String? inviteCode;

  const Mess({
    required this.id,
    required this.name,
    required this.address,
    required this.createdById,
    required this.createdAt,
    this.memberIds = const [],
    this.inviteCode,
  });

  Mess copyWith({
    String? id,
    String? name,
    String? address,
    String? createdById,
    DateTime? createdAt,
    List<String>? memberIds,
    String? inviteCode,
  }) {
    return Mess(
      id: id ?? this.id,
      name: name ?? this.name,
      address: address ?? this.address,
      createdById: createdById ?? this.createdById,
      createdAt: createdAt ?? this.createdAt,
      memberIds: memberIds ?? this.memberIds,
      inviteCode: inviteCode ?? this.inviteCode,
    );
  }

  factory Mess.fromJson(Map<String, dynamic> json) {
    return Mess(
      id: json['id'] as String,
      name: json['name'] as String,
      address: json['address'] as String,
      createdById: json['createdById'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      memberIds: List<String>.from(json['memberIds'] ?? []),
      inviteCode: json['inviteCode'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'createdById': createdById,
      'createdAt': createdAt.toIso8601String(),
      'memberIds': memberIds,
      'inviteCode': inviteCode,
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Mess &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          address == other.address &&
          createdById == other.createdById &&
          createdAt == other.createdAt &&
          memberIds.length == other.memberIds.length &&
          inviteCode == other.inviteCode;

  @override
  int get hashCode => Object.hash(
        id,
        name,
        address,
        createdById,
        createdAt,
        Object.hashAll(memberIds),
        inviteCode,
      );

  @override
  String toString() {
    return 'Mess(id: $id, name: $name, address: $address, createdById: $createdById, createdAt: $createdAt, memberIds: $memberIds, inviteCode: $inviteCode)';
  }
}
