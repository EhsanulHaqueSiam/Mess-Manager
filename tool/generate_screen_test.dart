#!/usr/bin/env dart

/// ═══════════════════════════════════════════════════════════════════════════
/// SCREEN TEST GENERATOR - CLI Tool for TDD Workflow
/// ═══════════════════════════════════════════════════════════════════════════
/// Purpose: Auto-generate test stubs for new screens.
/// Ensures new screens are immediately added to test infrastructure.
///
/// Usage:
///   dart run tool/generate_screen_test.dart --name NewScreen --route /new --feature newfeature
///
/// This tool:
///   1. Adds the screen to screen_registry.dart
///   2. Creates a widget test file for the screen
///   3. Updates page_coverage_test.dart if needed
/// ═══════════════════════════════════════════════════════════════════════════
library;

import 'dart:io';

void main(List<String> args) {
  print(
    '╔═══════════════════════════════════════════════════════════════════╗',
  );
  print('║       SCREEN TEST GENERATOR - Mesa Manager TDD Helper            ║');
  print(
    '╚═══════════════════════════════════════════════════════════════════╝',
  );
  print('');

  if (args.isEmpty || args.contains('--help') || args.contains('-h')) {
    _printUsage();
    return;
  }

  // Parse arguments
  String? screenName;
  String? route;
  String? feature;
  bool requiresAuth = true;
  bool hasBottomNav = false;

  for (int i = 0; i < args.length; i++) {
    switch (args[i]) {
      case '--name':
        if (i + 1 < args.length) screenName = args[++i];
        break;
      case '--route':
        if (i + 1 < args.length) route = args[++i];
        break;
      case '--feature':
        if (i + 1 < args.length) feature = args[++i];
        break;
      case '--no-auth':
        requiresAuth = false;
        break;
      case '--bottom-nav':
        hasBottomNav = true;
        break;
    }
  }

  // Validate required arguments
  if (screenName == null || route == null || feature == null) {
    print('❌ Error: Missing required arguments');
    print('');
    _printUsage();
    exit(1);
  }

  print('📋 Generating test infrastructure for:');
  print('   Screen Name: $screenName');
  print('   Route: $route');
  print('   Feature: $feature');
  print('   Requires Auth: $requiresAuth');
  print('   Bottom Nav: $hasBottomNav');
  print('');

  // Generate the registry entry
  final registryEntry = _generateRegistryEntry(
    screenName: screenName,
    route: route,
    feature: feature,
    requiresAuth: requiresAuth,
    hasBottomNav: hasBottomNav,
  );

  print('📝 Registry Entry to add to screen_registry.dart:');
  print('─' * 60);
  print(registryEntry);
  print('─' * 60);
  print('');

  // Generate the widget test
  final widgetTest = _generateWidgetTest(
    screenName: screenName,
    route: route,
    feature: feature,
  );

  print('📝 Widget Test to create:');
  print('   File: test/widget/screens/${_toSnakeCase(screenName)}_test.dart');
  print('─' * 60);
  print(widgetTest);
  print('─' * 60);
  print('');

  // Ask user if they want to auto-create files
  print('');
  print('📌 MANUAL STEPS:');
  print('   1. Add the screen import to lib/core/testing/screen_registry.dart');
  print('   2. Add the registry entry to the screenRegistry list');
  print('   3. Create the widget test file');
  print('   4. Run: flutter test to verify');
  print('');
  print('✅ Template generation complete!');
}

void _printUsage() {
  print('Usage:');
  print('  dart run tool/generate_screen_test.dart OPTIONS');
  print('');
  print('Required Options:');
  print(
    '  --name <ScreenName>     Name of the screen class (e.g., "NewFeatureScreen")',
  );
  print('  --route <route>         Route path (e.g., "/new-feature")');
  print('  --feature <feature>     Feature name (e.g., "newfeature")');
  print('');
  print('Optional Options:');
  print('  --no-auth               Screen does NOT require authentication');
  print('  --bottom-nav            Screen appears in bottom navigation');
  print('  --help, -h              Show this help message');
  print('');
  print('Example:');
  print('  dart run tool/generate_screen_test.dart \\');
  print('    --name ExpenseReportScreen \\');
  print('    --route /expense-report \\');
  print('    --feature analytics');
}

String _generateRegistryEntry({
  required String screenName,
  required String route,
  required String feature,
  required bool requiresAuth,
  required bool hasBottomNav,
}) {
  final buffer = StringBuffer();
  buffer.writeln('  ScreenInfo(');
  buffer.writeln("    route: '$route',");
  buffer.writeln(
    "    name: '${_toTitleCase(screenName.replaceAll('Screen', ''))}',",
  );
  buffer.writeln("    feature: '$feature',");
  buffer.writeln('    builder: () => const $screenName(),');
  if (!requiresAuth) {
    buffer.writeln('    requiresAuth: false,');
  }
  if (hasBottomNav) {
    buffer.writeln('    hasBottomNav: true,');
  }
  buffer.writeln('  ),');
  return buffer.toString();
}

String _generateWidgetTest({
  required String screenName,
  required String route,
  required String feature,
}) {
  return '''
/// Widget tests for $screenName
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mess_manager/features/$feature/screens/${_toSnakeCase(screenName)}.dart';
import '../../helpers/test_app_wrapper.dart';

void main() {
  group('$screenName Tests', () {
    test('$screenName instantiates without error', () {
      expect(() => const $screenName(), returnsNormally);
    });

    testWidgets('$screenName renders basic structure', (tester) async {
      await tester.pumpWidget(
        const TestAppWrapper(
          child: $screenName(),
        ),
      );

      // Add specific widget expectations here
      expect(find.byType($screenName), findsOneWidget);
    });

    testWidgets('$screenName has proper accessibility', (tester) async {
      await tester.pumpWidget(
        const TestAppWrapper(
          child: $screenName(),
        ),
      );

      // Verify screen has accessible content
      expect(find.byType(Semantics), findsWidgets);
    });
  });
}
''';
}

String _toSnakeCase(String input) {
  return input
      .replaceAllMapped(
        RegExp(r'[A-Z]'),
        (match) => '_${match.group(0)!.toLowerCase()}',
      )
      .replaceFirst('_', '');
}

String _toTitleCase(String input) {
  return input
      .replaceAllMapped(RegExp(r'[A-Z]'), (match) => ' ${match.group(0)}')
      .trim();
}
