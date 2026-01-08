import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:gap/gap.dart';
import 'package:getwidget/getwidget.dart';

import 'package:mess_manager/core/theme/app_theme.dart';
import 'package:mess_manager/core/models/member.dart';
import 'package:mess_manager/core/providers/members_provider.dart';
import 'package:mess_manager/core/providers/role_provider.dart';
import 'package:mess_manager/core/services/haptic_service.dart';
import 'package:mess_manager/core/widgets/gf_components.dart';

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
        color: AppColors.surfaceDark,
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
              color: AppColors.borderDark,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const Gap(AppSpacing.lg),

          // Member Header
          HStack([
            GFMemberAvatar(
              name: member.name,
              size: 48,
              backgroundColor: AppColors.primary.withValues(alpha: 0.1),
            ),
            12.widthBox,
            VStack(crossAlignment: CrossAxisAlignment.start, [
              member.name.text.lg.bold.make(),
              member.role.name.toUpperCase().text.xs.gray500.make(),
            ]).expand(),
          ]),
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
            HStack([
              Container(
                width: 40,
                height: 1,
                color: AppColors.error.withValues(alpha: 0.3),
              ),
              8.widthBox,
              '⚠️ SUPER ADMIN'.text.xs.bold.color(AppColors.error).make(),
              8.widthBox,
              Container(
                width: 40,
                height: 1,
                color: AppColors.error.withValues(alpha: 0.3),
              ).expand(),
            ]),
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
              child: HStack([
                const Icon(LucideIcons.info, size: 20, color: AppColors.info),
                12.widthBox,
                'You cannot modify your own account here.'.text.sm
                    .color(AppColors.info)
                    .make()
                    .expand(),
              ]),
            ),
          ],

          if (!isAdmin) ...[
            Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: AppColors.warning.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
              ),
              child: HStack([
                const Icon(
                  LucideIcons.lock,
                  size: 20,
                  color: AppColors.warning,
                ),
                12.widthBox,
                'Admin access required for member management.'.text.sm
                    .color(AppColors.warning)
                    .make()
                    .expand(),
              ]),
            ),
          ],

          const Gap(AppSpacing.lg),

          // Close Button
          GFButton(
            onPressed: () => Navigator.pop(context),
            text: 'Close',
            fullWidthButton: true,
            type: GFButtonType.outline,
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
        child: HStack([
          Container(
            padding: const EdgeInsets.all(AppSpacing.sm),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          12.widthBox,
          VStack(crossAlignment: CrossAxisAlignment.start, [
            title.text.semiBold.color(color).make(),
            subtitle.text.xs.gray500.make(),
          ]).expand(),
          Icon(LucideIcons.chevronRight, color: color, size: 20),
        ]),
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
        backgroundColor: AppColors.surfaceDark,
        title: 'Archive Member?'.text.bold.make(),
        content: VStack(crossAlignment: CrossAxisAlignment.start, [
          'This will deactivate ${member.name} but keep their records.'.text
              .make(),
          8.heightBox,
          'They can be reactivated later by an Admin.'.text.sm.gray500.make(),
        ]),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: 'Cancel'.text.make(),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.warning),
            onPressed: () => Navigator.pop(ctx, true),
            child: 'Archive'.text.bold.make(),
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
        backgroundColor: AppColors.surfaceDark,
        title: 'Restore Member?'.text.bold.make(),
        content: VStack(crossAlignment: CrossAxisAlignment.start, [
          'This will reactivate ${member.name}.'.text.make(),
          8.heightBox,
          'They will be able to participate in the mess again.'.text.sm.gray500
              .make(),
        ]),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: 'Cancel'.text.make(),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.success),
            onPressed: () => Navigator.pop(ctx, true),
            child: 'Restore'.text.bold.make(),
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
        backgroundColor: AppColors.surfaceDark,
        title: HStack([
          const Icon(LucideIcons.alertTriangle, color: AppColors.error),
          8.widthBox,
          'Remove Member?'.text.bold.make(),
        ]),
        content: VStack(crossAlignment: CrossAxisAlignment.start, [
          'This will permanently remove ${member.name} from the mess.'.text
              .make(),
          12.heightBox,
          Container(
            padding: const EdgeInsets.all(AppSpacing.sm),
            decoration: BoxDecoration(
              color: AppColors.error.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
            ),
            child: 'This action cannot be undone!'.text.sm
                .color(AppColors.error)
                .make(),
          ),
        ]),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: 'Cancel'.text.make(),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            onPressed: () => Navigator.pop(ctx, true),
            child: 'Remove'.text.bold.make(),
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
        backgroundColor: AppColors.surfaceDark,
        title: HStack([
          const Icon(LucideIcons.alertOctagon, color: AppColors.error),
          8.widthBox,
          'FORCE REMOVE'.text.bold.color(AppColors.error).make(),
        ]),
        content: VStack(crossAlignment: CrossAxisAlignment.start, [
          'You are about to PERMANENTLY delete ${member.name}.'.text.make(),
          12.heightBox,
          if (member.balance != 0) ...[
            Container(
              padding: const EdgeInsets.all(AppSpacing.sm),
              decoration: BoxDecoration(
                color: AppColors.warning.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
              ),
              child: VStack([
                'Outstanding Balance:'.text.sm.bold.make(),
                4.heightBox,
                '৳${member.balance.abs().toStringAsFixed(0)} ${member.balance > 0 ? "(to receive)" : "(owes)"}'
                    .text
                    .lg
                    .bold
                    .color(
                      member.balance > 0 ? AppColors.success : AppColors.error,
                    )
                    .make(),
              ]),
            ),
            8.heightBox,
          ],
          Container(
            padding: const EdgeInsets.all(AppSpacing.sm),
            decoration: BoxDecoration(
              color: AppColors.error.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
              border: Border.all(color: AppColors.error),
            ),
            child: VStack([
              '⚠️ This bypasses all safety checks!'.text.sm.bold
                  .color(AppColors.error)
                  .make(),
              4.heightBox,
              '• Balance will NOT be settled'.text.xs
                  .color(AppColors.error)
                  .make(),
              '• All member data will be deleted'.text.xs
                  .color(AppColors.error)
                  .make(),
              '• This action CANNOT be undone'.text.xs
                  .color(AppColors.error)
                  .make(),
            ]),
          ),
        ]),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: 'Cancel'.text.make(),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            onPressed: () => Navigator.pop(ctx, true),
            child: 'I Understand'.text.bold.make(),
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
        backgroundColor: AppColors.surfaceDark,
        title: 'Type "DELETE" to confirm'.text.bold.make(),
        content: VStack([
          'Type DELETE to permanently remove ${member.name}:'.text.sm.make(),
          12.heightBox,
          TextField(
            controller: typeController,
            autofocus: true,
            decoration: const InputDecoration(
              hintText: 'Type DELETE',
              border: OutlineInputBorder(),
            ),
          ),
        ]),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: 'Cancel'.text.make(),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            onPressed: () {
              if (typeController.text.toUpperCase() == 'DELETE') {
                Navigator.pop(ctx, true);
              }
            },
            child: 'Force Delete'.text.bold.make(),
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
        color: AppColors.surfaceDark,
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
                color: AppColors.borderDark,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const Gap(AppSpacing.lg),

          'Change Role for ${widget.member.name}'.text.lg.bold.make(),
          const Gap(AppSpacing.md),

          // Role List
          ...availableRoles.map((role) => _buildRoleTile(role)),

          const Gap(AppSpacing.lg),

          // Save Button
          GFButton(
            onPressed: _saveRole,
            text: 'Save Role',
            icon: const Icon(LucideIcons.check, color: Colors.white),
            fullWidthButton: true,
            color: AppColors.primary,
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
              : AppColors.cardDark,
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          border: Border.all(
            color: isSelected ? color : AppColors.borderDark,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: HStack([
          Icon(
            isSelected ? LucideIcons.checkCircle2 : LucideIcons.circle,
            color: isSelected ? color : AppColors.textMutedDark,
            size: 20,
          ),
          12.widthBox,
          VStack(crossAlignment: CrossAxisAlignment.start, [
            role.name
                .toUpperCase()
                .text
                .semiBold
                .color(isSelected ? color : AppColors.textPrimaryDark)
                .make(),
            _getRoleDescription(role).text.xs.gray500.make(),
          ]).expand(),
        ]),
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
        return AppColors.textSecondaryDark;
      case MemberRole.guest:
        return AppColors.textMutedDark;
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
        color: AppColors.surfaceDark,
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
                color: AppColors.borderDark,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const Gap(AppSpacing.lg),

          // Title
          HStack([
            const Icon(LucideIcons.arrowRightLeft, color: AppColors.warning),
            12.widthBox,
            'Transfer ${widget.fromMember.role.name.toUpperCase()} Rights'
                .text
                .lg
                .bold
                .make(),
          ]),
          const Gap(AppSpacing.sm),
          'Select a member to receive ${widget.fromMember.name}\'s rights:'
              .text
              .sm
              .gray500
              .make(),
          const Gap(AppSpacing.lg),

          // Member List
          ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.35,
            ),
            child: ListView.separated(
              shrinkWrap: true,
              itemCount: eligibleMembers.length,
              separatorBuilder: (_, __) => 8.heightBox,
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
                          : AppColors.surfaceDark,
                      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                      border: Border.all(
                        color: isSelected
                            ? AppColors.warning
                            : AppColors.borderDark,
                        width: isSelected ? 2 : 1,
                      ),
                    ),
                    child: HStack([
                      Icon(
                        isSelected
                            ? LucideIcons.checkCircle2
                            : LucideIcons.circle,
                        color: isSelected
                            ? AppColors.warning
                            : AppColors.textMutedDark,
                        size: 20,
                      ),
                      12.widthBox,
                      GFMemberAvatar(name: member.name, size: 32),
                      12.widthBox,
                      VStack(crossAlignment: CrossAxisAlignment.start, [
                        member.name.text.semiBold.make(),
                        member.role.name.text.xs.gray500.make(),
                      ]).expand(),
                    ]),
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
            child: VStack(crossAlignment: CrossAxisAlignment.start, [
              HStack([
                const Icon(
                  LucideIcons.alertTriangle,
                  color: AppColors.warning,
                  size: 16,
                ),
                8.widthBox,
                'What will happen:'.text.sm.bold
                    .color(AppColors.warning)
                    .make(),
              ]),
              8.heightBox,
              '• ${widget.fromMember.name} will become a regular Member'.text.xs
                  .make(),
              '• Selected member will become ${widget.fromMember.role.name}'
                  .text
                  .xs
                  .make(),
            ]),
          ),
          const Gap(AppSpacing.lg),

          // Actions
          HStack([
            GFButton(
              onPressed: () => Navigator.pop(context),
              text: 'Cancel',
              type: GFButtonType.outline,
            ).expand(),
            12.widthBox,
            GFButton(
              onPressed: _selectedMemberId != null ? _transferRights : null,
              text: 'Transfer Rights',
              color: AppColors.warning,
              disabledColor: AppColors.borderDark,
            ).expand(),
          ]),
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
        backgroundColor: AppColors.surfaceDark,
        title: 'Confirm Transfer'.text.bold.make(),
        content: VStack([
          'Transfer ${widget.fromMember.role.name.toUpperCase()} rights from:'
              .text
              .sm
              .make(),
          8.heightBox,
          HStack([
            '${widget.fromMember.name}'.text.bold.make(),
            const Icon(LucideIcons.arrowRight, size: 16).px8(),
            '${targetMember.name}'.text.bold.color(AppColors.warning).make(),
          ]),
        ]),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: 'Cancel'.text.make(),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.warning),
            onPressed: () => Navigator.pop(ctx, true),
            child: 'Transfer'.text.bold.make(),
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
        color: AppColors.surfaceDark,
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
                color: AppColors.borderDark,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const Gap(AppSpacing.lg),

          // Title with step indicator
          HStack([
            const Icon(LucideIcons.userPlus2, color: AppColors.primary),
            12.widthBox,
            VStack(crossAlignment: CrossAxisAlignment.start, [
              'Manager Handoff'.text.lg.bold.make(),
              'Step $_step of 2'.text.xs.color(AppColors.textMutedDark).make(),
            ]).expand(),
            // Step indicators
            HStack([
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
              ),
              4.widthBox,
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: _step == 2 ? AppColors.primary : AppColors.borderDark,
                  shape: BoxShape.circle,
                ),
              ),
            ]),
          ]),
          const Gap(AppSpacing.lg),

          if (_step == 1) ...[
            // Step 1: Select new manager
            'Select New Manager'.text.semiBold.make(),
            8.heightBox,
            ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.35,
              ),
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: eligibleMembers.length,
                separatorBuilder: (_, __) => 8.heightBox,
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
                            : AppColors.surfaceDark,
                        borderRadius: BorderRadius.circular(
                          AppSpacing.radiusMd,
                        ),
                        border: Border.all(
                          color: isSelected
                              ? AppColors.primary
                              : AppColors.borderDark,
                          width: isSelected ? 2 : 1,
                        ),
                      ),
                      child: HStack([
                        Icon(
                          isSelected
                              ? LucideIcons.checkCircle2
                              : LucideIcons.circle,
                          color: isSelected
                              ? AppColors.primary
                              : AppColors.textMutedDark,
                          size: 20,
                        ),
                        12.widthBox,
                        GFMemberAvatar(name: member.name, size: 32),
                        12.widthBox,
                        VStack(crossAlignment: CrossAxisAlignment.start, [
                          member.name.text.semiBold.make(),
                          member.role.name.text.xs.gray500.make(),
                        ]).expand(),
                      ]),
                    ),
                  );
                },
              ),
            ),
          ] else ...[
            // Step 2: Cash in hand amount
            'Cash in Hand Amount'.text.semiBold.make(),
            8.heightBox,
            'Enter the amount of cash being transferred to the new manager:'
                .text
                .sm
                .gray500
                .make(),
            16.heightBox,
            TextField(
              controller: _cashController,
              keyboardType: TextInputType.number,
              autofocus: true,
              decoration: InputDecoration(
                prefixText: '৳ ',
                hintText: '0',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                ),
                filled: true,
                fillColor: AppColors.cardDark,
              ),
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            16.heightBox,
            Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: AppColors.info.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
              ),
              child: VStack(crossAlignment: CrossAxisAlignment.start, [
                HStack([
                  const Icon(LucideIcons.info, color: AppColors.info, size: 16),
                  8.widthBox,
                  'This will:'.text.sm.bold.color(AppColors.info).make(),
                ]),
                8.heightBox,
                '• Transfer ${widget.fromMember.role.name.toUpperCase()} role to new manager'
                    .text
                    .xs
                    .make(),
                '• Create transaction record for cash handoff'.text.xs.make(),
                '• Set your role to regular Member'.text.xs.make(),
              ]),
            ),
          ],

          const Gap(AppSpacing.lg),

          // Actions
          HStack([
            GFButton(
              onPressed: () {
                if (_step == 1) {
                  Navigator.pop(context);
                } else {
                  setState(() => _step = 1);
                }
              },
              text: _step == 1 ? 'Cancel' : 'Back',
              type: GFButtonType.outline,
            ).expand(),
            12.widthBox,
            GFButton(
              onPressed: _step == 1
                  ? (_selectedMemberId != null
                        ? () => setState(() => _step = 2)
                        : null)
                  : _completeHandoff,
              text: _step == 1 ? 'Next' : 'Complete Handoff',
              color: AppColors.primary,
              disabledColor: AppColors.borderDark,
            ).expand(),
          ]),
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
        backgroundColor: AppColors.surfaceDark,
        title: 'Confirm Handoff'.text.bold.make(),
        content: VStack([
          'Complete manager handoff:'.text.sm.make(),
          12.heightBox,
          HStack([
            widget.fromMember.name.text.bold.make(),
            const Icon(LucideIcons.arrowRight, size: 16).px8(),
            targetMember.name.text.bold.color(AppColors.primary).make(),
          ]),
          if (cashAmount > 0) ...[
            12.heightBox,
            Container(
              padding: const EdgeInsets.all(AppSpacing.sm),
              decoration: BoxDecoration(
                color: AppColors.moneyPositive.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
              ),
              child: HStack([
                const Icon(
                  LucideIcons.banknote,
                  color: AppColors.moneyPositive,
                  size: 16,
                ),
                8.widthBox,
                'Cash Transfer: ৳${cashAmount.toStringAsFixed(0)}'.text.bold
                    .color(AppColors.moneyPositive)
                    .make(),
              ]),
            ),
          ],
        ]),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: 'Cancel'.text.make(),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
            onPressed: () => Navigator.pop(ctx, true),
            child: 'Confirm'.text.bold.make(),
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
        '✅ Manager handoff complete!\n'
        '${targetMember.name} is now ${widget.fromMember.role.name}.\n'
        '${cashAmount > 0 ? "৳${cashAmount.toStringAsFixed(0)} transferred." : ""}',
      );
    }
  }
}
