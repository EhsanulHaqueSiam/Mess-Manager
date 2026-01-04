import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:gap/gap.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:getwidget/getwidget.dart';

import 'package:mess_manager/core/theme/app_theme.dart';
import 'package:mess_manager/core/models/duty.dart';
import 'package:mess_manager/core/providers/members_provider.dart';
import 'package:mess_manager/core/services/haptic_service.dart';
import 'package:mess_manager/core/widgets/gf_components.dart';
import 'package:mess_manager/core/widgets/animated_widgets.dart';
import 'package:mess_manager/features/money/providers/money_provider.dart';
import 'package:mess_manager/features/money/widgets/add_transaction_sheet.dart';
import 'package:mess_manager/features/duties/providers/duty_provider.dart';

/// Money Screen - Uses GetWidget + VelocityX + flutter_animate
class MoneyScreen extends ConsumerWidget {
  const MoneyScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final personalBalance = ref.watch(currentPersonalBalanceProvider);
    final pendingTx = ref.watch(pendingTransactionsProvider);
    final settledTx = ref.watch(settledTransactionsProvider);
    final members = ref.watch(membersProvider);
    final dutyDebts = ref.watch(dutyDebtsProvider);
    final currentMemberId = ref.watch(currentMemberIdProvider);

    // Calculate duty debts/credits for current user
    final myDutyDebts = dutyDebts
        .where((d) => d.debtorId == currentMemberId && !d.isSettled)
        .toList();
    final myDutyCredits = dutyDebts
        .where((d) => d.creditorId == currentMemberId && !d.isSettled)
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: [
          const Icon(
            LucideIcons.arrowLeftRight,
            color: AppColors.accentWarm,
            size: 22,
          ),
          const Gap(AppSpacing.sm),
          'Money'.text.make(),
        ].hStack(),
        actions: [
          GFIconButton(
            icon: const Icon(LucideIcons.plus, color: AppColors.accentWarm),
            type: GFButtonType.transparent,
            onPressed: () {
              HapticService.buttonPress();
              _showAddSheet(context);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: VStack([
          // Personal Balance Card
          if (personalBalance != null)
            _buildPersonalBalanceCard(personalBalance),
          16.heightBox,

          // Pending Transactions
          if (pendingTx.isNotEmpty) ...[
            HStack([
              const Icon(LucideIcons.clock, size: 18, color: AppColors.warning),
              8.widthBox,
              'Pending (${pendingTx.length})'.text.xl.bold
                  .color(AppColors.textPrimaryDark)
                  .make(),
            ]),
            8.heightBox,
            ...pendingTx.asMap().entries.map(
              (e) => _buildTransactionCard(
                context,
                ref,
                e.value,
                members,
                e.key,
                false,
              ),
            ),
            16.heightBox,
          ],

          // Duty Debts Section
          if (myDutyDebts.isNotEmpty || myDutyCredits.isNotEmpty) ...[
            HStack([
              const Icon(
                LucideIcons.clipboardList,
                size: 18,
                color: AppColors.info,
              ),
              8.widthBox,
              'Duty Balance'.text.xl.bold
                  .color(AppColors.textPrimaryDark)
                  .make(),
            ]),
            8.heightBox,
            _buildDutyDebtsCard(myDutyDebts, myDutyCredits, members),
            16.heightBox,
          ],

          // Settled Transactions
          if (settledTx.isNotEmpty) ...[
            HStack([
              const Icon(
                LucideIcons.checkCircle,
                size: 18,
                color: AppColors.success,
              ),
              8.widthBox,
              'Settled'.text.xl.bold.color(AppColors.textPrimaryDark).make(),
            ]),
            8.heightBox,
            ...settledTx
                .take(5)
                .toList()
                .asMap()
                .entries
                .map(
                  (e) => _buildTransactionCard(
                    context,
                    ref,
                    e.value,
                    members,
                    e.key,
                    true,
                  ),
                ),
          ],

          if (pendingTx.isEmpty && settledTx.isEmpty)
            EmptyStateWidget(
              icon: LucideIcons.wallet,
              title: 'No transactions yet',
              subtitle: 'Track money given or received between members',
              action: ShimmerCTAButton(
                text: 'Add Transaction',
                icon: LucideIcons.plus,
                onPressed: () => _showAddSheet(context),
              ),
            ),

          32.heightBox,
        ]).p16(),
      ),
      floatingActionButton: _buildShimmerFAB(context),
    );
  }

  Widget _buildShimmerFAB(BuildContext context) {
    return FloatingActionButton.extended(
          onPressed: () {
            HapticService.buttonPress();
            _showAddSheet(context);
          },
          backgroundColor: AppColors.accentWarm,
          icon: const Icon(LucideIcons.plus),
          label: const Text('Add Transaction'),
        )
        .animate(onPlay: (c) => c.repeat())
        .shimmer(
          duration: 2.seconds,
          color: Colors.white.withValues(alpha: 0.15),
        );
  }

