import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:gap/gap.dart';
import 'package:mess_manager/core/theme/app_theme.dart';
import 'package:mess_manager/core/models/meal.dart';
import 'package:mess_manager/core/providers/members_provider.dart';
import 'package:mess_manager/features/meals/providers/meals_provider.dart';

/// Bulk Meal Entry Sheet
/// Add meals for multiple days (2-3 days or a week) at once
class BulkMealSheet extends ConsumerStatefulWidget {
  const BulkMealSheet({super.key});

  @override
  ConsumerState<BulkMealSheet> createState() => _BulkMealSheetState();
}

class _BulkMealSheetState extends ConsumerState<BulkMealSheet> {
  String? _selectedMemberId;
  DateTime _startDate = DateTime.now();
  int _numberOfDays = 3; // Default to 3 days

  final Set<MealType> _selectedMealTypes = {MealType.lunch, MealType.dinner};

  int get _totalMeals => _numberOfDays * _selectedMealTypes.length;

  @override
  void initState() {
    super.initState();
    _selectedMemberId = ref.read(currentMemberIdProvider);
  }

  @override
  Widget build(BuildContext context) {
    final members = ref.watch(membersProvider);

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.85,
      ),
      decoration: BoxDecoration(
        color: AppColors.surfaceDark,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(AppSpacing.radiusLg),
        ),
      ),
      child: SingleChildScrollView(
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
                Container(
                  padding: const EdgeInsets.all(AppSpacing.sm),
                  decoration: BoxDecoration(
                    color: AppColors.mealColor.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                  ),
                  child: const Icon(
                    LucideIcons.calendarDays,
                    color: AppColors.mealColor,
                    size: 24,
                  ),
                ),
                const Gap(AppSpacing.md),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Bulk Meal Entry',
                      style: AppTypography.headlineMedium.copyWith(
                        color: AppColors.textPrimaryDark,
                      ),
                    ),
                    Text(
                      'Add meals for multiple days at once',
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.textMutedDark,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const Gap(AppSpacing.xl),

            // Member Selector
            Text(
              'Who ate?',
              style: AppTypography.labelMedium.copyWith(
                color: AppColors.textSecondaryDark,
              ),
            ),
            const Gap(AppSpacing.sm),
            Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.sm,
              children: members.map((member) {
                final isSelected = _selectedMemberId == member.id;
                return FilterChip(
                  selected: isSelected,
                  label: Text(member.name),
                  onSelected: (_) =>
                      setState(() => _selectedMemberId = member.id),
                  selectedColor: AppColors.mealColor.withValues(alpha: 0.2),
                  checkmarkColor: AppColors.mealColor,
                );
              }).toList(),
            ),
            const Gap(AppSpacing.lg),

            // Start Date
            Text(
              'Starting from',
              style: AppTypography.labelMedium.copyWith(
                color: AppColors.textSecondaryDark,
              ),
            ),
            const Gap(AppSpacing.sm),
            Material(
              color: AppColors.cardDark,
              borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
              child: InkWell(
                onTap: _selectStartDate,
                borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  child: Row(
                    children: [
                      const Icon(
                        LucideIcons.calendar,
                        color: AppColors.mealColor,
                        size: 20,
                      ),
                      const Gap(AppSpacing.sm),
                      Text(
                        _formatDate(_startDate),
                        style: AppTypography.bodyMedium.copyWith(
                          color: AppColors.textPrimaryDark,
                        ),
                      ),
                      const Spacer(),
                      const Icon(
                        LucideIcons.chevronRight,
                        color: AppColors.textMutedDark,
                        size: 20,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const Gap(AppSpacing.lg),

            // Number of Days
            Text(
              'Number of days',
              style: AppTypography.labelMedium.copyWith(
                color: AppColors.textSecondaryDark,
              ),
            ),
            const Gap(AppSpacing.sm),
            Row(
              children: [
                _buildDayOption(2, '2 Days'),
                const Gap(AppSpacing.sm),
                _buildDayOption(3, '3 Days'),
                const Gap(AppSpacing.sm),
                _buildDayOption(5, '5 Days'),
                const Gap(AppSpacing.sm),
                _buildDayOption(7, '1 Week'),
              ],
            ),
            const Gap(AppSpacing.lg),

            // Meal Types
            Text(
              'Meal types',
              style: AppTypography.labelMedium.copyWith(
                color: AppColors.textSecondaryDark,
              ),
            ),
            const Gap(AppSpacing.sm),
            Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.sm,
              children: [
                _buildMealTypeChip(
                  MealType.breakfast,
                  'Breakfast',
                  LucideIcons.sunrise,
                ),
                _buildMealTypeChip(MealType.lunch, 'Lunch', LucideIcons.sun),
                _buildMealTypeChip(MealType.dinner, 'Dinner', LucideIcons.moon),
              ],
            ),
            const Gap(AppSpacing.lg),

            // Preview Card
            Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.mealColor.withValues(alpha: 0.15),
                    AppColors.mealColor.withValues(alpha: 0.05),
                  ],
                ),
                borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                border: Border.all(
                  color: AppColors.mealColor.withValues(alpha: 0.3),
                ),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Preview',
                        style: AppTypography.labelMedium.copyWith(
                          color: AppColors.textSecondaryDark,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.mealColor.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '$_totalMeals meals',
                          style: AppTypography.labelSmall.copyWith(
                            color: AppColors.mealColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Gap(AppSpacing.md),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildPreviewStat('Days', '$_numberOfDays'),
                      _buildPreviewStat(
                        'Types',
                        '${_selectedMealTypes.length}',
                      ),
                      _buildPreviewStat('Total', '$_totalMeals'),
                    ],
                  ),
                  const Gap(AppSpacing.md),
                  Text(
                    '${_formatDateShort(_startDate)} → ${_formatDateShort(_startDate.add(Duration(days: _numberOfDays - 1)))}',
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.textMutedDark,
                    ),
                  ),
                ],
              ),
            ),
            const Gap(AppSpacing.xl),

            // Submit Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _selectedMealTypes.isNotEmpty ? _submit : null,
                icon: const Icon(LucideIcons.check, size: 20),
                label: Text('Add $_totalMeals Meals'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.mealColor,
                  padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                ),
              ),
            ),
            const Gap(AppSpacing.md),
          ],
        ),
      ),
    );
  }

  Widget _buildDayOption(int days, String label) {
    final isSelected = _numberOfDays == days;
    return Expanded(
      child: Material(
        color: isSelected ? AppColors.mealColor : AppColors.cardDark,
        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
        child: InkWell(
          onTap: () => setState(() => _numberOfDays = days),
          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
            child: Center(
              child: Text(
                label,
                style: AppTypography.labelMedium.copyWith(
                  color: isSelected ? Colors.white : AppColors.textPrimaryDark,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMealTypeChip(MealType type, String label, IconData icon) {
    final isSelected = _selectedMealTypes.contains(type);
    return FilterChip(
      selected: isSelected,
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 14,
            color: isSelected ? AppColors.mealColor : AppColors.textMutedDark,
          ),
          const Gap(4),
          Text(label),
        ],
      ),
      onSelected: (s) {
        setState(() {
          if (s) {
            _selectedMealTypes.add(type);
          } else if (_selectedMealTypes.length > 1) {
            // Ensure at least one is selected
            _selectedMealTypes.remove(type);
          }
        });
      },
      selectedColor: AppColors.mealColor.withValues(alpha: 0.2),
      checkmarkColor: AppColors.mealColor,
    );
  }

  Widget _buildPreviewStat(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: AppTypography.titleLarge.copyWith(
            color: AppColors.mealColor,
            fontWeight: FontWeight.w700,
          ),
        ),
        Text(
          label,
          style: AppTypography.labelSmall.copyWith(
            color: AppColors.textMutedDark,
          ),
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(const Duration(days: 1));
    final dateOnly = DateTime(date.year, date.month, date.day);

    if (dateOnly == today) return 'Today';
    if (dateOnly == tomorrow) return 'Tomorrow';
    return '${date.day}/${date.month}/${date.year}';
  }

  String _formatDateShort(DateTime date) {
    return '${date.day}/${date.month}';
  }

  Future<void> _selectStartDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _startDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 30)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: AppColors.mealColor,
              surface: AppColors.surfaceDark,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() => _startDate = picked);
    }
  }

  void _submit() {
    if (_selectedMemberId == null || _selectedMealTypes.isEmpty) return;

    final mealsNotifier = ref.read(mealsProvider.notifier);
    int addedCount = 0;

    // Add meals for each day and each selected meal type
    for (int day = 0; day < _numberOfDays; day++) {
      final date = _startDate.add(Duration(days: day));

      for (final mealType in _selectedMealTypes) {
        final meal = Meal(
          id: 'meal_${DateTime.now().millisecondsSinceEpoch}_$addedCount',
          memberId: _selectedMemberId!,
          date: date,
          count: 1,
          type: mealType,
          createdAt: DateTime.now(),
        );
        mealsNotifier.addMeal(meal);
        addedCount++;
      }
    }

    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Added $addedCount meals!'),
        backgroundColor: AppColors.mealColor,
      ),
    );
  }
}
