import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:mess_manager/core/theme/app_theme.dart';
import 'package:mess_manager/core/router/app_router.dart';
import 'package:mess_manager/core/services/haptic_service.dart';

/// Main Shell with Modern Navigation Bar + Haptic Feedback
class MainShell extends StatelessWidget {
  final Widget child;

  const MainShell({super.key, required this.child});

  int _calculateSelectedIndex(BuildContext context) {
    final String location = GoRouterState.of(context).uri.path;
    if (location.startsWith(AppRoutes.bazar)) return 1;
    if (location.startsWith(AppRoutes.meals)) return 2;
    if (location.startsWith(AppRoutes.balance)) return 3;
    if (location.startsWith(AppRoutes.settings)) return 4;
    return 0; // Dashboard
  }

  void _onItemTapped(BuildContext context, int index) {
    // Premium haptic feedback on navigation
    HapticService.navigation();

    switch (index) {
      case 0:
        context.go(AppRoutes.dashboard);
        break;
      case 1:
        context.go(AppRoutes.bazar);
        break;
      case 2:
        context.go(AppRoutes.meals);
        break;
      case 3:
        context.go(AppRoutes.balance);
        break;
      case 4:
        context.go(AppRoutes.settings);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child
          .animate()
          .fadeIn(duration: 200.ms, curve: Curves.easeOut)
          .slideY(begin: 0.02, end: 0, duration: 200.ms, curve: Curves.easeOut),
      bottomNavigationBar:
          Container(
                decoration: BoxDecoration(
                  color: AppColors.surfaceDark,
                  border: Border(
                    top: BorderSide(
                      color: AppColors.borderDark.withValues(alpha: 0.3),
                      width: 1,
                    ),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.2),
                      blurRadius: 20,
                      offset: const Offset(0, -5),
                    ),
                  ],
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.sm,
                      vertical: AppSpacing.xs,
                    ),
                    child: NavigationBar(
                      selectedIndex: _calculateSelectedIndex(context),
                      onDestinationSelected: (index) =>
                          _onItemTapped(context, index),
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                      height: 68,
                      labelBehavior:
                          NavigationDestinationLabelBehavior.alwaysShow,
                      animationDuration: const Duration(milliseconds: 400),
                      destinations: const [
                        NavigationDestination(
                          icon: Icon(LucideIcons.home, size: 22),
                          selectedIcon: Icon(LucideIcons.home, size: 22),
                          label: 'Home',
                        ),
                        NavigationDestination(
                          icon: Icon(LucideIcons.shoppingCart, size: 22),
                          selectedIcon: Icon(
                            LucideIcons.shoppingCart,
                            size: 22,
                          ),
                          label: 'Bazar',
                        ),
                        NavigationDestination(
                          icon: Icon(LucideIcons.utensils, size: 22),
                          selectedIcon: Icon(LucideIcons.utensils, size: 22),
                          label: 'Meals',
                        ),
                        NavigationDestination(
                          icon: Icon(LucideIcons.wallet, size: 22),
                          selectedIcon: Icon(LucideIcons.wallet, size: 22),
                          label: 'Balance',
                        ),
                        NavigationDestination(
                          icon: Icon(LucideIcons.settings, size: 22),
                          selectedIcon: Icon(LucideIcons.settings, size: 22),
                          label: 'Settings',
                        ),
                      ],
                    ),
                  ),
                ),
              )
              .animate()
              .fadeIn(delay: 100.ms, duration: 300.ms)
              .slideY(begin: 0.1, end: 0),
    );
  }
}
