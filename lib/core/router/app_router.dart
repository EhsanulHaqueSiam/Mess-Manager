import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:mess_manager/features/dashboard/screens/dashboard_screen.dart';
import 'package:mess_manager/features/bazar/screens/bazar_screen.dart';
import 'package:mess_manager/features/meals/screens/meals_screen.dart';
import 'package:mess_manager/features/balance/screens/balance_screen.dart';
import 'package:mess_manager/features/settings/screens/settings_screen.dart';
import 'package:mess_manager/features/analytics/screens/analytics_screen.dart';
import 'package:mess_manager/features/money/screens/money_screen.dart';
import 'package:mess_manager/features/members/screens/members_screen.dart';
import 'package:mess_manager/features/vacation/screens/vacation_screen.dart';
import 'package:mess_manager/features/desco/screens/desco_screen.dart';
import 'package:mess_manager/features/ramadan/screens/ramadan_screen.dart';
import 'package:mess_manager/shared/widgets/main_shell.dart';

/// App Routes Constants
class AppRoutes {
  static const dashboard = '/';
  static const bazar = '/bazar';
  static const meals = '/meals';
  static const balance = '/balance';
  static const settings = '/settings';
  static const analytics = '/analytics';
  static const money = '/money';
  static const members = '/members';
  static const vacation = '/vacation';
  static const desco = '/desco';
  static const ramadan = '/ramadan';

  // Nested routes
  static const bazarAdd = '/bazar/add';
  static const bazarList = '/bazar/list';
  static const mealsBulk = '/meals/bulk';
}

/// Main Router Configuration
final appRouter = GoRouter(
  initialLocation: AppRoutes.dashboard,
  debugLogDiagnostics: true,
  routes: [
    /// Main Shell with Bottom Navigation
    ShellRoute(
      builder: (context, state, child) => MainShell(child: child),
      routes: [
        GoRoute(
          path: AppRoutes.dashboard,
          name: 'dashboard',
          pageBuilder: (context, state) =>
              const NoTransitionPage(child: DashboardScreen()),
        ),
        GoRoute(
          path: AppRoutes.bazar,
          name: 'bazar',
          pageBuilder: (context, state) =>
              const NoTransitionPage(child: BazarScreen()),
          routes: [
            // TODO: Add nested bazar routes
          ],
        ),
        GoRoute(
          path: AppRoutes.meals,
          name: 'meals',
          pageBuilder: (context, state) =>
              const NoTransitionPage(child: MealsScreen()),
        ),
        GoRoute(
          path: AppRoutes.balance,
          name: 'balance',
          pageBuilder: (context, state) =>
              const NoTransitionPage(child: BalanceScreen()),
        ),
        GoRoute(
          path: AppRoutes.settings,
          name: 'settings',
          pageBuilder: (context, state) =>
              const NoTransitionPage(child: SettingsScreen()),
        ),
        GoRoute(
          path: AppRoutes.analytics,
          name: 'analytics',
          pageBuilder: (context, state) =>
              const NoTransitionPage(child: AnalyticsScreen()),
        ),
        GoRoute(
          path: AppRoutes.money,
          name: 'money',
          pageBuilder: (context, state) =>
              const NoTransitionPage(child: MoneyScreen()),
        ),
        GoRoute(
          path: AppRoutes.members,
          name: 'members',
          pageBuilder: (context, state) =>
              const NoTransitionPage(child: MembersScreen()),
        ),
        GoRoute(
          path: AppRoutes.vacation,
          name: 'vacation',
          pageBuilder: (context, state) =>
              const NoTransitionPage(child: VacationScreen()),
        ),
        GoRoute(
          path: AppRoutes.desco,
          name: 'desco',
          pageBuilder: (context, state) =>
              const NoTransitionPage(child: DescoScreen()),
        ),
        GoRoute(
          path: AppRoutes.ramadan,
          name: 'ramadan',
          pageBuilder: (context, state) =>
              const NoTransitionPage(child: RamadanScreen()),
        ),
      ],
    ),
  ],
  errorBuilder: (context, state) =>
      Scaffold(body: Center(child: Text('Page not found: ${state.uri}'))),
);
