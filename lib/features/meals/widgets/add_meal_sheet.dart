import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:gap/gap.dart';
import 'package:mess_manager/core/theme/app_theme.dart';
import 'package:mess_manager/core/models/meal.dart';
import 'package:mess_manager/core/providers/members_provider.dart';
import 'package:mess_manager/features/meals/providers/meals_provider.dart';

class AddMealSheet extends ConsumerStatefulWidget {
  const AddMealSheet({super.key});

  @override
  ConsumerState<AddMealSheet> createState() => _AddMealSheetState();
}

class _AddMealSheetState extends ConsumerState<AddMealSheet> {
  String? _selectedMemberId;
  DateTime _selectedDate = DateTime.now();
  int _mealCount = 1;
  MealType _mealType = MealType.lunch;

  // Guest meal fields
  bool _hasGuests = false;
  int _guestCount = 1;
  final _guestNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _selectedMemberId = ref.read(currentMemberIdProvider);
  }

  @override
  void dispose() {
    _guestNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final members = ref.watch(membersProvider);

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.9,
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
            Text(
              'Add Meal',
              style: AppTypography.headlineMedium.copyWith(
                color: AppColors.textPrimaryDark,
              ),
            ),
            const Gap(AppSpacing.lg),

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
                  selectedColor: AppColors.primary.withValues(alpha: 0.2),
                  checkmarkColor: AppColors.primary,
                  labelStyle: TextStyle(
                    color: isSelected
                        ? AppColors.primary
                        : AppColors.textPrimaryDark,
                  ),
                );
              }).toList(),
            ),
            const Gap(AppSpacing.lg),

            // Meal Count
            Text(
              'How many meals?',
              style: AppTypography.labelMedium.copyWith(
                color: AppColors.textSecondaryDark,
              ),
            ),
            const Gap(AppSpacing.sm),
            Row(
              children: [1, 2, 3, 4].map((count) {
                final isSelected = _mealCount == count;
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: AppSpacing.sm),
                    child: Material(
                      color: isSelected
                          ? AppColors.primary
                          : AppColors.cardDark,
                      borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                      child: InkWell(
                        onTap: () => setState(() => _mealCount = count),
                        borderRadius: BorderRadius.circular(
                          AppSpacing.radiusSm,
                        ),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: AppSpacing.md,
                          ),
                          child: Center(
                            child: Text(
                              count.toString(),
                              style: AppTypography.titleMedium.copyWith(
                                color: isSelected
                                    ? Colors.white
                                    : AppColors.textPrimaryDark,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const Gap(AppSpacing.lg),

            // Meal Type
            Text(
              'Meal type',
              style: AppTypography.labelMedium.copyWith(
                color: AppColors.textSecondaryDark,
              ),
            ),
            const Gap(AppSpacing.sm),
            SegmentedButton<MealType>(
              segments: const [
                ButtonSegment(
                  value: MealType.breakfast,
                  label: Text('Breakfast'),
                  icon: Icon(LucideIcons.sunrise, size: 16),
                ),
                ButtonSegment(
                  value: MealType.lunch,
                  label: Text('Lunch'),
                  icon: Icon(LucideIcons.sun, size: 16),
                ),
                ButtonSegment(
                  value: MealType.dinner,
                  label: Text('Dinner'),
                  icon: Icon(LucideIcons.moon, size: 16),
                ),
              ],
              selected: {_mealType},
              onSelectionChanged: (set) =>
                  setState(() => _mealType = set.first),
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.resolveWith((states) {
                  if (states.contains(WidgetState.selected)) {
                    return AppColors.primary.withValues(alpha: 0.2);
                  }
                  return AppColors.cardDark;
                }),
              ),
            ),
            const Gap(AppSpacing.lg),

            // 🍽️ Guest Meal Section
            Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: _hasGuests
                    ? AppColors.success.withValues(alpha: 0.1)
                    : AppColors.cardDark,
                borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                border: Border.all(
                  color: _hasGuests
                      ? AppColors.success.withValues(alpha: 0.5)
                      : Colors.transparent,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        LucideIcons.users,
                        color: _hasGuests
                            ? AppColors.success
                            : AppColors.textSecondaryDark,
                        size: 20,
                      ),
                      const Gap(AppSpacing.sm),
                      Expanded(
                        child: Text(
                          'Had guests?',
                          style: AppTypography.titleSmall.copyWith(
                            color: AppColors.textPrimaryDark,
                          ),
                        ),
                      ),
                      Switch(
                        value: _hasGuests,
                        onChanged: (v) => setState(() => _hasGuests = v),
                        activeThumbColor: AppColors.success,
                      ),
                    ],
                  ),
                  if (_hasGuests) ...[
                    const Gap(AppSpacing.md),
                    Text(
                      'Guest meals',
                      style: AppTypography.labelSmall.copyWith(
                        color: AppColors.textSecondaryDark,
                      ),
                    ),
                    const Gap(AppSpacing.xs),
                    Row(
                      children: [1, 2, 3, 4, 5].map((count) {
                        final isSelected = _guestCount == count;
                        return Padding(
                          padding: const EdgeInsets.only(right: AppSpacing.xs),
                          child: GestureDetector(
                            onTap: () => setState(() => _guestCount = count),
                            child: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? AppColors.success
                                    : AppColors.surfaceDark,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Center(
                                child: Text(
                                  count.toString(),
                                  style: TextStyle(
                                    color: isSelected
                                        ? Colors.white
                                        : AppColors.textPrimaryDark,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const Gap(AppSpacing.md),
                    TextField(
                      controller: _guestNameController,
                      style: AppTypography.bodyMedium.copyWith(
                        color: AppColors.textPrimaryDark,
                      ),
                      decoration: const InputDecoration(
                        hintText: 'Guest name (optional)',
                        isDense: true,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const Gap(AppSpacing.lg),

            // Date selector
            Text(
              'Date',
              style: AppTypography.labelMedium.copyWith(
                color: AppColors.textSecondaryDark,
              ),
            ),
            const Gap(AppSpacing.sm),
            Material(
              color: AppColors.cardDark,
              borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
              child: InkWell(
                onTap: _selectDate,
                borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.md),
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
                        color: AppColors.textSecondaryDark,
                        size: 20,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const Gap(AppSpacing.xl),

            // Submit Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _submit,
                icon: const Icon(LucideIcons.check, size: 20),
                label: Text(
                  _hasGuests
                      ? 'Add Meal + $_guestCount Guest${_guestCount > 1 ? 's' : ''}'
                      : 'Add Meal',
                ),
                style: ElevatedButton.styleFrom(
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
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now().subtract(const Duration(days: 30)),
      lastDate: DateTime.now().add(const Duration(days: 7)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: AppColors.primary,
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
    if (_selectedMemberId == null) return;

    final meal = Meal(
      id: 'meal_${DateTime.now().millisecondsSinceEpoch}',
      memberId: _selectedMemberId!,
      date: _selectedDate,
      count: _mealCount,
      type: _mealType,
      guestCount: _hasGuests ? _guestCount : 0,
      guestName: _hasGuests && _guestNameController.text.trim().isNotEmpty
          ? _guestNameController.text.trim()
          : null,
      createdAt: DateTime.now(),
    );

    ref.read(mealsProvider.notifier).addMeal(meal);
    Navigator.of(context).pop();
  }
}
