import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:gap/gap.dart';
import 'package:mess_manager/core/theme/app_theme.dart';
import 'package:mess_manager/core/models/bazar_list_item.dart';
import 'package:mess_manager/core/providers/members_provider.dart';
import 'package:mess_manager/features/bazar/providers/bazar_list_provider.dart';

class BazarListTab extends ConsumerStatefulWidget {
  const BazarListTab({super.key});

  @override
  ConsumerState<BazarListTab> createState() => _BazarListTabState();
}

class _BazarListTabState extends ConsumerState<BazarListTab> {
  final _addItemController = TextEditingController();

  @override
  void dispose() {
    _addItemController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final items = ref.watch(bazarListProvider);
    final members = ref.watch(membersProvider);
    final currentMemberId = ref.watch(currentMemberIdProvider);

    final pendingItems = items
        .where((i) => i.status != BazarListStatus.purchased)
        .toList();
    final purchasedItems = items
        .where((i) => i.status == BazarListStatus.purchased)
        .toList();

    return Column(
      children: [
        // Add Item Row
        Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _addItemController,
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.textPrimaryDark,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Add item to shopping list...',
                    prefixIcon: const Icon(LucideIcons.plus, size: 18),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md,
                      vertical: AppSpacing.sm,
                    ),
                  ),
                  onSubmitted: (_) => _addItem(),
                ),
              ),
              const Gap(AppSpacing.sm),
              IconButton.filled(
                onPressed: _addItem,
                icon: const Icon(LucideIcons.send, size: 18),
                style: IconButton.styleFrom(
                  backgroundColor: AppColors.bazarColor,
                ),
              ),
            ],
          ),
        ),

        // Pending Items
        Expanded(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            children: [
              if (pendingItems.isEmpty)
                _buildEmptyState()
              else ...[
                Text(
                  'Need to buy',
                  style: AppTypography.labelMedium.copyWith(
                    color: AppColors.textSecondaryDark,
                  ),
                ),
                const Gap(AppSpacing.sm),
                ...pendingItems.map(
                  (item) => _buildItemCard(item, members, currentMemberId),
                ),
              ],

              if (purchasedItems.isNotEmpty) ...[
                const Gap(AppSpacing.lg),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Purchased',
                      style: AppTypography.labelMedium.copyWith(
                        color: AppColors.textSecondaryDark,
                      ),
                    ),
                    TextButton(
                      onPressed: () =>
                          ref.read(bazarListProvider.notifier).clearPurchased(),
                      child: Text(
                        'Clear all',
                        style: AppTypography.labelSmall.copyWith(
                          color: AppColors.error,
                        ),
                      ),
                    ),
                  ],
                ),
                const Gap(AppSpacing.sm),
                ...purchasedItems.map(
                  (item) => _buildPurchasedItem(item, members),
                ),
              ],
              const Gap(AppSpacing.xxl),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: Column(
        children: [
          Icon(
            LucideIcons.shoppingCart,
            size: 48,
            color: AppColors.textMutedDark,
          ),
          const Gap(AppSpacing.md),
          Text(
            'Shopping list is empty',
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.textSecondaryDark,
            ),
          ),
          Text(
            'Add items that need to be bought',
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.textMutedDark,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItemCard(
    BazarListItem item,
    List members,
    String currentMemberId,
  ) {
    final addedBy = members.firstWhere(
      (m) => m.id == item.addedById,
      orElse: () => members.first,
    );
    final claimedBy = item.claimedById != null
        ? members.firstWhere(
            (m) => m.id == item.claimedById,
            orElse: () => null,
          )
        : null;

    final isClaimed = item.status == BazarListStatus.claimed;
    final isClaimedByMe = item.claimedById == currentMemberId;

    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.cardDark,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        border: Border.all(
          color: isClaimed
              ? AppColors.success.withValues(alpha: 0.3)
              : AppColors.borderDark.withValues(alpha: 0.5),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Claim indicator (not checkbox)
              GestureDetector(
                onTap: () {
                  if (isClaimed && isClaimedByMe) {
                    ref.read(bazarListProvider.notifier).markPurchased(item.id);
                  }
                },
                child: Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: isClaimed
                        ? AppColors.warning.withValues(alpha: 0.2)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                      color: isClaimed
                          ? AppColors.warning
                          : AppColors.borderDark,
                      width: 2,
                    ),
                  ),
                  child: isClaimed
                      ? const Icon(
                          LucideIcons.hand,
                          size: 12,
                          color: AppColors.warning,
                        )
                      : null,
                ),
              ),
              const Gap(AppSpacing.sm),
              // Item name
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.name,
                      style: AppTypography.titleSmall.copyWith(
                        color: AppColors.textPrimaryDark,
                      ),
                    ),
                    if (item.quantity != null)
                      Text(
                        item.quantity!,
                        style: AppTypography.labelSmall.copyWith(
                          color: AppColors.textSecondaryDark,
                        ),
                      ),
                  ],
                ),
              ),
              // Added by
              Text(
                'by ${addedBy.name}',
                style: AppTypography.labelSmall.copyWith(
                  color: AppColors.textMutedDark,
                ),
              ),
            ],
          ),
          const Gap(AppSpacing.sm),
          // Action buttons
          Row(
            children: [
              if (!isClaimed)
                OutlinedButton.icon(
                  onPressed: () => ref
                      .read(bazarListProvider.notifier)
                      .claimItem(item.id, currentMemberId),
                  icon: const Icon(LucideIcons.hand, size: 14),
                  label: const Text("I'll get it"),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.bazarColor,
                    side: const BorderSide(color: AppColors.bazarColor),
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.sm,
                      vertical: AppSpacing.xs,
                    ),
                    textStyle: AppTypography.labelSmall,
                  ),
                )
              else if (claimedBy != null)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.sm,
                    vertical: AppSpacing.xs,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.success.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        LucideIcons.user,
                        size: 12,
                        color: AppColors.success,
                      ),
                      const Gap(4),
                      Text(
                        '${claimedBy.name} will buy',
                        style: AppTypography.labelSmall.copyWith(
                          color: AppColors.success,
                        ),
                      ),
                    ],
                  ),
                ),
              const Spacer(),
              if (isClaimedByMe)
                TextButton(
                  onPressed: () =>
                      ref.read(bazarListProvider.notifier).unclaimItem(item.id),
                  child: Text(
                    'Unclaim',
                    style: AppTypography.labelSmall.copyWith(
                      color: AppColors.textSecondaryDark,
                    ),
                  ),
                ),
              // Edit button
              IconButton(
                onPressed: () => _showEditSheet(context, item),
                icon: const Icon(LucideIcons.edit2, size: 16),
                color: AppColors.textMutedDark,
                iconSize: 16,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
              ),
              // Delete button
              IconButton(
                onPressed: () =>
                    ref.read(bazarListProvider.notifier).removeItem(item.id),
                icon: const Icon(LucideIcons.trash2, size: 16),
                color: AppColors.error,
                iconSize: 16,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPurchasedItem(BazarListItem item, List members) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.xs),
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: AppColors.cardDark.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
      ),
      child: Row(
        children: [
          const Icon(
            LucideIcons.checkCircle,
            size: 16,
            color: AppColors.success,
          ),
          const Gap(AppSpacing.sm),
          Text(
            item.name,
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.textSecondaryDark,
              decoration: TextDecoration.lineThrough,
            ),
          ),
        ],
      ),
    );
  }

  void _addItem() {
    final name = _addItemController.text.trim();
    if (name.isEmpty) return;

    final currentMemberId = ref.read(currentMemberIdProvider);
    final item = BazarListItem(
      id: 'list_${DateTime.now().millisecondsSinceEpoch}',
      name: name,
      addedById: currentMemberId,
      createdAt: DateTime.now(),
    );

    ref.read(bazarListProvider.notifier).addItem(item);
    _addItemController.clear();
  }

  void _showEditSheet(BuildContext context, BazarListItem item) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) => _EditShoppingItemSheet(
        item: item,
        onSave: (updatedItem) {
          ref.read(bazarListProvider.notifier).updateItem(updatedItem);
        },
      ),
    );
  }
}

