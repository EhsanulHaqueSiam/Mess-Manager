import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:gap/gap.dart';
import 'package:image_picker/image_picker.dart';

import 'package:mess_manager/core/theme/app_theme.dart';
import 'package:mess_manager/core/models/duty.dart';
import 'package:mess_manager/core/models/member.dart';
import 'package:mess_manager/core/providers/members_provider.dart';
import 'package:mess_manager/core/services/haptic_service.dart';
import 'package:mess_manager/core/widgets/app_components.dart';
import 'package:mess_manager/features/duties/providers/duty_provider.dart';

/// Duties Screen
class DutiesScreen extends ConsumerStatefulWidget {
  const DutiesScreen({super.key});

  @override
  ConsumerState<DutiesScreen> createState() => _DutiesScreenState();
}

class _DutiesScreenState extends ConsumerState<DutiesScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(dutyAssignmentsProvider.notifier).generateWeeklyDuties();
    });
  }

  @override
  Widget build(BuildContext context) {
    final todayDuties = ref.watch(todayDutiesProvider);
    final weeklyStats = ref.watch(weeklyDutyStatsProvider);
    final members = ref.watch(membersProvider);
    final schedules = ref.watch(dutySchedulesProvider);
    final dutyDebts = ref.watch(dutyDebtsProvider);
    final currentMemberId = ref.watch(currentMemberIdProvider);

    // Calculate debts/credits for current user
    final myDebts = dutyDebts
        .where((d) => d.debtorId == currentMemberId && !d.isSettled)
        .toList();
    final myCredits = dutyDebts
        .where((d) => d.creditorId == currentMemberId && !d.isSettled)
        .toList();

    return Scaffold(
      backgroundColor: const Color(0xFF0A0E1A),
      body: Stack(
        children: [
          // Background gradient
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

          // Breathing accent orb top-right
          Positioned(
            top: -60,
            right: -40,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppColors.primary.withValues(alpha: 0.15),
                    AppColors.primary.withValues(alpha: 0.0),
                  ],
                ),
              ),
            )
                .animate(onPlay: (c) => c.repeat(reverse: true))
                .scaleXY(begin: 0.8, end: 1.2, duration: 4000.ms, curve: Curves.easeInOut),
          ),

          // Breathing accent orb bottom-left
          Positioned(
            bottom: 100,
            left: -60,
            child: Container(
              width: 180,
              height: 180,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppColors.primary.withValues(alpha: 0.1),
                    AppColors.primary.withValues(alpha: 0.0),
                  ],
                ),
              ),
            )
                .animate(onPlay: (c) => c.repeat(reverse: true))
                .scaleXY(begin: 1.0, end: 1.3, duration: 5000.ms, curve: Curves.easeInOut),
          ),

          // Main content
          SafeArea(
            child: Column(
              children: [
                // Custom header
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.md, AppSpacing.sm, AppSpacing.md, 0,
                  ),
                  child: Row(
                    children: [
                      // Gradient halo icon
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: RadialGradient(
                            colors: [
                              AppColors.primary.withValues(alpha: 0.25),
                              AppColors.primary.withValues(alpha: 0.0),
                            ],
                          ),
                        ),
                        child: const Center(
                          child: Icon(
                            LucideIcons.clipboardList,
                            color: AppColors.primary,
                            size: 22,
                          ),
                        ),
                      ),
                      const Gap(12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Duties',
                              style: AppTypography.titleLarge.copyWith(
                                color: Colors.white.withValues(alpha: 0.9),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'Manage rotation schedules',
                              style: AppTypography.bodySmall.copyWith(
                                color: Colors.white.withValues(alpha: 0.5),
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Add button
                      ClipRRect(
                        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () => _showAddScheduleSheet(context),
                              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                              child: Container(
                                width: 40,
                                height: 40,
                                decoration: AppSpacing.accentCard(accent: AppColors.info),
                                child: Icon(
                                  LucideIcons.plus,
                                  size: 20,
                                  color: Colors.white.withValues(alpha: 0.9),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const Gap(8),

                // Scrollable body
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Stats Card
                        _buildStatsCard(context, weeklyStats),
                        const Gap(16),

                        // Today's Duties
                        _sectionHeader(context, "TODAY'S DUTIES"),
                        const Gap(8),
                        if (todayDuties.isEmpty)
                          _buildEmptyState(context, 'No duties scheduled for today')
                        else
                          ...todayDuties.asMap().entries.map((entry) {
                            final duty = entry.value;
                            String memberName = 'Unknown';
                            for (final m in members) {
                              if (m.id == duty.memberId) {
                                memberName = m.name;
                                break;
                              }
                            }
                            return _buildDutyCard(context, duty, memberName, entry.key);
                          }),
                        const Gap(16),

                        // Duty Debts Section (who owes whom)
                        if (myDebts.isNotEmpty || myCredits.isNotEmpty) ...[
                          _sectionHeader(context, 'DUTY BALANCE'),
                          const Gap(8),
                          _buildDutyDebtsCard(context, myDebts, myCredits, members),
                          const Gap(16),
                        ],

                        // Rotation Schedules
                        _sectionHeader(context, 'ROTATION SCHEDULES'),
                        const Gap(8),
                        if (schedules.isEmpty)
                          _buildQuickSetupCard(context, members)
                        else
                          ...schedules.asMap().entries.map(
                            (entry) =>
                                _buildScheduleCard(context, entry.value, members, entry.key),
                          ),
                        const Gap(80),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionHeader(BuildContext context, String title) {
    return Row(
      children: [
        Container(
          width: 3,
          height: 14,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AppColors.primary, AppColors.accentAlt],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const Gap(8),
        Text(
          title,
          style: AppTypography.labelSmall.copyWith(
            color: Colors.white.withValues(alpha: 0.5),
            fontWeight: FontWeight.w600,
            letterSpacing: 1.5,
          ),
        ),
      ],
    );
  }

  Widget _buildStatsCard(BuildContext context, Map<String, int> stats) {
    final total = stats['total'] ?? 0;
    final completed = stats['completed'] ?? 0;
    final progress = total > 0 ? completed / total : 0.0;

    return ClipRRect(
      borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.lg),
          decoration: AppSpacing.gradientCard(gradient: AppColors.gradientDuty),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'This Week',
                          style: AppTypography.bodySmall.copyWith(
                            color: Colors.white.withValues(alpha: 0.8),
                          ),
                        ),
                        const Gap(4),
                        Text(
                          '$completed / $total Completed',
                          style: AppTypography.titleLarge.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.1),
                      ),
                    ),
                    child: const Icon(
                      LucideIcons.checkSquare,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                ],
              ),
              const Gap(12),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: progress,
                  backgroundColor: Colors.white.withValues(alpha: 0.2),
                  valueColor: const AlwaysStoppedAnimation(Colors.white),
                  minHeight: 8,
                ),
              ),
              const Gap(12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _statItem('Pending', '${stats['pending'] ?? 0}'),
                  _statItem('Completed', '$completed'),
                  _statItem('Skipped', '${stats['skipped'] ?? 0}'),
                ],
              ),
            ],
          ),
        ),
      ),
    ).animate().fadeIn(duration: 400.ms).scale(begin: const Offset(0.95, 0.95));
  }

  Widget _statItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: AppTypography.titleMedium.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: AppTypography.bodySmall.copyWith(
            color: Colors.white.withValues(alpha: 0.7),
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState(BuildContext context, String message) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: Container(
          decoration: AppSpacing.accentCard(accent: AppColors.info),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Center(
              child: Text(
                message,
                style: TextStyle(color: Colors.white.withValues(alpha: 0.3)),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDutyDebtsCard(
    BuildContext context,
    List<DutyDebt> debts,
    List<DutyDebt> credits,
    List members,
  ) {
    String getMemberName(String id) {
      for (final m in members) {
        if (m.id == id) return m.name;
      }
      return 'Unknown';
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: AppSpacing.accentCard(accent: AppColors.info),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Credits (duties others owe you)
              if (credits.isNotEmpty) ...[
                Row(
                  children: [
                    const Icon(
                      LucideIcons.trendingUp,
                      color: AppColors.moneyPositive,
                      size: 18,
                    ),
                    const Gap(8),
                    Text(
                      'Others Owe You',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.moneyPositive,
                      ),
                    ),
                  ],
                ),
                const Gap(8),
                ...credits.map(
                  (c) => Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 14,
                          backgroundColor: AppColors.moneyPositive.withValues(
                            alpha: 0.1,
                          ),
                          child: Text(
                            getMemberName(c.debtorId)[0],
                            style: AppTypography.bodySmall.copyWith(
                              color: AppColors.moneyPositive,
                            ),
                          ),
                        ),
                        const Gap(8),
                        Expanded(
                          child: Text(
                            '${getMemberName(c.debtorId)} owes you 1 ${_getDutyName(c.dutyType)}',
                            style: AppTypography.bodySmall.copyWith(
                              color: Colors.white.withValues(alpha: 0.5),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                if (debts.isNotEmpty) const Gap(12),
              ],

              // Debts (duties you owe others)
              if (debts.isNotEmpty) ...[
                Row(
                  children: [
                    const Icon(
                      LucideIcons.trendingDown,
                      color: AppColors.moneyNegative,
                      size: 18,
                    ),
                    const Gap(8),
                    Text(
                      'You Owe',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.moneyNegative,
                      ),
                    ),
                  ],
                ),
                const Gap(8),
                ...debts.map(
                  (d) => Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 14,
                          backgroundColor: AppColors.moneyNegative.withValues(
                            alpha: 0.1,
                          ),
                          child: Text(
                            getMemberName(d.creditorId)[0],
                            style: AppTypography.bodySmall.copyWith(
                              color: AppColors.moneyNegative,
                            ),
                          ),
                        ),
                        const Gap(8),
                        Expanded(
                          child: Text(
                            'You owe ${getMemberName(d.creditorId)} 1 ${_getDutyName(d.dutyType)}',
                            style: AppTypography.bodySmall.copyWith(
                              color: Colors.white.withValues(alpha: 0.5),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    ).animate().fadeIn().slideX(begin: -0.05);
  }

  Widget _buildQuickSetupCard(BuildContext context, List members) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: Container(
          decoration: AppSpacing.accentCard(accent: AppColors.primary),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              children: [
                const Icon(
                  LucideIcons.settings2,
                  color: AppColors.primary,
                  size: 40,
                ),
                const Gap(12),
                Text(
                  'No Schedules Set Up',
                  style: AppTypography.titleMedium.copyWith(
                    color: Colors.white.withValues(alpha: 0.9),
                  ),
                  textAlign: TextAlign.center,
                ),
                const Gap(4),
                Text(
                  'Create rotation schedules to auto-assign duties',
                  style: AppTypography.bodySmall.copyWith(
                    color: Colors.white.withValues(alpha: 0.3),
                  ),
                  textAlign: TextAlign.center,
                ),
                const Gap(16),
                Row(
                  children: [
                    Expanded(
                      child: AppPrimaryButton(
                        text: 'Quick Setup',
                        icon: LucideIcons.zap,
                        onPressed: () => _quickSetup(members),
                      ),
                    ),
                    const Gap(8),
                    Expanded(
                      child: AppSecondaryButton(
                        text: 'Custom',
                        onPressed: () => _showAddScheduleSheet(context),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    ).animate().fadeIn();
  }

  Widget _buildDutyCard(
    BuildContext context,
    DutyAssignment duty,
    String memberName,
    int index,
  ) {
    final currentMemberId = ref.watch(currentMemberIdProvider);
    final isMyDuty = duty.memberId == currentMemberId;
    final color = _getDutyColor(duty.type);
    final (statusColor, statusIcon, statusText) = _getStatusInfo(
      duty.status,
      color,
    );

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
          child: Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: AppSpacing.accentCard(accent: statusColor),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: color.withValues(alpha: 0.15),
                      child: Icon(_getDutyIcon(duty.type), color: color, size: 22),
                    ),
                    const Gap(12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _getDutyName(duty.type),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white.withValues(alpha: 0.9),
                            ),
                          ),
                          const Gap(2),
                          Row(
                            children: [
                              Icon(
                                LucideIcons.user,
                                size: 12,
                                color: Colors.white.withValues(alpha: 0.3),
                              ),
                              const Gap(4),
                              Text(
                                memberName,
                                style: AppTypography.bodySmall.copyWith(
                                  color: Colors.white.withValues(alpha: 0.5),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    // Status Badge
                    AppBadge(
                      text: statusText,
                      color: statusColor.withValues(alpha: 0.1),
                      textColor: statusColor,
                    ),
                  ],
                ),

                // Action buttons
                if (duty.status == DutyStatus.pending && isMyDuty) ...[
                  const Gap(8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      FilledButton.icon(
                        onPressed: () => _showCompleteSheet(duty),
                        icon: const Icon(LucideIcons.camera, size: 16),
                        label: const Text('Complete with Photo'),
                        style: FilledButton.styleFrom(
                          backgroundColor: AppColors.moneyPositive,
                          textStyle: AppTypography.labelSmall,
                        ),
                      ),
                    ],
                  ),
                ],

                // Dispute button (for non-owners on completed duties)
                if (duty.status == DutyStatus.completed && !isMyDuty) ...[
                  const Gap(8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      OutlinedButton.icon(
                        onPressed: () => _showDisputeSheet(duty),
                        icon: const Icon(
                          LucideIcons.alertTriangle,
                          size: 16,
                          color: AppColors.warning,
                        ),
                        label: Text(
                          'Dispute',
                          style: TextStyle(color: AppColors.warning),
                        ),
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: AppColors.warning),
                        ),
                      ),
                    ],
                  ),
                ],

                // Admin actions
                if ((duty.status == DutyStatus.disputed ||
                        duty.status == DutyStatus.completed) &&
                    _isAdmin()) ...[
                  const Gap(8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      OutlinedButton.icon(
                        onPressed: () => _rejectDuty(duty),
                        icon: const Icon(LucideIcons.x, size: 16, color: AppColors.error),
                        label: Text(
                          'Reject',
                          style: TextStyle(color: AppColors.error),
                        ),
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: AppColors.error),
                        ),
                      ),
                      const Gap(8),
                      FilledButton.icon(
                        onPressed: () => _approveDuty(duty),
                        icon: const Icon(LucideIcons.check, size: 16),
                        label: const Text('Approve'),
                        style: FilledButton.styleFrom(
                          backgroundColor: AppColors.moneyPositive,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    ).animate(delay: (80 * index).ms).fadeIn().slideX(begin: 0.03);
  }

  (Color, IconData, String) _getStatusInfo(
    DutyStatus status,
    Color defaultColor,
  ) {
    return switch (status) {
      DutyStatus.pending => (defaultColor, LucideIcons.clock, 'Pending'),
      DutyStatus.completed => (
        AppColors.info,
        LucideIcons.checkCircle,
        'Awaiting Approval',
      ),
      DutyStatus.disputed => (
        AppColors.warning,
        LucideIcons.alertTriangle,
        'Disputed',
      ),
      DutyStatus.approved => (
        AppColors.moneyPositive,
        LucideIcons.checkCircle2,
        'Approved',
      ),
      DutyStatus.rejected => (AppColors.error, LucideIcons.xCircle, 'Rejected'),
      DutyStatus.skipped => (
        Colors.white.withValues(alpha: 0.3),
        LucideIcons.skipForward,
        'Skipped',
      ),
      DutyStatus.swapped => (AppColors.accent, LucideIcons.repeat, 'Swapped'),
    };
  }

  Widget _buildScheduleCard(
    BuildContext context,
    DutySchedule schedule,
    List members,
    int index,
  ) {
    final color = _getDutyColor(schedule.type);

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
          child: Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: AppSpacing.accentCard(accent: color),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundColor: color.withValues(alpha: 0.15),
                  child: Icon(_getDutyIcon(schedule.type), color: color, size: 20),
                ),
                const Gap(12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _getDutyName(schedule.type),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white.withValues(alpha: 0.9),
                        ),
                      ),
                      const Gap(2),
                      Text(
                        '${schedule.rotationOrder.length} members \u2022 ${schedule.rotationIntervalDays}d rotation',
                        style: AppTypography.bodySmall.copyWith(
                          color: Colors.white.withValues(alpha: 0.3),
                        ),
                      ),
                    ],
                  ),
                ),
                AppBadge(
                  text: schedule.isActive ? 'Active' : 'Paused',
                  color: schedule.isActive
                      ? AppColors.moneyPositive.withValues(alpha: 0.1)
                      : Colors.white.withValues(alpha: 0.05),
                  textColor: schedule.isActive
                      ? AppColors.moneyPositive
                      : Colors.white.withValues(alpha: 0.3),
                ),
              ],
            ),
          ),
        ),
      ),
    ).animate(delay: (60 * index).ms).fadeIn().slideX(begin: 0.02);
  }

  Color _getDutyColor(DutyType type) => switch (type) {
    DutyType.roomCleaning => AppColors.primary,
    DutyType.diningCleanup => AppColors.accentWarm,
    DutyType.bazarDuty => AppColors.bazarColor,
    DutyType.garbageDisposal => AppColors.moneyNegative,
    DutyType.cooking => AppColors.secondary,
    DutyType.custom => AppColors.info,
  };

  IconData _getDutyIcon(DutyType type) => switch (type) {
    DutyType.roomCleaning => LucideIcons.home,
    DutyType.diningCleanup => LucideIcons.utensils,
    DutyType.bazarDuty => LucideIcons.shoppingCart,
    DutyType.garbageDisposal => LucideIcons.trash2,
    DutyType.cooking => LucideIcons.chefHat,
    DutyType.custom => LucideIcons.clipboardList,
  };

  String _getDutyName(DutyType type) => switch (type) {
    DutyType.roomCleaning => 'Room Cleaning',
    DutyType.diningCleanup => 'Dining Cleanup',
    DutyType.bazarDuty => 'Bazar Duty',
    DutyType.garbageDisposal => 'Garbage Disposal',
    DutyType.cooking => 'Cooking',
    DutyType.custom => 'Custom',
  };

  Future<void> _quickSetup(List members) async {
    HapticService.success();
    final memberIds = members.map((m) => m.id as String).toList();

    if (memberIds.isEmpty) {
      showErrorToast(context, 'No members found. Add members first.');
      return;
    }

    final notifier = ref.read(dutySchedulesProvider.notifier);
    await notifier.createSchedule(
      type: DutyType.roomCleaning,
      memberIds: memberIds,
      rotationDays: 1,
    );
    await notifier.createSchedule(
      type: DutyType.diningCleanup,
      memberIds: memberIds,
      rotationDays: 1,
    );
    await notifier.createSchedule(
      type: DutyType.garbageDisposal,
      memberIds: memberIds,
      rotationDays: 2,
    );
    await ref.read(dutyAssignmentsProvider.notifier).generateWeeklyDuties();

    if (mounted) showSuccessToast(context, 'Duty schedules created!');
  }

  void _showCompleteSheet(DutyAssignment duty) {
    HapticService.modalOpen();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _DutyCompletionSheet(duty: duty),
    );
  }

  void _showAddScheduleSheet(BuildContext context) {
    HapticService.modalOpen();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const _AddScheduleSheet(),
    );
  }

  void _showDisputeSheet(DutyAssignment duty) {
    HapticService.modalOpen();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _DutyDisputeSheet(duty: duty),
    );
  }

  bool _isAdmin() {
    final currentMember = ref.read(currentMemberProvider);
    return currentMember?.role == MemberRole.superAdmin ||
        currentMember?.role == MemberRole.admin;
  }

  Future<void> _approveDuty(DutyAssignment duty) async {
    HapticService.success();
    await ref
        .read(dutyAssignmentsProvider.notifier)
        .approveDuty(
          dutyId: duty.id,
          reviewedBy: ref.read(currentMemberIdProvider),
          adminNotes: 'Approved',
        );
    if (mounted) showSuccessToast(context, 'Duty approved');
  }

  Future<void> _rejectDuty(DutyAssignment duty) async {
    HapticService.warning();
    await ref
        .read(dutyAssignmentsProvider.notifier)
        .rejectDuty(
          dutyId: duty.id,
          reviewedBy: ref.read(currentMemberIdProvider),
          adminNotes: 'Rejected - needs to be redone',
        );
    if (mounted) showErrorToast(context, 'Duty rejected');
  }
}

