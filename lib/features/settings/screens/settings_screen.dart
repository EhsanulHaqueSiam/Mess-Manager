import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:local_auth/local_auth.dart';

import 'package:mess_manager/core/theme/app_theme.dart';
import 'package:mess_manager/core/router/app_router.dart';
import 'package:mess_manager/core/services/haptic_service.dart';
import 'package:mess_manager/core/widgets/app_components.dart';
import 'package:mess_manager/core/database/isar_service.dart';
import 'package:mess_manager/core/services/backup_service.dart';
import 'package:mess_manager/features/auth/providers/auth_provider.dart';
import 'package:mess_manager/core/providers/role_provider.dart';
import 'package:mess_manager/features/settings/providers/theme_color_provider.dart';
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
    _privacyModeEnabled =
        IsarService.getSetting<bool>('privacy_mode') ?? false;
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
    final authState = ref.watch(authProvider);
    final isAdmin = ref.watch(isAdminProvider);

    return Scaffold(
      body: Stack(
        children: [
          // ── Deep space background ──
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFF0D1520), Color(0xFF0A0E1A)],
                ),
              ),
            ),
          ),
          // Breathing orbs
          Positioned(
            top: -80,
            right: -60,
            child: Container(
              width: 220,
              height: 220,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppColors.primary.withValues(alpha: 0.12),
                    Colors.transparent,
                  ],
                ),
              ),
            )
                .animate(onPlay: (c) => c.repeat(reverse: true))
                .scaleXY(begin: 0.9, end: 1.15, duration: 7.seconds),
          ),
          Positioned(
            bottom: -40,
            left: -60,
            child: Container(
              width: 160,
              height: 160,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppColors.accent.withValues(alpha: 0.06),
                    Colors.transparent,
                  ],
                ),
              ),
            )
                .animate(onPlay: (c) => c.repeat(reverse: true))
                .scaleXY(
                    begin: 0.95, end: 1.1, duration: 9.seconds, delay: 2.seconds),
          ),

          // ── Content ──
          SafeArea(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
              children: [
                _buildHeader(),
                const Gap(20),

                // ── Profile Identity Card ──
                _buildProfileCard(authState),
                const Gap(24),

                // ── Appearance ──
                _sectionLabel('APPEARANCE', 0),
                const Gap(8),
                _buildThemeTile(isDarkMode, 1),
                _buildThemeColorTile(2),
                const Gap(20),

                // ── Notifications ──
                _sectionLabel('NOTIFICATIONS', 3),
                const Gap(8),
                _buildGlassTile(
                  icon: LucideIcons.bellRing,
                  title: 'Notification Settings',
                  subtitle: 'Configure meal reminders & alerts',
                  color: AppColors.warning,
                  onTap: () => context.push(AppRoutes.notificationSettings),
                  index: 4,
                ),
                _buildGlassTile(
                  icon: LucideIcons.inbox,
                  title: 'Notification History',
                  subtitle: 'View past notifications',
                  color: AppColors.info,
                  onTap: () => context.push(AppRoutes.notifications),
                  index: 5,
                ),
                const Gap(20),

                // ── Admin Section (conditional) ──
                if (isAdmin) ...[
                  _sectionLabel('ADMIN', 6),
                  const Gap(8),
                  _buildGlassTile(
                    icon: LucideIcons.home,
                    title: 'Mess Settings',
                    subtitle: 'Edit name, address',
                    color: AppColors.primary,
                    onTap: () => _showEditMessSheet(context),
                    index: 7,
                  ),
                  _buildInviteCodeTile(8),
                  const Gap(20),
                ],

                // ── Data & Backup ──
                _sectionLabel('DATA & BACKUP', 9),
                const Gap(8),
                _buildGlassTile(
                  icon: LucideIcons.downloadCloud,
                  title: 'Backup Data',
                  subtitle: 'Export all data as JSON',
                  color: AppColors.success,
                  onTap: () async {
                    HapticService.lightTap();
                    await BackupService.createBackup();
                    if (context.mounted) {
                      showSuccessToast(context, 'Backup ready to share');
                    }
                  },
                  index: 10,
                ),
                _buildGlassTile(
                  icon: LucideIcons.uploadCloud,
                  title: 'Restore Backup',
                  subtitle: 'Import from JSON file',
                  color: AppColors.warning,
                  onTap: () async {
                    HapticService.lightTap();
                    final success = await BackupService.restoreBackup();
                    if (!context.mounted) return;
                    if (success) {
                      showSuccessToast(
                          context, 'Restore successful! Please restart app.');
                    } else {
                      showErrorToast(context, 'Restore cancelled or failed');
                    }
                  },
                  index: 11,
                ),
                _buildGlassTile(
                  icon: LucideIcons.fileSpreadsheet,
                  title: 'Export Reports',
                  subtitle: 'PDF / Excel sheets',
                  color: AppColors.bazarColor,
                  onTap: () {
                    HapticService.lightTap();
                    showInfoToast(context, 'Coming soon!');
                  },
                  index: 12,
                ),
                const Gap(20),

                // ── Privacy & Security ──
                _sectionLabel('PRIVACY & SECURITY', 13),
                const Gap(8),
                _buildPrivacyModeTile(14),
                _buildBiometricLockTile(15),
                const Gap(20),

                // ── About ──
                _sectionLabel('ABOUT', 16),
                const Gap(8),
                _buildGlassTile(
                  icon: LucideIcons.info,
                  title: 'About Mess Manager',
                  subtitle: 'Version 1.0.0',
                  color: AppColors.primaryLight,
                  onTap: () => _showAboutSheet(context),
                  index: 17,
                ),
                _buildGlassTile(
                  icon: LucideIcons.lifeBuoy,
                  title: 'Help & Support',
                  subtitle: 'Get assistance',
                  color: AppColors.accentAlt,
                  onTap: () => _showHelpSheet(context),
                  index: 18,
                ),
                const Gap(24),

                // ── Sign Out ──
                _buildSignOutButton(19),
                const Gap(24),

                // ── Footer ──
                _buildFooter(),
                const Gap(16),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ────────────────────────────────────────────────────────────────
  // HEADER
  // ────────────────────────────────────────────────────────────────

  Widget _buildHeader() {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: LinearGradient(
              colors: [
                AppColors.primaryLight.withValues(alpha: 0.15),
                AppColors.primary.withValues(alpha: 0.05),
              ],
            ),
            border: Border.all(
              color: AppColors.primaryLight.withValues(alpha: 0.12),
            ),
          ),
          child: const Icon(LucideIcons.settings, color: AppColors.primaryLight,
              size: 20),
        ),
        const Gap(12),
        Text(
          'Settings',
          style: AppTypography.headlineMedium.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
        const Spacer(),
        // Profile shortcut
        GestureDetector(
          onTap: () {
            HapticService.lightTap();
            context.push(AppRoutes.profile);
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.white.withValues(alpha: 0.04),
              border:
                  Border.all(color: Colors.white.withValues(alpha: 0.08)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(LucideIcons.user, size: 14,
                    color: Colors.white.withValues(alpha: 0.5)),
                const Gap(6),
                Text(
                  'Profile',
                  style: AppTypography.labelSmall.copyWith(
                    color: Colors.white.withValues(alpha: 0.5),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    ).animate().fadeIn(duration: 400.ms).slideY(begin: -0.05);
  }

  // ────────────────────────────────────────────────────────────────
  // PROFILE IDENTITY CARD
  // ────────────────────────────────────────────────────────────────

  Widget _buildProfileCard(AuthState authState) {
    final user = authState.user;
    final mess = authState.currentMess;
    final name = user?.name ?? 'User';
    final email = user?.email ?? '';
    final messName = mess?.name ?? 'No Mess';
    final initials = name.split(' ').map((w) => w.isNotEmpty ? w[0] : '')
        .take(2).join().toUpperCase();

    return GestureDetector(
      onTap: () {
        HapticService.lightTap();
        context.push(AppRoutes.profile);
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
              gradient: LinearGradient(
                colors: [
                  Colors.white.withValues(alpha: 0.08),
                  Colors.white.withValues(alpha: 0.02),
                  AppColors.primaryLight.withValues(alpha: 0.03),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.1),
                width: 1.2,
              ),
            ),
            child: Row(
              children: [
                // Avatar with gradient ring
                Container(
                  padding: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const LinearGradient(
                      colors: [
                        AppColors.primaryLight,
                        AppColors.accent,
                        AppColors.accentAlt,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primaryLight.withValues(alpha: 0.3),
                        blurRadius: 16,
                        spreadRadius: -4,
                      ),
                    ],
                  ),
                  child: CircleAvatar(
                    radius: 26,
                    backgroundColor: const Color(0xFF0D1520),
                    child: Text(
                      initials,
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primaryLight,
                      ),
                    ),
                  ),
                ),
                const Gap(16),
                // Name, email, mess
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: AppTypography.titleLarge.copyWith(
                          color: Colors.white.withValues(alpha: 0.95),
                          fontWeight: FontWeight.w700,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (email.isNotEmpty) ...[
                        const Gap(2),
                        Text(
                          email,
                          style: AppTypography.bodySmall.copyWith(
                            color: Colors.white.withValues(alpha: 0.4),
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                      const Gap(8),
                      // Mess badge
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          gradient: LinearGradient(
                            colors: [
                              AppColors.primaryLight.withValues(alpha: 0.12),
                              AppColors.primary.withValues(alpha: 0.06),
                            ],
                          ),
                          border: Border.all(
                            color:
                                AppColors.primaryLight.withValues(alpha: 0.15),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(LucideIcons.building2,
                                size: 11, color: AppColors.primaryLight),
                            const Gap(5),
                            Flexible(
                              child: Text(
                                messName,
                                style: AppTypography.labelSmall.copyWith(
                                  color: AppColors.primaryLight,
                                  fontWeight: FontWeight.w600,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  LucideIcons.chevronRight,
                  size: 18,
                  color: Colors.white.withValues(alpha: 0.15),
                ),
              ],
            ),
          ),
        ),
      ),
    )
        .animate()
        .fadeIn(duration: 600.ms)
        .scale(begin: const Offset(0.97, 0.97), curve: Curves.easeOutCubic);
  }

  // ────────────────────────────────────────────────────────────────
  // SECTION LABEL
  // ────────────────────────────────────────────────────────────────

  Widget _sectionLabel(String text, int index) {
    return Row(
      children: [
        Container(
          width: 3,
          height: 14,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(2),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                AppColors.primaryLight,
                AppColors.primaryLight.withValues(alpha: 0.3),
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.primaryLight.withValues(alpha: 0.2),
                blurRadius: 4,
                spreadRadius: -1,
              ),
            ],
          ),
        ),
        const Gap(8),
        Text(
          text,
          style: AppTypography.labelSmall.copyWith(
            color: Colors.white.withValues(alpha: 0.35),
            letterSpacing: 1.5,
            fontWeight: FontWeight.w600,
          ),
        ),
        const Gap(8),
        Expanded(
          child: Container(
            height: 1,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.white.withValues(alpha: 0.06),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),
      ],
    ).animate(delay: Duration(milliseconds: 30 * index)).fadeIn();
  }

  // ────────────────────────────────────────────────────────────────
  // GLASS TILE
  // ────────────────────────────────────────────────────────────────

  Widget _buildGlassTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required int index,
    VoidCallback? onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: GestureDetector(
        onTap: () {
          HapticService.lightTap();
          onTap?.call();
        },
        child: ClipRRect(
          borderRadius: BorderRadius.circular(14),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                color: Colors.white.withValues(alpha: 0.04),
                border: Border.all(
                    color: Colors.white.withValues(alpha: 0.06)),
              ),
              child: Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      gradient: RadialGradient(
                        colors: [
                          color.withValues(alpha: 0.25),
                          color.withValues(alpha: 0.08),
                        ],
                      ),
                    ),
                    child: Icon(icon, color: color, size: 18),
                  ),
                  const Gap(12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: AppTypography.titleSmall.copyWith(
                            color: Colors.white.withValues(alpha: 0.85),
                          ),
                        ),
                        Text(
                          subtitle,
                          style: AppTypography.bodySmall.copyWith(
                            color: Colors.white.withValues(alpha: 0.35),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    LucideIcons.chevronRight,
                    size: 16,
                    color: Colors.white.withValues(alpha: 0.2),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    )
        .animate(delay: Duration(milliseconds: 30 * index))
        .fadeIn()
        .slideX(begin: 0.02);
  }

  // ────────────────────────────────────────────────────────────────
  // THEME TOGGLE TILE
  // ────────────────────────────────────────────────────────────────

  Widget _buildThemeTile(bool isDarkMode, int index) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
          child: Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              color: Colors.white.withValues(alpha: 0.04),
              border: Border.all(
                  color: Colors.white.withValues(alpha: 0.06)),
            ),
            child: ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  gradient: RadialGradient(
                    colors: [
                      AppColors.primary.withValues(alpha: 0.25),
                      AppColors.primary.withValues(alpha: 0.08),
                    ],
                  ),
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
                  color: Colors.white.withValues(alpha: 0.85),
                ),
              ),
              subtitle: Text(
                isDarkMode ? 'Enabled' : 'Disabled',
                style: AppTypography.bodySmall.copyWith(
                  color: Colors.white.withValues(alpha: 0.35),
                ),
              ),
              trailing: ThemeSwitcher(
                clipper: const ThemeSwitcherCircleClipper(),
                builder: (ctx) {
                  return Switch.adaptive(
                    value: isDarkMode,
                    onChanged: (_) {
                      HapticService.toggle();
                      final themeSwitcher = ThemeSwitcher.of(ctx);
                      final adaptiveTheme = AdaptiveTheme.of(context);
                      final newTheme = isDarkMode
                          ? adaptiveTheme.lightTheme
                          : adaptiveTheme.darkTheme;
                      themeSwitcher.changeTheme(theme: newTheme);
                      adaptiveTheme.toggleThemeMode();
                    },
                    activeTrackColor:
                        AppColors.primary.withValues(alpha: 0.5),
                    activeThumbColor: AppColors.primary,
                  );
                },
              ),
              onTap: () {
                HapticService.toggle();
                AdaptiveTheme.of(context).toggleThemeMode();
              },
            ),
          ),
        ),
      ),
    )
        .animate(delay: Duration(milliseconds: 30 * index))
        .fadeIn()
        .slideX(begin: 0.02);
  }

  // ────────────────────────────────────────────────────────────────
  // THEME COLOR TILE
  // ────────────────────────────────────────────────────────────────

  Widget _buildThemeColorTile(int index) {
    final currentColor = ref.watch(themeColorProvider);

    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: GestureDetector(
        onTap: () {
          HapticService.lightTap();
          _showThemeColorPicker(context);
        },
        child: ClipRRect(
          borderRadius: BorderRadius.circular(14),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
            child: Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                color: Colors.white.withValues(alpha: 0.04),
                border: Border.all(
                    color: Colors.white.withValues(alpha: 0.06)),
              ),
              child: Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      gradient: RadialGradient(
                        colors: [
                          currentColor.effectiveColor
                              .withValues(alpha: 0.3),
                          currentColor.effectiveColor
                              .withValues(alpha: 0.1),
                        ],
                      ),
                    ),
                    child: Icon(
                      LucideIcons.palette,
                      color: currentColor.effectiveColor,
                      size: 18,
                    ),
                  ),
                  const Gap(12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Theme Color',
                          style: AppTypography.titleSmall.copyWith(
                            color:
                                Colors.white.withValues(alpha: 0.85),
                          ),
                        ),
                        Text(
                          currentColor.displayName,
                          style: AppTypography.bodySmall.copyWith(
                            color:
                                Colors.white.withValues(alpha: 0.35),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: currentColor.effectiveColor,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.2),
                        width: 2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: currentColor.effectiveColor
                              .withValues(alpha: 0.3),
                          blurRadius: 8,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    )
        .animate(delay: Duration(milliseconds: 30 * index))
        .fadeIn()
        .slideX(begin: 0.02);
  }

  // ────────────────────────────────────────────────────────────────
  // PRIVACY MODE TILE
  // ────────────────────────────────────────────────────────────────

  Widget _buildPrivacyModeTile(int index) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
          child: Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              color: Colors.white.withValues(alpha: 0.04),
              border: Border.all(
                  color: Colors.white.withValues(alpha: 0.06)),
            ),
            child: ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  gradient: RadialGradient(
                    colors: [
                      AppColors.warning.withValues(alpha: 0.25),
                      AppColors.warning.withValues(alpha: 0.08),
                    ],
                  ),
                ),
                child: const Icon(LucideIcons.eyeOff,
                    color: AppColors.warning, size: 18),
              ),
              title: Text(
                'Privacy Mode',
                style: AppTypography.titleSmall.copyWith(
                  color: Colors.white.withValues(alpha: 0.85),
                ),
              ),
              subtitle: Text(
                _privacyModeEnabled
                    ? 'Balances hidden'
                    : 'Balances visible',
                style: AppTypography.bodySmall.copyWith(
                  color: Colors.white.withValues(alpha: 0.35),
                ),
              ),
              trailing: Switch.adaptive(
                value: _privacyModeEnabled,
                onChanged: (value) {
                  HapticService.toggle();
                  setState(() => _privacyModeEnabled = value);
                  IsarService.saveSetting('privacy_mode', value);
                },
                activeTrackColor:
                    AppColors.warning.withValues(alpha: 0.5),
                activeThumbColor: AppColors.warning,
              ),
              onTap: () {
                HapticService.toggle();
                setState(
                    () => _privacyModeEnabled = !_privacyModeEnabled);
                IsarService.saveSetting(
                    'privacy_mode', _privacyModeEnabled);
              },
            ),
          ),
        ),
      ),
    )
        .animate(delay: Duration(milliseconds: 30 * index))
        .fadeIn()
        .slideX(begin: 0.02);
  }

  // ────────────────────────────────────────────────────────────────
  // BIOMETRIC LOCK TILE
  // ────────────────────────────────────────────────────────────────

  Widget _buildBiometricLockTile(int index) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
          child: Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              color: Colors.white.withValues(alpha: 0.04),
              border: Border.all(
                  color: Colors.white.withValues(alpha: 0.06)),
            ),
            child: ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  gradient: RadialGradient(
                    colors: [
                      AppColors.success.withValues(alpha: 0.25),
                      AppColors.success.withValues(alpha: 0.08),
                    ],
                  ),
                ),
                child: const Icon(LucideIcons.fingerprint,
                    color: AppColors.success, size: 18),
              ),
              title: Text(
                'Biometric Lock',
                style: AppTypography.titleSmall.copyWith(
                  color: Colors.white.withValues(alpha: 0.85),
                ),
              ),
              subtitle: Text(
                _biometricAvailable
                    ? (_biometricLockEnabled ? 'Enabled' : 'Disabled')
                    : 'Not available on this device',
                style: AppTypography.bodySmall.copyWith(
                  color: Colors.white.withValues(alpha: 0.35),
                ),
              ),
              trailing: Switch.adaptive(
                value: _biometricLockEnabled,
                onChanged: _biometricAvailable
                    ? (value) async {
                        if (value) {
                          final auth = LocalAuthentication();
                          try {
                            final didAuth = await auth.authenticate(
                              localizedReason:
                                  'Authenticate to enable biometric lock',
                            );
                            if (didAuth) {
                              HapticService.success();
                              setState(
                                  () => _biometricLockEnabled = true);
                              IsarService.saveSetting(
                                  'biometric_lock', true);
                            }
                          } catch (e) {
                            HapticService.error();
                          }
                        } else {
                          HapticService.toggle();
                          setState(
                              () => _biometricLockEnabled = false);
                          IsarService.saveSetting(
                              'biometric_lock', false);
                        }
                      }
                    : null,
                activeTrackColor:
                    AppColors.success.withValues(alpha: 0.5),
                activeThumbColor: AppColors.success,
              ),
            ),
          ),
        ),
      ),
    )
        .animate(delay: Duration(milliseconds: 30 * index))
        .fadeIn()
        .slideX(begin: 0.02);
  }

  // ────────────────────────────────────────────────────────────────
  // INVITE CODE TILE
  // ────────────────────────────────────────────────────────────────

  Widget _buildInviteCodeTile(int index) {
    final authState = ref.watch(authProvider);
    final inviteCode = authState.currentMess?.inviteCode;

    if (inviteCode == null) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: GestureDetector(
        onTap: () {
          Clipboard.setData(ClipboardData(text: inviteCode));
          HapticService.success();
          showSuccessToast(context, 'Invite code copied!');
        },
        child: ClipRRect(
          borderRadius: BorderRadius.circular(14),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
            child: Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                color: AppColors.primary.withValues(alpha: 0.06),
                border: Border.all(
                    color: AppColors.primary.withValues(alpha: 0.15)),
              ),
              child: Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      gradient: RadialGradient(
                        colors: [
                          AppColors.primary.withValues(alpha: 0.25),
                          AppColors.primary.withValues(alpha: 0.08),
                        ],
                      ),
                    ),
                    child: const Icon(LucideIcons.key,
                        color: AppColors.primary, size: 18),
                  ),
                  const Gap(12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Mess Invite Code',
                          style: AppTypography.titleSmall.copyWith(
                            color:
                                Colors.white.withValues(alpha: 0.85),
                          ),
                        ),
                        Text(
                          inviteCode,
                          style: GoogleFonts.jetBrainsMono(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primaryLight,
                            letterSpacing: 2,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    LucideIcons.copy,
                    size: 16,
                    color: AppColors.primaryLight.withValues(alpha: 0.6),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    )
        .animate(delay: Duration(milliseconds: 30 * index))
        .fadeIn()
        .slideX(begin: 0.02);
  }

  // ────────────────────────────────────────────────────────────────
  // SIGN OUT BUTTON
  // ────────────────────────────────────────────────────────────────

  Widget _buildSignOutButton(int index) {
    return GestureDetector(
      onTap: () => _showSignOutSheet(context),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              color: AppColors.error.withValues(alpha: 0.06),
              border: Border.all(
                  color: AppColors.error.withValues(alpha: 0.15)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(LucideIcons.logOut,
                    color: AppColors.error.withValues(alpha: 0.8),
                    size: 18),
                const Gap(10),
                Text(
                  'Sign Out',
                  style: AppTypography.titleSmall.copyWith(
                    color: AppColors.error.withValues(alpha: 0.8),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    )
        .animate(delay: Duration(milliseconds: 30 * index))
        .fadeIn()
        .slideY(begin: 0.03);
  }

  // ────────────────────────────────────────────────────────────────
  // FOOTER
  // ────────────────────────────────────────────────────────────────

  Widget _buildFooter() {
    return Column(
      children: [
        // Gradient divider
        Container(
          height: 1,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.transparent,
                AppColors.primaryLight.withValues(alpha: 0.08),
                Colors.transparent,
              ],
            ),
          ),
        ),
        const Gap(16),
        // App identity
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                gradient: LinearGradient(
                  colors: [
                    AppColors.primaryLight.withValues(alpha: 0.1),
                    AppColors.accent.withValues(alpha: 0.05),
                  ],
                ),
              ),
              child: Icon(LucideIcons.utensils,
                  size: 12, color: AppColors.primaryLight.withValues(alpha: 0.5)),
            ),
            const Gap(8),
            ShaderMask(
              shaderCallback: (bounds) => LinearGradient(
                colors: [
                  Colors.white.withValues(alpha: 0.25),
                  Colors.white.withValues(alpha: 0.1),
                ],
              ).createShader(bounds),
              child: Text(
                'Mess Manager v1.0.0',
                style: GoogleFonts.jetBrainsMono(
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                  letterSpacing: 1,
                ),
              ),
            ),
          ],
        ),
        const Gap(4),
        Text(
          'Made with love by Siam',
          style: AppTypography.labelSmall.copyWith(
            color: Colors.white.withValues(alpha: 0.15),
            fontSize: 9,
          ),
        ),
      ],
    ).animate(delay: 500.ms).fadeIn(duration: 600.ms);
  }

  // ────────────────────────────────────────────────────────────────
  // COSMIC SIGN-OUT SHEET
  // ────────────────────────────────────────────────────────────────

  void _showSignOutSheet(BuildContext context) {
    HapticService.mediumTap();
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => ClipRRect(
        borderRadius:
            const BorderRadius.vertical(top: Radius.circular(24)),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: const Color(0xFF0D1520).withValues(alpha: 0.95),
              borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(24)),
              border: Border(
                top: BorderSide(
                    color: AppColors.error.withValues(alpha: 0.15)),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Handle
                Container(
                  width: 36,
                  height: 4,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(2),
                    gradient: LinearGradient(
                      colors: [
                        AppColors.error.withValues(alpha: 0.4),
                        AppColors.error.withValues(alpha: 0.1),
                      ],
                    ),
                  ),
                ),
                const Gap(24),
                // Icon
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        AppColors.error.withValues(alpha: 0.15),
                        AppColors.error.withValues(alpha: 0.03),
                      ],
                    ),
                    border: Border.all(
                      color: AppColors.error.withValues(alpha: 0.2),
                    ),
                  ),
                  child: Icon(LucideIcons.logOut,
                      color: AppColors.error, size: 28),
                ),
                const Gap(16),
                Text(
                  'Sign Out?',
                  style: AppTypography.headlineSmall.copyWith(
                    color: Colors.white.withValues(alpha: 0.9),
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const Gap(8),
                Text(
                  'You will need to sign in again to access your mess data.',
                  textAlign: TextAlign.center,
                  style: AppTypography.bodySmall.copyWith(
                    color: Colors.white.withValues(alpha: 0.4),
                  ),
                ),
                const Gap(24),
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          HapticService.lightTap();
                          Navigator.pop(ctx);
                        },
                        child: Container(
                          padding:
                              const EdgeInsets.symmetric(vertical: 14),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color:
                                Colors.white.withValues(alpha: 0.05),
                            border: Border.all(
                              color: Colors.white
                                  .withValues(alpha: 0.08),
                            ),
                          ),
                          child: Center(
                            child: Text(
                              'Cancel',
                              style:
                                  AppTypography.titleSmall.copyWith(
                                color: Colors.white
                                    .withValues(alpha: 0.6),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const Gap(12),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          HapticService.success();
                          Navigator.pop(ctx);
                          context.go(AppRoutes.login);
                        },
                        child: Container(
                          padding:
                              const EdgeInsets.symmetric(vertical: 14),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            gradient: LinearGradient(
                              colors: [
                                AppColors.error,
                                AppColors.error
                                    .withValues(alpha: 0.8),
                              ],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.error
                                    .withValues(alpha: 0.3),
                                blurRadius: 12,
                                spreadRadius: -4,
                              ),
                            ],
                          ),
                          child: Center(
                            child: Text(
                              'Sign Out',
                              style:
                                  AppTypography.titleSmall.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const Gap(16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ────────────────────────────────────────────────────────────────
  // COSMIC ABOUT SHEET
  // ────────────────────────────────────────────────────────────────

  void _showAboutSheet(BuildContext context) {
    HapticService.lightTap();
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => ClipRRect(
        borderRadius:
            const BorderRadius.vertical(top: Radius.circular(24)),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: const Color(0xFF0D1520).withValues(alpha: 0.95),
              borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(24)),
              border: Border(
                top: BorderSide(
                    color: AppColors.primaryLight
                        .withValues(alpha: 0.1)),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Handle
                Container(
                  width: 36,
                  height: 4,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(2),
                    gradient: LinearGradient(
                      colors: [
                        AppColors.primaryLight
                            .withValues(alpha: 0.4),
                        AppColors.accent.withValues(alpha: 0.1),
                      ],
                    ),
                  ),
                ),
                const Gap(24),
                // App icon
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    gradient: const LinearGradient(
                      colors: AppColors.gradientPrimary,
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary
                            .withValues(alpha: 0.4),
                        blurRadius: 24,
                        spreadRadius: -8,
                      ),
                    ],
                  ),
                  child: const Icon(LucideIcons.utensils,
                      color: Colors.white, size: 28),
                ),
                const Gap(16),
                Text(
                  'Mess Manager',
                  style: AppTypography.headlineSmall.copyWith(
                    color: Colors.white.withValues(alpha: 0.95),
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const Gap(4),
                Text(
                  'Area51 Hostel Management',
                  style: AppTypography.bodySmall.copyWith(
                    color: Colors.white.withValues(alpha: 0.4),
                  ),
                ),
                const Gap(20),
                // Version info
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    color: Colors.white.withValues(alpha: 0.03),
                    border: Border.all(
                        color:
                            Colors.white.withValues(alpha: 0.06)),
                  ),
                  child: Column(
                    children: [
                      _aboutInfoRow('Version', '1.0.0'),
                      Divider(
                          color: Colors.white
                              .withValues(alpha: 0.04),
                          height: 20),
                      _aboutInfoRow('Build', '2026.02.13'),
                      Divider(
                          color: Colors.white
                              .withValues(alpha: 0.04),
                          height: 20),
                      _aboutInfoRow('Platform', 'Flutter 3.38'),
                    ],
                  ),
                ),
                const Gap(16),
                Text(
                  'Track meals, expenses, duties, and settlements\nfor shared living spaces.',
                  textAlign: TextAlign.center,
                  style: AppTypography.bodySmall.copyWith(
                    color: Colors.white.withValues(alpha: 0.35),
                    height: 1.6,
                  ),
                ),
                const Gap(20),
                ShaderMask(
                  shaderCallback: (bounds) =>
                      const LinearGradient(
                    colors: [
                      AppColors.primaryLight,
                      AppColors.accent,
                    ],
                  ).createShader(bounds),
                  child: Text(
                    'Made with love by Siam',
                    style: AppTypography.labelMedium.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const Gap(16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _aboutInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: AppTypography.bodySmall.copyWith(
            color: Colors.white.withValues(alpha: 0.4),
          ),
        ),
        Text(
          value,
          style: GoogleFonts.jetBrainsMono(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppColors.primaryLight,
          ),
        ),
      ],
    );
  }

  // ────────────────────────────────────────────────────────────────
  // COSMIC HELP SHEET
  // ────────────────────────────────────────────────────────────────

  void _showHelpSheet(BuildContext context) {
    HapticService.lightTap();
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => ClipRRect(
        borderRadius:
            const BorderRadius.vertical(top: Radius.circular(24)),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: const Color(0xFF0D1520).withValues(alpha: 0.95),
              borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(24)),
              border: Border(
                top: BorderSide(
                    color: AppColors.accentAlt
                        .withValues(alpha: 0.1)),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 36,
                  height: 4,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(2),
                    gradient: LinearGradient(
                      colors: [
                        AppColors.accentAlt.withValues(alpha: 0.4),
                        AppColors.info.withValues(alpha: 0.1),
                      ],
                    ),
                  ),
                ),
                const Gap(20),
                Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        gradient: RadialGradient(
                          colors: [
                            AppColors.accentAlt
                                .withValues(alpha: 0.2),
                            AppColors.accentAlt
                                .withValues(alpha: 0.05),
                          ],
                        ),
                      ),
                      child: const Icon(LucideIcons.lifeBuoy,
                          color: AppColors.accentAlt, size: 20),
                    ),
                    const Gap(12),
                    Text(
                      'Help & Support',
                      style: AppTypography.headlineSmall.copyWith(
                        color: Colors.white.withValues(alpha: 0.9),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                const Gap(16),
                _buildHelpOption(
                  ctx: ctx,
                  icon: LucideIcons.bookOpen,
                  title: 'User Guide',
                  subtitle: 'Learn how to use the app',
                  color: AppColors.primary,
                  onTap: () {
                    Navigator.pop(ctx);
                    showInfoToast(context, 'User guide coming soon!');
                  },
                ),
                _buildHelpOption(
                  ctx: ctx,
                  icon: LucideIcons.messageCircle,
                  title: 'Contact Support',
                  subtitle: 'siam@area51.app',
                  color: AppColors.accentAlt,
                  onTap: () {
                    Navigator.pop(ctx);
                    Clipboard.setData(
                        const ClipboardData(text: 'siam@area51.app'));
                    showSuccessToast(
                        context, 'Email copied to clipboard');
                  },
                ),
                _buildHelpOption(
                  ctx: ctx,
                  icon: LucideIcons.bug,
                  title: 'Report a Bug',
                  subtitle: 'Help us improve',
                  color: AppColors.warning,
                  onTap: () {
                    Navigator.pop(ctx);
                    showInfoToast(context,
                        'Bug report: github.com/siam/mess-manager');
                  },
                ),
                _buildHelpOption(
                  ctx: ctx,
                  icon: LucideIcons.star,
                  title: 'Rate the App',
                  subtitle: 'Leave a review on the store',
                  color: AppColors.accentWarm,
                  onTap: () {
                    Navigator.pop(ctx);
                    showInfoToast(
                        context, 'App store rating coming soon!');
                  },
                ),
                const Gap(8),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHelpOption({
    required BuildContext ctx,
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: GestureDetector(
        onTap: () {
          HapticService.lightTap();
          onTap();
        },
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.white.withValues(alpha: 0.03),
            border: Border.all(
                color: Colors.white.withValues(alpha: 0.05)),
          ),
          child: Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  gradient: RadialGradient(
                    colors: [
                      color.withValues(alpha: 0.2),
                      color.withValues(alpha: 0.05),
                    ],
                  ),
                ),
                child: Icon(icon, color: color, size: 18),
              ),
              const Gap(12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTypography.titleSmall.copyWith(
                        color:
                            Colors.white.withValues(alpha: 0.85),
                      ),
                    ),
                    Text(
                      subtitle,
                      style: AppTypography.bodySmall.copyWith(
                        color:
                            Colors.white.withValues(alpha: 0.35),
                      ),
                    ),
                  ],
                ),
              ),
              Icon(LucideIcons.chevronRight,
                  size: 14,
                  color: Colors.white.withValues(alpha: 0.15)),
            ],
          ),
        ),
      ),
    );
  }

  // ────────────────────────────────────────────────────────────────
  // THEME COLOR PICKER
  // ────────────────────────────────────────────────────────────────

  void _showThemeColorPicker(BuildContext context) {
    final currentColor = ref.read(themeColorProvider);

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => ClipRRect(
        borderRadius:
            const BorderRadius.vertical(top: Radius.circular(24)),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: const Color(0xFF0D1520).withValues(alpha: 0.95),
              borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(24)),
              border: Border(
                top: BorderSide(
                    color:
                        Colors.white.withValues(alpha: 0.08)),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 36,
                    height: 4,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(2),
                      gradient: LinearGradient(
                        colors: [
                          AppColors.primaryLight
                              .withValues(alpha: 0.4),
                          AppColors.accent
                              .withValues(alpha: 0.1),
                        ],
                      ),
                    ),
                  ),
                ),
                const Gap(20),
                Text(
                  'Theme Color',
                  style: AppTypography.headlineSmall.copyWith(
                    color: Colors.white.withValues(alpha: 0.9),
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const Gap(4),
                Text(
                  'Select an accent color for the app',
                  style: AppTypography.bodySmall.copyWith(
                    color: Colors.white.withValues(alpha: 0.35),
                  ),
                ),
                const Gap(20),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children:
                      ThemeColorOption.values.map((option) {
                    final isSelected = option == currentColor;
                    final color = option.effectiveColor;

                    return GestureDetector(
                      onTap: () {
                        HapticService.selectionTick();
                        ref
                            .read(themeColorProvider.notifier)
                            .setColor(option);
                        Navigator.pop(ctx);
                        showSuccessToast(context,
                            'Theme color changed! Restart app for full effect.');
                      },
                      child: AnimatedContainer(
                        duration:
                            const Duration(milliseconds: 200),
                        width: option == ThemeColorOption.system
                            ? 110
                            : 52,
                        height: 52,
                        decoration: BoxDecoration(
                          color:
                              option == ThemeColorOption.system
                                  ? Colors.white.withValues(
                                      alpha: 0.05)
                                  : color,
                          borderRadius: BorderRadius.circular(
                              AppSpacing.radiusSm),
                          border: Border.all(
                            color: isSelected
                                ? Colors.white
                                : Colors.white.withValues(
                                    alpha: 0.08),
                            width: isSelected ? 3 : 1,
                          ),
                          boxShadow: isSelected
                              ? [
                                  BoxShadow(
                                    color: color.withValues(
                                        alpha: 0.5),
                                    blurRadius: 12,
                                    spreadRadius: 2,
                                  ),
                                ]
                              : null,
                        ),
                        child: option == ThemeColorOption.system
                            ? Center(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      LucideIcons.smartphone,
                                      color: Colors.white
                                          .withValues(
                                              alpha: 0.5),
                                      size: 16,
                                    ),
                                    const Gap(4),
                                    Text(
                                      'Auto',
                                      style: AppTypography
                                          .labelSmall
                                          .copyWith(
                                        color: Colors.white
                                            .withValues(
                                                alpha: 0.5),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : isSelected
                                ? const Icon(
                                    LucideIcons.check,
                                    color: Colors.white,
                                    size: 20,
                                  )
                                : null,
                      ),
                    );
                  }).toList(),
                ),
                const Gap(20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ────────────────────────────────────────────────────────────────
  // EDIT MESS SHEET
  // ────────────────────────────────────────────────────────────────

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

// ══════════════════════════════════════════════════════════════════
// EDIT MESS SHEET
// ══════════════════════════════════════════════════════════════════

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
      decoration: BoxDecoration(
        color: context.surfaceColor,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(AppSpacing.radiusLg),
        ),
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: context.borderColor,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const Gap(AppSpacing.lg),
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
            Text(
              'Mess Name',
              style: AppTypography.labelMedium.copyWith(
                color: context.textSecondary,
              ),
            ),
            const Gap(AppSpacing.sm),
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                hintText: 'Enter mess name',
                prefixIcon: const Icon(LucideIcons.building2),
                border: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(AppSpacing.radiusSm),
                ),
              ),
            ),
            const Gap(AppSpacing.lg),
            Text(
              'Address',
              style: AppTypography.labelMedium.copyWith(
                color: context.textSecondary,
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
                  borderRadius:
                      BorderRadius.circular(AppSpacing.radiusSm),
                ),
              ),
            ),
            const Gap(AppSpacing.xl),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _saveChanges,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(
                      vertical: AppSpacing.md),
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(AppSpacing.radiusSm),
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
