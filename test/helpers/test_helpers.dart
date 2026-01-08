import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

/// Creates a ProviderContainer for testing with optional overrides
/// Note: using List<Object> because simple 'Override' type is not resolving correctly in analyzer
ProviderContainer createContainer({List<Object> overrides = const []}) {
  final container = ProviderContainer(overrides: overrides as dynamic);
  addTearDown(container.dispose);
  return container;
}

/// Helper to pump and settle widgets in tests
Future<void> pumpAndSettle(WidgetTester tester) async {
  await tester.pumpAndSettle(const Duration(milliseconds: 100));
}

/// Helper constants for testing
class TestConstants {
  static const testMemberId = 'test_member_1';
  static const testMemberName = 'Test User';
  static const testMessId = 'test_mess_1';
  static const testAmount = 100.0;
  static const testMealCount = 3;
}

/// Date helpers for testing
class TestDates {
  static DateTime get today => DateTime.now();
  static DateTime get yesterday =>
      DateTime.now().subtract(const Duration(days: 1));
  static DateTime get lastWeek =>
      DateTime.now().subtract(const Duration(days: 7));
  static DateTime get lastMonth =>
      DateTime.now().subtract(const Duration(days: 30));

  static DateTime get monthStart {
    final now = DateTime.now();
    return DateTime(now.year, now.month, 1);
  }

  static DateTime get monthEnd {
    final now = DateTime.now();
    return DateTime(now.year, now.month + 1, 0);
  }
}
