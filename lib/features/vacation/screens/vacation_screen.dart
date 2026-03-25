import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:gap/gap.dart';

import 'package:mess_manager/core/theme/app_theme.dart';
import 'package:mess_manager/core/models/meal.dart';
import 'package:mess_manager/core/providers/members_provider.dart';
import 'package:mess_manager/core/services/haptic_service.dart';
import 'package:mess_manager/core/widgets/app_components.dart';
import 'package:mess_manager/core/widgets/quick_input_widgets.dart';
import 'package:mess_manager/features/vacation/providers/vacation_provider.dart';
import 'package:mess_manager/features/vacation/providers/fixed_expenses_provider.dart';

/// Vacation Screen - Cosmic Bioluminescence design
class VacationScreen extends ConsumerWidget {
  const VacationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final myVacations = ref.watch(currentMemberVacationsProvider);
    final unpaidExpenses = ref.watch(unpaidExpensesProvider);
    final membersOnVacation = ref.watch(membersOnVacationProvider);
    final members = ref.watch(membersProvider);

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

          // Breathing accent orb - top right
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
                    AppColors.success.withValues(alpha: 0.15),
                    AppColors.success.withValues(alpha: 0.0),
                  ],
                ),
              ),
            )
                .animate(onPlay: (c) => c.repeat(reverse: true))
                .scaleXY(begin: 1.0, end: 1.15, duration: 4.seconds),
          ),

          // Breathing accent orb - bottom left
          Positioned(
            bottom: 80,
            left: -60,
            child: Container(
              width: 180,
              height: 180,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppColors.success.withValues(alpha: 0.10),
                    AppColors.success.withValues(alpha: 0.0),
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
                      // Gradient halo icon
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: RadialGradient(
                            colors: [
                              AppColors.success.withValues(alpha: 0.25),
                              AppColors.success.withValues(alpha: 0.0),
                            ],
                          ),
                        ),
                        child: const Center(
                          child: Icon(
                            LucideIcons.palmtree,
                            color: AppColors.success,
                            size: 22,
                          ),
                        ),
                      ),
                      const Gap(12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Vacation & Bills',
                            style: AppTypography.titleLarge.copyWith(
                              color: Colors.white.withValues(alpha: 0.9),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Manage your time away',
                            style: AppTypography.bodySmall.copyWith(
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
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          // Unpaid Expenses Alert
                          if (unpaidExpenses.isNotEmpty) ...[
                            _buildUnpaidExpensesCard(
                                context, unpaidExpenses, ref),
                            const Gap(16),
                          ],

                          // My Vacations section label
                          Row(
                            children: [
                              Container(
                                width: 3,
                                height: 14,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      AppColors.success,
                                      AppColors.success.withValues(alpha: 0.3),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              ),
                              const Gap(8),
                              Text(
                                'MY VACATION',
                                style: AppTypography.labelMedium.copyWith(
                                  color: Colors.white.withValues(alpha: 0.5),
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 1.2,
                                ),
                              ),
                              const Spacer(),
                              GestureDetector(
                                onTap: () => _showAddVacationSheet(context),
                                child: Container(
                                  width: 32,
                                  height: 32,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: AppColors.success
                                        .withValues(alpha: 0.15),
                                    border: Border.all(
                                      color: AppColors.success
                                          .withValues(alpha: 0.3),
                                    ),
                                  ),
                                  child: const Center(
                                    child: Icon(
                                      LucideIcons.plus,
                                      color: AppColors.success,
                                      size: 16,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const Gap(12),
                          if (myVacations.isEmpty)
                            // Cosmic empty state
                            ClipRRect(
                              borderRadius:
                                  BorderRadius.circular(AppSpacing.radiusMd),
                              child: BackdropFilter(
                                filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                                child: Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 40, horizontal: 24),
                                  decoration: AppSpacing.accentCard(accent: AppColors.moneyPositive),
                                  child: Column(
                                    children: [
                                      Icon(
                                        LucideIcons.palmtree,
                                        size: 40,
                                        color: Colors.white
                                            .withValues(alpha: 0.3),
                                      ),
                                      const Gap(12),
                                      Text(
                                        'No vacation planned',
                                        style:
                                            AppTypography.titleMedium.copyWith(
                                          color: Colors.white
                                              .withValues(alpha: 0.5),
                                        ),
                                      ),
                                      const Gap(4),
                                      Text(
                                        'Add a vacation to skip meal notifications',
                                        style:
                                            AppTypography.bodySmall.copyWith(
                                          color: Colors.white
                                              .withValues(alpha: 0.3),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            )
                          else
                            ...myVacations.asMap().entries.map(
                                  (e) => _buildVacationCard(
                                      context, ref, e.value, e.key),
                                ),
                          const Gap(24),

                          // Who's on vacation
                          if (membersOnVacation.isNotEmpty) ...[
                            Row(
                              children: [
                                Container(
                                  width: 3,
                                  height: 14,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                        AppColors.success,
                                        AppColors.success
                                            .withValues(alpha: 0.3),
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(2),
                                  ),
                                ),
                                const Gap(8),
                                Text(
                                  'CURRENTLY ON VACATION',
                                  style: AppTypography.labelMedium.copyWith(
                                    color:
                                        Colors.white.withValues(alpha: 0.5),
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 1.2,
                                  ),
                                ),
                              ],
                            ),
                            const Gap(12),
                            Wrap(
                              spacing: AppSpacing.sm,
                              children: membersOnVacation.map((memberId) {
                                if (members.isEmpty) {
                                  return const SizedBox.shrink();
                                }
                                final member =
                                    members.cast<dynamic>().firstWhere(
                                          (m) => m.id == memberId,
                                          orElse: () => null,
                                        );
                                if (member == null) {
                                  return const SizedBox.shrink();
                                }
                                return Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.success
                                        .withValues(alpha: 0.1),
                                    border: Border.all(
                                      color: AppColors.success
                                          .withValues(alpha: 0.2),
                                    ),
                                    borderRadius: BorderRadius.circular(
                                        AppSpacing.radiusFull),
                                  ),
                                  child: Text(
                                    member.name,
                                    style: AppTypography.labelMedium.copyWith(
                                      color: AppColors.success,
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                            const Gap(24),
                          ],

                          // Fixed Monthly Expenses
                          _buildFixedExpensesSection(context, ref),
                          const Gap(32),
                        ],
                      ),
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
              AppColors.success,
              AppColors.success.withValues(alpha: 0.8),
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.success.withValues(alpha: 0.4),
              blurRadius: 16,
              spreadRadius: -2,
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              HapticService.buttonPress();
              _showAddVacationSheet(context);
            },
            borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(LucideIcons.palmtree,
                      color: Colors.white, size: 20),
                  const Gap(8),
                  Text(
                    'Add Vacation',
                    style: AppTypography.labelLarge.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      )
          .animate(onPlay: (c) => c.repeat())
          .shimmer(
            duration: 2.seconds,
            color: Colors.white.withValues(alpha: 0.2),
          ),
    );
  }

  Widget _buildUnpaidExpensesCard(
      BuildContext context, List<FixedExpense> expenses, WidgetRef ref) {
    final total = expenses.fold(0.0, (sum, e) => sum + e.amount);
    final memberCount = ref.watch(membersProvider).length;
    final perMember = memberCount > 0 ? total / memberCount : 0;

    return ClipRRect(
      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.warning.withValues(alpha: 0.8),
                AppColors.warning,
              ],
            ),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.15),
            ),
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          ),
          child: Row(
            children: [
              const Icon(LucideIcons.alertTriangle,
                  color: Colors.white, size: 32),
              const Gap(12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Unpaid Bills',
                        style: AppTypography.titleMedium.copyWith(
                            color: Colors.white, fontWeight: FontWeight.bold)),
                    Text(
                      '${expenses.length} bills \u2022 \u09F3${total.toStringAsFixed(0)} total',
                      style:
                          AppTypography.bodySmall.copyWith(color: Colors.white),
                    ),
                    Text(
                      'Your share: \u09F3${perMember.toStringAsFixed(0)}',
                      style: AppTypography.titleMedium.copyWith(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ).animate().fadeIn().shake();
  }

  Widget _buildVacationCard(
    BuildContext context,
    WidgetRef ref,
    VacationPeriod vacation,
    int index,
  ) {
    final isActive = vacation.isActive;

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
          child: Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: AppSpacing.accentCard(accent: isActive ? AppColors.moneyPositive : AppColors.moneyPositive),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      isActive ? LucideIcons.check : LucideIcons.x,
                      color: isActive
                          ? AppColors.success
                          : Colors.white.withValues(alpha: 0.3),
                      size: 18,
                    ),
                    const Gap(8),
                    Expanded(
                      child: Text(
                        vacation.reason ?? 'Vacation',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.9),
                        ),
                      ),
                    ),
                    Switch.adaptive(
                      value: isActive,
                      onChanged: (_) => ref
                          .read(vacationsProvider.notifier)
                          .toggleActive(vacation.id),
                      activeColor: AppColors.success,
                    ),
                  ],
                ),
                const Gap(8),
                _buildDateChip(
                  context,
                  'From: ${_formatDateWithMeal(vacation.startDate, vacation.lastMealBefore)} (after)',
                ),
                const Gap(4),
                _buildDateChip(
                  context,
                  'To: ${_formatDateWithMeal(vacation.endDate, vacation.firstMealAfter)} (before)',
                ),
              ],
            ),
          ),
        ),
      ),
    ).animate(delay: (80 * index).ms).fadeIn().slideX(begin: 0.03);
  }

  Widget _buildDateChip(BuildContext context, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFF0D1520),
        borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
      ),
      child: Text(
        text,
        style: AppTypography.bodySmall.copyWith(
          color: Colors.white.withValues(alpha: 0.5),
        ),
      ),
    );
  }

  String _formatDateWithMeal(DateTime date, MealType meal) {
    final mealName = switch (meal) {
      MealType.breakfast => '\u09B8\u0995\u09BE\u09B2',
      MealType.lunch => '\u09A6\u09C1\u09AA\u09C1\u09B0',
      MealType.dinner => '\u09B0\u09BE\u09A4',
    };
    return '${date.day}/${date.month}/${date.year} $mealName';
  }

  Widget _buildFixedExpensesSection(BuildContext context, WidgetRef ref) {
    final expenses = ref.watch(currentMonthExpensesProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 3,
              height: 14,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppColors.success,
                    AppColors.success.withValues(alpha: 0.3),
                  ],
                ),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const Gap(8),
            Text(
              'FIXED MONTHLY EXPENSES',
              style: AppTypography.labelMedium.copyWith(
                color: Colors.white.withValues(alpha: 0.5),
                fontWeight: FontWeight.w600,
                letterSpacing: 1.2,
              ),
            ),
          ],
        ),
        const Gap(4),
        Padding(
          padding: const EdgeInsets.only(left: 11),
          child: Text(
            'These apply to everyone, even during vacation',
            style: AppTypography.bodySmall.copyWith(
              color: Colors.white.withValues(alpha: 0.3),
            ),
          ),
        ),
        const Gap(12),
        if (expenses.isEmpty)
          ClipRRect(
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: AppSpacing.accentCard(accent: AppColors.moneyPositive),
                child: Center(
                  child: Text(
                    'No fixed expenses this month',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.3),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ...expenses.asMap().entries.map(
              (e) => _buildExpenseCard(context, ref, e.value, e.key),
            ),
      ],
    );
  }

  Widget _buildExpenseCard(
      BuildContext context, WidgetRef ref, FixedExpense expense, int index) {
    final isPaid = expense.isPaid;
    final typeName = getExpenseTypeName(expense.type);
    final statusColor = isPaid ? AppColors.success : AppColors.warning;

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
          child: Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: AppSpacing.accentCard(accent: statusColor),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: statusColor.withValues(alpha: 0.1),
                  child: Icon(
                    isPaid ? LucideIcons.check : LucideIcons.clock,
                    color: statusColor,
                    size: 18,
                  ),
                ),
                const Gap(12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(typeName,
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.9),
                          )),
                      if (expense.description != null)
                        Text(expense.description!,
                            style: AppTypography.bodySmall.copyWith(
                              color: Colors.white.withValues(alpha: 0.5),
                            )),
                    ],
                  ),
                ),
                Text(
                  '\u09F3${expense.amount.toStringAsFixed(0)}',
                  style: AppTypography.titleMedium.copyWith(
                      color: statusColor, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
      ),
    ).animate(delay: (80 * index).ms).fadeIn().slideX(begin: 0.03);
  }

  void _showAddVacationSheet(BuildContext context) {
    HapticService.modalOpen();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const AddVacationSheet(),
    );
  }
}

