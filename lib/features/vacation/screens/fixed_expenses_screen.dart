import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:gap/gap.dart';
import 'package:getwidget/getwidget.dart';

import 'package:mess_manager/core/theme/app_theme.dart';
import 'package:mess_manager/core/models/meal.dart';
import 'package:mess_manager/core/services/haptic_service.dart';
import 'package:mess_manager/core/widgets/gf_components.dart';
import 'package:mess_manager/features/vacation/providers/fixed_expenses_provider.dart';

/// Fixed Expenses Screen - Manage Rent, Wifi, Bua, etc.
class FixedExpensesScreen extends ConsumerWidget {
  const FixedExpensesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final expenses = ref.watch(currentMonthExpensesProvider);
    final perMember = ref.watch(fixedExpensePerMemberProvider);
    final now = DateTime.now();
    final monthName = _getMonthName(now.month);

    return Scaffold(
      appBar: AppBar(
        title: HStack([
          const Icon(
            LucideIcons.receipt,
            color: AppColors.textSecondaryDark,
            size: 22,
          ),
          const Gap(AppSpacing.sm),
          'Fixed Expenses'.text.make(),
        ]),
        actions: [
          GFIconButton(
            icon: const Icon(LucideIcons.plus, color: AppColors.primary),
            type: GFButtonType.transparent,
            onPressed: () => _showAddExpenseSheet(context, ref),
            tooltip: 'Add Expense',
          ),
        ],
      ),
      body: Column(
        children: [
          // Summary Card
          Container(
            margin: const EdgeInsets.all(AppSpacing.md),
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.warning.withValues(alpha: 0.15),
                  AppColors.warning.withValues(alpha: 0.05),
                ],
              ),
              borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
              border: Border.all(
                color: AppColors.warning.withValues(alpha: 0.3),
              ),
            ),
            child: HStack([
              VStack(crossAlignment: CrossAxisAlignment.start, [
                '$monthName Fixed Costs'.text.semiBold.make(),
                4.heightBox,
                '৳${expenses.fold(0.0, (sum, e) => sum + e.amount).toStringAsFixed(0)}'
                    .text
                    .xl2
                    .bold
                    .color(AppColors.warning)
                    .make(),
              ]).expand(),
              Container(
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: AppColors.surfaceDark,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                ),
                child: VStack(crossAlignment: CrossAxisAlignment.center, [
                  '৳${perMember.toStringAsFixed(0)}'.text.lg.bold.make(),
                  'Per Member'.text.xs.gray500.make(),
                ]),
              ),
            ]),
          ).animate().fadeIn().slideY(begin: -0.05),

          // Expense List
          Expanded(
            child: expenses.isEmpty
                ? _buildEmptyState(context, ref)
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md,
                    ),
                    itemCount: expenses.length,
                    itemBuilder: (context, index) {
                      final expense = expenses[index];
                      return _buildExpenseCard(context, ref, expense, index);
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          HapticService.buttonPress();
          _showAddExpenseSheet(context, ref);
        },
        icon: const Icon(LucideIcons.plus),
        label: 'Add Expense'.text.bold.make(),
        backgroundColor: AppColors.warning,
      ).animate().scale(delay: 300.ms),
    );
  }

  Widget _buildEmptyState(BuildContext context, WidgetRef ref) {
    return Center(
      child: VStack(crossAlignment: CrossAxisAlignment.center, [
        const Icon(
          LucideIcons.receipt,
          size: 64,
          color: AppColors.textMutedDark,
        ),
        16.heightBox,
        'No Fixed Expenses'.text.xl.semiBold.gray500.make(),
        8.heightBox,
        'Add recurring costs like Rent, Wifi, Bua'.text.sm.gray500.center
            .make(),
        24.heightBox,
        GFButton(
          onPressed: () => _showAddExpenseSheet(context, ref),
          text: 'Add First Expense',
          icon: const Icon(LucideIcons.plus, color: Colors.white, size: 18),
          color: AppColors.warning,
        ),
      ]),
    ).animate().fadeIn();
  }

  Widget _buildExpenseCard(
    BuildContext context,
    WidgetRef ref,
    FixedExpense expense,
    int index,
  ) {
    final icon = _getExpenseIcon(expense.type);
    final color = expense.isPaid ? AppColors.success : AppColors.warning;

    return Slidable(
      key: Key(expense.id),
      endActionPane: ActionPane(
        motion: const DrawerMotion(),
        children: [
          SlidableAction(
            onPressed: (_) async {
              final confirm = await _confirmDelete(context);
              if (confirm) {
                final deletedExpense = expense;
                HapticService.warning();
                ref
                    .read(fixedExpensesProvider.notifier)
                    .removeExpense(expense.id);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      '${getExpenseTypeName(expense.type)} deleted',
                    ),
                    action: SnackBarAction(
                      label: 'Undo',
                      textColor: AppColors.warning,
                      onPressed: () {
                        ref
                            .read(fixedExpensesProvider.notifier)
                            .addExpense(deletedExpense);
                      },
                    ),
                    backgroundColor: AppColors.cardDark,
                    duration: const Duration(seconds: 4),
                  ),
                );
              }
            },
            backgroundColor: AppColors.error,
            foregroundColor: Colors.white,
            icon: LucideIcons.trash2,
            label: 'Delete',
            borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
          ),
        ],
      ),
      child: GFCard(
        margin: const EdgeInsets.only(bottom: AppSpacing.sm),
        padding: const EdgeInsets.all(AppSpacing.md),
        color: AppColors.cardDark,
        border: Border.all(color: color.withValues(alpha: 0.3)),
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        content: HStack([
          // Icon
          Container(
            padding: const EdgeInsets.all(AppSpacing.sm),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          12.widthBox,

          // Details
          VStack(crossAlignment: CrossAxisAlignment.start, [
            HStack([
              getExpenseTypeName(expense.type).text.semiBold.make().expand(),
              if (expense.isPaid)
                GFBadge(
                  text: 'Paid',
                  color: AppColors.success,
                  size: GFSize.SMALL,
                ),
            ]),
            if (expense.description != null && expense.description!.isNotEmpty)
              expense.description!.text.xs.gray500.make(),
            4.heightBox,
            'Due: ${_formatDate(expense.dueDate)}'.text.xs.gray400.make(),
          ]).expand(),

          // Amount & Actions
          VStack(crossAlignment: CrossAxisAlignment.end, [
            '৳${expense.amount.toStringAsFixed(0)}'.text.lg.bold
                .color(color)
                .make(),
            8.heightBox,
            if (!expense.isPaid)
              GFButton(
                onPressed: () {
                  HapticService.success();
                  ref
                      .read(fixedExpensesProvider.notifier)
                      .markPaid(expense.id, 'current');
                  showSuccessToast(context, 'Marked as paid!');
                },
                text: 'Pay',
                size: GFSize.SMALL,
                color: AppColors.success,
              ),
          ]),
        ]),
      ).animate(delay: (index * 50).ms).fadeIn().slideX(begin: 0.05),
    );
  }

  void _showAddExpenseSheet(BuildContext context, WidgetRef ref) {
    HapticService.modalOpen();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _AddExpenseSheet(ref: ref),
    );
  }

  Future<bool> _confirmDelete(BuildContext context) async {
    return await showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            backgroundColor: AppColors.surfaceDark,
            title: 'Delete Expense?'.text.bold.make(),
            content: 'This action cannot be undone.'.text.make(),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx, false),
                child: 'Cancel'.text.make(),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.error,
                ),
                onPressed: () => Navigator.pop(ctx, true),
                child: 'Delete'.text.bold.make(),
              ),
            ],
          ),
        ) ??
        false;
  }

  IconData _getExpenseIcon(FixedExpenseType type) {
    switch (type) {
      case FixedExpenseType.rent:
        return LucideIcons.home;
      case FixedExpenseType.wifi:
        return LucideIcons.wifi;
      case FixedExpenseType.bua:
        return LucideIcons.userCheck;
      case FixedExpenseType.electricity:
        return LucideIcons.zap;
      case FixedExpenseType.gas:
        return LucideIcons.flame;
      case FixedExpenseType.water:
        return LucideIcons.droplet;
      case FixedExpenseType.emergency:
        return LucideIcons.alertTriangle;
      case FixedExpenseType.other:
        return LucideIcons.moreHorizontal;
    }
  }

  String _formatDate(DateTime dt) {
    return '${dt.day}/${dt.month}/${dt.year}';
  }

  String _getMonthName(int month) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return months[month - 1];
  }
}

