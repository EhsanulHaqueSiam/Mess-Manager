import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:gap/gap.dart';
import 'package:mess_manager/core/theme/app_theme.dart';
import 'package:mess_manager/core/models/meal.dart';
import 'package:mess_manager/core/services/haptic_service.dart';

/// Bulk Meal Cancellation Screen
/// Cancel meals in bulk for a date range
class BulkCancelScreen extends ConsumerWidget {
  const BulkCancelScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cancellations = ref.watch(mealCancellationsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Icon(
              LucideIcons.calendarX,
              color: AppColors.warning,
              size: 22,
            ),
            const Gap(AppSpacing.sm),
            const Text('Cancel Meals'),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Info Card
            Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: AppColors.info.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                border: Border.all(
                  color: AppColors.info.withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                children: [
                  const Icon(LucideIcons.info, color: AppColors.info),
                  const Gap(AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Bulk Cancel Meals',
                          style: AppTypography.titleSmall.copyWith(
                            color: AppColors.textPrimaryDark,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          'Select date range to cancel all meals. You won\'t receive meal notifications during cancelled days.',
                          style: AppTypography.bodySmall.copyWith(
                            color: AppColors.textSecondaryDark,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ).animate().fadeIn().slideY(begin: -0.1),
            const Gap(AppSpacing.lg),

            // Active Cancellations
            if (cancellations.isNotEmpty) ...[
              Text(
                'Active Cancellations',
                style: AppTypography.headlineSmall.copyWith(
                  color: AppColors.textPrimaryDark,
                ),
              ),
              const Gap(AppSpacing.sm),
              ...cancellations.asMap().entries.map(
                (e) => _buildCancellationCard(context, ref, e.value, e.key),
              ),
              const Gap(AppSpacing.lg),
            ],

            // Empty State
            if (cancellations.isEmpty)
              Container(
                padding: const EdgeInsets.all(AppSpacing.xl),
                decoration: BoxDecoration(
                  color: AppColors.cardDark,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                ),
                child: Column(
                  children: [
                    Icon(
                      LucideIcons.calendarCheck,
                      color: AppColors.textMutedDark,
                      size: 48,
                    ),
                    const Gap(AppSpacing.md),
                    Text(
                      'No meals cancelled',
                      style: AppTypography.titleMedium.copyWith(
                        color: AppColors.textSecondaryDark,
                      ),
                    ),
                    Text(
                      'All meals are active',
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.textMutedDark,
                      ),
                    ),
                  ],
                ),
              ).animate().fadeIn(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          HapticService.buttonPress();
          _showCancelMealsSheet(context);
        },
        backgroundColor: AppColors.warning,
        icon: const Icon(LucideIcons.calendarMinus),
        label: const Text('Cancel Meals'),
      ).animate().scale(delay: 200.ms),
    );
  }

  Widget _buildCancellationCard(
    BuildContext context,
    WidgetRef ref,
    MealCancellation cancellation,
    int index,
  ) {
    final isActive = cancellation.endDate.isAfter(DateTime.now());

    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.cardDark,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        border: Border.all(
          color: isActive
              ? AppColors.warning.withValues(alpha: 0.5)
              : AppColors.borderDark,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                isActive ? LucideIcons.calendarX : LucideIcons.calendarCheck,
                color: isActive ? AppColors.warning : AppColors.textMutedDark,
                size: 20,
              ),
              const Gap(AppSpacing.sm),
              Expanded(
                child: Text(
                  isActive ? 'Meals Cancelled' : 'Past Cancellation',
                  style: AppTypography.titleSmall.copyWith(
                    color: AppColors.textPrimaryDark,
                  ),
                ),
              ),
              if (isActive)
                IconButton(
                  icon: const Icon(LucideIcons.trash2, size: 18),
                  color: AppColors.error,
                  onPressed: () {
                    HapticService.itemDeleted();
                    ref
                        .read(mealCancellationsProvider.notifier)
                        .removeCancellation(cancellation.id);
                  },
                ),
            ],
          ),
          const Gap(AppSpacing.sm),

