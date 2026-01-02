import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:gap/gap.dart';
import 'package:mess_manager/core/theme/app_theme.dart';
import 'package:mess_manager/core/providers/theme_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final themeNotifier = ref.read(themeModeProvider.notifier);

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
          // Theme Section
          _buildSectionHeader('Appearance'),
          _buildSettingsTile(
            icon: LucideIcons.moon,
            title: 'Dark Mode',
            subtitle: themeMode == ThemeMode.dark ? 'Enabled' : 'Disabled',
            trailing: Switch.adaptive(
              value: themeMode == ThemeMode.dark,
              onChanged: (_) => themeNotifier.toggleTheme(),
              activeTrackColor: AppColors.primary.withValues(alpha: 0.5),
              thumbColor: WidgetStateProperty.resolveWith((states) {
                if (states.contains(WidgetState.selected)) {
                  return AppColors.primary;
                }
                return null;
              }),
            ),
          ),
          const Gap(AppSpacing.lg),

          // Account Section
          _buildSectionHeader('Account'),
          _buildSettingsTile(
            icon: LucideIcons.user,
            title: 'Profile',
            subtitle: 'Manage your account',
            onTap: () {},
          ),
          _buildSettingsTile(
            icon: LucideIcons.users,
            title: 'Mess Members',
            subtitle: '4 members',
            onTap: () {},
          ),
          _buildSettingsTile(
            icon: LucideIcons.bell,
            title: 'Notifications',
            subtitle: 'Configure alerts',
            onTap: () {},
          ),
          const Gap(AppSpacing.lg),

          // Data Section
          _buildSectionHeader('Data'),
          _buildSettingsTile(
            icon: LucideIcons.cloudLightning,
            title: 'Backup & Sync',
            subtitle: 'Last synced: Today',
            onTap: () {},
          ),
          _buildSettingsTile(
            icon: LucideIcons.download,
            title: 'Export Data',
            subtitle: 'Download as PDF/Excel',
            onTap: () {},
          ),
          const Gap(AppSpacing.lg),

          // About Section
          _buildSectionHeader('About'),
          _buildSettingsTile(
            icon: LucideIcons.info,
            title: 'About Area51',
            subtitle: 'Version 1.0.0',
            onTap: () {},
          ),
          _buildSettingsTile(
            icon: LucideIcons.helpCircle,
            title: 'Help & Support',
            subtitle: 'Get assistance',
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
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
    );
  }

  Widget _buildSettingsTile({
    required IconData icon,
    required String title,
    required String subtitle,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
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
          child: Icon(icon, color: AppColors.primary, size: 18),
        ),
        title: Text(
          title,
          style: AppTypography.titleSmall.copyWith(
            color: AppColors.textPrimaryDark,
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
        onTap: onTap,
      ),
    );
  }
}
