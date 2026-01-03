import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:gap/gap.dart';
import 'package:image_picker/image_picker.dart';

import 'package:mess_manager/core/theme/app_theme.dart';
import 'package:mess_manager/core/models/bazar_entry.dart';
import 'package:mess_manager/core/models/member.dart';
import 'package:mess_manager/core/models/unified_entry.dart';
import 'package:mess_manager/core/services/haptic_service.dart';
import 'package:mess_manager/core/services/nlp_categorizer.dart';
import 'package:mess_manager/core/providers/members_provider.dart';
import 'package:mess_manager/features/bazar/providers/bazar_provider.dart';

/// Add Entry Sheet - Unified
///
/// - NLP auto-detects entry type (meal/bazar/fixed/monthly)
/// - Photo required for bazar entries
/// - Receipts optional (multiple allowed)
/// - Admin/SuperAdmin can select payer
/// - Supports Simple or Itemized for bazar
class AddBazarSheet extends ConsumerStatefulWidget {
  const AddBazarSheet({super.key});

  @override
  ConsumerState<AddBazarSheet> createState() => _AddBazarSheetState();
}

class _AddBazarSheetState extends ConsumerState<AddBazarSheet> {
  final DateTime _selectedDate = DateTime.now();
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();
  bool _isItemized = false;
  final List<BazarItem> _items = [];

  // Payer selection (admin only)
  String? _selectedPayerId;

  // NLP Entry Type Detection
  EntryType _selectedType = EntryType.mealBazar;
  MonthlyCategory? _selectedCategory;
  bool _isAutoDetected = true;
  double _confidence = 0.5;

  // Photo & Receipt storage (for bazar entries)
  final List<String> _photoUrls = [];
  final List<String> _receiptUrls = [];
  final ImagePicker _picker = ImagePicker();

