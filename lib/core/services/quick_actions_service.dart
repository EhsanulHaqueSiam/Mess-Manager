/// Quick Actions Service - 3D Touch / App Shortcuts
///
/// Provides quick action shortcuts for common tasks:
/// - Add Meal
/// - Add Bazar
/// - View Balance
library;

import 'package:flutter/foundation.dart';
import 'package:quick_actions/quick_actions.dart';

/// Quick action types
enum QuickActionType {
  addMeal('add_meal', 'Add Meal', 'Quickly add a meal entry'),
  addBazar('add_bazar', 'Add Bazar', 'Quickly add a bazar entry'),
  viewBalance('view_balance', 'Balance', 'View your current balance'),
  shopping('shopping', 'Shopping List', 'Open shopping list');

  final String type;
  final String title;
  final String subtitle;

  const QuickActionType(this.type, this.title, this.subtitle);
}

/// Callback for when a quick action is triggered
typedef QuickActionCallback = void Function(QuickActionType action);

/// Quick Actions Service
class QuickActionsService {
  static final QuickActions _quickActions = const QuickActions();
  static QuickActionCallback? _callback;
  static bool _isInitialized = false;

  /// Initialize quick actions with the provided callback
  static Future<void> initialize(QuickActionCallback callback) async {
    if (_isInitialized) return;

    _callback = callback;

    // Set available shortcuts
    await _quickActions.setShortcutItems([
      ShortcutItem(
        type: QuickActionType.addMeal.type,
        localizedTitle: QuickActionType.addMeal.title,
        localizedSubtitle: QuickActionType.addMeal.subtitle,
        icon: 'ic_meal', // Add to Android drawable
      ),
      ShortcutItem(
        type: QuickActionType.addBazar.type,
        localizedTitle: QuickActionType.addBazar.title,
        localizedSubtitle: QuickActionType.addBazar.subtitle,
        icon: 'ic_bazar',
      ),
      ShortcutItem(
        type: QuickActionType.viewBalance.type,
        localizedTitle: QuickActionType.viewBalance.title,
        localizedSubtitle: QuickActionType.viewBalance.subtitle,
        icon: 'ic_balance',
      ),
      ShortcutItem(
        type: QuickActionType.shopping.type,
        localizedTitle: QuickActionType.shopping.title,
        localizedSubtitle: QuickActionType.shopping.subtitle,
        icon: 'ic_shopping',
      ),
    ]);

    // Listen for quick action invocations
    _quickActions.initialize((type) {
      debugPrint('📱 Quick action triggered: $type');
      _handleQuickAction(type);
    });

    _isInitialized = true;
    debugPrint('✅ Quick Actions Service initialized');
  }

  /// Handle a quick action being triggered
  static void _handleQuickAction(String type) {
    final callback = _callback;
    if (callback == null) return;

    final action = QuickActionType.values.firstWhere(
      (a) => a.type == type,
      orElse: () => QuickActionType.addMeal,
    );

    callback(action);
  }

  /// Clear all shortcuts
  static Future<void> clear() async {
    await _quickActions.clearShortcutItems();
    _isInitialized = false;
  }

  /// Get route for quick action
  static String getRouteForAction(QuickActionType action) {
    switch (action) {
      case QuickActionType.addMeal:
        return '/meals';
      case QuickActionType.addBazar:
        return '/bazar';
      case QuickActionType.viewBalance:
        return '/balance';
      case QuickActionType.shopping:
        return '/bazar'; // Shopping tab in bazar
    }
  }
}