          // Date Range
          Row(
            children: [
              _buildDateChip(
                'From: ${_formatDateMeal(cancellation.startDate, cancellation.startMeal)}',
                AppColors.warning,
              ),
              const Gap(AppSpacing.sm),
              const Icon(
                LucideIcons.arrowRight,
                size: 14,
                color: AppColors.textMutedDark,
              ),
              const Gap(AppSpacing.sm),
              _buildDateChip(
                'To: ${_formatDateMeal(cancellation.endDate, cancellation.endMeal)}',
                AppColors.warning,
              ),
            ],
          ),

          // Cancelled meals count
          const Gap(AppSpacing.sm),
          Text(
            '${cancellation.getCancelledMealsCount()} meals cancelled',
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.textMutedDark,
            ),
          ),
        ],
      ),
    ).animate(delay: (80 * index).ms).fadeIn().slideX(begin: 0.03);
  }

  Widget _buildDateChip(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
      ),
      child: Text(text, style: AppTypography.labelSmall.copyWith(color: color)),
    );
  }

  String _formatDateMeal(DateTime date, MealType meal) {
    final mealName = switch (meal) {
      MealType.breakfast => 'সকাল',
      MealType.lunch => 'দুপুর',
      MealType.dinner => 'রাত',
    };
    return '${date.day}/${date.month} $mealName';
  }

  void _showCancelMealsSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const CancelMealsSheet(),
    );
  }
}

// ==================== Cancel Meals Sheet ====================

class CancelMealsSheet extends ConsumerStatefulWidget {
  const CancelMealsSheet({super.key});

  @override
  ConsumerState<CancelMealsSheet> createState() => _CancelMealsSheetState();
}

class _CancelMealsSheetState extends ConsumerState<CancelMealsSheet> {
  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now().add(const Duration(days: 1));
  MealType _startMeal = MealType.lunch;
  MealType _endMeal = MealType.dinner;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: AppSpacing.lg,
        right: AppSpacing.lg,
        top: AppSpacing.lg,
        bottom: MediaQuery.of(context).viewInsets.bottom + AppSpacing.lg,
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

            // Header
            Row(
              children: [
                const Icon(LucideIcons.calendarMinus, color: AppColors.warning),
                const Gap(AppSpacing.sm),
                Text(
                  'Cancel Meals',
                  style: AppTypography.headlineMedium.copyWith(
                    color: AppColors.textPrimaryDark,
                  ),
                ),
              ],
            ),
            const Gap(AppSpacing.md),

            // Start
            Text(
              'Cancel from',
              style: AppTypography.labelMedium.copyWith(
                color: AppColors.textSecondaryDark,
              ),
            ),
            const Gap(AppSpacing.sm),
            Row(
              children: [
                Expanded(
                  child: _buildDatePicker('Start Date', _startDate, (d) {
                    setState(() {
                      _startDate = d;
                      if (_endDate.isBefore(_startDate)) {
                        _endDate = _startDate;
                      }
                    });
                  }),
                ),
                const Gap(AppSpacing.sm),
                Expanded(
                  child: _buildMealSelector(_startMeal, (m) {
                    setState(() => _startMeal = m);
                  }),
                ),
              ],
            ),
            const Gap(AppSpacing.md),

            // End
            Text(
              'Cancel until',
              style: AppTypography.labelMedium.copyWith(
                color: AppColors.textSecondaryDark,
              ),
            ),
            const Gap(AppSpacing.sm),
            Row(
              children: [
                Expanded(
                  child: _buildDatePicker('End Date', _endDate, (d) {
                    setState(() => _endDate = d);
                  }),
                ),
                const Gap(AppSpacing.sm),
                Expanded(
                  child: _buildMealSelector(_endMeal, (m) {
                    setState(() => _endMeal = m);
                  }),
                ),
              ],
            ),
            const Gap(AppSpacing.lg),

