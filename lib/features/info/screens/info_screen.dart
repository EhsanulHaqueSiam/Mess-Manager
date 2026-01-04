import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:getwidget/getwidget.dart';

import 'package:mess_manager/core/theme/app_theme.dart';
import 'package:mess_manager/core/services/haptic_service.dart';
import 'package:mess_manager/core/widgets/gf_components.dart';

/// Info Screen - Uses GetWidget + VelocityX + flutter_animate
class InfoScreen extends ConsumerWidget {
  const InfoScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: [
          const Icon(LucideIcons.info, color: AppColors.primary, size: 22),
          8.widthBox,
          'Important Info'.text.make(),
        ].hStack(),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          // WiFi Password
          _buildQuickInfoCard(
            context,
            icon: LucideIcons.wifi,
            title: 'WiFi Password',
            value: 'MessWifi@2026',
            color: AppColors.primary,
            onCopy: true,
          ).animate().fadeIn().slideY(begin: 0.05),
          12.heightBox,

          // Landlord
          _buildContactCard(
            context,
            icon: LucideIcons.home,
            title: 'Landlord',
            name: 'Mr. Rahim',
            phone: '+880 1712-345678',
            note: 'Call for maintenance issues',
            color: AppColors.accentWarm,
          ).animate(delay: 100.ms).fadeIn().slideY(begin: 0.05),
          12.heightBox,

          // Emergency Contacts
          _buildSectionHeader('Emergency Contacts'),
          8.heightBox,
          _buildContactCard(
            context,
            icon: LucideIcons.phone,
            title: 'Police',
            name: 'Local Police Station',
            phone: '999',
            color: AppColors.moneyNegative,
          ).animate(delay: 150.ms).fadeIn(),
          8.heightBox,
          _buildContactCard(
            context,
            icon: LucideIcons.flame,
            title: 'Fire Service',
            name: 'Fire Department',
            phone: '199',
            color: AppColors.accentWarm,
          ).animate(delay: 200.ms).fadeIn(),
          8.heightBox,
          _buildContactCard(
            context,
            icon: LucideIcons.heartPulse,
            title: 'Ambulance',
            name: 'Emergency Medical',
            phone: '199',
            color: AppColors.moneyPositive,
          ).animate(delay: 250.ms).fadeIn(),
          16.heightBox,

          // House Rules
          _buildSectionHeader('House Rules'),
          8.heightBox,
          _buildRulesCard().animate(delay: 300.ms).fadeIn(),
          16.heightBox,

          // Utility Info
          _buildSectionHeader('Utility Information'),
          8.heightBox,
          _buildInfoTile(
            icon: LucideIcons.zap,
            title: 'DESCO Account',
            subtitle: 'Account: 12345678',
            color: AppColors.accentWarm,
          ),
          _buildInfoTile(
            icon: LucideIcons.droplet,
            title: 'WASA Account',
            subtitle: 'Account: 87654321',
            color: AppColors.primary,
          ),
          _buildInfoTile(
            icon: LucideIcons.flame,
            title: 'Gas (Titas)',
            subtitle: 'Meter: G-123456',
            color: AppColors.secondary,
          ),
          32.heightBox,
        ],
      ),
    );
  }

  Widget _buildQuickInfoCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String value,
    required Color color,
    bool onCopy = false,
  }) {
    return GFCard(
      padding: const EdgeInsets.all(AppSpacing.lg),
      margin: EdgeInsets.zero,
      gradient: LinearGradient(
        colors: [color.withValues(alpha: 0.15), color.withValues(alpha: 0.05)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      border: Border.all(color: color.withValues(alpha: 0.3)),
      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      content: HStack([
        GFAvatar(
          backgroundColor: color.withValues(alpha: 0.2),
          child: Icon(icon, color: color, size: 28),
        ),
        16.widthBox,
        VStack(crossAlignment: CrossAxisAlignment.start, [
          title.text.sm.color(AppColors.textSecondaryDark).make(),
          4.heightBox,
          value.text.xl.color(AppColors.textPrimaryDark).bold.make(),
        ]).expand(),
        if (onCopy)
          GFIconButton(
            icon: Icon(LucideIcons.copy, size: 20, color: color),
            type: GFButtonType.transparent,
            onPressed: () {
              HapticService.lightTap();
              Clipboard.setData(ClipboardData(text: value));
              showSuccessToast(context, 'Copied to clipboard!');
            },
          ),
      ]),
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
    return GFAppCard(
      child: HStack([
        GFAvatar(
          size: 44,
          backgroundColor: color.withValues(alpha: 0.15),
          child: Icon(icon, color: color, size: 24),
        ),
        12.widthBox,
        VStack(crossAlignment: CrossAxisAlignment.start, [
          title.text.xs.color(AppColors.textMutedDark).make(),
          name.text.color(AppColors.textPrimaryDark).bold.make(),
          if (note != null) note.text.sm.color(AppColors.textMutedDark).make(),
        ]).expand(),
        GFIconButton(
          icon: Icon(LucideIcons.phone, size: 20, color: color),
          type: GFButtonType.solid,
          color: color.withValues(alpha: 0.1),
          onPressed: () {
            HapticService.lightTap();
            Clipboard.setData(ClipboardData(text: phone));
            showSuccessToast(context, 'Copied $phone');
          },
        ),
      ]),
    );
  }

  Widget _buildSectionHeader(String title) {
    return HStack([
      Container(
        width: 4,
        height: 20,
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: AppColors.gradientPrimary),
          borderRadius: BorderRadius.circular(2),
        ),
      ),
      8.widthBox,
      title.text.xl.bold.color(AppColors.textPrimaryDark).make(),
    ]);
  }

  Widget _buildRulesCard() {
    final rules = [
      'No loud noises after 10 PM',
      'Guests must be informed in advance',
      'Keep common areas clean',
      'Pay rent by 5th of each month',
      'Garbage disposal on Tue/Fri',
      'AC usage: 25°C minimum',
    ];

    return GFAppCard(
      child: VStack(
        rules.asMap().entries.map((entry) {
          return HStack([
            GFBadge(
              text: '${entry.key + 1}',
              color: AppColors.primary.withValues(alpha: 0.1),
              textColor: AppColors.primary,
              size: GFSize.SMALL,
              shape: GFBadgeShape.circle,
            ),
            8.widthBox,
            entry.value.text.color(AppColors.textPrimaryDark).make().expand(),
          ]).py4();
        }).toList(),
      ),
    );
  }

  Widget _buildInfoTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
  }) {
    return GFAppCard(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: HStack([
        Icon(icon, color: color, size: 20),
        12.widthBox,
        VStack(crossAlignment: CrossAxisAlignment.start, [
          title.text.color(AppColors.textPrimaryDark).bold.make(),
          subtitle.text.sm.color(AppColors.textMutedDark).make(),
        ]).expand(),
      ]),
    );
  }
}
