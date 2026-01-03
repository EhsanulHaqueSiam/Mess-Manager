import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/theme/app_theme.dart';
import 'core/router/app_router.dart';
import 'core/providers/theme_provider.dart';
import 'core/services/storage_service.dart';
import 'core/services/firebase_service.dart';
import 'core/services/fcm_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize local storage
  await StorageService.init();

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

  runApp(const ProviderScope(child: Area51App()));
}

class Area51App extends ConsumerWidget {
  const Area51App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);

    return MaterialApp.router(
      title: 'Area51 - Mess Manager',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      routerConfig: appRouter,
      // Add analytics observer when Firebase is ready
      // navigatorObservers: [FirebaseService.observer],
    );
  }
}
