import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:gap/gap.dart';
import 'package:mess_manager/core/theme/app_theme.dart';
import 'package:mess_manager/core/providers/members_provider.dart';
import 'package:mess_manager/features/meals/providers/meal_schedule_provider.dart';

class MealScheduleTab extends ConsumerStatefulWidget {
  const MealScheduleTab({super.key});

  @override
  ConsumerState<MealScheduleTab> createState() => _MealScheduleTabState();
}

class _MealScheduleTabState extends ConsumerState<MealScheduleTab> {
  String? _selectedMemberId;

  static const _weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
  static const _mealTypes = ['breakfast', 'lunch', 'dinner'];
  static const _mealIcons = {
    'breakfast': LucideIcons.sunrise,
    'lunch': LucideIcons.sun,
    'dinner': LucideIcons.moon,
  };

  @override
  void initState() {
    super.initState();
    _selectedMemberId = ref.read(currentMemberIdProvider);
  }

  @override
  Widget build(BuildContext context) {
    final members = ref.watch(membersProvider);
    final schedules = ref.watch(mealScheduleProvider);
    final expectedMeals = ref.watch(allMembersExpectedMealsProvider);

    final selectedSchedule = schedules[_selectedMemberId] ?? [];

    return Column(
      children: [
        // Header with member selector
        Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: AppColors.cardDark,
            border: Border(
              bottom: BorderSide(
                color: AppColors.borderDark.withValues(alpha: 0.5),
              ),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(
                    LucideIcons.calendarDays,
                    color: AppColors.primary,
                    size: 18,
                  ),
                  const Gap(AppSpacing.sm),
                  Text(
                    'Default Weekly Schedule',
                    style: AppTypography.titleMedium.copyWith(
                      color: AppColors.textPrimaryDark,
                    ),
                  ),
                ],
              ),
              const Gap(AppSpacing.xs),
              Text(
                'Set the expected meals for each day. Actual meals can differ.',
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.textSecondaryDark,
                ),
              ),
              const Gap(AppSpacing.md),

              // Member selector chips
              Wrap(
                spacing: AppSpacing.sm,
                runSpacing: AppSpacing.sm,
                children: members.map((member) {
                  final isSelected = _selectedMemberId == member.id;
                  final expected = expectedMeals[member.id] ?? 0;
                  return FilterChip(
                    selected: isSelected,
                    label: Text('${member.name} (${expected.toInt()}/wk)'),
                    onSelected: (_) =>
                        setState(() => _selectedMemberId = member.id),
                    selectedColor: AppColors.primary.withValues(alpha: 0.2),
                    checkmarkColor: AppColors.primary,
                    labelStyle: TextStyle(
                      color: isSelected
                          ? AppColors.primary
                          : AppColors.textPrimaryDark,
                      fontSize: 12,
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),

        // Schedule Grid
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              children: [
                // Header Row (Days)
                Row(
                  children: [
                    const SizedBox(width: 60), // Meal type column
                    ...List.generate(7, (index) {
                      return Expanded(
                        child: Center(
                          child: Text(
                            _weekdays[index],
                            style: AppTypography.labelSmall.copyWith(
                              color: AppColors.textSecondaryDark,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      );
                    }),
                  ],
                ),
                const Gap(AppSpacing.sm),

                // Meal rows
                ...List.generate(3, (mealIndex) {
                  final mealType = _mealTypes[mealIndex];
                  final icon = _mealIcons[mealType]!;

                  return Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                    child: Row(
                      children: [
                        // Meal type label
                        SizedBox(
                          width: 60,
                          child: Row(
                            children: [
                              Icon(icon, size: 14, color: AppColors.mealColor),
                              const Gap(4),
                              Text(
                                mealType[0].toUpperCase(),
                                style: AppTypography.labelSmall.copyWith(
                                  color: AppColors.textSecondaryDark,
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Day toggles
                        ...List.generate(7, (dayIndex) {
                          final weekday = dayIndex + 1;
                          final daySchedule = selectedSchedule.isNotEmpty
                              ? selectedSchedule[dayIndex]
                              : null;

                          bool isEnabled = false;
                          if (daySchedule != null) {
                            switch (mealType) {
                              case 'breakfast':
                                isEnabled = daySchedule.breakfast;
                                break;
                              case 'lunch':
                                isEnabled = daySchedule.lunch;
                                break;
                              case 'dinner':
                                isEnabled = daySchedule.dinner;
                                break;
                            }
                          }

                          return Expanded(
                            child: Center(
                              child: GestureDetector(
                                onTap: () {
                                  if (_selectedMemberId != null) {
                                    ref
                                        .read(mealScheduleProvider.notifier)
                                        .toggleMeal(
                                          _selectedMemberId!,
                                          weekday,
                                          mealType,
                                        );
                                  }
                                },
                                child: Container(
                                  width: 32,
                                  height: 32,
                                  decoration: BoxDecoration(
                                    color: isEnabled
                                        ? AppColors.mealColor
                                        : AppColors.cardDark,
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: isEnabled
                                          ? AppColors.mealColor
                                          : AppColors.borderDark,
                                    ),
                                  ),
                                  child: isEnabled
                                      ? const Icon(
                                          LucideIcons.check,
                                          size: 16,
                                          color: Colors.white,
                                        )
                                      : null,
                                ),
                              ),
                            ),
                          );
                        }),
                      ],
                    ),
                  );
                }),

                const Gap(AppSpacing.lg),
                const Divider(color: AppColors.borderDark),
                const Gap(AppSpacing.md),

                // Summary and Actions
                Container(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        LucideIcons.calculator,
                        color: AppColors.primary,
                        size: 20,
                      ),
                      const Gap(AppSpacing.sm),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Expected Weekly',
                              style: AppTypography.labelSmall.copyWith(
                                color: AppColors.textSecondaryDark,
                              ),
                            ),
                            Text(
                              '${expectedMeals[_selectedMemberId]?.toInt() ?? 0} meals/week',
                              style: AppTypography.titleMedium.copyWith(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                      OutlinedButton.icon(
                        onPressed: () {
                          if (_selectedMemberId != null) {
                            _showApplyToAllDialog();
                          }
                        },
                        icon: const Icon(LucideIcons.copy, size: 14),
                        label: const Text('Apply to all'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.primary,
                          side: const BorderSide(color: AppColors.primary),
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.sm,
                            vertical: AppSpacing.xs,
                          ),
                          textStyle: AppTypography.labelSmall,
                        ),
                      ),
                    ],
                  ),
                ),

                const Gap(AppSpacing.lg),

                // Info card
                Container(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    color: AppColors.info.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                    border: Border.all(
                      color: AppColors.info.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        LucideIcons.info,
                        size: 16,
                        color: AppColors.info,
                      ),
                      const Gap(AppSpacing.sm),
                      Expanded(
                        child: Text(
                          'This is the default schedule. Tap "Add Meal" to record actual meals which may differ.',
                          style: AppTypography.bodySmall.copyWith(
                            color: AppColors.info,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _showApplyToAllDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surfaceDark,
        title: const Text('Apply to all members?'),
        content: Text(
          'This will copy the current schedule to all other members.',
          style: AppTypography.bodyMedium.copyWith(
            color: AppColors.textSecondaryDark,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              ref
                  .read(mealScheduleProvider.notifier)
                  .applyToAll(_selectedMemberId!);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Schedule applied to all members'),
                ),
              );
            },
            child: const Text('Apply'),
          ),
        ],
      ),
    );
  }
}
