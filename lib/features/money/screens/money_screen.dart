import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:gap/gap.dart';
import 'package:mess_manager/core/theme/app_theme.dart';
import 'package:mess_manager/core/providers/members_provider.dart';
import 'package:mess_manager/features/money/providers/money_provider.dart';
import 'package:mess_manager/features/money/widgets/add_transaction_sheet.dart';

class MoneyScreen extends ConsumerWidget {
  const MoneyScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final personalBalance = ref.watch(currentPersonalBalanceProvider);
    final pendingTx = ref.watch(pendingTransactionsProvider);
    final settledTx = ref.watch(settledTransactionsProvider);
    final members = ref.watch(membersProvider);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Icon(
              LucideIcons.arrowLeftRight,
              color: AppColors.accentWarm,
              size: 22,
            ),
            const Gap(AppSpacing.sm),
            const Text('Money'),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(LucideIcons.plus),
            onPressed: () => _showAddSheet(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Personal Balance Card
            if (personalBalance != null)
              _buildPersonalBalanceCard(personalBalance),
            const Gap(AppSpacing.lg),

            // Pending Transactions
            if (pendingTx.isNotEmpty) ...[
              Row(
                children: [
                  const Icon(
                    LucideIcons.clock,
                    size: 18,
                    color: AppColors.warning,
                  ),
                  const Gap(AppSpacing.sm),
                  Text(
                    'Pending (${pendingTx.length})',
                    style: AppTypography.headlineSmall.copyWith(
                      color: AppColors.textPrimaryDark,
                    ),
                  ),
                ],
              ),
              const Gap(AppSpacing.sm),
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
              const Gap(AppSpacing.lg),
            ],

            // Settled Transactions
            if (settledTx.isNotEmpty) ...[
              Row(
                children: [
                  const Icon(
                    LucideIcons.checkCircle,
                    size: 18,
                    color: AppColors.success,
                  ),
                  const Gap(AppSpacing.sm),
                  Text(
                    'Settled',
                    style: AppTypography.headlineSmall.copyWith(
                      color: AppColors.textPrimaryDark,
                    ),
                  ),
                ],
              ),
              const Gap(AppSpacing.sm),
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

            if (pendingTx.isEmpty && settledTx.isEmpty) _buildEmptyState(),

            const Gap(AppSpacing.xxl),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddSheet(context),
        backgroundColor: AppColors.accentWarm,
        icon: const Icon(LucideIcons.plus),
        label: const Text('Add Transaction'),
      ),
    );
  }

  Widget _buildPersonalBalanceCard(PersonalBalance balance) {
    final isPositive = balance.netBalance >= 0;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isPositive
              ? [AppColors.success.withValues(alpha: 0.8), AppColors.success]
              : [AppColors.error.withValues(alpha: 0.8), AppColors.error],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        boxShadow: [
          BoxShadow(
            color: (isPositive ? AppColors.success : AppColors.error)
                .withValues(alpha: 0.3),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                isPositive ? LucideIcons.trendingUp : LucideIcons.trendingDown,
                color: Colors.white.withValues(alpha: 0.8),
                size: 18,
              ),
              const Gap(AppSpacing.sm),
              Text(
                isPositive ? 'You are owed' : 'You owe',
                style: AppTypography.labelMedium.copyWith(
                  color: Colors.white.withValues(alpha: 0.8),
                ),
              ),
            ],
          ),
          const Gap(AppSpacing.sm),
          Text(
            '৳${balance.netBalance.abs().toStringAsFixed(0)}',
            style: AppTypography.displayLarge.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w800,
            ),
          ),
          const Gap(AppSpacing.md),
          Row(
            children: [
              _buildMiniStat(
                'Given',
                '৳${balance.amountOwedTo.toStringAsFixed(0)}',
              ),
              const Gap(AppSpacing.lg),
              _buildMiniStat(
                'Received',
                '৳${balance.amountOwed.toStringAsFixed(0)}',
              ),
            ],
          ),
        ],
      ),
    ).animate().fadeIn().scale(begin: const Offset(0.95, 0.95));
  }

  Widget _buildMiniStat(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTypography.labelSmall.copyWith(
            color: Colors.white.withValues(alpha: 0.7),
          ),
        ),
        Text(
          value,
          style: AppTypography.titleMedium.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
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

    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.cardDark,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        border: Border.all(
          color: isSettled
              ? AppColors.borderDark.withValues(alpha: 0.3)
              : AppColors.warning.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          // Avatar
          CircleAvatar(
            radius: 20,
            backgroundColor: AppColors.accentWarm.withValues(alpha: 0.1),
            child: Text(
              from.name[0],
              style: AppTypography.titleMedium.copyWith(
                color: AppColors.accentWarm,
              ),
            ),
          ),
          const Gap(AppSpacing.md),
          // Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      from.name,
                      style: AppTypography.titleSmall.copyWith(
                        color: AppColors.textPrimaryDark,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Gap(AppSpacing.xs),
                    const Icon(
                      LucideIcons.arrowRight,
                      size: 14,
                      color: AppColors.textMutedDark,
                    ),
                    const Gap(AppSpacing.xs),
                    Text(
                      to.name,
                      style: AppTypography.titleSmall.copyWith(
                        color: AppColors.textPrimaryDark,
                      ),
                    ),
                  ],
                ),
                if (tx.description != null && tx.description.isNotEmpty)
                  Text(
                    tx.description,
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.textSecondaryDark,
                    ),
                  ),
              ],
            ),
          ),
          // Amount & Action
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '৳${tx.amount.toStringAsFixed(0)}',
                style: AppTypography.titleMedium.copyWith(
                  color: AppColors.accentWarm,
                  fontWeight: FontWeight.w700,
                ),
              ),
              if (!isSettled)
                GestureDetector(
                  onTap: () => ref
                      .read(moneyTransactionsProvider.notifier)
                      .settleTransaction(tx.id),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.sm,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.success.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                    ),
                    child: Text(
                      'Settle',
                      style: AppTypography.labelSmall.copyWith(
                        color: AppColors.success,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    ).animate(delay: (80 * index).ms).fadeIn().slideX(begin: 0.03);
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          children: [
            Icon(LucideIcons.wallet, size: 64, color: AppColors.textMutedDark),
            const Gap(AppSpacing.md),
            Text(
              'No transactions yet',
              style: AppTypography.titleMedium.copyWith(
                color: AppColors.textSecondaryDark,
              ),
            ),
            Text(
              'Track money given or received between members',
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.textMutedDark,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  void _showAddSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const AddTransactionSheet(),
    );
  }
}
