import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:gap/gap.dart';

import 'package:mess_manager/core/theme/app_theme.dart';
import 'package:mess_manager/core/widgets/app_components.dart';
import 'package:mess_manager/core/services/haptic_service.dart';
import 'package:mess_manager/features/balance/providers/balance_provider.dart';

/// Balance Screen — Cosmic Bioluminescence Design
class BalanceScreen extends ConsumerWidget {
  const BalanceScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summary = ref.watch(balanceSummaryProvider);
    final balances = ref.watch(memberBalancesProvider);

    return Scaffold(
      body: Stack(
        children: [
          // ── Deep space background ──
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF0A0E1A),
                    Color(0xFF0D1520),
                    Color(0xFF0A0E1A),
                  ],
                ),
              ),
            ),
          ),
          // Teal accent orb
          Positioned(
            top: -60,
            left: -40,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppColors.primary.withValues(alpha: 0.15),
                    AppColors.primary.withValues(alpha: 0.03),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          // Violet accent orb
          Positioned(
            bottom: 100,
            right: -60,
            child: Container(
              width: 180,
              height: 180,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppColors.accent.withValues(alpha: 0.08),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          // ── Content ──
          SafeArea(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
              children: [
                // ── Header ──
                _buildHeader(context),
                const Gap(20),

                // ── Summary Stats ──
                Row(
                  children: [
                    Expanded(
                      child: _buildGlassStatCard(
                        icon: LucideIcons.shoppingCart,
                        label: 'Total Bazar',
                        value: '৳${summary.totalBazar.toStringAsFixed(0)}',
                        color: AppColors.bazarColor,
                        delay: 100,
                      ),
                    ),
                    const Gap(10),
                    Expanded(
                      child: _buildGlassStatCard(
                        icon: LucideIcons.utensils,
                        label: 'Total Meals',
                        value: summary.totalMeals.toStringAsFixed(1),
                        color: AppColors.mealColor,
                        delay: 150,
                      ),
                    ),
                  ],
                ),
                const Gap(14),

                // ── Meal Rate Hero Card ──
                _buildMealRateHero(summary.mealRate),
                const Gap(24),

                // ── Member Balances ──
                _sectionLabel('Member balances'),
                const Gap(4),
                Text(
                  'Positive = will receive · Negative = owes',
                  style: AppTypography.bodySmall.copyWith(
                    color: Colors.white.withValues(alpha: 0.25),
                  ),
                ),
                const Gap(14),

                ...balances.asMap().entries.map((entry) {
                  return _buildBalanceTile(context, entry.value, entry.key);
                }),
                const Gap(20),

                // ── Formula Card ──
                _buildFormulaCard(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ────────────────────────────────────────────────────────────────
  // HEADER
  // ────────────────────────────────────────────────────────────────

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: LinearGradient(
              colors: [
                AppColors.primary.withValues(alpha: 0.25),
                AppColors.primary.withValues(alpha: 0.08),
              ],
            ),
          ),
          child: const Icon(LucideIcons.wallet, color: AppColors.primary, size: 20),
        ),
        const Gap(12),
        Text(
          'Balance',
          style: AppTypography.headlineMedium.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
        const Spacer(),
        _glassIconButton(
          icon: LucideIcons.share2,
          onTap: () => HapticService.lightTap(),
        ),
      ],
    ).animate().fadeIn(duration: 400.ms).slideY(begin: -0.05);
  }

  Widget _glassIconButton({required IconData icon, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
          child: Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white.withValues(alpha: 0.06),
              border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
            ),
            child: Icon(icon, size: 18, color: Colors.white.withValues(alpha: 0.6)),
          ),
        ),
      ),
    );
  }

  // ────────────────────────────────────────────────────────────────
  // GLASS STAT CARD
  // ────────────────────────────────────────────────────────────────

  Widget _buildGlassStatCard({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
    int delay = 0,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: AppSpacing.accentCard(accent: color, radius: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  gradient: RadialGradient(
                    colors: [
                      color.withValues(alpha: 0.3),
                      color.withValues(alpha: 0.1),
                    ],
                  ),
                ),
                child: Icon(icon, color: color, size: 16),
              ),
              const Gap(10),
              Text(
                value,
                style: AppTypography.headlineSmall.copyWith(
                  color: color,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                label,
                style: AppTypography.bodySmall.copyWith(
                  color: Colors.white.withValues(alpha: 0.4),
                ),
              ),
            ],
          ),
        ),
      ),
    ).animate().fadeIn(delay: Duration(milliseconds: delay)).slideY(begin: 0.08);
  }

  // ────────────────────────────────────────────────────────────────
  // MEAL RATE HERO CARD
  // ────────────────────────────────────────────────────────────────

  Widget _buildMealRateHero(double mealRate) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: AppSpacing.gradientCard(
            gradient: AppColors.gradientBalance,
            radius: 20,
          ),
          child: Row(
            children: [
              // Animated icon halo
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      Colors.white.withValues(alpha: 0.15),
                      Colors.white.withValues(alpha: 0.05),
                    ],
                  ),
                ),
                child: const Icon(LucideIcons.calculator, color: Colors.white, size: 24),
              ),
              const Gap(16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Meal Rate',
                      style: AppTypography.bodySmall.copyWith(
                        color: Colors.white.withValues(alpha: 0.5),
                        letterSpacing: 0.5,
                      ),
                    ),
                    const Gap(2),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        TweenAnimationBuilder<double>(
                          tween: Tween(begin: 0, end: mealRate),
                          duration: const Duration(milliseconds: 1200),
                          curve: Curves.easeOutCubic,
                          builder: (context, value, _) => Text(
                            '৳${value.toStringAsFixed(2)}',
                            style: AppTypography.headlineMedium.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const Gap(4),
                        Text(
                          '/ meal',
                          style: AppTypography.bodySmall.copyWith(
                            color: Colors.white.withValues(alpha: 0.4),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Icon(
                LucideIcons.trendingUp,
                color: AppColors.accentAlt.withValues(alpha: 0.3),
                size: 32,
              ),
            ],
          ),
        ),
      ),
    ).animate(delay: 200.ms).fadeIn().slideY(begin: 0.08);
  }

  // ────────────────────────────────────────────────────────────────
  // SECTION LABEL
  // ────────────────────────────────────────────────────────────────

  Widget _sectionLabel(String text) {
    return Row(
      children: [
        Container(
          width: 3,
          height: 14,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(2),
            color: AppColors.primary,
          ),
        ),
        const Gap(8),
        Text(
          text,
          style: AppTypography.labelMedium.copyWith(
            color: Colors.white.withValues(alpha: 0.35),
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  // ────────────────────────────────────────────────────────────────
  // BALANCE TILE
  // ────────────────────────────────────────────────────────────────

  Widget _buildBalanceTile(
    BuildContext context,
    MemberBalance balance,
    int index,
  ) {
    final isPositive = balance.balance >= 0;
    final balanceColor =
        isPositive ? AppColors.moneyPositive : AppColors.moneyNegative;

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
          child: Container(
            decoration: AppSpacing.accentCard(
              accent: balanceColor,
              radius: 16,
            ),
            child: ExpansionTile(
              initiallyExpanded: index == 0,
              tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              shape: const Border(),
              collapsedShape: const Border(),
              iconColor: Colors.white.withValues(alpha: 0.3),
              collapsedIconColor: Colors.white.withValues(alpha: 0.2),
              title: Row(
                children: [
                  // Avatar with balance glow ring
                  Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: balanceColor.withValues(alpha: 0.4),
                        width: 2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: balanceColor.withValues(alpha: 0.15),
                          blurRadius: 8,
                        ),
                      ],
                    ),
                    child: AppMemberAvatar(
                      name: balance.name,
                      size: 36,
                      backgroundColor: balanceColor.withValues(alpha: 0.15),
                    ),
                  ),
                  const Gap(12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          balance.name,
                          style: AppTypography.bodyMedium.copyWith(
                            color: Colors.white.withValues(alpha: 0.85),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Row(
                          children: [
                            Icon(
                              isPositive
                                  ? LucideIcons.trendingUp
                                  : LucideIcons.trendingDown,
                              size: 12,
                              color: balanceColor.withValues(alpha: 0.7),
                            ),
                            const Gap(4),
                            Text(
                              isPositive ? 'Will receive' : 'Owes',
                              style: AppTypography.labelSmall.copyWith(
                                color: balanceColor.withValues(alpha: 0.7),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // Balance amount
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: balanceColor.withValues(alpha: 0.1),
                      border: Border.all(color: balanceColor.withValues(alpha: 0.15)),
                    ),
                    child: Text(
                      '${isPositive ? '+' : ''}৳${balance.balance.toStringAsFixed(0)}',
                      style: AppTypography.titleMedium.copyWith(
                        color: balanceColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.white.withValues(alpha: 0.03),
                  ),
                  child: Column(
                    children: [
                      _buildBreakdownRow(
                        icon: LucideIcons.utensils,
                        label: 'Meals consumed',
                        value: '${balance.totalMeals.toStringAsFixed(1)} meals',
                        color: AppColors.mealColor,
                      ),
                      _divider(),
                      _buildBreakdownRow(
                        icon: LucideIcons.calculator,
                        label: 'Meal cost',
                        value: '৳${balance.mealCost.toStringAsFixed(0)}',
                        color: Colors.white.withValues(alpha: 0.5),
                      ),
                      _divider(),
                      _buildBreakdownRow(
                        icon: LucideIcons.shoppingCart,
                        label: 'Bazar contributed',
                        value: '৳${balance.totalBazar.toStringAsFixed(0)}',
                        color: AppColors.bazarColor,
                      ),
                      _divider(),
                      _buildBreakdownRow(
                        icon: LucideIcons.wallet,
                        label: 'Balance',
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
          ),
        ),
      ),
    ).animate().fadeIn(delay: Duration(milliseconds: 300 + index * 60)).slideY(begin: 0.05);
  }

  Widget _buildBreakdownRow({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
    bool isBold = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Container(
            width: 26,
            height: 26,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              color: color.withValues(alpha: 0.1),
            ),
            child: Icon(icon, size: 13, color: color),
          ),
          const Gap(10),
          Expanded(
            child: Text(
              label,
              style: AppTypography.bodySmall.copyWith(
                color: Colors.white.withValues(alpha: 0.4),
              ),
            ),
          ),
          Text(
            value,
            style: AppTypography.bodyMedium.copyWith(
              color: color,
              fontWeight: isBold ? FontWeight.w700 : FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _divider() {
    return Container(
      height: 1,
      margin: const EdgeInsets.symmetric(vertical: 2),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.transparent,
            Colors.white.withValues(alpha: 0.06),
            Colors.transparent,
          ],
        ),
      ),
    );
  }

  // ────────────────────────────────────────────────────────────────
  // FORMULA CARD
  // ────────────────────────────────────────────────────────────────

  Widget _buildFormulaCard(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: AppColors.info.withValues(alpha: 0.05),
            border: Border.all(color: AppColors.info.withValues(alpha: 0.12)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      color: AppColors.info.withValues(alpha: 0.15),
                    ),
                    child: const Icon(LucideIcons.info, size: 13, color: AppColors.info),
                  ),
                  const Gap(8),
                  Text(
                    'How balance is calculated',
                    style: AppTypography.labelMedium.copyWith(
                      color: AppColors.info.withValues(alpha: 0.8),
                    ),
                  ),
                ],
              ),
              const Gap(12),
              Text(
                '''1. Meal Rate = Total Bazar \u00F7 Total Meals
2. Meal Cost = Your Meals \u00D7 Meal Rate
3. Balance = Your Bazar - Your Meal Cost

Positive balance: You contributed more than consumed
Negative balance: You consumed more than contributed''',
                style: AppTypography.bodySmall.copyWith(
                  color: Colors.white.withValues(alpha: 0.35),
                  height: 1.6,
                ),
              ),
            ],
          ),
        ),
      ),
    ).animate(delay: 500.ms).fadeIn();
  }
}
