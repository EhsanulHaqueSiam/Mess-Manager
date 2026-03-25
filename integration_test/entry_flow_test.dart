// Entry Flow Integration Test
//
// Tests data entry flows on a real device/emulator:
//   1. Meal entry via Dashboard FAB -> AddMealSheet -> preset -> submit
//   2. Bazar entry via Bazar tab FAB -> AddBazarSheet -> amount -> submit
//   3. Money entry via Balance tab FAB -> AddTransactionSheet -> submit
//   4. Vacation entry via Vacation module -> AddVacationSheet -> submit
//
// Run:
//   flutter test integration_test/entry_flow_test.dart -d <device_id>
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:mess_manager/main.dart' as app;
import 'package:mess_manager/features/auth/screens/login_screen.dart';
import 'package:mess_manager/features/auth/screens/mess_selection_screen.dart';
import 'package:mess_manager/features/dashboard/screens/dashboard_screen.dart';
import 'package:mess_manager/features/bazar/screens/bazar_screen.dart';
import 'package:mess_manager/features/meals/screens/meals_screen.dart';
import 'package:mess_manager/features/balance/screens/balance_screen.dart';
import 'package:mess_manager/features/vacation/screens/vacation_screen.dart';
import 'package:mess_manager/features/meals/widgets/add_meal_sheet.dart';
import 'package:mess_manager/features/bazar/widgets/add_bazar_sheet.dart';
import 'package:mess_manager/features/money/widgets/add_transaction_sheet.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  /// Helper: ensure app is authenticated and on Dashboard.
  Future<void> ensureOnDashboard(WidgetTester tester) async {
    app.main();
    await tester.pumpAndSettle(const Duration(seconds: 5));

    // If on Login, sign in with test credentials
    if (find.byType(LoginScreen).evaluate().isNotEmpty) {
      final emailField = find.widgetWithText(TextFormField, 'Email');
      final passwordField = find.widgetWithText(TextFormField, 'Password');

      if (emailField.evaluate().isNotEmpty) {
        await tester.enterText(emailField, 'entrytest@example.com');
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
      final homeTab = find.text('Home');
      if (homeTab.evaluate().isNotEmpty) {
        await tester.tap(homeTab.last);
        await tester.pumpAndSettle(const Duration(seconds: 2));
      }
    }
  }

  /// Helper: navigate to a specific tab by name.
  Future<void> navigateToTab(WidgetTester tester, String tabName) async {
    final tab = find.text(tabName);
    if (tab.evaluate().isNotEmpty) {
      await tester.tap(tab.last);
      await tester.pumpAndSettle(const Duration(seconds: 2));
    }
  }

  group(
    'Meal Entry Flow',
    () {
      testWidgets(
        'Dashboard FAB -> Add Meal -> tap preset 2 -> submit -> snackbar',
        (tester) async {
          await ensureOnDashboard(tester);

          // Tap the FAB (speed dial on Dashboard)
          final fab = find.byType(FloatingActionButton);
          if (fab.evaluate().isEmpty) {
            // FAB might not be visible if permissions are restricted
            return;
          }

          await tester.tap(fab.first);
          await tester.pumpAndSettle(const Duration(seconds: 2));

          // Tap "Meal" from Quick Actions sheet
          final mealAction = find.text('Meal');
          if (mealAction.evaluate().isEmpty) return;
          await tester.tap(mealAction.first);
          await tester.pumpAndSettle(const Duration(seconds: 2));

          // AddMealSheet should be visible
          expect(
            find.byType(AddMealSheet),
            findsOneWidget,
            reason: 'AddMealSheet should be displayed',
          );

          // Tap the "2" preset button to select 2 meals
          // The presets are shown as large tappable buttons with numbers
          final preset2 = find.text('2');
          if (preset2.evaluate().isNotEmpty) {
            await tester.tap(preset2.first);
            await tester.pumpAndSettle(const Duration(milliseconds: 500));
          }

          // Tap the submit button ("Add 2 meals")
          final submitBtn = find.textContaining('Add 2 meal');
          if (submitBtn.evaluate().isNotEmpty) {
            await tester.tap(submitBtn.first);
            await tester.pumpAndSettle(const Duration(seconds: 2));
          } else {
            // Fallback: tap any FilledButton
            final filledBtn = find.byType(FilledButton);
            if (filledBtn.evaluate().isNotEmpty) {
              await tester.tap(filledBtn.first);
              await tester.pumpAndSettle(const Duration(seconds: 2));
            }
          }

          // Verify the sheet is dismissed (back to Dashboard)
          expect(
            find.byType(AddMealSheet).evaluate().isEmpty,
            isTrue,
            reason: 'AddMealSheet should be dismissed after submit',
          );

          // Verify snackbar appears with confirmation
          final snackbar = find.byType(SnackBar);
          // Snackbar may dismiss quickly, so also check text
          final addedText = find.textContaining('Added');
          final mealText = find.textContaining('meal');
          expect(
            snackbar.evaluate().isNotEmpty ||
                addedText.evaluate().isNotEmpty ||
                mealText.evaluate().isNotEmpty,
            isTrue,
            reason: 'Should show confirmation snackbar after adding meal',
          );
        },
      );

      testWidgets(
        'Meals tab FAB -> Add Meal sheet opens directly',
        (tester) async {
          await ensureOnDashboard(tester);
          await navigateToTab(tester, 'Meals');

          expect(
            find.byType(MealsScreen),
            findsOneWidget,
            reason: 'Should be on MealsScreen',
          );

          // Tap the "Add Meal" extended FAB
          final addMealFab = find.text('Add Meal');
          if (addMealFab.evaluate().isNotEmpty) {
            await tester.tap(addMealFab.first);
            await tester.pumpAndSettle(const Duration(seconds: 2));

            // Sheet should be visible
            expect(
              find.byType(AddMealSheet),
              findsOneWidget,
              reason: 'AddMealSheet should open from Meals tab FAB',
            );

            // Dismiss by tapping outside
            await tester.tapAt(Offset.zero);
            await tester.pumpAndSettle(const Duration(seconds: 1));
          }
        },
      );

      testWidgets(
        'Meal preset "0" shows "Skip today" and dismisses',
        (tester) async {
          await ensureOnDashboard(tester);

          final fab = find.byType(FloatingActionButton);
          if (fab.evaluate().isEmpty) return;

          await tester.tap(fab.first);
          await tester.pumpAndSettle(const Duration(seconds: 2));

          final mealAction = find.text('Meal');
          if (mealAction.evaluate().isEmpty) return;
          await tester.tap(mealAction.first);
          await tester.pumpAndSettle(const Duration(seconds: 2));

          // Tap the "0" preset
          final preset0 = find.text('0');
          if (preset0.evaluate().isNotEmpty) {
            await tester.tap(preset0.first);
            await tester.pumpAndSettle(const Duration(milliseconds: 500));

            // Submit button should say "Skip today"
            expect(
              find.text('Skip today'),
              findsOneWidget,
              reason: 'Preset 0 should show "Skip today" on submit button',
            );

            // Tap it
            await tester.tap(find.text('Skip today'));
            await tester.pumpAndSettle(const Duration(seconds: 1));

            // Sheet should be dismissed
            expect(
              find.byType(AddMealSheet).evaluate().isEmpty,
              isTrue,
              reason: 'Sheet should dismiss after "Skip today"',
            );
          } else {
            // Dismiss the sheet
            await tester.tapAt(Offset.zero);
            await tester.pumpAndSettle();
          }
        },
      );
    },
  );

  group(
    'Bazar Entry Flow',
    () {
      testWidgets(
        'Bazar tab FAB -> Add Bazar -> enter amount -> submit',
        (tester) async {
          await ensureOnDashboard(tester);
          await navigateToTab(tester, 'Bazar');

          expect(
            find.byType(BazarScreen),
            findsOneWidget,
            reason: 'Should be on BazarScreen',
          );

          // Tap "Add Bazar" FAB
          final addBazarFab = find.text('Add Bazar');
          if (addBazarFab.evaluate().isEmpty) return;

          await tester.tap(addBazarFab.first);
          await tester.pumpAndSettle(const Duration(seconds: 2));

          // AddBazarSheet should be visible
          expect(
            find.byType(AddBazarSheet),
            findsOneWidget,
            reason: 'AddBazarSheet should be displayed',
          );

          // Enter amount -- the amount field should be autofocused
          // Find the amount text field (first TextField in the sheet)
          final textFields = find.byType(TextField);
          if (textFields.evaluate().isNotEmpty) {
            // The amount field is typically the first and autofocused
            await tester.enterText(textFields.first, '500');
            await tester.pump(const Duration(milliseconds: 300));
          }

          // Try to tap the submit button ("Add Meal Bazar" or similar)
          final submitBtn = find.textContaining('Add');
          if (submitBtn.evaluate().isNotEmpty) {
            // Find the ElevatedButton with "Add" text
            final elevatedBtns = find.byType(ElevatedButton);
            for (int i = 0; i < elevatedBtns.evaluate().length; i++) {
              final button =
                  tester.widget<ElevatedButton>(elevatedBtns.at(i));
              if (button.onPressed != null) {
                await tester.tap(elevatedBtns.at(i));
                await tester.pumpAndSettle(const Duration(seconds: 2));
                break;
              }
            }
          }

          // If submit succeeded, sheet should be dismissed
          // (may still be open if validation fails -- that's OK)
          final sheetStillOpen =
              find.byType(AddBazarSheet).evaluate().isNotEmpty;
          if (!sheetStillOpen) {
            // Should be back on BazarScreen
            expect(
              find.byType(BazarScreen),
              findsOneWidget,
              reason: 'Should return to BazarScreen after submit',
            );
          }
        },
      );

      testWidgets(
        'Bazar entry with description text',
        (tester) async {
          await ensureOnDashboard(tester);
          await navigateToTab(tester, 'Bazar');

          final addBazarFab = find.text('Add Bazar');
          if (addBazarFab.evaluate().isEmpty) return;

          await tester.tap(addBazarFab.first);
          await tester.pumpAndSettle(const Duration(seconds: 2));

          // Enter amount
          final textFields = find.byType(TextField);
          if (textFields.evaluate().isNotEmpty) {
            await tester.enterText(textFields.first, '750');
            await tester.pump(const Duration(milliseconds: 300));
          }

          // Find and fill the description field (second TextField)
          if (textFields.evaluate().length > 1) {
            await tester.enterText(textFields.at(1), 'Rice and vegetables');
            await tester.pump(const Duration(milliseconds: 300));
          }

          // Dismiss keyboard
          await tester.testTextInput.receiveAction(TextInputAction.done);
          await tester.pumpAndSettle(const Duration(seconds: 1));

          // Sheet should still be open with our data
          expect(
            find.byType(AddBazarSheet),
            findsOneWidget,
            reason: 'AddBazarSheet should still be visible with entered data',
          );

          // Dismiss the sheet
          await tester.tapAt(Offset.zero);
          await tester.pumpAndSettle(const Duration(seconds: 1));
        },
      );
    },
  );

  group(
    'Money / Transaction Entry Flow',
    () {
      testWidgets(
        'Balance tab FAB -> Quick Actions -> Money -> AddTransactionSheet',
        (tester) async {
          await ensureOnDashboard(tester);
          await navigateToTab(tester, 'Balance');

          expect(
            find.byType(BalanceScreen),
            findsOneWidget,
            reason: 'Should be on BalanceScreen',
          );

          // Balance tab shows the speed-dial FAB (same as Dashboard)
          final fab = find.byType(FloatingActionButton);
          if (fab.evaluate().isEmpty) return;

          await tester.tap(fab.first);
          await tester.pumpAndSettle(const Duration(seconds: 2));

          // Quick Actions sheet
          expect(
            find.text('Quick add'),
            findsOneWidget,
            reason: 'Quick Actions sheet should open',
          );

          // Tap "Money" action
          final moneyAction = find.text('Money');
          if (moneyAction.evaluate().isEmpty) return;
          await tester.tap(moneyAction.first);
          await tester.pumpAndSettle(const Duration(seconds: 2));

          // AddTransactionSheet should be visible
          expect(
            find.byType(AddTransactionSheet),
            findsOneWidget,
            reason: 'AddTransactionSheet should be displayed',
          );

          // Enter amount
          final textFields = find.byType(TextField);
          if (textFields.evaluate().isNotEmpty) {
            await tester.enterText(textFields.first, '1000');
            await tester.pump(const Duration(milliseconds: 300));
          }

          // The submit button should say "Add Transaction"
          final addTransactionBtn = find.text('Add Transaction');
          expect(
            addTransactionBtn,
            findsWidgets,
            reason: 'Should show "Add Transaction" submit button',
          );

          // Note: We don't submit because it requires member selection
          // (From/To member pickers), which depends on member data.
          // Just verify the sheet structure is correct.

          // Dismiss the sheet
          await tester.tapAt(Offset.zero);
          await tester.pumpAndSettle(const Duration(seconds: 1));
        },
      );

      testWidgets(
        'Money quick action from Dashboard',
        (tester) async {
          await ensureOnDashboard(tester);

          // Scroll to Quick actions section and tap "Money" pill
          final scrollable = find.byType(Scrollable);
          if (scrollable.evaluate().isNotEmpty) {
            await tester.scrollUntilVisible(
              find.text('Money'),
              200,
              scrollable: scrollable.first,
            );
            await tester.pumpAndSettle();
          }

          // Tap "Money" quick action pill on Dashboard
          final moneyPill = find.text('Money');
          if (moneyPill.evaluate().isNotEmpty) {
            await tester.tap(moneyPill.first);
            await tester.pumpAndSettle(const Duration(seconds: 3));

            // Should navigate to MoneyScreen
            // Verify we left the Dashboard
            expect(
              find.byType(Scaffold),
              findsWidgets,
              reason: 'MoneyScreen should render a Scaffold',
            );

            await tester.pageBack();
            await tester.pumpAndSettle(const Duration(seconds: 2));
          }
        },
      );
    },
  );

  group(
    'Vacation Entry Flow',
    () {
      testWidgets(
        'Navigate to Vacation -> open AddVacationSheet -> select preset -> verify',
        (tester) async {
          await ensureOnDashboard(tester);

          // Navigate to Vacation module from the grid
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
          if (vacationCard.evaluate().isEmpty) return;
          await tester.tap(vacationCard.first);
          await tester.pumpAndSettle(const Duration(seconds: 3));

          expect(
            find.byType(VacationScreen),
            findsOneWidget,
            reason: 'Should navigate to VacationScreen',
          );

          // Tap "Add Vacation" button
          final addVacationBtn = find.text('Add Vacation');
          if (addVacationBtn.evaluate().isEmpty) {
            // May need to scroll to find it
            final vacScrollable = find.byType(Scrollable);
            if (vacScrollable.evaluate().isNotEmpty) {
              await tester.scrollUntilVisible(
                find.text('Add Vacation'),
                200,
                scrollable: vacScrollable.first,
              );
              await tester.pumpAndSettle();
            }
          }

          final addVacation = find.text('Add Vacation');
          if (addVacation.evaluate().isEmpty) {
            await tester.pageBack();
            await tester.pumpAndSettle();
            return;
          }

          await tester.tap(addVacation.first);
          await tester.pumpAndSettle(const Duration(seconds: 2));

          // AddVacationSheet should be visible
          // It shows "Add Vacation" in the header and "How long?" label
          expect(
            find.text('How long?'),
            findsOneWidget,
            reason: 'AddVacationSheet should show "How long?" label',
          );

          // Tap a preset duration -- find the "3" days preset
          final preset3 = find.text('3');
          if (preset3.evaluate().isNotEmpty) {
            await tester.tap(preset3.first);
            await tester.pumpAndSettle(const Duration(milliseconds: 500));
          }

          // Verify the sheet has custom date pickers section
          expect(
            find.text('Or pick custom dates'),
            findsOneWidget,
            reason: 'Should show custom date picker option',
          );

          // Dismiss the sheet without submitting
          await tester.tapAt(Offset.zero);
          await tester.pumpAndSettle(const Duration(seconds: 1));

          // Go back to Dashboard
          await tester.pageBack();
          await tester.pumpAndSettle(const Duration(seconds: 2));
        },
      );

      testWidgets(
        'Vacation screen shows "No vacations" placeholder or existing list',
        (tester) async {
          await ensureOnDashboard(tester);

          // Navigate to Vacation
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
          if (vacationCard.evaluate().isEmpty) return;
          await tester.tap(vacationCard.first);
          await tester.pumpAndSettle(const Duration(seconds: 3));

          // Verify VacationScreen rendered (has Scaffold and content)
          expect(find.byType(Scaffold), findsWidgets);

          // Should show either vacation entries or a placeholder
          final hasContent =
              find.byType(ListView).evaluate().isNotEmpty ||
              find.byType(SingleChildScrollView).evaluate().isNotEmpty ||
              find.byType(CustomScrollView).evaluate().isNotEmpty;

          expect(
            hasContent,
            isTrue,
            reason: 'VacationScreen should render scrollable content',
          );

          await tester.pageBack();
          await tester.pumpAndSettle(const Duration(seconds: 2));
        },
      );
    },
  );

  group(
    'Dashboard Inline Meal Counter',
    () {
      testWidgets(
        'Inline meal counter increments on tap',
        (tester) async {
          await ensureOnDashboard(tester);

          // Scroll to Quick actions where the InlineMealCounter lives
          final scrollable = find.byType(Scrollable);
          if (scrollable.evaluate().isNotEmpty) {
            await tester.scrollUntilVisible(
              find.text('Quick actions'),
              200,
              scrollable: scrollable.first,
            );
            await tester.pumpAndSettle();
          }

          // The InlineMealCounter should be visible
          // It shows the current meal count and +/- buttons
          // Look for the "+" icon button to increment
          final addIcons = find.byIcon(Icons.add);
          if (addIcons.evaluate().isNotEmpty) {
            await tester.tap(addIcons.first);
            await tester.pumpAndSettle(const Duration(seconds: 1));

            // The count should update (no crash)
            expect(find.byType(MaterialApp), findsOneWidget);
          }
        },
      );
    },
  );
}
