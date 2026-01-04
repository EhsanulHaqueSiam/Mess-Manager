import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:gap/gap.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:getwidget/getwidget.dart';
import 'package:accordion/accordion.dart';

import 'package:mess_manager/core/theme/app_theme.dart';
import 'package:mess_manager/core/widgets/gf_components.dart';
import 'package:mess_manager/core/services/haptic_service.dart';
import 'package:mess_manager/features/balance/providers/balance_provider.dart';

/// Balance Screen - Uses GetWidget + VelocityX + Accordion
class BalanceScreen extends ConsumerWidget {
  const BalanceScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summary = ref.watch(balanceSummaryProvider);
    final balances = ref.watch(memberBalancesProvider);

    return Scaffold(
      appBar: AppBar(
        title: [
          const Icon(LucideIcons.wallet, color: AppColors.primary, size: 22),
          const Gap(AppSpacing.sm),
          'Balance'.text.make(),
        ].hStack(),
        actions: [
          IconButton(
            icon: const Icon(LucideIcons.share2, size: 20),
            onPressed: () => HapticService.lightTap(),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: VStack([
          // Summary Stats Row
          HStack([
            _buildStatCard(
              icon: LucideIcons.shoppingCart,
              label: 'Total Bazar',
              value: '৳${summary.totalBazar.toStringAsFixed(0)}',
              color: AppColors.bazarColor,
            ).expand(),
            8.widthBox,
            _buildStatCard(
              icon: LucideIcons.utensils,
              label: 'Total Meals',
              value: summary.totalMeals.toStringAsFixed(1),
              color: AppColors.mealColor,
            ).expand(),
          ]).animate().fadeIn().slideY(begin: 0.1),
          12.heightBox,

          // Meal Rate Card
          _buildMealRateCard(
            summary.mealRate,
          ).animate(delay: 100.ms).fadeIn().slideY(begin: 0.1),
          24.heightBox,

          // Member Balances Header
          'Member Balances'.text.xl.bold
              .color(AppColors.textPrimaryDark)
              .make(),
          4.heightBox,
          'Positive = will receive, Negative = owes'.text.xs
              .color(AppColors.textMutedDark)
              .make(),
          16.heightBox,

          // Member Balance Accordion
          Accordion(
            maxOpenSections: 1,
            headerBackgroundColor: AppColors.cardDark,
            contentBackgroundColor: AppColors.surfaceDark,
            contentBorderColor: AppColors.borderDark,
            headerPadding: const EdgeInsets.all(AppSpacing.md),
            paddingBetweenOpenSections: AppSpacing.sm,
            paddingBetweenClosedSections: AppSpacing.sm,
            children: balances.asMap().entries.map((entry) {
              final index = entry.key;
              final balance = entry.value;
              return _buildBalanceSection(balance, index);
            }).toList(),
          ),
          24.heightBox,

          // Formula Card
          _buildFormulaCard(),
          32.heightBox,
        ]).p16(),
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return GFCard(
      padding: const EdgeInsets.all(AppSpacing.md),
      margin: EdgeInsets.zero,
      color: color.withValues(alpha: 0.1),
      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      border: Border.all(color: color.withValues(alpha: 0.2)),
      content: VStack(crossAlignment: CrossAxisAlignment.start, [
        Icon(icon, color: color, size: 20),
        8.heightBox,
        value.text.xl2.color(color).bold.make(),
        label.text.sm.color(AppColors.textSecondaryDark).make(),
      ]),
    );
  }

  Widget _buildMealRateCard(double mealRate) {
    return GFCard(
      padding: const EdgeInsets.all(AppSpacing.lg),
      margin: EdgeInsets.zero,
      elevation: 4,
      gradient: LinearGradient(
        colors: [AppColors.primary, AppColors.primaryDark],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      content: HStack([
        GFAvatar(
          backgroundColor: Colors.white.withValues(alpha: 0.2),
          child: const Icon(LucideIcons.calculator, color: Colors.white),
        ),
        12.widthBox,
        VStack(crossAlignment: CrossAxisAlignment.start, [
          'Meal Rate'.text.sm.white.make(),
          HStack([
            '৳${mealRate.toStringAsFixed(2)}'.text.xl2.white.bold.make(),
            4.widthBox,
            '/ meal'.text.sm.white.make(),
          ]),
        ]).expand(),
        Icon(
          LucideIcons.trendingUp,
          color: Colors.white.withValues(alpha: 0.5),
          size: 32,
        ),
      ]),
    );
  }

  AccordionSection _buildBalanceSection(MemberBalance balance, int index) {
    final isPositive = balance.balance >= 0;
    final balanceColor = isPositive
        ? AppColors.moneyPositive
        : AppColors.moneyNegative;

    return AccordionSection(
      isOpen: index == 0,
      header: HStack([
        GFMemberAvatar(
          name: balance.name,
          size: 40,
          backgroundColor: balanceColor.withValues(alpha: 0.2),
        ),
        12.widthBox,
        VStack(crossAlignment: CrossAxisAlignment.start, [
          balance.name.text.color(AppColors.textPrimaryDark).bold.make(),
          HStack([
            Icon(
              isPositive ? LucideIcons.trendingUp : LucideIcons.trendingDown,
              size: 14,
              color: balanceColor,
            ),
            4.widthBox,
            (isPositive ? 'Will receive' : 'Owes').text.xs
                .color(balanceColor)
                .make(),
          ]),
        ]).expand(),
        '${isPositive ? '+' : ''}৳${balance.balance.toStringAsFixed(0)}'.text.xl
            .color(balanceColor)
            .bold
            .make(),
      ]).p4(),
      content: VStack([
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
          label: 'Balance',
          value:
              '${isPositive ? '+' : ''}৳${balance.balance.toStringAsFixed(0)}',
          color: balanceColor,
          isBold: true,
        ),
      ]).p8(),
    );
  }

  Widget _buildBreakdownRow({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
    bool isBold = false,
  }) {
    return HStack([
      Icon(icon, size: 16, color: color),
      8.widthBox,
      label.text.sm.color(AppColors.textSecondaryDark).make().expand(),
      value.text
          .color(color)
          .fontWeight(isBold ? FontWeight.w700 : FontWeight.w500)
          .make(),
    ]).py4();
  }

  Widget _buildFormulaCard() {
    return GFAppCard(
      color: AppColors.cardDark.withValues(alpha: 0.5),
      borderColor: AppColors.borderDark.withValues(alpha: 0.3),
      child: VStack(crossAlignment: CrossAxisAlignment.start, [
        HStack([
          const Icon(LucideIcons.info, size: 16, color: AppColors.info),
          8.widthBox,
          'How balance is calculated'.text.sm.color(AppColors.info).make(),
        ]),
        8.heightBox,
        '''1. Meal Rate = Total Bazar ÷ Total Meals
2. Meal Cost = Your Meals × Meal Rate
3. Balance = Your Bazar - Your Meal Cost

Positive balance: You contributed more than consumed
Negative balance: You consumed more than contributed'''
            .text
            .sm
            .color(AppColors.textSecondaryDark)
            .lineHeight(1.6)
            .make(),
      ]),
    );
  }
}
