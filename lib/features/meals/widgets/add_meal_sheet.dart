import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:gap/gap.dart';

import 'package:mess_manager/core/theme/app_theme.dart';
import 'package:mess_manager/core/models/meal.dart';
import 'package:mess_manager/core/services/haptic_service.dart';
import 'package:mess_manager/features/meals/providers/meals_provider.dart';

/// Add Meal Sheet - 2-Meal System
///
/// Default: 2 meals/day (Lunch + Dinner)
/// Quick buttons: 0 (Off) | 1 | 2 (Default) | 3+ (Guest)
/// Users can only add their own meals
class AddMealSheet extends ConsumerStatefulWidget {
  const AddMealSheet({super.key});

  @override
  ConsumerState<AddMealSheet> createState() => _AddMealSheetState();
}

class _AddMealSheetState extends ConsumerState<AddMealSheet> {
  DateTime _selectedDate = DateTime.now();
  int _totalMeals = 2; // Default: 2 meals (standard day)
  int _guestMeals = 0; // Extra meals for guests

  // Quick count options
  static const _quickOptions = [0, 1, 2, 3, 4, 5];

  @override
  Widget build(BuildContext context) {
    // Guest meals = anything above 2
    _guestMeals = _totalMeals > 2 ? _totalMeals - 2 : 0;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.75,
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
                Icon(
                  LucideIcons.utensils,
                  color: AppColors.mealColor,
                  size: 24,
                ),
                const Gap(AppSpacing.sm),
                Text(
                  'Add Meal',
                  style: AppTypography.headlineMedium.copyWith(
                    color: AppColors.textPrimaryDark,
                  ),
                ),
              ],
            ).animate().fadeIn(),
            const Gap(AppSpacing.sm),

            // Subtitle explaining the system
            Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: AppColors.info.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
              ),
              child: Row(
                children: [
                  const Icon(LucideIcons.info, color: AppColors.info, size: 16),
                  const Gap(AppSpacing.sm),
                  Expanded(
                    child: Text(
                      'Standard: 2 meals (Lunch + Dinner). Above 2 = Guests.',
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.textSecondaryDark,
                      ),
                    ),
                  ),
                ],
              ),
            ).animate().fadeIn(delay: 100.ms),
            const Gap(AppSpacing.xl),

            // Quick Meal Count Buttons
            Text(
              'Total meals today',
              style: AppTypography.labelMedium.copyWith(
                color: AppColors.textSecondaryDark,
              ),
            ),
            const Gap(AppSpacing.md),
            Row(
              children: _quickOptions.map((count) {
                final isSelected = _totalMeals == count;
                final isDefault = count == 2;
                final hasGuests = count > 2;

                Color bgColor;
                Color textColor;

                if (isSelected) {
                  bgColor = AppColors.mealColor;
                  textColor = Colors.white;
                } else {
                  bgColor = AppColors.cardDark;
                  textColor = AppColors.textPrimaryDark;
                }

                return Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(
                      right: count < _quickOptions.last ? AppSpacing.sm : 0,
                    ),
                    child: GestureDetector(
                      onTap: () {
                        HapticService.lightTap();
                        setState(() => _totalMeals = count);
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(
                          vertical: AppSpacing.md,
                        ),
                        decoration: BoxDecoration(
                          color: bgColor,
                          borderRadius: BorderRadius.circular(
                            AppSpacing.radiusMd,
                          ),
                          border: isDefault && !isSelected
                              ? Border.all(
                                  color: AppColors.mealColor.withValues(
                                    alpha: 0.5,
                                  ),
                                )
                              : null,
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              count.toString(),
                              style: AppTypography.titleLarge.copyWith(
                                color: textColor,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            if (count == 0)
                              Text(
                                'Off',
                                style: AppTypography.labelSmall.copyWith(
                                  color: textColor.withValues(alpha: 0.7),
                                ),
                              ),
                            if (isDefault && !isSelected)
                              Text(
                                'Default',
                                style: AppTypography.labelSmall.copyWith(
                                  color: AppColors.mealColor,
                                ),
                              ),
                            if (hasGuests && isSelected)
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    LucideIcons.users,
                                    size: 10,
                                    color: textColor,
                                  ),
                                  const Gap(2),
                                  Text(
                                    '+${count - 2}',
                                    style: AppTypography.labelSmall.copyWith(
                                      color: textColor,
                                    ),
                                  ),
                                ],
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.1),
            const Gap(AppSpacing.lg),

            // Summary Card
            Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: AppColors.cardDark,
                borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                border: Border.all(
                  color: AppColors.borderDark.withValues(alpha: 0.5),
                ),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Your meals',
                        style: AppTypography.bodyMedium.copyWith(
                          color: AppColors.textSecondaryDark,
                        ),
                      ),
                      Text(
                        _totalMeals > 2 ? '2' : '$_totalMeals',
                        style: AppTypography.titleMedium.copyWith(
                          color: AppColors.textPrimaryDark,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  if (_guestMeals > 0) ...[
                    const Gap(AppSpacing.sm),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              LucideIcons.users,
                              size: 14,
                              color: AppColors.success,
                            ),
                            const Gap(AppSpacing.xs),
                            Text(
                              'Guest meals',
                              style: AppTypography.bodyMedium.copyWith(
                                color: AppColors.success,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          '$_guestMeals',
                          style: AppTypography.titleMedium.copyWith(
                            color: AppColors.success,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                  const Divider(height: AppSpacing.lg),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total',
                        style: AppTypography.titleSmall.copyWith(
                          color: AppColors.textPrimaryDark,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        '$_totalMeals meals',
                        style: AppTypography.titleMedium.copyWith(
                          color: AppColors.mealColor,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ).animate().fadeIn(delay: 300.ms),
            const Gap(AppSpacing.lg),

            // Date Selector
            Text(
              'Date',
              style: AppTypography.labelMedium.copyWith(
                color: AppColors.textSecondaryDark,
              ),
            ),
            const Gap(AppSpacing.sm),
            GestureDetector(
              onTap: _selectDate,
              child: Container(
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: AppColors.cardDark,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                ),
                child: Row(
                  children: [
                    const Icon(
                      LucideIcons.calendar,
                      color: AppColors.primary,
                      size: 20,
                    ),
                    const Gap(AppSpacing.sm),
                    Text(
                      _formatDate(_selectedDate),
                      style: AppTypography.bodyMedium.copyWith(
                        color: AppColors.textPrimaryDark,
                      ),
                    ),
                    const Spacer(),
                    const Icon(
                      LucideIcons.chevronRight,
                      color: AppColors.textMutedDark,
                      size: 18,
                    ),
                  ],
                ),
              ),
            ).animate().fadeIn(delay: 400.ms),
            const Gap(AppSpacing.xl),

            // Submit Button
            SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _totalMeals > 0 ? _submit : null,
                    icon: Icon(
                      _totalMeals == 0 ? LucideIcons.x : LucideIcons.check,
                      size: 20,
                    ),
                    label: Text(_getSubmitText()),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        vertical: AppSpacing.md,
                      ),
                      backgroundColor: _totalMeals == 0
                          ? AppColors.warning
                          : null,
                    ),
                  ),
                )
                .animate()
                .fadeIn(delay: 500.ms)
                .scale(begin: const Offset(0.95, 0.95)),
            const Gap(AppSpacing.md),
          ],
        ),
      ),
    );
  }

  String _getSubmitText() {
    if (_totalMeals == 0) return 'Skip Today';
    if (_guestMeals > 0) return 'Add $_totalMeals Meals (+$_guestMeals Guest)';
    return 'Add $_totalMeals Meal${_totalMeals > 1 ? 's' : ''}';
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(const Duration(days: 1));
    final yesterday = today.subtract(const Duration(days: 1));
    final dateOnly = DateTime(date.year, date.month, date.day);

    if (dateOnly == today) return 'Today';
    if (dateOnly == tomorrow) return 'Tomorrow';
    if (dateOnly == yesterday) return 'Yesterday';

    return '${date.day}/${date.month}/${date.year}';
  }

  Future<void> _selectDate() async {
    HapticService.lightTap();
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now().subtract(const Duration(days: 7)),
      lastDate: DateTime.now().add(const Duration(days: 7)),
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
      setState(() => _selectedDate = picked);
    }
  }

  void _submit() {
    if (_totalMeals == 0) {
      // Skip today - could mark as cancelled
      Navigator.of(context).pop();
      return;
    }

    HapticService.success();

    // Create meal entry for current user only
    // The meal count represents total (own + guest)
    final ownMeals = _totalMeals > 2 ? 2 : _totalMeals;

    final meal = Meal(
      id: 'meal_${DateTime.now().millisecondsSinceEpoch}',
      memberId: 'current_user', // Will be replaced with actual auth user ID
      date: _selectedDate,
      count: ownMeals,
      type: MealType.lunch, // Combined as daily total
      guestCount: _guestMeals,
      createdAt: DateTime.now(),
    );

    ref.read(mealsProvider.notifier).addMeal(meal);
    Navigator.of(context).pop();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Added $_totalMeals meal${_totalMeals > 1 ? 's' : ''} for today',
        ),
        backgroundColor: AppColors.success,
      ),
    );
  }
}
