import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:gap/gap.dart';

import 'package:mess_manager/core/theme/app_theme.dart';
import 'package:mess_manager/core/models/meal.dart';
import 'package:mess_manager/core/services/haptic_service.dart';
import 'package:mess_manager/core/widgets/app_components.dart';

/// Bulk Meal Cancellation Screen
class BulkCancelScreen extends ConsumerWidget {
  const BulkCancelScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cancellations = ref.watch(mealCancellationsProvider);

    return Scaffold(
      backgroundColor: const Color(0xFF0A0E1A),
      body: Stack(
        children: [
          // Background gradient
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFF0A0E1A), Color(0xFF0D1520)],
                ),
              ),
            ),
          ),

          // Breathing accent orb 1
          Positioned(
            top: -60,
            right: -40,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppColors.warning.withValues(alpha: 0.15),
                    AppColors.warning.withValues(alpha: 0.0),
                  ],
                ),
              ),
            )
                .animate(onPlay: (c) => c.repeat(reverse: true))
                .scaleXY(begin: 1.0, end: 1.15, duration: 4.seconds),
          ),

          // Breathing accent orb 2
          Positioned(
            bottom: 120,
            left: -60,
            child: Container(
              width: 180,
              height: 180,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppColors.warning.withValues(alpha: 0.1),
                    AppColors.warning.withValues(alpha: 0.0),
                  ],
                ),
              ),
            )
                .animate(onPlay: (c) => c.repeat(reverse: true))
                .scaleXY(begin: 1.0, end: 1.15, duration: 4.seconds),
          ),

          // Main content
          SafeArea(
            child: Column(
              children: [
                // Custom header
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                    vertical: AppSpacing.sm,
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        icon: Icon(
                          LucideIcons.arrowLeft,
                          color: Colors.white.withValues(alpha: 0.9),
                        ),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                      const Gap(4),
                      // Gradient halo icon
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: RadialGradient(
                            colors: [
                              AppColors.warning.withValues(alpha: 0.3),
                              AppColors.warning.withValues(alpha: 0.0),
                            ],
                          ),
                        ),
                        child: const Icon(
                          LucideIcons.calendarX,
                          color: AppColors.warning,
                          size: 22,
                        ),
                      ),
                      const Gap(10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Cancel Meals',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white.withValues(alpha: 0.9),
                            ),
                          ),
                          Text(
                            'Bulk meal cancellation',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.white.withValues(alpha: 0.5),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Scrollable content
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Info Card — glass
                        ClipRRect(
                          borderRadius:
                              BorderRadius.circular(AppSpacing.radiusMd),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                            child: Container(
                              padding: const EdgeInsets.all(AppSpacing.md),
                              decoration: BoxDecoration(
                                color: AppColors.info.withValues(alpha: 0.08),
                                border: Border.all(
                                  color: AppColors.info.withValues(alpha: 0.2),
                                ),
                                borderRadius: BorderRadius.circular(
                                    AppSpacing.radiusMd),
                              ),
                              child: Row(
                                children: [
                                  const Icon(
                                      LucideIcons.info, color: AppColors.info),
                                  const Gap(12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Bulk Cancel Meals',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white
                                                .withValues(alpha: 0.9),
                                          ),
                                        ),
                                        Text(
                                          'Select date range to cancel all meals. You won\'t receive meal notifications during cancelled days.',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.white
                                                .withValues(alpha: 0.5),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ).animate().fadeIn().slideY(begin: -0.05),
                        const Gap(16),

                        // Active Cancellations
                        if (cancellations.isNotEmpty) ...[
                          Text(
                            'Active Cancellations',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white.withValues(alpha: 0.9),
                            ),
                          ),
                          const Gap(8),
                          ...cancellations.asMap().entries.map(
                                (e) => _buildCancellationCard(
                                    context, ref, e.value, e.key),
                              ),
                          const Gap(16),
                        ],

                        // Empty State
                        if (cancellations.isEmpty)
                          _buildEmptyState(context),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
          gradient: LinearGradient(
            colors: [
              AppColors.warning,
              AppColors.warning.withValues(alpha: 0.8),
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.warning.withValues(alpha: 0.3),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
            onTap: () {
              HapticService.buttonPress();
              _showCancelMealsSheet(context);
            },
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(LucideIcons.calendarMinus,
                      color: Colors.white, size: 20),
                  const Gap(8),
                  const Text(
                    'Cancel Meals',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      )
          .animate()
          .scale(delay: 200.ms)
          .shimmer(delay: 600.ms, duration: 1500.ms),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: AppSpacing.accentCard(accent: AppColors.error, radius: AppSpacing.radiusMd),
          child: Column(
            children: [
              Icon(
                LucideIcons.calendarCheck,
                color: Colors.white.withValues(alpha: 0.3),
                size: 48,
              ),
              const Gap(12),
              Text(
                'No meals cancelled',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.white.withValues(alpha: 0.5),
                ),
              ),
              Text(
                'All meals are active',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white.withValues(alpha: 0.3),
                ),
              ),
            ],
          ),
        ),
      ),
    ).animate().fadeIn();
  }

  Widget _buildCancellationCard(
    BuildContext context,
    WidgetRef ref,
    MealCancellation cancellation,
    int index,
  ) {
    final isActive = cancellation.endDate.isAfter(DateTime.now());

    return ClipRRect(
      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: Container(
          margin: const EdgeInsets.only(bottom: AppSpacing.sm),
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: AppSpacing.accentCard(accent: AppColors.error, radius: AppSpacing.radiusMd),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    isActive
                        ? LucideIcons.calendarX
                        : LucideIcons.calendarCheck,
                    color: isActive
                        ? AppColors.warning
                        : Colors.white.withValues(alpha: 0.3),
                    size: 20,
                  ),
                  const Gap(8),
                  Expanded(
                    child: Text(
                      isActive ? 'Meals Cancelled' : 'Past Cancellation',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.9),
                      ),
                    ),
                  ),
                  if (isActive)
                    IconButton(
                      icon: const Icon(
                        LucideIcons.trash2,
                        size: 18,
                        color: AppColors.error,
                      ),
                      onPressed: () {
                        HapticService.itemDeleted();
                        ref
                            .read(mealCancellationsProvider.notifier)
                            .removeCancellation(cancellation.id);
                      },
                    ),
                ],
              ),
              const Gap(8),
              // Date Range
              Row(
                children: [
                  AppBadge(
                    text:
                        'From: ${_formatDateMeal(cancellation.startDate, cancellation.startMeal)}',
                    color: AppColors.warning.withValues(alpha: 0.2),
                    textColor: AppColors.warning,
                  ),
                  const Gap(8),
                  Icon(
                    LucideIcons.arrowRight,
                    size: 14,
                    color: Colors.white.withValues(alpha: 0.3),
                  ),
                  const Gap(8),
                  AppBadge(
                    text:
                        'To: ${_formatDateMeal(cancellation.endDate, cancellation.endMeal)}',
                    color: AppColors.warning.withValues(alpha: 0.2),
                    textColor: AppColors.warning,
                  ),
                ],
              ),
              const Gap(8),
              Text(
                '${cancellation.getCancelledMealsCount()} meals cancelled',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white.withValues(alpha: 0.3),
                ),
              ),
            ],
          ),
        ),
      ),
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
    HapticService.modalOpen();
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
        color: Color(0xFF0D1520),
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppSpacing.radiusLg),
        ),
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Gradient handle bar
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.warning.withValues(alpha: 0.6),
                      AppColors.warning.withValues(alpha: 0.2),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const Gap(16),

            // Header
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        AppColors.warning.withValues(alpha: 0.3),
                        AppColors.warning.withValues(alpha: 0.0),
                      ],
                    ),
                  ),
                  child: const Icon(
                      LucideIcons.calendarMinus, color: AppColors.warning),
                ),
                const Gap(8),
                Text(
                  'Cancel Meals',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white.withValues(alpha: 0.9),
                  ),
                ),
              ],
            ),
            const Gap(16),

            // Start
            Text(
              'Cancel from',
              style: TextStyle(
                fontSize: 12,
                color: Colors.white.withValues(alpha: 0.5),
              ),
            ),
            const Gap(8),
            Row(
              children: [
                Expanded(
                  child:
                      _buildDatePicker(context, 'Start Date', _startDate, (d) {
                    setState(() {
                      _startDate = d;
                      if (_endDate.isBefore(_startDate)) {
                        _endDate = _startDate;
                      }
                    });
                  }),
                ),
                const Gap(8),
                Expanded(
                  child: _buildMealSelector(
                    context,
                    _startMeal,
                    (m) => setState(() => _startMeal = m),
                  ),
                ),
              ],
            ),
            const Gap(16),

            // End
            Text(
              'Cancel until',
              style: TextStyle(
                fontSize: 12,
                color: Colors.white.withValues(alpha: 0.5),
              ),
            ),
            const Gap(8),
            Row(
              children: [
                Expanded(
                  child: _buildDatePicker(
                    context,
                    'End Date',
                    _endDate,
                    (d) => setState(() => _endDate = d),
                  ),
                ),
                const Gap(8),
                Expanded(
                  child: _buildMealSelector(
                    context,
                    _endMeal,
                    (m) => setState(() => _endMeal = m),
                  ),
                ),
              ],
            ),
            const Gap(16),

            // Preview Warning — glass card
            ClipRRect(
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                child: Container(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    color: AppColors.warning.withValues(alpha: 0.08),
                    border: Border.all(
                      color: AppColors.warning.withValues(alpha: 0.2),
                    ),
                    borderRadius:
                        BorderRadius.circular(AppSpacing.radiusMd),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                          LucideIcons.alertCircle, color: AppColors.warning),
                      const Gap(12),
                      Expanded(
                        child: Text(
                          'No meal notifications during this period',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.warning,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const Gap(24),

            // Submit Button
            AppPrimaryButton(
              text: 'Cancel Meals',
              icon: LucideIcons.check,
              onPressed: _submit,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDatePicker(
    BuildContext context,
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
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
          child: Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: AppSpacing.accentCard(accent: AppColors.error, radius: AppSpacing.radiusMd),
            child: Row(
              children: [
                const Icon(
                    LucideIcons.calendar, size: 18, color: AppColors.warning),
                const Gap(8),
                Text(
                  '${date.day}/${date.month}',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.9),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMealSelector(
    BuildContext context,
    MealType selected,
    Function(MealType) onChanged,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      decoration: AppSpacing.accentCard(accent: AppColors.error, radius: AppSpacing.radiusMd),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<MealType>(
          value: selected,
          isExpanded: true,
          dropdownColor: const Color(0xFF0D1520),
          items: MealType.values.map((m) {
            return DropdownMenuItem(
              value: m,
              child: Text(
                _mealLabel(m),
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.9),
                ),
              ),
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
    HapticService.warning();

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
