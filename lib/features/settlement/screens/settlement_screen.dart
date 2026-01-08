import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:gap/gap.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:getwidget/getwidget.dart';
import 'package:go_router/go_router.dart';

import 'package:mess_manager/core/theme/app_theme.dart';
import 'package:mess_manager/core/providers/members_provider.dart';
import 'package:mess_manager/core/services/export_service.dart';
import 'package:mess_manager/core/services/haptic_service.dart';
import 'package:mess_manager/core/widgets/gf_components.dart';
import 'package:mess_manager/features/settlement/providers/settlement_provider.dart';
import 'package:mess_manager/features/settlement/providers/month_lock_provider.dart';
import 'package:mess_manager/core/models/settlement.dart';
import 'package:mess_manager/features/balance/providers/balance_provider.dart';
import 'package:mess_manager/features/settlement/widgets/audit_sheet.dart';
import 'package:mess_manager/features/settlement/widgets/penalty_settings_sheet.dart';
import 'package:mess_manager/core/providers/role_provider.dart';

/// Settlement Screen - Uses GetWidget + VelocityX + flutter_animate
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
        title: [
          const Icon(
            LucideIcons.receipt,
            color: AppColors.textSecondaryDark,
            size: 22,
          ),
          const Gap(AppSpacing.sm),
          'Settlement'.text.make(),
        ].hStack(),
        actions: [
          GFIconButton(
            icon: const Icon(
              LucideIcons.clipboardList,
              color: AppColors.success,
            ),
            type: GFButtonType.transparent,
            onPressed: () {
              HapticService.buttonPress();
              context.push('/month-summary');
            },
            tooltip: 'View Summary',
          ),
          GFIconButton(
            icon: const Icon(LucideIcons.shieldCheck, color: AppColors.info),
            type: GFButtonType.transparent,
            onPressed: () => _showAuditSheet(context),
            tooltip: 'Audit',
          ),
          GFIconButton(
            icon: const Icon(LucideIcons.percent, color: AppColors.error),
            type: GFButtonType.transparent,
            onPressed: () => _showPenaltySettings(context),
            tooltip: 'Penalty Settings',
          ),
          GFIconButton(
            icon: const Icon(LucideIcons.lock, color: AppColors.warning),
            type: GFButtonType.transparent,
            onPressed: () =>
                _showCloseMonthDialog(context, ref, summary, whoOwesWhom),
            tooltip: 'Close Month',
          ),
          GFIconButton(
            icon: const Icon(LucideIcons.fileText, color: AppColors.primary),
            type: GFButtonType.transparent,
            onPressed: () {
              HapticService.buttonPress();
              _exportPdf(context, ref, balances, whoOwesWhom, members, summary);
            },
            tooltip: 'Export PDF',
          ),
          GFIconButton(
            icon: const Icon(
              LucideIcons.fileSpreadsheet,
              color: AppColors.bazarColor,
            ),
            type: GFButtonType.transparent,
            onPressed: () {
              HapticService.buttonPress();
              _exportCsv(context, ref, balances, members);
            },
            tooltip: 'Export CSV',
          ),
          if (currentSettlement == null)
            GFButton(
              onPressed: () {
                HapticService.success();
                _createSettlement(context, ref, whoOwesWhom);
              },
              icon: const Icon(
                LucideIcons.check,
                size: 18,
                color: Colors.white,
              ),
              text: 'Finalize',
              color: AppColors.moneyPositive,
              size: GFSize.SMALL,
            ),
          // Super Admin: Force Settle All
          if (currentSettlement != null &&
              ref.watch(isSuperAdminProvider) &&
              currentSettlement.items.any((i) => !i.isPaid))
            GFIconButton(
              icon: const Icon(LucideIcons.zap, color: AppColors.error),
              type: GFButtonType.transparent,
              onPressed: () =>
                  _showForceSettleDialog(context, ref, currentSettlement.id),
              tooltip: 'Force Settle All',
            ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          // Month Header Card
          _buildMonthCard(monthName, now.year, summary),
          16.heightBox,

          // Settlement Status
          if (currentSettlement != null) ...[
            _buildStatusCard(currentSettlement),
            16.heightBox,
          ],

          // Who Owes Whom Section
          _buildSectionHeader('Who Owes Whom'),
          8.heightBox,
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
          16.heightBox,

          // Balance Summary Section
          _buildSectionHeader('Member Balances'),
          8.heightBox,
          ...balances.asMap().entries.map((entry) {
            final balance = entry.value;
            final member = members.firstWhere(
              (m) => m.id == balance.memberId,
              orElse: () => members.first,
            );
            return _buildBalanceItem(member.name, balance, entry.key);
          }),
          32.heightBox,
        ],
      ),
    );
  }

  Widget _buildMonthCard(String monthName, int year, BalanceSummary summary) {
    return GFCard(
      padding: const EdgeInsets.all(AppSpacing.lg),
      margin: EdgeInsets.zero,
      elevation: 8,
      gradient: LinearGradient(
        colors: [
          AppColors.moneyNegative.withValues(alpha: 0.8),
          AppColors.moneyNegative.withValues(alpha: 0.6),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
      content: VStack([
        HStack([
          VStack(crossAlignment: CrossAxisAlignment.start, [
            'Settlement'.text.sm.white.make(),
            4.heightBox,
            '$monthName $year'.text.xl2.white.bold.make(),
          ]),
          const Spacer(),
          GFAvatar(
            backgroundColor: Colors.white.withValues(alpha: 0.2),
            child: const Icon(LucideIcons.calculator, color: Colors.white),
          ),
        ]),
        16.heightBox,
        Container(height: 1, color: Colors.white.withValues(alpha: 0.2)),
        12.heightBox,
        HStack(alignment: MainAxisAlignment.spaceAround, [
          _buildMonthStat(
            'Total Bazar',
            '৳${summary.totalBazar.toStringAsFixed(0)}',
          ),
          _buildMonthStat(
            'Meal Rate',
            '৳${summary.mealRate.toStringAsFixed(1)}',
          ),
          _buildMonthStat('Members', '${summary.memberCount}'),
        ]),
      ]),
    ).animate().fadeIn(duration: 400.ms).scale(begin: const Offset(0.95, 0.95));
  }

  Widget _buildMonthStat(String label, String value) {
    return VStack([
      value.text.lg.white.bold.make(),
      2.heightBox,
      label.text.xs.white.make(),
    ]);
  }

  Widget _buildStatusCard(dynamic settlement) {
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

    return GFAppCard(
      color: statusColor.withValues(alpha: 0.1),
      borderColor: statusColor.withValues(alpha: 0.3),
      child: HStack([
        GFAvatar(
          size: 40,
          backgroundColor: statusColor.withValues(alpha: 0.2),
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
        12.widthBox,
        VStack(crossAlignment: CrossAxisAlignment.start, [
          'Settlement Status'.text.xs.color(AppColors.textMutedDark).make(),
          statusText.text.lg.color(statusColor).bold.make(),
        ]).expand(),
        if (isCompleted && settlement.settledAt != null)
          'Settled ${_formatDate(settlement.settledAt!)}'.text.xs
              .color(AppColors.textMutedDark)
              .make(),
      ]),
    ).animate().fadeIn(delay: 100.ms).slideX(begin: 0.05);
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

  Widget _buildEmptyState(String message) {
    return GFAppCard(
      child: VStack([
        Icon(LucideIcons.checkCircle, color: AppColors.moneyPositive, size: 48),
        12.heightBox,
        message.text.color(AppColors.textSecondaryDark).center.make(),
      ]).p16(),
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
    return GFAppCard(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      borderColor: isPaid
          ? AppColors.moneyPositive.withValues(alpha: 0.3)
          : AppColors.borderDark.withValues(alpha: 0.5),
      child: HStack([
        GFMemberAvatar(
          name: fromName,
          size: 36,
          backgroundColor: AppColors.moneyNegative.withValues(alpha: 0.2),
        ),
        8.widthBox,
        VStack([
          HStack(alignment: MainAxisAlignment.center, [
            fromName.text.sm.color(AppColors.textSecondaryDark).make(),
            4.widthBox,
            Icon(
              LucideIcons.arrowRight,
              color: isPaid ? AppColors.moneyPositive : AppColors.primary,
              size: 16,
            ),
            4.widthBox,
            toName.text.sm.color(AppColors.textSecondaryDark).make(),
          ]),
          2.heightBox,
          '৳${amount.toStringAsFixed(0)}'.text.lg
              .color(
                isPaid ? AppColors.moneyPositive : AppColors.textPrimaryDark,
              )
              .bold
              .make(),
        ]).expand(),
        GFMemberAvatar(
          name: toName,
          size: 36,
          backgroundColor: AppColors.moneyPositive.withValues(alpha: 0.2),
        ),
        8.widthBox,
        if (!isPaid && settlementId != null)
          GFIconButton(
            icon: const Icon(LucideIcons.check, size: 20),
            type: GFButtonType.solid,
            color: AppColors.moneyPositive,
            size: GFSize.SMALL,
            onPressed: () {
              HapticService.success();
              _markAsPaid(ref, settlementId, fromId, toId);
            },
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
      ]),
    ).animate(delay: (80 * index).ms).fadeIn().slideX(begin: 0.03);
  }

  Widget _buildBalanceItem(String name, dynamic balance, int index) {
    final isPositive = balance.balance >= 0;
    final balanceColor = isPositive
        ? AppColors.moneyPositive
        : AppColors.moneyNegative;

    return GFAppCard(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: HStack([
        GFMemberAvatar(
          name: name,
          size: 40,
          backgroundColor: balanceColor.withValues(alpha: 0.2),
        ),
        12.widthBox,
        VStack(crossAlignment: CrossAxisAlignment.start, [
          name.text.color(AppColors.textPrimaryDark).bold.make(),
          2.heightBox,
          'Bazar: ৳${balance.totalBazar.toStringAsFixed(0)} | Meals: ৳${balance.mealCost.toStringAsFixed(0)}'
              .text
              .xs
              .color(AppColors.textMutedDark)
              .make(),
        ]).expand(),
        VStack(crossAlignment: CrossAxisAlignment.end, [
          '${isPositive ? '+' : ''}৳${balance.balance.toStringAsFixed(0)}'
              .text
              .lg
              .color(balanceColor)
              .bold
              .make(),
          (isPositive ? 'Credit' : 'Owes').text.xs.color(balanceColor).make(),
        ]),
      ]),
    ).animate(delay: (60 * index).ms).fadeIn().slideX(begin: 0.02);
  }

  void _createSettlement(BuildContext context, WidgetRef ref, List items) {
    if (items.isEmpty) {
      showInfoToast(context, 'All balances are settled!');
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

    showSuccessToast(context, 'Settlement created!');
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

  String _formatDate(DateTime date) => '${date.day}/${date.month}/${date.year}';

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
      await ExportService.sharePdf(
        pdfBytes,
        'settlement_${now.year}_${now.month}.pdf',
      );
    } catch (e) {
      if (context.mounted) showErrorToast(context, 'Export failed: $e');
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
      if (context.mounted) showErrorToast(context, 'Export failed: $e');
    }
  }

  void _showCloseMonthDialog(
    BuildContext context,
    WidgetRef ref,
    BalanceSummary summary,
    List<SettlementItem> payments,
  ) {
    final now = DateTime.now();
    final isLocked = ref.read(monthLockProvider).isLocked(now.year, now.month);
    final isSuperAdmin = ref.read(isSuperAdminProvider);

    // If locked, show re-open option for Super Admins
    if (isLocked) {
      if (isSuperAdmin) {
        _showReopenMonthDialog(context, ref, now.year, now.month);
      } else {
        showErrorToast(context, 'This month is already closed');
      }
      return;
    }

    HapticService.modalOpen();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surfaceDark,
        title: HStack([
          const Icon(LucideIcons.alertTriangle, color: AppColors.warning),
          8.widthBox,
          'Close Month?'.text.bold.make(),
        ]),
        content: VStack(crossAlignment: CrossAxisAlignment.start, [
          'This will:'.text.semiBold.make(),
          8.heightBox,
          HStack([
            const Icon(LucideIcons.check, size: 16, color: AppColors.success),
            8.widthBox,
            'Generate final PDF report'.text.sm.make().expand(),
          ]),
          4.heightBox,
          HStack([
            const Icon(LucideIcons.check, size: 16, color: AppColors.success),
            8.widthBox,
            'Lock all entries (read-only)'.text.sm.make().expand(),
          ]),
          4.heightBox,
          HStack([
            const Icon(LucideIcons.check, size: 16, color: AppColors.success),
            8.widthBox,
            'Carry forward balances to next month'.text.sm.make().expand(),
          ]),
          16.heightBox,
          Container(
            padding: const EdgeInsets.all(AppSpacing.sm),
            decoration: BoxDecoration(
              color: AppColors.warning.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
            ),
            child: 'This action cannot be undone!'.text.sm
                .color(AppColors.warning)
                .make(),
          ),
        ]),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: 'Cancel'.text.make(),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.warning),
            onPressed: () async {
              Navigator.pop(ctx);
              await _closeMonth(context, ref, summary, payments);
            },
            child: 'Close Month'.text.bold.make(),
          ),
        ],
      ),
    );
  }

  /// Super Admin: Re-open a closed month
  void _showReopenMonthDialog(
    BuildContext context,
    WidgetRef ref,
    int year,
    int month,
  ) {
    HapticService.modalOpen();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surfaceDark,
        title: HStack([
          const Icon(LucideIcons.unlock, color: AppColors.error),
          8.widthBox,
          'Re-open Month?'.text.bold.color(AppColors.error).make(),
        ]),
        content: VStack(crossAlignment: CrossAxisAlignment.start, [
          '⚠️ SUPER ADMIN ACTION'.text.sm.bold.color(AppColors.error).make(),
          12.heightBox,
          'This will unlock ${_getMonthName(month)} $year for editing.'.text
              .make(),
          12.heightBox,
          Container(
            padding: const EdgeInsets.all(AppSpacing.sm),
            decoration: BoxDecoration(
              color: AppColors.error.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
              border: Border.all(color: AppColors.error.withValues(alpha: 0.3)),
            ),
            child: VStack(crossAlignment: CrossAxisAlignment.start, [
              'Warning:'.text.sm.bold.color(AppColors.error).make(),
              4.heightBox,
              '• Entries can be modified again'.text.xs.make(),
              '• Carry-forward balances may be affected'.text.xs.make(),
              '• Finalized reports will be invalidated'.text.xs.make(),
            ]),
          ),
        ]),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: 'Cancel'.text.make(),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            onPressed: () {
              Navigator.pop(ctx);
              ref.read(monthLockProvider.notifier).unlockMonth(year, month);
              HapticService.warning();
              showSuccessToast(context, 'Month unlocked for editing');
            },
            child: 'Unlock Month'.text.bold.make(),
          ),
        ],
      ),
    );
  }

  Future<void> _closeMonth(
    BuildContext context,
    WidgetRef ref,
    BalanceSummary summary,
    List<SettlementItem> payments,
  ) async {
    HapticService.buttonPress();

    final now = DateTime.now();
    final balances = ref.read(memberBalancesProvider);

    try {
      final result = await ref
          .read(monthLockProvider.notifier)
          .closeMonth(
            year: now.year,
            month: now.month,
            summary: summary,
            balances: balances,
            payments: payments,
          );

      if (result.success && result.pdfBytes != null) {
        HapticService.success();
        if (context.mounted) {
          showSuccessToast(context, 'Month closed! PDF generated.');
          // Share the PDF
          await ExportService.sharePdf(
            Uint8List.fromList(result.pdfBytes!),
            'settlement_${now.year}_${now.month}_final.pdf',
          );
        }
      } else {
        if (context.mounted) {
          showErrorToast(context, result.error ?? 'Failed to close month');
        }
      }
    } catch (e) {
      if (context.mounted) {
        showErrorToast(context, 'Error: $e');
      }
    }
  }

  void _showAuditSheet(BuildContext context) {
    HapticService.modalOpen();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const AuditSheet(),
    );
  }

  void _showPenaltySettings(BuildContext context) {
    HapticService.modalOpen();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const PenaltySettingsSheet(),
    );
  }

  /// Super Admin: Force settle all unpaid items
  void _showForceSettleDialog(
    BuildContext context,
    WidgetRef ref,
    String settlementId,
  ) {
    HapticService.modalOpen();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surfaceDark,
        title: HStack([
          const Icon(LucideIcons.zap, color: AppColors.error),
          8.widthBox,
          'Force Settle All?'.text.bold.color(AppColors.error).make(),
        ]),
        content: VStack(crossAlignment: CrossAxisAlignment.start, [
          '⚠️ SUPER ADMIN ACTION'.text.sm.bold.color(AppColors.error).make(),
          12.heightBox,
          'This will mark ALL remaining payments as PAID.'.text.make(),
          12.heightBox,
          Container(
            padding: const EdgeInsets.all(AppSpacing.sm),
            decoration: BoxDecoration(
              color: AppColors.warning.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
              border: Border.all(
                color: AppColors.warning.withValues(alpha: 0.3),
              ),
            ),
            child: VStack(crossAlignment: CrossAxisAlignment.start, [
              'This should only be used when:'.text.sm.bold.make(),
              4.heightBox,
              '• Payments were made outside the app'.text.xs.make(),
              '• Members left with unsettled balance'.text.xs.make(),
              '• Admin manually verified all payments'.text.xs.make(),
            ]),
          ),
        ]),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: 'Cancel'.text.make(),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            onPressed: () {
              Navigator.pop(ctx);
              ref
                  .read(settlementsProvider.notifier)
                  .forceSettleAll(settlementId);
              HapticService.success();
              showSuccessToast(context, 'All payments marked as settled');
            },
            child: 'Force Settle'.text.bold.make(),
          ),
        ],
      ),
    );
  }
}
