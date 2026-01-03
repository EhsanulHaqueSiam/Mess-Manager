import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:gap/gap.dart';

import 'package:mess_manager/core/theme/app_theme.dart';
import 'package:mess_manager/core/models/meal.dart';
import 'package:mess_manager/core/services/haptic_service.dart';
import 'package:mess_manager/features/meals/providers/meals_provider.dart';

/// Add Meal Sheet - Flexible Meal System
///
/// Supports both 2-meal (Lunch+Dinner) and 3-meal (Breakfast+Lunch+Dinner) systems
/// Quick mode: Total count with auto guest detection
/// Detailed mode: Per-meal breakdown
class AddMealSheet extends ConsumerStatefulWidget {
  const AddMealSheet({super.key});

  @override
  ConsumerState<AddMealSheet> createState() => _AddMealSheetState();
}

class _AddMealSheetState extends ConsumerState<AddMealSheet> {
  DateTime _selectedDate = DateTime.now();
  bool _isDetailedMode = false;

  // Quick mode - total count
  int _totalMeals = 2;

  // Detailed mode - per meal
  int _lunchCount = 1;
  int _dinnerCount = 1;
  int _breakfastCount = 0; // For 3-meal system

  // Settings
  bool _is3MealSystem = false; // Toggle between 2 and 3 meal systems

  int get _standardMeals => _is3MealSystem ? 3 : 2;

  int get _totalFromDetailedMode {
    return _breakfastCount + _lunchCount + _dinnerCount;
  }

  int get _guestMeals {
    final total = _isDetailedMode ? _totalFromDetailedMode : _totalMeals;
    return total > _standardMeals ? total - _standardMeals : 0;
  }

  @override
  Widget build(BuildContext context) {
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

            // Title and mode toggle
            Row(
              children: [
                Icon(
                  LucideIcons.utensils,
                  color: AppColors.mealColor,
                  size: 24,
                ),
                const Gap(AppSpacing.sm),
                Expanded(
                  child: Text(
                    'Add Meal',
                    style: AppTypography.headlineMedium.copyWith(
                      color: AppColors.textPrimaryDark,
                    ),
                  ),
                ),
                // Mode toggle
                _buildModeToggle(),
              ],
            ).animate().fadeIn(),
            const Gap(AppSpacing.md),

            // System info
            Container(
              padding: const EdgeInsets.all(AppSpacing.sm),
              decoration: BoxDecoration(
                color: AppColors.info.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
              ),
              child: Row(
                children: [
                  const Icon(LucideIcons.info, color: AppColors.info, size: 14),
                  const Gap(AppSpacing.sm),
                  Expanded(
                    child: Text(
                      _is3MealSystem
                          ? 'Standard: 3 meals (B+L+D). Above 3 = Guests.'
                          : 'Standard: 2 meals (L+D). Above 2 = Guests.',
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.textSecondaryDark,
                      ),
                    ),
                  ),
                  // Toggle meal system
                  GestureDetector(
                    onTap: () {
                      HapticService.lightTap();
                      setState(() => _is3MealSystem = !_is3MealSystem);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.cardDark,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        _is3MealSystem ? '3-Meal' : '2-Meal',
                        style: AppTypography.labelSmall.copyWith(
                          color: AppColors.mealColor,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ).animate().fadeIn(delay: 100.ms),
            const Gap(AppSpacing.lg),

            // Mode specific input
            if (_isDetailedMode)
              _buildDetailedModeInput()
            else
              _buildQuickModeInput(),

            const Gap(AppSpacing.lg),

            // Summary Card
            _buildSummaryCard(),
            const Gap(AppSpacing.lg),

            // Date Selector
            _buildDateSelector(),
            const Gap(AppSpacing.xl),

            // Submit Button
            SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _submit,
                    icon: const Icon(LucideIcons.check, size: 20),
                    label: Text(_getSubmitText()),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        vertical: AppSpacing.md,
                      ),
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

  Widget _buildModeToggle() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardDark,
        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildModeButton('Quick', !_isDetailedMode, () {
            setState(() => _isDetailedMode = false);
          }),
          _buildModeButton('Detailed', _isDetailedMode, () {
            setState(() => _isDetailedMode = true);
          }),
        ],
      ),
    );
  }

