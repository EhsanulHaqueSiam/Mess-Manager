import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:gap/gap.dart';

import 'package:mess_manager/core/theme/app_theme.dart';
import 'package:mess_manager/core/models/meal.dart';
import 'package:mess_manager/core/services/haptic_service.dart';
import 'package:mess_manager/features/meals/providers/meals_provider.dart';

// Time-lock deadlines for meal editing
const int kBreakfastDeadlineHour = 8; // 8:00 AM
const int kLunchDeadlineHour = 12; // 12:00 PM
const int kDinnerDeadlineHour = 19; // 7:00 PM

/// Streamlined meal entry sheet.
///
/// Large preset buttons as the primary UI. Supports 2-meal and 3-meal systems.
/// Tap a preset, tap submit. Two taps to log meals.
class AddMealSheet extends ConsumerStatefulWidget {
  /// Existing meal for edit mode (null for add mode)
  final Meal? existingMeal;

  const AddMealSheet({super.key, this.existingMeal});

  @override
  ConsumerState<AddMealSheet> createState() => _AddMealSheetState();
}

class _AddMealSheetState extends ConsumerState<AddMealSheet>
    with SingleTickerProviderStateMixin {
  late DateTime _selectedDate;
  int _totalMeals = 2;
  bool _is3MealSystem = false;

  bool get _isEditMode => widget.existingMeal != null;
  int get _standardMeals => _is3MealSystem ? 3 : 2;

  int get _guestMeals =>
      _totalMeals > _standardMeals ? _totalMeals - _standardMeals : 0;

  // Submit button pulse animation
  late AnimationController _pulseCtrl;
  late Animation<double> _pulseAnim;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.existingMeal?.date ?? DateTime.now();
    if (widget.existingMeal != null) {
      _totalMeals = widget.existingMeal!.count + widget.existingMeal!.guestCount;
    }

    _pulseCtrl = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _pulseAnim = Tween(begin: 1.0, end: 1.04).animate(
      CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseCtrl.dispose();
    super.dispose();
  }

  void _selectPreset(int count) {
    HapticService.selectionTick();
    setState(() => _totalMeals = count);
    // Pulse the submit button to encourage tapping it
    _pulseCtrl.forward().then((_) => _pulseCtrl.reverse());
  }

  String? get _timeLockWarning {
    final now = DateTime.now();
    if (_selectedDate.year != now.year ||
        _selectedDate.month != now.month ||
        _selectedDate.day != now.day) {
      return null;
    }

    if (now.hour >= kDinnerDeadlineHour) {
      return 'All meals locked for today (past 7 PM)';
    } else if (now.hour >= kLunchDeadlineHour) {
      return 'Breakfast & Lunch locked (past 12 PM)';
    } else if (now.hour >= kBreakfastDeadlineHour) {
      return 'Breakfast locked (past 8 AM)';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    return Container(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.md,
        AppSpacing.lg,
        AppSpacing.lg + bottomInset,
      ),
      decoration: BoxDecoration(
        color: context.surfaceColor,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(AppSpacing.radiusXl),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: context.borderColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const Gap(AppSpacing.md),

          // Time-lock warning (compact, single line)
          if (_timeLockWarning != null)
            Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.sm),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    LucideIcons.clock,
                    color: AppColors.warning,
                    size: 12,
                  ),
                  const Gap(AppSpacing.xs),
                  Text(
                    _timeLockWarning!,
                    style: AppTypography.labelSmall.copyWith(
                      color: AppColors.warning,
                    ),
                  ),
                ],
              ).animate().fadeIn(),
            ),

          // Header row: title + 3-meal chip + date chip
          _buildHeader(),
          const Gap(AppSpacing.lg),

          // Preset buttons - the centerpiece
          _buildPresetButtons(),
          const Gap(AppSpacing.lg),

          // Guest indicator (only when above standard)
          if (_guestMeals > 0)
            Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.md),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(LucideIcons.users, size: 13, color: AppColors.success),
                  const Gap(AppSpacing.xs),
                  Text(
                    '+$_guestMeals guest meal${_guestMeals > 1 ? 's' : ''}',
                    style: AppTypography.labelSmall.copyWith(
                      color: AppColors.success,
                    ),
                  ),
                ],
              ).animate().fadeIn(),
            ),

          // Submit button
          _buildSubmitButton(),
          const Gap(AppSpacing.sm),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Icon(LucideIcons.utensils, color: AppColors.mealColor, size: 20),
        const Gap(AppSpacing.sm),
        Text(
          _isEditMode ? 'Edit meal' : 'Add meal',
          style: AppTypography.headlineMedium.copyWith(
            color: context.textPrimary,
          ),
        ),
        const Spacer(),
        // 3-meal system toggle chip
        GestureDetector(
          onTap: () {
            HapticService.lightTap();
            setState(() => _is3MealSystem = !_is3MealSystem);
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: AppColors.mealColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppSpacing.radiusXs),
              border: Border.all(
                color: AppColors.mealColor.withValues(alpha: 0.25),
              ),
            ),
            child: Text(
              _is3MealSystem ? '3-meal' : '2-meal',
              style: AppTypography.labelSmall.copyWith(
                color: AppColors.mealColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        const Gap(AppSpacing.sm),
        // Date chip
        _buildDateChip(),
      ],
    ).animate().fadeIn();
  }

  Widget _buildDateChip() {
    return GestureDetector(
      onTap: _selectDate,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        decoration: BoxDecoration(
          color: context.cardColor,
          borderRadius: BorderRadius.circular(AppSpacing.radiusXs),
          border: Border.all(color: context.borderColor),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(LucideIcons.calendar, size: 11, color: context.textSecondary),
            const Gap(4),
            Text(
              _formatDate(_selectedDate),
              style: AppTypography.labelSmall.copyWith(
                color: context.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPresetButtons() {
    const presets = [0, 1, 2, 3, 5, 10];

    return Row(
      children: presets.map((count) {
        final isSelected = _totalMeals == count;
        final isDefault = count == _standardMeals;
        final label = count == 0 ? 'Off' : '$count';

        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(
              right: count == presets.last ? 0 : AppSpacing.sm,
            ),
            child: GestureDetector(
              onTap: () => _selectPreset(count),
              child: AnimatedContainer(
                duration: 200.ms,
                height: 72,
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.mealColor
                      : context.cardColor,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                  border: Border.all(
                    color: isSelected
                        ? AppColors.mealColor
                        : isDefault
                            ? AppColors.mealColor.withValues(alpha: 0.6)
                            : context.borderColor,
                    width: isDefault && !isSelected ? 1.5 : 1,
                  ),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: AppColors.mealColor.withValues(alpha: 0.35),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ]
                      : null,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      label,
                      style: (count == 0
                              ? AppTypography.titleMedium
                              : AppTypography.displaySmall)
                          .copyWith(
                        color: isSelected
                            ? Colors.white
                            : isDefault
                                ? AppColors.mealColor
                                : context.textPrimary,
                        fontWeight:
                            isSelected || isDefault ? FontWeight.w700 : FontWeight.w500,
                      ),
                    ),
                    if (isDefault && !isSelected)
                      Text(
                        'default',
                        style: AppTypography.labelSmall.copyWith(
                          color: AppColors.mealColor.withValues(alpha: 0.7),
                          fontSize: 8,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        );
      }).toList(),
    ).animate().fadeIn(delay: 100.ms).slideY(begin: 0.1, end: 0);
  }

  Widget _buildSubmitButton() {
    final text = _getSubmitText();

    return ScaleTransition(
      scale: _pulseAnim,
      child: SizedBox(
        width: double.infinity,
        child: FilledButton(
          onPressed: _submit,
          style: FilledButton.styleFrom(
            backgroundColor: AppColors.mealColor,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            ),
            textStyle: AppTypography.labelLarge,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                _totalMeals == 0
                    ? LucideIcons.moonStar
                    : LucideIcons.check,
                size: 18,
              ),
              const Gap(8),
              Text(text),
            ],
          ),
        ),
      ),
    ).animate().fadeIn(delay: 200.ms);
  }

  String _getSubmitText() {
    if (_totalMeals == 0) return 'Skip today';
    if (_isEditMode) {
      return 'Save $_totalMeals meal${_totalMeals > 1 ? 's' : ''}';
    }
    return 'Add $_totalMeals meal${_totalMeals > 1 ? 's' : ''}';
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final dateOnly = DateTime(date.year, date.month, date.day);

    if (dateOnly == today) return 'Today';
    if (dateOnly == today.add(const Duration(days: 1))) return 'Tomorrow';
    if (dateOnly == today.subtract(const Duration(days: 1))) return 'Yesterday';

    return '${date.day}/${date.month}/${date.year}';
  }

  Future<void> _selectDate() async {
    HapticService.lightTap();
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now().subtract(const Duration(days: 7)),
      lastDate: DateTime.now().add(const Duration(days: 7)),
      builder: (pickerContext, child) => Theme(
        data: Theme.of(pickerContext).copyWith(
          colorScheme: ColorScheme.dark(
            primary: AppColors.mealColor,
            surface: pickerContext.surfaceColor,
          ),
        ),
        child: child!,
      ),
    );
    if (picked != null) setState(() => _selectedDate = picked);
  }

  void _submit() {
    if (_totalMeals == 0) {
      Navigator.of(context).pop();
      return;
    }

    HapticService.success();

    final ownMeals = _totalMeals > _standardMeals ? _standardMeals : _totalMeals;

    if (_isEditMode) {
      final updatedMeal = widget.existingMeal!.copyWith(
        date: _selectedDate,
        count: ownMeals,
        guestCount: _guestMeals,
      );
      ref.read(mealsProvider.notifier).updateMeal(updatedMeal);
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
              Text('Meal updated: $_totalMeals meal${_totalMeals > 1 ? 's' : ''}'),
          backgroundColor: AppColors.info,
        ),
      );
    } else {
      final meal = Meal(
        id: 'meal_${DateTime.now().millisecondsSinceEpoch}',
        memberId: 'current_user',
        date: _selectedDate,
        count: ownMeals,
        type: MealType.lunch,
        guestCount: _guestMeals,
        createdAt: DateTime.now(),
      );

      ref.read(mealsProvider.notifier).addMeal(meal);
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Added $_totalMeals meal${_totalMeals > 1 ? 's' : ''} for today'),
          backgroundColor: AppColors.success,
        ),
      );
    }
  }
}
