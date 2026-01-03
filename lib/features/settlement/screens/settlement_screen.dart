import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:gap/gap.dart';

import 'package:mess_manager/core/theme/app_theme.dart';
import 'package:mess_manager/core/providers/members_provider.dart';
import 'package:mess_manager/core/services/export_service.dart';
import 'package:mess_manager/features/settlement/providers/settlement_provider.dart';
import 'package:mess_manager/features/balance/providers/balance_provider.dart';

class SettlementScreen extends ConsumerWidget {
  const SettlementScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final balances = ref.watch(currentMonthBalancesProvider);
    final whoOwesWhom = ref.watch(whoOwesWhomProvider);
    final currentSettlement = ref.watch(currentMonthSettlementProvider);
    final members = ref.watch(membersProvider);
    final summary = ref.watch(balanceSummaryProvider);

    final now = DateTime.now();
    final monthName = _getMonthName(now.month);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Icon(
              LucideIcons.receipt,
              color: AppColors.textSecondaryDark,
              size: 22,
            ),
            const Gap(AppSpacing.sm),
            const Text('Settlement'),
          ],
        ),
        actions: [
          // Export buttons
          IconButton(
            onPressed: () => _exportPdf(
              context,
              ref,
              balances,
              whoOwesWhom,
              members,
              summary,
            ),
            icon: const Icon(LucideIcons.fileText, size: 20),
            tooltip: 'Export PDF',
          ),
          IconButton(
            onPressed: () => _exportCsv(context, ref, balances, members),
            icon: const Icon(LucideIcons.fileSpreadsheet, size: 20),
            tooltip: 'Export CSV',
          ),
          if (currentSettlement == null)
            TextButton.icon(
              onPressed: () => _createSettlement(context, ref, whoOwesWhom),
              icon: const Icon(LucideIcons.check, size: 18),
              label: const Text('Finalize'),
            ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          // Month Header Card
          _buildMonthCard(context, monthName, now.year, summary),
          const Gap(AppSpacing.lg),

          // Settlement Status
          if (currentSettlement != null) ...[
            _buildStatusCard(context, currentSettlement),
            const Gap(AppSpacing.lg),
          ],

          // Who Owes Whom Section
          _buildSectionHeader('Who Owes Whom'),
          const Gap(AppSpacing.sm),
          if (whoOwesWhom.isEmpty)
            _buildEmptyState('All balanced! No payments needed.')
          else
            ...whoOwesWhom.asMap().entries.map((entry) {
              final item = entry.value;
              final fromMember = members.firstWhere(
                (m) => m.id == item.fromMemberId,
                orElse: () => members.first,
              );
              final toMember = members.firstWhere(
                (m) => m.id == item.toMemberId,
                orElse: () => members.first,
              );
              return _buildPaymentItem(
                context,
                ref,
                fromMember.name,
                toMember.name,
                item.amount,
                item.isPaid,
                currentSettlement?.id,
                item.fromMemberId,
                item.toMemberId,
                entry.key,
              );
            }),
          const Gap(AppSpacing.lg),

          // Balance Summary Section
          _buildSectionHeader('Member Balances'),
          const Gap(AppSpacing.sm),
          ...balances.asMap().entries.map((entry) {
            final balance = entry.value;
            final member = members.firstWhere(
              (m) => m.id == balance.memberId,
              orElse: () => members.first,
            );
            return _buildBalanceItem(
              context,
              member.name,
              balance.totalBazar,
              balance.mealCost,
              balance.balance,
              entry.key,
            );
          }),
          const Gap(AppSpacing.xxl),
        ],
      ),
    );
  }

  Widget _buildMonthCard(
    BuildContext context,
    String monthName,
    int year,
    BalanceSummary summary,
  ) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.moneyNegative.withValues(alpha: 0.8),
            AppColors.moneyNegative.withValues(alpha: 0.6),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        boxShadow: [
          BoxShadow(
            color: AppColors.moneyNegative.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Settlement',
                    style: AppTypography.labelMedium.copyWith(
                      color: Colors.white.withValues(alpha: 0.8),
                    ),
                  ),
                  const Gap(AppSpacing.xs),
                  Text(
                    '$monthName $year',
                    style: AppTypography.displaySmall.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                ),
                child: const Icon(
                  LucideIcons.calculator,
                  color: Colors.white,
                  size: 28,
                ),
              ),
            ],
          ),
          const Gap(AppSpacing.lg),
          Container(height: 1, color: Colors.white.withValues(alpha: 0.2)),
          const Gap(AppSpacing.md),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildMonthStat(
                'Total Bazar',
                '৳${summary.totalBazar.toStringAsFixed(0)}',
              ),
              _buildMonthStat(
                'Meal Rate',
                '৳${summary.mealRate.toStringAsFixed(1)}',
              ),
              _buildMonthStat('Members', '${summary.memberCount}'),
            ],
          ),
        ],
      ),
    ).animate().fadeIn(duration: 400.ms).scale(begin: const Offset(0.95, 0.95));
  }

  Widget _buildMonthStat(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: AppTypography.titleLarge.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
        const Gap(2),
        Text(
          label,
          style: AppTypography.labelSmall.copyWith(
            color: Colors.white.withValues(alpha: 0.7),
          ),
        ),
      ],
    );
  }

  Widget _buildStatusCard(BuildContext context, dynamic settlement) {
    final status = settlement.status;
    final isCompleted = status.toString().contains('completed');
    final isPartial = status.toString().contains('partial');

    final statusColor = isCompleted
        ? AppColors.moneyPositive
        : isPartial
        ? AppColors.accentWarm
        : AppColors.primary;
    final statusText = isCompleted
        ? 'Completed'
        : isPartial
        ? 'Partially Paid'
        : 'Pending';

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: statusColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        border: Border.all(color: statusColor.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.sm),
            decoration: BoxDecoration(
              color: statusColor.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
            ),
            child: Icon(
              isCompleted
                  ? LucideIcons.checkCircle
                  : isPartial
                  ? LucideIcons.clock
                  : LucideIcons.alertCircle,
              color: statusColor,
              size: 20,
            ),
          ),
          const Gap(AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Settlement Status',
                  style: AppTypography.labelSmall.copyWith(
                    color: AppColors.textMutedDark,
                  ),
                ),
                Text(
                  statusText,
                  style: AppTypography.titleMedium.copyWith(
                    color: statusColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          if (isCompleted && settlement.settledAt != null)
            Text(
              'Settled ${_formatDate(settlement.settledAt!)}',
              style: AppTypography.labelSmall.copyWith(
                color: AppColors.textMutedDark,
              ),
            ),
        ],
      ),
    ).animate().fadeIn(delay: 100.ms).slideX(begin: 0.05);
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

  Widget _buildEmptyState(String message) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        color: AppColors.cardDark,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        border: Border.all(color: AppColors.borderDark.withValues(alpha: 0.5)),
      ),
      child: Column(
        children: [
          Icon(
            LucideIcons.checkCircle,
            color: AppColors.moneyPositive,
            size: 48,
          ),
          const Gap(AppSpacing.md),
          Text(
            message,
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.textSecondaryDark,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentItem(
    BuildContext context,
    WidgetRef ref,
    String fromName,
    String toName,
    double amount,
    bool isPaid,
    String? settlementId,
    String fromId,
    String toId,
    int index,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.cardDark,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        border: Border.all(
          color: isPaid
              ? AppColors.moneyPositive.withValues(alpha: 0.3)
              : AppColors.borderDark.withValues(alpha: 0.5),
        ),
      ),
      child: Row(
        children: [
          // From Avatar
          CircleAvatar(
            radius: 18,
            backgroundColor: AppColors.moneyNegative.withValues(alpha: 0.2),
            child: Text(
              fromName[0].toUpperCase(),
              style: AppTypography.labelMedium.copyWith(
                color: AppColors.moneyNegative,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const Gap(AppSpacing.sm),
          // Arrow and Amount
          Expanded(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      fromName,
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.textSecondaryDark,
                      ),
                    ),
                    const Gap(AppSpacing.xs),
                    Icon(
                      LucideIcons.arrowRight,
                      color: isPaid
                          ? AppColors.moneyPositive
                          : AppColors.primary,
                      size: 16,
                    ),
                    const Gap(AppSpacing.xs),
                    Text(
                      toName,
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.textSecondaryDark,
                      ),
                    ),
                  ],
                ),
                const Gap(2),
                Text(
                  '৳${amount.toStringAsFixed(0)}',
                  style: AppTypography.titleMedium.copyWith(
                    color: isPaid
                        ? AppColors.moneyPositive
                        : AppColors.textPrimaryDark,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          // To Avatar
          CircleAvatar(
            radius: 18,
            backgroundColor: AppColors.moneyPositive.withValues(alpha: 0.2),
            child: Text(
              toName[0].toUpperCase(),
              style: AppTypography.labelMedium.copyWith(
                color: AppColors.moneyPositive,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const Gap(AppSpacing.sm),
          // Action Button
          if (!isPaid && settlementId != null)
            IconButton(
              onPressed: () => _markAsPaid(ref, settlementId, fromId, toId),
              icon: const Icon(LucideIcons.check, size: 20),
              style: IconButton.styleFrom(
                backgroundColor: AppColors.moneyPositive.withValues(alpha: 0.1),
                foregroundColor: AppColors.moneyPositive,
              ),
            )
          else if (isPaid)
            Container(
              padding: const EdgeInsets.all(AppSpacing.sm),
              decoration: BoxDecoration(
                color: AppColors.moneyPositive.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
              ),
              child: const Icon(
                LucideIcons.checkCircle,
                color: AppColors.moneyPositive,
                size: 20,
              ),
            ),
        ],
      ),
    ).animate(delay: (80 * index).ms).fadeIn().slideX(begin: 0.03);
  }

  Widget _buildBalanceItem(
    BuildContext context,
    String name,
    double bazar,
    double mealCost,
    double balance,
    int index,
  ) {
    final isPositive = balance >= 0;

    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.cardDark,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        border: Border.all(color: AppColors.borderDark.withValues(alpha: 0.5)),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor:
                (isPositive ? AppColors.moneyPositive : AppColors.moneyNegative)
                    .withValues(alpha: 0.2),
            child: Text(
              name[0].toUpperCase(),
              style: AppTypography.titleSmall.copyWith(
                color: isPositive
                    ? AppColors.moneyPositive
                    : AppColors.moneyNegative,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const Gap(AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: AppTypography.titleSmall.copyWith(
                    color: AppColors.textPrimaryDark,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Gap(2),
                Text(
                  'Bazar: ৳${bazar.toStringAsFixed(0)} | Meals: ৳${mealCost.toStringAsFixed(0)}',
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textMutedDark,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${isPositive ? '+' : ''}৳${balance.toStringAsFixed(0)}',
                style: AppTypography.titleMedium.copyWith(
                  color: isPositive
                      ? AppColors.moneyPositive
                      : AppColors.moneyNegative,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                isPositive ? 'Credit' : 'Owes',
                style: AppTypography.labelSmall.copyWith(
                  color: isPositive
                      ? AppColors.moneyPositive
                      : AppColors.moneyNegative,
                ),
              ),
            ],
          ),
        ],
      ),
    ).animate(delay: (60 * index).ms).fadeIn().slideX(begin: 0.02);
  }

  void _createSettlement(BuildContext context, WidgetRef ref, List items) {
    if (items.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('All balances are settled!')),
      );
      return;
    }

    final now = DateTime.now();
    ref
        .read(settlementsProvider.notifier)
        .createSettlement(
          year: now.year,
          month: now.month,
          items: items.cast(),
        );

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Settlement created!')));
  }

  void _markAsPaid(
    WidgetRef ref,
    String settlementId,
    String fromId,
    String toId,
  ) {
    ref
        .read(settlementsProvider.notifier)
        .markItemPaid(settlementId, fromId, toId);
  }

  String _getMonthName(int month) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return months[month - 1];
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  Future<void> _exportPdf(
    BuildContext context,
    WidgetRef ref,
    List balances,
    List payments,
    List members,
    BalanceSummary summary,
  ) async {
    try {
      final now = DateTime.now();
      final pdfBytes = await ExportService.generateSettlementPdf(
        year: now.year,
        month: now.month,
        totalBazar: summary.totalBazar,
        mealRate: summary.mealRate,
        balances: balances.cast(),
        payments: payments.cast(),
        members: members.cast(),
      );

      // Show share dialog
      await ExportService.sharePdf(
        pdfBytes,
        'settlement_${now.year}_${now.month}.pdf',
      );
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Export failed: $e')));
      }
    }
  }

  Future<void> _exportCsv(
    BuildContext context,
    WidgetRef ref,
    List balances,
    List members,
  ) async {
    try {
      final now = DateTime.now();
      final csv = ExportService.generateBalancesCsv(
        balances: balances.cast(),
        members: members.cast(),
      );

      await ExportService.shareCsv(
        csv,
        'balances_${now.year}_${now.month}.csv',
      );
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Export failed: $e')));
      }
    }
  }
}
