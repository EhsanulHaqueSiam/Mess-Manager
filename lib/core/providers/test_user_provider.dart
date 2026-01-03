import 'package:flutter_riverpod/flutter_riverpod.dart';

/// User Roles
enum UserRole {
  superAdmin, // Can do everything, assign admins
  admin, // Can manage members, add entries for others
  member, // Regular member, can only manage own entries
  guest, // View only (for demo)
}

/// Test User Model
class TestUser {
  final String id;
  final String name;
  final String email;
  final UserRole role;
  final String? messId;

  const TestUser({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.messId,
  });

  bool get isSuperAdmin => role == UserRole.superAdmin;
  bool get isAdmin => role == UserRole.admin || role == UserRole.superAdmin;
  bool get canManageMembers => isAdmin;
  bool get canAddForOthers => isAdmin;
  bool get canAssignRoles => isSuperAdmin;
}

/// Available test users for testing different roles
class TestUsers {
  static const superAdmin = TestUser(
    id: 'test_super_admin',
    name: 'Siam (Super Admin)',
    email: 'siam@area51.com',
    role: UserRole.superAdmin,
    messId: 'mess_area51',
  );

  static const admin = TestUser(
    id: 'test_admin',
    name: 'Rakib (Admin)',
    email: 'rakib@area51.com',
    role: UserRole.admin,
    messId: 'mess_area51',
  );

  static const member1 = TestUser(
    id: 'test_member_1',
    name: 'Fahim (Member)',
    email: 'fahim@area51.com',
    role: UserRole.member,
    messId: 'mess_area51',
  );

  static const member2 = TestUser(
    id: 'test_member_2',
    name: 'Sakib (Member)',
    email: 'sakib@area51.com',
    role: UserRole.member,
    messId: 'mess_area51',
  );

  static const guest = TestUser(
    id: 'test_guest',
    name: 'Guest Viewer',
    email: 'guest@demo.com',
    role: UserRole.guest,
    messId: 'mess_area51',
  );

  static List<TestUser> get all => [superAdmin, admin, member1, member2, guest];
}

/// Current test user provider
class CurrentTestUserNotifier extends Notifier<TestUser> {
  @override
  TestUser build() {
    // Default to super admin for full access during testing
    return TestUsers.superAdmin;
  }

  void switchUser(TestUser user) {
    state = user;
  }

  void switchToSuperAdmin() => state = TestUsers.superAdmin;
  void switchToAdmin() => state = TestUsers.admin;
  void switchToMember() => state = TestUsers.member1;
  void switchToGuest() => state = TestUsers.guest;
}

final currentTestUserProvider =
    NotifierProvider<CurrentTestUserNotifier, TestUser>(
      CurrentTestUserNotifier.new,
    );

/// Convenience providers
final isTestModeProvider = Provider<bool>((ref) => true); // Toggle for prod

final currentUserIdProvider = Provider<String>((ref) {
  return ref.watch(currentTestUserProvider).id;
});

final currentUserRoleProvider = Provider<UserRole>((ref) {
  return ref.watch(currentTestUserProvider).role;
});

final canAddForOthersProvider = Provider<bool>((ref) {
  return ref.watch(currentTestUserProvider).canAddForOthers;
});

final canManageMembersProvider = Provider<bool>((ref) {
  return ref.watch(currentTestUserProvider).canManageMembers;
});

final canAssignRolesProvider = Provider<bool>((ref) {
  return ref.watch(currentTestUserProvider).canAssignRoles;
});
