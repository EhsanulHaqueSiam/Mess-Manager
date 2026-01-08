/// ═══════════════════════════════════════════════════════════════════════════
/// SCREEN REGISTRY - Central Registry of All Application Screens
/// ═══════════════════════════════════════════════════════════════════════════
/// Purpose: Single source of truth for all screens in the application.
/// Used by:
///   - Integration tests (page coverage verification)
///   - Widget tests (per-screen testing)
///   - Route verification (unique path enforcement)
///   - Auto-discovery (new screens automatically included in tests)
/// ═══════════════════════════════════════════════════════════════════════════
library;

import 'package:flutter/material.dart';

// Feature: Analytics
import 'package:mess_manager/features/analytics/screens/analytics_screen.dart';

// Feature: Auth
import 'package:mess_manager/features/auth/screens/approval_dashboard_screen.dart';
import 'package:mess_manager/features/auth/screens/login_screen.dart';
import 'package:mess_manager/features/auth/screens/mess_selection_screen.dart';
import 'package:mess_manager/features/auth/screens/pending_approval_screen.dart';
import 'package:mess_manager/features/auth/screens/profile_screen.dart';
import 'package:mess_manager/features/auth/screens/signup_screen.dart';

// Feature: Balance
import 'package:mess_manager/features/balance/screens/balance_screen.dart';

// Feature: Bazar
import 'package:mess_manager/features/bazar/screens/bazar_screen.dart';

// Feature: Chatbot
import 'package:mess_manager/features/chatbot/screens/chatbot_screen.dart';

// Feature: Dashboard
import 'package:mess_manager/features/dashboard/screens/dashboard_screen.dart';

// Feature: Desco
import 'package:mess_manager/features/desco/screens/desco_screen.dart';

// Feature: Duties
import 'package:mess_manager/features/duties/screens/duties_screen.dart';

// Feature: Info
import 'package:mess_manager/features/info/screens/info_screen.dart';

// Feature: Meals
import 'package:mess_manager/features/meals/screens/meals_screen.dart';

// Feature: Members
import 'package:mess_manager/features/members/screens/members_screen.dart';

// Feature: Money
import 'package:mess_manager/features/money/screens/money_screen.dart';

// Feature: Notifications
import 'package:mess_manager/features/notifications/screens/notification_history_screen.dart';
import 'package:mess_manager/features/notifications/screens/notification_settings_screen.dart';

// Feature: Ramadan
import 'package:mess_manager/features/ramadan/screens/ramadan_calendar_screen.dart';
import 'package:mess_manager/features/ramadan/screens/ramadan_screen.dart';

// Feature: Settings
import 'package:mess_manager/features/settings/screens/settings_screen.dart';

// Feature: Settlement
import 'package:mess_manager/features/settlement/screens/month_summary_screen.dart';
import 'package:mess_manager/features/settlement/screens/settlement_screen.dart';

// Feature: Vacation
import 'package:mess_manager/features/vacation/screens/bulk_cancel_screen.dart';
import 'package:mess_manager/features/vacation/screens/fixed_expenses_screen.dart';
import 'package:mess_manager/features/vacation/screens/vacation_screen.dart';

/// Screen metadata for testing and documentation
class ScreenInfo {
  final String route;
  final String name;
  final String feature;
  final Widget Function() builder;
  final bool requiresAuth;
  final bool hasBottomNav;

  const ScreenInfo({
    required this.route,
    required this.name,
    required this.feature,
    required this.builder,
    this.requiresAuth = true,
    this.hasBottomNav = false,
  });
}

