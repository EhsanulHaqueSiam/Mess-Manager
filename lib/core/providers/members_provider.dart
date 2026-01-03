import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mess_manager/core/models/member.dart';

/// Sample members for the mess (hardcoded for now)
final sampleMembers = [
  Member(
    id: '1',
    name: 'Siam',
    role: MemberRole.superAdmin,
    preferences: [],
    joinedAt: DateTime(2024, 1, 1),
  ),
  Member(
    id: '2',
    name: 'Tanmoy',
    role: MemberRole.admin,
    preferences: [const FoodPreference(type: RestrictionType.noBeef)],
    joinedAt: DateTime(2024, 1, 1),
  ),
  Member(
    id: '3',
    name: 'Sarkar',
    role: MemberRole.member,
    preferences: [
      const FoodPreference(
        type: RestrictionType.vegetarian,
        daysActive: [2, 4], // Tue, Thu
        notes: 'Vegetarian on Tuesdays and Thursdays',
      ),
    ],
    joinedAt: DateTime(2024, 2, 15),
  ),
  Member(
    id: '4',
    name: 'Shahriyer',
    role: MemberRole.member,
    preferences: [
      const FoodPreference(
        type: RestrictionType.allergic,
        allergen: 'shrimp',
        notes: 'Allergic to shrimp',
      ),
    ],
    joinedAt: DateTime(2024, 3, 1),
  ),
];

/// Provider for all members
final membersProvider = NotifierProvider<MembersNotifier, List<Member>>(
  MembersNotifier.new,
);

class MembersNotifier extends Notifier<List<Member>> {
  @override
  List<Member> build() => List.from(sampleMembers);

  void updateBalance(String memberId, double balance) {
    state = [
      for (final member in state)
        if (member.id == memberId)
          member.copyWith(balance: balance)
        else
          member,
    ];
  }

  Member? getMember(String id) {
    try {
      return state.firstWhere((m) => m.id == id);
    } catch (_) {
      return null;
    }
  }
}

/// Provider for currently selected/logged-in member
final currentMemberIdProvider = NotifierProvider<CurrentMemberNotifier, String>(
  CurrentMemberNotifier.new,
);

class CurrentMemberNotifier extends Notifier<String> {
  @override
  String build() => '3'; // Default: Sarkar (member) - Change to '1' for Siam (superAdmin)

  void setMember(String id) => state = id;
}

/// Derived provider for current member
final currentMemberProvider = Provider<Member?>((ref) {
  final members = ref.watch(membersProvider);
  final currentId = ref.watch(currentMemberIdProvider);
  try {
    return members.firstWhere((m) => m.id == currentId);
  } catch (_) {
    return null;
  }
});
