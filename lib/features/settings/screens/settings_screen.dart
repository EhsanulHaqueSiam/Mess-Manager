import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:gap/gap.dart';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:local_auth/local_auth.dart';

import 'package:mess_manager/core/theme/app_theme.dart';
import 'package:mess_manager/core/router/app_router.dart';
import 'package:mess_manager/core/services/haptic_service.dart';
import 'package:mess_manager/core/widgets/gf_components.dart';
import 'package:mess_manager/core/database/isar_service.dart';
import 'package:mess_manager/core/services/backup_service.dart';
import 'package:mess_manager/features/auth/providers/auth_provider.dart';
import 'package:mess_manager/core/providers/role_provider.dart';
import 'package:flutter/services.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  bool _privacyModeEnabled = false;
  bool _biometricLockEnabled = false;
  bool _biometricAvailable = false;

  @override
  void initState() {
    super.initState();
    _loadSettings();
    _checkBiometricAvailability();
  }

  void _loadSettings() {
    _privacyModeEnabled = IsarService.getSetting<bool>('privacy_mode') ?? false;
    _biometricLockEnabled =
        IsarService.getSetting<bool>('biometric_lock') ?? false;
  }

  Future<void> _checkBiometricAvailability() async {
    final auth = LocalAuthentication();
    final canCheck = await auth.canCheckBiometrics;
    final isSupported = await auth.isDeviceSupported();
    setState(() => _biometricAvailable = canCheck || isSupported);
  }

  @override
  Widget build(BuildContext context) {
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

          // Preferences
          _buildSectionHeader('Preferences', 16),
          _buildSettingsTile(
            icon: LucideIcons.bell,
            title: 'Notifications',
            subtitle: 'View history',
            onTap: () => context.push(AppRoutes.notifications),
            index: 17,
          ),
          const Gap(AppSpacing.lg),

          // Data Section
          _buildSectionHeader('Data', 18),
          // Mess Settings (Admin only)
          if (ref.watch(isAdminProvider))
            _buildSettingsTile(
              icon: LucideIcons.home,
              title: 'Mess Settings',
              subtitle: 'Edit name, address',
              onTap: () => _showEditMessSheet(context),
              index: 25,
            ),
          // Invite Code (Admin only)
          if (ref.watch(isAdminProvider)) _buildInviteCodeTile(26),
          _buildSettingsTile(
            icon: LucideIcons.save,
            title: 'Backup Full Data',
            subtitle: 'Export (JSON)',
            onTap: () async {
              HapticService.lightTap();
              await BackupService.createBackup();
              if (context.mounted)
                showSuccessToast(context, 'Backup ready to share');
            },
            index: 17,
          ),
          _buildSettingsTile(
            icon: LucideIcons.uploadCloud,
            title: 'Restore Backup',
            subtitle: 'Import (JSON)',
            onTap: () async {
              HapticService.lightTap();
              final success = await BackupService.restoreBackup();
              if (!context.mounted) return;
              if (success) {
                showSuccessToast(
                  context,
                  'Restore successful! Please restart app.',
                );
              } else {
                showErrorToast(context, 'Restore cancelled or failed');
              }
            },
            index: 18,
            isDestructive: true,
          ),
          _buildSettingsTile(
            icon: LucideIcons.download,
            title: 'Export Reports',
            subtitle: 'PDF/Excel Sheets',
            onTap: () {},
            index: 19,
          ),
          const Gap(AppSpacing.lg),

          // Privacy & Security Section
          _buildSectionHeader('Privacy & Security', 19),
          _buildPrivacyModeTile(context, 20),
          _buildBiometricLockTile(context, 21),
          const Gap(AppSpacing.lg),

          // About Section
          _buildSectionHeader('About', 22),
          _buildSettingsTile(
            icon: LucideIcons.info,
            title: 'About Mess Manager',
            subtitle: 'Version 1.0.0',
            onTap: () => _showAboutDialog(context),
            index: 23,
          ),
          _buildSettingsTile(
            icon: LucideIcons.helpCircle,
            title: 'Help & Support',
            subtitle: 'Get assistance',
            onTap: () => _showHelpDialog(context),
            index: 24,
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

  void _showAboutDialog(BuildContext context) {
    HapticService.lightTap();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surfaceDark,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.primary, AppColors.accentWarm],
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                LucideIcons.utensils,
                color: Colors.white,
                size: 20,
              ),
            ),
            const Gap(12),
            const Text('Mess Manager'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildAboutRow('Version', '1.0.0'),
            _buildAboutRow('Build', '2026.01.06'),
            const Gap(AppSpacing.md),
            const Divider(),
            const Gap(AppSpacing.md),
            Text(
              'Area51 Mess Manager helps you track meals, expenses, duties, and settlements for shared living spaces.',
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.textSecondaryDark,
              ),
            ),
            const Gap(AppSpacing.lg),
            Text(
              'Made with ❤️ by Siam',
              style: AppTypography.labelMedium.copyWith(
                color: AppColors.textMutedDark,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _buildAboutRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTypography.bodyMedium),
          Text(
            value,
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  void _showHelpDialog(BuildContext context) {
    HapticService.lightTap();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surfaceDark,
        title: Row(
          children: [
            const Icon(LucideIcons.helpCircle, color: AppColors.info),
            const Gap(12),
            const Text('Help & Support'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildHelpOption(
              icon: LucideIcons.bookOpen,
              title: 'User Guide',
              subtitle: 'Learn how to use the app',
              onTap: () {
                Navigator.pop(context);
                showSuccessToast(context, 'User guide coming soon!');
              },
            ),
            _buildHelpOption(
              icon: LucideIcons.messageCircle,
              title: 'Contact Support',
              subtitle: 'Get in touch with us',
              onTap: () {
                Navigator.pop(context);
                showSuccessToast(context, 'Contact: siam@area51.app');
              },
            ),
            _buildHelpOption(
              icon: LucideIcons.bug,
              title: 'Report a Bug',
              subtitle: 'Help us improve',
              onTap: () {
                Navigator.pop(context);
                showSuccessToast(
                  context,
                  'Bug report: github.com/siam/mess-manager',
                );
              },
            ),
            _buildHelpOption(
              icon: LucideIcons.star,
              title: 'Rate the App',
              subtitle: 'Leave a review',
              onTap: () {
                Navigator.pop(context);
                showSuccessToast(context, 'App store rating coming soon!');
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _buildHelpOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: AppColors.primary, size: 20),
      ),
      title: Text(title, style: AppTypography.titleSmall),
      subtitle: Text(
        subtitle,
        style: AppTypography.bodySmall.copyWith(color: AppColors.textMutedDark),
      ),
      onTap: () {
        HapticService.lightTap();
        onTap();
      },
    );
  }

  /// Privacy Mode tile - hides balances throughout the app
  Widget _buildPrivacyModeTile(BuildContext context, int index) {
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
            color: AppColors.warning.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
          ),
          child: const Icon(
            LucideIcons.eyeOff,
            color: AppColors.warning,
            size: 18,
          ),
        ),
        title: Text(
          'Privacy Mode',
          style: AppTypography.titleSmall.copyWith(
            color: AppColors.textPrimaryDark,
          ),
        ),
        subtitle: Text(
          _privacyModeEnabled ? 'Balances hidden' : 'Balances visible',
          style: AppTypography.bodySmall.copyWith(
            color: AppColors.textSecondaryDark,
          ),
        ),
        trailing: Switch.adaptive(
          value: _privacyModeEnabled,
          onChanged: (value) {
            HapticService.toggle();
            setState(() => _privacyModeEnabled = value);
            IsarService.saveSetting('privacy_mode', value);
          },
          activeTrackColor: AppColors.warning.withValues(alpha: 0.5),
          activeThumbColor: AppColors.warning,
        ),
        onTap: () {
          HapticService.toggle();
          setState(() => _privacyModeEnabled = !_privacyModeEnabled);
          IsarService.saveSetting('privacy_mode', _privacyModeEnabled);
        },
      ),
    ).animate(delay: (30 * index).ms).fadeIn().slideX(begin: 0.02);
  }

  /// Biometric Lock tile - fingerprint/face ID to unlock app
  Widget _buildBiometricLockTile(BuildContext context, int index) {
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
            color: AppColors.success.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
          ),
          child: const Icon(
            LucideIcons.fingerprint,
            color: AppColors.success,
            size: 18,
          ),
        ),
        title: Text(
          'Biometric Lock',
          style: AppTypography.titleSmall.copyWith(
            color: AppColors.textPrimaryDark,
          ),
        ),
        subtitle: Text(
          _biometricAvailable
              ? (_biometricLockEnabled ? 'Enabled' : 'Disabled')
              : 'Not available on this device',
          style: AppTypography.bodySmall.copyWith(
            color: AppColors.textSecondaryDark,
          ),
        ),
        trailing: Switch.adaptive(
          value: _biometricLockEnabled,
          onChanged: _biometricAvailable
              ? (value) async {
                  if (value) {
                    // Authenticate before enabling
                    final auth = LocalAuthentication();
                    try {
                      final didAuth = await auth.authenticate(
                        localizedReason:
                            'Authenticate to enable biometric lock',
                      );
                      if (didAuth) {
                        HapticService.success();
                        setState(() => _biometricLockEnabled = true);
                        IsarService.saveSetting('biometric_lock', true);
                      }
                    } catch (e) {
                      HapticService.error();
                    }
                  } else {
                    HapticService.toggle();
                    setState(() => _biometricLockEnabled = false);
                    IsarService.saveSetting('biometric_lock', false);
                  }
                }
              : null,
          activeTrackColor: AppColors.success.withValues(alpha: 0.5),
          activeThumbColor: AppColors.success,
        ),
      ),
    ).animate(delay: (30 * index).ms).fadeIn().slideX(begin: 0.02);
  }

  /// Invite Code tile - Display mess invite code for admins
  Widget _buildInviteCodeTile(int index) {
    final authState = ref.watch(authProvider);
    final inviteCode = authState.currentMess?.inviteCode;

    if (inviteCode == null) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      decoration: BoxDecoration(
        color: AppColors.cardDark,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
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
          child: const Icon(
            LucideIcons.key,
            color: AppColors.primary,
            size: 18,
          ),
        ),
        title: Text(
          'Mess Invite Code',
          style: AppTypography.titleSmall.copyWith(
            color: AppColors.textPrimaryDark,
          ),
        ),
        subtitle: Text(
          inviteCode,
          style: AppTypography.bodyMedium.copyWith(
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
          ),
        ),
        trailing: IconButton(
          icon: const Icon(
            LucideIcons.copy,
            color: AppColors.primary,
            size: 18,
          ),
          onPressed: () {
            Clipboard.setData(ClipboardData(text: inviteCode));
            HapticService.success();
            showSuccessToast(context, 'Invite code copied!');
          },
        ),
        onTap: () {
          Clipboard.setData(ClipboardData(text: inviteCode));
          HapticService.success();
          showSuccessToast(context, 'Invite code copied!');
        },
      ),
    ).animate(delay: (30 * index).ms).fadeIn().slideX(begin: 0.02);
  }

  void _showEditMessSheet(BuildContext context) {
    HapticService.modalOpen();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _EditMessSheet(ref: ref),
    );
  }
}