// ==================== Add Schedule Sheet ====================

class _AddScheduleSheet extends ConsumerStatefulWidget {
  const _AddScheduleSheet();

  @override
  ConsumerState<_AddScheduleSheet> createState() => _AddScheduleSheetState();
}

class _AddScheduleSheetState extends ConsumerState<_AddScheduleSheet> {
  DutyType _selectedType = DutyType.roomCleaning;
  int _rotationDays = 1;
  final Set<String> _selectedMembers = {};

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final members = ref.read(membersProvider);
      setState(() => _selectedMembers.addAll(members.map((m) => m.id)));
    });
  }

  @override
  Widget build(BuildContext context) {
    final members = ref.watch(membersProvider);

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: const BoxDecoration(
        color: Color(0xFF0D1520),
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppSpacing.radiusLg),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sheetHandle(context),
          const Gap(16),
          Text(
            'Create Duty Schedule',
            style: AppTypography.headlineSmall.copyWith(
              color: Colors.white.withValues(alpha: 0.9),
            ),
          ),
          const Gap(16),

          Text(
            'Duty Type',
            style: AppTypography.bodySmall.copyWith(
              color: Colors.white.withValues(alpha: 0.5),
            ),
          ),
          const Gap(8),
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: DutyType.values
                .map(
                  (type) => ChoiceChip(
                    selected: _selectedType == type,
                    label: Text(_getDutyName2(type)),
                    onSelected: (_) {
                      HapticService.selectionTick();
                      setState(() => _selectedType = type);
                    },
                  ),
                )
                .toList(),
          ),
          const Gap(16),

          Text(
            'Rotation Interval',
            style: AppTypography.bodySmall.copyWith(
              color: Colors.white.withValues(alpha: 0.5),
            ),
          ),
          const Gap(8),
          Wrap(
            spacing: AppSpacing.sm,
            children: [1, 2, 3, 7]
                .map(
                  (days) => ChoiceChip(
                    selected: _rotationDays == days,
                    label: Text('$days day${days > 1 ? 's' : ''}'),
                    onSelected: (_) {
                      HapticService.selectionTick();
                      setState(() => _rotationDays = days);
                    },
                  ),
                )
                .toList(),
          ),
          const Gap(16),

          Text(
            'Members in Rotation',
            style: AppTypography.bodySmall.copyWith(
              color: Colors.white.withValues(alpha: 0.5),
            ),
          ),
          const Gap(8),
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: members
                .map(
                  (m) => FilterChip(
                    selected: _selectedMembers.contains(m.id),
                    label: Text(m.name),
                    onSelected: (s) {
                      HapticService.selectionTick();
                      setState(
                        () => s
                            ? _selectedMembers.add(m.id)
                            : _selectedMembers.remove(m.id),
                      );
                    },
                  ),
                )
                .toList(),
          ),
          const Gap(24),

          AppPrimaryButton(
            text: 'Create Schedule',
            icon: LucideIcons.check,
            onPressed: _create,
          ),
          const Gap(16),
        ],
      ),
    );
  }

  String _getDutyName2(DutyType type) => switch (type) {
    DutyType.roomCleaning => 'Room Cleaning',
    DutyType.diningCleanup => 'Dining Cleanup',
    DutyType.bazarDuty => 'Bazar Duty',
    DutyType.garbageDisposal => 'Garbage',
    DutyType.cooking => 'Cooking',
    DutyType.custom => 'Custom',
  };

  void _create() {
    if (_selectedMembers.isEmpty) return;
    HapticService.success();

    ref
        .read(dutySchedulesProvider.notifier)
        .createSchedule(
          type: _selectedType,
          memberIds: _selectedMembers.toList(),
          rotationDays: _rotationDays,
        );
    ref.read(dutyAssignmentsProvider.notifier).generateWeeklyDuties();

    Navigator.pop(context);
    showSuccessToast(context, 'Schedule created');
  }
}

