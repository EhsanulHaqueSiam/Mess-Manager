import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mess_manager/core/models/member.dart';
import 'package:mess_manager/core/providers/members_provider.dart';

/// Role permission definitions
/// Each permission maps to allowed roles
class RolePermissions {
  /// Can add/edit their own meals
  static const canAddMeal = {
    MemberRole.superAdmin,
    MemberRole.admin,
    MemberRole.mealManager,
    MemberRole.member,
    MemberRole.temp,
  };

  /// Can add/edit bazar entries
  static const canAddBazar = {
    MemberRole.superAdmin,
    MemberRole.admin,
    MemberRole.mealManager,
    MemberRole.member,
  };

  /// Can add money transactions
  static const canAddTransaction = {
    MemberRole.superAdmin,
    MemberRole.admin,
    MemberRole.member,
  };

  /// Can manage fixed expenses
  static const canManageFixedExpenses = {
    MemberRole.superAdmin,
    MemberRole.admin,
    MemberRole.maintenance,
  };

  /// Can manage duties
  static const canManageDuties = {
    MemberRole.superAdmin,
    MemberRole.admin,
    MemberRole.maintenance,
    MemberRole.member,
  };

  /// Can manage members (add/edit/remove)
  static const canManageMembers = {MemberRole.superAdmin, MemberRole.admin};

  /// Can close month / lock data
  static const canCloseMonth = {MemberRole.superAdmin, MemberRole.admin};

  /// Can bypass time locks
  static const canBypassTimeLock = {MemberRole.superAdmin, MemberRole.admin};

  /// Can edit other users' entries
  static const canEditOthersEntries = {MemberRole.superAdmin, MemberRole.admin};

  /// Can see settlement details
  static const canViewSettlement = {
    MemberRole.superAdmin,
    MemberRole.admin,
    MemberRole.member,
    MemberRole.temp,
  };

  /// View only (no write access)
  static const viewOnly = {MemberRole.guest};
}

/// Extension on MemberRole for quick permission checks
extension MemberRolePermissions on MemberRole {
  bool get canAddMeal => RolePermissions.canAddMeal.contains(this);
  bool get canAddBazar => RolePermissions.canAddBazar.contains(this);
  bool get canAddTransaction =>
      RolePermissions.canAddTransaction.contains(this);
  bool get canManageFixedExpenses =>
      RolePermissions.canManageFixedExpenses.contains(this);
  bool get canManageDuties => RolePermissions.canManageDuties.contains(this);
  bool get canManageMembers => RolePermissions.canManageMembers.contains(this);
  bool get canCloseMonth => RolePermissions.canCloseMonth.contains(this);
  bool get canBypassTimeLock =>
      RolePermissions.canBypassTimeLock.contains(this);
  bool get canEditOthersEntries =>
      RolePermissions.canEditOthersEntries.contains(this);
  bool get canViewSettlement =>
      RolePermissions.canViewSettlement.contains(this);
  bool get isViewOnly => RolePermissions.viewOnly.contains(this);
  bool get isAdmin => this == MemberRole.superAdmin || this == MemberRole.admin;
  bool get isSuperAdmin => this == MemberRole.superAdmin;
}

/// Provider for current user's role
final currentUserRoleProvider = Provider<MemberRole>((ref) {
  final currentId = ref.watch(currentMemberIdProvider);
  final members = ref.watch(membersProvider);

  final currentMember = members.where((m) => m.id == currentId).firstOrNull;
  return currentMember?.role ?? MemberRole.member;
});

/// Permission check providers for easy use in widgets
final canAddMealProvider = Provider<bool>((ref) {
  return ref.watch(currentUserRoleProvider).canAddMeal;
});

final canAddBazarProvider = Provider<bool>((ref) {
  return ref.watch(currentUserRoleProvider).canAddBazar;
});

final canAddTransactionProvider = Provider<bool>((ref) {
  return ref.watch(currentUserRoleProvider).canAddTransaction;
});

final canManageMembersProvider = Provider<bool>((ref) {
  return ref.watch(currentUserRoleProvider).canManageMembers;
});

final canCloseMonthProvider = Provider<bool>((ref) {
  return ref.watch(currentUserRoleProvider).canCloseMonth;
});

final canEditOthersEntriesProvider = Provider<bool>((ref) {
  return ref.watch(currentUserRoleProvider).canEditOthersEntries;
});

final isAdminProvider = Provider<bool>((ref) {
  return ref.watch(currentUserRoleProvider).isAdmin;
});

final isSuperAdminProvider = Provider<bool>((ref) {
  return ref.watch(currentUserRoleProvider).isSuperAdmin;
});
