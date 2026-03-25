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
import 'package:mess_manager/core/widgets/quick_input_widgets.dart';
import 'package:mess_manager/features/bazar/providers/bazar_provider.dart';

/// Streamlined bazar entry sheet — amount-first, fewer taps.
///
/// - Amount field autofocused with quick presets
/// - NLP auto-detects silently (no confirm dialog)
/// - Compact segmented entry type selector
/// - Photo recommended, not required
/// - Inline large-amount warning instead of dialog
/// - Admin payer via MemberAvatarPicker
/// - Edit mode fully supported
class AddBazarSheet extends ConsumerStatefulWidget {
  /// Existing entry for edit mode (null for add mode)
  final BazarEntry? existingEntry;

  const AddBazarSheet({super.key, this.existingEntry});

  @override
  ConsumerState<AddBazarSheet> createState() => _AddBazarSheetState();
}

class _AddBazarSheetState extends ConsumerState<AddBazarSheet> {
  late DateTime _selectedDate;
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _amountFocusNode = FocusNode();
  bool _isItemized = false;
  final List<BazarItem> _items = [];

  // Payer selection (admin only)
  String? _selectedPayerId;

  // NLP Entry Type Detection
  EntryType _selectedType = EntryType.mealBazar;
  bool _isAutoDetected = true;
  double _confidence = 0.5;

  // Photo & Receipt storage
  final List<String> _photoUrls = [];
  final List<String> _receiptUrls = [];
  final ImagePicker _picker = ImagePicker();

  // Item controllers
  final _itemNameController = TextEditingController();
  final _itemPriceController = TextEditingController();

  // Edit mode helper
  bool get _isEditMode => widget.existingEntry != null;