/// Add Vacation Bottom Sheet
class AddVacationSheet extends ConsumerStatefulWidget {
  const AddVacationSheet({super.key});

  @override
  ConsumerState<AddVacationSheet> createState() => _AddVacationSheetState();
}

class _AddVacationSheetState extends ConsumerState<AddVacationSheet> {
  DateTime _startDate = DateTime.now().add(const Duration(days: 1));
  DateTime _endDate = DateTime.now().add(const Duration(days: 3));
  MealType _lastMealBefore = MealType.dinner;
  MealType _firstMealAfter = MealType.breakfast;
  final _reasonController = TextEditingController();
  int? _selectedPresetDays;

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  int get _vacationDays =>
      _endDate.difference(_startDate).inDays.clamp(1, 9999);

  String get _durationLabel {
    final days = _vacationDays;
    if (days == 1) return '1-day';
    if (days < 7) return '$days-day';
    if (days == 7) return '1-week';
    if (days == 14) return '2-week';
    if (days >= 28 && days <= 31) return '1-month';
    return '$days-day';
  }

  void _onPresetTapped(int days) {
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    setState(() {
      _selectedPresetDays = days;
      _startDate = tomorrow;
      _endDate = tomorrow.add(Duration(days: days - 1));
    });
  }

  void _cycleMealType({required bool isLastMeal}) {
    HapticService.selectionTick();
    const order = [MealType.breakfast, MealType.lunch, MealType.dinner];
    if (isLastMeal) {
      final idx = order.indexOf(_lastMealBefore);
      setState(() => _lastMealBefore = order[(idx + 1) % order.length]);
    } else {
      final idx = order.indexOf(_firstMealAfter);
      setState(() => _firstMealAfter = order[(idx + 1) % order.length]);
    }
  }

