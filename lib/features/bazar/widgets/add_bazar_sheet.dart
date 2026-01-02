import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:gap/gap.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mess_manager/core/theme/app_theme.dart';
import 'package:mess_manager/core/models/bazar_entry.dart';
import 'package:mess_manager/core/providers/members_provider.dart';
import 'package:mess_manager/features/bazar/providers/bazar_provider.dart';

class AddBazarSheet extends ConsumerStatefulWidget {
  const AddBazarSheet({super.key});

  @override
  ConsumerState<AddBazarSheet> createState() => _AddBazarSheetState();
}

class _AddBazarSheetState extends ConsumerState<AddBazarSheet> {
  String? _selectedMemberId;
  final DateTime _selectedDate = DateTime.now();
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();
  bool _isItemized = false;
  final List<BazarItem> _items = [];

  // Photo & Receipt storage
  final List<String> _photoUrls = [];
  final List<String> _receiptUrls = [];
  final ImagePicker _picker = ImagePicker();

  // Item controllers
  final _itemNameController = TextEditingController();
  final _itemPriceController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _selectedMemberId = ref.read(currentMemberIdProvider);
  }

  @override
  void dispose() {
    _amountController.dispose();
    _descriptionController.dispose();
    _itemNameController.dispose();
    _itemPriceController.dispose();
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
            Text(
              'Add Bazar Entry',
              style: AppTypography.headlineMedium.copyWith(
                color: AppColors.textPrimaryDark,
              ),
            ),
            const Gap(AppSpacing.lg),

            // Entry Type Toggle
            Row(
              children: [
                Expanded(
                  child: _buildTypeButton(
                    icon: LucideIcons.banknote,
                    label: 'Simple',
                    isSelected: !_isItemized,
                    onTap: () => setState(() => _isItemized = false),
                  ),
                ),
                const Gap(AppSpacing.sm),
                Expanded(
                  child: _buildTypeButton(
                    icon: LucideIcons.list,
                    label: 'Itemized',
                    isSelected: _isItemized,
                    onTap: () => setState(() => _isItemized = true),
                  ),
                ),
              ],
            ),
            const Gap(AppSpacing.lg),

            // Member Selector
            Text(
              'Who bought?',
              style: AppTypography.labelMedium.copyWith(
                color: AppColors.textSecondaryDark,
              ),
            ),
            const Gap(AppSpacing.sm),
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
                  selectedColor: AppColors.bazarColor.withValues(alpha: 0.2),
                  checkmarkColor: AppColors.bazarColor,
                  labelStyle: TextStyle(
                    color: isSelected
                        ? AppColors.bazarColor
                        : AppColors.textPrimaryDark,
                  ),
                );
              }).toList(),
            ),
            const Gap(AppSpacing.lg),

            if (!_isItemized) ...[
              // Simple Mode - Amount
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
                style: AppTypography.titleLarge.copyWith(
                  color: AppColors.textPrimaryDark,
                ),
                decoration: InputDecoration(
                  hintText: '0',
                  prefixText: '৳ ',
                  prefixStyle: AppTypography.titleLarge.copyWith(
                    color: AppColors.bazarColor,
                  ),
                ),
              ),
            ] else ...[
              // Itemized Mode - Items List
              Text(
                'Items',
                style: AppTypography.labelMedium.copyWith(
                  color: AppColors.textSecondaryDark,
                ),
              ),
              const Gap(AppSpacing.sm),
              ..._items.asMap().entries.map((entry) {
                final item = entry.value;
                return Container(
                  margin: const EdgeInsets.only(bottom: AppSpacing.xs),
                  padding: const EdgeInsets.all(AppSpacing.sm),
                  decoration: BoxDecoration(
                    color: AppColors.cardDark,
                    borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          item.name,
                          style: AppTypography.bodyMedium.copyWith(
                            color: AppColors.textPrimaryDark,
                          ),
                        ),
                      ),
                      Text(
                        '৳${item.price.toStringAsFixed(0)}',
                        style: AppTypography.labelMedium.copyWith(
                          color: AppColors.bazarColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(LucideIcons.x, size: 16),
                        onPressed: () =>
                            setState(() => _items.removeAt(entry.key)),
                        color: AppColors.error,
                        iconSize: 16,
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(
                          minWidth: 32,
                          minHeight: 32,
                        ),
                      ),
                    ],
                  ),
                );
              }),

              // Add Item Row
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: TextField(
                      controller: _itemNameController,
                      style: AppTypography.bodyMedium.copyWith(
                        color: AppColors.textPrimaryDark,
                      ),
                      decoration: const InputDecoration(
                        hintText: 'Item name',
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: AppSpacing.sm,
                          vertical: AppSpacing.sm,
                        ),
                      ),
                    ),
                  ),
                  const Gap(AppSpacing.sm),
                  Expanded(
                    child: TextField(
                      controller: _itemPriceController,
                      keyboardType: TextInputType.number,
                      style: AppTypography.bodyMedium.copyWith(
                        color: AppColors.textPrimaryDark,
                      ),
                      decoration: const InputDecoration(
                        hintText: '৳',
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: AppSpacing.sm,
                          vertical: AppSpacing.sm,
                        ),
                      ),
                    ),
                  ),
                  const Gap(AppSpacing.sm),
                  IconButton.filled(
                    onPressed: _addItem,
                    icon: const Icon(LucideIcons.plus, size: 18),
                    style: IconButton.styleFrom(
                      backgroundColor: AppColors.bazarColor,
                    ),
                  ),
                ],
              ),
              const Gap(AppSpacing.sm),

              // Total
              Container(
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: AppColors.bazarColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total',
                      style: AppTypography.titleMedium.copyWith(
                        color: AppColors.textPrimaryDark,
                      ),
                    ),
                    Text(
                      '৳${_items.fold(0.0, (sum, i) => sum + i.price).toStringAsFixed(0)}',
                      style: AppTypography.titleLarge.copyWith(
                        color: AppColors.bazarColor,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ],

            const Gap(AppSpacing.lg),

            // Description
            Text(
              'Description (optional)',
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
              decoration: const InputDecoration(hintText: 'What was this for?'),
            ),
            const Gap(AppSpacing.lg),

            // 📸 Photos Section
            _buildPhotoSection(
              title: 'Bazar Photos',
              subtitle: 'Take photos of your purchases',
              icon: LucideIcons.camera,
              photos: _photoUrls,
              onAdd: () => _pickImage(isReceipt: false),
              onRemove: (index) => setState(() => _photoUrls.removeAt(index)),
            ),
            const Gap(AppSpacing.lg),

            // 🧾 Receipts Section
            _buildPhotoSection(
              title: 'Receipts',
              subtitle: 'Upload receipt images',
              icon: LucideIcons.receipt,
              photos: _receiptUrls,
              onAdd: () => _pickImage(isReceipt: true),
              onRemove: (index) => setState(() => _receiptUrls.removeAt(index)),
            ),
            const Gap(AppSpacing.xl),

            // Submit Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _submit,
                icon: const Icon(LucideIcons.check, size: 20),
                label: const Text('Add Bazar'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.bazarColor,
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

  Widget _buildPhotoSection({
    required String title,
    required String subtitle,
    required IconData icon,
    required List<String> photos,
    required VoidCallback onAdd,
    required Function(int) onRemove,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 18, color: AppColors.bazarColor),
            const Gap(AppSpacing.sm),
            Text(
              title,
              style: AppTypography.labelMedium.copyWith(
                color: AppColors.textSecondaryDark,
              ),
            ),
          ],
        ),
        const Gap(AppSpacing.xs),
        Text(
          subtitle,
          style: AppTypography.bodySmall.copyWith(
            color: AppColors.textMutedDark,
          ),
        ),
        const Gap(AppSpacing.sm),
        SizedBox(
          height: 80,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              // Add Photo Button
              GestureDetector(
                onTap: onAdd,
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: AppColors.cardDark,
                    borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                    border: Border.all(
                      color: AppColors.bazarColor.withValues(alpha: 0.5),
                      style: BorderStyle.solid,
                    ),
                  ),
                  child: Icon(
                    LucideIcons.plus,
                    color: AppColors.bazarColor,
                    size: 24,
                  ),
                ),
              ),
              const Gap(AppSpacing.sm),
              // Photo Previews
              ...photos.asMap().entries.map(
                (entry) => Padding(
                  padding: const EdgeInsets.only(right: AppSpacing.sm),
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(
                          AppSpacing.radiusSm,
                        ),
                        child: Image.file(
                          File(entry.value),
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              Container(
                                width: 80,
                                height: 80,
                                color: AppColors.cardDark,
                                child: const Icon(
                                  LucideIcons.imageOff,
                                  color: AppColors.textMutedDark,
                                ),
                              ),
                        ),
                      ),
                      Positioned(
                        top: 4,
                        right: 4,
                        child: GestureDetector(
                          onTap: () => onRemove(entry.key),
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: AppColors.error,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              LucideIcons.x,
                              size: 12,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTypeButton({
    required IconData icon,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Material(
      color: isSelected ? AppColors.bazarColor : AppColors.cardDark,
      borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: isSelected ? Colors.white : AppColors.textSecondaryDark,
                size: 18,
              ),
              const Gap(AppSpacing.sm),
              Text(
                label,
                style: AppTypography.labelMedium.copyWith(
                  color: isSelected ? Colors.white : AppColors.textPrimaryDark,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _pickImage({required bool isReceipt}) async {
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      backgroundColor: AppColors.surfaceDark,
      builder: (context) => Container(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(
                LucideIcons.camera,
                color: AppColors.bazarColor,
              ),
              title: Text(
                'Take Photo',
                style: TextStyle(color: AppColors.textPrimaryDark),
              ),
              onTap: () => Navigator.pop(context, ImageSource.camera),
            ),
            ListTile(
              leading: const Icon(
                LucideIcons.image,
                color: AppColors.bazarColor,
              ),
              title: Text(
                'Choose from Gallery',
                style: TextStyle(color: AppColors.textPrimaryDark),
              ),
              onTap: () => Navigator.pop(context, ImageSource.gallery),
            ),
          ],
        ),
      ),
    );

    if (source == null) return;

    try {
      final pickedFile = await _picker.pickImage(
        source: source,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 80,
      );

      if (pickedFile != null) {
        setState(() {
          if (isReceipt) {
            _receiptUrls.add(pickedFile.path);
          } else {
            _photoUrls.add(pickedFile.path);
          }
        });
      }
    } catch (e) {
      // Handle error silently
    }
  }

  void _addItem() {
    final name = _itemNameController.text.trim();
    final price = double.tryParse(_itemPriceController.text) ?? 0;
    if (name.isEmpty || price <= 0) return;

    setState(() {
      _items.add(BazarItem(name: name, price: price));
      _itemNameController.clear();
      _itemPriceController.clear();
    });
  }

  void _submit() {
    if (_selectedMemberId == null) return;

    double amount;
    if (_isItemized) {
      amount = _items.fold(0.0, (sum, i) => sum + i.price);
      if (_items.isEmpty) return;
    } else {
      amount = double.tryParse(_amountController.text) ?? 0;
      if (amount <= 0) return;
    }

    final entry = BazarEntry(
      id: 'bazar_${DateTime.now().millisecondsSinceEpoch}',
      memberId: _selectedMemberId!,
      date: _selectedDate,
      amount: amount,
      description: _descriptionController.text.trim().isNotEmpty
          ? _descriptionController.text.trim()
          : null,
      isItemized: _isItemized,
      items: _isItemized ? _items : [],
      photoUrls: _photoUrls,
      receiptUrls: _receiptUrls,
      createdAt: DateTime.now(),
    );

    ref.read(bazarEntriesProvider.notifier).addEntry(entry);
    Navigator.of(context).pop();
  }
}