/// Edit Mess Settings Sheet
class _EditMessSheet extends ConsumerStatefulWidget {
  final WidgetRef ref;

  const _EditMessSheet({required this.ref});

  @override
  ConsumerState<_EditMessSheet> createState() => _EditMessSheetState();
}

class _EditMessSheetState extends ConsumerState<_EditMessSheet> {
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    final mess = ref.read(authProvider).currentMess;
    if (mess != null) {
      _nameController.text = mess.name;
      _addressController.text = mess.address;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      decoration: const BoxDecoration(
        color: AppColors.surfaceDark,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppSpacing.radiusLg),
        ),
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Handle
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.borderDark,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const Gap(AppSpacing.lg),

            // Title
            Row(
              children: [
                const Icon(LucideIcons.home, color: AppColors.primary),
                const Gap(AppSpacing.sm),
                Text(
                  'Edit Mess Settings',
                  style: AppTypography.titleLarge.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const Gap(AppSpacing.lg),

            // Mess Name
            Text(
              'Mess Name',
              style: AppTypography.labelMedium.copyWith(
                color: AppColors.textSecondaryDark,
              ),
            ),
            const Gap(AppSpacing.sm),
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                hintText: 'Enter mess name',
                prefixIcon: const Icon(LucideIcons.building2),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                ),
              ),
            ),
            const Gap(AppSpacing.lg),

