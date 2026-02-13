import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:gap/gap.dart';

import 'package:mess_manager/core/theme/app_theme.dart';
import 'package:mess_manager/core/widgets/app_components.dart';
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
        color: context.surfaceColor,
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
              color: context.borderColor,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const Gap(AppSpacing.md),

          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            child: Row(
              children: [
                Icon(
                  audit.isClean
                      ? LucideIcons.shieldCheck
                      : LucideIcons.shieldAlert,
                  color: audit.isClean ? AppColors.success : AppColors.warning,
                  size: 24,
                ),
                const Gap(12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Data Audit Report',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Checked at ${_formatTime(audit.auditedAt)}',
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.grey[500],
                        ),
                      ),
                    ],
                  ),
                ),
                if (audit.isClean)
                  AppBadge.success('Clean')
                else
                  AppBadge(
                    text: '${audit.issues.length} Issues',
                    color: (audit.criticalCount > 0
                            ? AppColors.error
                            : AppColors.warning)
                        .withValues(alpha: 0.1),
                    textColor: audit.criticalCount > 0
                        ? AppColors.error
                        : AppColors.warning,
                  ),
              ],
            ),
          ),
          const Gap(AppSpacing.md),

          // Stats Summary
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            child: Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: context.cardColor,
                borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                border: Border.all(color: context.borderColor),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildStatItem(
                        context,
                        'Members',
                        audit.memberCount.toString(),
                        LucideIcons.users,
                      ),
                      _buildStatItem(
                        context,
                        'Bazar',
                        audit.bazarEntryCount.toString(),
                        LucideIcons.shoppingCart,
                      ),
                      _buildStatItem(
                        context,
                        'Meals',
                        audit.mealCount.toString(),
                        LucideIcons.utensils,
                      ),
                      _buildStatItem(
                        context,
                        'Transactions',
                        audit.transactionCount.toString(),
                        LucideIcons.banknote,
                      ),
                    ],
                  ),
                  const Divider(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            Text(
                              '৳${audit.totalBazar.toStringAsFixed(0)}',
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'Total Bazar',
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.grey[500],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            Text(
                              '৳${audit.totalMealCost.toStringAsFixed(0)}',
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'Total Meal Cost',
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.grey[500],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            Text(
                              '৳${audit.actualDiscrepancy.abs().toStringAsFixed(0)}',
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: audit.actualDiscrepancy.abs() > 1
                                    ? AppColors.warning
                                    : AppColors.success,
                              ),
                            ),
                            Text(
                              'Discrepancy',
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.grey[500],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ).animate().fadeIn().slideY(begin: 0.05),
          const Gap(AppSpacing.md),

          // Issues List
          Expanded(
            child: audit.isClean
                ? _buildCleanState(context)
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.lg,
                    ),
                    itemCount: audit.issues.length,
                    itemBuilder: (context, index) {
                      final issue = audit.issues[index];
                      return _buildIssueCard(context, issue, index);
                    },
                  ),
          ),

          // Footer
          Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () {
                  HapticService.buttonPress();
                  Navigator.pop(context);
                },
                child: const Text('Close'),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(BuildContext context, String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, size: 16, color: context.textSecondary),
        const Gap(4),
        Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        Text(
          label,
          style: TextStyle(fontSize: 10, color: Colors.grey[500]),
        ),
      ],
    );
  }

  Widget _buildCleanState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            LucideIcons.checkCircle2,
            size: 64,
            color: AppColors.success,
          ),
          const Gap(16),
          Text(
            'All Clear!',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.success,
            ),
          ),
          const Gap(8),
          Text(
            'No data integrity issues found.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey[500]),
          ),
        ],
      ),
    ).animate().fadeIn().scale(begin: const Offset(0.9, 0.9));
  }

  Widget _buildIssueCard(BuildContext context, AuditIssue issue, int index) {
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
      child: Row(
        children: [
          Icon(icon, size: 20, color: color),
          const Gap(12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        issue.title,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: color,
                        ),
                      ),
                    ),
                    if (issue.isCritical)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.error,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text(
                          'CRITICAL',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                          ),
                        ),
                      ),
                  ],
                ),
                const Gap(4),
                Text(
                  issue.description,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[400],
                  ),
                ),
                if (issue.amount != null) ...[
                  const Gap(4),
                  Text(
                    'Amount: ৳${issue.amount!.abs().toStringAsFixed(0)}',
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
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