/// Add Expense Sheet
class _AddExpenseSheet extends ConsumerStatefulWidget {
  final WidgetRef ref;

  const _AddExpenseSheet({required this.ref});

  @override
  ConsumerState<_AddExpenseSheet> createState() => _AddExpenseSheetState();
}

class _AddExpenseSheetState extends ConsumerState<_AddExpenseSheet> {
  FixedExpenseType _selectedType = FixedExpenseType.rent;
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();
  DateTime _dueDate = DateTime.now();

  @override
  void dispose() {
    _amountController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      decoration: BoxDecoration(
        color: AppColors.surfaceDark,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(AppSpacing.radiusLg),
        ),
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
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
            'Add Fixed Expense'.text.xl.bold.make(),
            const Gap(AppSpacing.lg),

            // Type Selection
            'Expense Type'.text.sm.gray500.make(),
            const Gap(AppSpacing.sm),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: FixedExpenseType.values.map((type) {
                final isSelected = type == _selectedType;
                return GFButton(
                  onPressed: () {
                    HapticService.lightTap();
                    setState(() => _selectedType = type);
                  },
                  text: getExpenseTypeName(type),
                  type: isSelected ? GFButtonType.solid : GFButtonType.outline,
                  color: isSelected
                      ? AppColors.warning
                      : AppColors.textSecondaryDark,
                  size: GFSize.SMALL,
                );
              }).toList(),
            ),
            const Gap(AppSpacing.lg),

