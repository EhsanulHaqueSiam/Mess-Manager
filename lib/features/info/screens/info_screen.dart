import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:getwidget/getwidget.dart';

import 'package:mess_manager/features/info/providers/info_provider.dart';
import 'package:mess_manager/features/info/widgets/edit_info_sheet.dart';
import 'package:mess_manager/core/providers/members_provider.dart';
import 'package:mess_manager/core/models/member.dart';
import 'package:mess_manager/core/theme/app_theme.dart';
import 'package:mess_manager/core/services/haptic_service.dart';
import 'package:mess_manager/core/widgets/gf_components.dart';
import 'package:mess_manager/core/models/mess_info.dart';

/// Info Screen - Uses GetWidget + VelocityX + flutter_animate
class InfoScreen extends ConsumerWidget {
  const InfoScreen({super.key});

  void _showEditSheet(BuildContext context) {
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
      appBar: AppBar(
        title: [
          const Icon(LucideIcons.info, color: AppColors.primary, size: 22),
          8.widthBox,
          'Important Info'.text.make(),
        ].hStack(),
        actions: [
          if (canEdit)
            IconButton(
              icon: const Icon(LucideIcons.edit2, size: 20),
              onPressed: () => _showEditSheet(context),
            ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
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
          12.heightBox,

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
          12.heightBox,

          // Emergency Contacts
          _buildSectionHeader('Emergency Contacts'),
          8.heightBox,
          _buildContactCard(
            context,
            icon: LucideIcons.phone,
            title: 'Police',
            name: 'Local Police Station',
            phone: info.policePhone,
            color: AppColors.moneyNegative,
          ).animate(delay: 150.ms).fadeIn(),
          8.heightBox,
          _buildContactCard(
            context,
            icon: LucideIcons.flame,
            title: 'Fire Service',
            name: 'Fire Department',
            phone: info.fireServicePhone,
            color: AppColors.accentWarm,
          ).animate(delay: 200.ms).fadeIn(),
          8.heightBox,
          _buildContactCard(
            context,
            icon: LucideIcons.heartPulse,
            title: 'Ambulance',
            name: 'Emergency Medical',
            phone: info.ambulancePhone,
            color: AppColors.moneyPositive,
          ).animate(delay: 250.ms).fadeIn(),
          16.heightBox,

          // House Rules
          _buildSectionHeader('House Rules'),
          8.heightBox,
          _buildRulesCard(info).animate(delay: 300.ms).fadeIn(),
          16.heightBox,

          // Utility Info
          _buildSectionHeader('Utility Information'),
          8.heightBox,
          _buildInfoTile(
            icon: LucideIcons.zap,
            title: 'DESCO Account',
            subtitle: 'Account: ${info.descoAccount}',
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
    String? subValue,
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
          if (subValue != null) ...[
            2.heightBox,
            subValue.text.xs.gray500.make(),
          ],
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

  Widget _buildRulesCard(MessInfo info) {
    return GFAppCard(
      child: VStack([
        HStack([
          const Icon(LucideIcons.clock, size: 16, color: AppColors.warning),
          8.widthBox,
          'Gate closes at ${info.gateCloseTime}'.text
              .color(AppColors.textPrimaryDark)
              .make(),
        ]),
        8.heightBox,
        HStack([
          const Icon(LucideIcons.wifiOff, size: 16, color: AppColors.error),
          8.widthBox,
          'WiFi turns off at ${info.wifiOffTime}'.text
              .color(AppColors.textPrimaryDark)
              .make(),
        ]),
        12.heightBox,
        const Divider(color: AppColors.borderDark),
        12.heightBox,
        HStack([
          GFBadge(size: GFSize.SMALL, text: '1'),
          8.widthBox,
          info.rule1.text.color(AppColors.textSecondaryDark).make().expand(),
        ]),
        8.heightBox,
        HStack([
          GFBadge(size: GFSize.SMALL, text: '2'),
          8.widthBox,
          info.rule2.text.color(AppColors.textSecondaryDark).make().expand(),
        ]),
      ]),
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
