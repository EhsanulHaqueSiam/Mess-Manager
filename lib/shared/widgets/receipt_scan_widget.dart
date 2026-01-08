import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:mess_manager/core/services/receipt_ocr_service.dart';
import 'package:mess_manager/core/services/haptic_service.dart';
import 'package:mess_manager/core/theme/app_theme.dart';

/// Receipt Scan Sheet
///
/// Bottom sheet for scanning receipts with camera or gallery.
/// Shows extracted items with prices for review before adding.
class ReceiptScanSheet extends ConsumerStatefulWidget {
  final void Function(List<ReceiptItem> items, double total)? onConfirm;

  const ReceiptScanSheet({super.key, this.onConfirm});

  @override
  ConsumerState<ReceiptScanSheet> createState() => _ReceiptScanSheetState();
}

class _ReceiptScanSheetState extends ConsumerState<ReceiptScanSheet> {
  final Set<int> _selectedItems = {};
  bool _selectAll = true;

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(receiptOcrProvider);
    final notifier = ref.read(receiptOcrProvider.notifier);

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.85,
      ),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surfaceDark,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.borderDark,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 20),

          // Header
          Row(
            children: [
              Icon(LucideIcons.scanLine, color: AppColors.primary),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'Scan Receipt',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              if (state.lastResult != null)
                TextButton(
                  onPressed: () {
                    notifier.clearResult();
                    setState(() {
                      _selectedItems.clear();
                      _selectAll = true;
                    });
                  },
                  child: const Text('Clear'),
                ),
            ],
          ),
          const SizedBox(height: 20),

          // Content
          if (state.isProcessing)
            _buildProcessingView(state)
          else if (state.lastResult != null && state.lastResult!.success)
            Expanded(child: _buildResultsView(state.lastResult!))
          else
            _buildScanOptions(notifier),

          // Error
          if (state.error != null)
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Text(
                state.error!,
                style: TextStyle(color: AppColors.error, fontSize: 12),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildProcessingView(ReceiptOcrState state) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 40),
        SizedBox(
          width: 80,
          height: 80,
          child: CircularProgressIndicator(
            value: state.progress > 0 ? state.progress : null,
            strokeWidth: 3,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(height: 24),
        Text(
          state.progress < 0.3
              ? 'Capturing image...'
              : state.progress < 0.6
              ? 'Extracting text...'
              : 'Parsing items...',
          style: TextStyle(color: AppColors.textSecondaryDark),
        ),
        const SizedBox(height: 40),
      ],
    );
  }

  Widget _buildScanOptions(ReceiptOcrNotifier notifier) {
    return Column(
      children: [
        const SizedBox(height: 20),
        Icon(LucideIcons.receipt, size: 64, color: AppColors.textMutedDark),
        const SizedBox(height: 16),
        Text(
          'Scan a receipt to auto-extract items',
          style: TextStyle(color: AppColors.textSecondaryDark),
        ),
        const SizedBox(height: 32),
        Row(
          children: [
            Expanded(
              child: _buildOptionButton(
                icon: LucideIcons.camera,
                label: 'Camera',
                onTap: () => notifier.scanFromCamera(),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildOptionButton(
                icon: LucideIcons.image,
                label: 'Gallery',
                onTap: () => notifier.scanFromGallery(),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildOptionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: () {
        HapticService.bouncyTap();
        onTap();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 24),
        decoration: BoxDecoration(
          color: AppColors.cardDark,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.borderDark),
        ),
        child: Column(
          children: [
            Icon(icon, size: 32, color: AppColors.primary),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                color: AppColors.textPrimaryDark,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultsView(ReceiptScanResult result) {
    // Initialize selected items if not done
    if (_selectedItems.isEmpty && _selectAll) {
      for (int i = 0; i < result.items.length; i++) {
        _selectedItems.add(i);
      }
    }

    final selectedTotal = result.items
        .asMap()
        .entries
        .where((e) => _selectedItems.contains(e.key))
        .fold<double>(0, (sum, e) => sum + e.value.price);

    return Column(
      children: [
        // Summary card
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${result.items.length} items found',
                      style: TextStyle(
                        color: AppColors.textSecondaryDark,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '৳${selectedTotal.toStringAsFixed(0)}',
                      style: TextStyle(
                        color: AppColors.primary,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              if (result.detectedTotal != null)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Receipt total',
                      style: TextStyle(
                        color: AppColors.textMutedDark,
                        fontSize: 10,
                      ),
                    ),
                    Text(
                      '৳${result.detectedTotal!.toStringAsFixed(0)}',
                      style: TextStyle(
                        color: result.totalMatches
                            ? AppColors.success
                            : AppColors.warning,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
        const SizedBox(height: 12),

        // Select all toggle
        Row(
          children: [
            Checkbox(
              value: _selectedItems.length == result.items.length,
              onChanged: (v) {
                HapticService.checkboxToggle();
                setState(() {
                  if (v == true) {
                    _selectedItems.addAll(
                      List.generate(result.items.length, (i) => i),
                    );
                  } else {
                    _selectedItems.clear();
                  }
                });
              },
              activeColor: AppColors.primary,
            ),
            Text(
              'Select all',
              style: TextStyle(color: AppColors.textSecondaryDark),
            ),
          ],
        ),

        // Items list
        Expanded(
          child: ListView.builder(
            itemCount: result.items.length,
            itemBuilder: (context, index) {
              final item = result.items[index];
              final isSelected = _selectedItems.contains(index);
              final category = ReceiptCategories.categorize(item.name);

              return _buildItemTile(item, index, isSelected, category);
            },
          ),
        ),

        const SizedBox(height: 16),

        // Confirm button
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _selectedItems.isNotEmpty
                ? () {
                    HapticService.bouncyConfirm();
                    final selectedItems = result.items
                        .asMap()
                        .entries
                        .where((e) => _selectedItems.contains(e.key))
                        .map((e) => e.value)
                        .toList();
                    widget.onConfirm?.call(selectedItems, selectedTotal);
                    Navigator.pop(context);
                  }
                : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              'Add ${_selectedItems.length} items (৳${selectedTotal.toStringAsFixed(0)})',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildItemTile(
    ReceiptItem item,
    int index,
    bool isSelected,
    String category,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: isSelected ? AppColors.cardDark : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isSelected
              ? AppColors.primary.withValues(alpha: 0.3)
              : AppColors.borderDark,
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 12),
        leading: Checkbox(
          value: isSelected,
          onChanged: (v) {
            HapticService.checkboxToggle();
            setState(() {
              if (v == true) {
                _selectedItems.add(index);
              } else {
                _selectedItems.remove(index);
              }
            });
          },
          activeColor: AppColors.primary,
        ),
        title: Text(
          item.name,
          style: TextStyle(
            color: AppColors.textPrimaryDark,
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: Text(
          category,
          style: TextStyle(color: AppColors.textMutedDark, fontSize: 12),
        ),
        trailing: Text(
          '৳${item.price.toStringAsFixed(0)}',
          style: TextStyle(
            color: AppColors.accentWarm,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
    ).animate().fadeIn(delay: Duration(milliseconds: 50 * index));
  }
}

/// Show receipt scan sheet
Future<(List<ReceiptItem>, double)?> showReceiptScanSheet(
  BuildContext context,
) async {
  (List<ReceiptItem>, double)? result;

  await showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) =>
        ReceiptScanSheet(onConfirm: (items, total) => result = (items, total)),
  );

  return result;
}
