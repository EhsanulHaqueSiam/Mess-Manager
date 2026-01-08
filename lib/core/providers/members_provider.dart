import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mess_manager/core/models/member.dart';
import 'package:mess_manager/core/services/member_service.dart';
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
    try {
      final members = await MemberService.getMembers();
      state = members;
    } catch (e) {
      // Keep empty or handle error
    }
  }

  Future<void> refresh() async {
    try {
      final members = await MemberService.getMembers(forceRefresh: true);
      state = members;
    } catch (e) {
      // Handle error
    }
  }

  Future<void> addMember(Member member) async {
    // Optimistic update
    state = [...state, member];
    try {
      await MemberService.saveMember(member);
    } catch (e) {
      // Revert on failure
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
    state = state.where((m) => m.id != id).toList();
    try {
      await MemberService.deleteMember(id);
    } catch (e) {
      state = oldState;
      rethrow;
    }
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
