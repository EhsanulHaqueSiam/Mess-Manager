import 'package:flutter/foundation.dart';

/// Demo mode flag - when true:
/// - All data comes from MockDataService
/// - No Firebase sync
/// - CRUD operations are in-memory only
///
/// This is a simple global flag for demo/development mode.
/// Set to true when using DEV login buttons.
/// Only works in debug builds — production calls are no-ops.
class DemoMode {
  static bool _isEnabled = false;

  /// Check if demo mode is enabled
  static bool get isEnabled => _isEnabled;

  /// Enable demo mode (no Firebase sync)
  /// Only available in debug builds for security.
  static void enable() {
    if (!kDebugMode) return;
    _isEnabled = true;
  }

  /// Disable demo mode (normal Firebase sync)
  static void disable() {
    _isEnabled = false;
  }
}