  Widget _buildModeButton(String label, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: () {
        HapticService.lightTap();
        onTap();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.mealColor : Colors.transparent,
          borderRadius: BorderRadius.circular(AppSpacing.radiusSm - 2),
        ),
        child: Text(
          label,
          style: AppTypography.labelSmall.copyWith(
            color: isSelected ? Colors.white : AppColors.textSecondaryDark,
          ),
        ),
      ),
    );
  }

  /// Quick mode - single number input with +/- buttons
  Widget _buildQuickModeInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Total meals today',
          style: AppTypography.labelMedium.copyWith(
            color: AppColors.textSecondaryDark,
          ),
        ),
        const Gap(AppSpacing.md),

        // Counter with +/- buttons
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Decrease
            _buildCountButton(LucideIcons.minus, () {
              if (_totalMeals > 0) setState(() => _totalMeals--);
            }),
            const Gap(AppSpacing.lg),

            // Count display
            GestureDetector(
              onTap: _showCustomNumberPicker,
              child: Container(
                width: 100,
                height: 80,
                decoration: BoxDecoration(
                  color: AppColors.cardDark,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                  border: Border.all(
                    color: AppColors.mealColor.withValues(alpha: 0.5),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '$_totalMeals',
                      style: AppTypography.displayMedium.copyWith(
                        color: AppColors.mealColor,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      'tap to edit',
                      style: AppTypography.labelSmall.copyWith(
                        color: AppColors.textMutedDark,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const Gap(AppSpacing.lg),

            // Increase
            _buildCountButton(LucideIcons.plus, () {
              setState(() => _totalMeals++);
            }),
          ],
        ).animate().fadeIn(delay: 200.ms),

        // Quick presets
        const Gap(AppSpacing.md),
        Center(
          child: Wrap(
            spacing: AppSpacing.sm,
            children: [0, 1, 2, 3, 5, 10].map((count) {
              final isSelected = _totalMeals == count;
              final isDefault = count == _standardMeals;

              return GestureDetector(
                onTap: () {
                  HapticService.lightTap();
                  setState(() => _totalMeals = count);
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.mealColor
                        : AppColors.cardDark,
                    borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                    border: isDefault && !isSelected
                        ? Border.all(color: AppColors.mealColor)
                        : null,
                  ),
                  child: Text(
                    count == 0 ? 'Off' : '$count',
                    style: TextStyle(
                      color: isSelected
                          ? Colors.white
                          : AppColors.textPrimaryDark,
                      fontWeight: isDefault
                          ? FontWeight.w600
                          : FontWeight.normal,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildCountButton(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: () {
        HapticService.lightTap();
        onTap();
      },
      child: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          color: AppColors.cardDark,
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.borderDark),
        ),
        child: Icon(icon, color: AppColors.mealColor, size: 24),
      ),
    );
  }

  /// Detailed mode - per meal input
  Widget _buildDetailedModeInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Meals per type',
          style: AppTypography.labelMedium.copyWith(
            color: AppColors.textSecondaryDark,
          ),
        ),
        const Gap(AppSpacing.md),

        if (_is3MealSystem)
          _buildMealTypeRow(
            icon: LucideIcons.sunrise,
            label: 'Breakfast',
            count: _breakfastCount,
            onChanged: (v) => setState(() => _breakfastCount = v),
            color: AppColors.warning,
          ),

        _buildMealTypeRow(
          icon: LucideIcons.sun,
          label: 'Lunch',
          count: _lunchCount,
          onChanged: (v) => setState(() => _lunchCount = v),
          color: AppColors.mealColor,
        ),

        _buildMealTypeRow(
          icon: LucideIcons.moon,
          label: 'Dinner',
          count: _dinnerCount,
          onChanged: (v) => setState(() => _dinnerCount = v),
          color: AppColors.primary,
        ),
      ],
    ).animate().fadeIn(delay: 200.ms);
  }

  Widget _buildMealTypeRow({
    required IconData icon,
    required String label,
    required int count,
    required ValueChanged<int> onChanged,
    required Color color,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.cardDark,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 20),
          const Gap(AppSpacing.sm),
          Expanded(
            child: Text(
              label,
              style: AppTypography.titleSmall.copyWith(
                color: AppColors.textPrimaryDark,
              ),
            ),
          ),
          // Stepper
          Container(
            decoration: BoxDecoration(
              color: AppColors.surfaceDark,
              borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(LucideIcons.minus, size: 16),
                  onPressed: count > 0
                      ? () {
                          HapticService.lightTap();
                          onChanged(count - 1);
                        }
                      : null,
                  iconSize: 20,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(
                    minWidth: 36,
                    minHeight: 36,
                  ),
                ),
                Container(
                  width: 40,
                  alignment: Alignment.center,
                  child: Text(
                    '$count',
                    style: AppTypography.titleMedium.copyWith(
                      color: color,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(LucideIcons.plus, size: 16),
                  onPressed: () {
                    HapticService.lightTap();
                    onChanged(count + 1);
                  },
                  iconSize: 20,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(
                    minWidth: 36,
                    minHeight: 36,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard() {
    final total = _isDetailedMode ? _totalFromDetailedMode : _totalMeals;
    final ownMeals = total > _standardMeals ? _standardMeals : total;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.cardDark,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        border: Border.all(color: AppColors.borderDark.withValues(alpha: 0.5)),
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
                '$ownMeals',
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
                '$total meals',
                style: AppTypography.titleMedium.copyWith(
                  color: AppColors.mealColor,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ],
      ),
    ).animate().fadeIn(delay: 300.ms);
  }

  Widget _buildDateSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
        ),
      ],
    ).animate().fadeIn(delay: 400.ms);
  }

  void _showCustomNumberPicker() {
    HapticService.modalOpen();
    final controller = TextEditingController(text: '$_totalMeals');

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surfaceDark,
        title: const Text('Enter meal count'),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          autofocus: true,
          decoration: const InputDecoration(hintText: 'e.g. 15'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final value = int.tryParse(controller.text);
              if (value != null && value >= 0) {
                setState(() => _totalMeals = value);
              }
              Navigator.pop(ctx);
            },
            child: const Text('Set'),
          ),
        ],
      ),
    );
  }

  String _getSubmitText() {
    final total = _isDetailedMode ? _totalFromDetailedMode : _totalMeals;
    if (total == 0) return 'Skip Today';
    if (_guestMeals > 0) return 'Add $total Meals (+$_guestMeals Guest)';
    return 'Add $total Meal${total > 1 ? 's' : ''}';
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
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.dark(
            primary: AppColors.mealColor,
            surface: AppColors.surfaceDark,
          ),
        ),
        child: child!,
      ),
    );
    if (picked != null) setState(() => _selectedDate = picked);
  }

  void _submit() {
    final total = _isDetailedMode ? _totalFromDetailedMode : _totalMeals;
    if (total == 0) {
      Navigator.of(context).pop();
      return;
    }

    HapticService.success();

    final ownMeals = total > _standardMeals ? _standardMeals : total;

    final meal = Meal(
      id: 'meal_${DateTime.now().millisecondsSinceEpoch}',
      memberId: 'current_user', // Will use test user or auth user
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
        content: Text('Added $total meal${total > 1 ? 's' : ''} for today'),
        backgroundColor: AppColors.success,
      ),
    );
  }
}
