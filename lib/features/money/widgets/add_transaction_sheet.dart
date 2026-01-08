import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:gap/gap.dart';
import 'package:uuid/uuid.dart';
import 'package:mess_manager/core/theme/app_theme.dart';
import 'package:mess_manager/core/models/money_transaction.dart';
import 'package:mess_manager/core/providers/members_provider.dart';
import 'package:mess_manager/features/money/providers/money_provider.dart';
import 'package:mess_manager/core/services/haptic_service.dart';

class AddTransactionSheet extends ConsumerStatefulWidget {
  final MoneyTransaction? existingTransaction;

  const AddTransactionSheet({super.key, this.existingTransaction});

  @override
  ConsumerState<AddTransactionSheet> createState() =>
      _AddTransactionSheetState();
}

class _AddTransactionSheetState extends ConsumerState<AddTransactionSheet> {
  late final TextEditingController _amountController;
  late final TextEditingController _descController;
  String? _fromMemberId;
  String? _toMemberId;

  bool get _isEditing => widget.existingTransaction != null;

  @override
  void initState() {
    super.initState();
    final existing = widget.existingTransaction;
    _amountController = TextEditingController(
      text: existing?.amount.toStringAsFixed(0) ?? '',
    );
    _descController = TextEditingController(text: existing?.description ?? '');
    _fromMemberId = existing?.fromMemberId;
    _toMemberId = existing?.toMemberId;
  }

  @override
  void dispose() {
    _amountController.dispose();
    _descController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final members = ref.watch(membersProvider);
    final currentId = ref.watch(currentMemberIdProvider);

    // Default from to current user
    _fromMemberId ??= currentId;

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
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
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
            Row(
              children: [
                Icon(
                  _isEditing ? LucideIcons.edit2 : LucideIcons.arrowLeftRight,
                  color: AppColors.accentWarm,
                ),
                const Gap(AppSpacing.sm),
                Text(
                  _isEditing ? 'Edit Transaction' : 'Add Transaction',
                  style: AppTypography.headlineMedium.copyWith(
                    color: AppColors.textPrimaryDark,
                  ),
                ),
              ],
            ),
            const Gap(AppSpacing.lg),

            // From Member
            Text(
              'From',
              style: AppTypography.labelMedium.copyWith(
                color: AppColors.textSecondaryDark,
              ),
            ),
            const Gap(AppSpacing.xs),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
              decoration: BoxDecoration(
                color: AppColors.cardDark,
                borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _fromMemberId,
                  isExpanded: true,
                  dropdownColor: AppColors.cardDark,
                  items: members
                      .map(
                        (m) => DropdownMenuItem(
                          value: m.id,
                          child: Text(
                            m.name,
                            style: AppTypography.bodyMedium.copyWith(
                              color: AppColors.textPrimaryDark,
                            ),
                          ),
                        ),
                      )
                      .toList(),
                  onChanged: (v) {
                    HapticService.selectionTick();
                    setState(() => _fromMemberId = v);
                  },
                ),
              ),
            ),
            const Gap(AppSpacing.md),

            // To Member
            Text(
              'To',
              style: AppTypography.labelMedium.copyWith(
                color: AppColors.textSecondaryDark,
              ),
            ),
            const Gap(AppSpacing.xs),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
              decoration: BoxDecoration(
                color: AppColors.cardDark,
                borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _toMemberId,
                  hint: Text(
                    'Select member',
                    style: AppTypography.bodyMedium.copyWith(
                      color: AppColors.textMutedDark,
                    ),
                  ),
                  isExpanded: true,
                  dropdownColor: AppColors.cardDark,
                  items: members
                      .where((m) => m.id != _fromMemberId)
                      .map(
                        (m) => DropdownMenuItem(
                          value: m.id,
                          child: Text(
                            m.name,
                            style: AppTypography.bodyMedium.copyWith(
                              color: AppColors.textPrimaryDark,
                            ),
                          ),
                        ),
                      )
                      .toList(),
                  onChanged: (v) {
                    HapticService.selectionTick();
                    setState(() => _toMemberId = v);
                  },
                ),
              ),
            ),
            const Gap(AppSpacing.md),

            // Amount
            Text(
              'Amount',
              style: AppTypography.labelMedium.copyWith(
                color: AppColors.textSecondaryDark,
              ),
            ),
            const Gap(AppSpacing.xs),
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              style: AppTypography.displaySmall.copyWith(
                color: AppColors.accentWarm,
              ),
              decoration: InputDecoration(
                prefixText: '৳ ',
                prefixStyle: AppTypography.displaySmall.copyWith(
                  color: AppColors.accentWarm,
                ),
                hintText: '0',
                filled: true,
                fillColor: AppColors.cardDark,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const Gap(AppSpacing.md),

            // Description
            Text(
              'Description (optional)',
              style: AppTypography.labelMedium.copyWith(
                color: AppColors.textSecondaryDark,
              ),
            ),
            const Gap(AppSpacing.xs),
            TextField(
              controller: _descController,
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.textPrimaryDark,
              ),
              decoration: InputDecoration(
                hintText: 'What is this for?',
                filled: true,
                fillColor: AppColors.cardDark,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const Gap(AppSpacing.xl),

            // Submit Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _canSubmit() ? _submit : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.accentWarm,
                  padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                  ),
                ),
                child: Text(
                  _isEditing ? 'Update Transaction' : 'Add Transaction',
                  style: AppTypography.titleMedium.copyWith(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const Gap(AppSpacing.lg),
          ],
        ),
      ),
    );
  }

  bool _canSubmit() {
    return _fromMemberId != null &&
        _toMemberId != null &&
        _amountController.text.isNotEmpty &&
        double.tryParse(_amountController.text) != null;
  }

  void _submit() async {
    final amount = double.parse(_amountController.text);

    // Block negative amounts
    if (amount <= 0) {
      HapticService.error();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Amount must be greater than 0'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    // Confirm large amounts (>5,000 BDT for transactions)
    if (amount > 5000) {
      HapticService.warning();
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          backgroundColor: AppColors.surfaceDark,
          title: const Row(
            children: [
              Icon(LucideIcons.alertTriangle, color: AppColors.warning),
              Gap(8),
              Text('Large Transaction'),
            ],
          ),
          content: Text(
            'You are about to record a ৳${amount.toStringAsFixed(0)} transaction.\n\nThis is a significant amount. Are you sure?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Review'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(ctx, true),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.warning,
              ),
              child: const Text('Confirm'),
            ),
          ],
        ),
      );
      if (confirmed != true || !context.mounted) return;
    }

    // Premium haptic for successful transaction
    HapticService.paymentConfirmed();

    if (_isEditing) {
      // Update existing transaction
      final existing = widget.existingTransaction!;
      final updatedTransaction = existing.copyWith(
        fromMemberId: _fromMemberId!,
        toMemberId: _toMemberId!,
        amount: amount,
        description: _descController.text.isEmpty ? null : _descController.text,
      );
      ref
          .read(moneyTransactionsProvider.notifier)
          .updateTransaction(updatedTransaction);
    } else {
      // Create new transaction
      final transaction = MoneyTransaction(
        id: const Uuid().v4(),
        fromMemberId: _fromMemberId!,
        toMemberId: _toMemberId!,
        amount: amount,
        description: _descController.text.isEmpty ? null : _descController.text,
        date: DateTime.now(),
        isSettled: false,
      );
      ref.read(moneyTransactionsProvider.notifier).addTransaction(transaction);
    }
    Navigator.of(context).pop();
  }
}
