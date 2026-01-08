import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:gap/gap.dart';
import 'package:mess_manager/core/theme/app_theme.dart';
import 'package:mess_manager/core/models/member.dart';
import 'package:mess_manager/core/models/unified_entry.dart';
import 'package:mess_manager/core/services/nlp_categorizer.dart';
import 'package:mess_manager/core/providers/members_provider.dart';
import 'package:mess_manager/features/unified/providers/unified_entries_provider.dart';

class AddEntrySheet extends ConsumerStatefulWidget {
  const AddEntrySheet({super.key});

  @override
  ConsumerState<AddEntrySheet> createState() => _AddEntrySheetState();
}

class _AddEntrySheetState extends ConsumerState<AddEntrySheet> {
  String? _selectedMemberId;
  final DateTime _selectedDate = DateTime.now();
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();

  // NLP detection
  EntryType _selectedType = EntryType.mealBazar;
  MonthlyCategory? _selectedCategory;
  bool _isAutoDetected = true;
  double _confidence = 0.5;

  @override
  void initState() {
    super.initState();
    _selectedMemberId = ref.read(currentMemberIdProvider);
    _descriptionController.addListener(_onDescriptionChanged);
  }

  @override
  void dispose() {
    _amountController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _onDescriptionChanged() {
    final text = _descriptionController.text.trim();
    if (text.isEmpty) return;

    final result = NLPCategorizer().categorize(text);
    setState(() {
      _selectedType = result.type;
      _selectedCategory = result.category;
      _isAutoDetected = true;
      _confidence = result.confidence;
    });
  }

  @override
  Widget build(BuildContext context) {
    final members = ref.watch(membersProvider);

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.85,
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

            // Title
            Row(
              children: [
                const Icon(LucideIcons.plusCircle, color: AppColors.primary),
                const Gap(AppSpacing.sm),
                Text(
                  'Add Entry',
                  style: AppTypography.headlineMedium.copyWith(
                    color: AppColors.textPrimaryDark,
                  ),
                ),
              ],
            ),
            const Gap(AppSpacing.lg),

            // Amount (Quick Entry)
            Text(
              'Amount (৳)',
              style: AppTypography.labelMedium.copyWith(
                color: AppColors.textSecondaryDark,
              ),
            ),
            const Gap(AppSpacing.sm),
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              autofocus: true,
              style: AppTypography.displaySmall.copyWith(
                color: AppColors.textPrimaryDark,
              ),
              decoration: InputDecoration(
                hintText: '0',
                prefixText: '৳ ',
                prefixStyle: AppTypography.displaySmall.copyWith(
                  color: AppColors.primary,
                ),
              ),
            ),
            const Gap(AppSpacing.lg),

            // Description (for NLP detection)
            Text(
              'What is it for? (auto-detects type)',
              style: AppTypography.labelMedium.copyWith(
                color: AppColors.textSecondaryDark,
              ),
            ),
            const Gap(AppSpacing.sm),
            TextField(
              controller: _descriptionController,
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.textPrimaryDark,
              ),
              decoration: InputDecoration(
                hintText: 'চাল, মাছ, সাবান, ভাড়া...',
                suffixIcon:
                    _isAutoDetected && _descriptionController.text.isNotEmpty
                    ? Icon(
                        LucideIcons.sparkles,
                        color: _confidence > 0.7
                            ? AppColors.success
                            : AppColors.warning,
                        size: 18,
                      )
                    : null,
              ),
            ),
            const Gap(AppSpacing.lg),

