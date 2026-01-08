import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:gap/gap.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:getwidget/getwidget.dart';

import 'package:mess_manager/core/theme/app_theme.dart';
import 'package:mess_manager/core/providers/members_provider.dart';
import 'package:mess_manager/core/models/member.dart';
import 'package:mess_manager/core/widgets/gf_components.dart';
import 'package:mess_manager/core/widgets/animated_widgets.dart';
import 'package:mess_manager/core/services/haptic_service.dart';
import 'package:mess_manager/features/members/widgets/add_edit_member_sheet.dart';
import 'package:mess_manager/features/members/widgets/member_actions_sheet.dart';
import 'package:mess_manager/features/balance/providers/balance_provider.dart';

/// Members Screen - Uses GetWidget + VelocityX + flutter_animate
class MembersScreen extends ConsumerWidget {
  const MembersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final members = ref.watch(membersProvider);
    final balances = ref.watch(memberBalancesProvider);
    final currentMemberId = ref.watch(currentMemberIdProvider);

    return Scaffold(
      appBar: AppBar(
        title: [
          const Icon(LucideIcons.users, color: AppColors.primary, size: 22),
          const Gap(AppSpacing.sm),
          'Members'.text.make(),
        ].hStack(),
        actions: [
          GFIconButton(
            icon: const Icon(LucideIcons.userPlus, color: AppColors.primary),
            type: GFButtonType.transparent,
            onPressed: () {
              HapticService.buttonPress();
              _showAddEditSheet(context);
            },
          ),
        ],
      ),
      body: members.isEmpty
          ? EmptyStateWidget.noData(
              title: 'No Members Yet',
              subtitle: 'Add your first mess member to get started',
              action: ShimmerCTAButton(
                text: 'Add First Member',
                icon: LucideIcons.plus,
                onPressed: () => _showAddEditSheet(context),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(AppSpacing.md),
              itemCount: members.length,
              itemBuilder: (context, index) {
                final member = members[index];
                final balance = balances.firstWhere(
                  (b) => b.memberId == member.id,
                  orElse: () => MemberBalance(
                    memberId: member.id,
                    name: member.name,
                    totalMeals: 0,
                    totalBazar: 0,
                    balance: 0,
                    mealCost: 0,
                  ),
                );
                return _buildMemberCard(
                  context,
                  member,
                  balance,
                  index,
                  currentMemberId,
                );
              },
            ),
    );
  }

  void _showAddEditSheet(BuildContext context, {Member? member}) {
    HapticService.modalOpen();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AddEditMemberSheet(member: member),
    );
  }

  void _showMemberActions(BuildContext context, Member member) {
    HapticService.modalOpen();
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => MemberActionsSheet(member: member),
    );
  }

  Widget _buildMemberCard(
    BuildContext context,
    Member member,
    MemberBalance balance,
    int index,
    String currentMemberId,
  ) {
    final isCurrentUser = member.id == currentMemberId;
    final roleColor = _getRoleColor(member.role);
    final balanceColor = balance.balance >= 0
        ? AppColors.moneyPositive
        : AppColors.moneyNegative;

    return GFCard(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      padding: EdgeInsets.zero,
      color: AppColors.cardDark,
      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      border: Border.all(
        color: isCurrentUser
            ? AppColors.primary.withValues(alpha: 0.5)
            : AppColors.borderDark.withValues(alpha: 0.5),
        width: isCurrentUser ? 2 : 1,
      ),
      content: InkWell(
        onTap: () => _showAddEditSheet(context, member: member),
        onLongPress: () => _showMemberActions(context, member),
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        child: VStack([
          // Header Row
          HStack([
            // Avatar
            GFMemberAvatar(
              name: member.name,
              size: 48,
              backgroundColor: AppColors.primary.withValues(alpha: 0.1),
            ),
            12.widthBox,
            // Info
            VStack(crossAlignment: CrossAxisAlignment.start, [
              HStack([
                member.name.text.color(AppColors.textPrimaryDark).bold.make(),
                if (isCurrentUser) ...[
                  4.widthBox,
                  GFBadge(
                    text: 'You',
                    color: AppColors.primary.withValues(alpha: 0.1),
                    textColor: AppColors.primary,
                    size: GFSize.SMALL,
                  ),
                ],
              ]),
              4.heightBox,
              HStack([
                GFBadge(
                  text: member.role.name.toUpperCase(),
                  color: roleColor.withValues(alpha: 0.1),
                  textColor: roleColor,
                  size: GFSize.SMALL,
                ),
                8.widthBox,
                '${balance.totalMeals.toStringAsFixed(0)} meals'.text.xs
                    .color(AppColors.textMutedDark)
                    .make(),
              ]),
            ]).expand(),
            // Balance
            VStack(crossAlignment: CrossAxisAlignment.end, [
              '${balance.balance >= 0 ? '+' : ''}৳${balance.balance.toStringAsFixed(0)}'
                  .text
                  .lg
                  .color(balanceColor)
                  .bold
                  .make(),
              'balance'.text.xs.color(AppColors.textMutedDark).make(),
            ]),
          ]).p16(),

          // Food Preferences
          if (member.preferences.isNotEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: AppColors.surfaceDark,
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(AppSpacing.radiusMd - 1),
                ),
              ),
              child: VStack(crossAlignment: CrossAxisAlignment.start, [
                HStack([
                  Icon(
                    LucideIcons.alertCircle,
                    size: 14,
                    color: AppColors.warning,
                  ),
                  4.widthBox,
                  'Food Preferences'.text.xs
                      .color(AppColors.textSecondaryDark)
                      .make(),
                ]),
                8.heightBox,
                Wrap(
                  spacing: 4,
                  runSpacing: 4,
                  children: member.preferences.map((pref) {
                    final label = pref.notes ?? pref.type.name;
                    return GFBadge(
                      text: label,
                      color: AppColors.warning.withValues(alpha: 0.1),
                      textColor: AppColors.warning,
                      size: GFSize.SMALL,
                      shape: GFBadgeShape.pills,
                    );
                  }).toList(),
                ),
              ]),
            ),
        ]),
      ),
    ).animate(delay: (80 * index).ms).fadeIn().slideX(begin: 0.03);
  }

  Color _getRoleColor(MemberRole role) {
    switch (role) {
      case MemberRole.superAdmin:
        return AppColors.error;
      case MemberRole.admin:
        return AppColors.warning;
      case MemberRole.mealManager:
        return AppColors.primary;
      case MemberRole.maintenance:
        return AppColors.info;
      case MemberRole.member:
        return AppColors.success;
      case MemberRole.temp:
        return AppColors.textMutedDark;
      case MemberRole.guest:
        return AppColors.borderDark;
    }
  }
}
