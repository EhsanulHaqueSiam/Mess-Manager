import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:getwidget/getwidget.dart';

import 'package:mess_manager/core/theme/app_theme.dart';
import 'package:mess_manager/core/models/meal.dart';
import 'package:mess_manager/core/services/haptic_service.dart';
import 'package:mess_manager/core/widgets/gf_components.dart';

/// Bulk Meal Cancellation Screen - Uses GetWidget + VelocityX + flutter_animate
class BulkCancelScreen extends ConsumerWidget {
  const BulkCancelScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cancellations = ref.watch(mealCancellationsProvider);

    return Scaffold(
      appBar: AppBar(
        title: HStack([
          const Icon(LucideIcons.calendarX, color: AppColors.warning, size: 22),
          8.widthBox,
          'Cancel Meals'.text.make(),
        ]),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: VStack(crossAlignment: CrossAxisAlignment.start, [
          // Info Card
          GFAppCard(
            color: AppColors.info.withValues(alpha: 0.1),
            borderColor: AppColors.info.withValues(alpha: 0.3),
            child: HStack([
              const Icon(LucideIcons.info, color: AppColors.info),
              12.widthBox,
              VStack(crossAlignment: CrossAxisAlignment.start, [
                'Bulk Cancel Meals'.text.bold
                    .color(AppColors.textPrimaryDark)
                    .make(),
                'Select date range to cancel all meals. You won\'t receive meal notifications during cancelled days.'
                    .text
                    .sm
                    .color(AppColors.textSecondaryDark)
                    .make(),
              ]).expand(),
            ]),
          ).animate().fadeIn().slideY(begin: -0.05),
          16.heightBox,

          // Active Cancellations
          if (cancellations.isNotEmpty) ...[
            'Active Cancellations'.text.xl.bold
                .color(AppColors.textPrimaryDark)
                .make(),
            8.heightBox,
            ...cancellations.asMap().entries.map(
              (e) => _buildCancellationCard(context, ref, e.value, e.key),
            ),
            16.heightBox,
          ],

          // Empty State
          if (cancellations.isEmpty) _buildEmptyState(),
        ]),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          HapticService.buttonPress();
          _showCancelMealsSheet(context);
        },
        backgroundColor: AppColors.warning,
        icon: const Icon(LucideIcons.calendarMinus),
        label: 'Cancel Meals'.text.make(),
      ).animate().scale(delay: 200.ms),
    );
  }

  Widget _buildEmptyState() {
    return GFAppCard(
      child: VStack([
        const Icon(
          LucideIcons.calendarCheck,
          color: AppColors.textMutedDark,
          size: 48,
        ),
        12.heightBox,
        'No meals cancelled'.text.lg
            .color(AppColors.textSecondaryDark)
            .center
            .make(),
        'All meals are active'.text.sm
            .color(AppColors.textMutedDark)
            .center
            .make(),
      ]).p16(),
    ).animate().fadeIn();
  }

  Widget _buildCancellationCard(
    BuildContext context,
    WidgetRef ref,
    MealCancellation cancellation,
    int index,
  ) {
    final isActive = cancellation.endDate.isAfter(DateTime.now());

    return GFAppCard(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      borderColor: isActive
          ? AppColors.warning.withValues(alpha: 0.5)
          : AppColors.borderDark,
      child: VStack(crossAlignment: CrossAxisAlignment.start, [
        HStack([
          Icon(
            isActive ? LucideIcons.calendarX : LucideIcons.calendarCheck,
            color: isActive ? AppColors.warning : AppColors.textMutedDark,
            size: 20,
          ),
          8.widthBox,
          (isActive ? 'Meals Cancelled' : 'Past Cancellation').text
              .color(AppColors.textPrimaryDark)
              .make()
              .expand(),
          if (isActive)
            GFIconButton(
              icon: const Icon(
                LucideIcons.trash2,
                size: 18,
                color: AppColors.error,
              ),
              type: GFButtonType.transparent,
              size: GFSize.SMALL,
              onPressed: () {
                HapticService.itemDeleted();
                ref
                    .read(mealCancellationsProvider.notifier)
                    .removeCancellation(cancellation.id);
              },
            ),
        ]),
        8.heightBox,
        // Date Range
        HStack([
          GFBadge(
            text:
                'From: ${_formatDateMeal(cancellation.startDate, cancellation.startMeal)}',
            color: AppColors.warning.withValues(alpha: 0.2),
            textColor: AppColors.warning,
            size: GFSize.SMALL,
            shape: GFBadgeShape.pills,
          ),
          8.widthBox,
          const Icon(
            LucideIcons.arrowRight,
            size: 14,
            color: AppColors.textMutedDark,
          ),
          8.widthBox,
          GFBadge(
            text:
                'To: ${_formatDateMeal(cancellation.endDate, cancellation.endMeal)}',
            color: AppColors.warning.withValues(alpha: 0.2),
            textColor: AppColors.warning,
            size: GFSize.SMALL,
            shape: GFBadgeShape.pills,
          ),
        ]),
        8.heightBox,
        '${cancellation.getCancelledMealsCount()} meals cancelled'.text.sm
            .color(AppColors.textMutedDark)
            .make(),
      ]),
    ).animate(delay: (80 * index).ms).fadeIn().slideX(begin: 0.03);
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
      decoration: const BoxDecoration(
        color: AppColors.surfaceDark,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppSpacing.radiusLg),
        ),
      ),
      child: SingleChildScrollView(
        child: VStack(crossAlignment: CrossAxisAlignment.start, [
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
          16.heightBox,

          // Header
          HStack([
            const Icon(LucideIcons.calendarMinus, color: AppColors.warning),
            8.widthBox,
            'Cancel Meals'.text.xl2.color(AppColors.textPrimaryDark).make(),
          ]),
          16.heightBox,

          // Start
          'Cancel from'.text.sm.color(AppColors.textSecondaryDark).make(),
          8.heightBox,
          HStack([
            _buildDatePicker('Start Date', _startDate, (d) {
              setState(() {
                _startDate = d;
                if (_endDate.isBefore(_startDate)) {
                  _endDate = _startDate;
                }
              });
            }).expand(),
            8.widthBox,
            _buildMealSelector(
              _startMeal,
              (m) => setState(() => _startMeal = m),
            ).expand(),
          ]),
          16.heightBox,

          // End
          'Cancel until'.text.sm.color(AppColors.textSecondaryDark).make(),
          8.heightBox,
          HStack([
            _buildDatePicker(
              'End Date',
              _endDate,
              (d) => setState(() => _endDate = d),
            ).expand(),
            8.widthBox,
            _buildMealSelector(
              _endMeal,
              (m) => setState(() => _endMeal = m),
            ).expand(),
          ]),
          16.heightBox,

          // Preview Warning
          GFAppCard(
            color: AppColors.warning.withValues(alpha: 0.1),
            borderColor: AppColors.warning.withValues(alpha: 0.3),
            child: HStack([
              const Icon(LucideIcons.alertCircle, color: AppColors.warning),
              12.widthBox,
              'No meal notifications during this period'.text.sm
                  .color(AppColors.warning)
                  .make()
                  .expand(),
            ]),
          ),
          24.heightBox,

          // Submit Button
          GFPrimaryButton(
            text: 'Cancel Meals',
            icon: LucideIcons.check,
            onPressed: _submit,
          ),
        ]),
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
      child: GFAppCard(
        child: HStack([
          const Icon(LucideIcons.calendar, size: 18, color: AppColors.warning),
          8.widthBox,
          '${date.day}/${date.month}'.text
              .color(AppColors.textPrimaryDark)
              .make(),
        ]),
      ),
    );
  }

  Widget _buildMealSelector(MealType selected, Function(MealType) onChanged) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.cardDark,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        border: Border.all(color: AppColors.borderDark.withValues(alpha: 0.5)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<MealType>(
          value: selected,
          isExpanded: true,
          dropdownColor: AppColors.cardDark,
          items: MealType.values.map((m) {
            return DropdownMenuItem(
              value: m,
              child: _mealLabel(m).text.color(AppColors.textPrimaryDark).make(),
            );
          }).toList(),
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
    showSuccessToast(context, 'Meals cancelled successfully');
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
