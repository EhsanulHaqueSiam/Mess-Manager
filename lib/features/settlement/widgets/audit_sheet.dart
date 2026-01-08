import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:gap/gap.dart';
import 'package:getwidget/getwidget.dart';

import 'package:mess_manager/core/theme/app_theme.dart';
import 'package:mess_manager/core/services/haptic_service.dart';
import 'package:mess_manager/features/settlement/providers/audit_provider.dart';

/// Audit Sheet - Shows comprehensive data integrity report
class AuditSheet extends ConsumerWidget {
  const AuditSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final audit = ref.watch(auditProvider);

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.85,
      ),
      decoration: BoxDecoration(
        color: AppColors.surfaceDark,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(AppSpacing.radiusLg),
        ),
      ),
      child: Column(
        children: [
          // Handle
          Container(
            margin: const EdgeInsets.only(top: AppSpacing.md),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.borderDark,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const Gap(AppSpacing.md),

          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            child: HStack([
              Icon(
                audit.isClean
                    ? LucideIcons.shieldCheck
                    : LucideIcons.shieldAlert,
                color: audit.isClean ? AppColors.success : AppColors.warning,
                size: 24,
              ),
              12.widthBox,
              VStack(crossAlignment: CrossAxisAlignment.start, [
                'Data Audit Report'.text.xl.bold.make(),
                'Checked at ${_formatTime(audit.auditedAt)}'.text.xs.gray500
                    .make(),
              ]).expand(),
              if (audit.isClean)
                GFBadge(text: 'Clean', color: AppColors.success)
              else
                GFBadge(
                  text: '${audit.issues.length} Issues',
                  color: audit.criticalCount > 0
                      ? AppColors.error
                      : AppColors.warning,
                ),
            ]),
          ),
          const Gap(AppSpacing.md),

          // Stats Summary
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            child: Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: AppColors.cardDark,
                borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                border: Border.all(color: AppColors.borderDark),
              ),
              child: Column(
                children: [
                  HStack([
                    _buildStatItem(
                      'Members',
                      audit.memberCount.toString(),
                      LucideIcons.users,
                    ),
                    _buildStatItem(
                      'Bazar',
                      audit.bazarEntryCount.toString(),
                      LucideIcons.shoppingCart,
                    ),
                    _buildStatItem(
                      'Meals',
                      audit.mealCount.toString(),
                      LucideIcons.utensils,
                    ),
                    _buildStatItem(
                      'Transactions',
                      audit.transactionCount.toString(),
                      LucideIcons.banknote,
                    ),
                  ], alignment: MainAxisAlignment.spaceAround),
                  const Divider(height: 24),
                  HStack([
                    VStack([
                      '৳${audit.totalBazar.toStringAsFixed(0)}'.text.lg.bold
                          .make(),
                      'Total Bazar'.text.xs.gray500.make(),
                    ]).expand(),
                    VStack([
                      '৳${audit.totalMealCost.toStringAsFixed(0)}'.text.lg.bold
                          .make(),
                      'Total Meal Cost'.text.xs.gray500.make(),
                    ]).expand(),
                    VStack([
                      '৳${audit.actualDiscrepancy.abs().toStringAsFixed(0)}'
                          .text
                          .lg
                          .bold
                          .color(
                            audit.actualDiscrepancy.abs() > 1
                                ? AppColors.warning
                                : AppColors.success,
                          )
                          .make(),
                      'Discrepancy'.text.xs.gray500.make(),
                    ]).expand(),
                  ]),
                ],
              ),
            ),
          ).animate().fadeIn().slideY(begin: 0.05),
          const Gap(AppSpacing.md),

          // Issues List
          Expanded(
            child: audit.isClean
                ? _buildCleanState()
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.lg,
                    ),
                    itemCount: audit.issues.length,
                    itemBuilder: (context, index) {
                      final issue = audit.issues[index];
                      return _buildIssueCard(issue, index);
                    },
                  ),
          ),

          // Footer
          Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: GFButton(
              onPressed: () {
                HapticService.buttonPress();
                Navigator.pop(context);
              },
              text: 'Close',
              fullWidthButton: true,
              type: GFButtonType.outline,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return VStack(crossAlignment: CrossAxisAlignment.center, [
      Icon(icon, size: 16, color: AppColors.textSecondaryDark),
      4.heightBox,
      value.text.semiBold.make(),
      label.text.xs.gray500.make(),
    ]);
  }

  Widget _buildCleanState() {
    return Center(
      child: VStack(crossAlignment: CrossAxisAlignment.center, [
        const Icon(
          LucideIcons.checkCircle2,
          size: 64,
          color: AppColors.success,
        ),
        16.heightBox,
        'All Clear!'.text.xl.bold.color(AppColors.success).make(),
        8.heightBox,
        'No data integrity issues found.'.text.gray500.center.make(),
      ]),
    ).animate().fadeIn().scale(begin: const Offset(0.9, 0.9));
  }

  Widget _buildIssueCard(AuditIssue issue, int index) {
    final color = issue.isCritical ? AppColors.error : AppColors.warning;
    final icon = _getIssueIcon(issue.type);

    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: HStack([
        Icon(icon, size: 20, color: color),
        12.widthBox,
        VStack(crossAlignment: CrossAxisAlignment.start, [
          HStack([
            issue.title.text.semiBold.color(color).make().expand(),
            if (issue.isCritical)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.error,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: 'CRITICAL'.text.white.xs.make(),
              ),
          ]),
          4.heightBox,
          issue.description.text.sm.gray400.make(),
          if (issue.amount != null) ...[
            4.heightBox,
            'Amount: ৳${issue.amount!.abs().toStringAsFixed(0)}'.text.xs.gray500
                .make(),
          ],
        ]).expand(),
      ]),
    ).animate(delay: (index * 50).ms).fadeIn().slideX(begin: 0.05);
  }

  IconData _getIssueIcon(AuditIssueType type) {
    switch (type) {
      case AuditIssueType.balanceMismatch:
        return LucideIcons.scale;
      case AuditIssueType.negativeBalance:
        return LucideIcons.trendingDown;
      case AuditIssueType.orphanedEntry:
        return LucideIcons.unlink;
      case AuditIssueType.duplicateEntry:
        return LucideIcons.copy;
      case AuditIssueType.futureDate:
        return LucideIcons.calendarX;
      case AuditIssueType.zeroAmount:
        return LucideIcons.alertCircle;
      case AuditIssueType.missingMember:
        return LucideIcons.userX;
    }
  }

  String _formatTime(DateTime dt) {
    return '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
  }
}
