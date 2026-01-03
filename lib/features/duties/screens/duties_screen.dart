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
import 'package:mess_manager/features/duties/providers/duty_provider.dart';

class DutiesScreen extends ConsumerStatefulWidget {
  const DutiesScreen({super.key});

  @override
  ConsumerState<DutiesScreen> createState() => _DutiesScreenState();
}

class _DutiesScreenState extends ConsumerState<DutiesScreen> {
  @override
  void initState() {
    super.initState();
    // Generate weekly duties on load
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

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundDark,
        title: Row(
          children: [
            const Icon(
              LucideIcons.clipboardList,
              color: AppColors.primary,
              size: 22,
            ),
            const Gap(AppSpacing.sm),
            const Text('Duties'),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () => _showAddScheduleSheet(context),
            icon: const Icon(LucideIcons.plus, size: 20),
            tooltip: 'Add Schedule',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Stats Card
            _buildStatsCard(weeklyStats),
            const Gap(AppSpacing.lg),

            // Today's Duties
            _buildSectionHeader("Today's Duties"),
            const Gap(AppSpacing.sm),
            if (todayDuties.isEmpty)
              _buildEmptyState('No duties scheduled for today')
            else
              ...todayDuties.asMap().entries.map((entry) {
                final duty = entry.value;
                final member = members
                    .where((m) => m.id == duty.memberId)
                    .firstOrNull;
                final memberName = member?.name ?? 'Unknown';
                return _buildDutyCard(duty, memberName, entry.key);
              }),
            const Gap(AppSpacing.lg),

            // Active Schedules
            _buildSectionHeader('Rotation Schedules'),
            const Gap(AppSpacing.sm),
            if (schedules.isEmpty)
              _buildQuickSetupCard(members)
            else
              ...schedules.asMap().entries.map((entry) {
                final schedule = entry.value;
                return _buildScheduleCard(schedule, members, entry.key);
              }),
            const Gap(AppSpacing.xxl),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsCard(Map<String, int> stats) {
    final total = stats['total'] ?? 0;
    final completed = stats['completed'] ?? 0;
    final progress = total > 0 ? completed / total : 0.0;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primary.withValues(alpha: 0.8),
            AppColors.primaryLight.withValues(alpha: 0.6),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'This Week',
                    style: AppTypography.labelMedium.copyWith(
                      color: Colors.white.withValues(alpha: 0.8),
                    ),
                  ),
                  const Gap(AppSpacing.xs),
                  Text(
                    '$completed / $total Completed',
                    style: AppTypography.headlineSmall.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                ),
                child: const Icon(
                  LucideIcons.checkSquare,
                  color: Colors.white,
                  size: 28,
                ),
              ),
            ],
          ),
          const Gap(AppSpacing.md),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.white.withValues(alpha: 0.3),
              valueColor: const AlwaysStoppedAnimation(Colors.white),
              minHeight: 8,
            ),
          ),
          const Gap(AppSpacing.md),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem('Pending', '${stats['pending'] ?? 0}'),
              _buildStatItem('Completed', '$completed'),
              _buildStatItem('Skipped', '${stats['skipped'] ?? 0}'),
            ],
          ),
        ],
      ),
    ).animate().fadeIn(duration: 400.ms).scale(begin: const Offset(0.95, 0.95));
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: AppTypography.titleMedium.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
        Text(
          label,
          style: AppTypography.labelSmall.copyWith(
            color: Colors.white.withValues(alpha: 0.7),
          ),
        ),
      ],
    );
  }

  Widget _buildSectionHeader(String title) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 20,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: AppColors.gradientPrimary,
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const Gap(AppSpacing.sm),
        Text(
          title,
          style: AppTypography.headlineSmall.copyWith(
            color: AppColors.textPrimaryDark,
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState(String message) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        color: AppColors.cardDark,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        border: Border.all(color: AppColors.borderDark.withValues(alpha: 0.5)),
      ),
      child: Center(
        child: Text(
          message,
          style: AppTypography.bodyMedium.copyWith(
            color: AppColors.textMutedDark,
          ),
        ),
      ),
    );
  }

  /// Quick setup card for creating sample schedules
  Widget _buildQuickSetupCard(List members) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.cardDark,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          Icon(LucideIcons.settings2, color: AppColors.primary, size: 40),
          const Gap(AppSpacing.md),
          Text(
            'No Schedules Set Up',
            style: AppTypography.titleMedium.copyWith(
              color: AppColors.textPrimaryDark,
            ),
          ),
          const Gap(AppSpacing.xs),
          Text(
            'Create rotation schedules to auto-assign duties',
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.textMutedDark,
            ),
            textAlign: TextAlign.center,
          ),
          const Gap(AppSpacing.lg),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => _quickSetup(members),
                  icon: const Icon(LucideIcons.zap, size: 18),
                  label: const Text('Quick Setup'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      vertical: AppSpacing.sm,
                    ),
                  ),
                ),
              ),
              const Gap(AppSpacing.sm),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _showAddScheduleSheet(context),
                  icon: const Icon(LucideIcons.plus, size: 18),
                  label: const Text('Custom'),
                ),
              ),
            ],
          ),
        ],
      ),
    ).animate().fadeIn();
  }

  /// Quick setup creates common duty schedules
  Future<void> _quickSetup(List members) async {
    HapticService.success();
    final memberIds = members.map((m) => m.id as String).toList();

    if (memberIds.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No members found. Add members first.'),
          backgroundColor: AppColors.warning,
        ),
      );
      return;
    }

    // Create common duty schedules
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

    // Generate duties for the week
    await ref.read(dutyAssignmentsProvider.notifier).generateWeeklyDuties();

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Duty schedules created! ✓'),
          backgroundColor: AppColors.success,
        ),
      );
    }
  }

  Widget _buildDutyCard(DutyAssignment duty, String memberName, int index) {
    final currentMemberId = ref.watch(currentMemberIdProvider);
    final isMyDuty = duty.memberId == currentMemberId;
    final color = _getDutyColor(duty.type);

    // Status-based styling
    Color statusColor;
    IconData statusIcon;
    String statusText;

    switch (duty.status) {
      case DutyStatus.pending:
        statusColor = color;
        statusIcon = LucideIcons.clock;
        statusText = 'Pending';
      case DutyStatus.completed:
        statusColor = AppColors.info;
        statusIcon = LucideIcons.checkCircle;
        statusText = 'Awaiting Approval';
      case DutyStatus.disputed:
        statusColor = AppColors.warning;
        statusIcon = LucideIcons.alertTriangle;
        statusText = 'Disputed';
      case DutyStatus.approved:
        statusColor = AppColors.moneyPositive;
        statusIcon = LucideIcons.checkCircle2;
        statusText = 'Approved';
      case DutyStatus.rejected:
        statusColor = AppColors.error;
        statusIcon = LucideIcons.xCircle;
        statusText = 'Rejected';
      case DutyStatus.skipped:
        statusColor = AppColors.textMutedDark;
        statusIcon = LucideIcons.skipForward;
        statusText = 'Skipped';
      case DutyStatus.swapped:
        statusColor = AppColors.accent;
        statusIcon = LucideIcons.repeat;
        statusText = 'Swapped';
    }

    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.cardDark,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        border: Border.all(color: statusColor.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(AppSpacing.sm),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                ),
                child: Icon(_getDutyIcon(duty.type), color: color, size: 24),
              ),
              const Gap(AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _getDutyName(duty.type),
                      style: AppTypography.titleSmall.copyWith(
                        color: AppColors.textPrimaryDark,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Gap(2),
                    Row(
                      children: [
                        Icon(
                          LucideIcons.user,
                          size: 12,
                          color: AppColors.textMutedDark,
                        ),
                        const Gap(4),
                        Text(
                          memberName,
                          style: AppTypography.bodySmall.copyWith(
                            color: AppColors.textSecondaryDark,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Status badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(statusIcon, size: 14, color: statusColor),
                    const Gap(4),
                    Text(
                      statusText,
                      style: AppTypography.labelSmall.copyWith(
                        color: statusColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          // Action buttons row
          if (duty.status == DutyStatus.pending && isMyDuty) ...[
            const Gap(AppSpacing.sm),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton.icon(
                  onPressed: () => _showCompleteSheet(duty),
                  icon: const Icon(LucideIcons.camera, size: 16),
                  label: const Text('Complete with Photo'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.moneyPositive,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                  ),
                ),
              ],
            ),
          ],

          // Dispute button (for non-owners on completed duties)
          if (duty.status == DutyStatus.completed && !isMyDuty) ...[
            const Gap(AppSpacing.sm),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                OutlinedButton.icon(
                  onPressed: () => _showDisputeSheet(duty),
                  icon: const Icon(LucideIcons.alertTriangle, size: 16),
                  label: const Text('Dispute'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.warning,
                    side: const BorderSide(color: AppColors.warning),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                  ),
                ),
              ],
            ),
          ],

          // Admin actions (approve/reject disputed duties)
          if (duty.status == DutyStatus.disputed ||
              duty.status == DutyStatus.completed) ...[
            if (_isAdmin()) ...[
              const Gap(AppSpacing.sm),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton.icon(
                    onPressed: () => _rejectDuty(duty),
                    icon: const Icon(LucideIcons.x, size: 16),
                    label: const Text('Reject'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.error,
                      side: const BorderSide(color: AppColors.error),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                    ),
                  ),
                  const Gap(AppSpacing.sm),
                  ElevatedButton.icon(
                    onPressed: () => _approveDuty(duty),
                    icon: const Icon(LucideIcons.check, size: 16),
                    label: const Text('Approve'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.moneyPositive,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ],
      ),
    ).animate(delay: (80 * index).ms).fadeIn().slideX(begin: 0.03);
  }

  Widget _buildScheduleCard(DutySchedule schedule, List members, int index) {
    final color = _getDutyColor(schedule.type);

    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.cardDark,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        border: Border.all(color: AppColors.borderDark.withValues(alpha: 0.5)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.sm),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
            ),
            child: Icon(_getDutyIcon(schedule.type), color: color, size: 20),
          ),
          const Gap(AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _getDutyName(schedule.type),
                  style: AppTypography.titleSmall.copyWith(
                    color: AppColors.textPrimaryDark,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Gap(2),
                Text(
                  '${schedule.rotationOrder.length} members • ${schedule.rotationIntervalDays}d rotation',
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textMutedDark,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: schedule.isActive
                  ? AppColors.moneyPositive.withValues(alpha: 0.1)
                  : AppColors.textMutedDark.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              schedule.isActive ? 'Active' : 'Paused',
              style: AppTypography.labelSmall.copyWith(
                color: schedule.isActive
                    ? AppColors.moneyPositive
                    : AppColors.textMutedDark,
              ),
            ),
          ),
        ],
      ),
    ).animate(delay: (60 * index).ms).fadeIn().slideX(begin: 0.02);
  }

  Color _getDutyColor(DutyType type) {
    switch (type) {
      case DutyType.roomCleaning:
        return AppColors.primary;
      case DutyType.diningCleanup:
        return AppColors.accentWarm;
      case DutyType.bazarDuty:
        return AppColors.bazarColor;
      case DutyType.garbageDisposal:
        return AppColors.moneyNegative;
      case DutyType.cooking:
        return AppColors.secondary;
    }
  }

  IconData _getDutyIcon(DutyType type) {
    switch (type) {
      case DutyType.roomCleaning:
        return LucideIcons.home;
      case DutyType.diningCleanup:
        return LucideIcons.utensils;
      case DutyType.bazarDuty:
        return LucideIcons.shoppingCart;
      case DutyType.garbageDisposal:
        return LucideIcons.trash2;
      case DutyType.cooking:
        return LucideIcons.chefHat;
    }
  }

  String _getDutyName(DutyType type) {
    switch (type) {
      case DutyType.roomCleaning:
        return 'Room Cleaning';
      case DutyType.diningCleanup:
        return 'Dining Cleanup';
      case DutyType.bazarDuty:
        return 'Bazar Duty';
      case DutyType.garbageDisposal:
        return 'Garbage Disposal';
      case DutyType.cooking:
        return 'Cooking';
    }
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
    final currentMemberId = ref.read(currentMemberIdProvider);
    HapticService.success();
    await ref
        .read(dutyAssignmentsProvider.notifier)
        .approveDuty(
          dutyId: duty.id,
          reviewedBy: currentMemberId,
          adminNotes: 'Approved',
        );
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Duty approved ✓'),
          backgroundColor: AppColors.moneyPositive,
        ),
      );
    }
  }

  Future<void> _rejectDuty(DutyAssignment duty) async {
    final currentMemberId = ref.read(currentMemberIdProvider);
    HapticService.warning();
    await ref
        .read(dutyAssignmentsProvider.notifier)
        .rejectDuty(
          dutyId: duty.id,
          reviewedBy: currentMemberId,
          adminNotes: 'Rejected - needs to be redone',
        );
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Duty rejected'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }
}

