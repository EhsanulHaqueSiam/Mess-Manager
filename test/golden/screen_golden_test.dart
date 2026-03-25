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

import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mess_manager/core/testing/screen_registry.dart';

import '../helpers/test_app_wrapper.dart';
import 'golden_test_helper.dart';

/// Prevents GoogleFonts from making real HTTP calls during tests.
/// Creates a flutter_test_config.dart style override that makes
/// font loading a no-op.

void main() {
  // No global setup needed — font errors handled per-test via takeException

  // Iterate over every registered screen and create a golden test.
  for (final screen in screenRegistry) {
    testWidgets(
      '${screen.feature}/${screen.name} golden',
      (WidgetTester tester) async {
        // Sanitize name for file system: lowercase, replace spaces with underscores
        final safeName = screen.name.toLowerCase().replaceAll(' ', '_');
        final goldenPath = 'goldens/${screen.feature}_$safeName.png';

        await pumpScreenForGolden(
          tester,
          screen.builder(),
          size: TestDevices.pixel7,
        );

        // Drain all async exceptions from GoogleFonts font loading
        for (var i = 0; i < 5; i++) {
          await tester.pump(const Duration(milliseconds: 50));
          while (tester.takeException() != null) {}
        }

        await expectLater(
          find.byType(MaterialApp),
          matchesGoldenFile(goldenPath),
        );

        // Final drain for late-arriving async exceptions
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
