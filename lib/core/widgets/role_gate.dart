import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mess_manager/core/models/member.dart';
import 'package:mess_manager/core/providers/role_provider.dart';

/// Widget that conditionally shows content based on user role permissions
class RoleGate extends ConsumerWidget {
  /// The child to show if permission is granted
  final Widget child;

  /// Optional widget to show if permission is denied (defaults to nothing)
  final Widget? fallback;

  /// Required roles to see the child (any of these roles grants access)
  final Set<MemberRole>? allowedRoles;

  /// Permission check (use providers from role_provider.dart)
  final Provider<bool>? permission;

  /// If true, shows disabled version instead of hiding
  final bool showDisabled;

  const RoleGate({
    super.key,
    required this.child,
    this.fallback,
    this.allowedRoles,
    this.permission,
    this.showDisabled = false,
  }) : assert(allowedRoles != null || permission != null);

  /// Factory for meal-related actions
  RoleGate.meal({
    super.key,
    required this.child,
    this.fallback,
    this.showDisabled = false,
  }) : allowedRoles = null,
       permission = canAddMealProvider;

  /// Factory for bazar-related actions
  RoleGate.bazar({
    super.key,
    required this.child,
    this.fallback,
    this.showDisabled = false,
  }) : allowedRoles = null,
       permission = canAddBazarProvider;

  /// Factory for transaction-related actions
  RoleGate.transaction({
    super.key,
    required this.child,
    this.fallback,
    this.showDisabled = false,
  }) : allowedRoles = null,
       permission = canAddTransactionProvider;

  /// Factory for admin-only actions
  RoleGate.admin({
    super.key,
    required this.child,
    this.fallback,
    this.showDisabled = false,
  }) : allowedRoles = null,
       permission = isAdminProvider;

  /// Factory for super admin only
  RoleGate.superAdmin({
    super.key,
    required this.child,
    this.fallback,
    this.showDisabled = false,
  }) : allowedRoles = null,
       permission = isSuperAdminProvider;

  /// Factory for member management
  RoleGate.memberManagement({
    super.key,
    required this.child,
    this.fallback,
    this.showDisabled = false,
  }) : allowedRoles = null,
       permission = canManageMembersProvider;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    bool hasAccess;

    if (permission != null) {
      hasAccess = ref.watch(permission!);
    } else if (allowedRoles != null) {
      final userRole = ref.watch(currentUserRoleProvider);
      hasAccess = allowedRoles!.contains(userRole);
    } else {
      hasAccess = true;
    }

    if (hasAccess) {
      return child;
    }

    if (showDisabled) {
      return IgnorePointer(child: Opacity(opacity: 0.4, child: child));
    }

    return fallback ?? const SizedBox.shrink();
  }
}

/// Extension for quick role checks in widgets
extension RoleGateContext on BuildContext {
  /// Check if a callback should be allowed based on role
  VoidCallback? guardAction(bool hasPermission, VoidCallback action) {
    return hasPermission ? action : null;
  }
}
