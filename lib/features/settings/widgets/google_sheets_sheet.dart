import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gap/gap.dart';
import 'package:lucide_icons/lucide_icons.dart';

import 'package:mess_manager/core/theme/app_theme.dart';
import 'package:mess_manager/core/services/haptic_service.dart';
import 'package:mess_manager/core/services/google_sheets_service.dart';
import 'package:mess_manager/core/providers/google_sheets_provider.dart';
import 'package:mess_manager/core/widgets/app_components.dart';

/// Bottom sheet for configuring Google Sheets sync.
class GoogleSheetsSheet extends ConsumerStatefulWidget {
  const GoogleSheetsSheet({super.key});

  static Future<void> show(BuildContext context) {
    HapticService.modalOpen();
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const GoogleSheetsSheet(),
    );
  }

  @override
  ConsumerState<GoogleSheetsSheet> createState() => _GoogleSheetsSheetState();
}

class _GoogleSheetsSheetState extends ConsumerState<GoogleSheetsSheet> {
  final _urlController = TextEditingController();
  bool _enabled = false;
  bool _testing = false;
  String? _testResult;

  @override
  void initState() {
    super.initState();
    final state = ref.read(googleSheetsProvider);
    _urlController.text = state.sheetUrl;
    _enabled = state.isEnabled;
  }

  @override
  void dispose() {
    _urlController.dispose();
    super.dispose();
  }

  Future<void> _testConnection() async {
    setState(() {
      _testing = true;
      _testResult = null;
    });
    HapticService.lightTap();

    // Save first
    await ref.read(googleSheetsProvider.notifier).configure(
          sheetUrl: _urlController.text.trim(),
          enabled: _enabled,
        );

    final success =
        await ref.read(googleSheetsProvider.notifier).testConnection();

    setState(() {
      _testing = false;
      _testResult = success ? 'Connected' : 'Failed';
    });

    if (success) HapticService.success();
  }

  Future<void> _syncNow() async {
    HapticService.buttonPress();

    // Save config first
    await ref.read(googleSheetsProvider.notifier).configure(
          sheetUrl: _urlController.text.trim(),
          enabled: _enabled,
        );

    final result = await ref.read(googleSheetsProvider.notifier).syncNow();

    if (!mounted) return;
    switch (result) {
      case SyncResult.success:
        showSuccessToast(context, 'Synced to Google Sheet');
      case SyncResult.authFailed:
        showErrorToast(context, 'Sign in with Google first');
      case SyncResult.disabled:
        showInfoToast(context, 'Enable sync first');
      case SyncResult.error:
        showErrorToast(context, 'Sync failed');
    }
  }

  Future<void> _save() async {
    await ref.read(googleSheetsProvider.notifier).configure(
          sheetUrl: _urlController.text.trim(),
          enabled: _enabled,
        );
    HapticService.success();
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final sheetsState = ref.watch(googleSheetsProvider);
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return ClipRRect(
      borderRadius: const BorderRadius.vertical(
        top: Radius.circular(AppSpacing.radiusXl),
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFF0D1520).withValues(alpha: 0.95),
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(AppSpacing.radiusXl),
            ),
            border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
          ),
          child: Padding(
            padding: EdgeInsets.fromLTRB(
              AppSpacing.lg,
              AppSpacing.md,
              AppSpacing.lg,
              bottomInset + AppSpacing.lg,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Handle
                Center(
                  child: Container(
                    width: 36,
                    height: 4,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(2),
                      gradient: const LinearGradient(
                        colors: [AppColors.accent, AppColors.accentAlt],
                      ),
                    ),
                  ),
                ),
                const Gap(AppSpacing.md),

                // Title
                Row(
                  children: [
                    Icon(LucideIcons.sheet,
                        color: AppColors.success, size: 22),
                    const Gap(AppSpacing.sm),
                    Text(
                      'Google Sheets sync',
                      style: AppTypography.headlineMedium.copyWith(
                        color: AppColors.textPrimaryDark,
                      ),
                    ),
                  ],
                ),
                const Gap(4),
                Text(
                  'Auto-sync meals, bazar, and balance data to a Google Sheet '
                  'for transparent daily tracking.',
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textMutedDark,
                    height: 1.5,
                  ),
                ),
                const Gap(AppSpacing.lg),