            // Preview
            Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: AppColors.warning.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
              ),
              child: Row(
                children: [
                  const Icon(LucideIcons.alertCircle, color: AppColors.warning),
                  const Gap(AppSpacing.md),
                  Expanded(
                    child: Text(
                      'No meal notifications during this period',
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.warning,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Gap(AppSpacing.xl),

            // Submit
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _submit,
                icon: const Icon(LucideIcons.check),
                label: const Text('Cancel Meals'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.warning,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDatePicker(
    String label,
    DateTime date,
    Function(DateTime) onChanged,
  ) {
    return GestureDetector(
      onTap: () async {
        HapticService.lightTap();
        final picked = await showDatePicker(
          context: context,
          initialDate: date,
          firstDate: DateTime.now(),
          lastDate: DateTime.now().add(const Duration(days: 180)),
        );
        if (picked != null) onChanged(picked);
      },
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
              size: 18,
              color: AppColors.warning,
            ),
            const Gap(AppSpacing.sm),
            Text(
              '${date.day}/${date.month}',
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.textPrimaryDark,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMealSelector(MealType selected, Function(MealType) onChanged) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.cardDark,
        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<MealType>(
          value: selected,
          isExpanded: true,
          dropdownColor: AppColors.cardDark,
          items: MealType.values
              .map(
                (m) => DropdownMenuItem(
                  value: m,
                  child: Text(
                    _mealLabel(m),
                    style: TextStyle(color: AppColors.textPrimaryDark),
                  ),
                ),
              )
              .toList(),
          onChanged: (v) {
            HapticService.selectionTick();
            onChanged(v!);
          },
        ),
      ),
    );
  }

  String _mealLabel(MealType type) {
    return switch (type) {
      MealType.breakfast => 'সকাল (Breakfast)',
      MealType.lunch => 'দুপুর (Lunch)',
      MealType.dinner => 'রাত (Dinner)',
    };
  }

  void _submit() {
    HapticService.success();

    final cancellation = MealCancellation(
      id: 'cancel_${DateTime.now().millisecondsSinceEpoch}',
      startDate: _startDate,
      endDate: _endDate,
      startMeal: _startMeal,
      endMeal: _endMeal,
    );

    ref.read(mealCancellationsProvider.notifier).addCancellation(cancellation);
    Navigator.of(context).pop();
  }
}

// ==================== Models & Providers ====================

/// Meal Cancellation Model
class MealCancellation {
  final String id;
  final DateTime startDate;
  final DateTime endDate;
  final MealType startMeal;
  final MealType endMeal;

  MealCancellation({
    required this.id,
    required this.startDate,
    required this.endDate,
    required this.startMeal,
    required this.endMeal,
  });

  int getCancelledMealsCount() {
    int count = 0;
    DateTime current = startDate;

    while (current.isBefore(endDate) || current.isAtSameMomentAs(endDate)) {
      for (final meal in MealType.values) {
        // Skip meals before start meal on start date
        if (current.isAtSameMomentAs(startDate) &&
            meal.index < startMeal.index) {
          continue;
        }
        // Skip meals after end meal on end date
        if (current.isAtSameMomentAs(endDate) && meal.index > endMeal.index) {
          continue;
        }
        count++;
      }
      current = current.add(const Duration(days: 1));
    }

    return count;
  }

  bool isMealCancelled(DateTime date, MealType meal) {
    // Before start date
    if (date.isBefore(startDate)) return false;
    // After end date
    if (date.isAfter(endDate)) return false;

    // On start date but before start meal
    if (_isSameDay(date, startDate) && meal.index < startMeal.index) {
      return false;
    }
    // On end date but after end meal
    if (_isSameDay(date, endDate) && meal.index > endMeal.index) {
      return false;
    }

    return true;
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'startDate': startDate.toIso8601String(),
    'endDate': endDate.toIso8601String(),
    'startMeal': startMeal.index,
    'endMeal': endMeal.index,
  };

  factory MealCancellation.fromJson(Map<String, dynamic> json) =>
      MealCancellation(
        id: json['id'],
        startDate: DateTime.parse(json['startDate']),
        endDate: DateTime.parse(json['endDate']),
        startMeal: MealType.values[json['startMeal']],
        endMeal: MealType.values[json['endMeal']],
      );
}

/// Meal Cancellations Notifier
class MealCancellationsNotifier extends Notifier<List<MealCancellation>> {
  @override
  List<MealCancellation> build() => [];

  void addCancellation(MealCancellation cancellation) {
    state = [...state, cancellation];
  }

  void removeCancellation(String id) {
    state = state.where((c) => c.id != id).toList();
  }

  bool isMealCancelled(DateTime date, MealType meal) {
    return state.any((c) => c.isMealCancelled(date, meal));
  }
}

final mealCancellationsProvider =
    NotifierProvider<MealCancellationsNotifier, List<MealCancellation>>(() {
      return MealCancellationsNotifier();
    });
