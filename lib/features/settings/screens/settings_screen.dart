import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:gap/gap.dart';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:animated_theme_switcher/animated_theme_switcher.dart';

import 'package:mess_manager/core/theme/app_theme.dart';
import 'package:mess_manager/core/router/app_router.dart';
import 'package:mess_manager/core/services/haptic_service.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkMode = AdaptiveTheme.of(context).mode.isDark;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Icon(
              LucideIcons.settings,
              color: AppColors.textSecondaryDark,
              size: 22,
            ),
            const Gap(AppSpacing.sm),
            const Text('Settings'),
          ],
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          // Modules Section
          _buildSectionHeader('Modules', 0),
          _buildSettingsTile(
            icon: LucideIcons.barChart3,
            title: 'Analytics',
            subtitle: 'Charts & insights',
            onTap: () => context.go(AppRoutes.analytics),
            index: 1,
          ),
          _buildSettingsTile(
            icon: LucideIcons.users,
            title: 'Members',
            subtitle: 'Manage mess members',
            onTap: () => context.go(AppRoutes.members),
            index: 2,
          ),
          _buildSettingsTile(
            icon: LucideIcons.arrowLeftRight,
            title: 'Money Give/Take',
            subtitle: 'Track personal transactions',
            onTap: () => context.go(AppRoutes.money),
            index: 3,
          ),
          _buildSettingsTile(
            icon: LucideIcons.calendarX,
            title: 'Cancel Meals',
            subtitle: 'Bulk meal cancellation',
            onTap: () => context.go(AppRoutes.vacation),
            index: 4,
          ),
          _buildSettingsTile(
            icon: LucideIcons.zap,
            title: 'DESCO Meter',
            subtitle: 'Electricity balance',
            onTap: () => context.go(AppRoutes.desco),
            index: 5,
          ),
          _buildSettingsTile(
            icon: LucideIcons.moon,
            title: 'Ramadan',
            subtitle: 'Sehri/Iftar tracking',
            onTap: () => context.go(AppRoutes.ramadan),
            index: 6,
          ),
          _buildSettingsTile(
            icon: LucideIcons.receipt,
            title: 'Settlement',
            subtitle: 'Monthly balance & payments',
            onTap: () => context.go(AppRoutes.settlement),
            index: 7,
          ),
          _buildSettingsTile(
            icon: LucideIcons.clipboardList,
            title: 'Duties',
            subtitle: 'Rotation & assignments',
            onTap: () => context.go(AppRoutes.duties),
            index: 8,
          ),
          _buildSettingsTile(
            icon: LucideIcons.info,
            title: 'Important Info',
            subtitle: 'Contacts, WiFi, rules',
            onTap: () => context.go(AppRoutes.info),
            index: 9,
          ),
          const Gap(AppSpacing.lg),

          // Appearance Section
          _buildSectionHeader('Appearance', 10),
          _buildAnimatedThemeTile(context, isDarkMode, 11),
          _buildSettingsTile(
            icon: LucideIcons.bell,
            title: 'Notifications',
            subtitle: 'Configure meal reminders',
            onTap: () => context.go(AppRoutes.notificationSettings),
            index: 12,
          ),
          const Gap(AppSpacing.lg),

          // Account Section
          _buildSectionHeader('Account', 13),
          _buildSettingsTile(
            icon: LucideIcons.user,
            title: 'Profile',
            subtitle: 'Manage your account',
            onTap: () => context.push(AppRoutes.profile),
            index: 14,
          ),
          _buildSettingsTile(
            icon: LucideIcons.logOut,
            title: 'Sign Out',
            subtitle: 'Log out of your account',
            onTap: () => _showSignOutDialog(context),
            index: 15,
            isDestructive: true,
          ),
          const Gap(AppSpacing.lg),

          // Data Section
          _buildSectionHeader('Data', 16),
          _buildSettingsTile(
            icon: LucideIcons.cloudLightning,
            title: 'Backup & Sync',
            subtitle: 'Firebase sync enabled',
            onTap: () {},
            index: 17,
          ),
          _buildSettingsTile(
            icon: LucideIcons.download,
            title: 'Export Data',
            subtitle: 'Download as PDF/Excel',
            onTap: () {},
            index: 18,
          ),
          const Gap(AppSpacing.lg),

          // About Section
          _buildSectionHeader('About', 19),
          _buildSettingsTile(
            icon: LucideIcons.info,
            title: 'About Mess Manager',
            subtitle: 'Version 1.0.0',
            onTap: () {},
            index: 20,
          ),
          _buildSettingsTile(
            icon: LucideIcons.helpCircle,
            title: 'Help & Support',
            subtitle: 'Get assistance',
            onTap: () {},
            index: 21,
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, int index) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: AppSpacing.sm,
        left: AppSpacing.xs,
      ),
      child: Text(
        title.toUpperCase(),
        style: AppTypography.labelSmall.copyWith(
          color: AppColors.textMutedDark,
          letterSpacing: 1.2,
        ),
      ),
    ).animate(delay: (30 * index).ms).fadeIn();
  }

  Widget _buildSettingsTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required int index,
    Widget? trailing,
    VoidCallback? onTap,
    bool isDestructive = false,
  }) {
    final color = isDestructive ? AppColors.error : AppColors.primary;

    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      decoration: BoxDecoration(
        color: AppColors.cardDark,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        border: Border.all(color: AppColors.borderDark.withValues(alpha: 0.5)),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.xs,
        ),
        leading: Container(
          padding: const EdgeInsets.all(AppSpacing.sm + 2),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
          ),
          child: Icon(icon, color: color, size: 18),
        ),
        title: Text(
          title,
          style: AppTypography.titleSmall.copyWith(
            color: isDestructive ? AppColors.error : AppColors.textPrimaryDark,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: AppTypography.bodySmall.copyWith(
            color: AppColors.textSecondaryDark,
          ),
        ),
        trailing:
            trailing ??
            const Icon(
              LucideIcons.chevronRight,
              color: AppColors.textMutedDark,
              size: 20,
            ),
        onTap: () {
          HapticService.lightTap();
          onTap?.call();
        },
      ),
    ).animate(delay: (30 * index).ms).fadeIn().slideX(begin: 0.02);
  }

  /// Animated theme tile with expanding circle transition
  Widget _buildAnimatedThemeTile(
    BuildContext context,
    bool isDarkMode,
    int index,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      decoration: BoxDecoration(
        color: AppColors.cardDark,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        border: Border.all(color: AppColors.borderDark.withValues(alpha: 0.5)),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.xs,
        ),
        leading: Container(
          padding: const EdgeInsets.all(AppSpacing.sm + 2),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
          ),
          child: Icon(
            isDarkMode ? LucideIcons.moon : LucideIcons.sun,
            color: AppColors.primary,
            size: 18,
          ),
        ),
        title: Text(
          'Dark Mode',
          style: AppTypography.titleSmall.copyWith(
            color: AppColors.textPrimaryDark,
          ),
        ),
        subtitle: Text(
          isDarkMode ? 'Enabled' : 'Disabled',
          style: AppTypography.bodySmall.copyWith(
            color: AppColors.textSecondaryDark,
          ),
        ),
        trailing: ThemeSwitcher(
          clipper: const ThemeSwitcherCircleClipper(),
          builder: (ctx) {
            return Switch.adaptive(
              value: isDarkMode,
              onChanged: (_) {
                HapticService.toggle();
                // Use both animated_theme_switcher and adaptive_theme
                final themeSwitcher = ThemeSwitcher.of(ctx);
                final adaptiveTheme = AdaptiveTheme.of(context);

                // Get the new theme
                final newTheme = isDarkMode
                    ? adaptiveTheme.lightTheme
                    : adaptiveTheme.darkTheme;

                // Animate the transition
                themeSwitcher.changeTheme(theme: newTheme);

                // Also update AdaptiveTheme for persistence
                adaptiveTheme.toggleThemeMode();
              },
              activeTrackColor: AppColors.primary.withValues(alpha: 0.5),
              activeThumbColor: AppColors.primary,
            );
          },
        ),
        onTap: () {
          HapticService.toggle();
          AdaptiveTheme.of(context).toggleThemeMode();
        },
      ),
    ).animate(delay: (30 * index).ms).fadeIn().slideX(begin: 0.02);
  }

  void _showSignOutDialog(BuildContext context) {
    HapticService.mediumTap();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surfaceDark,
        title: const Text('Sign Out'),
        content: const Text('Are you sure you want to sign out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              HapticService.success();
              Navigator.pop(context);
              context.go(AppRoutes.login);
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            child: const Text('Sign Out'),
          ),
        ],
      ),
    );
  }
}
