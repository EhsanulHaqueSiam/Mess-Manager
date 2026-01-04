import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:getwidget/getwidget.dart';

import 'package:mess_manager/core/theme/app_theme.dart';
import 'package:mess_manager/core/models/meal.dart';
import 'package:mess_manager/core/providers/members_provider.dart';
import 'package:mess_manager/core/services/haptic_service.dart';
import 'package:mess_manager/core/widgets/gf_components.dart';
import 'package:mess_manager/core/widgets/animated_widgets.dart';
import 'package:mess_manager/features/vacation/providers/vacation_provider.dart';
import 'package:mess_manager/features/vacation/providers/fixed_expenses_provider.dart';

/// Vacation Screen - Uses GetWidget + VelocityX + flutter_animate
class VacationScreen extends ConsumerWidget {
  const VacationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final myVacations = ref.watch(currentMemberVacationsProvider);
    final unpaidExpenses = ref.watch(unpaidExpensesProvider);
    final membersOnVacation = ref.watch(membersOnVacationProvider);
    final members = ref.watch(membersProvider);

    return Scaffold(
      appBar: AppBar(
        title: [
          const Icon(LucideIcons.palmtree, color: AppColors.success, size: 22),
          8.widthBox,
          'Vacation & Bills'.text.make(),
        ].hStack(),
      ),
      body: SingleChildScrollView(
        child: VStack([
          // Unpaid Expenses Alert
          if (unpaidExpenses.isNotEmpty) ...[
            _buildUnpaidExpensesCard(unpaidExpenses, ref),
            16.heightBox,
          ],

          // My Vacations
          HStack([
            'My Vacation'.text.xl.bold.color(AppColors.textPrimaryDark).make(),
            const Spacer(),
            GFIconButton(
              icon: const Icon(LucideIcons.plus, color: AppColors.success),
              type: GFButtonType.transparent,
              onPressed: () => _showAddVacationSheet(context),
            ),
          ]),
          8.heightBox,
          if (myVacations.isEmpty)
            EmptyStateWidget(
              icon: LucideIcons.palmtree,
              title: 'No vacation planned',
              subtitle: 'Add a vacation to skip meal notifications',
            )
          else
            ...myVacations.asMap().entries.map(
              (e) => _buildVacationCard(context, ref, e.value, e.key),
            ),
          24.heightBox,

          // Who's on vacation
          if (membersOnVacation.isNotEmpty) ...[
            'Currently on Vacation'.text.xl.bold
                .color(AppColors.textPrimaryDark)
                .make(),
            8.heightBox,
            Wrap(
              spacing: AppSpacing.sm,
              children: membersOnVacation.map((memberId) {
                final member = members.firstWhere(
                  (m) => m.id == memberId,
                  orElse: () => members.first,
                );
                return GFBadge(
                  text: member.name,
                  color: AppColors.success.withValues(alpha: 0.1),
                  textColor: AppColors.success,
                  shape: GFBadgeShape.pills,
                );
              }).toList(),
            ),
            24.heightBox,
          ],

          // Fixed Monthly Expenses
          _buildFixedExpensesSection(ref),
          32.heightBox,
        ]).p16(),
      ),
      floatingActionButton:
          FloatingActionButton.extended(
                onPressed: () {
                  HapticService.buttonPress();
                  _showAddVacationSheet(context);
                },
                backgroundColor: AppColors.success,
                icon: const Icon(LucideIcons.palmtree),
                label: const Text('Add Vacation'),
              )
              .animate(onPlay: (c) => c.repeat())
              .shimmer(
                duration: 2.seconds,
                color: Colors.white.withValues(alpha: 0.2),
              ),
    );
  }

  Widget _buildUnpaidExpensesCard(List<FixedExpense> expenses, WidgetRef ref) {
    final total = expenses.fold(0.0, (sum, e) => sum + e.amount);
    final memberCount = ref.watch(membersProvider).length;
    final perMember = memberCount > 0 ? total / memberCount : 0;

    return GFCard(
      padding: const EdgeInsets.all(AppSpacing.md),
      margin: EdgeInsets.zero,
      gradient: LinearGradient(
        colors: [AppColors.warning.withValues(alpha: 0.8), AppColors.warning],
      ),
      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      content: HStack([
        const Icon(LucideIcons.alertTriangle, color: Colors.white, size: 32),
        12.widthBox,
        VStack(crossAlignment: CrossAxisAlignment.start, [
          'Unpaid Bills'.text.lg.white.bold.make(),
          '${expenses.length} bills • ৳${total.toStringAsFixed(0)} total'
              .text
              .sm
              .white
              .make(),
          'Your share: ৳${perMember.toStringAsFixed(0)}'.text.lg.white.bold
              .make(),
        ]).expand(),
      ]),
    ).animate().fadeIn().shake();
  }

  Widget _buildVacationCard(
    BuildContext context,
    WidgetRef ref,
    VacationPeriod vacation,
    int index,
  ) {
    final isActive = vacation.isActive;

    return GFAppCard(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      borderColor: isActive
          ? AppColors.success.withValues(alpha: 0.5)
          : AppColors.borderDark,
      child: VStack(crossAlignment: CrossAxisAlignment.start, [
        HStack([
          Icon(
            isActive ? LucideIcons.check : LucideIcons.x,
            color: isActive ? AppColors.success : AppColors.textMutedDark,
            size: 18,
          ),
          8.widthBox,
          (vacation.reason ?? 'Vacation').text
              .color(AppColors.textPrimaryDark)
              .make()
              .expand(),
          GFToggle(
            value: isActive,
            onChanged: (_) =>
                ref.read(vacationsProvider.notifier).toggleActive(vacation.id),
            enabledThumbColor: AppColors.success,
            type: GFToggleType.ios,
          ),
        ]),
        8.heightBox,
        _buildDateChip(
          'From: ${_formatDateWithMeal(vacation.startDate, vacation.lastMealBefore)} (after)',
        ),
        4.heightBox,
        _buildDateChip(
          'To: ${_formatDateWithMeal(vacation.endDate, vacation.firstMealAfter)} (before)',
        ),
      ]),
    ).animate(delay: (80 * index).ms).fadeIn().slideX(begin: 0.03);
  }

  Widget _buildDateChip(String text) {
    return GFBadge(
      text: text,
      color: AppColors.surfaceDark,
      textColor: AppColors.textSecondaryDark,
      size: GFSize.SMALL,
      shape: GFBadgeShape.pills,
    );
  }

  String _formatDateWithMeal(DateTime date, MealType meal) {
    final mealName = switch (meal) {
      MealType.breakfast => 'সকাল',
      MealType.lunch => 'দুপুর',
      MealType.dinner => 'রাত',
    };
    return '${date.day}/${date.month}/${date.year} $mealName';
  }

  Widget _buildFixedExpensesSection(WidgetRef ref) {
    final expenses = ref.watch(currentMonthExpensesProvider);

    return VStack(crossAlignment: CrossAxisAlignment.start, [
      'Fixed Monthly Expenses'.text.xl.bold
          .color(AppColors.textPrimaryDark)
          .make(),
      4.heightBox,
      'These apply to everyone, even during vacation'.text.sm
          .color(AppColors.textMutedDark)
          .make(),
      12.heightBox,
      if (expenses.isEmpty)
        GFAppCard(
          child: 'No fixed expenses this month'.text
              .color(AppColors.textMutedDark)
              .center
              .make()
              .p16(),
        ),
      ...expenses.asMap().entries.map(
        (e) => _buildExpenseCard(ref, e.value, e.key),
      ),
    ]);
  }

  Widget _buildExpenseCard(WidgetRef ref, FixedExpense expense, int index) {
    final isPaid = expense.isPaid;
    final typeName = getExpenseTypeName(expense.type);
    final statusColor = isPaid ? AppColors.success : AppColors.warning;

    return GFAppCard(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      borderColor: statusColor.withValues(alpha: 0.5),
      child: HStack([
        GFAvatar(
          size: 40,
          backgroundColor: statusColor.withValues(alpha: 0.1),
          child: Icon(
            isPaid ? LucideIcons.check : LucideIcons.clock,
            color: statusColor,
            size: 18,
          ),
        ),
        12.widthBox,
        VStack(crossAlignment: CrossAxisAlignment.start, [
          typeName.text.color(AppColors.textPrimaryDark).make(),
          if (expense.description != null)
            expense.description!.text.sm
                .color(AppColors.textSecondaryDark)
                .make(),
        ]).expand(),
        '৳${expense.amount.toStringAsFixed(0)}'.text.lg
            .color(statusColor)
            .bold
            .make(),
      ]),
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
  MealType _lastMealBefore = MealType.lunch;
  MealType _firstMealAfter = MealType.dinner;
  final _reasonController = TextEditingController();

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

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
        child: VStack([
          // Handle
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.borderDark,
              borderRadius: BorderRadius.circular(2),
            ),
          ).centered(),
          16.heightBox,

          // Header
          HStack([
            const Icon(LucideIcons.palmtree, color: AppColors.success),
            8.widthBox,
            'Add Vacation'.text.xl.bold.color(AppColors.textPrimaryDark).make(),
          ]),
          16.heightBox,

          // Start Date
          'Starting from'.text.sm
              .color(AppColors.textSecondaryDark)
              .make()
              .wFull(context),
          8.heightBox,
          HStack([
            _buildDatePicker(
              'Date',
              _startDate,
              (d) => setState(() => _startDate = d),
            ).expand(),
            8.widthBox,
            _buildMealSelector(
              'Last meal',
              _lastMealBefore,
              (m) => setState(() => _lastMealBefore = m),
            ).expand(),
          ]),
          12.heightBox,

          // End Date
          'Returning on'.text.sm
              .color(AppColors.textSecondaryDark)
              .make()
              .wFull(context),
          8.heightBox,
          HStack([
            _buildDatePicker(
              'Date',
              _endDate,
              (d) => setState(() => _endDate = d),
            ).expand(),
            8.widthBox,
            _buildMealSelector(
              'First meal',
              _firstMealAfter,
              (m) => setState(() => _firstMealAfter = m),
            ).expand(),
          ]),
          16.heightBox,

          // Reason
          'Reason (optional)'.text.sm
              .color(AppColors.textSecondaryDark)
              .make()
              .wFull(context),
          8.heightBox,
          TextField(
            controller: _reasonController,
            decoration: const InputDecoration(hintText: 'বাড়ি যাচ্ছি...'),
          ),
          24.heightBox,

          // Submit
          GFPrimaryButton(
            text: 'Save Vacation',
            icon: LucideIcons.check,
            onPressed: _submit,
          ),
          12.heightBox,
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
        final picked = await showDatePicker(
          context: context,
          initialDate: date,
          firstDate: DateTime.now(),
          lastDate: DateTime.now().add(const Duration(days: 365)),
        );
        if (picked != null) onChanged(picked);
      },
      child: GFAppCard(
        child: HStack([
          const Icon(LucideIcons.calendar, size: 18, color: AppColors.success),
          8.widthBox,
          '${date.day}/${date.month}/${date.year}'.text
              .color(AppColors.textPrimaryDark)
              .make(),
        ]),
      ),
    );
  }

  Widget _buildMealSelector(
    String label,
    MealType selected,
    Function(MealType) onChanged,
  ) {
    return GFAppCard(
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
          onChanged: (v) => onChanged(v!),
        ),
      ),
    );
  }

  String _mealLabel(MealType type) => switch (type) {
    MealType.breakfast => 'সকাল',
    MealType.lunch => 'দুপুর',
    MealType.dinner => 'রাত',
  };

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
