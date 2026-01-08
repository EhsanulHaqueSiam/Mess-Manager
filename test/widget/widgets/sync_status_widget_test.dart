import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:mess_manager/core/providers/sync_provider.dart';

void main() {
  group('SyncStatusWidget Tests', () {
    testWidgets('displays "Never synced" when no sync time', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: Consumer(
                builder: (context, ref, _) {
                  final syncText = ref.watch(syncStatusTextProvider);
                  return Text(syncText);
                },
              ),
            ),
          ),
        ),
      );

      expect(find.text('Never synced'), findsOneWidget);
    });

    testWidgets('SyncIndicator renders without error', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(home: Scaffold(body: SyncIndicator())),
        ),
      );

      // Should find the icon widget
      expect(find.byType(Tooltip), findsOneWidget);
    });

    testWidgets('SyncStatusWidget renders without error', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(home: Scaffold(body: SyncStatusWidget())),
        ),
      );

      // Should find the sync text
      expect(find.textContaining('Synced:'), findsOneWidget);
    });
  });

  group('Sync Status Text Provider Tests', () {
    test('returns "Never synced" when lastSyncTime is null', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final syncText = container.read(syncStatusTextProvider);
      expect(syncText, equals('Never synced'));
    });

    test('returns "Just now" for recent sync', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      // Set sync time to now
      container.read(lastSyncTimeProvider.notifier).update(DateTime.now());

      final syncText = container.read(syncStatusTextProvider);
      expect(syncText, equals('Just now'));
    });

    test('returns minutes ago for sync within an hour', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      // Set sync time to 30 minutes ago
      container
          .read(lastSyncTimeProvider.notifier)
          .update(DateTime.now().subtract(const Duration(minutes: 30)));

      final syncText = container.read(syncStatusTextProvider);
      expect(syncText, contains('m ago'));
    });

    test('returns hours ago for sync within a day', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      // Set sync time to 5 hours ago
      container
          .read(lastSyncTimeProvider.notifier)
          .update(DateTime.now().subtract(const Duration(hours: 5)));

      final syncText = container.read(syncStatusTextProvider);
      expect(syncText, contains('h ago'));
    });
  });
}
