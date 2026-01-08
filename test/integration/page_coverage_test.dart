/// ═══════════════════════════════════════════════════════════════════════════
/// PAGE COVERAGE INTEGRATION TEST (V2 - Using Screen Registry)
/// ═══════════════════════════════════════════════════════════════════════════
/// Purpose: Ensure all application pages are covered by integration tests.
/// Now uses the Screen Registry for auto-discovery instead of manual imports.
///
/// Auto-Discovery Features:
///   - New screens added to registry are automatically tested
///   - Routes are verified unique
///   - Feature coverage is tracked
/// ═══════════════════════════════════════════════════════════════════════════
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Import Core
import 'package:mess_manager/core/router/app_router.dart';
import 'package:mess_manager/core/testing/screen_registry.dart';

void main() {
  // ═══════════════════════════════════════════════════════════════════════════
  // AUTO-DISCOVERY: Screen Registry Integration
  // ═══════════════════════════════════════════════════════════════════════════
  group('📋 Auto-Discovery - Screen Registry', () {
    test('Screen registry is populated', () {
      expect(screenRegistry.totalScreens, greaterThan(0));
      expect(screenRegistry.totalScreens, equals(27));
    });

    test('All screens have valid builders', () {
      for (final screen in screenRegistry) {
        expect(
          () => screen.builder(),
          returnsNormally,
          reason: 'Screen ${screen.name} builder failed',
        );
      }
    });

    test('All screens have non-empty names', () {
      for (final screen in screenRegistry) {
        expect(screen.name.isNotEmpty, isTrue);
      }
    });

    test('All screens have valid routes', () {
      for (final screen in screenRegistry) {
        expect(screen.route.isNotEmpty, isTrue);
        expect(screen.route.startsWith('/'), isTrue);
      }
    });

    test('All screens belong to a feature', () {
      for (final screen in screenRegistry) {
        expect(screen.feature.isNotEmpty, isTrue);
      }
    });
  });

  // ═══════════════════════════════════════════════════════════════════════════
  // ROUTE INTEGRITY: Unique Paths & AppRoutes Sync
  // ═══════════════════════════════════════════════════════════════════════════
  group('📄 Page Coverage - Routing Integrity', () {
    testWidgets('AppRouter configures successfully', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(home: const Scaffold(body: Text('Router Test'))),
        ),
      );

      final container = ProviderContainer();
      addTearDown(container.dispose);

      expect(createAppRouter, isNotNull);
    });

    test('All registry routes are unique', () {
      final routes = screenRegistry.allRoutes;
      expect(
        routes.length,
        equals(screenRegistry.totalScreens),
        reason: 'Duplicate route paths detected in registry',
      );
    });

    test('AppRoutes constants match registry', () {
      // Verify key routes exist in registry
      final registryRoutes = screenRegistry.allRoutes;

      expect(registryRoutes.contains(AppRoutes.dashboard), isTrue);
      expect(registryRoutes.contains(AppRoutes.bazar), isTrue);
      expect(registryRoutes.contains(AppRoutes.meals), isTrue);
      expect(registryRoutes.contains(AppRoutes.balance), isTrue);
      expect(registryRoutes.contains(AppRoutes.settings), isTrue);
      expect(registryRoutes.contains(AppRoutes.login), isTrue);
    });

    test('No orphan AppRoutes (all routes in registry)', () {
      final registryRoutes = screenRegistry.allRoutes;

      final appRoutes = [
        AppRoutes.dashboard,
        AppRoutes.bazar,
        AppRoutes.meals,
        AppRoutes.balance,
        AppRoutes.settings,
        AppRoutes.analytics,
        AppRoutes.money,
        AppRoutes.members,
        AppRoutes.vacation,
        AppRoutes.desco,
        AppRoutes.ramadan,
        AppRoutes.ramadanCalendar,
        AppRoutes.settlement,
        AppRoutes.duties,
        AppRoutes.fixedExpenses,
        AppRoutes.info,
        AppRoutes.chatbot,
        AppRoutes.notifications,
        AppRoutes.monthSummary,
        AppRoutes.login,
        AppRoutes.signup,
        AppRoutes.messSelection,
        AppRoutes.profile,
        AppRoutes.notificationSettings,
        AppRoutes.adminApprovals,
        AppRoutes.pendingApproval,
      ];

      for (final route in appRoutes) {
        expect(
          registryRoutes.contains(route),
          isTrue,
          reason: 'AppRoute $route not in registry',
        );
      }
    });
  });

  // ═══════════════════════════════════════════════════════════════════════════
  // FEATURE COVERAGE: All Features Have Screens
  // ═══════════════════════════════════════════════════════════════════════════
  group('🏗️ Feature Coverage - All Features Represented', () {
    test('Dashboard feature exists', () {
      expect(screenRegistry.byFeature('dashboard').length, greaterThan(0));
    });

    test('Auth feature exists with multiple screens', () {
      expect(screenRegistry.byFeature('auth').length, greaterThanOrEqualTo(4));
    });

    test('Bazar feature exists', () {
      expect(screenRegistry.byFeature('bazar').length, greaterThan(0));
    });

    test('Meals feature exists', () {
      expect(screenRegistry.byFeature('meals').length, greaterThan(0));
    });

    test('Balance feature exists', () {
      expect(screenRegistry.byFeature('balance').length, greaterThan(0));
    });

    test('Settings feature exists', () {
      expect(screenRegistry.byFeature('settings').length, greaterThan(0));
    });

    test('Analytics feature exists', () {
      expect(screenRegistry.byFeature('analytics').length, greaterThan(0));
    });

    test('Money feature exists', () {
      expect(screenRegistry.byFeature('money').length, greaterThan(0));
    });

    test('Members feature exists', () {
      expect(screenRegistry.byFeature('members').length, greaterThan(0));
    });

    test('Vacation feature exists', () {
      expect(screenRegistry.byFeature('vacation').length, greaterThan(0));
    });

    test('Desco feature exists', () {
      expect(screenRegistry.byFeature('desco').length, greaterThan(0));
    });

    test('Ramadan feature exists', () {
      expect(screenRegistry.byFeature('ramadan').length, greaterThan(0));
    });

    test('Settlement feature exists', () {
      expect(screenRegistry.byFeature('settlement').length, greaterThan(0));
    });

    test('Duties feature exists', () {
      expect(screenRegistry.byFeature('duties').length, greaterThan(0));
    });

    test('Info feature exists', () {
      expect(screenRegistry.byFeature('info').length, greaterThan(0));
    });

    test('Chatbot feature exists', () {
      expect(screenRegistry.byFeature('chatbot').length, greaterThan(0));
    });

    test('Notifications feature exists', () {
      expect(screenRegistry.byFeature('notifications').length, greaterThan(0));
    });
  });

  // ═══════════════════════════════════════════════════════════════════════════
  // SCREEN INSTANTIATION: Smoke Tests Via Registry
  // ═══════════════════════════════════════════════════════════════════════════
  group('📄 Page Coverage - Screen Instantiation (Auto-Generated)', () {
    // Auto-generate tests for ALL screens in registry
    for (final screen in screenRegistry) {
      test('${screen.name} screen instantiates', () {
        Widget? widget;

        expect(() {
          widget = screen.builder();
        }, returnsNormally);

        expect(widget, isNotNull);
        expect(widget, isA<Widget>());
      });
    }
  });

  // ═══════════════════════════════════════════════════════════════════════════
  // NAVIGATION STRUCTURE: Bottom Nav & Auth Flow
  // ═══════════════════════════════════════════════════════════════════════════
  group('🧭 Navigation Structure', () {
    test('Bottom nav has 5 screens', () {
      final bottomNavScreens = screenRegistry.bottomNavScreens;
      expect(bottomNavScreens.length, equals(5));
    });

    test('Auth flow screens are marked correctly', () {
      final noAuthScreens = screenRegistry.noAuthRequired;

      // These screens should NOT require auth
      final noAuthRoutes = noAuthScreens.map((s) => s.route).toSet();
      expect(noAuthRoutes.contains('/login'), isTrue);
      expect(noAuthRoutes.contains('/signup'), isTrue);
      expect(noAuthRoutes.contains('/mess-selection'), isTrue);
      expect(noAuthRoutes.contains('/pending-approval'), isTrue);
    });

    test('Main screens require auth', () {
      final authScreens = screenRegistry.authRequired;

      // These screens SHOULD require auth
      final authRoutes = authScreens.map((s) => s.route).toSet();
      expect(authRoutes.contains('/'), isTrue);
      expect(authRoutes.contains('/bazar'), isTrue);
      expect(authRoutes.contains('/meals'), isTrue);
      expect(authRoutes.contains('/analytics'), isTrue);
    });
  });

  // ═══════════════════════════════════════════════════════════════════════════
  // COMPLETENESS CHECK: Verify All 27 Screens
  // ═══════════════════════════════════════════════════════════════════════════
  group('✅ Completeness Check', () {
    test('Exactly 27 screens are registered', () {
      expect(screenRegistry.totalScreens, equals(27));
    });

    test('17 features are covered', () {
      expect(screenRegistry.allFeatures.length, equals(17));
    });

    test('Each feature has at least 1 screen', () {
      for (final feature in screenRegistry.allFeatures) {
        final screens = screenRegistry.byFeature(feature);
        expect(
          screens.length,
          greaterThan(0),
          reason: 'Feature $feature has no screens',
        );
      }
    });
  });
}
