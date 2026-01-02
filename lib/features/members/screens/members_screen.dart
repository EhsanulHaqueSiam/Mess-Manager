import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:gap/gap.dart';
import 'package:mess_manager/core/theme/app_theme.dart';
import 'package:mess_manager/core/providers/members_provider.dart';
import 'package:mess_manager/core/models/member.dart';

import 'package:mess_manager/features/balance/providers/balance_provider.dart';

class MembersScreen extends ConsumerWidget {
  const MembersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final members = ref.watch(membersProvider);
    final balances = ref.watch(memberBalancesProvider);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Icon(LucideIcons.users, color: AppColors.primary, size: 22),
            const Gap(AppSpacing.sm),
            const Text('Members'),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(LucideIcons.userPlus),
            onPressed: () {}, // TODO: Add member
          ),
        ],
      ),
      body: ListView.builder(
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
          return _buildMemberCard(context, member, balance, index);
        },
      ),
    );
  }

  Widget _buildMemberCard(
    BuildContext context,
    Member member,
    MemberBalance balance,
    int index,
  ) {
    final isCurrentUser = member.id == 'm1'; // TODO: Get current user
    final roleColor = _getRoleColor(member.role);
    final balanceColor = balance.balance >= 0
        ? AppColors.moneyPositive
        : AppColors.moneyNegative;

    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.cardDark,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        border: Border.all(
          color: isCurrentUser
              ? AppColors.primary.withValues(alpha: 0.5)
              : AppColors.borderDark.withValues(alpha: 0.5),
          width: isCurrentUser ? 2 : 1,
        ),
      ),
      child: Column(
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Row(
              children: [
                // Avatar
                CircleAvatar(
                  radius: 24,
                  backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                  child: Text(
                    member.name[0].toUpperCase(),
                    style: AppTypography.headlineMedium.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                ),
                const Gap(AppSpacing.md),
                // Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            member.name,
                            style: AppTypography.titleMedium.copyWith(
                              color: AppColors.textPrimaryDark,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          if (isCurrentUser) ...[
                            const Gap(AppSpacing.xs),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.primary.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                'You',
                                style: AppTypography.labelSmall.copyWith(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: roleColor.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              member.role.name.toUpperCase(),
                              style: AppTypography.labelSmall.copyWith(
                                color: roleColor,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          const Gap(AppSpacing.sm),
                          Text(
                            '${balance.totalMeals.toStringAsFixed(0)} meals',
                            style: AppTypography.labelSmall.copyWith(
                              color: AppColors.textMutedDark,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // Balance
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '${balance.balance >= 0 ? '+' : ''}৳${balance.balance.toStringAsFixed(0)}',
                      style: AppTypography.titleMedium.copyWith(
                        color: balanceColor,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      'balance',
                      style: AppTypography.labelSmall.copyWith(
                        color: AppColors.textMutedDark,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Food Preferences
          if (member.preferences.isNotEmpty) ...[
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: AppColors.surfaceDark,
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(AppSpacing.radiusMd - 1),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        LucideIcons.alertCircle,
                        size: 14,
                        color: AppColors.warning,
                      ),
                      const Gap(4),
                      Text(
                        'Food Preferences',
                        style: AppTypography.labelSmall.copyWith(
                          color: AppColors.textSecondaryDark,
                        ),
                      ),
                    ],
                  ),
                  const Gap(AppSpacing.xs),
                  Wrap(
                    spacing: AppSpacing.xs,
                    runSpacing: AppSpacing.xs,
                    children: member.preferences.map((pref) {
                      final label = pref.notes ?? pref.type.name;
                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.warning.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(
                            AppSpacing.radiusSm,
                          ),
                          border: Border.all(
                            color: AppColors.warning.withValues(alpha: 0.3),
                          ),
                        ),
                        child: Text(
                          label,
                          style: AppTypography.labelSmall.copyWith(
                            color: AppColors.warning,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ],
        ],
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
