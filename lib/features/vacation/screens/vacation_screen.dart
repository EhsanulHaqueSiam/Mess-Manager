import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:gap/gap.dart';
import 'package:mess_manager/core/theme/app_theme.dart';
import 'package:mess_manager/core/models/meal.dart';
import 'package:mess_manager/core/providers/members_provider.dart';
import 'package:mess_manager/features/vacation/providers/vacation_provider.dart';
import 'package:mess_manager/features/vacation/providers/fixed_expenses_provider.dart';

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
        title: Row(
          children: [
            const Icon(
              LucideIcons.palmtree,
              color: AppColors.success,
              size: 22,
            ),
            const Gap(AppSpacing.sm),
            const Text('Vacation & Bills'),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ⚠️ Unpaid Fixed Expenses Alert
            if (unpaidExpenses.isNotEmpty) ...[
              _buildUnpaidExpensesCard(unpaidExpenses, ref),
              const Gap(AppSpacing.lg),
            ],

            // 🏖️ My Vacations
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'My Vacation',
                  style: AppTypography.headlineSmall.copyWith(
                    color: AppColors.textPrimaryDark,
                  ),
                ),
                IconButton(
                  icon: const Icon(LucideIcons.plus),
                  onPressed: () => _showAddVacationSheet(context),
                ),
              ],
            ),
            const Gap(AppSpacing.sm),
            if (myVacations.isEmpty)
              _buildEmptyVacation()
            else
              ...myVacations.asMap().entries.map(
                (e) => _buildVacationCard(context, ref, e.value, e.key),
              ),
            const Gap(AppSpacing.xl),

            // 🧑‍🤝‍🧑 Who's on vacation
            if (membersOnVacation.isNotEmpty) ...[
              Text(
                'Currently on Vacation',
                style: AppTypography.headlineSmall.copyWith(
                  color: AppColors.textPrimaryDark,
                ),
              ),
              const Gap(AppSpacing.sm),
              Wrap(
                spacing: AppSpacing.sm,
                children: membersOnVacation.map((memberId) {
                  final member = members.firstWhere(
                    (m) => m.id == memberId,
                    orElse: () => members.first,
                  );
                  return Chip(
                    avatar: CircleAvatar(
                      backgroundColor: AppColors.success.withValues(alpha: 0.2),
                      child: Text(member.name[0]),
                    ),
                    label: Text(member.name),
                    backgroundColor: AppColors.cardDark,
                  );
                }).toList(),
              ),
              const Gap(AppSpacing.xl),
            ],

            // 💰 Fixed Monthly Expenses
            _buildFixedExpensesSection(ref),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddVacationSheet(context),
        backgroundColor: AppColors.success,
        icon: const Icon(LucideIcons.palmtree),
        label: const Text('Add Vacation'),
      ),
    );
  }

  Widget _buildUnpaidExpensesCard(List<FixedExpense> expenses, WidgetRef ref) {
    final total = expenses.fold(0.0, (sum, e) => sum + e.amount);
    final memberCount = ref.watch(membersProvider).length;
    final perMember = memberCount > 0 ? total / memberCount : 0;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.warning.withValues(alpha: 0.8), AppColors.warning],
        ),
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      ),
      child: Row(
        children: [
          const Icon(LucideIcons.alertTriangle, color: Colors.white, size: 32),
          const Gap(AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Unpaid Bills',
                  style: AppTypography.titleMedium.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  '${expenses.length} bills • ৳${total.toStringAsFixed(0)} total',
                  style: AppTypography.bodySmall.copyWith(
                    color: Colors.white.withValues(alpha: 0.8),
                  ),
                ),
                Text(
                  'Your share: ৳${perMember.toStringAsFixed(0)}',
                  style: AppTypography.labelMedium.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn().shake();
  }

  Widget _buildEmptyVacation() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.cardDark,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      ),
      child: Row(
        children: [
          Icon(LucideIcons.palmtree, color: AppColors.textMutedDark, size: 32),
          const Gap(AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'No vacation planned',
                  style: AppTypography.titleSmall.copyWith(
                    color: AppColors.textSecondaryDark,
                  ),
                ),
                Text(
                  'Add a vacation to skip meal notifications',
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textMutedDark,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVacationCard(
    BuildContext context,
    WidgetRef ref,
    VacationPeriod vacation,
    int index,
  ) {
    final isActive = vacation.isActive;

    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.cardDark,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        border: Border.all(
          color: isActive
              ? AppColors.success.withValues(alpha: 0.5)
              : AppColors.borderDark,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                isActive ? LucideIcons.check : LucideIcons.x,
                color: isActive ? AppColors.success : AppColors.textMutedDark,
                size: 18,
              ),
              const Gap(AppSpacing.sm),
              Expanded(
                child: Text(
                  vacation.reason ?? 'Vacation',
                  style: AppTypography.titleSmall.copyWith(
                    color: AppColors.textPrimaryDark,
                  ),
                ),
              ),
              Switch(
                value: isActive,
                onChanged: (_) => ref
                    .read(vacationsProvider.notifier)
                    .toggleActive(vacation.id),
                activeThumbColor: AppColors.success,
              ),
            ],
          ),
          const Gap(AppSpacing.sm),
          Row(
            children: [
              _buildDateChip(
                'From: ${_formatDateWithMeal(vacation.startDate, vacation.lastMealBefore)} (after)',
              ),
            ],
          ),
          const Gap(AppSpacing.xs),
          Row(
            children: [
              _buildDateChip(
                'To: ${_formatDateWithMeal(vacation.endDate, vacation.firstMealAfter)} (before)',
              ),
            ],
          ),
        ],
      ),
    ).animate(delay: (80 * index).ms).fadeIn().slideX(begin: 0.03);
  }

  Widget _buildDateChip(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.surfaceDark,
        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
      ),
      child: Text(
        text,
        style: AppTypography.labelSmall.copyWith(
          color: AppColors.textSecondaryDark,
        ),
      ),
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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Fixed Monthly Expenses',
          style: AppTypography.headlineSmall.copyWith(
            color: AppColors.textPrimaryDark,
          ),
        ),
        const Gap(AppSpacing.xs),
        Text(
          'These apply to everyone, even during vacation',
          style: AppTypography.bodySmall.copyWith(
            color: AppColors.textMutedDark,
          ),
        ),
        const Gap(AppSpacing.md),
        ...expenses.asMap().entries.map(
          (e) => _buildExpenseCard(ref, e.value, e.key),
        ),
        if (expenses.isEmpty)
          Container(
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(
              color: AppColors.cardDark,
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            ),
            child: Center(
              child: Text(
                'No fixed expenses this month',
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.textMutedDark,
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildExpenseCard(WidgetRef ref, FixedExpense expense, int index) {
    final isPaid = expense.isPaid;
    final typeName = getExpenseTypeName(expense.type);

    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.cardDark,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        border: Border.all(
          color: isPaid
              ? AppColors.success.withValues(alpha: 0.5)
              : AppColors.warning.withValues(alpha: 0.5),
        ),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: isPaid
                ? AppColors.success.withValues(alpha: 0.1)
                : AppColors.warning.withValues(alpha: 0.1),
            child: Icon(
              isPaid ? LucideIcons.check : LucideIcons.clock,
              color: isPaid ? AppColors.success : AppColors.warning,
              size: 18,
            ),
          ),
          const Gap(AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  typeName,
                  style: AppTypography.titleSmall.copyWith(
                    color: AppColors.textPrimaryDark,
                  ),
                ),
                if (expense.description != null)
                  Text(
                    expense.description!,
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.textSecondaryDark,
                    ),
                  ),
              ],
            ),
          ),
          Text(
            '৳${expense.amount.toStringAsFixed(0)}',
            style: AppTypography.titleMedium.copyWith(
              color: isPaid ? AppColors.success : AppColors.warning,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    ).animate(delay: (80 * index).ms).fadeIn().slideX(begin: 0.03);
  }

  void _showAddVacationSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const AddVacationSheet(),
    );
  }
}

