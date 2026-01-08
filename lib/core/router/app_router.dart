import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:mess_manager/features/dashboard/screens/dashboard_screen.dart';
import 'package:mess_manager/features/bazar/screens/bazar_screen.dart';
import 'package:mess_manager/features/meals/screens/meals_screen.dart';
import 'package:mess_manager/features/balance/screens/balance_screen.dart';
import 'package:mess_manager/features/settings/screens/settings_screen.dart';
import 'package:mess_manager/features/analytics/screens/analytics_screen.dart';
import 'package:mess_manager/features/money/screens/money_screen.dart';
import 'package:mess_manager/features/members/screens/members_screen.dart';
import 'package:mess_manager/features/vacation/screens/vacation_screen.dart';
import 'package:mess_manager/features/vacation/screens/fixed_expenses_screen.dart';
import 'package:mess_manager/features/desco/screens/desco_screen.dart';
import 'package:mess_manager/features/ramadan/screens/ramadan_screen.dart';
import 'package:mess_manager/features/ramadan/screens/ramadan_calendar_screen.dart';
import 'package:mess_manager/features/settlement/screens/settlement_screen.dart';
import 'package:mess_manager/features/duties/screens/duties_screen.dart';
import 'package:mess_manager/features/settlement/screens/month_summary_screen.dart';
import 'package:mess_manager/features/info/screens/info_screen.dart';
import 'package:mess_manager/features/auth/screens/login_screen.dart';
import 'package:mess_manager/features/auth/screens/signup_screen.dart';
import 'package:mess_manager/features/auth/screens/mess_selection_screen.dart';
import 'package:mess_manager/features/auth/screens/profile_screen.dart';
import 'package:mess_manager/features/notifications/screens/notification_settings_screen.dart';
import 'package:mess_manager/features/notifications/screens/notification_history_screen.dart';
import 'package:mess_manager/features/chatbot/screens/chatbot_screen.dart';
import 'package:mess_manager/features/auth/screens/approval_dashboard_screen.dart';
import 'package:mess_manager/features/auth/screens/pending_approval_screen.dart';
import 'package:mess_manager/features/auth/providers/auth_provider.dart';
import 'package:mess_manager/shared/widgets/main_shell.dart';
import 'package:mess_manager/core/widgets/error_screen.dart';

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
  static const ramadanCalendar = '/ramadan-calendar';
  static const settlement = '/settlement';
  static const duties = '/duties';
  static const fixedExpenses = '/fixed-expenses';
  static const info = '/info';
  static const chatbot = '/chatbot';
  static const notifications = '/notifications';
  static const monthSummary = '/month-summary';

  // Auth routes
  static const login = '/login';
  static const signup = '/signup';
  static const messSelection = '/mess-selection';
  static const profile = '/profile';
  static const notificationSettings = '/notification-settings';
  static const adminApprovals = '/admin/approvals';
  static const pendingApproval = '/pending-approval';
}

/// Auth routes that don't require authentication
const _publicRoutes = [
  AppRoutes.login,
  AppRoutes.signup,
  AppRoutes.pendingApproval,
];

/// Create router with auth state awareness
GoRouter createAppRouter(WidgetRef ref) {
  debugPrint('GoRouter: Creating app router...');
  return GoRouter(
    initialLocation: AppRoutes.login,
    debugLogDiagnostics: true,
    errorPageBuilder: (context, state) =>
        MaterialPage(child: ErrorScreen(error: state.error)),
    redirect: (context, state) {
      try {
        debugPrint('GoRouter: Redirect called for ${state.matchedLocation}');
        final authState = ref.read(authProvider);
        debugPrint('GoRouter: Auth status = ${authState.status}');
        final isLoggedIn = authState.status == AuthStatus.authenticated;
        final isPending = authState.status == AuthStatus.pendingApproval;
        final isOnPublicRoute = _publicRoutes.contains(state.matchedLocation);

        // If pending approval, redirect to pending screen
        if (isPending && state.matchedLocation != AppRoutes.pendingApproval) {
          return AppRoutes.pendingApproval;
        }

        // If not logged in and trying to access protected route
        if (!isLoggedIn && !isPending && !isOnPublicRoute) {
          return AppRoutes.login;
        }

        // If logged in and on login/signup, redirect to dashboard
        if (isLoggedIn &&
            (state.matchedLocation == AppRoutes.login ||
                state.matchedLocation == AppRoutes.signup)) {
          return AppRoutes.dashboard;
        }

        return null; // No redirect needed
      } catch (e, stack) {
        debugPrint('GoRouter redirect error: $e');
        debugPrint('Stack: $stack');
        return null;
      }
    },
    routes: [
      // Auth Routes (outside shell)
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: AppRoutes.signup,
        builder: (context, state) => const SignupScreen(),
      ),
      GoRoute(
        path: AppRoutes.messSelection,
        builder: (context, state) => const MessSelectionScreen(),
      ),
      GoRoute(
        path: AppRoutes.profile,
        builder: (context, state) => const ProfileScreen(),
      ),
      GoRoute(
        path: AppRoutes.notifications,
        builder: (context, state) => const NotificationHistoryScreen(),
      ),
      GoRoute(
        path: AppRoutes.monthSummary,
        builder: (context, state) => const MonthSummaryScreen(),
      ),
      GoRoute(
        path: AppRoutes.adminApprovals,
        builder: (context, state) => const ApprovalDashboardScreen(),
      ),
      GoRoute(
        path: AppRoutes.pendingApproval,
        builder: (context, state) => const PendingApprovalScreen(),
      ),

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
            // Note: Add bazar entry uses showModalBottomSheet, not navigation
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
          GoRoute(
            path: AppRoutes.ramadanCalendar,
            name: 'ramadan-calendar',
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: RamadanCalendarScreen()),
          ),
          GoRoute(
            path: AppRoutes.settlement,
            name: 'settlement',
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: SettlementScreen()),
          ),
          GoRoute(
            path: AppRoutes.duties,
            name: 'duties',
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: DutiesScreen()),
          ),
          GoRoute(
            path: AppRoutes.fixedExpenses,
            name: 'fixed-expenses',
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: FixedExpensesScreen()),
          ),
          GoRoute(
            path: AppRoutes.info,
            name: 'info',
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: InfoScreen()),
          ),
          GoRoute(
            path: AppRoutes.notificationSettings,
            name: 'notification-settings',
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: NotificationSettingsScreen()),
          ),
          GoRoute(
            path: AppRoutes.chatbot,
            name: 'chatbot',
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: ChatbotScreen()),
          ),
        ],
      ),
    ],
  );
}
