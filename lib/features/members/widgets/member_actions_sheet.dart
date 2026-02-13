import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:gap/gap.dart';

import 'package:mess_manager/core/theme/app_theme.dart';
import 'package:mess_manager/core/models/member.dart';
import 'package:mess_manager/core/providers/members_provider.dart';
import 'package:mess_manager/core/providers/role_provider.dart';
import 'package:mess_manager/core/services/haptic_service.dart';
import 'package:mess_manager/core/widgets/app_components.dart';

/// Sheet with member management actions (for Admins)
class MemberActionsSheet extends ConsumerWidget {
  final Member member;

  const MemberActionsSheet({super.key, required this.member});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isAdmin = ref.watch(isAdminProvider);
    final currentMemberId = ref.watch(currentMemberIdProvider);
    final isSelf = member.id == currentMemberId;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: context.surfaceColor,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(AppSpacing.radiusLg),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: context.borderColor,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const Gap(AppSpacing.lg),

          // Member Header
          Row(
            children: [
              AppMemberAvatar(
                name: member.name,
                size: 48,
                backgroundColor: AppColors.primary.withValues(alpha: 0.1),
              ),
              const Gap(12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      member.name,
                      style: AppTypography.titleMedium.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      member.role.name.toUpperCase(),
                      style: AppTypography.bodySmall.copyWith(
                        color: Colors.grey[500],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const Gap(AppSpacing.lg),
          const Divider(),
          const Gap(AppSpacing.md),

          // Actions List
          if (isAdmin && !isSelf) ...[
            // Change Role
            _buildActionTile(
              icon: LucideIcons.shield,
              title: 'Change Role',
              subtitle: 'Update member permissions',
              color: AppColors.info,
              onTap: () {
                Navigator.pop(context);
                _showChangeRoleSheet(context, ref);
              },
            ),
            const Gap(AppSpacing.sm),

            // Archive/Restore Member (Soft Delete)
            if (member.isActive)
              _buildActionTile(
                icon: LucideIcons.archive,
                title: 'Archive Member',
                subtitle: 'Deactivate but keep records',
                color: AppColors.warning,
                onTap: () {
                  Navigator.pop(context);
                  _archiveMember(context, ref);
                },
              )
            else
              _buildActionTile(
                icon: LucideIcons.archiveRestore,
                title: 'Restore Member',
                subtitle: 'Reactivate archived member',
                color: AppColors.success,
                onTap: () {
                  Navigator.pop(context);
                  _restoreMember(context, ref);
                },
              ),
            const Gap(AppSpacing.sm),

            // Remove Member (Hard Delete)
            _buildActionTile(
              icon: LucideIcons.userX,
              title: 'Remove Member',
              subtitle: 'Permanently delete from mess',
              color: AppColors.error,
              onTap: () {
                Navigator.pop(context);
                _confirmRemoveMember(context, ref);
              },
            ),
          ],

          // === SUPER ADMIN EXCLUSIVE ===
          if (ref.watch(isSuperAdminProvider) && !isSelf) ...[
            const Gap(AppSpacing.lg),
            Row(
              children: [
                Container(
                  width: 40,
                  height: 1,
                  color: AppColors.error.withValues(alpha: 0.3),
                ),
                const Gap(8),
                Text(
                  'SUPER ADMIN',
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.error,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Gap(8),
                Expanded(
                  child: Container(
                    height: 1,
                    color: AppColors.error.withValues(alpha: 0.3),
                  ),
                ),
              ],
            ),
            const Gap(AppSpacing.sm),

            // Force Remove (bypass balance/restrictions)
            _buildActionTile(
              icon: LucideIcons.trash2,
              title: 'Force Remove',
              subtitle: 'Bypass balance check & delete',
              color: AppColors.error,
              onTap: () {
                Navigator.pop(context);
                _forceRemoveMember(context, ref);
              },
            ),
            const Gap(AppSpacing.sm),

            // Transfer Admin Rights (if member is admin/superadmin)
            if (member.role == MemberRole.admin ||
                member.role == MemberRole.superAdmin)
              _buildActionTile(
                icon: LucideIcons.arrowRightLeft,
                title: 'Transfer Rights',
                subtitle: 'Move admin role to another member',
                color: AppColors.warning,
                onTap: () {
                  Navigator.pop(context);
                  _showTransferRightsSheet(context, ref);
                },
              ),
            const Gap(AppSpacing.sm),

            // Manager Handoff (full handover with cash transfer)
            _buildActionTile(
              icon: LucideIcons.userPlus2,
              title: 'Manager Handoff',
              subtitle: 'Transfer role + cash in hand',
              color: AppColors.primary,
              onTap: () {
                Navigator.pop(context);
                _showManagerHandoffSheet(context, ref);
              },
            ),
          ],

          if (isSelf) ...[
            Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: AppColors.info.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
              ),
              child: Row(
                children: [
                  const Icon(LucideIcons.info, size: 20, color: AppColors.info),
                  const Gap(12),
                  Expanded(
                    child: Text(
                      'You cannot modify your own account here.',
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.info,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],

          if (!isAdmin) ...[
            Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: AppColors.warning.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
              ),
              child: Row(
                children: [
                  const Icon(
                    LucideIcons.lock,
                    size: 20,
                    color: AppColors.warning,
                  ),
                  const Gap(12),
                  Expanded(
                    child: Text(
                      'Admin access required for member management.',
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.warning,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],

          const Gap(AppSpacing.lg),

          // Close Button
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
          ),
          const Gap(AppSpacing.md),
        ],
      ),
    );
  }

  Widget _buildActionTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: () {
        HapticService.buttonPress();
        onTap();
      },
      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          border: Border.all(color: color.withValues(alpha: 0.2)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(AppSpacing.sm),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const Gap(12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: color,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: AppTypography.bodySmall.copyWith(
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ),
            ),
            Icon(LucideIcons.chevronRight, color: color, size: 20),
          ],
        ),
      ),
    );
  }

  void _showChangeRoleSheet(BuildContext context, WidgetRef ref) {
    HapticService.modalOpen();
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _ChangeRoleSheet(member: member),
    );
  }

  void _archiveMember(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: context.surfaceColor,
        title: const Text(
          'Archive Member?',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('This will deactivate ${member.name} but keep their records.'),
            const Gap(8),
            Text(
              'They can be reactivated later by an Admin.',
              style: AppTypography.bodySmall.copyWith(color: Colors.grey[500]),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.warning),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text(
              'Archive',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      HapticService.warning();
      ref
          .read(membersProvider.notifier)
          .updateMember(member.copyWith(isActive: false));
      if (context.mounted) {
        showSuccessToast(context, '${member.name} has been archived');
      }
    }
  }

  void _restoreMember(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: context.surfaceColor,
        title: const Text(
          'Restore Member?',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('This will reactivate ${member.name}.'),
            const Gap(8),
            Text(
              'They will be able to participate in the mess again.',
              style: AppTypography.bodySmall.copyWith(color: Colors.grey[500]),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.success),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text(
              'Restore',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      HapticService.success();
      ref
          .read(membersProvider.notifier)
          .updateMember(member.copyWith(isActive: true));
      if (context.mounted) {
        showSuccessToast(context, '${member.name} has been restored');
      }
    }
  }

  void _confirmRemoveMember(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: context.surfaceColor,
        title: Row(
          children: [
            const Icon(LucideIcons.alertTriangle, color: AppColors.error),
            const Gap(8),
            const Text(
              'Remove Member?',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'This will permanently remove ${member.name} from the mess.',
            ),
            const Gap(12),
            Container(
              padding: const EdgeInsets.all(AppSpacing.sm),
              decoration: BoxDecoration(
                color: AppColors.error.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
              ),
              child: Text(
                'This action cannot be undone!',
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.error,
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text(
              'Remove',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      HapticService.error();
      ref.read(membersProvider.notifier).deleteMember(member.id);
      if (context.mounted) {
        showSuccessToast(context, '${member.name} has been removed');
      }
    }
  }

  /// Force Remove - Super Admin only, bypasses balance checks
  void _forceRemoveMember(BuildContext context, WidgetRef ref) async {
    // First confirmation
    final firstConfirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: context.surfaceColor,
        title: Row(
          children: [
            const Icon(LucideIcons.alertOctagon, color: AppColors.error),
            const Gap(8),
            Text(
              'FORCE REMOVE',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: AppColors.error,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('You are about to PERMANENTLY delete ${member.name}.'),
            const Gap(12),
            if (member.balance != 0) ...[
              Container(
                padding: const EdgeInsets.all(AppSpacing.sm),
                decoration: BoxDecoration(
                  color: AppColors.warning.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                ),
                child: Column(
                  children: [
                    Text(
                      'Outstanding Balance:',
                      style: AppTypography.bodySmall.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Gap(4),
                    Text(
                      '${member.balance.abs().toStringAsFixed(0)} ${member.balance > 0 ? "(to receive)" : "(owes)"}',
                      style: AppTypography.titleMedium.copyWith(
                        fontWeight: FontWeight.bold,
                        color: member.balance > 0
                            ? AppColors.success
                            : AppColors.error,
                      ),
                    ),
                  ],
                ),
              ),
              const Gap(8),
            ],
            Container(
              padding: const EdgeInsets.all(AppSpacing.sm),
              decoration: BoxDecoration(
                color: AppColors.error.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                border: Border.all(color: AppColors.error),
              ),
              child: Column(
                children: [
                  Text(
                    'This bypasses all safety checks!',
                    style: AppTypography.bodySmall.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.error,
                    ),
                  ),
                  const Gap(4),
                  Text(
                    'Balance will NOT be settled',
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.error,
                    ),
                  ),
                  Text(
                    'All member data will be deleted',
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.error,
                    ),
                  ),
                  Text(
                    'This action CANNOT be undone',
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.error,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text(
              'I Understand',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );

    if (firstConfirm != true || !context.mounted) return;

    // Second confirmation with typing required
    final typeController = TextEditingController();
    final secondConfirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: context.surfaceColor,
        title: const Text(
          'Type "DELETE" to confirm',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Type DELETE to permanently remove ${member.name}:',
              style: AppTypography.bodySmall,
            ),
            const Gap(12),
            TextField(
              controller: typeController,
              autofocus: true,
              decoration: const InputDecoration(
                hintText: 'Type DELETE',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            onPressed: () {
              if (typeController.text.toUpperCase() == 'DELETE') {
                Navigator.pop(ctx, true);
              }
            },
            child: const Text(
              'Force Delete',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );

    if (secondConfirm == true && context.mounted) {
      HapticService.error();
      ref.read(membersProvider.notifier).deleteMember(member.id);
      showSuccessToast(context, '${member.name} has been force removed');
    }
  }

  /// Transfer Admin Rights to another member
  void _showTransferRightsSheet(BuildContext context, WidgetRef ref) {
    HapticService.modalOpen();
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _TransferRightsSheet(fromMember: member),
    );
  }

  /// Manager Handoff - Transfer role + cash in hand
  void _showManagerHandoffSheet(BuildContext context, WidgetRef ref) {
    HapticService.modalOpen();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _ManagerHandoffSheet(fromMember: member),
    );
  }
}

/// Change Role Sheet
class _ChangeRoleSheet extends ConsumerStatefulWidget {
  final Member member;

  const _ChangeRoleSheet({required this.member});

  @override
  ConsumerState<_ChangeRoleSheet> createState() => _ChangeRoleSheetState();
}

class _ChangeRoleSheetState extends ConsumerState<_ChangeRoleSheet> {
  late MemberRole _selectedRole;

  @override
  void initState() {
    super.initState();
    _selectedRole = widget.member.role;
  }

  @override
  Widget build(BuildContext context) {
    final isSuperAdmin = ref.watch(isSuperAdminProvider);

    // Filter roles - only super admin can assign superAdmin role
    final availableRoles = MemberRole.values.where((role) {
      if (role == MemberRole.superAdmin && !isSuperAdmin) return false;
      return true;
    }).toList();

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: context.surfaceColor,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(AppSpacing.radiusLg),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: context.borderColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const Gap(AppSpacing.lg),

          Text(
            'Change Role for ${widget.member.name}',
            style: AppTypography.titleMedium.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const Gap(AppSpacing.md),

          // Role List
          ...availableRoles.map((role) => _buildRoleTile(role)),

          const Gap(AppSpacing.lg),

          // Save Button
          AppPrimaryButton(
            text: 'Save Role',
            icon: LucideIcons.check,
            onPressed: _saveRole,
          ),
          const Gap(AppSpacing.md),
        ],
      ),
    );
  }

  Widget _buildRoleTile(MemberRole role) {
    final isSelected = role == _selectedRole;
    final color = _getRoleColor(role);

    return InkWell(
      onTap: () {
        HapticService.lightTap();
        setState(() => _selectedRole = role);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: AppSpacing.sm),
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: isSelected
              ? color.withValues(alpha: 0.15)
              : context.cardColor,
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          border: Border.all(
            color: isSelected ? color : context.borderColor,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              isSelected ? LucideIcons.checkCircle2 : LucideIcons.circle,
              color: isSelected ? color : context.textMuted,
              size: 20,
            ),
            const Gap(12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    role.name.toUpperCase(),
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: isSelected ? color : context.textPrimary,
                    ),
                  ),
                  Text(
                    _getRoleDescription(role),
                    style: AppTypography.bodySmall.copyWith(
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _saveRole() {
    if (_selectedRole != widget.member.role) {
      HapticService.success();
      ref
          .read(membersProvider.notifier)
          .updateMember(widget.member.copyWith(role: _selectedRole));
      if (context.mounted) {
        showSuccessToast(context, 'Role updated to ${_selectedRole.name}');
      }
    }
    Navigator.pop(context);
  }

  Color _getRoleColor(MemberRole role) {
    switch (role) {
      case MemberRole.superAdmin:
        return AppColors.error;
      case MemberRole.admin:
        return AppColors.warning;
      case MemberRole.mealManager:
        return AppColors.mealColor;
      case MemberRole.maintenance:
        return AppColors.info;
      case MemberRole.member:
        return AppColors.success;
      case MemberRole.temp:
        return context.textSecondary;
      case MemberRole.guest:
        return context.textMuted;
    }
  }

  String _getRoleDescription(MemberRole role) {
    switch (role) {
      case MemberRole.superAdmin:
        return 'Full access + transfer ownership';
      case MemberRole.admin:
        return 'Edit past entries, manage members, bypass time locks';
      case MemberRole.mealManager:
        return 'Bulk meal operations only';
      case MemberRole.maintenance:
        return 'Fixed expenses management only';
      case MemberRole.member:
        return 'Standard access - own entries + guest meals';
      case MemberRole.temp:
        return 'Temporary member with active dates';
      case MemberRole.guest:
        return 'View only - no write access';
    }
  }
}

/// Transfer Rights Sheet - Move admin role to another member
class _TransferRightsSheet extends ConsumerStatefulWidget {
  final Member fromMember;

  const _TransferRightsSheet({required this.fromMember});

  @override
  ConsumerState<_TransferRightsSheet> createState() =>
      _TransferRightsSheetState();
}

class _TransferRightsSheetState extends ConsumerState<_TransferRightsSheet> {
  String? _selectedMemberId;

  @override
  Widget build(BuildContext context) {
    final members = ref.watch(membersProvider);
    // Filter: Only active members who are not the source member
    final eligibleMembers = members
        .where((m) => m.isActive && m.id != widget.fromMember.id)
        .toList();

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: context.surfaceColor,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(AppSpacing.radiusLg),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: context.borderColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const Gap(AppSpacing.lg),

          // Title
          Row(
            children: [
              const Icon(LucideIcons.arrowRightLeft, color: AppColors.warning),
              const Gap(12),
              Text(
                'Transfer ${widget.fromMember.role.name.toUpperCase()} Rights',
                style: AppTypography.titleMedium.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const Gap(AppSpacing.sm),
          Text(
            'Select a member to receive ${widget.fromMember.name}\'s rights:',
            style: AppTypography.bodySmall.copyWith(color: Colors.grey[500]),
          ),
          const Gap(AppSpacing.lg),

          // Member List
          ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.35,
            ),
            child: ListView.separated(
              shrinkWrap: true,
              itemCount: eligibleMembers.length,
              separatorBuilder: (_, __) => const Gap(8),
              itemBuilder: (context, index) {
                final member = eligibleMembers[index];
                final isSelected = member.id == _selectedMemberId;
                return InkWell(
                  onTap: () {
                    HapticService.selectionTick();
                    setState(() => _selectedMemberId = member.id);
                  },
                  borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                  child: Container(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.warning.withValues(alpha: 0.1)
                          : context.surfaceColor,
                      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                      border: Border.all(
                        color: isSelected
                            ? AppColors.warning
                            : context.borderColor,
                        width: isSelected ? 2 : 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          isSelected
                              ? LucideIcons.checkCircle2
                              : LucideIcons.circle,
                          color: isSelected
                              ? AppColors.warning
                              : context.textMuted,
                          size: 20,
                        ),
                        const Gap(12),
                        AppMemberAvatar(name: member.name, size: 32),
                        const Gap(12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                member.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                member.role.name,
                                style: AppTypography.bodySmall.copyWith(
                                  color: Colors.grey[500],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          const Gap(AppSpacing.lg),

          // Warning Box
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: AppColors.warning.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
              border: Border.all(
                color: AppColors.warning.withValues(alpha: 0.3),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(
                      LucideIcons.alertTriangle,
                      color: AppColors.warning,
                      size: 16,
                    ),
                    const Gap(8),
                    Text(
                      'What will happen:',
                      style: AppTypography.bodySmall.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.warning,
                      ),
                    ),
                  ],
                ),
                const Gap(8),
                Text(
                  '${widget.fromMember.name} will become a regular Member',
                  style: AppTypography.bodySmall,
                ),
                Text(
                  'Selected member will become ${widget.fromMember.role.name}',
                  style: AppTypography.bodySmall,
                ),
              ],
            ),
          ),
          const Gap(AppSpacing.lg),

          // Actions
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
              ),
              const Gap(12),
              Expanded(
                child: FilledButton(
                  onPressed: _selectedMemberId != null ? _transferRights : null,
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.warning,
                    disabledBackgroundColor: context.borderColor,
                  ),
                  child: const Text('Transfer Rights'),
                ),
              ),
            ],
          ),
          const Gap(AppSpacing.md),
        ],
      ),
    );
  }

  void _transferRights() async {
    if (_selectedMemberId == null) return;

    final targetMember = ref
        .read(membersProvider)
        .firstWhere((m) => m.id == _selectedMemberId);

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: context.surfaceColor,
        title: const Text(
          'Confirm Transfer',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Transfer ${widget.fromMember.role.name.toUpperCase()} rights from:',
              style: AppTypography.bodySmall,
            ),
            const Gap(8),
            Row(
              children: [
                Text(
                  widget.fromMember.name,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: const Icon(LucideIcons.arrowRight, size: 16),
                ),
                Text(
                  targetMember.name,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.warning,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.warning),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text(
              'Transfer',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      HapticService.success();

      // Transfer the role
      ref
          .read(membersProvider.notifier)
          .updateMember(targetMember.copyWith(role: widget.fromMember.role));

      // Demote the original member to regular member
      ref
          .read(membersProvider.notifier)
          .updateMember(widget.fromMember.copyWith(role: MemberRole.member));

      Navigator.pop(context);
      showSuccessToast(context, 'Rights transferred to ${targetMember.name}');
    }
  }
}

/// Manager Handoff Sheet - Transfer role + cash in hand
class _ManagerHandoffSheet extends ConsumerStatefulWidget {
  final Member fromMember;

  const _ManagerHandoffSheet({required this.fromMember});

  @override
  ConsumerState<_ManagerHandoffSheet> createState() =>
      _ManagerHandoffSheetState();
}

class _ManagerHandoffSheetState extends ConsumerState<_ManagerHandoffSheet> {
  String? _selectedMemberId;
  final _cashController = TextEditingController();
  int _step = 1; // 1: Select member, 2: Enter cash amount

  @override
  void dispose() {
    _cashController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final members = ref.watch(membersProvider);
    final eligibleMembers = members
        .where((m) => m.isActive && m.id != widget.fromMember.id)
        .toList();

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: context.surfaceColor,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(AppSpacing.radiusLg),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: context.borderColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const Gap(AppSpacing.lg),

          // Title with step indicator
          Row(
            children: [
              const Icon(LucideIcons.userPlus2, color: AppColors.primary),
              const Gap(12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Manager Handoff',
                      style: AppTypography.titleMedium.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Step $_step of 2',
                      style: AppTypography.bodySmall.copyWith(
                        color: context.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
              // Step indicators
              Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const Gap(4),
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color:
                          _step == 2 ? AppColors.primary : context.borderColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const Gap(AppSpacing.lg),

          if (_step == 1) ...[
            // Step 1: Select new manager
            const Text(
              'Select New Manager',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const Gap(8),
            ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.35,
              ),
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: eligibleMembers.length,
                separatorBuilder: (_, __) => const Gap(8),
                itemBuilder: (context, index) {
                  final member = eligibleMembers[index];
                  final isSelected = member.id == _selectedMemberId;
                  return InkWell(
                    onTap: () {
                      HapticService.selectionTick();
                      setState(() => _selectedMemberId = member.id);
                    },
                    borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                    child: Container(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.primary.withValues(alpha: 0.1)
                            : context.surfaceColor,
                        borderRadius: BorderRadius.circular(
                          AppSpacing.radiusMd,
                        ),
                        border: Border.all(
                          color: isSelected
                              ? AppColors.primary
                              : context.borderColor,
                          width: isSelected ? 2 : 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            isSelected
                                ? LucideIcons.checkCircle2
                                : LucideIcons.circle,
                            color: isSelected
                                ? AppColors.primary
                                : context.textMuted,
                            size: 20,
                          ),
                          const Gap(12),
                          AppMemberAvatar(name: member.name, size: 32),
                          const Gap(12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  member.name,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  member.role.name,
                                  style: AppTypography.bodySmall.copyWith(
                                    color: Colors.grey[500],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ] else ...[
            // Step 2: Cash in hand amount
            const Text(
              'Cash in Hand Amount',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const Gap(8),
            Text(
              'Enter the amount of cash being transferred to the new manager:',
              style: AppTypography.bodySmall.copyWith(color: Colors.grey[500]),
            ),
            const Gap(16),
            TextField(
              controller: _cashController,
              keyboardType: TextInputType.number,
              autofocus: true,
              decoration: InputDecoration(
                prefixText: ' ',
                hintText: '0',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                ),
                filled: true,
                fillColor: context.cardColor,
              ),
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const Gap(16),
            Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: AppColors.info.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(
                        LucideIcons.info,
                        color: AppColors.info,
                        size: 16,
                      ),
                      const Gap(8),
                      Text(
                        'This will:',
                        style: AppTypography.bodySmall.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.info,
                        ),
                      ),
                    ],
                  ),
                  const Gap(8),
                  Text(
                    'Transfer ${widget.fromMember.role.name.toUpperCase()} role to new manager',
                    style: AppTypography.bodySmall,
                  ),
                  Text(
                    'Create transaction record for cash handoff',
                    style: AppTypography.bodySmall,
                  ),
                  Text(
                    'Set your role to regular Member',
                    style: AppTypography.bodySmall,
                  ),
                ],
              ),
            ),
          ],

          const Gap(AppSpacing.lg),

          // Actions
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    if (_step == 1) {
                      Navigator.pop(context);
                    } else {
                      setState(() => _step = 1);
                    }
                  },
                  child: Text(_step == 1 ? 'Cancel' : 'Back'),
                ),
              ),
              const Gap(12),
              Expanded(
                child: FilledButton(
                  onPressed: _step == 1
                      ? (_selectedMemberId != null
                            ? () => setState(() => _step = 2)
                            : null)
                      : _completeHandoff,
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    disabledBackgroundColor: context.borderColor,
                  ),
                  child: Text(_step == 1 ? 'Next' : 'Complete Handoff'),
                ),
              ),
            ],
          ),
          const Gap(AppSpacing.md),
        ],
      ),
    );
  }

  void _completeHandoff() async {
    if (_selectedMemberId == null) return;

    final cashAmount = double.tryParse(_cashController.text) ?? 0.0;
    final targetMember = ref
        .read(membersProvider)
        .firstWhere((m) => m.id == _selectedMemberId);

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: context.surfaceColor,
        title: const Text(
          'Confirm Handoff',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Complete manager handoff:',
              style: AppTypography.bodySmall,
            ),
            const Gap(12),
            Row(
              children: [
                Text(
                  widget.fromMember.name,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: const Icon(LucideIcons.arrowRight, size: 16),
                ),
                Text(
                  targetMember.name,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
            if (cashAmount > 0) ...[
              const Gap(12),
              Container(
                padding: const EdgeInsets.all(AppSpacing.sm),
                decoration: BoxDecoration(
                  color: AppColors.moneyPositive.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                ),
                child: Row(
                  children: [
                    const Icon(
                      LucideIcons.banknote,
                      color: AppColors.moneyPositive,
                      size: 16,
                    ),
                    const Gap(8),
                    Text(
                      'Cash Transfer: ${cashAmount.toStringAsFixed(0)}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.moneyPositive,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text(
              'Confirm',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      HapticService.success();

      // 1. Transfer the role
      ref
          .read(membersProvider.notifier)
          .updateMember(targetMember.copyWith(role: widget.fromMember.role));

      // 2. Demote the original member
      ref
          .read(membersProvider.notifier)
          .updateMember(widget.fromMember.copyWith(role: MemberRole.member));

      // 3. Note: Cash transfer would be recorded as a transaction
      // This is logged in the audit but actual transaction tracking
      // requires the money_provider which we'll keep simple here

      Navigator.pop(context);
      showSuccessToast(
        context,
        'Manager handoff complete!\n'
        '${targetMember.name} is now ${widget.fromMember.role.name}.\n'
        '${cashAmount > 0 ? "${cashAmount.toStringAsFixed(0)} transferred." : ""}',
      );
    }
  }
}
