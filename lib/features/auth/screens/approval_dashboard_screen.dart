import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:gap/gap.dart';
import 'package:getwidget/getwidget.dart';
import 'package:timeago/timeago.dart' as timeago;

import 'package:mess_manager/core/theme/app_theme.dart';
import 'package:mess_manager/core/models/member.dart';
import 'package:mess_manager/core/services/haptic_service.dart';
import 'package:mess_manager/core/widgets/gf_components.dart';
import 'package:mess_manager/features/auth/providers/approval_provider.dart';

/// Admin Approval Dashboard
class ApprovalDashboardScreen extends ConsumerWidget {
  const ApprovalDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final approvalState = ref.watch(approvalProvider);

    return Scaffold(
      appBar: AppBar(
        title: HStack([
          const Icon(LucideIcons.userCheck, color: AppColors.primary, size: 22),
          const Gap(AppSpacing.sm),
          'Pending Approvals'.text.make(),
        ]),
        actions: [
          GFIconButton(
            icon: approvalState.isLoading
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(LucideIcons.refreshCw, color: AppColors.primary),
            type: GFButtonType.transparent,
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
      child: VStack([
        Icon(
          LucideIcons.checkCircle,
          size: 80,
          color: AppColors.success.withValues(alpha: 0.5),
        ),
        const Gap(AppSpacing.lg),
        'All Caught Up!'.text.xl.bold.color(AppColors.success).make(),
        const Gap(AppSpacing.sm),
        'No pending approval requests.'.text.gray500.make(),
      ]),
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
      decoration: BoxDecoration(
        color: AppColors.cardDark,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        border: Border.all(color: AppColors.borderDark),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: AppColors.surfaceDark,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(AppSpacing.radiusMd - 1),
              ),
            ),
            child: HStack([
              GFMemberAvatar(name: request.name, size: 48),
              12.widthBox,
              VStack(crossAlignment: CrossAxisAlignment.start, [
                request.name.text.lg.bold.make(),
                request.email.text.sm.gray500.make(),
              ]).expand(),
              VStack(crossAlignment: CrossAxisAlignment.end, [
                timeago.format(request.requestedAt).text.xs.gray500.make(),
                4.heightBox,
                GFBadge(
                  text: request.requestedRole.name.toUpperCase(),
                  color: _getRoleColor(
                    request.requestedRole,
                  ).withValues(alpha: 0.15),
                  textColor: _getRoleColor(request.requestedRole),
                  size: GFSize.SMALL,
                ),
              ]),
            ]),
          ),

          // Details
          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: VStack(crossAlignment: CrossAxisAlignment.start, [
              if (request.phone != null) ...[
                HStack([
                  const Icon(
                    LucideIcons.phone,
                    size: 14,
                    color: AppColors.textMutedDark,
                  ),
                  8.widthBox,
                  request.phone!.text.sm.make(),
                ]),
                8.heightBox,
              ],
              if (request.inviteCode != null) ...[
                HStack([
                  const Icon(
                    LucideIcons.ticket,
                    size: 14,
                    color: AppColors.textMutedDark,
                  ),
                  8.widthBox,
                  'Invite Code: ${request.inviteCode}'.text.sm.make(),
                ]),
                8.heightBox,
              ],
              if (request.notes != null) ...[
                HStack([
                  const Icon(
                    LucideIcons.stickyNote,
                    size: 14,
                    color: AppColors.textMutedDark,
                  ),
                  8.widthBox,
                  request.notes!.text.sm.italic.make().expand(),
                ]),
                8.heightBox,
              ],
            ]),
          ),

          // Actions
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: AppColors.borderDark.withValues(alpha: 0.5),
                ),
              ),
            ),
            child: HStack([
              // Reject
              GFButton(
                onPressed: () => _showRejectDialog(context, ref, request),
                text: 'Reject',
                icon: const Icon(
                  LucideIcons.x,
                  size: 16,
                  color: AppColors.error,
                ),
                type: GFButtonType.outline,
                color: AppColors.error,
                size: GFSize.SMALL,
              ),
              const Spacer(),
              // Role selector
              GFButton(
                onPressed: () => _showRoleSelector(context, ref, request),
                text: 'Role',
                icon: const Icon(LucideIcons.shield, size: 16),
                type: GFButtonType.outline,
                color: AppColors.info,
                size: GFSize.SMALL,
              ),
              12.widthBox,
              // Approve
              GFButton(
                onPressed: () {
                  HapticService.success();
                  ref.read(approvalProvider.notifier).approve(request.id);
                  showSuccessToast(context, '${request.name} approved!');
                },
                text: 'Approve',
                icon: const Icon(
                  LucideIcons.check,
                  size: 16,
                  color: Colors.white,
                ),
                color: AppColors.success,
                size: GFSize.SMALL,
              ),
            ]),
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
        backgroundColor: AppColors.surfaceDark,
        title: 'Reject ${request.name}?'.text.bold.make(),
        content: VStack(crossAlignment: CrossAxisAlignment.start, [
          'This will deny their signup request.'.text.sm.make(),
          16.heightBox,
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
        ]),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: 'Cancel'.text.make(),
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
            child: 'Reject'.text.bold.make(),
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
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
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
            'Select Role for ${request.name}'.text.lg.bold.make(),
            const Gap(AppSpacing.md),
            ...MemberRole.values
                .where((r) => r != MemberRole.superAdmin)
                .map(
                  (role) => InkWell(
                    onTap: () {
                      HapticService.success();
                      ref
                          .read(approvalProvider.notifier)
                          .approve(request.id, role: role);
                      Navigator.pop(ctx);
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
                      child: HStack([
                        Icon(
                          LucideIcons.shield,
                          color: _getRoleColor(role),
                          size: 20,
                        ),
                        12.widthBox,
                        role.name
                            .toUpperCase()
                            .text
                            .color(_getRoleColor(role))
                            .bold
                            .make(),
                      ]),
                    ),
                  ),
                ),
            const Gap(AppSpacing.md),
          ],
        ),
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
