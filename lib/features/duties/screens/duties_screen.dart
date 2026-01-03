import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:gap/gap.dart';

import 'package:mess_manager/core/theme/app_theme.dart';
import 'package:mess_manager/core/models/duty.dart';
import 'package:mess_manager/core/providers/members_provider.dart';
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
      appBar: AppBar(
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
                final member = members.firstWhere(
                  (m) => m.id == duty.memberId,
                  orElse: () => members.first,
                );
                return _buildDutyCard(duty, member.name, entry.key);
              }),
            const Gap(AppSpacing.lg),

            // Active Schedules
            _buildSectionHeader('Rotation Schedules'),
            const Gap(AppSpacing.sm),
            if (schedules.isEmpty)
              _buildEmptyState('No rotation schedules set up')
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

  Widget _buildDutyCard(DutyAssignment duty, String memberName, int index) {
    final isCompleted = duty.status == DutyStatus.completed;
    final color = _getDutyColor(duty.type);

    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.cardDark,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        border: Border.all(
          color: isCompleted
              ? AppColors.moneyPositive.withValues(alpha: 0.3)
              : color.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
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
          if (isCompleted)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.moneyPositive.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    LucideIcons.checkCircle,
                    size: 14,
                    color: AppColors.moneyPositive,
                  ),
                  const Gap(4),
                  Text(
                    'Done',
                    style: AppTypography.labelSmall.copyWith(
                      color: AppColors.moneyPositive,
                    ),
                  ),
                ],
              ),
            )
          else
            IconButton(
              onPressed: () => _markComplete(duty.id),
              icon: const Icon(LucideIcons.check, size: 20),
              style: IconButton.styleFrom(
                backgroundColor: color.withValues(alpha: 0.1),
                foregroundColor: color,
              ),
            ),
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

  void _markComplete(String dutyId) {
    ref.read(dutyAssignmentsProvider.notifier).markComplete(dutyId);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Duty marked complete ✓'),
        backgroundColor: AppColors.moneyPositive,
      ),
    );
  }

  void _showAddScheduleSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const _AddScheduleSheet(),
    );
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
