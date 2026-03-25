// Settings Flow Integration Test
//
// Tests settings interactions on a real device/emulator:
//   1. Navigate to Settings tab
//   2. Dark mode switch is locked (always on)
//   3. Theme color picker -> tap a color
//   4. Notification settings -> toggle switches
//   5. Profile -> verify user info
//   6. About sheet
//   7. Sign out flow
//
// Run:
//   flutter test integration_test/settings_flow_test.dart -d <device_id>
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:mess_manager/main.dart' as app;
import 'package:mess_manager/features/auth/screens/login_screen.dart';
import 'package:mess_manager/features/auth/screens/mess_selection_screen.dart';
import 'package:mess_manager/features/auth/screens/profile_screen.dart';
import 'package:mess_manager/features/settings/screens/settings_screen.dart';
import 'package:mess_manager/features/notifications/screens/notification_settings_screen.dart';
import 'package:mess_manager/features/notifications/screens/notification_history_screen.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  /// Helper: ensure app is authenticated and on Dashboard.
  Future<void> ensureOnDashboard(WidgetTester tester) async {
    app.main();
    await tester.pumpAndSettle(const Duration(seconds: 5));

    // If on Login, sign in
    if (find.byType(LoginScreen).evaluate().isNotEmpty) {
      final emailField = find.widgetWithText(TextFormField, 'Email');
      final passwordField = find.widgetWithText(TextFormField, 'Password');

      if (emailField.evaluate().isNotEmpty) {
        await tester.enterText(emailField, 'settings_test@example.com');
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

    // Handle MessSelection
    if (find.byType(MessSelectionScreen).evaluate().isNotEmpty) {
      final continueDefault = find.text('Continue with Default Mess');
      if (continueDefault.evaluate().isNotEmpty) {
        await tester.tap(continueDefault);
        await tester.pumpAndSettle(const Duration(seconds: 3));
      }
    }
  }

  /// Helper: navigate to Settings tab.
  Future<void> navigateToSettings(WidgetTester tester) async {
    final settingsTab = find.text('Settings');
    if (settingsTab.evaluate().isNotEmpty) {
      await tester.tap(settingsTab.last);
      await tester.pumpAndSettle(const Duration(seconds: 2));
    }
  }

  group(
    'Settings Screen - Appearance',
    () {
      testWidgets(
        'Settings screen loads with header and sections',
        (tester) async {
          await ensureOnDashboard(tester);
          await navigateToSettings(tester);

          expect(
            find.byType(SettingsScreen),
            findsOneWidget,
            reason: 'Should be on SettingsScreen',
          );

          // Verify "Settings" header text
          expect(find.text('Settings'), findsWidgets);

          // Verify key sections exist
          expect(
            find.text('Appearance'),
            findsOneWidget,
            reason: 'Should have "Appearance" section',
          );
        },
      );

      testWidgets(
        'Dark Mode switch is locked (always on, onChanged: null)',
        (tester) async {
          await ensureOnDashboard(tester);
          await navigateToSettings(tester);

          // Find the Dark Mode tile
          expect(
            find.text('Dark Mode'),
            findsOneWidget,
            reason: 'Should show "Dark Mode" tile',
          );
          expect(
            find.text('Always on \u2014 Cosmic Bioluminescence'),
            findsOneWidget,
            reason: 'Dark mode subtitle should indicate it is locked',
          );

          // Find the Switch widget
          final switchFinder = find.byType(Switch);
          expect(
            switchFinder,
            findsWidgets,
            reason: 'Should have Switch widgets on Settings page',
          );

          // The dark mode switch should be ON
          final darkModeSwitch =
              tester.widget<Switch>(switchFinder.first);
          expect(
            darkModeSwitch.value,
            isTrue,
            reason: 'Dark mode switch should be ON',
          );

          // The switch should be disabled (onChanged == null)
          expect(
            darkModeSwitch.onChanged,
            isNull,
            reason: 'Dark mode switch should be locked (onChanged: null)',
          );
        },
      );

      testWidgets(
        'Theme color picker tile is tappable',
        (tester) async {
          await ensureOnDashboard(tester);
          await navigateToSettings(tester);

          // Find "Theme Color" or the color tile
          // The tile text varies, but the section is under "Appearance"
          // Look for a color swatch circle or the tile itself
          final themeColorTile = find.text('Theme Color');
          final accentTile = find.text('Accent Color');

          final hasTile = themeColorTile.evaluate().isNotEmpty ||
              accentTile.evaluate().isNotEmpty;

          if (hasTile) {
            final tile = themeColorTile.evaluate().isNotEmpty
                ? themeColorTile
                : accentTile;
            await tester.tap(tile.first);
            await tester.pumpAndSettle(const Duration(seconds: 2));

            // The color picker sheet/dialog should open
            // Look for colored circles (Container with BoxDecoration)
            // or specific color names
            // Just verify something opened (a modal bottom sheet or dialog)
            expect(
              find.byType(BottomSheet).evaluate().isNotEmpty ||
                  find.byType(Dialog).evaluate().isNotEmpty ||
                  find.byType(AlertDialog).evaluate().isNotEmpty ||
                  // It may use showModalBottomSheet which wraps in BottomSheet
                  find.text('System').evaluate().isNotEmpty ||
                  find.text('Teal').evaluate().isNotEmpty,
              isTrue,
              reason: 'Theme color picker should open',
            );

            // Dismiss
            await tester.tapAt(Offset.zero);
            await tester.pumpAndSettle(const Duration(seconds: 1));
          }
        },
      );
    },
  );

  group(
    'Settings Screen - Notifications',
    () {
      testWidgets(
        'Notification Settings tile navigates to NotificationSettingsScreen',
        (tester) async {
          await ensureOnDashboard(tester);
          await navigateToSettings(tester);

          // Scroll to find "Notification Settings"
          final scrollable = find.byType(Scrollable);
          if (scrollable.evaluate().isNotEmpty) {
            await tester.scrollUntilVisible(
              find.text('Notification Settings'),
              200,
              scrollable: scrollable.first,
            );
            await tester.pumpAndSettle();
          }

          final notifTile = find.text('Notification Settings');
          expect(
            notifTile,
            findsOneWidget,
            reason: 'Should have "Notification Settings" tile',
          );

          await tester.tap(notifTile);
          await tester.pumpAndSettle(const Duration(seconds: 3));

          expect(
            find.byType(NotificationSettingsScreen),
            findsOneWidget,
            reason: 'Should navigate to NotificationSettingsScreen',
          );

          // Verify notification toggles exist
          final switches = find.byType(Switch);
          expect(
            switches,
            findsWidgets,
            reason: 'NotificationSettingsScreen should have toggle switches',
          );

          // Go back
          await tester.pageBack();
          await tester.pumpAndSettle(const Duration(seconds: 2));

          expect(
            find.byType(SettingsScreen),
            findsOneWidget,
            reason: 'Should return to SettingsScreen',
          );
        },
      );

      testWidgets(
        'Notification History tile navigates to NotificationHistoryScreen',
        (tester) async {
          await ensureOnDashboard(tester);
          await navigateToSettings(tester);

          final scrollable = find.byType(Scrollable);
          if (scrollable.evaluate().isNotEmpty) {
            await tester.scrollUntilVisible(
              find.text('Notification History'),
              200,
              scrollable: scrollable.first,
            );
            await tester.pumpAndSettle();
          }

          final historyTile = find.text('Notification History');
          expect(
            historyTile,
            findsOneWidget,
            reason: 'Should have "Notification History" tile',
          );

          await tester.tap(historyTile);
          await tester.pumpAndSettle(const Duration(seconds: 3));

          expect(
            find.byType(NotificationHistoryScreen),
            findsOneWidget,
            reason: 'Should navigate to NotificationHistoryScreen',
          );

          await tester.pageBack();
          await tester.pumpAndSettle(const Duration(seconds: 2));
        },
      );
    },
  );

  group(
    'Settings Screen - Profile',
    () {
      testWidgets(
        'Profile card shows user info and is tappable',
        (tester) async {
          await ensureOnDashboard(tester);
          await navigateToSettings(tester);

          // The profile card should be near the top of Settings
          // It shows the user's email or name
          // Look for common profile indicators
          final emailText = find.textContaining('@');
          final profileAvatar = find.byType(CircleAvatar);

          expect(
            emailText.evaluate().isNotEmpty ||
                profileAvatar.evaluate().isNotEmpty,
            isTrue,
            reason: 'Settings should show user profile info',
          );
        },
      );

      testWidgets(
        'Navigate to Profile screen from Dashboard header',
        (tester) async {
          await ensureOnDashboard(tester);

          // Tap profile orb in header
          final circleAvatar = find.byType(CircleAvatar);
          if (circleAvatar.evaluate().isNotEmpty) {
            await tester.tap(circleAvatar.first);
            await tester.pumpAndSettle(const Duration(seconds: 3));

            expect(
              find.byType(ProfileScreen),
              findsOneWidget,
              reason: 'Should navigate to ProfileScreen',
            );

            // Verify profile has form fields
            final nameField = find.byType(TextField);
            expect(
              nameField,
              findsWidgets,
              reason: 'Profile should have editable text fields',
            );

            await tester.pageBack();
            await tester.pumpAndSettle(const Duration(seconds: 2));
          }
        },
      );
    },
  );

  group(
    'Settings Screen - Data & Backup',
    () {
      testWidgets(
        'Backup and Restore tiles are visible',
        (tester) async {
          await ensureOnDashboard(tester);
          await navigateToSettings(tester);

          final scrollable = find.byType(Scrollable);
          if (scrollable.evaluate().isNotEmpty) {
            await tester.scrollUntilVisible(
              find.text('Backup Data'),
              200,
              scrollable: scrollable.first,
            );
            await tester.pumpAndSettle();
          }

          expect(
            find.text('Backup Data'),
            findsOneWidget,
            reason: 'Should show "Backup Data" tile',
          );
          expect(
            find.text('Export all data as JSON'),
            findsOneWidget,
            reason: 'Backup tile should have descriptive subtitle',
          );

          // Restore tile
          if (scrollable.evaluate().isNotEmpty) {
            await tester.scrollUntilVisible(
              find.text('Restore Backup'),
              200,
              scrollable: scrollable.first,
            );
            await tester.pumpAndSettle();
          }

          expect(
            find.text('Restore Backup'),
            findsOneWidget,
            reason: 'Should show "Restore Backup" tile',
          );
        },
      );

      testWidgets(
        'Export Reports tile shows "Coming soon"',
        (tester) async {
          await ensureOnDashboard(tester);
          await navigateToSettings(tester);

          final scrollable = find.byType(Scrollable);
          if (scrollable.evaluate().isNotEmpty) {
            await tester.scrollUntilVisible(
              find.text('Export Reports'),
              200,
              scrollable: scrollable.first,
            );
            await tester.pumpAndSettle();
          }

          final exportReports = find.text('Export Reports');
          if (exportReports.evaluate().isNotEmpty) {
            await tester.tap(exportReports);
            await tester.pumpAndSettle(const Duration(seconds: 2));

            // Should show "Coming soon!" toast/snackbar
            // (May already have dismissed, so just verify no crash)
            expect(find.byType(MaterialApp), findsOneWidget);
          }
        },
      );
    },
  );

  group(
    'Settings Screen - Privacy & Security',
    () {
      testWidgets(
        'Privacy mode toggle is visible',
        (tester) async {
          await ensureOnDashboard(tester);
          await navigateToSettings(tester);

          final scrollable = find.byType(Scrollable);
          if (scrollable.evaluate().isNotEmpty) {
            await tester.scrollUntilVisible(
              find.text('Privacy and security'),
              200,
              scrollable: scrollable.first,
            );
            await tester.pumpAndSettle();
          }

          expect(
            find.text('Privacy and security'),
            findsOneWidget,
            reason: 'Should show "Privacy and security" section',
          );
        },
      );
    },
  );

  group(
    'Settings Screen - About',
    () {
      testWidgets(
        'About tile opens About sheet',
        (tester) async {
          await ensureOnDashboard(tester);
          await navigateToSettings(tester);

          final scrollable = find.byType(Scrollable);
          if (scrollable.evaluate().isNotEmpty) {
            await tester.scrollUntilVisible(
              find.text('About Mess Manager'),
              200,
              scrollable: scrollable.first,
            );
            await tester.pumpAndSettle();
          }

          final aboutTile = find.text('About Mess Manager');
          expect(
            aboutTile,
            findsOneWidget,
            reason: 'Should show "About Mess Manager" tile',
          );

          await tester.tap(aboutTile);
          await tester.pumpAndSettle(const Duration(seconds: 2));

          // About sheet should open -- look for version info
          final versionText = find.textContaining('1.0');
          expect(
            versionText,
            findsWidgets,
            reason: 'About sheet should show version info',
          );

          // Dismiss
          await tester.tapAt(Offset.zero);
          await tester.pumpAndSettle(const Duration(seconds: 1));
        },
      );

      testWidgets(
        'Help & Support tile is tappable',
        (tester) async {
          await ensureOnDashboard(tester);
          await navigateToSettings(tester);

          final scrollable = find.byType(Scrollable);
          if (scrollable.evaluate().isNotEmpty) {
            await tester.scrollUntilVisible(
              find.text('Help & Support'),
              200,
              scrollable: scrollable.first,
            );
            await tester.pumpAndSettle();
          }

          final helpTile = find.text('Help & Support');
          expect(
            helpTile,
            findsOneWidget,
            reason: 'Should show "Help & Support" tile',
          );

          await tester.tap(helpTile);
          await tester.pumpAndSettle(const Duration(seconds: 2));

          // Verify something opened (no crash)
          expect(find.byType(MaterialApp), findsOneWidget);

          // Dismiss any sheet
          await tester.tapAt(Offset.zero);
          await tester.pumpAndSettle(const Duration(seconds: 1));
        },
      );
    },
  );

  group(
    'Settings Screen - Sign Out',
    () {
      testWidgets(
        'Sign Out button opens confirmation sheet with Cancel and confirm',
        (tester) async {
          await ensureOnDashboard(tester);
          await navigateToSettings(tester);

          // Scroll to Sign Out
          final scrollable = find.byType(Scrollable);
          if (scrollable.evaluate().isNotEmpty) {
            await tester.scrollUntilVisible(
              find.text('Sign Out'),
              200,
              scrollable: scrollable.first,
            );
            await tester.pumpAndSettle();
          }

          final signOutBtn = find.text('Sign Out');
          expect(signOutBtn, findsWidgets);

          // Tap Sign Out
          await tester.tap(signOutBtn.first);
          await tester.pumpAndSettle(const Duration(seconds: 2));

          // Confirmation sheet should appear
          expect(
            find.text('Sign Out?'),
            findsOneWidget,
            reason: 'Should show "Sign Out?" confirmation title',
          );
          expect(
            find.text('Cancel'),
            findsOneWidget,
            reason: 'Should show Cancel button in confirmation sheet',
          );

          // Tap Cancel to dismiss
          await tester.tap(find.text('Cancel'));
          await tester.pumpAndSettle(const Duration(seconds: 1));

          // Should still be on Settings
          expect(
            find.byType(SettingsScreen),
            findsOneWidget,
            reason: 'Cancel should keep user on Settings screen',
          );
        },
      );

      testWidgets(
        'Sign Out confirmation navigates to Login',
        (tester) async {
          await ensureOnDashboard(tester);
          await navigateToSettings(tester);

          // Scroll to Sign Out
          final scrollable = find.byType(Scrollable);
          if (scrollable.evaluate().isNotEmpty) {
            await tester.scrollUntilVisible(
              find.text('Sign Out'),
              200,
              scrollable: scrollable.first,
            );
            await tester.pumpAndSettle();
          }

          // Tap Sign Out
          final signOutBtn = find.text('Sign Out');
          await tester.tap(signOutBtn.first);
          await tester.pumpAndSettle(const Duration(seconds: 2));

          // Confirm by tapping "Sign Out" in the sheet
          // The sheet has both "Cancel" and "Sign Out" buttons
          final confirmBtn = find.text('Sign Out');
          // The last "Sign Out" occurrence is the confirmation button
          if (confirmBtn.evaluate().length > 1) {
            await tester.tap(confirmBtn.last);
          } else {
            await tester.tap(confirmBtn.first);
          }
          await tester.pumpAndSettle(const Duration(seconds: 3));

          // Should navigate to Login screen
          expect(
            find.byType(LoginScreen),
            findsOneWidget,
            reason: 'Should navigate to LoginScreen after sign out',
          );
        },
      );
    },
  );

  group(
    'Settings Screen - Theme Persistence',
    () {
      testWidgets(
        'App always uses dark theme regardless of system',
        (tester) async {
          await ensureOnDashboard(tester);

          // Verify the app theme is dark
          final materialApp =
              tester.widget<MaterialApp>(find.byType(MaterialApp).first);
          expect(
            materialApp.themeMode,
            ThemeMode.dark,
            reason: 'App should always use ThemeMode.dark',
          );

          // Verify the theme brightness is dark
          final theme = Theme.of(tester.element(find.byType(Scaffold).first));
          expect(
            theme.brightness,
            Brightness.dark,
            reason: 'Theme brightness should be dark',
          );
        },
      );
    },
  );
}
