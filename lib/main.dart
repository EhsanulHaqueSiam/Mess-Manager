import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_displaymode/flutter_displaymode.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

import 'core/theme/app_theme.dart';
import 'core/router/app_router.dart';
import 'core/database/isar_service.dart';
import 'core/services/firebase_service.dart';
import 'core/services/fcm_service.dart';
import 'core/services/nlp_categorizer.dart';
import 'features/settings/providers/theme_color_provider.dart';

void main() async {
  // Setup Flutter error handling
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details);
    debugPrint('FlutterError: ${details.exception}');
    debugPrint('Stack trace: ${details.stack}');

    // Send to Crashlytics in production
    if (!kDebugMode) {
      FirebaseCrashlytics.instance.recordFlutterFatalError(details);
    }
  };

  // Catch async errors not handled by Flutter
  runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();

      // Enable the highest available refresh rate (no hard limit).
      // Supports 30/60/90/120/165/240+ Hz — whatever the device offers.
      if (!kIsWeb) {
        try {
          final modes = await FlutterDisplayMode.supported;
          modes.sort((a, b) => b.refreshRate.compareTo(a.refreshRate));
          if (modes.isNotEmpty) {
            await FlutterDisplayMode.setPreferredMode(modes.first);
            debugPrint('Display: ${modes.first.width}x${modes.first.height} @ ${modes.first.refreshRate}Hz');
            debugPrint('Available modes: ${modes.map((m) => '${m.refreshRate}Hz').toSet().join(', ')}');
          }
        } catch (e) {
          debugPrint('DisplayMode setup skipped: $e');
        }
      }

      // Enable pointer event resampling for high refresh rate displays
      GestureBinding.instance.resamplingEnabled = true;

      // Use path URL strategy for web (removes # from URLs)
      usePathUrlStrategy();

      // Configure flutter_animate for faster, snappier animations
      Animate.restartOnHotReload = true;
      // Reduce default animation duration for a faster feel (default is 300ms)
      Animate.defaultDuration = const Duration(milliseconds: 200);

      // Get saved theme mode (for adaptive_theme initial mode)
      final savedThemeMode = await AdaptiveTheme.getThemeMode();

      // Initialize Isar database
      await IsarService.init();

      // Initialize Firebase
      try {
        await FirebaseService.initialize();

        // Initialize Crashlytics (non-web, non-debug only)
        if (!kIsWeb && !kDebugMode) {
          await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(
            true,
          );
          debugPrint('✅ Crashlytics enabled for production');
        }

        // Load NLP keywords from Firestore
        await NLPCategorizer().loadFromFirestore();

        // Initialize FCM (non-web only)
        if (!kIsWeb) {
          await FCMService.initialize();
        }
      } catch (e) {
        debugPrint('Firebase initialization failed: $e');
        // App can still work offline with local storage
      }

      runApp(ProviderScope(child: Area51App(savedThemeMode: savedThemeMode)));
    },
    (error, stackTrace) {
      debugPrint('Uncaught async error: $error');
      debugPrint('Stack trace: $stackTrace');

      // Send to Crashlytics in production
      if (!kDebugMode) {
        FirebaseCrashlytics.instance.recordError(
          error,
          stackTrace,
          fatal: true,
        );
      }
    },
  );
}

/// Custom scroll behavior for smoother scrolling on high refresh rate displays
class SmoothScrollBehavior extends MaterialScrollBehavior {
  @override
  ScrollPhysics getScrollPhysics(BuildContext context) {
    // Use bouncing scroll physics for a premium iOS-like feel
    return const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics());
  }

  @override
  Set<PointerDeviceKind> get dragDevices => {
    PointerDeviceKind.touch,
    PointerDeviceKind.stylus,
    PointerDeviceKind.mouse,
  };
}

class Area51App extends ConsumerWidget {
  final AdaptiveThemeMode? savedThemeMode;

  const Area51App({super.key, this.savedThemeMode});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Get the user-selected theme color from provider
    // This uses Isar for persistence, loaded at app init
    final themeColorNotifier = ref.watch(themeColorProvider.notifier);
    final seedColor = themeColorNotifier.seedColor;
    final useSystemColors = themeColorNotifier.isUsingSystemColor;

    // Create router with auth awareness
    final router = createAppRouter(ref);

    // Dark-only — "Cosmic Bioluminescence" requires dark backgrounds.
    // AdaptiveTheme still manages the ThemeData so seed color changes work.
    return DynamicColorBuilder(
      builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
        final darkTheme = AppTheme.buildDarkTheme(
          dynamicColorScheme: useSystemColors ? darkDynamic : null,
          seedColor: seedColor,
        );

        return ThemeProvider(
          initTheme: darkTheme,
          builder: (context, theme) {
            return AdaptiveTheme(
              light: darkTheme,
              dark: darkTheme,
              initial: AdaptiveThemeMode.dark,
              builder: (adaptiveLight, adaptiveDark) => MaterialApp.router(
                title: 'Area51 - Mess Manager',
                debugShowCheckedModeBanner: false,
                // Use adaptiveDark so AdaptiveTheme color changes propagate
                theme: adaptiveDark ?? darkTheme,
                darkTheme: adaptiveDark ?? darkTheme,
                themeMode: ThemeMode.dark,
                routerConfig: router,
                scrollBehavior: SmoothScrollBehavior(),
              ),
            );
          },
        );
      },
    );
  }
}