/// Central registry of all screens in the application.
/// Add new screens here and they will automatically be included in tests.
final List<ScreenInfo> screenRegistry = [
  // ═══════════════════════════════════════════════════════════════════════════
  // MAIN NAVIGATION SCREENS (Bottom Nav)
  // ═══════════════════════════════════════════════════════════════════════════
  ScreenInfo(
    route: '/',
    name: 'Dashboard',
    feature: 'dashboard',
    builder: () => const DashboardScreen(),
    hasBottomNav: true,
  ),
  ScreenInfo(
    route: '/bazar',
    name: 'Bazar',
    feature: 'bazar',
    builder: () => const BazarScreen(),
    hasBottomNav: true,
  ),
  ScreenInfo(
    route: '/meals',
    name: 'Meals',
    feature: 'meals',
    builder: () => const MealsScreen(),
    hasBottomNav: true,
  ),
  ScreenInfo(
    route: '/balance',
    name: 'Balance',
    feature: 'balance',
    builder: () => const BalanceScreen(),
    hasBottomNav: true,
  ),
  ScreenInfo(
    route: '/settings',
    name: 'Settings',
    feature: 'settings',
    builder: () => const SettingsScreen(),
    hasBottomNav: true,
  ),

  // ═══════════════════════════════════════════════════════════════════════════
  // AUTH SCREENS (No Auth Required)
  // ═══════════════════════════════════════════════════════════════════════════
  ScreenInfo(
    route: '/login',
    name: 'Login',
    feature: 'auth',
    builder: () => const LoginScreen(),
    requiresAuth: false,
  ),
  ScreenInfo(
    route: '/signup',
    name: 'Signup',
    feature: 'auth',
    builder: () => const SignupScreen(),
    requiresAuth: false,
  ),
  ScreenInfo(
    route: '/mess-selection',
    name: 'Mess Selection',
    feature: 'auth',
    builder: () => const MessSelectionScreen(),
    requiresAuth: false,
  ),
  ScreenInfo(
    route: '/pending-approval',
    name: 'Pending Approval',
    feature: 'auth',
    builder: () => const PendingApprovalScreen(),
    requiresAuth: false,
  ),
  ScreenInfo(
    route: '/profile',
    name: 'Profile',
    feature: 'auth',
    builder: () => const ProfileScreen(),
  ),
  ScreenInfo(
    route: '/admin/approvals',
    name: 'Approval Dashboard',
    feature: 'auth',
    builder: () => const ApprovalDashboardScreen(),
  ),

  // ═══════════════════════════════════════════════════════════════════════════
  // FEATURE SCREENS
  // ═══════════════════════════════════════════════════════════════════════════
  ScreenInfo(
    route: '/analytics',
    name: 'Analytics',
    feature: 'analytics',
    builder: () => const AnalyticsScreen(),
  ),
  ScreenInfo(
    route: '/money',
    name: 'Money',
    feature: 'money',
    builder: () => const MoneyScreen(),
  ),
  ScreenInfo(
    route: '/members',
    name: 'Members',
    feature: 'members',
    builder: () => const MembersScreen(),
  ),
  ScreenInfo(
    route: '/vacation',
    name: 'Vacation',
    feature: 'vacation',
    builder: () => const VacationScreen(),
  ),
  ScreenInfo(
    route: '/vacation/bulk-cancel',
    name: 'Bulk Cancel',
    feature: 'vacation',
    builder: () => const BulkCancelScreen(),
  ),
  ScreenInfo(
    route: '/fixed-expenses',
    name: 'Fixed Expenses',
    feature: 'vacation',
    builder: () => const FixedExpensesScreen(),
  ),
  ScreenInfo(
    route: '/desco',
    name: 'Desco',
    feature: 'desco',
    builder: () => const DescoScreen(),
  ),
  ScreenInfo(
    route: '/ramadan',
    name: 'Ramadan',
    feature: 'ramadan',
    builder: () => const RamadanScreen(),
  ),
  ScreenInfo(
    route: '/ramadan-calendar',
    name: 'Ramadan Calendar',
    feature: 'ramadan',
    builder: () => const RamadanCalendarScreen(),
  ),
  ScreenInfo(
    route: '/settlement',
    name: 'Settlement',
    feature: 'settlement',
    builder: () => const SettlementScreen(),
  ),
  ScreenInfo(
    route: '/month-summary',
    name: 'Month Summary',
    feature: 'settlement',
    builder: () => const MonthSummaryScreen(),
  ),
  ScreenInfo(
    route: '/duties',
    name: 'Duties',
    feature: 'duties',
    builder: () => const DutiesScreen(),
  ),
  ScreenInfo(
    route: '/info',
    name: 'Info',
    feature: 'info',
    builder: () => const InfoScreen(),
  ),
  ScreenInfo(
    route: '/chatbot',
    name: 'Chatbot',
    feature: 'chatbot',
    builder: () => const ChatbotScreen(),
  ),
  ScreenInfo(
    route: '/notifications',
    name: 'Notification History',
    feature: 'notifications',
    builder: () => const NotificationHistoryScreen(),
  ),
  ScreenInfo(
    route: '/notification-settings',
    name: 'Notification Settings',
    feature: 'notifications',
    builder: () => const NotificationSettingsScreen(),
  ),
];

/// Helper getters for test usage
extension ScreenRegistryHelpers on List<ScreenInfo> {
  /// Get all unique routes
  Set<String> get allRoutes => map((s) => s.route).toSet();

  /// Get all unique feature names
  Set<String> get allFeatures => map((s) => s.feature).toSet();

  /// Get screens by feature
  List<ScreenInfo> byFeature(String feature) =>
      where((s) => s.feature == feature).toList();

  /// Get screens that require auth
  List<ScreenInfo> get authRequired => where((s) => s.requiresAuth).toList();

  /// Get screens that don't require auth
  List<ScreenInfo> get noAuthRequired => where((s) => !s.requiresAuth).toList();

  /// Get bottom nav screens
  List<ScreenInfo> get bottomNavScreens =>
      where((s) => s.hasBottomNav).toList();

  /// Get screen by route
  ScreenInfo? byRoute(String route) {
    try {
      return firstWhere((s) => s.route == route);
    } catch (_) {
      return null;
    }
  }

  /// Total count
  int get totalScreens => length;
}
