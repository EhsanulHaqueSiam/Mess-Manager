import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:gap/gap.dart';
import 'package:mess_manager/core/theme/app_theme.dart';
import 'package:mess_manager/features/balance/providers/balance_provider.dart';

class BalanceScreen extends ConsumerWidget {
  const BalanceScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summary = ref.watch(balanceSummaryProvider);
    final balances = ref.watch(memberBalancesProvider);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Icon(LucideIcons.wallet, color: AppColors.primary, size: 22),
            const Gap(AppSpacing.sm),
            const Text('Balance'),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(LucideIcons.share2, size: 20),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Summary Stats
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    icon: LucideIcons.shoppingCart,
                    label: 'Total Bazar',
                    value: '৳${summary.totalBazar.toStringAsFixed(0)}',
                    color: AppColors.bazarColor,
                  ),
                ),
                const Gap(AppSpacing.sm),
                Expanded(
                  child: _buildStatCard(
                    icon: LucideIcons.utensils,
                    label: 'Total Meals',
                    value: summary.totalMeals.toStringAsFixed(1),
                    color: AppColors.mealColor,
                  ),
                ),
              ],
            ).animate().fadeIn().slideY(begin: 0.1),
            const Gap(AppSpacing.sm),
            _buildMealRateCard(
              summary.mealRate,
            ).animate(delay: 100.ms).fadeIn().slideY(begin: 0.1),
            const Gap(AppSpacing.xl),

            // Member Balances
            Text(
              'Member Balances',
              style: AppTypography.headlineSmall.copyWith(
                color: AppColors.textPrimaryDark,
              ),
            ),
            const Gap(AppSpacing.sm),
            Text(
              'Positive = will receive money, Negative = owes money',
              style: AppTypography.labelSmall.copyWith(
                color: AppColors.textMutedDark,
              ),
            ),
            const Gap(AppSpacing.md),

            ...balances.asMap().entries.map((entry) {
              final index = entry.key;
              final balance = entry.value;
              return _buildBalanceCard(
                balance,
              ).animate(delay: (100 * index).ms).fadeIn().slideX(begin: 0.03);
            }),
            const Gap(AppSpacing.xl),

            // Formula Explanation
            _buildFormulaCard(),
            const Gap(AppSpacing.xxl),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 20),
          const Gap(AppSpacing.sm),
          Text(
            value,
            style: AppTypography.displaySmall.copyWith(
              color: color,
              fontWeight: FontWeight.w700,
            ),
          ),
          Text(
            label,
            style: AppTypography.labelSmall.copyWith(
              color: AppColors.textSecondaryDark,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMealRateCard(double mealRate) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary, AppColors.primaryDark],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.sm),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
            ),
            child: const Icon(
              LucideIcons.calculator,
              color: Colors.white,
              size: 24,
            ),
          ),
          const Gap(AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Meal Rate',
                  style: AppTypography.labelMedium.copyWith(
                    color: Colors.white.withValues(alpha: 0.8),
                  ),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      '৳${mealRate.toStringAsFixed(2)}',
                      style: AppTypography.displayMedium.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const Gap(AppSpacing.xs),
                    Text(
                      '/ meal',
                      style: AppTypography.bodySmall.copyWith(
                        color: Colors.white.withValues(alpha: 0.7),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Icon(
            LucideIcons.trendingUp,
            color: Colors.white.withValues(alpha: 0.5),
            size: 32,
          ),
        ],
      ),
    );
  }

  Widget _buildBalanceCard(MemberBalance balance) {
    final isPositive = balance.balance >= 0;
    final balanceColor = isPositive
        ? AppColors.moneyPositive
        : AppColors.moneyNegative;

    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      decoration: BoxDecoration(
        color: AppColors.cardDark,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        border: Border.all(color: AppColors.borderDark.withValues(alpha: 0.5)),
      ),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
        childrenPadding: const EdgeInsets.all(AppSpacing.md),
        leading: CircleAvatar(
          radius: 20,
          backgroundColor: balanceColor.withValues(alpha: 0.2),
          child: Text(
            balance.name[0],
            style: AppTypography.titleMedium.copyWith(color: balanceColor),
          ),
        ),
        title: Text(
          balance.name,
          style: AppTypography.titleMedium.copyWith(
            color: AppColors.textPrimaryDark,
          ),
        ),
        subtitle: Row(
          children: [
            Icon(
              isPositive ? LucideIcons.trendingUp : LucideIcons.trendingDown,
              size: 14,
              color: balanceColor,
            ),
            const Gap(4),
            Text(
              isPositive ? 'Will receive' : 'Owes',
              style: AppTypography.labelSmall.copyWith(color: balanceColor),
            ),
          ],
        ),
        trailing: Text(
          '${isPositive ? '+' : ''}৳${balance.balance.toStringAsFixed(0)}',
          style: AppTypography.titleLarge.copyWith(
            color: balanceColor,
            fontWeight: FontWeight.w700,
          ),
        ),
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: AppColors.surfaceDark,
              borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
            ),
            child: Column(
              children: [
                _buildBreakdownRow(
                  icon: LucideIcons.utensils,
                  label: 'Meals consumed',
                  value: '${balance.totalMeals.toStringAsFixed(1)} meals',
                  color: AppColors.mealColor,
                ),
                const Divider(color: AppColors.borderDark),
                _buildBreakdownRow(
                  icon: LucideIcons.calculator,
                  label: 'Meal cost',
                  value: '৳${balance.mealCost.toStringAsFixed(0)}',
                  color: AppColors.textSecondaryDark,
                ),
                const Divider(color: AppColors.borderDark),
                _buildBreakdownRow(
                  icon: LucideIcons.shoppingCart,
                  label: 'Bazar contributed',
                  value: '৳${balance.totalBazar.toStringAsFixed(0)}',
                  color: AppColors.bazarColor,
                ),
                const Divider(color: AppColors.borderDark),
                _buildBreakdownRow(
                  icon: LucideIcons.wallet,
                  label: 'Balance (Bazar - Cost)',
                  value:
                      '${isPositive ? '+' : ''}৳${balance.balance.toStringAsFixed(0)}',
                  color: balanceColor,
                  isBold: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBreakdownRow({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
    bool isBold = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
      child: Row(
        children: [
          Icon(icon, size: 16, color: color),
          const Gap(AppSpacing.sm),
          Expanded(
            child: Text(
              label,
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.textSecondaryDark,
              ),
            ),
          ),
          Text(
            value,
            style:
                (isBold ? AppTypography.titleSmall : AppTypography.labelMedium)
                    .copyWith(
                      color: color,
                      fontWeight: isBold ? FontWeight.w700 : FontWeight.w500,
                    ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormulaCard() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.cardDark.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        border: Border.all(color: AppColors.borderDark.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(LucideIcons.info, size: 16, color: AppColors.info),
              const Gap(AppSpacing.sm),
              Text(
                'How balance is calculated',
                style: AppTypography.labelMedium.copyWith(
                  color: AppColors.info,
                ),
              ),
            ],
          ),
          const Gap(AppSpacing.sm),
          Text(
            '1. Meal Rate = Total Bazar ÷ Total Meals\n'
            '2. Meal Cost = Your Meals × Meal Rate\n'
            '3. Balance = Your Bazar - Your Meal Cost\n\n'
            'Positive balance: You contributed more than consumed\n'
            'Negative balance: You consumed more than contributed',
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.textSecondaryDark,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}