            // Address
            Text(
              'Address',
              style: AppTypography.labelMedium.copyWith(
                color: AppColors.textSecondaryDark,
              ),
            ),
            const Gap(AppSpacing.sm),
            TextFormField(
              controller: _addressController,
              maxLines: 2,
              decoration: InputDecoration(
                hintText: 'Enter mess address',
                prefixIcon: const Icon(LucideIcons.mapPin),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                ),
              ),
            ),
            const Gap(AppSpacing.xl),

            // Save Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _saveChanges,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                  ),
                ),
                child: _isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : Text(
                        'Save Changes',
                        style: AppTypography.titleMedium.copyWith(
                          color: Colors.white,
                        ),
                      ),
              ),
            ),
            const Gap(AppSpacing.md),
          ],
        ),
      ),
    );
  }

  void _saveChanges() async {
    final name = _nameController.text.trim();
    final address = _addressController.text.trim();

    if (name.isEmpty) {
      showErrorToast(context, 'Please enter a mess name');
      return;
    }

    setState(() => _isLoading = true);

    try {
      await ref
          .read(authProvider.notifier)
          .updateMess(name: name, address: address);

      HapticService.success();
      if (context.mounted) {
        Navigator.pop(context);
        showSuccessToast(context, 'Mess settings updated!');
      }
    } catch (e) {
      HapticService.error();
      if (context.mounted) {
        showErrorToast(context, 'Failed to update: $e');
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }
}
