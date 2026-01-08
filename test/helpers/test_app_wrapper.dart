/// ═══════════════════════════════════════════════════════════════════════════
/// TEST APP WRAPPER - Reusable Widget Test Wrapper
/// ═══════════════════════════════════════════════════════════════════════════
/// Purpose: Provide a consistent test environment for all widget tests.
/// Ensures all screens have access to:
///   - MaterialApp with proper theme
///   - ProviderScope for state management
///   - MediaQuery for screen size simulation
/// ═══════════════════════════════════════════════════════════════════════════
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

/// Wraps a widget with all necessary providers and MaterialApp for testing.
///
/// Usage:
/// ```dart
/// await tester.pumpWidget(
///   TestAppWrapper(child: MyScreen()),
/// );
/// ```
class TestAppWrapper extends StatelessWidget {
  final Widget child;
  final bool useMockData;
  final ThemeMode themeMode;
  final Size screenSize;

  const TestAppWrapper({
    super.key,
    required this.child,
    this.useMockData = true,
    this.themeMode = ThemeMode.dark,
    this.screenSize = const Size(411, 823), // Pixel 4 dimensions
  });

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        themeMode: themeMode,
        theme: ThemeData.light(useMaterial3: true),
        darkTheme: ThemeData.dark(useMaterial3: true),
        home: MediaQuery(
          data: MediaQueryData(size: screenSize),
          child: Scaffold(body: child),
        ),
      ),
    );
  }
}

/// Wraps a widget with minimal configuration for unit-like widget tests.
/// No navigation, no complex providers.
class MinimalTestWrapper extends StatelessWidget {
  final Widget child;

  const MinimalTestWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: MaterialApp(home: Scaffold(body: child)),
    );
  }
}

/// Extension methods for WidgetTester to simplify common test patterns.
extension TestHelperExtensions on WidgetTester {
  /// Pumps a widget wrapped with TestAppWrapper and waits for animations.
  Future<void> pumpTestApp(
    Widget child, {
    Duration settleDuration = const Duration(seconds: 1),
  }) async {
    await pumpWidget(TestAppWrapper(child: child));
    await pump(settleDuration);
  }

  /// Pumps a widget with minimal wrapper and waits for animations.
  Future<void> pumpMinimal(Widget child) async {
    await pumpWidget(MinimalTestWrapper(child: child));
    await pump();
  }

  /// Finds a widget by text and taps it.
  Future<void> tapByText(String text) async {
    final finder = find.text(text);
    expect(finder, findsOneWidget, reason: 'Could not find text: $text');
    await tap(finder);
    await pump();
  }

  /// Finds a widget by icon and taps it.
  Future<void> tapByIcon(IconData icon) async {
    final finder = find.byIcon(icon);
    expect(finder, findsOneWidget, reason: 'Could not find icon: $icon');
    await tap(finder);
    await pump();
  }

  /// Enters text into a TextField found by key.
  Future<void> enterTextByKey(Key key, String text) async {
    final finder = find.byKey(key);
    expect(
      finder,
      findsOneWidget,
      reason: 'Could not find widget with key: $key',
    );
    await enterText(finder, text);
    await pump();
  }

  /// Scrolls until a widget with the given text is visible.
  Future<void> scrollUntilVisible(
    String text, {
    double delta = 100,
    int maxScrolls = 50,
  }) async {
    final finder = find.text(text);
    final scrollable = find.byType(Scrollable).first;

    for (int i = 0; i < maxScrolls; i++) {
      if (any(finder)) break;
      await drag(scrollable, Offset(0, -delta));
      await pump();
    }
  }

  /// Verifies a screen has basic structure (AppBar, body content).
  Future<void> verifyScreenStructure({
    bool expectAppBar = true,
    bool expectScaffold = true,
    bool expectBody = true,
  }) async {
    if (expectScaffold) {
      expect(find.byType(Scaffold), findsWidgets);
    }
    if (expectAppBar) {
      expect(find.byType(AppBar), findsWidgets);
    }
    if (expectBody) {
      expect(find.byType(Widget), findsWidgets);
    }
  }
}

/// Common test device sizes for responsive testing
class TestDevices {
  static const Size iPhoneSE = Size(375, 667);
  static const Size iPhone14 = Size(390, 844);
  static const Size iPhone14ProMax = Size(430, 932);
  static const Size pixel4 = Size(411, 823);
  static const Size pixel7 = Size(412, 915);
  static const Size galaxyS21 = Size(360, 800);
  static const Size iPad = Size(768, 1024);
  static const Size iPadPro = Size(1024, 1366);
}

/// Golden test helpers
class GoldenTestConfig {
  /// Standard device sizes for golden tests
  static const List<Size> standardSizes = [
    TestDevices.iPhoneSE,
    TestDevices.pixel4,
    TestDevices.iPhone14ProMax,
  ];

  /// Generate golden file name
  static String goldenName(String screenName, Size size) {
    return 'goldens/${screenName}_${size.width.toInt()}x${size.height.toInt()}.png';
  }
}