// ===================== Add Vacation Sheet =====================

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
            Row(
              children: [
                const Icon(LucideIcons.palmtree, color: AppColors.success),
                const Gap(AppSpacing.sm),
                Text(
                  'Add Vacation',
                  style: AppTypography.headlineMedium.copyWith(
                    color: AppColors.textPrimaryDark,
                  ),
                ),
              ],
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
            Row(
              children: [
                Expanded(
                  child: _buildDatePicker(
                    'Date',
                    _startDate,
                    (d) => setState(() => _startDate = d),
                  ),
                ),
                const Gap(AppSpacing.sm),
                Expanded(
                  child: _buildMealSelector(
                    'Last meal',
                    _lastMealBefore,
                    (m) => setState(() => _lastMealBefore = m),
                  ),
                ),
              ],
            ),
            const Gap(AppSpacing.md),

            // End Date
            Text(
              'Returning on',
              style: AppTypography.labelMedium.copyWith(
                color: AppColors.textSecondaryDark,
              ),
            ),
            const Gap(AppSpacing.sm),
            Row(
              children: [
                Expanded(
                  child: _buildDatePicker(
                    'Date',
                    _endDate,
                    (d) => setState(() => _endDate = d),
                  ),
                ),
                const Gap(AppSpacing.sm),
                Expanded(
                  child: _buildMealSelector(
                    'First meal',
                    _firstMealAfter,
                    (m) => setState(() => _firstMealAfter = m),
                  ),
                ),
              ],
            ),
            const Gap(AppSpacing.lg),

            // Reason
            Text(
              'Reason (optional)',
              style: AppTypography.labelMedium.copyWith(
                color: AppColors.textSecondaryDark,
              ),
            ),
            const Gap(AppSpacing.sm),
            TextField(
              controller: _reasonController,
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.textPrimaryDark,
              ),
              decoration: const InputDecoration(hintText: 'বাড়ি যাচ্ছি...'),
            ),
            const Gap(AppSpacing.xl),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _submit,
                icon: const Icon(LucideIcons.check),
                label: const Text('Save Vacation'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.success,
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
              color: AppColors.success,
            ),
            const Gap(AppSpacing.sm),
            Text(
              '${date.day}/${date.month}/${date.year}',
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.textPrimaryDark,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMealSelector(
    String label,
    MealType selected,
    Function(MealType) onChanged,
  ) {
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
          onChanged: (v) => onChanged(v!),
        ),
      ),
    );
  }

  String _mealLabel(MealType type) {
    return switch (type) {
      MealType.breakfast => 'সকাল',
      MealType.lunch => 'দুপুর',
      MealType.dinner => 'রাত',
    };
  }

  void _submit() {
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