// ==================== Duty Completion Sheet ====================

class _DutyCompletionSheet extends ConsumerStatefulWidget {
  final DutyAssignment duty;
  const _DutyCompletionSheet({required this.duty});

  @override
  ConsumerState<_DutyCompletionSheet> createState() =>
      _DutyCompletionSheetState();
}

class _DutyCompletionSheetState extends ConsumerState<_DutyCompletionSheet> {
  final List<String> _photoUrls = [];
  final ImagePicker _picker = ImagePicker();
  bool _isSubmitting = false;

  Future<void> _pickPhoto(ImageSource source) async {
    final image = await _picker.pickImage(source: source, imageQuality: 80);
    if (image != null) {
      setState(() => _photoUrls.add(image.path));
      HapticService.lightTap();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.7,
      ),
      decoration: const BoxDecoration(
        color: Color(0xFF0D1520),
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppSpacing.radiusLg),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sheetHandle(context),
          const Gap(16),

          Row(
            children: [
              const Icon(LucideIcons.checkCircle, color: AppColors.moneyPositive),
              const Gap(8),
              Text(
                'Complete Duty',
                style: AppTypography.headlineSmall.copyWith(
                  color: Colors.white.withValues(alpha: 0.9),
                ),
              ),
            ],
          ),
          const Gap(4),
          Text(
            'Add photo proof to mark this duty as complete',
            style: AppTypography.bodySmall.copyWith(
              color: Colors.white.withValues(alpha: 0.5),
            ),
          ),
          const Gap(16),

          // Photo Grid
          ClipRRect(
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
              child: Container(
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.03),
                  border: Border.all(
                    color: _photoUrls.isEmpty
                        ? AppColors.warning.withValues(alpha: 0.3)
                        : AppColors.moneyPositive.withValues(alpha: 0.3),
                  ),
                  borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Icon(
                          LucideIcons.camera,
                          color: _photoUrls.isEmpty
                              ? AppColors.warning
                              : AppColors.moneyPositive,
                          size: 18,
                        ),
                        const Gap(8),
                        Expanded(
                          child: Text(
                            _photoUrls.isEmpty
                                ? 'Photo Required'
                                : '${_photoUrls.length} photo(s) added',
                            style: TextStyle(
                              color: _photoUrls.isEmpty
                                  ? AppColors.warning
                                  : AppColors.moneyPositive,
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (_photoUrls.isNotEmpty) ...[
                      const Gap(8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: _photoUrls
                            .asMap()
                            .entries
                            .map(
                              (e) => Stack(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.network(
                                      e.value,
                                      width: 60,
                                      height: 60,
                                      fit: BoxFit.cover,
                                      errorBuilder: (_, __, ___) => Container(
                                        width: 60,
                                        height: 60,
                                        color: AppColors.primary.withValues(
                                          alpha: 0.2,
                                        ),
                                        child: const Icon(
                                          LucideIcons.image,
                                          color: AppColors.primary,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    top: -4,
                                    right: -4,
                                    child: GestureDetector(
                                      onTap: () => setState(
                                        () => _photoUrls.removeAt(e.key),
                                      ),
                                      child: Container(
                                        padding: const EdgeInsets.all(2),
                                        decoration: const BoxDecoration(
                                          color: AppColors.error,
                                          shape: BoxShape.circle,
                                        ),
                                        child: const Icon(
                                          LucideIcons.x,
                                          color: Colors.white,
                                          size: 12,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                            .toList(),
                      ),
                    ],
                    const Gap(12),
                    Row(
                      children: [
                        Expanded(
                          child: FilledButton.icon(
                            onPressed: () => _pickPhoto(ImageSource.camera),
                            icon: const Icon(LucideIcons.camera, size: 16),
                            label: const Text('Camera'),
                            style: FilledButton.styleFrom(
                              backgroundColor: AppColors.primary,
                            ),
                          ),
                        ),
                        const Gap(8),
                        Expanded(
                          child: FilledButton.icon(
                            onPressed: () => _pickPhoto(ImageSource.gallery),
                            icon: const Icon(LucideIcons.image, size: 16),
                            label: const Text('Gallery'),
                            style: FilledButton.styleFrom(
                              backgroundColor: AppColors.secondary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          const Gap(24),

          AppPrimaryButton(
            text: 'Complete Duty',
            icon: LucideIcons.check,
            isLoading: _isSubmitting,
            onPressed: _photoUrls.isEmpty ? null : _submit,
          ),
          const Gap(16),
        ],
      ),
    );
  }

  Future<void> _submit() async {
    if (_photoUrls.isEmpty) return;
    setState(() => _isSubmitting = true);

    await ref
        .read(dutyAssignmentsProvider.notifier)
        .markComplete(widget.duty.id, proofImagePath: _photoUrls.join(','));

    HapticService.success();
    if (mounted) {
      Navigator.pop(context);
      showSuccessToast(context, 'Duty completed with photo proof');
    }
  }
}

// ==================== Duty Dispute Sheet ====================

class _DutyDisputeSheet extends ConsumerStatefulWidget {
  final DutyAssignment duty;
  const _DutyDisputeSheet({required this.duty});

  @override
  ConsumerState<_DutyDisputeSheet> createState() => _DutyDisputeSheetState();
}

class _DutyDisputeSheetState extends ConsumerState<_DutyDisputeSheet> {
  final _reasonController = TextEditingController();
  final List<String> _photoUrls = [];
  final ImagePicker _picker = ImagePicker();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  Future<void> _pickPhoto() async {
    final image = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 80,
    );
    if (image != null) {
      setState(() => _photoUrls.add(image.path));
      HapticService.lightTap();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: const BoxDecoration(
        color: Color(0xFF0D1520),
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppSpacing.radiusLg),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sheetHandle(context),
          const Gap(16),

          Row(
            children: [
              const Icon(LucideIcons.alertTriangle, color: AppColors.warning),
              const Gap(8),
              Text(
                'Dispute Duty',
                style: AppTypography.headlineSmall.copyWith(
                  color: Colors.white.withValues(alpha: 0.9),
                ),
              ),
            ],
          ),
          const Gap(4),
          Text(
            'Provide evidence that this duty was not completed properly',
            style: AppTypography.bodySmall.copyWith(
              color: Colors.white.withValues(alpha: 0.5),
            ),
          ),
          const Gap(16),

          TextField(
            controller: _reasonController,
            decoration: const InputDecoration(
              labelText: 'Reason for dispute',
              prefixIcon: Icon(LucideIcons.messageSquare, size: 18),
            ),
            maxLines: 3,
          ),
          const Gap(16),

          AppSecondaryButton(
            text: 'Add Photo Evidence',
            icon: LucideIcons.camera,
            onPressed: _pickPhoto,
          ),

          if (_photoUrls.isNotEmpty) ...[
            const Gap(8),
            Text(
              '${_photoUrls.length} photo(s) added',
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.moneyPositive,
              ),
            ),
          ],
          const Gap(24),

          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: _isSubmitting ? null : _submit,
              icon: const Icon(LucideIcons.alertTriangle, size: 18),
              label: const Text('Submit Dispute'),
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.warning,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.lg,
                  vertical: AppSpacing.md,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
                ),
              ),
            ),
          ),
          const Gap(16),
        ],
      ),
    );
  }

  Future<void> _submit() async {
    if (_reasonController.text.isEmpty) {
      showErrorToast(context, 'Provide a reason');
      return;
    }

    setState(() => _isSubmitting = true);
    HapticService.warning();

    await ref
        .read(dutyAssignmentsProvider.notifier)
        .disputeDuty(
          dutyId: widget.duty.id,
          disputedBy: ref.read(currentMemberIdProvider),
          reason: _reasonController.text,
          disputePhotoPath: _photoUrls.isNotEmpty ? _photoUrls.join(',') : null,
        );

    if (mounted) {
      Navigator.pop(context);
      showInfoToast(context, 'Dispute submitted for admin review');
    }
  }
}

// ==================== Helpers ====================

Widget _sheetHandle(BuildContext context) {
  return Center(
    child: Container(
      width: 40,
      height: 4,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(2),
      ),
    ),
  );
}
