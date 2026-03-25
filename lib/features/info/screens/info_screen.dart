import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:gap/gap.dart';

import 'package:mess_manager/features/info/providers/info_provider.dart';
import 'package:mess_manager/features/info/widgets/edit_info_sheet.dart';
import 'package:mess_manager/core/providers/members_provider.dart';
import 'package:mess_manager/core/models/member.dart';
import 'package:mess_manager/core/theme/app_theme.dart';
import 'package:mess_manager/core/services/haptic_service.dart';
import 'package:mess_manager/core/widgets/app_components.dart';
import 'package:mess_manager/core/models/mess_info.dart';

/// Info Screen
class InfoScreen extends ConsumerWidget {
  const InfoScreen({super.key});

  void _showEditSheet(BuildContext context) {
    HapticService.modalOpen();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const EditInfoSheet(),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final info = ref.watch(messInfoProvider);
    final currentMember = ref.watch(currentMemberProvider);
    final canEdit =
        currentMember?.role == MemberRole.superAdmin ||
        currentMember?.role == MemberRole.admin;

    return Scaffold(
      backgroundColor: const Color(0xFF0A0E1A),
      body: Stack(
        children: [
          // Background gradient
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFF0A0E1A), Color(0xFF0D1520)],
                ),
              ),
            ),
          ),

          // Breathing accent orb - top right
          Positioned(
            top: -60,
            right: -40,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppColors.info.withValues(alpha: 0.12),
                    AppColors.info.withValues(alpha: 0.0),
                  ],
                ),
              ),
            )
                .animate(onPlay: (c) => c.repeat(reverse: true))
                .scaleXY(begin: 0.8, end: 1.2, duration: 4000.ms, curve: Curves.easeInOut),
          ),

          // Breathing accent orb - bottom left
          Positioned(
            bottom: 100,
            left: -60,
            child: Container(
              width: 180,
              height: 180,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppColors.info.withValues(alpha: 0.08),
                    AppColors.info.withValues(alpha: 0.0),
                  ],
                ),
              ),
            )
                .animate(onPlay: (c) => c.repeat(reverse: true))
                .scaleXY(begin: 1.0, end: 1.3, duration: 5000.ms, curve: Curves.easeInOut),
          ),

          // Main content
          SafeArea(
            child: ListView(
              padding: const EdgeInsets.all(AppSpacing.md),
              children: [
                // Custom header
                _buildHeader(context, canEdit),
                const Gap(24),

                // WiFi Password
                _buildQuickInfoCard(
                  context,
                  icon: LucideIcons.wifi,
                  title: 'WiFi Password',
                  value: info.wifiPassword,
                  subValue: 'Auto-off: ${info.wifiOffTime}',
                  color: AppColors.primary,
                  onCopy: true,
                ).animate().fadeIn().slideY(begin: 0.05),
                const Gap(12),

                // Landlord
                _buildContactCard(
                  context,
                  icon: LucideIcons.home,
                  title: 'Landlord',
                  name: info.landlordName,
                  phone: info.landlordPhone,
                  note: 'Call for maintenance issues',
                  color: AppColors.accentWarm,
                ).animate(delay: 100.ms).fadeIn().slideY(begin: 0.05),
                const Gap(12),

                // Emergency Contacts
                _buildSectionHeader(context, 'Emergency Contacts'),
                const Gap(8),
                _buildContactCard(
                  context,
                  icon: LucideIcons.phone,
                  title: 'Police',
                  name: 'Local Police Station',
                  phone: info.policePhone,
                  color: AppColors.moneyNegative,
                ).animate(delay: 150.ms).fadeIn(),
                const Gap(8),
                _buildContactCard(
                  context,
                  icon: LucideIcons.flame,
                  title: 'Fire Service',
                  name: 'Fire Department',
                  phone: info.fireServicePhone,
                  color: AppColors.accentWarm,
                ).animate(delay: 200.ms).fadeIn(),
                const Gap(8),
                _buildContactCard(
                  context,
                  icon: LucideIcons.heartPulse,
                  title: 'Ambulance',
                  name: 'Emergency Medical',
                  phone: info.ambulancePhone,
                  color: AppColors.moneyPositive,
                ).animate(delay: 250.ms).fadeIn(),
                const Gap(16),

                // House Rules
                _buildSectionHeader(context, 'House Rules'),
                const Gap(8),
                _buildRulesCard(context, info).animate(delay: 300.ms).fadeIn(),
                const Gap(16),

                // Utility Info
                _buildSectionHeader(context, 'Utility Information'),
                const Gap(8),
                _buildInfoTile(
                  context,
                  icon: LucideIcons.zap,
                  title: 'DESCO Account',
                  subtitle: 'Account: ${info.descoAccount}',
                  color: AppColors.accentWarm,
                ),
                _buildInfoTile(
                  context,
                  icon: LucideIcons.droplet,
                  title: 'WASA Account',
                  subtitle: 'Account: 87654321',
                  color: AppColors.primary,
                ),
                _buildInfoTile(
                  context,
                  icon: LucideIcons.flame,
                  title: 'Gas (Titas)',
                  subtitle: 'Meter: G-123456',
                  color: AppColors.secondary,
                ),
                const Gap(32),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, bool canEdit) {
    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.sm),
      child: Row(
        children: [
          IconButton(
            icon: Icon(LucideIcons.arrowLeft, color: Colors.white.withValues(alpha: 0.9)),
            onPressed: () => Navigator.of(context).pop(),
          ),
          const Gap(4),
          // Gradient halo icon circle
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  AppColors.info.withValues(alpha: 0.3),
                  AppColors.info.withValues(alpha: 0.05),
                ],
              ),
              border: Border.all(
                color: AppColors.info.withValues(alpha: 0.3),
                width: 1.5,
              ),
            ),
            child: const Icon(LucideIcons.info, color: AppColors.info, size: 22),
          ),
          const Gap(12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Important Info',
                  style: AppTypography.titleLarge.copyWith(
                    color: Colors.white.withValues(alpha: 0.9),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Contacts, rules & utilities',
                  style: AppTypography.bodySmall.copyWith(
                    color: Colors.white.withValues(alpha: 0.4),
                  ),
                ),
              ],
            ),
          ),
          if (canEdit)
            GestureDetector(
              onTap: () => _showEditSheet(context),
              child: Container(
                width: 40,
                height: 40,
                decoration: AppSpacing.accentCard(accent: AppColors.info, radius: AppSpacing.radiusFull),
                child: Icon(
                  LucideIcons.edit2,
                  size: 18,
                  color: Colors.white.withValues(alpha: 0.6),
                ),
              ),
            ),
        ],
      ),
    ).animate().fadeIn(duration: 400.ms).slideY(begin: -0.1);
  }

  Widget _buildGlassCard({
    required Widget child,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
  }) {
    return Padding(
      padding: margin ?? EdgeInsets.zero,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
          child: Container(
            padding: padding ?? const EdgeInsets.all(AppSpacing.md),
            decoration: AppSpacing.accentCard(accent: AppColors.info),
            child: child,
          ),
        ),
      ),
    );
  }

  Widget _buildQuickInfoCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String value,
    String? subValue,
    required Color color,
    bool onCopy = false,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.lg),
          decoration: AppSpacing.accentCard(accent: color),
          child: Row(
            children: [
              // Gradient halo icon
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      color.withValues(alpha: 0.25),
                      color.withValues(alpha: 0.05),
                    ],
                  ),
                  border: Border.all(
                    color: color.withValues(alpha: 0.2),
                  ),
                ),
                child: Icon(icon, color: color, size: 28),
              ),
              const Gap(16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTypography.bodySmall.copyWith(
                        color: Colors.white.withValues(alpha: 0.5),
                      ),
                    ),
                    const Gap(4),
                    Text(
                      value,
                      style: AppTypography.titleLarge.copyWith(
                        color: Colors.white.withValues(alpha: 0.9),
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.0,
                      ),
                    ),
                    if (subValue != null) ...[
                      const Gap(2),
                      Text(
                        subValue,
                        style: AppTypography.bodySmall.copyWith(
                          color: Colors.white.withValues(alpha: 0.3),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              if (onCopy)
                GestureDetector(
                  onTap: () {
                    HapticService.lightTap();
                    Clipboard.setData(ClipboardData(text: value));
                    showSuccessToast(context, 'Copied to clipboard!');
                  },
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: color.withValues(alpha: 0.1),
                      border: Border.all(color: color.withValues(alpha: 0.2)),
                    ),
                    child: Icon(LucideIcons.copy, size: 18, color: color),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContactCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String name,
    required String phone,
    String? note,
    required Color color,
  }) {
    return _buildGlassCard(
      child: Row(
        children: [
          // Gradient icon halo
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  color.withValues(alpha: 0.2),
                  color.withValues(alpha: 0.03),
                ],
              ),
              border: Border.all(color: color.withValues(alpha: 0.15)),
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          const Gap(12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTypography.bodySmall.copyWith(
                    color: Colors.white.withValues(alpha: 0.3),
                  ),
                ),
                Text(
                  name,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.9),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (note != null)
                  Text(
                    note,
                    style: AppTypography.bodySmall.copyWith(
                      color: Colors.white.withValues(alpha: 0.3),
                    ),
                  ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              HapticService.lightTap();
              Clipboard.setData(ClipboardData(text: phone));
              showSuccessToast(context, 'Copied $phone');
            },
            child: Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: color.withValues(alpha: 0.1),
                border: Border.all(color: color.withValues(alpha: 0.15)),
              ),
              child: Icon(LucideIcons.phone, size: 18, color: color),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Row(
      children: [
        Container(
          width: 3,
          height: 14,
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(1.5),
          ),
        ),
        const Gap(8),
        Text(
          title,
          style: AppTypography.labelMedium.copyWith(
            color: Colors.white.withValues(alpha: 0.5),
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildRulesCard(BuildContext context, MessInfo info) {
    return _buildGlassCard(
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.warning.withValues(alpha: 0.1),
                  border: Border.all(color: AppColors.warning.withValues(alpha: 0.15)),
                ),
                child: const Icon(LucideIcons.clock, size: 14, color: AppColors.warning),
              ),
              const Gap(10),
              Text(
                'Gate closes at ${info.gateCloseTime}',
                style: TextStyle(color: Colors.white.withValues(alpha: 0.9)),
              ),
            ],
          ),
          const Gap(10),
          Row(
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.error.withValues(alpha: 0.1),
                  border: Border.all(color: AppColors.error.withValues(alpha: 0.15)),
                ),
                child: const Icon(LucideIcons.wifiOff, size: 14, color: AppColors.error),
              ),
              const Gap(10),
              Text(
                'WiFi turns off at ${info.wifiOffTime}',
                style: TextStyle(color: Colors.white.withValues(alpha: 0.9)),
              ),
            ],
          ),
          const Gap(14),
          Divider(color: Colors.white.withValues(alpha: 0.06)),
          const Gap(14),
          _buildRuleRow(context, '1', info.rule1),
          const Gap(10),
          _buildRuleRow(context, '2', info.rule2),
        ],
      ),
    );
  }

  Widget _buildRuleRow(BuildContext context, String number, String rule) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [
                AppColors.primary.withValues(alpha: 0.3),
                AppColors.accentAlt.withValues(alpha: 0.15),
              ],
            ),
            border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
          ),
          alignment: Alignment.center,
          child: Text(
            number,
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.accentAlt,
              fontWeight: FontWeight.bold,
              fontSize: 11,
            ),
          ),
        ),
        const Gap(10),
        Expanded(
          child: Text(
            rule,
            style: TextStyle(color: Colors.white.withValues(alpha: 0.5)),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: _buildGlassCard(
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: color.withValues(alpha: 0.1),
                border: Border.all(color: color.withValues(alpha: 0.15)),
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
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.9),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: AppTypography.bodySmall.copyWith(
                      color: Colors.white.withValues(alpha: 0.3),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
