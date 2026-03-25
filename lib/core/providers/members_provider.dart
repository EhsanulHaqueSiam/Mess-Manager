import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mess_manager/core/models/member.dart';
import 'package:mess_manager/core/services/member_service.dart';
import 'package:mess_manager/core/database/isar_service.dart';
import 'package:mess_manager/features/auth/providers/auth_provider.dart';

/// Provider for all members
final membersProvider = NotifierProvider<MembersNotifier, List<Member>>(
  MembersNotifier.new,
);

class MembersNotifier extends Notifier<List<Member>> {
  @override
  List<Member> build() {
    // Initial load from service
    _loadMembers();
    return [];
  }

  Future<void> _loadMembers() async {
    // Offline-first: try local first, then Firebase
    final localMembers = IsarService.getAllMembers();
    if (localMembers.isNotEmpty) {
      state = localMembers;
    }

    try {
      final members = await MemberService.getMembers();
      if (members.isNotEmpty) {
        state = members;
      }
    } catch (e) {
      debugPrint('MembersNotifier: Failed to load from Firestore: $e');
    }
  }

  Future<void> refresh() async {
    try {
      final members = await MemberService.getMembers(forceRefresh: true);
      state = members;
    } catch (e) {
      debugPrint('MembersNotifier: Failed to refresh: $e');
    }
  }

  Future<void> addMember(Member member) async {
    // Optimistic update
    state = [...state, member];

    try {
      await MemberService.saveMember(member);
    } catch (e) {
      state = state.where((m) => m.id != member.id).toList();
      rethrow;
    }
  }

  Future<void> updateMember(Member member) async {
    final oldState = state;

    state = [
      for (final m in state)
        if (m.id == member.id) member else m,
    ];

    try {
      await MemberService.saveMember(member);
    } catch (e) {
      state = oldState;
      rethrow;
    }
  }

  Future<void> deleteMember(String id) async {
    final oldState = state;
    final removedMember = state.firstWhere(
      (m) => m.id == id,
      orElse: () => const Member(id: '', name: ''),
    );

    state = state.where((m) => m.id != id).toList();

    // Gap 3: Auto-succession — if removing a superAdmin, promote next in line
    if (removedMember.role == MemberRole.superAdmin && state.isNotEmpty) {
      final activeMembers = state.where((m) => m.isActive).toList();
      if (activeMembers.isNotEmpty) {
        // Priority: admin > mealManager > maintenance > member (by joinedAt)
        final successor = _findSuccessor(activeMembers);
        if (successor != null) {
          state = [
            for (final m in state)
              if (m.id == successor.id)
                m.copyWith(role: MemberRole.superAdmin)
              else
                m,
          ];
          debugPrint(
            'SuperAdmin succession: ${successor.name} promoted to superAdmin',
          );
        }
      }
    }

    try {
      await MemberService.deleteMember(id);
    } catch (e) {
      state = oldState;
      rethrow;
    }
  }

  /// Find the best successor for superAdmin role.
  /// Priority: existing admins first (by join date), then other active members.
  Member? _findSuccessor(List<Member> activeMembers) {
    // Try admins first
    final admins = activeMembers
        .where((m) => m.role == MemberRole.admin)
        .toList()
      ..sort((a, b) => (a.joinedAt ?? DateTime.now())
          .compareTo(b.joinedAt ?? DateTime.now()));
    if (admins.isNotEmpty) return admins.first;

    // Then mealManagers
    final managers = activeMembers
        .where((m) => m.role == MemberRole.mealManager)
        .toList()
      ..sort((a, b) => (a.joinedAt ?? DateTime.now())
          .compareTo(b.joinedAt ?? DateTime.now()));
    if (managers.isNotEmpty) return managers.first;

    // Then any active member (longest serving)
    final others = activeMembers
        .where((m) =>
            m.role != MemberRole.guest && m.role != MemberRole.temp)
        .toList()
      ..sort((a, b) => (a.joinedAt ?? DateTime.now())
          .compareTo(b.joinedAt ?? DateTime.now()));
    if (others.isNotEmpty) return others.first;

    // Last resort: any active member
    return activeMembers.first;
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
/// Links to authenticated user by email
final currentMemberIdProvider = NotifierProvider<CurrentMemberNotifier, String>(
  CurrentMemberNotifier.new,
);

class CurrentMemberNotifier extends Notifier<String> {
  @override
  String build() {
    // Watch auth user and members
    final authUser = ref.watch(currentUserProvider);
    final members = ref.watch(membersProvider);

    // Try to find member matching auth user's email
    if (authUser != null && members.isNotEmpty) {
      final matchByEmail = members
          .where((m) => m.email == authUser.email)
          .firstOrNull;
      if (matchByEmail != null) return matchByEmail.id;

      // Fallback: try matching by name (for legacy data)
      final matchByName = members
          .where((m) => m.name == authUser.name)
          .firstOrNull;
      if (matchByName != null) return matchByName.id;
    }

    // Fallback to first member if no match found
    if (members.isNotEmpty) return members.first.id;
    return '';
  }

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
