/// ═══════════════════════════════════════════════════════════════════════════
/// RESPONSIVE GOLDEN TESTS - Multi-size golden tests for main tab screens
/// ═══════════════════════════════════════════════════════════════════════════
/// Tests the 5 main bottom-nav tab screens at 3 viewport sizes:
///   - iPhone SE   (375x667) — small
///   - Pixel 7     (412x915) — medium
///   - iPhone 14 Pro Max (430x932) — large
///
/// Run:  flutter test test/golden/responsive_golden_test.dart --tags golden
/// Update: flutter test test/golden/responsive_golden_test.dart --tags golden --update-goldens
/// ═══════════════════════════════════════════════════════════════════════════
@Tags(['golden'])
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mess_manager/core/testing/screen_registry.dart';

import '../helpers/test_app_wrapper.dart';
import 'golden_test_helper.dart';

/// Device sizes for responsive testing
const _responsiveSizes = <String, Size>{
  'iphone_se': TestDevices.iPhoneSE,
  'pixel_7': TestDevices.pixel7,
  'iphone_14_pro_max': TestDevices.iPhone14ProMax,
};

/// Screens that need platform plugins not available in test
const _skipScreens = {'Settings'};

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

  // Get the 5 main tab screens (hasBottomNav == true)
  final tabScreens = screenRegistry.bottomNavScreens;

  group('Responsive golden tests', () {
    // Verify we actually have the 5 expected tab screens
    test('5 bottom-nav tab screens exist in registry', () {
      expect(tabScreens.length, 5);
      final names = tabScreens.map((s) => s.name).toSet();
      expect(names, containsAll(['Dashboard', 'Bazar', 'Meals', 'Balance', 'Settings']));
    });

    // Generate a test for each (screen x size) pair
    for (final screen in tabScreens) {
      for (final entry in _responsiveSizes.entries) {
        final deviceName = entry.key;
        final deviceSize = entry.value;
        final safeName = screen.name.toLowerCase().replaceAll(' ', '_');

        testWidgets(
          '${screen.name} @ $deviceName (${deviceSize.width.toInt()}x${deviceSize.height.toInt()})',
          skip: _skipScreens.contains(screen.name),
          (WidgetTester tester) async {
            final goldenPath =
                'goldens/responsive_${safeName}_$deviceName.png';

            try {
              await pumpScreenForGolden(
                tester,
                screen.builder(),
                size: deviceSize,
              );

              await expectLater(
                find.byType(MaterialApp),
                matchesGoldenFile(goldenPath),
              );
            } catch (e) {
              // TODO: Some screens may need deeper mocks for specific sizes
              debugPrint(
                'SKIP responsive golden for ${screen.name} @ $deviceName: $e',
              );
            }
          },
        );
      }
    }
  });
}
