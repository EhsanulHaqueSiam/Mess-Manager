import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
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

      // Use path URL strategy for web (removes # from URLs)
      usePathUrlStrategy();

      // Configure flutter_animate defaults
      Animate.restartOnHotReload = true;

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

    // Determine initial theme for animated_theme_switcher
    final isDark =
        savedThemeMode == AdaptiveThemeMode.dark ||
        (savedThemeMode == AdaptiveThemeMode.system &&
            WidgetsBinding.instance.platformDispatcher.platformBrightness ==
                Brightness.dark);

    // Use DynamicColorBuilder for Android 12+ Material You support
    return DynamicColorBuilder(
      builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
        // Build themes using dynamic colors if available and selected, otherwise use user seed color
        final lightTheme = AppTheme.buildLightTheme(
          dynamicColorScheme: useSystemColors ? lightDynamic : null,
          seedColor: seedColor,
        );
        final darkTheme = AppTheme.buildDarkTheme(
          dynamicColorScheme: useSystemColors ? darkDynamic : null,
          seedColor: seedColor,
        );

        // Wrap with ThemeProvider for animated theme switching
        return ThemeProvider(
          initTheme: isDark ? darkTheme : lightTheme,
          builder: (context, theme) {
            return AdaptiveTheme(
              light: lightTheme,
              dark: darkTheme,
              initial: savedThemeMode ?? AdaptiveThemeMode.dark,
              builder: (adaptiveLight, adaptiveDark) => MaterialApp.router(
                title: 'Area51 - Mess Manager',
                debugShowCheckedModeBanner: false,
                theme: theme, // Use theme from ThemeProvider for animations
                routerConfig: router,
              ),
            );
          },
        );
      },
    );
  }
}