  Widget _buildPersonalBalanceCard(PersonalBalance balance) {
    final isPositive = balance.netBalance >= 0;
    final colors = isPositive
        ? [AppColors.success.withValues(alpha: 0.8), AppColors.success]
        : [AppColors.error.withValues(alpha: 0.8), AppColors.error];

    return GFCard(
      padding: const EdgeInsets.all(AppSpacing.lg),
      margin: EdgeInsets.zero,
      elevation: 8,
      gradient: LinearGradient(
        colors: colors,
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
      content: VStack(crossAlignment: CrossAxisAlignment.start, [
        HStack([
          Icon(
            isPositive ? LucideIcons.trendingUp : LucideIcons.trendingDown,
            color: Colors.white,
            size: 18,
          ),
          8.widthBox,
          (isPositive ? 'You are owed' : 'You owe').text.sm.white.make(),
        ]),
        8.heightBox,
        '৳${balance.netBalance.abs().toStringAsFixed(0)}'.text.xl3.white.bold
            .make(),
        12.heightBox,
        HStack([
          _buildMiniStat(
            'Given',
            '৳${balance.amountOwedTo.toStringAsFixed(0)}',
          ),
          16.widthBox,
          _buildMiniStat(
            'Received',
            '৳${balance.amountOwed.toStringAsFixed(0)}',
          ),
        ]),
      ]),
    ).animate().fadeIn().scale(begin: const Offset(0.95, 0.95));
  }

  Widget _buildDutyDebtsCard(
    List<DutyDebt> debts,
    List<DutyDebt> credits,
    List members,
  ) {
    String getMemberName(String id) {
      for (final m in members) {
        if (m.id == id) return m.name;
      }
      return 'Unknown';
    }

    String getDutyName(DutyType type) {
      switch (type) {
        case DutyType.roomCleaning:
          return 'Room Cleaning';
        case DutyType.diningCleanup:
          return 'Dining Cleanup';
        case DutyType.bazarDuty:
          return 'Bazar Duty';
        case DutyType.garbageDisposal:
          return 'Garbage';
        case DutyType.cooking:
          return 'Cooking';
      }
    }

    return GFAppCard(
      child: VStack(crossAlignment: CrossAxisAlignment.start, [
        // Credits (duties others owe you)
        if (credits.isNotEmpty) ...[
          HStack([
            const Icon(
              LucideIcons.trendingUp,
              color: AppColors.moneyPositive,
              size: 16,
            ),
            6.widthBox,
            'Others Owe You'.text.sm.bold.color(AppColors.moneyPositive).make(),
          ]),
          6.heightBox,
          ...credits.map(
            (c) =>
                '• ${getMemberName(c.debtorId)} owes 1 ${getDutyName(c.dutyType)}'
                    .text
                    .xs
                    .color(AppColors.textSecondaryDark)
                    .make(),
          ),
          if (debts.isNotEmpty) 10.heightBox,
        ],

        // Debts (duties you owe others)
        if (debts.isNotEmpty) ...[
          HStack([
            const Icon(
              LucideIcons.trendingDown,
              color: AppColors.moneyNegative,
              size: 16,
            ),
            6.widthBox,
            'You Owe'.text.sm.bold.color(AppColors.moneyNegative).make(),
          ]),
          6.heightBox,
          ...debts.map(
            (d) =>
                '• You owe ${getMemberName(d.creditorId)} 1 ${getDutyName(d.dutyType)}'
                    .text
                    .xs
                    .color(AppColors.textSecondaryDark)
                    .make(),
          ),
        ],
      ]).p12(),
    ).animate().fadeIn().slideX(begin: -0.03);
  }

  Widget _buildMiniStat(String label, String value) {
    return VStack(crossAlignment: CrossAxisAlignment.start, [
      label.text.xs.white.make(),
      value.text.lg.white.bold.make(),
    ]);
  }

  Widget _buildTransactionCard(
    BuildContext context,
    WidgetRef ref,
    dynamic tx,
    List members,
    int index,
    bool isSettled,
  ) {
    final from = members.firstWhere(
      (m) => m.id == tx.fromMemberId,
      orElse: () => members.first,
    );
    final to = members.firstWhere(
      (m) => m.id == tx.toMemberId,
      orElse: () => members.first,
    );

    return GFAppCard(
      borderColor: isSettled
          ? AppColors.borderDark.withValues(alpha: 0.3)
          : AppColors.warning.withValues(alpha: 0.3),
      child: HStack([
        GFMemberAvatar(
          name: from.name,
          size: 40,
          backgroundColor: AppColors.accentWarm.withValues(alpha: 0.1),
        ),
        12.widthBox,
        VStack(crossAlignment: CrossAxisAlignment.start, [
          HStack([
            from.name
                .toString()
                .text
                .color(AppColors.textPrimaryDark)
                .bold
                .make(),
            4.widthBox,
            const Icon(
              LucideIcons.arrowRight,
              size: 14,
              color: AppColors.textMutedDark,
            ),
            4.widthBox,
            to.name.toString().text.color(AppColors.textPrimaryDark).make(),
          ]),
          if (tx.description != null && tx.description.isNotEmpty)
            tx.description
                .toString()
                .text
                .sm
                .color(AppColors.textSecondaryDark)
                .make(),
        ]).expand(),
        VStack(crossAlignment: CrossAxisAlignment.end, [
          '৳${tx.amount.toStringAsFixed(0)}'.text.lg
              .color(AppColors.accentWarm)
              .bold
              .make(),
          if (!isSettled)
            GFButton(
              onPressed: () {
                HapticService.success();
                ref
                    .read(moneyTransactionsProvider.notifier)
                    .settleTransaction(tx.id);
              },
              text: 'Settle',
              size: GFSize.SMALL,
              color: AppColors.success,
            ),
        ]),
      ]),
    ).animate(delay: (80 * index).ms).fadeIn().slideX(begin: 0.03);
  }

  void _showAddSheet(BuildContext context) {
    HapticService.modalOpen();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const AddTransactionSheet(),
    );
  }
}
