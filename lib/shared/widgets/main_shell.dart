import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:mess_manager/core/theme/app_theme.dart';
import 'package:mess_manager/core/router/app_router.dart';
import 'package:mess_manager/core/services/haptic_service.dart';
import 'package:mess_manager/core/widgets/speed_dial_fab.dart';
import 'package:mess_manager/core/providers/role_provider.dart';
import 'package:mess_manager/features/meals/widgets/add_meal_sheet.dart';
import 'package:mess_manager/features/bazar/widgets/add_bazar_sheet.dart';
import 'package:mess_manager/features/money/widgets/add_transaction_sheet.dart';

/// Main Shell with Floating Glass Navigation Bar
class MainShell extends ConsumerWidget {
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

  static const _items = <_NavItemData>[
    _NavItemData(icon: LucideIcons.home, label: 'Home'),
    _NavItemData(icon: LucideIcons.shoppingCart, label: 'Bazar'),
    _NavItemData(icon: LucideIcons.utensils, label: 'Meals'),
    _NavItemData(icon: LucideIcons.wallet, label: 'Balance'),
    _NavItemData(icon: LucideIcons.settings, label: 'Settings'),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selected = _calculateSelectedIndex(context);

    return Scaffold(
      extendBody: true,
      body: child
          .animate()
          .fadeIn(duration: 200.ms, curve: Curves.easeOut)
          .slideY(begin: 0.02, end: 0, duration: 200.ms, curve: Curves.easeOut),
      floatingActionButton: _buildFAB(context, ref, selected),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
              child: Container(
                height: 64,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
                  color: Colors.white.withValues(alpha: 0.06),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.08),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF0A0F14).withValues(alpha: 0.5),
                      blurRadius: 20,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(_items.length, (i) {
                    return _NavItem(
                      icon: _items[i].icon,
                      label: _items[i].label,
                      isSelected: selected == i,
                      onTap: () => _onItemTapped(context, i),
                    );
                  }),
                ),
              ),
            ),
          )
              .animate()
              .fadeIn(delay: 100.ms, duration: 300.ms)
              .slideY(begin: 0.1, end: 0),
        ),
      ),
    );
  }

  // ──────────────────── FAB Logic ────────────────────

  Widget? _buildFAB(BuildContext context, WidgetRef ref, int tabIndex) {
    final canMeal = ref.watch(canAddMealProvider);
    final canBazar = ref.watch(canAddBazarProvider);
    final canTransaction = ref.watch(canAddTransactionProvider);

    switch (tabIndex) {
      // Dashboard: full speed dial
      case 0:
        return _buildSpeedDial(
          context,
          canMeal: canMeal,
          canBazar: canBazar,
          canTransaction: canTransaction,
        );

      // Bazar tab: single FAB → open AddBazarSheet
      case 1:
        if (!canBazar) return null;
        return _buildSingleFAB(
          context,
          label: 'Add Bazar',
          icon: LucideIcons.shoppingCart,
          color: AppColors.bazarColor,
          onPressed: () => _showAddBazarSheet(context),
        );

      // Meals tab: single FAB → open AddMealSheet
      case 2:
        if (!canMeal) return null;
        return _buildSingleFAB(
          context,
          label: 'Add Meal',
          icon: LucideIcons.utensils,
          color: AppColors.mealColor,
          onPressed: () => _showAddMealSheet(context),
        );

      // Balance tab: full speed dial
      case 3:
        return _buildSpeedDial(
          context,
          canMeal: canMeal,
          canBazar: canBazar,
          canTransaction: canTransaction,
        );

      // Settings tab: no FAB
      default:
        return null;
    }
  }

  Widget? _buildSpeedDial(
    BuildContext context, {
    required bool canMeal,
    required bool canBazar,
    required bool canTransaction,
  }) {
    final items = <SpeedDialItem>[
      SpeedDialItem(
        label: 'Add Duty',
        icon: LucideIcons.clipboardList,
        color: AppColors.success,
        onPressed: () => context.push(AppRoutes.duties),
      ),
      if (canTransaction)
        SpeedDialItem(
          label: 'Add Money',
          icon: LucideIcons.banknote,
          color: AppColors.warning,
          onPressed: () => _showAddMoneySheet(context),
        ),
      if (canBazar)
        SpeedDialItem(
          label: 'Add Bazar',
          icon: LucideIcons.shoppingCart,
          color: AppColors.bazarColor,
          onPressed: () => _showAddBazarSheet(context),
        ),
      if (canMeal)
        SpeedDialItem(
          label: 'Add Meal',
          icon: LucideIcons.utensils,
          color: AppColors.mealColor,
          onPressed: () => _showAddMealSheet(context),
        ),
    ];

    if (items.length <= 1) return null;
    return SpeedDialFAB(items: items);
  }

  Widget _buildSingleFAB(
    BuildContext context, {
    required String label,
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [color, color.withValues(alpha: 0.8)],
        ),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.4),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: FloatingActionButton.extended(
        heroTag: 'shell_fab_$label',
        onPressed: () {
          HapticService.buttonPress();
          onPressed();
        },
        backgroundColor: Colors.transparent,
        elevation: 0,
        highlightElevation: 0,
        icon: Icon(icon, size: 20),
        label: Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            letterSpacing: 0.3,
          ),
        ),
      ),
    );
  }

  // ──────────────────── Sheets ────────────────────

  void _showAddMealSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const AddMealSheet(),
    );
  }

  void _showAddBazarSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const AddBazarSheet(),
    );
  }

  void _showAddMoneySheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const AddTransactionSheet(),
    );
  }
}

class _NavItemData {
  final IconData icon;
  final String label;
  const _NavItemData({required this.icon, required this.label});
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedScale(
        scale: isSelected ? 1.1 : 1.0,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOutCubic,
        child: SizedBox(
          width: 56,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: isSelected
                      ? AppColors.primary.withValues(alpha: 0.15)
                      : Colors.transparent,
                ),
                child: Icon(
                  icon,
                  size: 20,
                  color: isSelected
                      ? AppColors.primary
                      : Colors.white.withValues(alpha: 0.35),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                label,
                style: AppTypography.labelSmall.copyWith(
                  fontSize: 9,
                  color: isSelected
                      ? AppColors.primary
                      : Colors.white.withValues(alpha: 0.3),
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
