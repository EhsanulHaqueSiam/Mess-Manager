import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:flutter_animate/flutter_animate.dart';

import 'core/theme/app_theme.dart';
import 'core/router/app_router.dart';
import 'core/database/isar_service.dart';
import 'core/services/firebase_service.dart';
import 'core/services/fcm_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Configure flutter_animate defaults
  Animate.restartOnHotReload = true;

  // Get saved theme mode (for adaptive_theme initial mode)
  final savedThemeMode = await AdaptiveTheme.getThemeMode();

  // Initialize Isar database
  await IsarService.init();

  // Initialize Firebase
  try {
    await FirebaseService.initialize();

    // Initialize FCM (non-web only)
    if (!kIsWeb) {
      await FCMService.initialize();
    }
  } catch (e) {
    debugPrint('Firebase initialization failed: $e');
    // App can still work offline with local storage
  }

  runApp(ProviderScope(child: Area51App(savedThemeMode: savedThemeMode)));
}

class Area51App extends StatelessWidget {
  final AdaptiveThemeMode? savedThemeMode;

  const Area51App({super.key, this.savedThemeMode});

  // Default seed color for Material You fallback
  static const _defaultSeedColor = AppColors.primary;

  @override
  Widget build(BuildContext context) {
    // Determine initial theme for animated_theme_switcher
    final isDark =
        savedThemeMode == AdaptiveThemeMode.dark ||
        (savedThemeMode == AdaptiveThemeMode.system &&
            WidgetsBinding.instance.platformDispatcher.platformBrightness ==
                Brightness.dark);

    // Use DynamicColorBuilder for Android 12+ Material You support
    return DynamicColorBuilder(
      builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
        // Build themes using dynamic colors if available, otherwise use default
        final lightTheme = AppTheme.buildLightTheme(
          dynamicColorScheme: lightDynamic,
          seedColor: _defaultSeedColor,
        );
        final darkTheme = AppTheme.buildDarkTheme(
          dynamicColorScheme: darkDynamic,
          seedColor: _defaultSeedColor,
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
                routerConfig: appRouter,
              ),
            );
          },
        );
      },
    );
  }
}
