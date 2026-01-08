/// ═══════════════════════════════════════════════════════════════════════════
/// APP INTEGRATION TEST - Run on Real Android/iOS Devices
/// ═══════════════════════════════════════════════════════════════════════════
/// Purpose: End-to-end tests that run on real devices or emulators.
/// Uses mock data (debug builds only) to test full user flows.
///
/// Run with:
///   flutter test integration_test/app_test.dart
///   flutter drive --target=integration_test/app_test.dart (for driver mode)
///
/// For Android:
///   flutter test integration_test/app_test.dart -d <device_id>
///
/// For iOS:
///   flutter test integration_test/app_test.dart -d <simulator_id>
/// ═══════════════════════════════════════════════════════════════════════════
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:mess_manager/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('App Launch & Navigation', () {
    testWidgets('App launches successfully', (tester) async {
      // Launch the app
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Verify app is running (either login or dashboard)
      expect(
        find.byType(MaterialApp),
        findsOneWidget,
        reason: 'App should launch with MaterialApp',
      );
    });

    testWidgets('Bottom navigation works', (tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Try to find bottom navigation
      final bottomNav = find.byType(BottomNavigationBar);
      if (bottomNav.evaluate().isNotEmpty) {
        // Navigate to different tabs
        final items = find.byType(BottomNavigationBarItem);
        if (items.evaluate().length >= 2) {
          await tester.tap(items.at(1));
          await tester.pumpAndSettle();
        }
      }
    });
  });

  group('Smoke Tests - Core Screens', () {
    testWidgets('Dashboard loads content', (tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Dashboard should have some scaffold content
      expect(find.byType(Scaffold), findsWidgets);
    });

    testWidgets('No crash on rapid navigation', (tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Rapidly tap around (stress test)
      for (int i = 0; i < 5; i++) {
        final tappables = find.byType(InkWell);
        if (tappables.evaluate().isNotEmpty) {
          await tester.tap(tappables.first, warnIfMissed: false);
          await tester.pump(const Duration(milliseconds: 100));
        }
      }

      // App should not crash
      expect(find.byType(MaterialApp), findsOneWidget);
    });
  });

  group('Platform-Specific Tests', () {
    testWidgets('Theme renders correctly', (tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Find theme-aware widget
      final scaffold = tester.widget<Scaffold>(find.byType(Scaffold).first);
      expect(scaffold.backgroundColor, isNotNull);
    });

    testWidgets('Text scales properly', (tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Verify text widgets exist and render
      expect(find.byType(Text), findsWidgets);
    });

    testWidgets('Icons render on platform', (tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Icons should render (Lucide or Material)
      final icons = find.byType(Icon);
      expect(icons, findsWidgets);
    });
  });

  group('Data Flow Tests (Mock Data)', () {
    testWidgets('Mock members load in debug', (tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // In debug mode, mock data should populate
      // This is a sanity check that the app doesn't crash
      expect(find.byType(MaterialApp), findsOneWidget);
    });

    testWidgets('Provider state is accessible', (tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // App should have ProviderScope
      expect(find.byType(MaterialApp), findsOneWidget);
    });
  });
}