  String _mealLabel(MealType type) => switch (type) {
        MealType.breakfast => '\u09B8\u0995\u09BE\u09B2',
        MealType.lunch => '\u09A6\u09C1\u09AA\u09C1\u09B0',
        MealType.dinner => '\u09B0\u09BE\u09A4',
      };

  IconData _mealIcon(MealType type) => switch (type) {
        MealType.breakfast => LucideIcons.sunrise,
        MealType.lunch => LucideIcons.sun,
        MealType.dinner => LucideIcons.moon,
      };

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
            // Glass-styled handle bar
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const Gap(16),

            // Header
            Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        AppColors.success.withValues(alpha: 0.25),
                        AppColors.success.withValues(alpha: 0.0),
                      ],
                    ),
                  ),
                  child: const Center(
                    child: Icon(LucideIcons.palmtree,
                        color: AppColors.success, size: 20),
                  ),
                ),
                const Gap(8),
                Text('Add Vacation',
                    style: AppTypography.titleLarge.copyWith(
                        color: Colors.white.withValues(alpha: 0.9),
                        fontWeight: FontWeight.bold)),
              ],
            ),
            const Gap(20),

            // Quick Duration Presets
            Text('How long?',
                style: AppTypography.bodySmall.copyWith(
                  color: Colors.white.withValues(alpha: 0.5),
                )),
            const Gap(8),
            QuickDurationPicker(
              selectedDays: _selectedPresetDays,
              onDurationSelected: _onPresetTapped,
              accentColor: AppColors.success,
            ),
            const Gap(20),

            // Custom date pickers
            Text('Or pick custom dates',
                style: AppTypography.bodySmall.copyWith(
                  color: Colors.white.withValues(alpha: 0.3),
                )),
            const Gap(8),
            Row(
              children: [
                Expanded(
                  child: _buildDatePicker(
                    'Start',
                    _startDate,
                    (d) => setState(() {
                      _startDate = d;
                      if (_endDate.isBefore(d)) _endDate = d;
                      _selectedPresetDays = null;
                    }),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Icon(LucideIcons.arrowRight,
                      size: 16,
                      color: Colors.white.withValues(alpha: 0.3)),
                ),
                Expanded(
                  child: _buildDatePicker(
                    'End',
                    _endDate,
                    (d) => setState(() {
                      _endDate = d;
                      _selectedPresetDays = null;
                    }),
                  ),
                ),
              ],
            ),
            const Gap(16),

            // Meal type chips (tap-to-cycle)
            Text('Meal boundaries',
                style: AppTypography.bodySmall.copyWith(
                  color: Colors.white.withValues(alpha: 0.5),
                )),
            const Gap(8),
            Row(
              children: [
                Expanded(
                  child: _buildMealCycleChip(
                    label: 'Last meal before',
                    mealType: _lastMealBefore,
                    onTap: () => _cycleMealType(isLastMeal: true),
                  ),
                ),
                const Gap(8),
                Expanded(
                  child: _buildMealCycleChip(
                    label: 'First meal after',
                    mealType: _firstMealAfter,
                    onTap: () => _cycleMealType(isLastMeal: false),
                  ),
                ),
              ],
            ),
            const Gap(16),

            // Compact reason field
            TextField(
              controller: _reasonController,
              maxLines: 1,
              style: AppTypography.bodyMedium.copyWith(
                color: Colors.white.withValues(alpha: 0.9),
              ),
              decoration: InputDecoration(
                hintText: 'Reason (optional)',
                hintStyle: TextStyle(
                  color: Colors.white.withValues(alpha: 0.3),
                ),
                isDense: true,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                filled: true,
                fillColor: Colors.white.withValues(alpha: 0.03),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                  borderSide: BorderSide(
                    color: Colors.white.withValues(alpha: 0.05),
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                  borderSide: BorderSide(
                    color: Colors.white.withValues(alpha: 0.05),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                  borderSide: BorderSide(
                    color: AppColors.success.withValues(alpha: 0.5),
                  ),
                ),
              ),
            ),
            const Gap(24),

            // Submit with duration summary
            AppPrimaryButton(
              text: 'Save $_durationLabel Vacation',
              icon: LucideIcons.check,
              onPressed: _submit,
            ),
            const Gap(12),
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
        HapticService.selectionTick();
        final picked = await showDatePicker(
          context: context,
          initialDate: date,
          firstDate: DateTime.now(),
          lastDate: DateTime.now().add(const Duration(days: 365)),
        );
        if (picked != null) onChanged(picked);
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
          child: Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: AppSpacing.accentCard(accent: AppColors.moneyPositive),
            child: Row(
              children: [
                const Icon(LucideIcons.calendar,
                    size: 16, color: AppColors.success),
                const Gap(6),
                Expanded(
                  child: Text('${date.day}/${date.month}/${date.year}',
                      style: AppTypography.labelMedium.copyWith(
                        color: Colors.white.withValues(alpha: 0.9),
                      )),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMealCycleChip({
    required String label,
    required MealType mealType,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            padding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: AppColors.success.withValues(alpha: 0.08),
              border: Border.all(
                color: AppColors.success.withValues(alpha: 0.2),
              ),
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            ),
            child: Row(
              children: [
                Icon(_mealIcon(mealType),
                    size: 16, color: AppColors.success),
                const Gap(6),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(label,
                          style: AppTypography.labelSmall.copyWith(
                            color: Colors.white.withValues(alpha: 0.3),
                          )),
                      Text(_mealLabel(mealType),
                          style: AppTypography.labelMedium.copyWith(
                            color: Colors.white.withValues(alpha: 0.9),
                            fontWeight: FontWeight.w600,
                          )),
                    ],
                  ),
                ),
                Icon(LucideIcons.refreshCw,
                    size: 12,
                    color: Colors.white.withValues(alpha: 0.3)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _submit() {
    HapticService.success();
    final currentId = ref.read(currentMemberIdProvider);
    final vacation = VacationPeriod(
      id: 'vac_${DateTime.now().millisecondsSinceEpoch}',
      memberId: currentId,
      startDate: _startDate,
      endDate: _endDate,
      lastMealBefore: _lastMealBefore,
      firstMealAfter: _firstMealAfter,
      reason: _reasonController.text.trim().isNotEmpty
          ? _reasonController.text.trim()
          : null,
    );

    ref.read(vacationsProvider.notifier).addVacation(vacation);
    Navigator.of(context).pop();
  }
}
