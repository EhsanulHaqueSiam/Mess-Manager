import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:home_widget/home_widget.dart';
import 'package:mess_manager/features/balance/providers/balance_provider.dart';
import 'package:mess_manager/core/providers/members_provider.dart';

/// Home Widget Data
/// Provides data for home screen widget display
class HomeWidgetData {
  final double balance;
  final String balanceText;
  final int totalMeals;
  final int pendingDuties;
  final String messName;

  const HomeWidgetData({
    this.balance = 0,
    this.balanceText = '৳0',
    this.totalMeals = 0,
    this.pendingDuties = 0,
    this.messName = 'Mess Manager',
  });
}

/// Home Widget Data Provider
final homeWidgetDataProvider = Provider<HomeWidgetData>((ref) {
  final balanceData = ref.watch(currentMemberBalanceProvider);
  final members = ref.watch(membersProvider);

  // Get balance value from MemberBalance object
  final double balance = balanceData?.balance ?? 0.0;

  String balanceText;
  if (balance >= 0) {
    balanceText = '+৳${balance.abs().toStringAsFixed(0)}';
  } else {
    balanceText = '-৳${balance.abs().toStringAsFixed(0)}';
  }

  return HomeWidgetData(
    balance: balance,
    balanceText: balanceText,
    messName: 'Area51',
    totalMeals: members.length * 2, // Approximate
  );
});

/// Home Widget Service
/// Handles syncing data to the platform home screen widget
class HomeWidgetService {
  static const String _androidWidgetName = 'HomeWidgetReceiver';
  static const String _iosWidgetName = 'MessManagerWidget';

  /// Initialize the home widget
  static Future<void> initialize() async {
    // Set the group ID for iOS (if using app groups)
    // await HomeWidget.setAppGroupId('group.com.area51.messmanager');

    // Register background callback for widget interactions
    HomeWidget.registerInteractivityCallback(interactivityCallback);
  }

  /// Update the home widget with current data
  static Future<void> updateWidget(HomeWidgetData data) async {
    try {
      // Save data to shared preferences (accessible by the widget)
      await HomeWidget.saveWidgetData<String>('balance', data.balanceText);
      await HomeWidget.saveWidgetData<String>('messName', data.messName);
      await HomeWidget.saveWidgetData<String>(
        'mealsCount',
        data.totalMeals.toString(),
      );
      await HomeWidget.saveWidgetData<String>(
        'dutiesCount',
        data.pendingDuties.toString(),
      );

      // Trigger widget update on the platform
      await HomeWidget.updateWidget(
        androidName: _androidWidgetName,
        iOSName: _iosWidgetName,
        qualifiedAndroidName: 'com.area51.area51.$_androidWidgetName',
      );
    } catch (e) {
      // Widget update failed - likely widget not added to home screen
      // This is expected when user hasn't added the widget yet
    }
  }

  /// Handle widget tap interactions
  static Future<void> interactivityCallback(Uri? uri) async {
    if (uri == null) return;

    // Handle different widget actions
    switch (uri.host) {
      case 'open':
        // Widget was tapped - app will open automatically
        break;
      case 'refresh':
        // User requested refresh from widget
        // Note: We'd need a way to get fresh data here
        break;
    }
  }

  /// Called when widget data might have changed
  /// Call this when balance, meals, or duties change
  static Future<void> scheduleUpdate(Ref ref) async {
    final data = ref.read(homeWidgetDataProvider);
    await updateWidget(data);
  }
}

/// Provider that automatically updates the home widget when data changes
final homeWidgetUpdateProvider = Provider<void>((ref) {
  // Watch for changes in the widget data
  final data = ref.watch(homeWidgetDataProvider);

  // Update the widget whenever data changes
  // Note: This is fire-and-forget, we don't await
  HomeWidgetService.updateWidget(data);

  return;
});
