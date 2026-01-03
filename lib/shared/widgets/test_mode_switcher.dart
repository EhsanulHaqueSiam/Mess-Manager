import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:gap/gap.dart';

import 'package:mess_manager/core/theme/app_theme.dart';
import 'package:mess_manager/core/providers/test_user_provider.dart';
import 'package:mess_manager/core/services/haptic_service.dart';

/// Test Mode Switcher - Shows current role and allows switching
///
/// This is a development-only widget for testing different user roles.
/// Remove or hide this in production.
class TestModeSwitcher extends ConsumerWidget {
  const TestModeSwitcher({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentTestUserProvider);

    return GestureDetector(
      onTap: () => _showRoleSwitcher(context, ref),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: AppSpacing.xs,
        ),
        decoration: BoxDecoration(
          color: _getRoleColor(currentUser.role).withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
          border: Border.all(
            color: _getRoleColor(currentUser.role).withValues(alpha: 0.5),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              _getRoleIcon(currentUser.role),
              size: 14,
              color: _getRoleColor(currentUser.role),
            ),
            const Gap(4),
            Text(
              _getRoleName(currentUser.role),
              style: AppTypography.labelSmall.copyWith(
                color: _getRoleColor(currentUser.role),
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showRoleSwitcher(BuildContext context, WidgetRef ref) {
    HapticService.modalOpen();
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: AppColors.surfaceDark,
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(AppSpacing.radiusLg),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Gap(AppSpacing.md),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.borderDark,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const Gap(AppSpacing.lg),
            Text(
              '🧪 Test Mode - Switch User',
              style: AppTypography.titleMedium.copyWith(
                color: AppColors.textPrimaryDark,
              ),
            ),
            const Gap(AppSpacing.sm),
            Text(
              'Select a role to test the app as different users',
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.textMutedDark,
              ),
            ),
            const Gap(AppSpacing.lg),
            ...TestUsers.all.map((user) => _buildUserTile(context, ref, user)),
            const Gap(AppSpacing.lg),
          ],
        ),
      ),
    );
  }

  Widget _buildUserTile(BuildContext context, WidgetRef ref, TestUser user) {
    final currentUser = ref.watch(currentTestUserProvider);
    final isSelected = currentUser.id == user.id;

    return ListTile(
      onTap: () {
        HapticService.success();
        ref.read(currentTestUserProvider.notifier).switchUser(user);
        Navigator.pop(context);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Switched to ${user.name}'),
            backgroundColor: _getRoleColor(user.role),
          ),
        );
      },
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: _getRoleColor(user.role).withValues(alpha: 0.2),
          shape: BoxShape.circle,
        ),
        child: Icon(
          _getRoleIcon(user.role),
          color: _getRoleColor(user.role),
          size: 20,
        ),
      ),
      title: Text(
        user.name,
        style: TextStyle(
          color: isSelected ? AppColors.primary : AppColors.textPrimaryDark,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
        ),
      ),
      subtitle: Text(
        _getRoleName(user.role),
        style: TextStyle(color: _getRoleColor(user.role), fontSize: 12),
      ),
      trailing: isSelected
          ? Icon(LucideIcons.check, color: AppColors.success, size: 20)
          : null,
    );
  }

  Color _getRoleColor(UserRole role) {
    switch (role) {
      case UserRole.superAdmin:
        return AppColors.error; // Red for super admin
      case UserRole.admin:
        return AppColors.warning; // Orange for admin
      case UserRole.member:
        return AppColors.success; // Green for member
      case UserRole.guest:
        return AppColors.textMutedDark; // Gray for guest
    }
  }

  IconData _getRoleIcon(UserRole role) {
    switch (role) {
      case UserRole.superAdmin:
        return LucideIcons.crown;
      case UserRole.admin:
        return LucideIcons.shield;
      case UserRole.member:
        return LucideIcons.user;
      case UserRole.guest:
        return LucideIcons.eye;
    }
  }

  String _getRoleName(UserRole role) {
    switch (role) {
      case UserRole.superAdmin:
        return 'Super Admin';
      case UserRole.admin:
        return 'Admin';
      case UserRole.member:
        return 'Member';
      case UserRole.guest:
        return 'Guest';
    }
  }
}
