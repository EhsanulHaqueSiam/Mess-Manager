import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';

import 'package:mess_manager/core/theme/app_theme.dart';
import 'package:mess_manager/core/database/isar_service.dart';

/// Notifier for managing sync time state
class SyncTimeNotifier extends Notifier<DateTime?> {
  @override
  DateTime? build() => null;

  void update(DateTime time) {
    state = time;
    IsarService.saveSyncTime(time);
  }

  Future<void> load() async {
    final saved = await IsarService.loadSyncTime();
    if (saved != null) {
      state = saved;
    }
  }
}

/// Stores the last sync time
final lastSyncTimeProvider = NotifierProvider<SyncTimeNotifier, DateTime?>(
  SyncTimeNotifier.new,
);

/// Returns formatted sync status text
final syncStatusTextProvider = Provider<String>((ref) {
  final lastSync = ref.watch(lastSyncTimeProvider);
  if (lastSync == null) return 'Never synced';

  final now = DateTime.now();
  final diff = now.difference(lastSync);

  if (diff.inMinutes < 1) return 'Just now';
  if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
  if (diff.inHours < 24) return '${diff.inHours}h ago';
  if (diff.inDays < 7) return '${diff.inDays}d ago';

  return '${lastSync.day}/${lastSync.month}/${lastSync.year}';
});

/// Sync Status Widget - shows last synced time
class SyncStatusWidget extends ConsumerWidget {
  const SyncStatusWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final syncText = ref.watch(syncStatusTextProvider);
    final lastSync = ref.watch(lastSyncTimeProvider);
    final isRecent =
        lastSync != null && DateTime.now().difference(lastSync).inMinutes < 5;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: isRecent
            ? AppColors.success.withValues(alpha: 0.1)
            : AppColors.warning.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
        border: Border.all(
          color: isRecent
              ? AppColors.success.withValues(alpha: 0.3)
              : AppColors.warning.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isRecent ? LucideIcons.cloud : LucideIcons.cloudOff,
            size: 16,
            color: isRecent ? AppColors.success : AppColors.warning,
          ),
          const SizedBox(width: AppSpacing.sm),
          Text(
            'Synced: $syncText',
            style: AppTypography.labelSmall.copyWith(
              color: isRecent ? AppColors.success : AppColors.warning,
            ),
          ),
        ],
      ),
    );
  }
}

/// Compact sync indicator for app bar
class SyncIndicator extends ConsumerWidget {
  const SyncIndicator({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lastSync = ref.watch(lastSyncTimeProvider);
    final isRecent =
        lastSync != null && DateTime.now().difference(lastSync).inMinutes < 5;

    return Tooltip(
      message: ref.watch(syncStatusTextProvider),
      child: Icon(
        isRecent ? LucideIcons.wifi : LucideIcons.wifiOff,
        size: 18,
        color: isRecent ? AppColors.success : AppColors.warning,
      ),
    );
  }
}

/// Call this when data is synced
void markSynced(WidgetRef ref) {
  ref.read(lastSyncTimeProvider.notifier).update(DateTime.now());
}

/// Load sync time on app start
Future<void> loadSyncTime(WidgetRef ref) async {
  await ref.read(lastSyncTimeProvider.notifier).load();
}
