import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:gap/gap.dart';

import 'package:mess_manager/core/theme/app_theme.dart';

/// Important Info Screen
/// Displays house information, landlord contacts, WiFi, house rules
class InfoScreen extends ConsumerWidget {
  const InfoScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Icon(LucideIcons.info, color: AppColors.primary, size: 22),
            const Gap(AppSpacing.sm),
            const Text('Important Info'),
          ],
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          // Quick Info Cards
          _buildQuickInfoCard(
            context,
            icon: LucideIcons.wifi,
            title: 'WiFi Password',
            value: 'MessWifi@2026',
            color: AppColors.primary,
            onCopy: true,
          ),
          const Gap(AppSpacing.md),

          // Landlord Contact
          _buildContactCard(
            context,
            icon: LucideIcons.home,
            title: 'Landlord',
            name: 'Mr. Rahim',
            phone: '+880 1712-345678',
            note: 'Call for maintenance issues',
            color: AppColors.accentWarm,
          ),
          const Gap(AppSpacing.md),

          // Emergency Contacts
          _buildSectionHeader('Emergency Contacts'),
          const Gap(AppSpacing.sm),
          _buildContactCard(
            context,
            icon: LucideIcons.phone,
            title: 'Police',
            name: 'Local Police Station',
            phone: '999',
            color: AppColors.moneyNegative,
          ),
          const Gap(AppSpacing.sm),
          _buildContactCard(
            context,
            icon: LucideIcons.flame,
            title: 'Fire Service',
            name: 'Fire Department',
            phone: '199',
            color: AppColors.accentWarm,
          ),
          const Gap(AppSpacing.sm),
          _buildContactCard(
            context,
            icon: LucideIcons.heartPulse,
            title: 'Ambulance',
            name: 'Emergency Medical',
            phone: '199',
            color: AppColors.moneyPositive,
          ),
          const Gap(AppSpacing.lg),

          // House Rules
          _buildSectionHeader('House Rules'),
          const Gap(AppSpacing.sm),
          _buildRulesCard(context),
          const Gap(AppSpacing.lg),

          // Utility Info
          _buildSectionHeader('Utility Information'),
          const Gap(AppSpacing.sm),
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
          const Gap(AppSpacing.xxl),
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
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            color.withValues(alpha: 0.15),
            color.withValues(alpha: 0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
            ),
            child: Icon(icon, color: color, size: 28),
          ),
          const Gap(AppSpacing.lg),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTypography.labelMedium.copyWith(
                    color: AppColors.textSecondaryDark,
                  ),
                ),
                const Gap(4),
                Text(
                  value,
                  style: AppTypography.headlineSmall.copyWith(
                    color: AppColors.textPrimaryDark,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          if (onCopy)
            IconButton(
              onPressed: () {
                Clipboard.setData(ClipboardData(text: value));
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Copied to clipboard!')),
                );
              },
              icon: const Icon(LucideIcons.copy, size: 20),
              color: color,
            ),
        ],
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
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.cardDark,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        border: Border.all(color: AppColors.borderDark.withValues(alpha: 0.5)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.sm),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const Gap(AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTypography.labelSmall.copyWith(
                    color: AppColors.textMutedDark,
                  ),
                ),
                Text(
                  name,
                  style: AppTypography.titleSmall.copyWith(
                    color: AppColors.textPrimaryDark,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (note != null) ...[
                  const Gap(2),
                  Text(
                    note,
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.textMutedDark,
                    ),
                  ),
                ],
              ],
            ),
          ),
          IconButton(
            onPressed: () {
              Clipboard.setData(ClipboardData(text: phone));
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text('Copied $phone')));
            },
            icon: const Icon(LucideIcons.phone, size: 20),
            style: IconButton.styleFrom(
              backgroundColor: color.withValues(alpha: 0.1),
              foregroundColor: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 20,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: AppColors.gradientPrimary,
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const Gap(AppSpacing.sm),
        Text(
          title,
          style: AppTypography.headlineSmall.copyWith(
            color: AppColors.textPrimaryDark,
          ),
        ),
      ],
    );
  }

  Widget _buildRulesCard(BuildContext context) {
    final rules = [
      'No loud noises after 10 PM',
      'Guests must be informed in advance',
      'Keep common areas clean',
      'Pay rent by 5th of each month',
      'Garbage disposal on Tue/Fri',
      'AC usage: 25°C minimum',
    ];

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.cardDark,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        border: Border.all(color: AppColors.borderDark.withValues(alpha: 0.5)),
      ),
      child: Column(
        children: rules.asMap().entries.map((entry) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
            child: Row(
              children: [
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text(
                      '${entry.key + 1}',
                      style: AppTypography.labelSmall.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const Gap(AppSpacing.sm),
                Expanded(
                  child: Text(
                    entry.value,
                    style: AppTypography.bodyMedium.copyWith(
                      color: AppColors.textPrimaryDark,
                    ),
                  ),
                ),
              ],
            ),
          );
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
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.cardDark,
        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 20),
          const Gap(AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTypography.titleSmall.copyWith(
                    color: AppColors.textPrimaryDark,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  subtitle,
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textMutedDark,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