/// Add Schedule Bottom Sheet
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
      setState(() {
        _selectedMembers.addAll(members.map((m) => m.id));
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final members = ref.watch(membersProvider);

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
          Text(
            'Create Duty Schedule',
            style: AppTypography.headlineMedium.copyWith(
              color: AppColors.textPrimaryDark,
            ),
          ),
          const Gap(AppSpacing.lg),

          // Duty Type
          Text(
            'Duty Type',
            style: AppTypography.labelMedium.copyWith(
              color: AppColors.textSecondaryDark,
            ),
          ),
          const Gap(AppSpacing.sm),
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: DutyType.values.map((type) {
              final isSelected = _selectedType == type;
              return ChoiceChip(
                selected: isSelected,
                label: Text(_getDutyName(type)),
                onSelected: (_) => setState(() => _selectedType = type),
              );
            }).toList(),
          ),
          const Gap(AppSpacing.lg),

          // Rotation Interval
          Text(
            'Rotation Interval (days)',
            style: AppTypography.labelMedium.copyWith(
              color: AppColors.textSecondaryDark,
            ),
          ),
          const Gap(AppSpacing.sm),
          Row(
            children: [1, 2, 3, 7].map((days) {
              final isSelected = _rotationDays == days;
              return Padding(
                padding: const EdgeInsets.only(right: AppSpacing.sm),
                child: ChoiceChip(
                  selected: isSelected,
                  label: Text('$days day${days > 1 ? 's' : ''}'),
                  onSelected: (_) => setState(() => _rotationDays = days),
                ),
              );
            }).toList(),
          ),
          const Gap(AppSpacing.lg),

          // Members
          Text(
            'Members in Rotation',
            style: AppTypography.labelMedium.copyWith(
              color: AppColors.textSecondaryDark,
            ),
          ),
          const Gap(AppSpacing.sm),
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: members.map((m) {
              final isSelected = _selectedMembers.contains(m.id);
              return FilterChip(
                selected: isSelected,
                label: Text(m.name),
                onSelected: (s) {
                  setState(() {
                    if (s) {
                      _selectedMembers.add(m.id);
                    } else {
                      _selectedMembers.remove(m.id);
                    }
                  });
                },
              );
            }).toList(),
          ),
          const Gap(AppSpacing.xl),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _createSchedule,
              icon: const Icon(LucideIcons.check, size: 18),
              label: const Text('Create Schedule'),
            ),
          ),
          const Gap(AppSpacing.lg),
        ],
      ),
    );
  }

  String _getDutyName(DutyType type) {
    switch (type) {
      case DutyType.roomCleaning:
        return 'Room Cleaning';
      case DutyType.diningCleanup:
        return 'Dining Cleanup';
      case DutyType.bazarDuty:
        return 'Bazar Duty';
      case DutyType.garbageDisposal:
        return 'Garbage';
      case DutyType.cooking:
        return 'Cooking';
    }
  }

  void _createSchedule() {
    if (_selectedMembers.isEmpty) return;

    ref
        .read(dutySchedulesProvider.notifier)
        .createSchedule(
          type: _selectedType,
          memberIds: _selectedMembers.toList(),
          rotationDays: _rotationDays,
        );

    // Generate duties immediately
    ref.read(dutyAssignmentsProvider.notifier).generateWeeklyDuties();

    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Schedule created ✓'),
        backgroundColor: AppColors.success,
      ),
    );
  }
}

