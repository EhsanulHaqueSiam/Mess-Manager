import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:getwidget/getwidget.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:gap/gap.dart';
import 'package:printing/printing.dart';
import 'package:velocity_x/velocity_x.dart';

import 'package:mess_manager/core/theme/app_theme.dart';
import 'package:mess_manager/core/providers/members_provider.dart';
import 'package:mess_manager/core/services/export_service.dart';
import 'package:mess_manager/features/balance/providers/balance_provider.dart';
import 'package:mess_manager/features/settlement/providers/settlement_provider.dart';

/// Month-End Summary Screen - Printable A4 format
class MonthSummaryScreen extends ConsumerWidget {
  const MonthSummaryScreen({super.key});

  static const _months = [
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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final now = DateTime.now();
    final balances = ref.watch(memberBalancesProvider);
    final summary = ref.watch(balanceSummaryProvider);
    final members = ref.watch(membersProvider);
    final settlementBalances = ref.watch(currentMonthBalancesProvider);
    final payments = ref.watch(whoOwesWhomProvider);

    return Scaffold(
      appBar: AppBar(
        title: 'Month-End Summary'.text.make(),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(LucideIcons.share2),
            onSelected: (value) => _handleExport(
              context,
              ref,
              value,
              balances,
              summary,
              members,
              settlementBalances,
              payments,
            ),
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'print',
                child: Text('🖨️ Print / PDF'),
              ),
              const PopupMenuItem(
                value: 'excel',
                child: Text('📊 Export Excel'),
              ),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header Card
            _buildHeader(now, summary).animate().fadeIn().slideY(begin: -0.1),
            const Gap(AppSpacing.lg),

            // Balance Table
            _buildBalanceTable(
              balances,
              summary,
            ).animate().fadeIn(delay: 100.ms),
            const Gap(AppSpacing.lg),

            // Summary Stats
            _buildSummaryStats(summary).animate().fadeIn(delay: 200.ms),
            const Gap(AppSpacing.xl),

            // Signature Block
            _buildSignatureBlock().animate().fadeIn(delay: 300.ms),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(DateTime now, BalanceSummary summary) {
    final monthName = _months[now.month - 1];
    return GFCard(
      padding: const EdgeInsets.all(AppSpacing.lg),
      content: Column(
        children: [
          'Area51 Mess'.text.xl2.bold.make(),
          const Gap(4),
          '$monthName ${now.year} - Financial Summary'.text.lg.gray500.make(),
          const Divider(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildHeaderStat(
                'Total Bazar',
                '৳${summary.totalBazar.toStringAsFixed(0)}',
              ),
              _buildHeaderStat(
                'Meal Rate',
                '৳${summary.mealRate.toStringAsFixed(2)}',
              ),
              _buildHeaderStat(
                'Fixed Costs',
                '৳${summary.totalFixedExpenses.toStringAsFixed(0)}',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderStat(String label, String value) {
    return Column(
      children: [
        value.text.xl.bold.color(AppColors.primary).make(),
        label.text.sm.gray500.make(),
      ],
    );
  }

  Widget _buildBalanceTable(
    List<MemberBalance> balances,
    BalanceSummary summary,
  ) {
    return GFCard(
      padding: EdgeInsets.zero,
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Table Header
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.sm,
            ),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(8),
              ),
            ),
            child: Row(
              children: [
                Expanded(flex: 3, child: 'Member'.text.semiBold.make()),
                Expanded(flex: 2, child: 'Meals'.text.semiBold.center.make()),
                Expanded(flex: 2, child: 'Bazar'.text.semiBold.center.make()),
                Expanded(flex: 2, child: 'Fixed'.text.semiBold.center.make()),
                Expanded(
                  flex: 2,
                  child: 'Meal Cost'.text.semiBold.center.make(),
                ),
                Expanded(flex: 2, child: 'Balance'.text.semiBold.center.make()),
              ],
            ),
          ),
          // Table Rows
          ...balances.asMap().entries.map((entry) {
            final i = entry.key;
            final b = entry.value;
            final isEven = i % 2 == 0;
            return Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.sm,
              ),
              color: isEven
                  ? Colors.transparent
                  : AppColors.surfaceDark.withValues(alpha: 0.3),
              child: Row(
                children: [
                  Expanded(flex: 3, child: b.name.text.make()),
                  Expanded(
                    flex: 2,
                    child: b.totalMeals.toStringAsFixed(1).text.center.make(),
                  ),
                  Expanded(
                    flex: 2,
                    child: '৳${b.totalBazar.toStringAsFixed(0)}'.text.center
                        .make(),
                  ),
                  Expanded(
                    flex: 2,
                    child: '৳${b.fixedExpenseShare.toStringAsFixed(0)}'
                        .text
                        .center
                        .make(),
                  ),
                  Expanded(
                    flex: 2,
                    child: '৳${b.mealCost.toStringAsFixed(0)}'.text.center
                        .make(),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(
                      '${b.balance >= 0 ? '+' : ''}${b.balance.toStringAsFixed(0)}',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: b.balance >= 0
                            ? AppColors.success
                            : AppColors.error,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildSummaryStats(BalanceSummary summary) {
    return GFCard(
      padding: const EdgeInsets.all(AppSpacing.md),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          'Calculation Summary'.text.lg.semiBold.make(),
          const Gap(AppSpacing.sm),
          _buildStatRow('Total Meals', summary.totalMeals.toStringAsFixed(1)),
          _buildStatRow(
            'Total Bazar',
            '৳${summary.totalBazar.toStringAsFixed(2)}',
          ),
          _buildStatRow(
            'Meal Rate',
            '৳${summary.mealRate.toStringAsFixed(2)} per meal',
          ),
          _buildStatRow(
            'Fixed Expenses',
            '৳${summary.totalFixedExpenses.toStringAsFixed(0)}',
          ),
          _buildStatRow(
            'Per-Member Fixed Share',
            '৳${summary.perMemberFixedShare.toStringAsFixed(2)}',
          ),
          _buildStatRow('Members', '${summary.memberCount}'),
          _buildStatRow(
            'Calculation Mode',
            summary.calculationMode.toUpperCase(),
          ),
        ],
      ),
    );
  }

  Widget _buildStatRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [label.text.gray600.make(), value.text.semiBold.make()],
      ),
    );
  }

  Widget _buildSignatureBlock() {
    return GFCard(
      padding: const EdgeInsets.all(AppSpacing.lg),
      content: Column(
        children: [
          'Verification & Signatures'.text.lg.semiBold.make(),
          const Gap(AppSpacing.lg),
          Row(
            children: [
              Expanded(child: _buildSignatureLine('Manager')),
              const Gap(AppSpacing.lg),
              Expanded(child: _buildSignatureLine('Member Rep.')),
            ],
          ),
          const Gap(AppSpacing.md),
          'Date: _____________________'.text.gray500.make(),
        ],
      ),
    );
  }

  Widget _buildSignatureLine(String role) {
    return Column(
      children: [
        const SizedBox(height: 40),
        Container(height: 1, color: Colors.grey),
        const Gap(4),
        role.text.sm.gray500.make(),
      ],
    );
  }

  Future<void> _handleExport(
    BuildContext context,
    WidgetRef ref,
    String type,
    List<MemberBalance> balances,
    BalanceSummary summary,
    List members,
    List settlementBalances,
    List payments,
  ) async {
    final now = DateTime.now();
    try {
      if (type == 'print') {
        final pdfBytes = await ExportService.generateSettlementPdf(
          year: now.year,
          month: now.month,
          totalBazar: summary.totalBazar,
          mealRate: summary.mealRate,
          balances: settlementBalances.cast(),
          payments: payments.cast(),
          members: members.cast(),
        );
        await Printing.layoutPdf(onLayout: (_) => pdfBytes);
      } else if (type == 'excel') {
        final xlsxBytes = ExportService.generateBalancesXlsx(
          year: now.year,
          month: now.month,
          totalBazar: summary.totalBazar,
          mealRate: summary.mealRate,
          balances: settlementBalances.cast(),
          members: members.cast(),
        );
        await ExportService.shareXlsx(
          xlsxBytes,
          'summary_${now.year}_${now.month}.xlsx',
        );
      }
    } catch (e) {
      if (context.mounted) {
        GFToast.showToast('Export failed: $e', context);
      }
    }
  }
}
