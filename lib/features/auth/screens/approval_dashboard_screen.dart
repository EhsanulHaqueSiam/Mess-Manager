import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:gap/gap.dart';
import 'package:timeago/timeago.dart' as timeago;

import 'package:mess_manager/core/theme/app_theme.dart';
import 'package:mess_manager/core/models/member.dart';
import 'package:mess_manager/core/services/haptic_service.dart';
import 'package:mess_manager/core/widgets/app_components.dart';
import 'package:mess_manager/features/auth/providers/approval_provider.dart';

/// Admin Approval Dashboard
class ApprovalDashboardScreen extends ConsumerWidget {
  const ApprovalDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final approvalState = ref.watch(approvalProvider);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Icon(LucideIcons.userCheck, color: AppColors.primary, size: 22),
            const Gap(AppSpacing.sm),
            const Text('Pending Approvals'),
          ],
        ),
        actions: [
          IconButton(
            icon: approvalState.isLoading
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(LucideIcons.refreshCw, color: AppColors.primary),
            onPressed: () {
              HapticService.buttonPress();
              ref.read(approvalProvider.notifier).refresh();
            },
          ),
        ],
      ),
      body: approvalState.pending.isEmpty
          ? _buildEmptyState(context)
          : ListView.builder(
              padding: const EdgeInsets.all(AppSpacing.md),
              itemCount: approvalState.pending.length,
              itemBuilder: (context, index) {
                final request = approvalState.pending[index];
                return _buildApprovalCard(context, ref, request, index);
              },
            ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            LucideIcons.checkCircle,
            size: 80,
            color: AppColors.success.withValues(alpha: 0.5),
          ),
          const Gap(AppSpacing.lg),
          Text(
            'All Caught Up!',
            style: AppTypography.titleLarge.copyWith(
              color: AppColors.success,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Gap(AppSpacing.sm),
          Text(
            'No pending approval requests.',
            style: TextStyle(color: context.textSecondary),
          ),
        ],
      ),
    ).animate().fadeIn().scale(begin: const Offset(0.9, 0.9));
  }

  Widget _buildApprovalCard(
    BuildContext context,
    WidgetRef ref,
    PendingApproval request,
    int index,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      decoration: AppSpacing.accentCard(accent: AppColors.warning, radius: AppSpacing.radiusMd),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: context.surfaceColor,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(AppSpacing.radiusMd - 1),
              ),
            ),
            child: Row(
              children: [
                AppMemberAvatar(name: request.name, size: 48),
                const Gap(12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        request.name,
                        style: AppTypography.titleMedium.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        request.email,
                        style: AppTypography.bodySmall.copyWith(
                          color: context.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      timeago.format(request.requestedAt),
                      style: AppTypography.bodySmall.copyWith(
                        color: context.textSecondary,
                      ),
                    ),
                    const Gap(4),
                    AppBadge(
                      text: request.requestedRole.name.toUpperCase(),
                      color: _getRoleColor(
                        request.requestedRole,
                      ).withValues(alpha: 0.15),
                      textColor: _getRoleColor(request.requestedRole),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Details
          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (request.phone != null) ...[
                  Row(
                    children: [
                      Icon(
                        LucideIcons.phone,
                        size: 14,
                        color: context.textMuted,
                      ),
                      const Gap(8),
                      Text(
                        request.phone!,
                        style: AppTypography.bodySmall,
                      ),
                    ],
                  ),
                  const Gap(8),
                ],
                if (request.inviteCode != null) ...[
                  Row(
                    children: [
                      Icon(
                        LucideIcons.ticket,
                        size: 14,
                        color: context.textMuted,
                      ),
                      const Gap(8),
                      Text(
                        'Invite Code: ${request.inviteCode}',
                        style: AppTypography.bodySmall,
                      ),
                    ],
                  ),
                  const Gap(8),
                ],
                if (request.notes != null) ...[
                  Row(
                    children: [
                      Icon(
                        LucideIcons.stickyNote,
                        size: 14,
                        color: context.textMuted,
                      ),
                      const Gap(8),
                      Expanded(
                        child: Text(
                          request.notes!,
                          style: AppTypography.bodySmall.copyWith(
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Gap(8),
                ],
              ],
            ),
          ),

          // Actions
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: context.borderColor.withValues(alpha: 0.5),
                ),
              ),
            ),
            child: Row(
              children: [
                // Reject
                OutlinedButton.icon(
                  onPressed: () => _showRejectDialog(context, ref, request),
                  icon: const Icon(LucideIcons.x, size: 16),
                  label: const Text('Reject'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.error,
                    side: const BorderSide(color: AppColors.error),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                  ),
                ),
                const Spacer(),
                // Role selector
                OutlinedButton.icon(
                  onPressed: () => _showRoleSelector(context, ref, request),
                  icon: const Icon(LucideIcons.shield, size: 16),
                  label: const Text('Role'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.info,
                    side: const BorderSide(color: AppColors.info),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                  ),
                ),
                const Gap(12),
                // Approve
                FilledButton.icon(
                  onPressed: () {
                    HapticService.bouncyConfirm();
                    ref.read(approvalProvider.notifier).approve(request.id);
                    showSuccessToast(context, '${request.name} approved!');
                  },
                  icon: const Icon(LucideIcons.check, size: 16),
                  label: const Text('Approve'),
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.success,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate(delay: (80 * index).ms).fadeIn().slideX(begin: 0.05);
  }

  void _showRejectDialog(
    BuildContext context,
    WidgetRef ref,
    PendingApproval request,
  ) {
    final reasonController = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: context.surfaceColor,
        title: Text(
          'Reject ${request.name}?',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'This will deny their signup request.',
              style: AppTypography.bodySmall,
            ),
            const Gap(16),
            TextField(
              controller: reasonController,
              decoration: InputDecoration(
                labelText: 'Reason (optional)',
                hintText: 'Enter rejection reason...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                ),
              ),
              maxLines: 2,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            onPressed: () {
              HapticService.warning();
              ref
                  .read(approvalProvider.notifier)
                  .reject(
                    request.id,
                    reason: reasonController.text.isEmpty
                        ? null
                        : reasonController.text,
                  );
              Navigator.pop(ctx);
              showErrorToast(context, '${request.name} rejected');
            },
            child: const Text(
              'Reject',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  void _showRoleSelector(
    BuildContext context,
    WidgetRef ref,
    PendingApproval request,
  ) {
    AppSheet.show(
      context: context,
      title: 'Select Role for ${request.name}',
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ...MemberRole.values
              .where((r) => r != MemberRole.superAdmin)
              .map(
                (role) => InkWell(
                  onTap: () {
                    HapticService.bouncyConfirm();
                    ref
                        .read(approvalProvider.notifier)
                        .approve(request.id, role: role);
                    Navigator.pop(context);
                    showSuccessToast(
                      context,
                      '${request.name} approved as ${role.name}',
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    margin: const EdgeInsets.only(bottom: AppSpacing.sm),
                    decoration: BoxDecoration(
                      color: _getRoleColor(role).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(
                        AppSpacing.radiusSm,
                      ),
                      border: Border.all(
                        color: _getRoleColor(role).withValues(alpha: 0.3),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          LucideIcons.shield,
                          color: _getRoleColor(role),
                          size: 20,
                        ),
                        const Gap(12),
                        Text(
                          role.name.toUpperCase(),
                          style: TextStyle(
                            color: _getRoleColor(role),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          const Gap(AppSpacing.md),
        ],
      ),
    );
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
}
