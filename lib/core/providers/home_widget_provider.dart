import 'package:flutter_riverpod/flutter_riverpod.dart';
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

/// Note: For actual home screen widget implementation,
/// you would need to use the home_widget package with platform-specific setup.
/// This provider supplies the data that would be displayed in the widget.
///
/// Android: Create widget XML in android/app/src/main/res/layout/
/// iOS: Create widget extension in ios/Runner/
///
/// Example usage with home_widget package:
/// ```dart
/// import 'package:home_widget/home_widget.dart';
///
/// Future<void> updateHomeWidget() async {
///   await HomeWidget.saveWidgetData<String>('balance', widgetData.balanceText);
///   await HomeWidget.saveWidgetData<String>('messName', widgetData.messName);
///   await HomeWidget.updateWidget(
///     name: 'MessManagerWidget',
///     androidName: 'MessManagerWidget',
///     iOSName: 'MessManagerWidget',
///   );
/// }
/// ```
