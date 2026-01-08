import 'dart:convert';
import 'package:isar_plus/isar_plus.dart';
import '../../models/member.dart';

part 'member_collection.g.dart';

/// Isar collection for Member data
@collection
class MemberCollection {
  /// Auto-incrementing ID - Isar assigns this automatically
  late int id;

  @Index(unique: true)
  late String memberId;

  late String name;

  /// Role stored as int (enum index)
  late int roleIndex;

  String? avatarUrl;
  String? phone;
  String? email; // For auth user linking

  late double balance;

  DateTime? joinedAt;
  DateTime? activeFromDate;
  DateTime? activeToDate;

  late bool isActive;

  /// Food preferences stored as JSON string
  String? preferencesJson;

  // ─────────────────────────────────────────────────────────────────────────
  // Model Converters
  // ─────────────────────────────────────────────────────────────────────────

  /// Convert to Freezed Member model
  Member toModel() {
    List<FoodPreference> preferences = [];
    if (preferencesJson != null && preferencesJson!.isNotEmpty) {
      try {
        final List<dynamic> prefList = jsonDecode(preferencesJson!);
        preferences = prefList
            .map((p) => FoodPreference.fromJson(Map<String, dynamic>.from(p)))
            .toList();
      } catch (_) {}
    }

    return Member(
      id: memberId,
      name: name,
      role: MemberRole.values[roleIndex],
      avatarUrl: avatarUrl,
      phone: phone,
      email: email,
      preferences: preferences,
      balance: balance,
      joinedAt: joinedAt,
      activeFromDate: activeFromDate,
      activeToDate: activeToDate,
      isActive: isActive,
    );
  }

  /// Create from Freezed Member model
  static MemberCollection fromModel(Member m) {
    String? prefJson;
    if (m.preferences.isNotEmpty) {
      prefJson = jsonEncode(m.preferences.map((p) => p.toJson()).toList());
    }

    return MemberCollection()
      ..memberId = m.id
      ..name = m.name
      ..roleIndex = m.role.index
      ..avatarUrl = m.avatarUrl
      ..phone = m.phone
      ..email = m.email
      ..balance = m.balance
      ..joinedAt = m.joinedAt
      ..activeFromDate = m.activeFromDate
      ..activeToDate = m.activeToDate
      ..isActive = m.isActive
      ..preferencesJson = prefJson;
  }
}