  // Item controllers
  final _itemNameController = TextEditingController();
  final _itemPriceController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _descriptionController.addListener(_onDescriptionChanged);
  }

  void _onDescriptionChanged() {
    final text = _descriptionController.text.trim();
    if (text.isEmpty) return;

    final result = NLPCategorizer.categorize(text);
    setState(() {
      _selectedType = result.type;
      _selectedCategory = result.category;
      _isAutoDetected = true;
      _confidence = result.confidence;
    });
  }

  @override
  void dispose() {
    _descriptionController.removeListener(_onDescriptionChanged);
    _amountController.dispose();
    _descriptionController.dispose();
    _itemNameController.dispose();
    _itemPriceController.dispose();
    super.dispose();
  }

  // Photo required only for bazar entries
  bool get _isBazarEntry => _selectedType == EntryType.mealBazar;
  bool get _hasRequiredPhoto => !_isBazarEntry || _photoUrls.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    final members = ref.watch(membersProvider);
    final currentMember = ref.watch(currentMemberProvider);
    final currentId = ref.watch(currentMemberIdProvider);

    // Check if user is admin (can select payer)
    final isAdmin =
        currentMember?.role == MemberRole.superAdmin ||
        currentMember?.role == MemberRole.admin;

    // Initialize payer to current user if not set
    _selectedPayerId ??= currentId;

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
                const Icon(
                  LucideIcons.shoppingCart,
                  color: AppColors.bazarColor,
                  size: 24,
                ),
                const Gap(AppSpacing.sm),
                Text(
                  'Add Entry',
                  style: AppTypography.headlineMedium.copyWith(
                    color: AppColors.textPrimaryDark,
                  ),
                ),
              ],
            ).animate().fadeIn(),
            const Gap(AppSpacing.md),

            // Admin: Payer Selector / Member: Info text
            if (isAdmin) ...[
              Text(
                'Who Paid',
                style: AppTypography.labelMedium.copyWith(
                  color: AppColors.textSecondaryDark,
                ),
              ),
              const Gap(AppSpacing.sm),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                decoration: BoxDecoration(
                  color: AppColors.cardDark,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                  border: Border.all(color: AppColors.borderDark),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _selectedPayerId,
                    isExpanded: true,
                    dropdownColor: AppColors.cardDark,
                    icon: const Icon(LucideIcons.chevronDown, size: 18),
                    items: members
                        .map(
                          (m) => DropdownMenuItem(
                            value: m.id,
                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius: 14,
                                  backgroundColor: AppColors.primary.withValues(
                                    alpha: 0.2,
                                  ),
                                  child: Text(
                                    m.name.isNotEmpty
                                        ? m.name[0].toUpperCase()
                                        : '?',
                                    style: AppTypography.labelSmall.copyWith(
                                      color: AppColors.primary,
                                    ),
                                  ),
                                ),
                                const Gap(AppSpacing.sm),
                                Text(
                                  m.name,
                                  style: AppTypography.bodyMedium.copyWith(
                                    color: AppColors.textPrimaryDark,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                        .toList(),
                    onChanged: (value) =>
                        setState(() => _selectedPayerId = value),
                  ),
                ),
              ).animate().fadeIn(delay: 100.ms),
            ] else ...[
              // Non-admin: Show info text
              Container(
                padding: const EdgeInsets.all(AppSpacing.sm),
                decoration: BoxDecoration(
                  color: AppColors.info.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                ),
                child: Row(
                  children: [
                    const Icon(
                      LucideIcons.user,
                      color: AppColors.info,
                      size: 14,
                    ),
                    const Gap(AppSpacing.sm),
                    Expanded(
                      child: Text(
                        'This entry will be added under your name',
                        style: AppTypography.bodySmall.copyWith(
                          color: AppColors.textSecondaryDark,
                        ),
                      ),
                    ),
                  ],
                ),
              ).animate().fadeIn(delay: 100.ms),
            ],
            const Gap(AppSpacing.lg),

            // NLP Entry Type Selector
            Row(
              children: [
                Text(
                  'Entry Type',
                  style: AppTypography.labelMedium.copyWith(
                    color: AppColors.textSecondaryDark,
                  ),
                ),
                if (_isAutoDetected &&
                    _descriptionController.text.isNotEmpty) ...[
                  const Gap(AppSpacing.sm),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: _confidence > 0.7
                          ? AppColors.success.withValues(alpha: 0.2)
                          : AppColors.warning.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          LucideIcons.sparkles,
                          size: 12,
                          color: _confidence > 0.7
                              ? AppColors.success
                              : AppColors.warning,
                        ),
                        const Gap(4),
                        Text(
                          'Auto',
                          style: AppTypography.labelSmall.copyWith(
                            color: _confidence > 0.7
                                ? AppColors.success
                                : AppColors.warning,
                          ),
                        ),
                      ],
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
                      margin: EdgeInsets.only(
                        right: type != EntryType.values.last
                            ? AppSpacing.xs
                            : 0,
                      ),
                      padding: const EdgeInsets.symmetric(
                        vertical: AppSpacing.sm,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? _getTypeColor(type).withValues(alpha: 0.2)
                            : AppColors.cardDark,
                        borderRadius: BorderRadius.circular(
                          AppSpacing.radiusSm,
                        ),
                        border: Border.all(
                          color: isSelected
                              ? _getTypeColor(type)
                              : AppColors.borderDark.withValues(alpha: 0.5),
                        ),
                      ),
                      child: Column(
                        children: [
                          Icon(
                            _getTypeIcon(type),
                            size: 18,
                            color: isSelected
                                ? _getTypeColor(type)
                                : AppColors.textMutedDark,
                          ),
                          const Gap(4),
                          Text(
                            _getTypeLabel(type),
                            style: AppTypography.labelSmall.copyWith(
                              color: isSelected
                                  ? _getTypeColor(type)
                                  : AppColors.textMutedDark,
                              fontWeight: isSelected
                                  ? FontWeight.w600
                                  : FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            ).animate().fadeIn(delay: 150.ms),
            const Gap(AppSpacing.lg),

            // Bazar-specific: Simple/Itemized Toggle (only for bazar entries)
            if (_isBazarEntry) ...[
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
              ).animate().fadeIn(delay: 200.ms),
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
                ).animate().fadeIn(delay: 300.ms),
              ] else ...[
                // Itemized Mode
                _buildItemizedSection(),
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
                decoration: const InputDecoration(
                  hintText: 'What was this for?',
                ),
              ).animate().fadeIn(delay: 400.ms),
              const Gap(AppSpacing.lg),

              // 📸 Photos Section (REQUIRED)
              _buildPhotoSection(
                title: 'Bazar Photos',
                subtitle: 'At least one photo required',
                icon: LucideIcons.camera,
                photos: _photoUrls,
                isRequired: true,
                onAdd: () => _pickImage(isReceipt: false),
                onRemove: (index) => setState(() => _photoUrls.removeAt(index)),
              ),
              const Gap(AppSpacing.lg),

              // 🧾 Receipts Section (Optional)
              _buildPhotoSection(
                title: 'Receipts',
                subtitle: 'Optional - upload if available',
                icon: LucideIcons.receipt,
                photos: _receiptUrls,
                isRequired: false,
                onAdd: () => _pickImage(isReceipt: true),
                onRemove: (index) =>
                    setState(() => _receiptUrls.removeAt(index)),
              ),
            ] else ...[
              // Non-bazar: Simple amount entry
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
                    color: _getTypeColor(_selectedType),
                  ),
                ),
              ).animate().fadeIn(delay: 200.ms),
              const Gap(AppSpacing.lg),

              // Description for NLP
              Text(
                'Description',
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
                  hintText: 'What is this for?',
                ),
              ).animate().fadeIn(delay: 250.ms),
            ],
            const Gap(AppSpacing.xl),

            // Submit Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _canSubmit ? _submit : null,
                icon: const Icon(LucideIcons.check, size: 20),
                label: Text(_getSubmitLabel()),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _getTypeColor(_selectedType),
                  padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                  disabledBackgroundColor: AppColors.cardDark,
                ),
              ),
            ).animate().fadeIn(delay: 500.ms),
            const Gap(AppSpacing.md),
          ],
        ),
      ),
    );
  }

  String _getSubmitLabel() {
    if (_isBazarEntry && !_hasRequiredPhoto) return 'Photo Required';
    return 'Add ${_getTypeLabel(_selectedType)}';
  }

  Color _getTypeColor(EntryType type) {
    switch (type) {
      case EntryType.mealBazar:
        return AppColors.bazarColor;
      case EntryType.monthly:
        return AppColors.info;
      case EntryType.fixed:
        return AppColors.warning;
    }
  }

  IconData _getTypeIcon(EntryType type) {
    switch (type) {
      case EntryType.mealBazar:
        return LucideIcons.shoppingCart;
      case EntryType.monthly:
        return LucideIcons.refreshCw;
      case EntryType.fixed:
        return LucideIcons.building;
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

  bool get _canSubmit {
    if (!_hasRequiredPhoto) return false;
    if (_isItemized) {
      return _items.isNotEmpty;
    } else {
      final amount = double.tryParse(_amountController.text) ?? 0;
      return amount > 0;
    }
  }

  Widget _buildItemizedSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
                  onPressed: () {
                    HapticService.lightTap();
                    setState(() => _items.removeAt(entry.key));
                  },
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
        if (_items.isNotEmpty)
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
    ).animate().fadeIn(delay: 300.ms);
  }

  Widget _buildPhotoSection({
    required String title,
    required String subtitle,
    required IconData icon,
    required List<String> photos,
    required bool isRequired,
    required VoidCallback onAdd,
    required Function(int) onRemove,
  }) {
    final hasPhotos = photos.isNotEmpty;
    final color = isRequired && !hasPhotos
        ? AppColors.warning
        : AppColors.bazarColor;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 18, color: color),
            const Gap(AppSpacing.sm),
            Text(
              title,
              style: AppTypography.labelMedium.copyWith(
                color: AppColors.textSecondaryDark,
              ),
            ),
            if (isRequired) ...[
              const Gap(AppSpacing.xs),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: hasPhotos
                      ? AppColors.success.withValues(alpha: 0.2)
                      : AppColors.warning.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  hasPhotos ? '✓' : 'Required',
                  style: AppTypography.labelSmall.copyWith(
                    color: hasPhotos ? AppColors.success : AppColors.warning,
                    fontSize: 10,
                  ),
                ),
              ),
            ],
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
                onTap: () {
                  HapticService.lightTap();
                  onAdd();
                },
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: AppColors.cardDark,
                    borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                    border: Border.all(color: color.withValues(alpha: 0.5)),
                  ),
                  child: Icon(LucideIcons.plus, color: color, size: 24),
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
                          onTap: () {
                            HapticService.lightTap();
                            onRemove(entry.key);
                          },
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
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
        onTap: () {
          HapticService.lightTap();
          onTap();
        },
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
    HapticService.modalOpen();
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
        HapticService.success();
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

    HapticService.lightTap();
    setState(() {
      _items.add(BazarItem(name: name, price: price));
      _itemNameController.clear();
      _itemPriceController.clear();
    });
  }

  void _submit() {
    double amount;
    if (_isItemized) {
      amount = _items.fold(0.0, (sum, i) => sum + i.price);
      if (_items.isEmpty) return;
    } else {
      amount = double.tryParse(_amountController.text) ?? 0;
      if (amount <= 0) return;
    }

    if (!_hasRequiredPhoto) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please add at least one photo'),
          backgroundColor: AppColors.warning,
        ),
      );
      return;
    }

    HapticService.success();

    final entry = BazarEntry(
      id: 'bazar_${DateTime.now().millisecondsSinceEpoch}',
      memberId: _selectedPayerId ?? 'current_user',
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

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Added ৳${amount.toStringAsFixed(0)} bazar entry'),
        backgroundColor: AppColors.success,
      ),
    );
  }
}
