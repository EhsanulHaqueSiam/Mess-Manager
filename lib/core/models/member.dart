import 'package:freezed_annotation/freezed_annotation.dart';

part 'member.freezed.dart';
part 'member.g.dart';

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
@freezed
sealed class FoodPreference with _$FoodPreference {
  const factory FoodPreference({
    required RestrictionType type,
    String? allergen,
    String? notes,
    @Default([])
    List<int> daysActive, // 1=Mon, 7=Sun (for part-time vegetarians)
  }) = _FoodPreference;

  factory FoodPreference.fromJson(Map<String, dynamic> json) =>
      _$FoodPreferenceFromJson(json);
}

/// Mess member
@freezed
sealed class Member with _$Member {
  const factory Member({
    required String id,
    required String name,
    @Default(MemberRole.member) MemberRole role,
    String? avatarUrl,
    String? phone,
    @Default([]) List<FoodPreference> preferences,
    @Default(0.0) double balance, // Positive = will receive, Negative = owes
    DateTime? joinedAt,
    // Temporary member fields
    DateTime? activeFromDate, // For temp members
    DateTime? activeToDate, // For temp members
    @Default(true) bool isActive,
  }) = _Member;

  factory Member.fromJson(Map<String, dynamic> json) => _$MemberFromJson(json);
}