/// Duty Completion Sheet with Photo Proof
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

  Future<void> _pickPhoto() async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 80,
    );
    if (image != null) {
      setState(() => _photoUrls.add(image.path));
      HapticService.lightTap();
    }
  }

  Future<void> _pickFromGallery() async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    if (image != null) {
      setState(() => _photoUrls.add(image.path));
      HapticService.lightTap();
    }
  }

  void _removePhoto(int index) {
    setState(() => _photoUrls.removeAt(index));
  }

  Future<void> _submit() async {
    if (_photoUrls.isEmpty) return;

    setState(() => _isSubmitting = true);

    // Mark duty complete with photo proof
    // For now, we'll store the first photo path. In production, upload all to Firebase Storage
    await ref
        .read(dutyAssignmentsProvider.notifier)
        .markComplete(
          widget.duty.id,
          proofImagePath: _photoUrls.join(
            ',',
          ), // Store all paths comma-separated
        );

    HapticService.success();
    if (mounted) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Duty completed with photo proof ✓'),
          backgroundColor: AppColors.moneyPositive,
        ),
      );
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
        color: AppColors.surfaceDark,
        borderRadius: BorderRadius.vertical(
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
          Row(
            children: [
              const Icon(
                LucideIcons.checkCircle,
                color: AppColors.moneyPositive,
              ),
              const Gap(AppSpacing.sm),
              Text(
                'Complete Duty',
                style: AppTypography.headlineMedium.copyWith(
                  color: AppColors.textPrimaryDark,
                ),
              ),
            ],
          ),
          const Gap(AppSpacing.sm),
          Text(
            'Add photo proof to mark this duty as complete',
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.textSecondaryDark,
            ),
          ),
          const Gap(AppSpacing.lg),

          // Photo Section
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: AppColors.cardDark,
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
              border: Border.all(
                color: _photoUrls.isEmpty
                    ? AppColors.warning.withValues(alpha: 0.3)
                    : AppColors.moneyPositive.withValues(alpha: 0.3),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
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
                    const Gap(AppSpacing.sm),
                    Text(
                      _photoUrls.isEmpty
                          ? 'Photo Required'
                          : '${_photoUrls.length} photo(s) added',
                      style: AppTypography.labelMedium.copyWith(
                        color: _photoUrls.isEmpty
                            ? AppColors.warning
                            : AppColors.moneyPositive,
                      ),
                    ),
                  ],
                ),
                const Gap(AppSpacing.md),

                // Photo Grid
                if (_photoUrls.isNotEmpty) ...[
                  SizedBox(
                    height: 80,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _photoUrls.length + 1,
                      itemBuilder: (context, index) {
                        if (index == _photoUrls.length) {
                          // Add more button
                          return _buildAddPhotoButton();
                        }
                        return _buildPhotoThumbnail(_photoUrls[index], index);
                      },
                    ),
                  ),
                ] else ...[
                  // Empty state - Add photo buttons
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: _pickPhoto,
                          icon: const Icon(LucideIcons.camera, size: 18),
                          label: const Text('Camera'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.primary,
                            side: const BorderSide(color: AppColors.primary),
                            padding: const EdgeInsets.symmetric(
                              vertical: AppSpacing.md,
                            ),
                          ),
                        ),
                      ),
                      const Gap(AppSpacing.sm),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: _pickFromGallery,
                          icon: const Icon(LucideIcons.image, size: 18),
                          label: const Text('Gallery'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.textSecondaryDark,
                            side: const BorderSide(color: AppColors.borderDark),
                            padding: const EdgeInsets.symmetric(
                              vertical: AppSpacing.md,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
          const Gap(AppSpacing.lg),

          // Submit Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _photoUrls.isNotEmpty && !_isSubmitting
                  ? _submit
                  : null,
              icon: _isSubmitting
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(LucideIcons.check, size: 20),
              label: Text(
                _photoUrls.isEmpty ? 'Add Photo to Continue' : 'Mark Complete',
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.moneyPositive,
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                disabledBackgroundColor: AppColors.cardDark,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPhotoThumbnail(String path, int index) {
    return Container(
      width: 80,
      height: 80,
      margin: const EdgeInsets.only(right: AppSpacing.sm),
      decoration: BoxDecoration(
        color: AppColors.elevatedDark,
        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
        border: Border.all(
          color: AppColors.moneyPositive.withValues(alpha: 0.3),
        ),
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Center(
            child: Icon(
              LucideIcons.image,
              color: AppColors.textMutedDark,
              size: 24,
            ),
          ),
          Positioned(
            top: 4,
            right: 4,
            child: GestureDetector(
              onTap: () => _removePhoto(index),
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: AppColors.error,
                  shape: BoxShape.circle,
                ),
                child: const Icon(LucideIcons.x, size: 12, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddPhotoButton() {
    return GestureDetector(
      onTap: _pickPhoto,
      child: Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
          border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(LucideIcons.plus, color: AppColors.primary, size: 24),
            const Gap(4),
            Text(
              'Add',
              style: AppTypography.labelSmall.copyWith(
                color: AppColors.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
