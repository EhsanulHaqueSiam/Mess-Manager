import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:gap/gap.dart';

import 'package:mess_manager/core/theme/app_theme.dart';
import 'package:mess_manager/core/providers/members_provider.dart';
import 'package:mess_manager/core/services/haptic_service.dart';

/// Party/Occasion Splitter Bottom Sheet
/// Splits special occasion costs among members + guests
/// Includes party bazar tracking
class PartySplitterSheet extends ConsumerStatefulWidget {
  const PartySplitterSheet({super.key});

  @override
  ConsumerState<PartySplitterSheet> createState() => _PartySplitterSheetState();
}

class _PartySplitterSheetState extends ConsumerState<PartySplitterSheet> {
  final _totalAmountController = TextEditingController();
  final _descriptionController = TextEditingController();
  final Set<String> _selectedMembers = {};

  // Guest count (non-members)
  int _guestCount = 0;

  // Party bazar items
  final List<_PartyBazarItem> _bazarItems = [];
  final _itemNameController = TextEditingController();
  final _itemAmountController = TextEditingController();

  double get _bazarTotal => _bazarItems.fold(0.0, (sum, i) => sum + i.amount);
  double get _totalAmount =>
      (double.tryParse(_totalAmountController.text) ?? 0) + _bazarTotal;
  int get _totalPeople => _selectedMembers.length + _guestCount;
  double get _perPersonAmount =>
      _totalPeople <= 0 ? 0 : _totalAmount / _totalPeople;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final members = ref.read(membersProvider);
      setState(() {
        _selectedMembers.addAll(members.map((m) => m.id));
      });
    });
    _totalAmountController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _totalAmountController.dispose();
    _descriptionController.dispose();
    _itemNameController.dispose();
    _itemAmountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final members = ref.watch(membersProvider);

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.9,
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
            ).animate().fadeIn(),
            const Gap(AppSpacing.lg),

            // Description
            TextField(
              controller: _descriptionController,
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.textPrimaryDark,
              ),
              decoration: const InputDecoration(
                hintText: 'Party name (Birthday, Eid, etc.)',
                prefixIcon: Icon(LucideIcons.tag, size: 18),
              ),
            ).animate().fadeIn(delay: 100.ms),
            const Gap(AppSpacing.lg),

            // Party Bazar Section
            _buildPartyBazarSection(),
            const Gap(AppSpacing.lg),

            // Additional Costs
            Text(
              'Additional Costs (৳)',
              style: AppTypography.labelMedium.copyWith(
                color: AppColors.textSecondaryDark,
              ),
            ),
            const Gap(AppSpacing.sm),
            TextField(
              controller: _totalAmountController,
              keyboardType: TextInputType.number,
              style: AppTypography.titleLarge.copyWith(
                color: AppColors.textPrimaryDark,
              ),
              decoration: InputDecoration(
                hintText: '0',
                prefixText: '৳ ',
                prefixStyle: AppTypography.titleLarge.copyWith(
                  color: AppColors.accentWarm,
                ),
                helperText: 'Venue, decoration, etc.',
              ),
            ).animate().fadeIn(delay: 200.ms),
            const Gap(AppSpacing.lg),

            // Members Selection
            _buildMemberSelection(members),
            const Gap(AppSpacing.lg),

            // Guest Count Section
            _buildGuestSection(),
            const Gap(AppSpacing.xl),

            // Summary Card
            _buildSummaryCard(),
            const Gap(AppSpacing.lg),

            // Breakdown
            if (_totalPeople > 0 && _totalAmount > 0) _buildBreakdown(members),
            const Gap(AppSpacing.lg),

            // Done Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  HapticService.success();
                  Navigator.pop(context);
                },
                icon: const Icon(LucideIcons.check, size: 20),
                label: const Text('Done'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.accentWarm,
                  padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                ),
              ),
            ).animate().fadeIn(delay: 500.ms),
            const Gap(AppSpacing.md),
          ],
        ),
      ),
    );
  }

  Widget _buildPartyBazarSection() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.cardDark,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        border: Border.all(color: AppColors.accentWarm.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                LucideIcons.shoppingBag,
                color: AppColors.accentWarm,
                size: 18,
              ),
              const Gap(AppSpacing.sm),
              Text(
                'Party Bazar',
                style: AppTypography.titleSmall.copyWith(
                  color: AppColors.textPrimaryDark,
                ),
              ),
              const Spacer(),
              if (_bazarTotal > 0)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.accentWarm.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    '৳${_bazarTotal.toStringAsFixed(0)}',
                    style: AppTypography.labelSmall.copyWith(
                      color: AppColors.accentWarm,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),
          const Gap(AppSpacing.sm),
          Text(
            'Track party-specific purchases',
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.textMutedDark,
            ),
          ),
          const Gap(AppSpacing.md),

          // Items list
          if (_bazarItems.isNotEmpty) ...[
            ..._bazarItems.asMap().entries.map(
              (entry) => Container(
                margin: const EdgeInsets.only(bottom: AppSpacing.xs),
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm,
                  vertical: AppSpacing.xs,
                ),
                decoration: BoxDecoration(
                  color: AppColors.surfaceDark,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        entry.value.name,
                        style: TextStyle(color: AppColors.textPrimaryDark),
                      ),
                    ),
                    Text(
                      '৳${entry.value.amount.toStringAsFixed(0)}',
                      style: TextStyle(
                        color: AppColors.accentWarm,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(LucideIcons.x, size: 14),
                      onPressed: () =>
                          setState(() => _bazarItems.removeAt(entry.key)),
                      color: AppColors.error,
                      iconSize: 14,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(
                        minWidth: 28,
                        minHeight: 28,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const Gap(AppSpacing.sm),
          ],

          // Add item row
          Row(
            children: [
              Expanded(
                flex: 2,
                child: TextField(
                  controller: _itemNameController,
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textPrimaryDark,
                  ),
                  decoration: const InputDecoration(
                    hintText: 'Item (cake, drinks...)',
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 8,
                    ),
                    isDense: true,
                  ),
                ),
              ),
              const Gap(AppSpacing.sm),
              Expanded(
                child: TextField(
                  controller: _itemAmountController,
                  keyboardType: TextInputType.number,
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textPrimaryDark,
                  ),
                  decoration: const InputDecoration(
                    hintText: '৳',
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 8,
                    ),
                    isDense: true,
                  ),
                ),
              ),
              const Gap(AppSpacing.sm),
              IconButton.filled(
                onPressed: _addBazarItem,
                icon: const Icon(LucideIcons.plus, size: 16),
                style: IconButton.styleFrom(
                  backgroundColor: AppColors.accentWarm,
                ),
              ),
            ],
          ),
        ],
      ),
    ).animate().fadeIn(delay: 150.ms);
  }

  Widget _buildMemberSelection(List members) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Mess Members',
              style: AppTypography.labelMedium.copyWith(
                color: AppColors.textSecondaryDark,
              ),
            ),
            TextButton(
              onPressed: () {
                HapticService.lightTap();
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
                HapticService.lightTap();
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
      ],
    ).animate().fadeIn(delay: 300.ms);
  }

  Widget _buildGuestSection() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.success.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        border: Border.all(color: AppColors.success.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          const Icon(LucideIcons.userPlus, color: AppColors.success, size: 20),
          const Gap(AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'External Guests',
                  style: AppTypography.titleSmall.copyWith(
                    color: AppColors.textPrimaryDark,
                  ),
                ),
                Text(
                  'Non-members joining the party',
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textMutedDark,
                  ),
                ),
              ],
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(LucideIcons.minus, size: 18),
                onPressed: _guestCount > 0
                    ? () {
                        HapticService.lightTap();
                        setState(() => _guestCount--);
                      }
                    : null,
              ),
              Container(
                width: 40,
                alignment: Alignment.center,
                child: Text(
                  '$_guestCount',
                  style: AppTypography.titleMedium.copyWith(
                    color: AppColors.success,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(LucideIcons.plus, size: 18),
                onPressed: () {
                  HapticService.lightTap();
                  setState(() => _guestCount++);
                },
              ),
            ],
          ),
        ],
      ),
    ).animate().fadeIn(delay: 350.ms);
  }

  Widget _buildSummaryCard() {
    return Container(
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
        border: Border.all(color: AppColors.accentWarm.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          // Total Bill
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total Bill',
                style: AppTypography.labelMedium.copyWith(
                  color: AppColors.textSecondaryDark,
                ),
              ),
              Text(
                '৳${_totalAmount.toStringAsFixed(0)}',
                style: AppTypography.titleLarge.copyWith(
                  color: AppColors.textPrimaryDark,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const Gap(AppSpacing.sm),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total People',
                style: AppTypography.labelMedium.copyWith(
                  color: AppColors.textSecondaryDark,
                ),
              ),
              Text(
                '$_totalPeople (${_selectedMembers.length} members + $_guestCount guests)',
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.textMutedDark,
                ),
              ),
            ],
          ),
          const Divider(height: AppSpacing.lg),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Per Person',
                style: AppTypography.titleSmall.copyWith(
                  color: AppColors.textPrimaryDark,
                  fontWeight: FontWeight.w600,
                ),
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
        ],
      ),
    ).animate().fadeIn(delay: 400.ms);
  }

  Widget _buildBreakdown(List members) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Member Breakdown',
          style: AppTypography.labelMedium.copyWith(
            color: AppColors.textSecondaryDark,
          ),
        ),
        const Gap(AppSpacing.sm),
        ...members
            .where((m) => _selectedMembers.contains(m.id))
            .map(
              (member) => Container(
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
              ),
            ),
        if (_guestCount > 0)
          Container(
            margin: const EdgeInsets.only(bottom: AppSpacing.xs),
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.sm,
            ),
            decoration: BoxDecoration(
              color: AppColors.success.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(
                      LucideIcons.users,
                      size: 16,
                      color: AppColors.success,
                    ),
                    const Gap(AppSpacing.sm),
                    Text(
                      '$_guestCount Guest${_guestCount > 1 ? 's' : ''}',
                      style: AppTypography.bodyMedium.copyWith(
                        color: AppColors.success,
                      ),
                    ),
                  ],
                ),
                Text(
                  '৳${(_perPersonAmount * _guestCount).toStringAsFixed(0)}',
                  style: AppTypography.titleSmall.copyWith(
                    color: AppColors.success,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        const Gap(AppSpacing.sm),
      ],
    ).animate().fadeIn(delay: 450.ms);
  }

  void _addBazarItem() {
    final name = _itemNameController.text.trim();
    final amount = double.tryParse(_itemAmountController.text) ?? 0;
    if (name.isEmpty || amount <= 0) return;

    HapticService.lightTap();
    setState(() {
      _bazarItems.add(_PartyBazarItem(name: name, amount: amount));
      _itemNameController.clear();
      _itemAmountController.clear();
    });
  }
}

class _PartyBazarItem {
  final String name;
  final double amount;
  _PartyBazarItem({required this.name, required this.amount});
}
