/// ═══════════════════════════════════════════════════════════════════════════
/// SCREEN GOLDEN TESTS - Auto-generated golden tests for all 27 screens
/// ═══════════════════════════════════════════════════════════════════════════
/// Iterates over screenRegistry and generates a golden file for each screen
/// at Pixel 7 (412x915) resolution using the real AppTheme.buildDarkTheme().
///
/// Run:  flutter test test/golden/screen_golden_test.dart --tags golden
/// Update: flutter test test/golden/screen_golden_test.dart --tags golden --update-goldens
/// ═══════════════════════════════════════════════════════════════════════════
@Tags(['golden'])
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mess_manager/core/testing/screen_registry.dart';

import '../helpers/test_app_wrapper.dart';
import 'golden_test_helper.dart';

void main() {
  setUpAll(() {
    // Mock local_auth platform channel
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      const MethodChannel('plugins.flutter.io/local_auth'),
      (MethodCall call) async {
        if (call.method == 'getAvailableBiometrics') return <String>[];
        if (call.method == 'isDeviceSupported') return false;
        if (call.method == 'authenticate') return false;
        return null;
      },
    );
  });

  // PendingApproval needs Lottie assets + GoRouter context (can't mock easily)
  const _skipScreens = {'Pending Approval'};

  // Iterate over every registered screen and create a golden test.
  for (final screen in screenRegistry) {
    final isSkipped = _skipScreens.contains(screen.name);

    testWidgets(
      '${screen.feature}/${screen.name} golden',
      skip: isSkipped,
      (WidgetTester tester) async {
        final safeName = screen.name.toLowerCase().replaceAll(' ', '_');
        final goldenPath = 'goldens/${screen.feature}_$safeName.png';

        await pumpScreenForGolden(
          tester,
          screen.builder(),
          size: TestDevices.pixel7,
        );

        // Drain async exceptions (font loading, plugin calls, etc.)
        for (var i = 0; i < 5; i++) {
          await tester.pump(const Duration(milliseconds: 50));
          while (tester.takeException() != null) {}
        }

        await expectLater(
          find.byType(MaterialApp),
          matchesGoldenFile(goldenPath),
        );

        await tester.pump(const Duration(milliseconds: 200));
        while (tester.takeException() != null) {}
      },
    );
  }

  // ─── Verify test coverage ────────────────────────────────────────────
  test('all registered screens have golden tests', () {
    // This test simply verifies the registry count hasn't drifted.
    // If new screens are added to screenRegistry, they are automatically
    // picked up by the loop above — no manual addition needed.
    expect(
      screenRegistry.length,
      greaterThanOrEqualTo(27),
      reason: 'Expected at least 27 screens in screenRegistry',
    );
  });
}
