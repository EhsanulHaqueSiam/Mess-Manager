import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:gap/gap.dart';

import 'package:mess_manager/core/theme/app_theme.dart';
import 'package:mess_manager/core/providers/members_provider.dart';

/// Party/Occasion Splitter Bottom Sheet
/// Splits special occasion costs among selected members
class PartySplitterSheet extends ConsumerStatefulWidget {
  const PartySplitterSheet({super.key});

  @override
  ConsumerState<PartySplitterSheet> createState() => _PartySplitterSheetState();
}

class _PartySplitterSheetState extends ConsumerState<PartySplitterSheet> {
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();
  final Set<String> _selectedMembers = {};

  double get _totalAmount => double.tryParse(_amountController.text) ?? 0;
  double get _perPersonAmount =>
      _selectedMembers.isEmpty ? 0 : _totalAmount / _selectedMembers.length;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final members = ref.read(membersProvider);
      setState(() {
        _selectedMembers.addAll(members.map((m) => m.id));
      });
    });
    _amountController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _amountController.dispose();
    _descriptionController.dispose();
    super.dispose();
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
                Container(
                  padding: const EdgeInsets.all(AppSpacing.sm),
                  decoration: BoxDecoration(
                    color: AppColors.accentWarm.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                  ),
                  child: const Icon(
                    LucideIcons.partyPopper,
                    color: AppColors.accentWarm,
                    size: 24,
                  ),
                ),
                const Gap(AppSpacing.md),
                Text(
                  'Party Splitter',
                  style: AppTypography.headlineMedium.copyWith(
                    color: AppColors.textPrimaryDark,
                  ),
                ),
              ],
            ),
            const Gap(AppSpacing.lg),

            // Total Amount
            Text(
              'Total Amount (৳)',
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
                  color: AppColors.accentWarm,
                ),
              ),
            ),
            const Gap(AppSpacing.lg),

            // Description
            Text(
              'What is this for?',
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
              decoration: const InputDecoration(
                hintText: 'Birthday party, Eid celebration...',
              ),
            ),
            const Gap(AppSpacing.lg),

            // Select Members
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Split Between',
                  style: AppTypography.labelMedium.copyWith(
                    color: AppColors.textSecondaryDark,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      if (_selectedMembers.length == members.length) {
                        _selectedMembers.clear();
                      } else {
                        _selectedMembers.addAll(members.map((m) => m.id));
                      }
                    });
                  },
                  child: Text(
                    _selectedMembers.length == members.length
                        ? 'Deselect All'
                        : 'Select All',
                  ),
                ),
              ],
            ),
            const Gap(AppSpacing.sm),
            Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.sm,
              children: members.map((member) {
                final isSelected = _selectedMembers.contains(member.id);
                return FilterChip(
                  selected: isSelected,
                  label: Text(member.name),
                  onSelected: (s) {
                    setState(() {
                      if (s) {
                        _selectedMembers.add(member.id);
                      } else {
                        _selectedMembers.remove(member.id);
                      }
                    });
                  },
                  selectedColor: AppColors.accentWarm.withValues(alpha: 0.2),
                  checkmarkColor: AppColors.accentWarm,
                );
              }).toList(),
            ),
            const Gap(AppSpacing.xl),

            // Per Person Result Card
            Container(
              padding: const EdgeInsets.all(AppSpacing.lg),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.accentWarm.withValues(alpha: 0.15),
                    AppColors.accentWarm.withValues(alpha: 0.05),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                border: Border.all(
                  color: AppColors.accentWarm.withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Per Person',
                        style: AppTypography.labelMedium.copyWith(
                          color: AppColors.textSecondaryDark,
                        ),
                      ),
                      const Gap(4),
                      Text(
                        '${_selectedMembers.length} members',
                        style: AppTypography.bodySmall.copyWith(
                          color: AppColors.textMutedDark,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    '৳${_perPersonAmount.toStringAsFixed(0)}',
                    style: AppTypography.displaySmall.copyWith(
                      color: AppColors.accentWarm,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
            const Gap(AppSpacing.lg),

            // Member Breakdown
            if (_selectedMembers.isNotEmpty && _totalAmount > 0) ...[
              Text(
                'Breakdown',
                style: AppTypography.labelMedium.copyWith(
                  color: AppColors.textSecondaryDark,
                ),
              ),
              const Gap(AppSpacing.sm),
              ...members.where((m) => _selectedMembers.contains(m.id)).map((
                member,
              ) {
                return Container(
                  margin: const EdgeInsets.only(bottom: AppSpacing.xs),
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                    vertical: AppSpacing.sm,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.cardDark,
                    borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 14,
                            backgroundColor: AppColors.accentWarm.withValues(
                              alpha: 0.2,
                            ),
                            child: Text(
                              member.name[0],
                              style: AppTypography.labelSmall.copyWith(
                                color: AppColors.accentWarm,
                              ),
                            ),
                          ),
                          const Gap(AppSpacing.sm),
                          Text(
                            member.name,
                            style: AppTypography.bodyMedium.copyWith(
                              color: AppColors.textPrimaryDark,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        '৳${_perPersonAmount.toStringAsFixed(0)}',
                        style: AppTypography.titleSmall.copyWith(
                          color: AppColors.accentWarm,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                );
              }),
              const Gap(AppSpacing.lg),
            ],

            // Done Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(LucideIcons.check, size: 20),
                label: const Text('Done'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.accentWarm,
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
}