  @override
  void initState() {
    super.initState();
    _descriptionController.addListener(_onDescriptionChanged);

    if (widget.existingEntry != null) {
      final entry = widget.existingEntry!;
      _selectedDate = entry.date;
      _amountController.text = entry.amount.toStringAsFixed(0);
      _descriptionController.text = entry.description ?? '';
      _selectedPayerId = entry.memberId;
      _isItemized = entry.isItemized;
      _items.addAll(entry.items);
      _photoUrls.addAll(entry.photoUrls);
      _receiptUrls.addAll(entry.receiptUrls);
      _selectedType = EntryType.mealBazar;
      _isAutoDetected = false;
    } else {
      _selectedDate = DateTime.now();
      // Autofocus amount field after build
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _amountFocusNode.requestFocus();
      });
    }
  }

  void _onDescriptionChanged() {
    final text = _descriptionController.text.trim();
    if (text.isEmpty) return;

    final result = NLPCategorizer().categorize(text);
    setState(() {
      _selectedType = result.type;
      _isAutoDetected = true;
      _confidence = result.confidence;
    });
  }

  @override
  void dispose() {
    _descriptionController.removeListener(_onDescriptionChanged);
    _amountController.dispose();
    _descriptionController.dispose();
    _amountFocusNode.dispose();
    _itemNameController.dispose();
    _itemPriceController.dispose();
    super.dispose();
  }

  bool get _isBazarEntry => _selectedType == EntryType.mealBazar;

  double get _currentAmount {
    if (_isItemized) {
      return _items.fold(0.0, (sum, i) => sum + i.price);
    }
    return double.tryParse(_amountController.text) ?? 0;
  }

  bool get _isLargeAmount => _currentAmount > 10000;

  bool get _canSubmit {
    if (_isItemized) {
      return _items.isNotEmpty;
    } else {
      return _currentAmount > 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    final members = ref.watch(membersProvider);
    final currentMember = ref.watch(currentMemberProvider);
    final currentId = ref.watch(currentMemberIdProvider);

    final isAdmin = currentMember?.role == MemberRole.superAdmin ||
        currentMember?.role == MemberRole.admin;

    _selectedPayerId ??= currentId;

    return Container(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.md,
        AppSpacing.lg,
        AppSpacing.lg,
      ),
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.88,
      ),
      decoration: BoxDecoration(
        color: context.surfaceColor,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(AppSpacing.radiusXl),
        ),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Handle ──
            Center(
              child: Container(
                width: 36,
                height: 4,
                margin: const EdgeInsets.only(bottom: AppSpacing.md),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.bazarColor.withValues(alpha: 0.4),
                      AppColors.bazarColor.withValues(alpha: 0.15),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),

            // ── Header row ──
            Row(
              children: [
                const Icon(
                  LucideIcons.shoppingCart,
                  color: AppColors.bazarColor,
                  size: 22,
                ),
                const Gap(AppSpacing.sm),
                Text(
                  _isEditMode ? 'Edit entry' : 'Add entry',
                  style: AppTypography.headlineMedium.copyWith(
                    color: context.textPrimary,
                  ),
                ),
                const Spacer(),
                // Date chip
                GestureDetector(
                  onTap: _pickDate,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.bazarColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                      border: Border.all(
                        color: AppColors.bazarColor.withValues(alpha: 0.2),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          LucideIcons.calendar,
                          size: 13,
                          color: AppColors.bazarColor,
                        ),
                        const Gap(4),
                        Text(
                          _formatDate(_selectedDate),
                          style: AppTypography.labelSmall.copyWith(
                            color: AppColors.bazarColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ).animate().fadeIn(duration: 200.ms),
            const Gap(AppSpacing.md + 4),

            // ══════════════════════════════════════════════════════════
            // 1. AMOUNT FIELD — first, autofocused
            // ══════════════════════════════════════════════════════════
            if (!_isItemized) ...[
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
                style: AppTypography.monoLarge.copyWith(
                  color: context.textPrimary,
                  fontSize: 24,
                ),
                onChanged: (_) => setState(() {}),
                decoration: InputDecoration(
                  hintText: '0',
                  hintStyle: AppTypography.monoLarge.copyWith(
                    color: context.textMuted,
                    fontSize: 24,
                  ),
                  prefixText: '৳ ',
                  prefixStyle: AppTypography.monoLarge.copyWith(
                    color: AppColors.bazarColor,
                    fontSize: 24,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                    vertical: AppSpacing.sm + 2,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                    borderSide: const BorderSide(
                      color: AppColors.bazarColor,
                      width: 2,
                    ),
                  ),
                ),
              ).animate().fadeIn(duration: 150.ms),

              // Inline large amount warning
              if (_isLargeAmount) ...[
                const Gap(AppSpacing.xs),
                Row(
                  children: [
                    Icon(
                      LucideIcons.alertTriangle,
                      size: 13,
                      color: AppColors.warning,
                    ),
                    const Gap(4),
                    Text(
                      'Large amount -- double-check before submitting',
                      style: AppTypography.labelSmall.copyWith(
                        color: AppColors.warning,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ).animate().fadeIn(duration: 150.ms).shakeX(
                      amount: 2,
                      duration: 300.ms,
                    ),
              ],
              const Gap(AppSpacing.sm),

              // ── Quick amount presets ──
              QuickAmountPicker(
                selectedAmount: double.tryParse(_amountController.text),
                controller: _amountController,
                accentColor: AppColors.bazarColor,
                onAmountSelected: (amount) {
                  setState(() {
                    _amountController.text = amount.toStringAsFixed(0);
                  });
                },
              ).animate().fadeIn(delay: 50.ms, duration: 150.ms),
              const Gap(AppSpacing.md + 4),
            ] else ...[
              // ── Itemized mode ──
              _buildItemizedSection(),
              const Gap(AppSpacing.md + 4),
            ],

            // ══════════════════════════════════════════════════════════
            // 2. DESCRIPTION — with NLP sparkles indicator
            // ══════════════════════════════════════════════════════════
            Row(
              children: [
                Text(
                  'Description',
                  style: AppTypography.labelMedium.copyWith(
                    color: context.textSecondary,
                  ),
                ),
                if (_isAutoDetected &&
                    _descriptionController.text.isNotEmpty) ...[
                  const Gap(6),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: (_confidence > 0.7
                              ? AppColors.success
                              : AppColors.warning)
                          .withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          LucideIcons.sparkles,
                          size: 11,
                          color: _confidence > 0.7
                              ? AppColors.success
                              : AppColors.warning,
                        ),
                        const Gap(3),
                        Text(
                          _getTypeLabel(_selectedType),
                          style: AppTypography.labelSmall.copyWith(
                            color: _confidence > 0.7
                                ? AppColors.success
                                : AppColors.warning,
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
            const Gap(AppSpacing.xs),
            TextField(
              controller: _descriptionController,
              style: AppTypography.bodyMedium.copyWith(
                color: context.textPrimary,
              ),
              decoration: InputDecoration(
                hintText: 'e.g. rice, fish, soap...',
                hintStyle: AppTypography.bodyMedium.copyWith(
                  color: context.textMuted,
                ),
              ),
            ).animate().fadeIn(delay: 100.ms, duration: 150.ms),
            const Gap(AppSpacing.md + 4),

            // ══════════════════════════════════════════════════════════
            // 3. ENTRY TYPE — compact segmented control
            // ══════════════════════════════════════════════════════════
            Text(
              'Entry type',
              style: AppTypography.labelMedium.copyWith(
                color: context.textSecondary,
              ),
            ),
            const Gap(AppSpacing.xs),
            _buildCompactTypeSelector()
                .animate()
                .fadeIn(delay: 150.ms, duration: 150.ms),
            const Gap(AppSpacing.md + 4),

            // ══════════════════════════════════════════════════════════
            // 4. SIMPLE / ITEMIZED TOGGLE (bazar only, compact)
            // ══════════════════════════════════════════════════════════
            if (_isBazarEntry) ...[
              _buildCompactModeToggle()
                  .animate()
                  .fadeIn(delay: 200.ms, duration: 150.ms),
              const Gap(AppSpacing.md),
            ],

            // ══════════════════════════════════════════════════════════
            // 5. PHOTO ROW (compact, recommended not required)
            // ══════════════════════════════════════════════════════════
            if (_isBazarEntry) ...[
              _buildCompactPhotoRow()
                  .animate()
                  .fadeIn(delay: 250.ms, duration: 150.ms),
              const Gap(AppSpacing.sm),

              // Receipts row (if any exist, or show add button)
              if (_receiptUrls.isNotEmpty)
                _buildCompactReceiptRow()
                    .animate()
                    .fadeIn(delay: 280.ms, duration: 150.ms),
              const Gap(AppSpacing.md),
            ],

            // ══════════════════════════════════════════════════════════
            // 6. ADMIN PAYER SELECTOR — avatar picker
            // ══════════════════════════════════════════════════════════
            if (isAdmin) ...[
              Text(
                'Who paid',
                style: AppTypography.labelMedium.copyWith(
                  color: context.textSecondary,
                ),
              ),
              const Gap(AppSpacing.sm),
              MemberAvatarPicker(
                members: members,
                selectedMemberId: _selectedPayerId,
                accentColor: AppColors.bazarColor,
                onMemberSelected: (id) {
                  HapticService.selectionTick();
                  setState(() => _selectedPayerId = id);
                },
              ).animate().fadeIn(delay: 300.ms, duration: 150.ms),
              const Gap(AppSpacing.md),
            ],

            // ══════════════════════════════════════════════════════════
            // 7. SUBMIT BUTTON
            // ══════════════════════════════════════════════════════════
            const Gap(AppSpacing.sm),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _canSubmit ? _submit : null,
                icon: Icon(
                  _isEditMode ? LucideIcons.save : LucideIcons.check,
                  size: 20,
                ),
                label: Text(
                  _isEditMode
                      ? 'Update ${_getTypeLabel(_selectedType)}'
                      : 'Add ${_getTypeLabel(_selectedType)}',
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _getTypeColor(_selectedType),
                  padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                  disabledBackgroundColor: context.cardColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                  ),
                ),
              ),
            ).animate().fadeIn(delay: 350.ms, duration: 200.ms),
            const Gap(AppSpacing.md),
          ],
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // COMPACT ENTRY TYPE SELECTOR — segmented control
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildCompactTypeSelector() {
    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: context.cardColor,
        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
        border: Border.all(
          color: context.borderColor.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: EntryType.values.map((type) {
          final isSelected = _selectedType == type;
          final color = _getTypeColor(type);
          return Expanded(
            child: GestureDetector(
              onTap: () {
                HapticService.selectionTick();
                setState(() {
                  _selectedType = type;
                  _isAutoDetected = false;
                });
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected ? color.withValues(alpha: 0.18) : null,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusXs),
                  border: isSelected
                      ? Border.all(color: color.withValues(alpha: 0.4))
                      : null,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      _getTypeIcon(type),
                      size: 14,
                      color: isSelected ? color : context.textMuted,
                    ),
                    const Gap(5),
                    Text(
                      _getTypeLabel(type),
                      style: AppTypography.labelMedium.copyWith(
                        color: isSelected ? color : context.textMuted,
                        fontWeight:
                            isSelected ? FontWeight.w700 : FontWeight.w400,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // COMPACT SIMPLE / ITEMIZED TOGGLE
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildCompactModeToggle() {
    return Row(
      children: [
        Text(
          'Mode',
          style: AppTypography.labelMedium.copyWith(
            color: context.textSecondary,
          ),
        ),
        const Spacer(),
        Container(
          padding: const EdgeInsets.all(2),
          decoration: BoxDecoration(
            color: context.cardColor,
            borderRadius: BorderRadius.circular(AppSpacing.radiusXs),
            border: Border.all(
              color: context.borderColor.withValues(alpha: 0.3),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildMiniToggle(
                icon: LucideIcons.banknote,
                label: 'Simple',
                isSelected: !_isItemized,
                onTap: () => setState(() => _isItemized = false),
              ),
              _buildMiniToggle(
                icon: LucideIcons.list,
                label: 'Itemized',
                isSelected: _isItemized,
                onTap: () => setState(() => _isItemized = true),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMiniToggle({
    required IconData icon,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: () {
        HapticService.selectionTick();
        onTap();
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.bazarColor.withValues(alpha: 0.18)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(AppSpacing.radiusXs - 2),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 13,
              color: isSelected ? AppColors.bazarColor : context.textMuted,
            ),
            const Gap(4),
            Text(
              label,
              style: AppTypography.labelSmall.copyWith(
                color: isSelected ? AppColors.bazarColor : context.textMuted,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // COMPACT PHOTO ROW — single row, not blocking
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildCompactPhotoRow() {
    final hasPhotos = _photoUrls.isNotEmpty;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm + 2,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: context.cardColor,
        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
        border: Border.all(
          color: context.borderColor.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          // Camera button
          GestureDetector(
            onTap: () => _pickImage(isReceipt: false),
            child: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppColors.bazarColor.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(AppSpacing.radiusXs),
                border: Border.all(
                  color: AppColors.bazarColor.withValues(alpha: 0.25),
                ),
              ),
              child: const Icon(
                LucideIcons.camera,
                color: AppColors.bazarColor,
                size: 20,
              ),
            ),
          ),
          const Gap(AppSpacing.sm),

          // Photo previews (scrollable)
          if (hasPhotos)
            Expanded(
              child: SizedBox(
                height: 44,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: _photoUrls.length,
                  separatorBuilder: (_, i) => const Gap(6),
                  itemBuilder: (context, index) {
                    return Stack(
                      clipBehavior: Clip.none,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(
                            AppSpacing.radiusXs,
                          ),
                          child: Image.file(
                            File(_photoUrls[index]),
                            width: 44,
                            height: 44,
                            fit: BoxFit.cover,
                            errorBuilder: (_, e, s) => Container(
                              width: 44,
                              height: 44,
                              color: context.cardColor,
                              child: Icon(
                                LucideIcons.imageOff,
                                color: context.textMuted,
                                size: 16,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          top: -4,
                          right: -4,
                          child: GestureDetector(
                            onTap: () {
                              HapticService.lightTap();
                              setState(() => _photoUrls.removeAt(index));
                            },
                            child: Container(
                              width: 18,
                              height: 18,
                              decoration: const BoxDecoration(
                                color: AppColors.error,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                LucideIcons.x,
                                size: 10,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            )
          else
            Expanded(
              child: Text(
                'Add photos (recommended)',
                style: AppTypography.bodySmall.copyWith(
                  color: context.textMuted,
                ),
              ),
            ),

          // Receipt add button
          const Gap(AppSpacing.sm),
          GestureDetector(
            onTap: () => _pickImage(isReceipt: true),
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.04),
                borderRadius: BorderRadius.circular(AppSpacing.radiusXs),
                border: Border.all(
                  color: context.borderColor.withValues(alpha: 0.2),
                ),
              ),
              child: Icon(
                LucideIcons.receipt,
                color: context.textMuted,
                size: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // COMPACT RECEIPT ROW — only shown if receipts exist
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildCompactReceiptRow() {
    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.sm),
      child: SizedBox(
        height: 40,
        child: Row(
          children: [
            Icon(
              LucideIcons.receipt,
              size: 14,
              color: context.textMuted,
            ),
            const Gap(6),
            Text(
              'Receipts',
              style: AppTypography.labelSmall.copyWith(
                color: context.textMuted,
              ),
            ),
            const Gap(AppSpacing.sm),
            Expanded(
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: _receiptUrls.length,
                separatorBuilder: (_, i) => const Gap(6),
                itemBuilder: (context, index) {
                  return Stack(
                    clipBehavior: Clip.none,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(
                          AppSpacing.radiusXs,
                        ),
                        child: Image.file(
                          File(_receiptUrls[index]),
                          width: 40,
                          height: 40,
                          fit: BoxFit.cover,
                          errorBuilder: (c, e, s) => Container(
                            width: 40,
                            height: 40,
                            color: context.cardColor,
                            child: Icon(
                              LucideIcons.imageOff,
                              color: context.textMuted,
                              size: 14,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: -4,
                        right: -4,
                        child: GestureDetector(
                          onTap: () {
                            HapticService.lightTap();
                            setState(() => _receiptUrls.removeAt(index));
                          },
                          child: Container(
                            width: 16,
                            height: 16,
                            decoration: const BoxDecoration(
                              color: AppColors.error,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              LucideIcons.x,
                              size: 9,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // ITEMIZED SECTION
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildItemizedSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Items',
          style: AppTypography.labelMedium.copyWith(
            color: context.textSecondary,
          ),
        ),
        const Gap(AppSpacing.sm),

        // Existing items
        ..._items.asMap().entries.map((entry) {
          final item = entry.value;
          return Container(
            margin: const EdgeInsets.only(bottom: AppSpacing.xs),
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.sm + 2,
              vertical: AppSpacing.sm,
            ),
            decoration: BoxDecoration(
              color: context.cardColor,
              borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    item.name,
                    style: AppTypography.bodyMedium.copyWith(
                      color: context.textPrimary,
                    ),
                  ),
                ),
                Text(
                  '৳${item.price.toStringAsFixed(0)}',
                  style: AppTypography.labelMedium.copyWith(
                    color: AppColors.bazarColor,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'JetBrains Mono',
                  ),
                ),
                const Gap(4),
                GestureDetector(
                  onTap: () {
                    HapticService.lightTap();
                    setState(() => _items.removeAt(entry.key));
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(4),
                    child: Icon(
                      LucideIcons.x,
                      size: 14,
                      color: AppColors.error.withValues(alpha: 0.7),
                    ),
                  ),
                ),
              ],
            ),
          );
        }),

        // Add item row
        Row(
          children: [
            Expanded(
              flex: 2,
              child: TextField(
                controller: _itemNameController,
                style: AppTypography.bodyMedium.copyWith(
                  color: context.textPrimary,
                ),
                decoration: InputDecoration(
                  hintText: 'Item name',
                  hintStyle: AppTypography.bodyMedium.copyWith(
                    color: context.textMuted,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
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
                  color: context.textPrimary,
                ),
                decoration: InputDecoration(
                  hintText: '৳',
                  hintStyle: AppTypography.bodyMedium.copyWith(
                    color: context.textMuted,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.sm,
                    vertical: AppSpacing.sm,
                  ),
                ),
              ),
            ),
            const Gap(AppSpacing.sm),
            GestureDetector(
              onTap: _addItem,
              child: Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: AppColors.bazarColor,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusXs),
                ),
                child: const Icon(
                  LucideIcons.plus,
                  size: 18,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),

        // Total
        if (_items.isNotEmpty) ...[
          const Gap(AppSpacing.sm),
          Container(
            padding: const EdgeInsets.all(AppSpacing.sm + 2),
            decoration: BoxDecoration(
              color: AppColors.bazarColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
              border: Border.all(
                color: AppColors.bazarColor.withValues(alpha: 0.2),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total',
                  style: AppTypography.titleSmall.copyWith(
                    color: context.textPrimary,
                  ),
                ),
                Text(
                  '৳${_items.fold(0.0, (sum, i) => sum + i.price).toStringAsFixed(0)}',
                  style: AppTypography.titleMedium.copyWith(
                    color: AppColors.bazarColor,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'JetBrains Mono',
                  ),
                ),
              ],
            ),
          ),
          // Inline large amount warning for itemized
          if (_isLargeAmount) ...[
            const Gap(AppSpacing.xs),
            Row(
              children: [
                Icon(
                  LucideIcons.alertTriangle,
                  size: 13,
                  color: AppColors.warning,
                ),
                const Gap(4),
                Text(
                  'Large amount -- double-check before submitting',
                  style: AppTypography.labelSmall.copyWith(
                    color: AppColors.warning,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ],
      ],
    ).animate().fadeIn(duration: 150.ms);
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // HELPERS
  // ═══════════════════════════════════════════════════════════════════════════

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

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final dateOnly = DateTime(date.year, date.month, date.day);

    if (dateOnly == today) return 'Today';
    if (dateOnly == today.subtract(const Duration(days: 1))) return 'Yesterday';

    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return '${date.day} ${months[date.month - 1]}';
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // ACTIONS
  // ═══════════════════════════════════════════════════════════════════════════

  Future<void> _pickDate() async {
    HapticService.lightTap();
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now().subtract(const Duration(days: 90)),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
                  primary: AppColors.bazarColor,
                ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  Future<void> _pickImage({required bool isReceipt}) async {
    HapticService.modalOpen();
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      backgroundColor: context.surfaceColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppSpacing.radiusLg),
        ),
      ),
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
                'Take photo',
                style: TextStyle(color: context.textPrimary),
              ),
              onTap: () => Navigator.pop(context, ImageSource.camera),
            ),
            ListTile(
              leading: const Icon(
                LucideIcons.image,
                color: AppColors.bazarColor,
              ),
              title: Text(
                'Choose from gallery',
                style: TextStyle(color: context.textPrimary),
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

  void _submit() async {
    double amount;
    if (_isItemized) {
      amount = _items.fold(0.0, (sum, i) => sum + i.price);
      if (_items.isEmpty) return;
    } else {
      amount = double.tryParse(_amountController.text) ?? 0;
      if (amount <= 0) return;
    }

    HapticService.success();

    if (_isEditMode) {
      final updatedEntry = widget.existingEntry!.copyWith(
        memberId: _selectedPayerId ?? widget.existingEntry!.memberId,
        date: _selectedDate,
        amount: amount,
        description: _descriptionController.text.trim().isNotEmpty
            ? _descriptionController.text.trim()
            : null,
        isItemized: _isItemized,
        items: _isItemized ? _items : [],
        photoUrls: _photoUrls,
        receiptUrls: _receiptUrls,
      );
      ref.read(bazarEntriesProvider.notifier).updateEntry(updatedEntry);
      Navigator.of(context).pop();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Updated ৳${amount.toStringAsFixed(0)} bazar entry'),
          backgroundColor: AppColors.success,
        ),
      );
    } else {
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
}