                // Enable toggle
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                    vertical: AppSpacing.sm,
                  ),
                  decoration: AppSpacing.glassTile(radius: AppSpacing.radiusMd),
                  child: Row(
                    children: [
                      Icon(LucideIcons.toggleRight,
                          size: 18, color: AppColors.accent),
                      const Gap(AppSpacing.sm),
                      Expanded(
                        child: Text(
                          'Enable sync',
                          style: AppTypography.titleSmall.copyWith(
                            color: AppColors.textPrimaryDark,
                          ),
                        ),
                      ),
                      Switch.adaptive(
                        value: _enabled,
                        activeColor: AppColors.accent,
                        onChanged: (v) {
                          HapticService.lightTap();
                          setState(() => _enabled = v);
                        },
                      ),
                    ],
                  ),
                ),
                const Gap(AppSpacing.md),

                // Sheet URL input
                AppInput(
                  label: 'Google Sheet URL or ID',
                  hint: 'Paste your Google Sheet URL here',
                  controller: _urlController,
                  prefixIcon: LucideIcons.link,
                  maxLines: 1,
                ),
                const Gap(AppSpacing.xs),
                Text(
                  'Share the sheet with your Google account for write access.',
                  style: AppTypography.labelSmall.copyWith(
                    color: AppColors.textMutedDark,
                  ),
                ),
                const Gap(AppSpacing.md),

                // Test connection button
                Row(
                  children: [
                    Expanded(
                      child: AppSecondaryButton(
                        text: _testing ? 'Testing...' : 'Test connection',
                        icon: LucideIcons.plugZap,
                        color: AppColors.accent,
                        onPressed: _testing ? null : _testConnection,
                      ),
                    ),
                    if (_testResult != null) ...[
                      const Gap(AppSpacing.sm),
                      Icon(
                        _testResult == 'Connected'
                            ? Icons.check_circle
                            : Icons.error,
                        color: _testResult == 'Connected'
                            ? AppColors.success
                            : AppColors.error,
                        size: 22,
                      ),
                    ],
                  ],
                ),

                // Error message
                if (sheetsState.error != null) ...[
                  const Gap(AppSpacing.sm),
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.sm),
                    decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.circular(AppSpacing.radiusXs),
                      color: AppColors.error.withValues(alpha: 0.1),
                      border: Border.all(
                        color: AppColors.error.withValues(alpha: 0.2),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(LucideIcons.alertTriangle,
                            size: 14, color: AppColors.error),
                        const Gap(8),
                        Expanded(
                          child: Text(
                            sheetsState.error!,
                            style: AppTypography.bodySmall.copyWith(
                              color: AppColors.error,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],

                // Last sync info
                if (sheetsState.lastSync != null) ...[
                  const Gap(AppSpacing.sm),
                  Row(
                    children: [
                      Icon(LucideIcons.clock,
                          size: 12, color: AppColors.textMutedDark),
                      const Gap(4),
                      Text(
                        'Last synced: ${_formatDateTime(sheetsState.lastSync!)}',
                        style: AppTypography.labelSmall.copyWith(
                          color: AppColors.textMutedDark,
                        ),
                      ),
                    ],
                  ),
                ],

                const Gap(AppSpacing.lg),

                // Action buttons
                Row(
                  children: [
                    Expanded(
                      child: AppSecondaryButton(
                        text: 'Sync now',
                        icon: LucideIcons.refreshCw,
                        color: AppColors.accentAlt,
                        onPressed: sheetsState.isSyncing ? null : _syncNow,
                      ),
                    ),
                    const Gap(AppSpacing.sm),
                    Expanded(
                      flex: 2,
                      child: AppPrimaryButton(
                        text: 'Save',
                        icon: LucideIcons.check,
                        onPressed: _save,
                      ),
                    ),
                  ],
                ),

                // Sheet structure info
                const Gap(AppSpacing.md),
                Container(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  decoration: AppSpacing.glassTile(radius: AppSpacing.radiusMd),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(LucideIcons.info,
                              size: 14, color: AppColors.accent),
                          const Gap(6),
                          Text(
                            'Sheet structure',
                            style: AppTypography.labelMedium.copyWith(
                              color: AppColors.accent,
                            ),
                          ),
                        ],
                      ),
                      const Gap(8),
                      _sheetTab('Daily Summary',
                          'Date, total meals, bazar, meal rate'),
                      _sheetTab('Meals', 'Per-member daily meal entries'),
                      _sheetTab('Bazar', 'Grocery purchases with items'),
                      _sheetTab('Balance', 'Member balances breakdown'),
                    ],
                  ),
                )
                    .animate()
                    .fadeIn(duration: 300.ms, delay: 200.ms),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _sheetTab(String name, String desc) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 4,
            decoration: const BoxDecoration(
              color: AppColors.accentAlt,
              shape: BoxShape.circle,
            ),
          ),
          const Gap(8),
          Text(
            '$name — ',
            style: AppTypography.labelSmall.copyWith(
              color: AppColors.textSecondaryDark,
              fontWeight: FontWeight.w600,
            ),
          ),
          Expanded(
            child: Text(
              desc,
              style: AppTypography.labelSmall.copyWith(
                color: AppColors.textMutedDark,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDateTime(DateTime dt) {
    final h = dt.hour.toString().padLeft(2, '0');
    final m = dt.minute.toString().padLeft(2, '0');
    return '${dt.day}/${dt.month}/${dt.year} $h:$m';
  }
}
