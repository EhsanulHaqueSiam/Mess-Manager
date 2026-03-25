import 'dart:async';
import 'package:google_fonts/google_fonts.dart';

/// Global test configuration — runs before every test file.
/// Fonts are bundled in test/assets/fonts/ and registered in pubspec.yaml.
/// Disable runtime fetching so GoogleFonts uses the bundled fonts.
Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  GoogleFonts.config.allowRuntimeFetching = false;
  await testMain();
}