            // Amount
            'Amount (৳)'.text.sm.gray500.make(),
            const Gap(AppSpacing.sm),
            TextFormField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                hintText: 'Enter amount',
                prefixIcon: Icon(LucideIcons.banknote),
              ),
            ),
            const Gap(AppSpacing.lg),

            // Description
            'Description (optional)'.text.sm.gray500.make(),
            const Gap(AppSpacing.sm),
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                hintText: 'e.g., January Rent',
                prefixIcon: Icon(LucideIcons.text),
              ),
            ),
            const Gap(AppSpacing.lg),

            // Due Date
            'Due Date'.text.sm.gray500.make(),
            const Gap(AppSpacing.sm),
            GestureDetector(
              onTap: _pickDueDate,
              child: Container(
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: AppColors.cardDark,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                  border: Border.all(color: AppColors.borderDark),
                ),
                child: HStack([
                  const Icon(
                    LucideIcons.calendar,
                    size: 20,
                    color: AppColors.textSecondaryDark,
                  ),
                  12.widthBox,
                  '${_dueDate.day}/${_dueDate.month}/${_dueDate.year}'.text
                      .make()
                      .expand(),
                  const Icon(
                    LucideIcons.chevronDown,
                    size: 20,
                    color: AppColors.textSecondaryDark,
                  ),
                ]),
              ),
            ),
            const Gap(AppSpacing.xl),

            // Submit Button
            GFButton(
              onPressed: _submit,
              text: 'Add Expense',
              icon: const Icon(LucideIcons.plus, color: Colors.white),
              fullWidthButton: true,
              color: AppColors.warning,
            ),
            const Gap(AppSpacing.md),
          ],
        ),
      ),
    );
  }

  Future<void> _pickDueDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _dueDate,
      firstDate: DateTime.now().subtract(const Duration(days: 30)),
      lastDate: DateTime.now().add(const Duration(days: 60)),
    );
    if (picked != null) {
      setState(() => _dueDate = picked);
    }
  }

  void _submit() {
    final amount = double.tryParse(_amountController.text);
    if (amount == null || amount <= 0) {
      showErrorToast(context, 'Please enter a valid amount');
      return;
    }

    HapticService.success();
    final now = DateTime.now();
    final expense = FixedExpense(
      id: 'fix_${DateTime.now().millisecondsSinceEpoch}',
      type: _selectedType,
      amount: amount,
      dueDate: _dueDate,
      month: now.month,
      year: now.year,
      description: _descriptionController.text.trim().isEmpty
          ? null
          : _descriptionController.text.trim(),
    );

    widget.ref.read(fixedExpensesProvider.notifier).addExpense(expense);
    Navigator.pop(context);
    showSuccessToast(context, 'Expense added!');
  }
}