/// Edit Shopping Item Sheet
class _EditShoppingItemSheet extends StatefulWidget {
  final BazarListItem item;
  final Function(BazarListItem) onSave;

  const _EditShoppingItemSheet({required this.item, required this.onSave});

  @override
  State<_EditShoppingItemSheet> createState() => _EditShoppingItemSheetState();
}

class _EditShoppingItemSheetState extends State<_EditShoppingItemSheet> {
  late TextEditingController _nameController;
  late TextEditingController _quantityController;
  late TextEditingController _noteController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.item.name);
    _quantityController = TextEditingController(
      text: widget.item.quantity ?? '',
    );
    _noteController = TextEditingController(text: widget.item.note ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _quantityController.dispose();
    _noteController.dispose();
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
          Text(
            'Edit Item',
            style: AppTypography.headlineSmall.copyWith(
              color: AppColors.textPrimaryDark,
            ),
          ),
          const Gap(AppSpacing.lg),

          // Name field
          Text(
            'Item Name',
            style: AppTypography.labelMedium.copyWith(
              color: AppColors.textSecondaryDark,
            ),
          ),
          const Gap(AppSpacing.xs),
          TextField(
            controller: _nameController,
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.textPrimaryDark,
            ),
            decoration: const InputDecoration(
              hintText: 'What needs to be bought?',
              prefixIcon: Icon(LucideIcons.shoppingBag, size: 18),
            ),
          ),
          const Gap(AppSpacing.md),

          // Quantity field
          Text(
            'Quantity (optional)',
            style: AppTypography.labelMedium.copyWith(
              color: AppColors.textSecondaryDark,
            ),
          ),
          const Gap(AppSpacing.xs),
          TextField(
            controller: _quantityController,
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.textPrimaryDark,
            ),
            decoration: const InputDecoration(
              hintText: 'e.g., 2 kg, 5 liters',
              prefixIcon: Icon(LucideIcons.hash, size: 18),
            ),
          ),
          const Gap(AppSpacing.md),

          // Note field
          Text(
            'Note (optional)',
            style: AppTypography.labelMedium.copyWith(
              color: AppColors.textSecondaryDark,
            ),
          ),
          const Gap(AppSpacing.xs),
          TextField(
            controller: _noteController,
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.textPrimaryDark,
            ),
            decoration: const InputDecoration(
              hintText: 'Any special instructions?',
              prefixIcon: Icon(LucideIcons.messageSquare, size: 18),
            ),
          ),
          const Gap(AppSpacing.xl),

          // Save button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _save,
              icon: const Icon(LucideIcons.check, size: 18),
              label: const Text('Save Changes'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.bazarColor,
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
              ),
            ),
          ),
          const Gap(AppSpacing.md),
        ],
      ),
    );
  }

  void _save() {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Item name cannot be empty'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    final updatedItem = widget.item.copyWith(
      name: name,
      quantity: _quantityController.text.trim().isNotEmpty
          ? _quantityController.text.trim()
          : null,
      note: _noteController.text.trim().isNotEmpty
          ? _noteController.text.trim()
          : null,
    );

    widget.onSave(updatedItem);
    Navigator.pop(context);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Item updated'),
        backgroundColor: AppColors.success,
      ),
    );
  }
}
