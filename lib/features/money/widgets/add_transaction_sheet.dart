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
import 'package:mess_manager/core/widgets/quick_input_widgets.dart';

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
  late final FocusNode _amountFocusNode;
  String? _fromMemberId;
  String? _toMemberId;
  double? _selectedPresetAmount;

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
    _amountFocusNode = FocusNode();

    // Sync preset selection if editing with a preset-matching amount
    if (existing != null) {
      final amt = existing.amount;
      if (const [200, 500, 1000, 2000, 5000].contains(amt.toInt())) {
        _selectedPresetAmount = amt;
      }
    }

    // Listen to manual amount edits to deselect preset chips
    _amountController.addListener(_onAmountTextChanged);

    // Auto-focus amount field after build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _amountFocusNode.requestFocus();
    });
  }

  void _onAmountTextChanged() {
    final text = _amountController.text;
    final parsed = double.tryParse(text);
    if (parsed == null) {
      if (_selectedPresetAmount != null) {
        setState(() => _selectedPresetAmount = null);
      }
      return;
    }
    // If the current text matches a preset, keep it selected; otherwise deselect
    if (const [200, 500, 1000, 2000, 5000].contains(parsed.toInt()) &&
        parsed == parsed.toInt().toDouble()) {
      if (_selectedPresetAmount != parsed) {
        setState(() => _selectedPresetAmount = parsed);
      }
    } else {
      if (_selectedPresetAmount != null) {
        setState(() => _selectedPresetAmount = null);
      }
    }
  }

  @override
  void dispose() {
    _amountController.removeListener(_onAmountTextChanged);
    _amountController.dispose();
    _descController.dispose();
    _amountFocusNode.dispose();
    super.dispose();
  }

  double? get _parsedAmount => double.tryParse(_amountController.text);
  bool get _isLargeAmount => (_parsedAmount ?? 0) > 5000;

  @override
  Widget build(BuildContext context) {
    final members = ref.watch(membersProvider);
    final currentId = ref.watch(currentMemberIdProvider);
    final currentMember = ref.watch(currentMemberProvider);

    // Default from to current user
    _fromMemberId ??= currentId;

    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      decoration: BoxDecoration(
        color: context.surfaceColor,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(AppSpacing.radiusXl),
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
                  color: context.borderColor,
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
                    color: context.textPrimary,
                  ),
                ),
              ],
            ),
            const Gap(AppSpacing.lg),

            // From Member — locked info row for current user
            Text(
              'From',
              style: AppTypography.labelMedium.copyWith(
                color: context.textSecondary,
              ),
            ),
            const Gap(AppSpacing.xs),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.sm + 2,
              ),
              decoration: BoxDecoration(
                color: context.cardColor,
                borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                border: Border.all(
                  color: AppColors.accentWarm.withValues(alpha: 0.2),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: AppColors.accentWarm.withValues(alpha: 0.15),
                    ),
                    child: Center(
                      child: Text(
                        (currentMember?.name.isNotEmpty ?? false)
                            ? currentMember!.name[0].toUpperCase()
                            : '?',
                        style: AppTypography.titleSmall.copyWith(
                          color: AppColors.accentWarm,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                  const Gap(AppSpacing.sm),
                  Expanded(
                    child: Text(
                      currentMember?.name ?? 'You',
                      style: AppTypography.bodyMedium.copyWith(
                        color: context.textPrimary,
                      ),
                    ),
                  ),
                  Icon(
                    LucideIcons.lock,
                    size: 14,
                    color: context.textMuted,
                  ),
                ],
              ),
            ),
            const Gap(AppSpacing.md),

            // To Member — horizontal avatar picker (1 tap)
            Text(
              'To',
              style: AppTypography.labelMedium.copyWith(
                color: context.textSecondary,
              ),
            ),
            const Gap(AppSpacing.xs),
            MemberAvatarPicker(
              members: members,
              selectedMemberId: _toMemberId,
              excludeMemberId: _fromMemberId,
              accentColor: AppColors.accentWarm,
              onMemberSelected: (id) {
                setState(() => _toMemberId = id);
              },
            ),
            const Gap(AppSpacing.md),

            // Quick amount presets
            Text(
              'Quick amount',
              style: AppTypography.labelMedium.copyWith(
                color: context.textSecondary,
              ),
            ),
            const Gap(AppSpacing.xs),
            QuickAmountPicker(
              selectedAmount: _selectedPresetAmount,
              accentColor: AppColors.accentWarm,
              presets: const [200, 500, 1000, 2000, 5000],
              controller: _amountController,
              onAmountSelected: (amount) {
                setState(() => _selectedPresetAmount = amount);
              },
            ),
            const Gap(AppSpacing.md),

            // Amount field — prominent displaySmall size
            Text(
              'Amount',
              style: AppTypography.labelMedium.copyWith(
                color: context.textSecondary,
              ),
            ),
            const Gap(AppSpacing.xs),
            TextField(
              controller: _amountController,
              focusNode: _amountFocusNode,
              keyboardType: TextInputType.number,
              style: AppTypography.displaySmall.copyWith(
                color: AppColors.accentWarm,
                fontFamily: 'JetBrains Mono',
              ),
              decoration: InputDecoration(
                prefixText: '৳ ',
                prefixStyle: AppTypography.displaySmall.copyWith(
                  color: AppColors.accentWarm,
                ),
                hintText: '0',
                hintStyle: AppTypography.displaySmall.copyWith(
                  color: context.textMuted.withValues(alpha: 0.3),
                ),
                filled: true,
                fillColor: context.cardColor,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                  borderSide: const BorderSide(
                    color: AppColors.accentWarm,
                    width: 2,
                  ),
                ),
              ),
              onChanged: (_) => setState(() {}),
            ),

            // Inline large amount warning (replaces confirmation dialog)
            if (_isLargeAmount) ...[
              const Gap(AppSpacing.sm),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.sm,
                ),
                decoration: BoxDecoration(
                  color: AppColors.warning.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                  border: Border.all(
                    color: AppColors.warning.withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(
                      LucideIcons.alertTriangle,
                      color: AppColors.warning,
                      size: 16,
                    ),
                    const Gap(AppSpacing.sm),
                    Expanded(
                      child: Text(
                        'Large transaction — ৳${_parsedAmount?.toStringAsFixed(0) ?? '0'}',
                        style: AppTypography.labelMedium.copyWith(
                          color: AppColors.warning,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
            const Gap(AppSpacing.md),

            // Description with suggestion chips
            Text(
              'Description (optional)',
              style: AppTypography.labelMedium.copyWith(
                color: context.textSecondary,
              ),
            ),
            const Gap(AppSpacing.xs),
            DescriptionSuggestChips(
              suggestions: const [
                'Rent share',
                'Bazar money',
                'Bill split',
                'Loan',
                'Return',
              ],
              accentColor: AppColors.accentWarm,
              onSelected: (suggestion) {
                _descController.text = suggestion;
                setState(() {});
              },
            ),
            const Gap(AppSpacing.sm),
            TextField(
              controller: _descController,
              style: AppTypography.bodyMedium.copyWith(
                color: context.textPrimary,
              ),
              decoration: InputDecoration(
                hintText: 'What is this for?',
                filled: true,
                fillColor: context.cardColor,
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
                  disabledBackgroundColor:
                      AppColors.accentWarm.withValues(alpha: 0.3),
                  padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(AppSpacing.radiusMd),
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
