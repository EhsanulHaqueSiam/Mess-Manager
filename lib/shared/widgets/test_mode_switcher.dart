import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:mess_manager/core/theme/app_theme.dart';
import 'package:mess_manager/core/providers/test_user_provider.dart';
import 'package:mess_manager/core/services/haptic_service.dart';

/// Test Mode Switcher — Mission Control Terminal
///
/// Development-only widget for testing different user roles.
/// Guarded by kDebugMode in dashboard_screen.dart.
class TestModeSwitcher extends ConsumerWidget {
  const TestModeSwitcher({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentTestUserProvider);
    final roleColor = _getRoleColor(currentUser.role);

    return GestureDetector(
      onTap: () => _showRoleSwitcher(context, ref),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: roleColor.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: roleColor.withValues(alpha: 0.25)),
              boxShadow: [
                BoxShadow(
                  color: roleColor.withValues(alpha: 0.15),
                  blurRadius: 12,
                  spreadRadius: -2,
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Pulsing DEV beacon
                Container(
                  width: 6,
                  height: 6,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: roleColor,
                    boxShadow: [
                      BoxShadow(
                        color: roleColor.withValues(alpha: 0.6),
                        blurRadius: 6,
                      ),
                    ],
                  ),
                )
                    .animate(onPlay: (c) => c.repeat(reverse: true))
                    .fadeIn(begin: 0.4, duration: 800.ms),
                const Gap(6),
                Text(
                  'DEV',
                  style: GoogleFonts.jetBrainsMono(
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                    color: roleColor.withValues(alpha: 0.6),
                    letterSpacing: 1.5,
                  ),
                ),
                Container(
                  width: 1,
                  height: 12,
                  margin: const EdgeInsets.symmetric(horizontal: 6),
                  color: Colors.white.withValues(alpha: 0.08),
                ),
                Icon(
                  _getRoleIcon(currentUser.role),
                  size: 12,
                  color: roleColor,
                ),
                const Gap(4),
                Text(
                  _getRoleLabel(currentUser.role),
                  style: GoogleFonts.jetBrainsMono(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: roleColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showRoleSwitcher(BuildContext context, WidgetRef ref) {
    HapticService.modalOpen();
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) => _RoleSwitcherSheet(ref: ref),
    );
  }

  static Color _getRoleColor(UserRole role) {
    switch (role) {
      case UserRole.superAdmin:
        return AppColors.error;
      case UserRole.admin:
        return AppColors.warning;
      case UserRole.member:
        return AppColors.success;
      case UserRole.guest:
        return Colors.white.withValues(alpha: 0.4);
    }
  }

  static IconData _getRoleIcon(UserRole role) {
    switch (role) {
      case UserRole.superAdmin:
        return LucideIcons.crown;
      case UserRole.admin:
        return LucideIcons.shield;
      case UserRole.member:
        return LucideIcons.user;
      case UserRole.guest:
        return LucideIcons.eye;
    }
  }

  static String _getRoleLabel(UserRole role) {
    switch (role) {
      case UserRole.superAdmin:
        return 'S.ADMIN';
      case UserRole.admin:
        return 'ADMIN';
      case UserRole.member:
        return 'MEMBER';
      case UserRole.guest:
        return 'GUEST';
    }
  }

  static String _getRoleName(UserRole role) {
    switch (role) {
      case UserRole.superAdmin:
        return 'Super Admin';
      case UserRole.admin:
        return 'Admin';
      case UserRole.member:
        return 'Member';
      case UserRole.guest:
        return 'Guest';
    }
  }

  static String _getClearanceLevel(UserRole role) {
    switch (role) {
      case UserRole.superAdmin:
        return 'CLEARANCE LVL 4';
      case UserRole.admin:
        return 'CLEARANCE LVL 3';
      case UserRole.member:
        return 'CLEARANCE LVL 2';
      case UserRole.guest:
        return 'CLEARANCE LVL 1';
    }
  }

  static String _getAccessScope(UserRole role) {
    switch (role) {
      case UserRole.superAdmin:
        return 'Full system access · Role assignment · Data export';
      case UserRole.admin:
        return 'Member management · Entry creation · Reports';
      case UserRole.member:
        return 'Own entries · View balances · Basic features';
      case UserRole.guest:
        return 'Read-only access · View dashboard';
    }
  }
}

// ─────────────────────────────────────────────────────────────────
// ROLE SWITCHER BOTTOM SHEET
// ─────────────────────────────────────────────────────────────────

class _RoleSwitcherSheet extends ConsumerWidget {
  final WidgetRef ref;

  const _RoleSwitcherSheet({required this.ref});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentTestUserProvider);

    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFF0D1520).withValues(alpha: 0.95),
            borderRadius:
                const BorderRadius.vertical(top: Radius.circular(24)),
            border: Border(
              top: BorderSide(color: Colors.white.withValues(alpha: 0.08)),
              left: BorderSide(color: Colors.white.withValues(alpha: 0.04)),
              right: BorderSide(color: Colors.white.withValues(alpha: 0.04)),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Gap(12),
              // Gradient handle bar
              Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(2),
                  gradient: LinearGradient(
                    colors: [
                      AppColors.warning.withValues(alpha: 0.4),
                      AppColors.warning.withValues(alpha: 0.1),
                    ],
                  ),
                ),
              ),
              const Gap(20),

              // Header — terminal style
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    // Terminal icon with scan-line effect
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            AppColors.warning.withValues(alpha: 0.2),
                            AppColors.warning.withValues(alpha: 0.05),
                          ],
                        ),
                        border: Border.all(
                          color: AppColors.warning.withValues(alpha: 0.25),
                        ),
                      ),
                      child: Icon(
                        LucideIcons.terminal,
                        size: 18,
                        color: AppColors.warning,
                      ),
                    ),
                    const Gap(12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'ROLE TERMINAL',
                            style: GoogleFonts.jetBrainsMono(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: AppColors.warning,
                              letterSpacing: 2,
                            ),
                          ),
                          const Gap(2),
                          Text(
                            'Switch identity to test different access levels',
                            style: AppTypography.bodySmall.copyWith(
                              color: Colors.white.withValues(alpha: 0.35),
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ).animate().fadeIn(duration: 300.ms),

              const Gap(16),

              // Divider with gradient
              Container(
                height: 1,
                margin: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.transparent,
                      AppColors.warning.withValues(alpha: 0.15),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),

              const Gap(12),

              // Role cards
              ...TestUsers.all.asMap().entries.map((entry) {
                final index = entry.key;
                final user = entry.value;
                final isSelected = currentUser.id == user.id;
                final roleColor =
                    TestModeSwitcher._getRoleColor(user.role);

                return _buildRoleCard(
                  context,
                  ref,
                  user,
                  isSelected,
                  roleColor,
                  index,
                );
              }),

              const Gap(16),

              // Footer — session info
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 4,
                      height: 4,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.success,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.success.withValues(alpha: 0.5),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                    ),
                    const Gap(6),
                    Text(
                      'DEBUG SESSION ACTIVE',
                      style: GoogleFonts.jetBrainsMono(
                        fontSize: 9,
                        fontWeight: FontWeight.w500,
                        color: Colors.white.withValues(alpha: 0.2),
                        letterSpacing: 1.5,
                      ),
                    ),
                  ],
                ),
              ).animate().fadeIn(delay: 400.ms),

              const Gap(20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRoleCard(
    BuildContext context,
    WidgetRef ref,
    TestUser user,
    bool isSelected,
    Color roleColor,
    int index,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 3),
      child: GestureDetector(
        onTap: () {
          HapticService.success();
          ref.read(currentTestUserProvider.notifier).switchUser(user);
          Navigator.pop(context);
        },
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: isSelected
                    ? roleColor.withValues(alpha: 0.1)
                    : Colors.white.withValues(alpha: 0.02),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isSelected
                      ? roleColor.withValues(alpha: 0.35)
                      : Colors.white.withValues(alpha: 0.04),
                  width: isSelected ? 1.5 : 1,
                ),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: roleColor.withValues(alpha: 0.1),
                          blurRadius: 16,
                          spreadRadius: -4,
                        ),
                      ]
                    : null,
              ),
              child: Row(
                children: [
                  // Role icon with halo
                  Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          roleColor.withValues(alpha: isSelected ? 0.25 : 0.12),
                          roleColor.withValues(alpha: 0.02),
                        ],
                      ),
                      border: Border.all(
                        color: roleColor.withValues(
                            alpha: isSelected ? 0.4 : 0.15),
                      ),
                    ),
                    child: Icon(
                      TestModeSwitcher._getRoleIcon(user.role),
                      size: 16,
                      color: roleColor,
                    ),
                  ),
                  const Gap(12),
                  // Name + clearance
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user.name,
                          style: AppTypography.bodyMedium.copyWith(
                            color: isSelected
                                ? Colors.white.withValues(alpha: 0.95)
                                : Colors.white.withValues(alpha: 0.7),
                            fontWeight:
                                isSelected ? FontWeight.w600 : FontWeight.w400,
                          ),
                        ),
                        const Gap(2),
                        Text(
                          TestModeSwitcher._getAccessScope(user.role),
                          style: AppTypography.bodySmall.copyWith(
                            color: Colors.white.withValues(alpha: 0.3),
                            fontSize: 10,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  // Clearance badge
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      color: roleColor.withValues(alpha: isSelected ? 0.15 : 0.06),
                      border: Border.all(
                        color: roleColor.withValues(
                            alpha: isSelected ? 0.3 : 0.1),
                      ),
                    ),
                    child: Text(
                      TestModeSwitcher._getClearanceLevel(user.role),
                      style: GoogleFonts.jetBrainsMono(
                        fontSize: 8,
                        fontWeight: FontWeight.w600,
                        color: roleColor.withValues(
                            alpha: isSelected ? 0.9 : 0.5),
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                  if (isSelected) ...[
                    const Gap(8),
                    Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: roleColor,
                        boxShadow: [
                          BoxShadow(
                            color: roleColor.withValues(alpha: 0.6),
                            blurRadius: 6,
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    )
        .animate(delay: (60 * index).ms)
        .fadeIn(duration: 300.ms)
        .slideX(begin: 0.02);
  }
}