            // Entry Type Selector (NLP detected, can override)
            Row(
              children: [
                Text(
                  'Type',
                  style: AppTypography.labelMedium.copyWith(
                    color: AppColors.textSecondaryDark,
                  ),
                ),
                if (_isAutoDetected) ...[
                  const Gap(AppSpacing.sm),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.success.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      'Auto',
                      style: AppTypography.labelSmall.copyWith(
                        color: AppColors.success,
                      ),
                    ),
                  ),
                ],
              ],
            ),
            const Gap(AppSpacing.sm),
            Row(
              children: EntryType.values.map((type) {
                final isSelected = _selectedType == type;
                return Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() {
                      _selectedType = type;
                      _isAutoDetected = false;
                    }),
                    child: Container(
                      margin: const EdgeInsets.only(right: AppSpacing.xs),
                      padding: const EdgeInsets.symmetric(
                        vertical: AppSpacing.sm,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? _getTypeColor(type)
                            : AppColors.cardDark,
                        borderRadius: BorderRadius.circular(
                          AppSpacing.radiusSm,
                        ),
                      ),
                      child: Column(
                        children: [
                          Icon(
                            _getTypeIcon(type),
                            color: isSelected
                                ? Colors.white
                                : AppColors.textSecondaryDark,
                            size: 20,
                          ),
                          const Gap(4),
                          Text(
                            _getTypeLabel(type),
                            style: AppTypography.labelSmall.copyWith(
                              color: isSelected
                                  ? Colors.white
                                  : AppColors.textSecondaryDark,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const Gap(AppSpacing.lg),

            // Member Selector (restricted based on role)
            _buildMemberSelector(members),
            const Gap(AppSpacing.xl),

            // Split Info
            Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: AppColors.cardDark,
                borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
              ),
              child: Row(
                children: [
                  Icon(
                    _selectedType == EntryType.mealBazar
                        ? LucideIcons.pieChart
                        : LucideIcons.users,
                    color: _getTypeColor(_selectedType),
                    size: 18,
                  ),
                  const Gap(AppSpacing.sm),
                  Expanded(
                    child: Text(
                      _getSplitInfo(_selectedType),
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.textSecondaryDark,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Gap(AppSpacing.xl),

            // Submit Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _submit,
                icon: const Icon(LucideIcons.check, size: 20),
                label: const Text('Add Entry'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _getTypeColor(_selectedType),
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

  Color _getTypeColor(EntryType type) {
    switch (type) {
      case EntryType.mealBazar:
        return AppColors.bazarColor;
      case EntryType.monthly:
        return AppColors.warning;
      case EntryType.fixed:
        return AppColors.error;
    }
  }

  IconData _getTypeIcon(EntryType type) {
    switch (type) {
      case EntryType.mealBazar:
        return LucideIcons.shoppingCart;
      case EntryType.monthly:
        return LucideIcons.package;
      case EntryType.fixed:
        return LucideIcons.receipt;
    }
  }

  String _getTypeLabel(EntryType type) {
    switch (type) {
      case EntryType.mealBazar:
        return 'Bazar';
      case EntryType.monthly:
        return 'Monthly';
      case EntryType.fixed:
        return 'Fixed';
    }
  }

  String _getSplitInfo(EntryType type) {
    switch (type) {
      case EntryType.mealBazar:
        return 'Split by meal ratio (who ate more pays more)';
      case EntryType.monthly:
        return 'Split equally among all members';
      case EntryType.fixed:
        return 'Split equally (Rent, WiFi, Maid, etc.)';
    }
  }

  /// Build member selector with role-based restrictions
  /// Only SuperAdmin can select other members
  Widget _buildMemberSelector(List members) {
    final currentMemberId = ref.watch(currentMemberIdProvider);
    final currentMember = members.firstWhere(
      (m) => m.id == currentMemberId,
      orElse: () => members.first,
    );
    final isSuperAdmin = currentMember.role == MemberRole.superAdmin;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Who paid?',
              style: AppTypography.labelMedium.copyWith(
                color: AppColors.textSecondaryDark,
              ),
            ),
            if (!isSuperAdmin) ...[
              const Gap(AppSpacing.sm),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.info.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  'You only',
                  style: AppTypography.labelSmall.copyWith(
                    color: AppColors.info,
                  ),
                ),
              ),
            ],
          ],
        ),
        const Gap(AppSpacing.sm),
        if (isSuperAdmin)
          // SuperAdmin can select any member
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: members.map((member) {
              final isSelected = _selectedMemberId == member.id;
              return FilterChip(
                selected: isSelected,
                label: Text(member.name),
                onSelected: (_) =>
                    setState(() => _selectedMemberId = member.id),
                selectedColor: AppColors.primary.withValues(alpha: 0.2),
                checkmarkColor: AppColors.primary,
              );
            }).toList(),
          )
        else
          // Regular members can only add for themselves
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: AppColors.cardDark,
              borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
              border: Border.all(
                color: AppColors.primary.withValues(alpha: 0.5),
              ),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundColor: AppColors.primary.withValues(alpha: 0.2),
                  child: Text(
                    currentMember.name[0],
                    style: AppTypography.labelMedium.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                ),
                const Gap(AppSpacing.sm),
                Text(
                  currentMember.name,
                  style: AppTypography.titleSmall.copyWith(
                    color: AppColors.textPrimaryDark,
                  ),
                ),
                const Spacer(),
                Icon(
                  LucideIcons.lock,
                  size: 14,
                  color: AppColors.textMutedDark,
                ),
              ],
            ),
          ),
      ],
    );
  }

  void _submit() {
    if (_selectedMemberId == null) return;
    final amount = double.tryParse(_amountController.text) ?? 0;
    if (amount <= 0) return;

    final entry = UnifiedEntry(
      id: 'ue_${DateTime.now().millisecondsSinceEpoch}',
      memberId: _selectedMemberId!,
      date: _selectedDate,
      amount: amount,
      description: _descriptionController.text.trim().isNotEmpty
          ? _descriptionController.text.trim()
          : null,
      type: _selectedType,
      monthlyCategory: _selectedCategory,
      isAutoDetected: _isAutoDetected,
      createdAt: DateTime.now(),
    );

    ref.read(unifiedEntriesProvider.notifier).addEntry(entry);
    Navigator.of(context).pop();
  }
}
