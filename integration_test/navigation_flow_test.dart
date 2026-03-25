// Navigation Flow Integration Test
//
// Tests all navigation paths on a real device/emulator:
//   1. Bottom nav tabs (Home, Bazar, Meals, Balance, Settings)
//   2. Dashboard module grid items (Analytics, Members, Vacation, etc.)
//   3. Global FAB / Quick Actions sheet
//   4. Profile icon -> Profile screen
//
// Run:
//   flutter test integration_test/navigation_flow_test.dart -d <device_id>
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:mess_manager/main.dart' as app;
import 'package:mess_manager/features/auth/screens/login_screen.dart';
import 'package:mess_manager/features/auth/screens/mess_selection_screen.dart';
import 'package:mess_manager/features/auth/screens/profile_screen.dart';
import 'package:mess_manager/features/dashboard/screens/dashboard_screen.dart';
import 'package:mess_manager/features/bazar/screens/bazar_screen.dart';
import 'package:mess_manager/features/meals/screens/meals_screen.dart';
import 'package:mess_manager/features/balance/screens/balance_screen.dart';
import 'package:mess_manager/features/settings/screens/settings_screen.dart';
import 'package:mess_manager/features/analytics/screens/analytics_screen.dart';
import 'package:mess_manager/features/members/screens/members_screen.dart';
import 'package:mess_manager/features/vacation/screens/vacation_screen.dart';
import 'package:mess_manager/features/desco/screens/desco_screen.dart';
import 'package:mess_manager/features/ramadan/screens/ramadan_screen.dart';
import 'package:mess_manager/features/settlement/screens/settlement_screen.dart';
import 'package:mess_manager/features/duties/screens/duties_screen.dart';
import 'package:mess_manager/features/info/screens/info_screen.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  /// Helper: ensure app is authenticated and on Dashboard before each test.
  Future<void> ensureOnDashboard(WidgetTester tester) async {
    app.main();
    await tester.pumpAndSettle(const Duration(seconds: 5));

    // If on Login, sign in with test credentials
    if (find.byType(LoginScreen).evaluate().isNotEmpty) {
      final emailField = find.widgetWithText(TextFormField, 'Email');
      final passwordField = find.widgetWithText(TextFormField, 'Password');

      if (emailField.evaluate().isNotEmpty) {
        await tester.enterText(emailField, 'navtest@example.com');
      }
      if (passwordField.evaluate().isNotEmpty) {
        await tester.enterText(passwordField, 'password123');
      }
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pumpAndSettle();

      final signInBtn = find.text('Sign In');
      if (signInBtn.evaluate().isNotEmpty) {
        await tester.tap(signInBtn.first);
        await tester.pumpAndSettle(const Duration(seconds: 5));
      }
    }

    // Handle MessSelection if shown
    if (find.byType(MessSelectionScreen).evaluate().isNotEmpty) {
      final continueDefault = find.text('Continue with Default Mess');
      if (continueDefault.evaluate().isNotEmpty) {
        await tester.tap(continueDefault);
        await tester.pumpAndSettle(const Duration(seconds: 3));
      }
    }

    // Ensure we're on Dashboard
    if (find.byType(DashboardScreen).evaluate().isEmpty) {
      // Try tapping Home tab
      final homeTab = find.text('Home');
      if (homeTab.evaluate().isNotEmpty) {
        await tester.tap(homeTab.last);
        await tester.pumpAndSettle(const Duration(seconds: 2));
      }
    }
  }

  group(
    'Bottom Navigation Tabs',
    () {
      testWidgets(
        'Tap Home tab -> DashboardScreen loads',
        (tester) async {
          await ensureOnDashboard(tester);

          // Tap Home tab (should already be selected, but verify)
          final homeTab = find.text('Home');
          if (homeTab.evaluate().isNotEmpty) {
            await tester.tap(homeTab.last);
            await tester.pumpAndSettle(const Duration(seconds: 2));
          }

          expect(
            find.byType(DashboardScreen),
            findsOneWidget,
            reason: 'Home tab should show DashboardScreen',
          );

          // Verify dashboard has key content
          expect(find.text('Area51 Mess'), findsWidgets);
        },
      );

      testWidgets(
        'Tap Bazar tab -> BazarScreen loads',
        (tester) async {
          await ensureOnDashboard(tester);

          final bazarTab = find.text('Bazar');
          expect(bazarTab, findsWidgets, reason: 'Bazar tab should exist');
          await tester.tap(bazarTab.last);
          await tester.pumpAndSettle(const Duration(seconds: 2));

          expect(
            find.byType(BazarScreen),
            findsOneWidget,
            reason: 'Bazar tab should show BazarScreen',
          );
        },
      );

      testWidgets(
        'Tap Meals tab -> MealsScreen loads',
        (tester) async {
          await ensureOnDashboard(tester);

          final mealsTab = find.text('Meals');
          expect(mealsTab, findsWidgets, reason: 'Meals tab should exist');
          await tester.tap(mealsTab.last);
          await tester.pumpAndSettle(const Duration(seconds: 2));

          expect(
            find.byType(MealsScreen),
            findsOneWidget,
            reason: 'Meals tab should show MealsScreen',
          );
        },
      );

      testWidgets(
        'Tap Balance tab -> BalanceScreen loads',
        (tester) async {
          await ensureOnDashboard(tester);

          final balanceTab = find.text('Balance');
          expect(balanceTab, findsWidgets, reason: 'Balance tab should exist');
          await tester.tap(balanceTab.last);
          await tester.pumpAndSettle(const Duration(seconds: 2));

          expect(
            find.byType(BalanceScreen),
            findsOneWidget,
            reason: 'Balance tab should show BalanceScreen',
          );
        },
      );

      testWidgets(
        'Tap Settings tab -> SettingsScreen loads',
        (tester) async {
          await ensureOnDashboard(tester);

          final settingsTab = find.text('Settings');
          expect(settingsTab, findsWidgets, reason: 'Settings tab should exist');
          await tester.tap(settingsTab.last);
          await tester.pumpAndSettle(const Duration(seconds: 2));

          expect(
            find.byType(SettingsScreen),
            findsOneWidget,
            reason: 'Settings tab should show SettingsScreen',
          );

          // Verify Settings header
          expect(find.text('Settings'), findsWidgets);
        },
      );

      testWidgets(
        'Cycle through all tabs rapidly without crash',
        (tester) async {
          await ensureOnDashboard(tester);

          final tabs = ['Home', 'Bazar', 'Meals', 'Balance', 'Settings'];

          for (final tabName in tabs) {
            final tab = find.text(tabName);
            if (tab.evaluate().isNotEmpty) {
              await tester.tap(tab.last);
              await tester.pumpAndSettle(const Duration(seconds: 1));
            }
          }

          // Cycle back
          for (final tabName in tabs.reversed) {
            final tab = find.text(tabName);
            if (tab.evaluate().isNotEmpty) {
              await tester.tap(tab.last);
              await tester.pumpAndSettle(const Duration(seconds: 1));
            }
          }

          // App should not crash
          expect(find.byType(MaterialApp), findsOneWidget);
        },
      );
    },
  );

  group(
    'Dashboard Module Grid Navigation',
    () {
      testWidgets(
        'Tap Analytics module -> AnalyticsScreen loads and back works',
        (tester) async {
          await ensureOnDashboard(tester);

          // Scroll to the modules grid
          final scrollable = find.byType(Scrollable);
          if (scrollable.evaluate().isNotEmpty) {
            await tester.scrollUntilVisible(
              find.text('Analytics'),
              200,
              scrollable: scrollable.first,
            );
            await tester.pumpAndSettle(const Duration(seconds: 1));
          }

          final analyticsCard = find.text('Analytics');
          expect(analyticsCard, findsWidgets);
          await tester.tap(analyticsCard.first);
          await tester.pumpAndSettle(const Duration(seconds: 3));

          expect(
            find.byType(AnalyticsScreen),
            findsOneWidget,
            reason: 'Should navigate to AnalyticsScreen',
          );

          // Go back
          final backBtn = find.byType(BackButton);
          if (backBtn.evaluate().isNotEmpty) {
            await tester.tap(backBtn.first);
          } else {
            // Try the page's back button or navigator pop
            await tester.pageBack();
          }
          await tester.pumpAndSettle(const Duration(seconds: 2));

          expect(
            find.byType(DashboardScreen),
            findsOneWidget,
            reason: 'Should return to DashboardScreen after back',
          );
        },
      );

      testWidgets(
        'Tap Members module -> MembersScreen loads',
        (tester) async {
          await ensureOnDashboard(tester);

          final scrollable = find.byType(Scrollable);
          if (scrollable.evaluate().isNotEmpty) {
            await tester.scrollUntilVisible(
              find.text('Members'),
              200,
              scrollable: scrollable.first,
            );
            await tester.pumpAndSettle();
          }

          final membersCard = find.text('Members');
          if (membersCard.evaluate().isNotEmpty) {
            await tester.tap(membersCard.first);
            await tester.pumpAndSettle(const Duration(seconds: 3));

            expect(
              find.byType(MembersScreen),
              findsOneWidget,
              reason: 'Should navigate to MembersScreen',
            );

            await tester.pageBack();
            await tester.pumpAndSettle(const Duration(seconds: 2));
          }
        },
      );

      testWidgets(
        'Tap Vacation module -> VacationScreen loads',
        (tester) async {
          await ensureOnDashboard(tester);

          final scrollable = find.byType(Scrollable);
          if (scrollable.evaluate().isNotEmpty) {
            await tester.scrollUntilVisible(
              find.text('Vacation'),
              200,
              scrollable: scrollable.first,
            );
            await tester.pumpAndSettle();
          }

          final vacationCard = find.text('Vacation');
          if (vacationCard.evaluate().isNotEmpty) {
            await tester.tap(vacationCard.first);
            await tester.pumpAndSettle(const Duration(seconds: 3));

            expect(
              find.byType(VacationScreen),
              findsOneWidget,
              reason: 'Should navigate to VacationScreen',
            );

            await tester.pageBack();
            await tester.pumpAndSettle(const Duration(seconds: 2));
          }
        },
      );

      testWidgets(
        'Tap DESCO module -> DescoScreen loads',
        (tester) async {
          await ensureOnDashboard(tester);

          final scrollable = find.byType(Scrollable);
          if (scrollable.evaluate().isNotEmpty) {
            await tester.scrollUntilVisible(
              find.text('DESCO'),
              200,
              scrollable: scrollable.first,
            );
            await tester.pumpAndSettle();
          }

          final descoCard = find.text('DESCO');
          if (descoCard.evaluate().isNotEmpty) {
            await tester.tap(descoCard.first);
            await tester.pumpAndSettle(const Duration(seconds: 3));

            expect(
              find.byType(DescoScreen),
              findsOneWidget,
              reason: 'Should navigate to DescoScreen',
            );

            await tester.pageBack();
            await tester.pumpAndSettle(const Duration(seconds: 2));
          }
        },
      );

      testWidgets(
        'Tap Ramadan module -> RamadanScreen loads',
        (tester) async {
          await ensureOnDashboard(tester);

          final scrollable = find.byType(Scrollable);
          if (scrollable.evaluate().isNotEmpty) {
            await tester.scrollUntilVisible(
              find.text('Ramadan'),
              200,
              scrollable: scrollable.first,
            );
            await tester.pumpAndSettle();
          }

          final ramadanCard = find.text('Ramadan');
          if (ramadanCard.evaluate().isNotEmpty) {
            await tester.tap(ramadanCard.first);
            await tester.pumpAndSettle(const Duration(seconds: 3));

            expect(
              find.byType(RamadanScreen),
              findsOneWidget,
              reason: 'Should navigate to RamadanScreen',
            );

            await tester.pageBack();
            await tester.pumpAndSettle(const Duration(seconds: 2));
          }
        },
      );

      testWidgets(
        'Tap Settlement module -> SettlementScreen loads',
        (tester) async {
          await ensureOnDashboard(tester);

          final scrollable = find.byType(Scrollable);
          if (scrollable.evaluate().isNotEmpty) {
            await tester.scrollUntilVisible(
              find.text('Settlement'),
              200,
              scrollable: scrollable.first,
            );
            await tester.pumpAndSettle();
          }

          final settlementCard = find.text('Settlement');
          if (settlementCard.evaluate().isNotEmpty) {
            await tester.tap(settlementCard.first);
            await tester.pumpAndSettle(const Duration(seconds: 3));

            expect(
              find.byType(SettlementScreen),
              findsOneWidget,
              reason: 'Should navigate to SettlementScreen',
            );

            await tester.pageBack();
            await tester.pumpAndSettle(const Duration(seconds: 2));
          }
        },
      );

      testWidgets(
        'Tap Duties module -> DutiesScreen loads',
        (tester) async {
          await ensureOnDashboard(tester);

          final scrollable = find.byType(Scrollable);
          if (scrollable.evaluate().isNotEmpty) {
            await tester.scrollUntilVisible(
              find.text('Duties'),
              200,
              scrollable: scrollable.first,
            );
            await tester.pumpAndSettle();
          }

          final dutiesCard = find.text('Duties');
          if (dutiesCard.evaluate().isNotEmpty) {
            await tester.tap(dutiesCard.first);
            await tester.pumpAndSettle(const Duration(seconds: 3));

            expect(
              find.byType(DutiesScreen),
              findsOneWidget,
              reason: 'Should navigate to DutiesScreen',
            );

            await tester.pageBack();
            await tester.pumpAndSettle(const Duration(seconds: 2));
          }
        },
      );

      testWidgets(
        'Tap Info module -> InfoScreen loads',
        (tester) async {
          await ensureOnDashboard(tester);

          final scrollable = find.byType(Scrollable);
          if (scrollable.evaluate().isNotEmpty) {
            await tester.scrollUntilVisible(
              find.text('Info'),
              200,
              scrollable: scrollable.first,
            );
            await tester.pumpAndSettle();
          }

          final infoCard = find.text('Info');
          if (infoCard.evaluate().isNotEmpty) {
            await tester.tap(infoCard.first);
            await tester.pumpAndSettle(const Duration(seconds: 3));

            expect(
              find.byType(InfoScreen),
              findsOneWidget,
              reason: 'Should navigate to InfoScreen',
            );

            await tester.pageBack();
            await tester.pumpAndSettle(const Duration(seconds: 2));
          }
        },
      );
    },
  );

  group(
    'FAB / Quick Actions Sheet',
    () {
      testWidgets(
        'Dashboard FAB opens Quick Actions sheet',
        (tester) async {
          await ensureOnDashboard(tester);

          // Dashboard should show the speed-dial FAB
          final fab = find.byType(FloatingActionButton);
          if (fab.evaluate().isNotEmpty) {
            await tester.tap(fab.first);
            await tester.pumpAndSettle(const Duration(seconds: 2));

            // Quick Actions sheet should be visible
            expect(
              find.text('Quick add'),
              findsOneWidget,
              reason: 'Quick Actions sheet should show "Quick add" title',
            );

            // Verify action items are present
            expect(find.text('Meal'), findsWidgets);
            expect(find.text('Bazar'), findsWidgets);
            expect(find.text('Money'), findsWidgets);
            expect(find.text('Duty'), findsWidgets);

            // Dismiss the sheet
            await tester.tapAt(Offset.zero);
            await tester.pumpAndSettle(const Duration(seconds: 1));
          }
        },
      );

      testWidgets(
        'Quick Actions -> Meal opens AddMealSheet',
        (tester) async {
          await ensureOnDashboard(tester);

          final fab = find.byType(FloatingActionButton);
          if (fab.evaluate().isNotEmpty) {
            await tester.tap(fab.first);
            await tester.pumpAndSettle(const Duration(seconds: 2));

            // Tap "Meal" action
            final mealAction = find.text('Meal');
            if (mealAction.evaluate().isNotEmpty) {
              await tester.tap(mealAction.first);
              await tester.pumpAndSettle(const Duration(seconds: 2));

              // AddMealSheet should appear (look for its submit button text)
              final addMealIndicator = find.textContaining('meal');
              expect(
                addMealIndicator,
                findsWidgets,
                reason: 'AddMealSheet should open with meal-related content',
              );

              // Dismiss sheet
              await tester.tapAt(Offset.zero);
              await tester.pumpAndSettle(const Duration(seconds: 1));
            }
          }
        },
      );

      testWidgets(
        'Quick Actions -> Bazar opens AddBazarSheet',
        (tester) async {
          await ensureOnDashboard(tester);

          final fab = find.byType(FloatingActionButton);
          if (fab.evaluate().isNotEmpty) {
            await tester.tap(fab.first);
            await tester.pumpAndSettle(const Duration(seconds: 2));

            final bazarAction = find.text('Bazar');
            if (bazarAction.evaluate().isNotEmpty) {
              await tester.tap(bazarAction.first);
              await tester.pumpAndSettle(const Duration(seconds: 2));

              // AddBazarSheet should appear
              final bazarIndicator = find.byType(TextField);
              expect(
                bazarIndicator,
                findsWidgets,
                reason: 'AddBazarSheet should open with input fields',
              );

              // Dismiss sheet
              await tester.tapAt(Offset.zero);
              await tester.pumpAndSettle(const Duration(seconds: 1));
            }
          }
        },
      );

      testWidgets(
        'Quick Actions -> Duty navigates to DutiesScreen',
        (tester) async {
          await ensureOnDashboard(tester);

          final fab = find.byType(FloatingActionButton);
          if (fab.evaluate().isNotEmpty) {
            await tester.tap(fab.first);
            await tester.pumpAndSettle(const Duration(seconds: 2));

            final dutyAction = find.text('Duty');
            if (dutyAction.evaluate().isNotEmpty) {
              await tester.tap(dutyAction.first);
              await tester.pumpAndSettle(const Duration(seconds: 3));

              expect(
                find.byType(DutiesScreen),
                findsOneWidget,
                reason: 'Tapping Duty action should navigate to DutiesScreen',
              );

              await tester.pageBack();
              await tester.pumpAndSettle(const Duration(seconds: 2));
            }
          }
        },
      );

      testWidgets(
        'Bazar tab FAB shows "Add Bazar" extended FAB',
        (tester) async {
          await ensureOnDashboard(tester);

          // Navigate to Bazar tab
          final bazarTab = find.text('Bazar');
          if (bazarTab.evaluate().isNotEmpty) {
            await tester.tap(bazarTab.last);
            await tester.pumpAndSettle(const Duration(seconds: 2));
          }

          // Should show an extended FAB labeled "Add Bazar"
          final addBazarFab = find.text('Add Bazar');
          expect(
            addBazarFab,
            findsWidgets,
            reason: 'Bazar tab should show "Add Bazar" FAB',
          );
        },
      );

      testWidgets(
        'Meals tab FAB shows "Add Meal" extended FAB',
        (tester) async {
          await ensureOnDashboard(tester);

          // Navigate to Meals tab
          final mealsTab = find.text('Meals');
          if (mealsTab.evaluate().isNotEmpty) {
            await tester.tap(mealsTab.last);
            await tester.pumpAndSettle(const Duration(seconds: 2));
          }

          // Should show an extended FAB labeled "Add Meal"
          final addMealFab = find.text('Add Meal');
          expect(
            addMealFab,
            findsWidgets,
            reason: 'Meals tab should show "Add Meal" FAB',
          );
        },
      );
    },
  );

  group(
    'Profile Navigation',
    () {
      testWidgets(
        'Profile icon on Dashboard navigates to ProfileScreen',
        (tester) async {
          await ensureOnDashboard(tester);

          // The profile icon is a CircleAvatar in the header
          final circleAvatar = find.byType(CircleAvatar);
          if (circleAvatar.evaluate().isNotEmpty) {
            await tester.tap(circleAvatar.first);
            await tester.pumpAndSettle(const Duration(seconds: 3));

            expect(
              find.byType(ProfileScreen),
              findsOneWidget,
              reason: 'Tapping profile icon should open ProfileScreen',
            );

            // Go back
            await tester.pageBack();
            await tester.pumpAndSettle(const Duration(seconds: 2));

            expect(
              find.byType(DashboardScreen),
              findsOneWidget,
              reason: 'Back from profile should return to Dashboard',
            );
          }
        },
      );
    },
  );
}
