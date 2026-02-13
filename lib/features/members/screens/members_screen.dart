import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:gap/gap.dart';

import 'package:mess_manager/core/theme/app_theme.dart';
import 'package:mess_manager/core/providers/members_provider.dart';
import 'package:mess_manager/core/models/member.dart';
import 'package:mess_manager/core/widgets/app_components.dart';
import 'package:mess_manager/core/widgets/animated_widgets.dart';
import 'package:mess_manager/core/services/haptic_service.dart';
import 'package:mess_manager/features/members/widgets/add_edit_member_sheet.dart';
import 'package:mess_manager/features/members/widgets/member_actions_sheet.dart';
import 'package:mess_manager/features/balance/providers/balance_provider.dart';

/// Members Screen - Cosmic Bioluminescence Design
class MembersScreen extends ConsumerWidget {
  const MembersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final members = ref.watch(membersProvider);
    final balances = ref.watch(memberBalancesProvider);
    final currentMemberId = ref.watch(currentMemberIdProvider);

    return Scaffold(
      backgroundColor: const Color(0xFF0A0E1A),
      body: Stack(
        children: [
          // === Deep Space Background ===
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFF0A0E1A), Color(0xFF0D1520)],
                ),
              ),
            ),
          ),

          // Teal accent orb
          Positioned(
            top: -30,
            right: -50,
            child: Container(
              width: 180,
              height: 180,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppColors.primary.withValues(alpha: 0.12),
                    AppColors.primary.withValues(alpha: 0.02),
                    Colors.transparent,
                  ],
                ),
              ),
            )
                .animate(onPlay: (c) => c.repeat(reverse: true))
                .scaleXY(begin: 1.0, end: 1.15, duration: 4.seconds),
          ),

          // Violet accent orb
          Positioned(
            bottom: 120,
            left: -40,
            child: Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppColors.accent.withValues(alpha: 0.06),
                    Colors.transparent,
                  ],
                ),
              ),
            )
                .animate(onPlay: (c) => c.repeat(reverse: true))
                .scaleXY(begin: 0.9, end: 1.1, duration: 5.seconds),
          ),

          // === Main Content ===
          SafeArea(
            child: Column(
              children: [
                // Custom Header
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                  child: Row(
                    children: [
                      // Icon with gradient halo
                      Container(
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: RadialGradient(
                            colors: [
                              AppColors.primary.withValues(alpha: 0.3),
                              AppColors.primary.withValues(alpha: 0.05),
                            ],
                          ),
                          border: Border.all(
                            color: AppColors.primary.withValues(alpha: 0.2),
                          ),
                        ),
                        child: const Icon(
                          LucideIcons.users,
                          color: AppColors.primary,
                          size: 20,
                        ),
                      ),
                      const Gap(12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Members',
                              style: AppTypography.headlineMedium.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Text(
                              '${members.length} people in mess',
                              style: AppTypography.bodySmall.copyWith(
                                color: Colors.white.withValues(alpha: 0.4),
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Add member button
                      _buildGlassIconButton(
                        context,
                        icon: LucideIcons.userPlus,
                        color: AppColors.primary,
                        onTap: () {
                          HapticService.buttonPress();
                          _showAddEditSheet(context);
                        },
                      ),
                    ],
                  ).animate().fadeIn(duration: 500.ms).slideY(begin: -0.1),
                ),

                const Gap(16),

                // Member List
                Expanded(
                  child: members.isEmpty
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
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.md,
                          ),
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
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGlassIconButton(
    BuildContext context, {
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: color.withValues(alpha: 0.15),
              ),
            ),
            child: Icon(icon, color: color, size: 18),
          ),
        ),
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
    final roleColor = _getRoleColor(context, member.role);
    final balanceColor = balance.balance >= 0
        ? AppColors.moneyPositive
        : AppColors.moneyNegative;

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm + 2),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
          child: GestureDetector(
            onTap: () => _showAddEditSheet(context, member: member),
            onLongPress: () => _showMemberActions(context, member),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.03),
                borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                border: Border.all(
                  color: isCurrentUser
                      ? AppColors.primary.withValues(alpha: 0.3)
                      : Colors.white.withValues(alpha: 0.05),
                  width: isCurrentUser ? 1.5 : 1,
                ),
              ),
              child: Column(
                children: [
                  // Header Row
                  Padding(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    child: Row(
                      children: [
                        // Avatar with glow ring
                        Container(
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isCurrentUser
                                  ? AppColors.primary.withValues(alpha: 0.4)
                                  : Colors.white.withValues(alpha: 0.1),
                              width: isCurrentUser ? 2 : 1,
                            ),
                            boxShadow: isCurrentUser
                                ? [
                                    BoxShadow(
                                      color: AppColors.primary
                                          .withValues(alpha: 0.2),
                                      blurRadius: 8,
                                    ),
                                  ]
                                : null,
                          ),
                          child: AppMemberAvatar(
                            name: member.name,
                            size: 44,
                            backgroundColor:
                                AppColors.primary.withValues(alpha: 0.1),
                          ),
                        ),
                        const Gap(12),
                        // Info
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    member.name,
                                    style: TextStyle(
                                      color: Colors.white
                                          .withValues(alpha: 0.9),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  if (isCurrentUser) ...[
                                    const Gap(6),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 6,
                                        vertical: 2,
                                      ),
                                      decoration: BoxDecoration(
                                        color: AppColors.primary
                                            .withValues(alpha: 0.12),
                                        borderRadius:
                                            BorderRadius.circular(6),
                                        border: Border.all(
                                          color: AppColors.primary
                                              .withValues(alpha: 0.2),
                                        ),
                                      ),
                                      child: Text(
                                        'You',
                                        style: TextStyle(
                                          color: AppColors.primaryLight,
                                          fontSize: 10,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                              const Gap(4),
                              Row(
                                children: [
                                  // Role badge with cosmic styling
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 2,
                                    ),
                                    decoration: BoxDecoration(
                                      color: roleColor
                                          .withValues(alpha: 0.08),
                                      borderRadius:
                                          BorderRadius.circular(6),
                                      border: Border.all(
                                        color: roleColor
                                            .withValues(alpha: 0.15),
                                      ),
                                    ),
                                    child: Text(
                                      member.role.name.toUpperCase(),
                                      style: TextStyle(
                                        color: roleColor,
                                        fontSize: 9,
                                        fontWeight: FontWeight.w700,
                                        letterSpacing: 0.8,
                                      ),
                                    ),
                                  ),
                                  const Gap(8),
                                  Text(
                                    '${balance.totalMeals.toStringAsFixed(0)} meals',
                                    style: AppTypography.bodySmall.copyWith(
                                      color: Colors.white
                                          .withValues(alpha: 0.3),
                                      fontSize: 11,
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
                                fontWeight: FontWeight.bold,
                                fontFamily: 'JetBrains Mono',
                              ),
                            ),
                            Text(
                              'balance',
                              style: AppTypography.bodySmall.copyWith(
                                color: Colors.white.withValues(alpha: 0.25),
                                fontSize: 10,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Food Preferences
                  if (member.preferences.isNotEmpty)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(AppSpacing.md),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.02),
                        borderRadius: const BorderRadius.vertical(
                          bottom:
                              Radius.circular(AppSpacing.radiusMd - 1),
                        ),
                        border: Border(
                          top: BorderSide(
                            color: Colors.white.withValues(alpha: 0.04),
                          ),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 18,
                                height: 18,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: RadialGradient(
                                    colors: [
                                      AppColors.warning
                                          .withValues(alpha: 0.3),
                                      AppColors.warning
                                          .withValues(alpha: 0.05),
                                    ],
                                  ),
                                ),
                                child: const Icon(
                                  LucideIcons.alertCircle,
                                  size: 10,
                                  color: AppColors.warning,
                                ),
                              ),
                              const Gap(6),
                              Text(
                                'Food Preferences',
                                style: AppTypography.bodySmall.copyWith(
                                  color: Colors.white
                                      .withValues(alpha: 0.4),
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                          const Gap(8),
                          Wrap(
                            spacing: 4,
                            runSpacing: 4,
                            children: member.preferences.map((pref) {
                              final label =
                                  pref.notes ?? pref.type.name;
                              return Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 3,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.warning
                                      .withValues(alpha: 0.06),
                                  borderRadius:
                                      BorderRadius.circular(6),
                                  border: Border.all(
                                    color: AppColors.warning
                                        .withValues(alpha: 0.12),
                                  ),
                                ),
                                child: Text(
                                  label,
                                  style: TextStyle(
                                    color: AppColors.warning
                                        .withValues(alpha: 0.8),
                                    fontSize: 10,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    ).animate(delay: (80 * index).ms).fadeIn().slideX(begin: 0.03);
  }

  Color _getRoleColor(BuildContext context, MemberRole role) {
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
        return Colors.white.withValues(alpha: 0.3);
      case MemberRole.guest:
        return Colors.white.withValues(alpha: 0.2);
    }
  }
}
