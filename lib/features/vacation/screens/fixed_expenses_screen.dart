import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:gap/gap.dart';

import 'package:mess_manager/core/theme/app_theme.dart';
import 'package:mess_manager/core/models/meal.dart';
import 'package:mess_manager/core/services/haptic_service.dart';
import 'package:mess_manager/core/widgets/app_components.dart';
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
                          LucideIcons.receipt,
                          color: AppColors.warning,
                          size: 22,
                        ),
                      ),
                      const Gap(10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Fixed Expenses',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white.withValues(alpha: 0.9),
                              ),
                            ),
                            Text(
                              'Rent, Wifi, Bua & more',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.white.withValues(alpha: 0.5),
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(
                            LucideIcons.plus, color: AppColors.primary),
                        onPressed: () => _showAddExpenseSheet(context, ref),
                        tooltip: 'Add Expense',
                      ),
                    ],
                  ),
                ),

                // Summary Card — glass
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                    vertical: AppSpacing.sm,
                  ),
                  child: ClipRRect(
                    borderRadius:
                        BorderRadius.circular(AppSpacing.radiusLg),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                      child: Container(
                        padding: const EdgeInsets.all(AppSpacing.lg),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              AppColors.warning.withValues(alpha: 0.12),
                              AppColors.warning.withValues(alpha: 0.04),
                            ],
                          ),
                          borderRadius:
                              BorderRadius.circular(AppSpacing.radiusLg),
                          border: Border.all(
                            color:
                                AppColors.warning.withValues(alpha: 0.2),
                          ),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '$monthName Fixed Costs',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white
                                          .withValues(alpha: 0.9),
                                    ),
                                  ),
                                  const Gap(4),
                                  Text(
                                    '${expenses.fold(0.0, (sum, e) => sum + e.amount).toStringAsFixed(0)}',
                                    style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.warning,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding:
                                  const EdgeInsets.all(AppSpacing.md),
                              decoration: BoxDecoration(
                                color: const Color(0xFF0D1520),
                                borderRadius: BorderRadius.circular(
                                    AppSpacing.radiusMd),
                              ),
                              child: Column(
                                children: [
                                  Text(
                                    '${perMember.toStringAsFixed(0)}',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white
                                          .withValues(alpha: 0.9),
                                    ),
                                  ),
                                  Text(
                                    'Per Member',
                                    style: TextStyle(
                                      fontSize: 10,
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
                  ),
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
                            return _buildExpenseCard(
                                context, ref, expense, index);
                          },
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
              _showAddExpenseSheet(context, ref);
            },
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(LucideIcons.plus, color: Colors.white, size: 20),
                  const Gap(8),
                  const Text(
                    'Add Expense',
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
          .scale(delay: 300.ms)
          .shimmer(delay: 700.ms, duration: 1500.ms),
    );
  }

  Widget _buildEmptyState(BuildContext context, WidgetRef ref) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            LucideIcons.receipt,
            size: 64,
            color: Colors.white.withValues(alpha: 0.15),
          ),
          const Gap(16),
          Text(
            'No Fixed Expenses',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.white.withValues(alpha: 0.5),
            ),
          ),
          const Gap(8),
          Text(
            'Add recurring costs like Rent, Wifi, Bua',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              color: Colors.white.withValues(alpha: 0.5),
            ),
          ),
          const Gap(24),
          FilledButton.icon(
            onPressed: () => _showAddExpenseSheet(context, ref),
            icon: const Icon(LucideIcons.plus, size: 18),
            label: const Text('Add First Expense'),
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.warning,
            ),
          ),
        ],
      ),
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
                    backgroundColor: const Color(0xFF0D1520),
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
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
          child: Container(
            margin: const EdgeInsets.only(bottom: AppSpacing.sm),
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.03),
              border: Border.all(
                color: color.withValues(alpha: 0.2),
              ),
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            ),
            child: Row(
              children: [
                // Icon
                Container(
                  padding: const EdgeInsets.all(AppSpacing.sm),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.12),
                    borderRadius:
                        BorderRadius.circular(AppSpacing.radiusSm),
                  ),
                  child: Icon(icon, color: color, size: 24),
                ),
                const Gap(12),

                // Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              getExpenseTypeName(expense.type),
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Colors.white
                                    .withValues(alpha: 0.9),
                              ),
                            ),
                          ),
                          if (expense.isPaid) AppBadge.success('Paid'),
                        ],
                      ),
                      if (expense.description != null &&
                          expense.description!.isNotEmpty)
                        Text(
                          expense.description!,
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.white
                                .withValues(alpha: 0.5),
                          ),
                        ),
                      const Gap(4),
                      Text(
                        'Due: ${_formatDate(expense.dueDate)}',
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.white
                              .withValues(alpha: 0.3),
                        ),
                      ),
                    ],
                  ),
                ),

                // Amount & Actions
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '${expense.amount.toStringAsFixed(0)}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: color,
                      ),
                    ),
                    const Gap(8),
                    if (!expense.isPaid)
                      FilledButton(
                        onPressed: () {
                          HapticService.success();
                          ref
                              .read(fixedExpensesProvider.notifier)
                              .markPaid(expense.id, 'current');
                          showSuccessToast(context, 'Marked as paid!');
                        },
                        style: FilledButton.styleFrom(
                          backgroundColor: AppColors.success,
                          minimumSize: const Size(0, 32),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 4,
                          ),
                        ),
                        child: const Text(
                            'Pay', style: TextStyle(fontSize: 12)),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
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
            backgroundColor: const Color(0xFF0D1520),
            title: Text(
              'Delete Expense?',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white.withValues(alpha: 0.9),
              ),
            ),
            content: Text(
              'This action cannot be undone.',
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.5),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx, false),
                child: Text(
                  'Cancel',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.5),
                  ),
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.error,
                ),
                onPressed: () => Navigator.pop(ctx, true),
                child: const Text(
                  'Delete',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
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
      decoration: const BoxDecoration(
        color: Color(0xFF0D1520),
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppSpacing.radiusLg),
        ),
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
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
            const Gap(AppSpacing.lg),

            // Title
            Text(
              'Add Fixed Expense',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white.withValues(alpha: 0.9),
              ),
            ),
            const Gap(AppSpacing.lg),

            // Type Selection
            Text(
              'Expense Type',
              style: TextStyle(
                fontSize: 12,
                color: Colors.white.withValues(alpha: 0.5),
              ),
            ),
            const Gap(AppSpacing.sm),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: FixedExpenseType.values.map((type) {
                final isSelected = type == _selectedType;
                return isSelected
                    ? FilledButton(
                        onPressed: () {
                          HapticService.lightTap();
                          setState(() => _selectedType = type);
                        },
                        style: FilledButton.styleFrom(
                          backgroundColor: AppColors.warning,
                          minimumSize: const Size(0, 32),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 4,
                          ),
                        ),
                        child: Text(
                          getExpenseTypeName(type),
                          style: const TextStyle(fontSize: 12),
                        ),
                      )
                    : OutlinedButton(
                        onPressed: () {
                          HapticService.lightTap();
                          setState(() => _selectedType = type);
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor:
                              Colors.white.withValues(alpha: 0.5),
                          side: BorderSide(
                            color:
                                Colors.white.withValues(alpha: 0.15),
                          ),
                          minimumSize: const Size(0, 32),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 4,
                          ),
                        ),
                        child: Text(
                          getExpenseTypeName(type),
                          style: const TextStyle(fontSize: 12),
                        ),
                      );
              }).toList(),
            ),
            const Gap(AppSpacing.lg),

            // Amount
            Text(
              'Amount (\u09F3)',
              style: TextStyle(
                fontSize: 12,
                color: Colors.white.withValues(alpha: 0.5),
              ),
            ),
            const Gap(AppSpacing.sm),
            TextFormField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.9),
              ),
              decoration: InputDecoration(
                hintText: 'Enter amount',
                hintStyle: TextStyle(
                  color: Colors.white.withValues(alpha: 0.3),
                ),
                prefixIcon: Icon(
                  LucideIcons.banknote,
                  color: Colors.white.withValues(alpha: 0.5),
                ),
                filled: true,
                fillColor: Colors.white.withValues(alpha: 0.03),
                border: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(AppSpacing.radiusMd),
                  borderSide: BorderSide(
                    color: Colors.white.withValues(alpha: 0.06),
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(AppSpacing.radiusMd),
                  borderSide: BorderSide(
                    color: Colors.white.withValues(alpha: 0.06),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(AppSpacing.radiusMd),
                  borderSide: BorderSide(
                    color: AppColors.warning.withValues(alpha: 0.5),
                  ),
                ),
              ),
            ),
            const Gap(AppSpacing.lg),

            // Description
            Text(
              'Description (optional)',
              style: TextStyle(
                fontSize: 12,
                color: Colors.white.withValues(alpha: 0.5),
              ),
            ),
            const Gap(AppSpacing.sm),
            TextFormField(
              controller: _descriptionController,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.9),
              ),
              decoration: InputDecoration(
                hintText: 'e.g., January Rent',
                hintStyle: TextStyle(
                  color: Colors.white.withValues(alpha: 0.3),
                ),
                prefixIcon: Icon(
                  LucideIcons.text,
                  color: Colors.white.withValues(alpha: 0.5),
                ),
                filled: true,
                fillColor: Colors.white.withValues(alpha: 0.03),
                border: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(AppSpacing.radiusMd),
                  borderSide: BorderSide(
                    color: Colors.white.withValues(alpha: 0.06),
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(AppSpacing.radiusMd),
                  borderSide: BorderSide(
                    color: Colors.white.withValues(alpha: 0.06),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(AppSpacing.radiusMd),
                  borderSide: BorderSide(
                    color: AppColors.warning.withValues(alpha: 0.5),
                  ),
                ),
              ),
            ),
            const Gap(AppSpacing.lg),

            // Due Date
            Text(
              'Due Date',
              style: TextStyle(
                fontSize: 12,
                color: Colors.white.withValues(alpha: 0.5),
              ),
            ),
            const Gap(AppSpacing.sm),
            GestureDetector(
              onTap: _pickDueDate,
              child: Container(
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.03),
                  borderRadius:
                      BorderRadius.circular(AppSpacing.radiusSm),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.06),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      LucideIcons.calendar,
                      size: 20,
                      color: Colors.white.withValues(alpha: 0.5),
                    ),
                    const Gap(12),
                    Expanded(
                      child: Text(
                        '${_dueDate.day}/${_dueDate.month}/${_dueDate.year}',
                        style: TextStyle(
                          color: Colors.white
                              .withValues(alpha: 0.9),
                        ),
                      ),
                    ),
                    Icon(
                      LucideIcons.chevronDown,
                      size: 20,
                      color: Colors.white.withValues(alpha: 0.5),
                    ),
                  ],
                ),
              ),
            ),
            const Gap(AppSpacing.xl),

            // Submit Button
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: _submit,
                icon: const Icon(LucideIcons.plus),
                label: const Text('Add Expense'),
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.warning,
                ),
              ),
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
