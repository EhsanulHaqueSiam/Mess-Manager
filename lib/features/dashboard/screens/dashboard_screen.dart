import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:go_router/go_router.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:mess_manager/core/router/app_router.dart';
import 'package:mess_manager/core/theme/app_theme.dart';
import 'package:mess_manager/core/providers/members_provider.dart';
import 'package:mess_manager/core/providers/smart_suggestions_provider.dart';
import 'package:mess_manager/core/services/haptic_service.dart';
import 'package:mess_manager/features/meals/providers/meals_provider.dart';
import 'package:mess_manager/features/bazar/providers/bazar_provider.dart';
import 'package:mess_manager/features/balance/providers/balance_provider.dart';
import 'package:mess_manager/features/meals/widgets/add_meal_sheet.dart';
import 'package:mess_manager/features/bazar/widgets/add_bazar_sheet.dart';
import 'package:mess_manager/shared/widgets/smart_suggestion_card.dart';
import 'package:mess_manager/shared/widgets/party_splitter_sheet.dart';
import 'package:mess_manager/shared/widgets/test_mode_switcher.dart';
import 'package:mess_manager/features/dashboard/widgets/notification_alerts.dart';
import 'package:mess_manager/features/dashboard/widgets/meal_rate_breakdown_card.dart';
import 'package:mess_manager/features/money/widgets/add_transaction_sheet.dart';
import 'package:mess_manager/core/widgets/speed_dial_fab.dart';
import 'package:mess_manager/core/providers/role_provider.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentBalance = ref.watch(currentMemberBalanceProvider);
    final summary = ref.watch(balanceSummaryProvider);
    final meals = ref.watch(mealsProvider);
    final bazarEntries = ref.watch(bazarEntriesProvider);
    final members = ref.watch(membersProvider);
    final daysSinceBazar = ref.watch(daysSinceLastBazarProvider);
    final activities = _buildActivityList(meals, bazarEntries, members);
    final displayActivities = activities.take(5).toList();

    // Today's stats
    final now = DateTime.now();
    final todayStart = DateTime(now.year, now.month, now.day);
    final todayMealCount = meals.where((m) {
      final d = m.createdAt;
      return d != null && !d.isBefore(todayStart);
    }).fold<num>(0, (sum, m) => sum + m.count);
    final todayBazarTotal = bazarEntries.where((e) {
      final d = e.createdAt;
      return d != null && !d.isBefore(todayStart);
    }).fold<num>(0, (sum, e) => sum + e.amount);

    return Scaffold(
      body: Stack(
        children: [
          const _AuroraMesh(),
          SafeArea(
            child: RefreshIndicator(
              onRefresh: () async {
                HapticService.lightTap();
                ref.invalidate(mealsProvider);
                ref.invalidate(bazarEntriesProvider);
                ref.invalidate(membersProvider);
                ref.invalidate(balanceSummaryProvider);
                ref.invalidate(currentMemberBalanceProvider);
                await Future.delayed(const Duration(milliseconds: 300));
              },
              color: AppColors.primaryLight,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(context, daysSinceBazar),
                    const Gap(12),
                    _buildMonthContext(context),
                    const Gap(20),
                    _buildHeroBalance(context, currentBalance, summary),
                    const Gap(16),
                    _buildTodayPulse(
                      context,
                      todayMealCount: todayMealCount,
                      todayBazarTotal: todayBazarTotal,
                      avgDailySpend: now.day > 0
                          ? summary.totalBazar / now.day
                          : 0,
                    ),
                    const Gap(16),
                    SmartSuggestionCard(
                      onAddMeal: () => _showAddMealSheet(context),
                      onAddBazar: () => _showAddBazarSheet(context),
                      onCheckList: () => context.go(AppRoutes.bazar),
                    ),
                    const Gap(16),
                    NotificationAlertsArea(alerts: getSampleAlerts()),
                    const Gap(24),
                    _sectionLabel(context, 'Quick actions'),
                    const Gap(12),
                    _buildQuickActions(context),
                    const Gap(28),
                    _sectionLabel(context, 'Explore'),
                    const Gap(12),
                    _buildModulesGrid(context),
                    const Gap(24),
                    const MealRateBreakdownCard(),
                    const Gap(24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(child: _sectionLabel(context, 'Activity')),
                        GestureDetector(
                          onTap: () {},
                          child: Text(
                            'See all',
                            style: AppTypography.labelSmall.copyWith(
                              color: AppColors.primaryLight,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Gap(16),
                    if (displayActivities.isEmpty)
                      _buildEmptyActivity(context)
                    else
                      ...displayActivities.asMap().entries.map(
                        (entry) => _buildTimelineItem(
                          context,
                          entry.value,
                          entry.key,
                          entry.key == displayActivities.length - 1,
                        ),
                      ),
                    const Gap(100),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: _buildSpeedDial(context, ref),
    );
  }

  // ──────────────────── Header ────────────────────

  Widget _buildHeader(BuildContext context, int? daysSinceBazar) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Greeting label with gradient shimmer
              ShaderMask(
                shaderCallback: (bounds) => const LinearGradient(
                  colors: [
                    AppColors.primaryLight,
                    AppColors.accentAlt,
                    AppColors.primaryLight,
                  ],
                ).createShader(bounds),
                child: Text(
                  _getGreeting(),
                  style: AppTypography.labelSmall.copyWith(
                    color: Colors.white,
                    letterSpacing: 1.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              )
                  .animate()
                  .fadeIn(duration: 600.ms)
                  .slideX(begin: -0.05)
                  .then()
                  .shimmer(
                    duration: 3.seconds,
                    color: AppColors.accentAlt.withValues(alpha: 0.3),
                  ),
              const Gap(4),
              Text(
                'Area51 Mess',
                style: AppTypography.headlineLarge.copyWith(
                  color: context.textPrimary,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.5,
                ),
              )
                  .animate()
                  .fadeIn(delay: 100.ms, duration: 600.ms)
                  .slideX(begin: -0.03),
            ],
          ),
        ),
        if (kDebugMode) const TestModeSwitcher(),
        const Gap(8),
        if (daysSinceBazar != null) ...[
          const ExpenseTimerWidget(),
          const Gap(8),
        ],
        _buildProfileOrb(context),
      ],
    );
  }

  Widget _buildProfileOrb(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(2.5),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const LinearGradient(
          colors: [
            AppColors.primaryLight,
            AppColors.accentAlt,
            AppColors.accent,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryLight.withValues(alpha: 0.4),
            blurRadius: 16,
            spreadRadius: -2,
          ),
          BoxShadow(
            color: AppColors.accent.withValues(alpha: 0.2),
            blurRadius: 24,
            spreadRadius: -4,
          ),
        ],
      ),
      child: CircleAvatar(
        radius: 20,
        backgroundColor: context.surfaceColor,
        child: const Icon(LucideIcons.user, color: AppColors.primaryLight,
            size: 18),
      ),
    )
        .animate()
        .scale(
            delay: 300.ms, duration: 500.ms, curve: Curves.elasticOut)
        .then()
        .animate(onPlay: (c) => c.repeat(reverse: true))
        .custom(
          duration: 3.seconds,
          curve: Curves.easeInOut,
          builder: (context, value, child) => Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppColors.primaryLight
                      .withValues(alpha: 0.2 + value * 0.2),
                  blurRadius: 12 + value * 8,
                  spreadRadius: -2,
                ),
              ],
            ),
            child: child,
          ),
        );
  }

  // ──────────────────── Month Context ────────────────────

  static const _monthNames = [
    'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December',
  ];

  Widget _buildMonthContext(BuildContext context) {
    final now = DateTime.now();
    final daysInMonth = DateUtils.getDaysInMonth(now.year, now.month);
    final progress = now.day / daysInMonth;

    return Column(
      children: [
        Row(
          children: [
            // Month pill
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: LinearGradient(
                  colors: [
                    AppColors.primaryLight.withValues(alpha: 0.08),
                    AppColors.accent.withValues(alpha: 0.04),
                  ],
                ),
                border: Border.all(
                  color: AppColors.primaryLight.withValues(alpha: 0.12),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    LucideIcons.calendar,
                    size: 12,
                    color: AppColors.primaryLight.withValues(alpha: 0.7),
                  ),
                  const Gap(6),
                  Text(
                    '${_monthNames[now.month - 1]} ${now.year}',
                    style: AppTypography.labelSmall.copyWith(
                      color: context.textSecondary,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.3,
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
            Text(
              'Day ${now.day} of $daysInMonth',
              style: GoogleFonts.jetBrainsMono(
                fontSize: 10,
                fontWeight: FontWeight.w500,
                color: context.textMuted,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
        const Gap(8),
        // Progress bar
        ClipRRect(
          borderRadius: BorderRadius.circular(2),
          child: SizedBox(
            height: 3,
            child: Stack(
              children: [
                // Track
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.04),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                // Fill
                FractionallySizedBox(
                  widthFactor: progress,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(2),
                      gradient: const LinearGradient(
                        colors: [
                          AppColors.primaryLight,
                          AppColors.accentAlt,
                        ],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primaryLight.withValues(alpha: 0.4),
                          blurRadius: 6,
                          spreadRadius: -1,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    )
        .animate()
        .fadeIn(delay: 150.ms, duration: 500.ms)
        .slideY(begin: -0.03);
  }

  // ──────────────────── Today's Pulse ────────────────────

  Widget _buildTodayPulse(
    BuildContext context, {
    required num todayMealCount,
    required num todayBazarTotal,
    required double avgDailySpend,
  }) {
    return Row(
      children: [
        _todayStatChip(
          context,
          icon: LucideIcons.utensils,
          value: todayMealCount.toStringAsFixed(0),
          label: 'Meals Today',
          color: AppColors.mealColor,
        ),
        const Gap(8),
        _todayStatChip(
          context,
          icon: LucideIcons.shoppingCart,
          value: '\u09F3${todayBazarTotal.toStringAsFixed(0)}',
          label: 'Spent Today',
          color: AppColors.bazarColor,
        ),
        const Gap(8),
        _todayStatChip(
          context,
          icon: LucideIcons.activity,
          value: '\u09F3${avgDailySpend.toStringAsFixed(0)}',
          label: 'Avg/Day',
          color: AppColors.accentWarm,
        ),
      ],
    )
        .animate(delay: 200.ms)
        .fadeIn(duration: 500.ms)
        .slideY(begin: 0.04);
  }

  Widget _todayStatChip(
    BuildContext context, {
    required IconData icon,
    required String value,
    required String label,
    required Color color,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
          color: color.withValues(alpha: 0.06),
          border: Border.all(color: color.withValues(alpha: 0.1)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: color.withValues(alpha: 0.12),
              ),
              child: Icon(icon, color: color, size: 12),
            ),
            const Gap(6),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    value,
                    style: GoogleFonts.jetBrainsMono(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: context.textPrimary,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    label,
                    style: AppTypography.labelSmall.copyWith(
                      color: context.textMuted,
                      fontSize: 9,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ──────────────────── Empty Activity State ────────────────────

  Widget _buildEmptyActivity(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        color: Colors.white.withValues(alpha: 0.02),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.04),
        ),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  AppColors.primaryLight.withValues(alpha: 0.1),
                  AppColors.primaryLight.withValues(alpha: 0.02),
                ],
              ),
            ),
            child: Icon(
              LucideIcons.activity,
              color: AppColors.primaryLight.withValues(alpha: 0.4),
              size: 28,
            ),
          ),
          const Gap(12),
          Text(
            'No activity yet',
            style: AppTypography.titleSmall.copyWith(
              color: context.textSecondary,
            ),
          ),
          const Gap(4),
          Text(
            'Meals and bazar entries will appear here',
            style: AppTypography.bodySmall.copyWith(
              color: context.textMuted,
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 400.ms);
  }

  // ──────────────────── Hero Balance ────────────────────

  Widget _buildHeroBalance(
    BuildContext context,
    MemberBalance? balance,
    BalanceSummary summary,
  ) {
    final amount = balance?.balance ?? 0;
    final isPositive = amount >= 0;
    final balanceColor =
        isPositive ? AppColors.moneyPositive : AppColors.moneyNegative;

    return GestureDetector(
      onTap: () {
        HapticService.lightTap();
        context.go(AppRoutes.balance);
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
          boxShadow: [
            // Outer glow — primary
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.15),
              blurRadius: 40,
              spreadRadius: -8,
              offset: const Offset(0, 12),
            ),
            // Secondary glow for depth
            BoxShadow(
              color: AppColors.accent.withValues(alpha: 0.06),
              blurRadius: 60,
              spreadRadius: -12,
              offset: const Offset(0, 20),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 32, sigmaY: 32),
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                // Holographic gradient layers
                gradient: LinearGradient(
                  colors: [
                    Colors.white.withValues(alpha: 0.10),
                    Colors.white.withValues(alpha: 0.03),
                    AppColors.primaryLight.withValues(alpha: 0.03),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  stops: const [0.0, 0.5, 1.0],
                ),
                border: Border.all(
                  width: 1.2,
                  color: Colors.white.withValues(alpha: 0.12),
                ),
              ),
              child: Stack(
                children: [
                  // Internal holographic shimmer layer
                  Positioned.fill(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.circular(AppSpacing.radiusLg),
                        gradient: LinearGradient(
                          colors: [
                            AppColors.primaryLight.withValues(alpha: 0.04),
                            AppColors.accent.withValues(alpha: 0.02),
                            AppColors.accentAlt.withValues(alpha: 0.04),
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomRight,
                        ),
                      ),
                    ),
                  ),
                  // Floating noise/grain texture
                  Positioned(
                    top: -20,
                    right: -20,
                    child: Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            AppColors.primaryLight.withValues(alpha: 0.06),
                            AppColors.primaryLight.withValues(alpha: 0.0),
                          ],
                        ),
                      ),
                    ),
                  ),
                  // Actual content
                  Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    // Glowing wallet icon
                                    Container(
                                      padding: const EdgeInsets.all(7),
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            AppColors.primary
                                                .withValues(alpha: 0.3),
                                            AppColors.primaryLight
                                                .withValues(alpha: 0.1),
                                          ],
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(9),
                                        boxShadow: [
                                          BoxShadow(
                                            color: AppColors.primaryLight
                                                .withValues(alpha: 0.2),
                                            blurRadius: 8,
                                            spreadRadius: -2,
                                          ),
                                        ],
                                      ),
                                      child: const Icon(
                                        LucideIcons.wallet,
                                        color: AppColors.primaryLight,
                                        size: 14,
                                      ),
                                    ),
                                    const Gap(8),
                                    Text(
                                      'Your Balance',
                                      style:
                                          AppTypography.labelMedium.copyWith(
                                        color: context.textSecondary,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                  ],
                                ),
                                const Gap(14),
                                // Animated balance with JetBrains Mono + glow
                                TweenAnimationBuilder<double>(
                                  tween: Tween(
                                      begin: 0, end: amount.toDouble()),
                                  duration:
                                      const Duration(milliseconds: 1200),
                                  curve: Curves.easeOutCubic,
                                  builder: (context, value, _) {
                                    final text =
                                        '${value >= 0 ? '+' : ''}\u09F3${value.abs().toStringAsFixed(0)}';
                                    return Stack(
                                      children: [
                                        // Glow layer behind text
                                        Text(
                                          text,
                                          style: GoogleFonts.jetBrainsMono(
                                            fontSize: 36,
                                            fontWeight: FontWeight.w800,
                                            height: 1.0,
                                            letterSpacing: -1.0,
                                            color: balanceColor
                                                .withValues(alpha: 0.15),
                                          ),
                                        ),
                                        // Actual text
                                        Text(
                                          text,
                                          style: GoogleFonts.jetBrainsMono(
                                            fontSize: 36,
                                            fontWeight: FontWeight.w800,
                                            height: 1.0,
                                            letterSpacing: -1.0,
                                            color: context.textPrimary,
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                          // Status badge with glow
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: balanceColor.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color:
                                    balanceColor.withValues(alpha: 0.25),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color:
                                      balanceColor.withValues(alpha: 0.1),
                                  blurRadius: 12,
                                  spreadRadius: -4,
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  isPositive
                                      ? LucideIcons.trendingUp
                                      : LucideIcons.trendingDown,
                                  color: balanceColor,
                                  size: 14,
                                ),
                                const Gap(4),
                                Text(
                                  isPositive ? 'Positive' : 'Owes',
                                  style:
                                      AppTypography.labelSmall.copyWith(
                                    color: balanceColor,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          )
                              .animate(
                                  onPlay: (c) =>
                                      c.repeat(reverse: true))
                              .custom(
                                duration: 2500.ms,
                                curve: Curves.easeInOut,
                                builder: (context, value, child) =>
                                    Container(
                                  decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.circular(20),
                                    boxShadow: [
                                      BoxShadow(
                                        color: balanceColor.withValues(
                                            alpha: 0.05 + value * 0.1),
                                        blurRadius: 8 + value * 6,
                                        spreadRadius: -2,
                                      ),
                                    ],
                                  ),
                                  child: child,
                                ),
                              ),
                        ],
                      ),
                      const Gap(20),
                      // Holographic divider line
                      Container(
                        height: 1,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.white.withValues(alpha: 0),
                              AppColors.primaryLight
                                  .withValues(alpha: 0.12),
                              AppColors.accent.withValues(alpha: 0.08),
                              Colors.white.withValues(alpha: 0),
                            ],
                            stops: const [0.0, 0.35, 0.65, 1.0],
                          ),
                        ),
                      ),
                      const Gap(16),
                      Row(
                        children: [
                          _glassStatChip(
                            context,
                            LucideIcons.calculator,
                            'Meal Rate',
                            '\u09F3${summary.mealRate.toStringAsFixed(0)}',
                            AppColors.primaryLight,
                          ),
                          const Gap(10),
                          _glassStatChip(
                            context,
                            LucideIcons.utensils,
                            'Meals',
                            '${balance?.totalMeals.toStringAsFixed(0) ?? 0}',
                            AppColors.mealColor,
                          ),
                          const Gap(10),
                          _glassStatChip(
                            context,
                            LucideIcons.users,
                            'Members',
                            '${summary.memberCount}',
                            AppColors.accentAlt,
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    )
        .animate()
        .fadeIn(duration: 700.ms)
        .scale(
          begin: const Offset(0.96, 0.96),
          curve: Curves.easeOutCubic,
        )
        .then()
        .shimmer(
          duration: 4.seconds,
          delay: 1.seconds,
          color: AppColors.primaryLight.withValues(alpha: 0.05),
        );
  }

  Widget _glassStatChip(
    BuildContext context,
    IconData icon,
    String label,
    String value,
    Color color,
  ) {
    return Expanded(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  color.withValues(alpha: 0.08),
                  color.withValues(alpha: 0.03),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
              border: Border.all(color: color.withValues(alpha: 0.15)),
            ),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: color.withValues(alpha: 0.1),
                    boxShadow: [
                      BoxShadow(
                        color: color.withValues(alpha: 0.15),
                        blurRadius: 8,
                        spreadRadius: -2,
                      ),
                    ],
                  ),
                  child: Icon(icon, color: color, size: 14),
                ),
                const Gap(6),
                Text(
                  value,
                  style: GoogleFonts.jetBrainsMono(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: context.textPrimary,
                  ),
                ),
                const Gap(2),
                Text(
                  label,
                  style: AppTypography.labelSmall.copyWith(
                    color: context.textMuted,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ──────────────────── Quick Actions ────────────────────

  Widget _buildQuickActions(BuildContext context) {
    final actions = [
      ('Add Meal', LucideIcons.plus, AppColors.mealColor,
          () => _showAddMealSheet(context)),
      ('Money', LucideIcons.arrowLeftRight, AppColors.accentWarm,
          () => context.push(AppRoutes.money)),
      ('Split', LucideIcons.partyPopper, AppColors.accent,
          () => _showPartySplitter(context)),
    ];

    return Row(
      children: actions.asMap().entries.map((entry) {
        final i = entry.key;
        final (label, icon, color, onTap) = entry.value;
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(left: i > 0 ? 10 : 0),
            child: _QuickActionPill(
              label: label,
              icon: icon,
              color: color,
              onTap: onTap,
              delay: i * 80,
            ),
          ),
        );
      }).toList(),
    ).animate().fadeIn(delay: 200.ms, duration: 500.ms).slideY(begin: 0.06);
  }

  // ──────────────────── Modules Grid ────────────────────

  Widget _buildModulesGrid(BuildContext context) {
    final features = [
      ('Analytics', LucideIcons.barChart3, AppColors.primaryLight,
          AppRoutes.analytics),
      ('Members', LucideIcons.users, AppColors.accentAlt, AppRoutes.members),
      ('Vacation', LucideIcons.palmtree, AppColors.moneyPositive,
          AppRoutes.vacation),
      ('DESCO', LucideIcons.zap, AppColors.accentWarm, AppRoutes.desco),
      ('Ramadan', LucideIcons.moon, AppColors.accent, AppRoutes.ramadan),
      ('Settlement', LucideIcons.receipt, AppColors.moneyNegative,
          AppRoutes.settlement),
      ('Duties', LucideIcons.clipboardList, AppColors.info, AppRoutes.duties),
      ('Info', LucideIcons.info, AppColors.info, AppRoutes.info),
    ];

    return GridView.count(
      crossAxisCount: 4,
      mainAxisSpacing: 10,
      crossAxisSpacing: 10,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      childAspectRatio: 0.82,
      children: features.asMap().entries.map((entry) {
        final (label, icon, color, route) = entry.value;
        return _ModuleCard(
          label: label,
          icon: icon,
          color: color,
          delay: entry.key * 50,
          onTap: () {
            HapticService.lightTap();
            context.push(route);
          },
        );
      }).toList(),
    );
  }

  // ──────────────────── Section Label ────────────────────

  Widget _sectionLabel(BuildContext context, String text) {
    return Row(
      children: [
        Container(
          width: 3,
          height: 14,
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const Gap(10),
        Text(
          text,
          style: AppTypography.labelMedium.copyWith(
            color: Colors.white.withValues(alpha: 0.35),
            fontWeight: FontWeight.w600,
          ),
        ),
        const Gap(10),
        Expanded(
          child: Container(
            height: 1,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  context.borderColor.withValues(alpha: 0.2),
                  context.borderColor.withValues(alpha: 0.0),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ──────────────────── Activity Timeline ────────────────────

  Widget _buildTimelineItem(
    BuildContext context,
    _Activity activity,
    int index,
    bool isLast,
  ) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 28,
            child: Column(
              children: [
                const Gap(6),
                // Pulsing timeline dot
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        activity.color,
                        activity.color.withValues(alpha: 0.5),
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: activity.color.withValues(alpha: 0.6),
                        blurRadius: 10,
                        spreadRadius: -2,
                      ),
                    ],
                  ),
                  child: Center(
                    child: Container(
                      width: 4,
                      height: 4,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                )
                    .animate(
                        onPlay: (c) => c.repeat(reverse: true))
                    .scale(
                      begin: const Offset(1.0, 1.0),
                      end: const Offset(1.2, 1.2),
                      duration: 2.seconds,
                      curve: Curves.easeInOut,
                      delay: Duration(milliseconds: index * 400),
                    ),
                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 1.5,
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            activity.color.withValues(alpha: 0.4),
                            activity.color.withValues(alpha: 0.08),
                            context.borderColor.withValues(alpha: 0.04),
                          ],
                          stops: const [0.0, 0.5, 1.0],
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const Gap(10),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
                child: Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        context.cardColor.withValues(alpha: 0.5),
                        context.cardColor.withValues(alpha: 0.25),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                    border: Border.all(
                      color: activity.color.withValues(alpha: 0.08),
                    ),
                  ),
                  child: Row(
                    children: [
                      // Glowing icon container
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          gradient: RadialGradient(
                            colors: [
                              activity.color.withValues(alpha: 0.15),
                              activity.color.withValues(alpha: 0.04),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: activity.color.withValues(alpha: 0.1),
                              blurRadius: 8,
                              spreadRadius: -2,
                            ),
                          ],
                        ),
                        child: Icon(
                          activity.icon,
                          color: activity.color,
                          size: 16,
                        ),
                      ),
                      const Gap(12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Flexible(
                                  child: Text(
                                    activity.name,
                                    style: AppTypography.titleSmall.copyWith(
                                      color: context.textPrimary,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                const Gap(6),
                                Text(
                                  _formatTimeAgo(activity.time),
                                  style: AppTypography.labelSmall.copyWith(
                                    color: context.textMuted,
                                  ),
                                ),
                              ],
                            ),
                            const Gap(2),
                            Text(
                              activity.action,
                              style: AppTypography.bodySmall.copyWith(
                                color: context.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        activity.value,
                        style: GoogleFonts.jetBrainsMono(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: activity.color,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    )
        .animate(delay: Duration(milliseconds: 80 * index))
        .fadeIn(duration: 400.ms)
        .slideX(begin: 0.04);
  }

  // ──────────────────── Speed Dial FAB ────────────────────

  Widget _buildSpeedDial(BuildContext context, WidgetRef ref) {
    final canMeal = ref.watch(canAddMealProvider);
    final canBazar = ref.watch(canAddBazarProvider);
    final canTransaction = ref.watch(canAddTransactionProvider);

    final items = <SpeedDialItem>[
      SpeedDialItem(
        label: 'Add Duty',
        icon: LucideIcons.clipboardList,
        color: AppColors.success,
        onPressed: () => context.push(AppRoutes.duties),
      ),
      if (canTransaction)
        SpeedDialItem(
          label: 'Add Money',
          icon: LucideIcons.banknote,
          color: AppColors.warning,
          onPressed: () => _showAddMoneySheet(context),
        ),
      if (canBazar)
        SpeedDialItem(
          label: 'Add Bazar',
          icon: LucideIcons.shoppingCart,
          color: AppColors.bazarColor,
          onPressed: () => _showAddBazarSheet(context),
        ),
      if (canMeal)
        SpeedDialItem(
          label: 'Add Meal',
          icon: LucideIcons.utensils,
          color: AppColors.mealColor,
          onPressed: () => _showAddMealSheet(context),
        ),
    ];

    if (items.length <= 1) return const SizedBox.shrink();
    return SpeedDialFAB(items: items);
  }

  // ──────────────────── Helpers ────────────────────

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning';
    if (hour < 17) return 'Good Afternoon';
    if (hour < 21) return 'Good Evening';
    return 'Good Night';
  }

  String _formatTimeAgo(DateTime time) {
    final diff = DateTime.now().difference(time);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    return '${time.day}/${time.month}';
  }

  // ──────────────────── Sheets ────────────────────

  void _showAddMealSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const AddMealSheet(),
    );
  }

  void _showAddBazarSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const AddBazarSheet(),
    );
  }

  void _showAddMoneySheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const AddTransactionSheet(),
    );
  }

  void _showPartySplitter(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const PartySplitterSheet(),
    );
  }

  // ──────────────────── Activity Data ────────────────────

  List<_Activity> _buildActivityList(
    List meals,
    List bazarEntries,
    List members,
  ) {
    final activities = <_Activity>[];
    if (members.isEmpty) return activities;

    final memberList = members.toList();

    dynamic findMember(String? memberId) {
      if (memberId == null) return memberList.first;
      try {
        return memberList.firstWhere((m) => m.id == memberId);
      } catch (_) {
        return memberList.first;
      }
    }

    final recentMeals = [...meals]
      ..sort(
        (a, b) => b.createdAt?.compareTo(a.createdAt ?? DateTime.now()) ?? 0,
      );
    for (final meal in recentMeals.take(5)) {
      final member = findMember(meal.memberId);
      if (member != null) {
        activities.add(
          _Activity(
            name: member.name ?? 'Unknown',
            action: 'Added meal',
            value: '${meal.count} meals',
            icon: LucideIcons.utensils,
            color: AppColors.mealColor,
            time: meal.createdAt ?? DateTime.now(),
          ),
        );
      }
    }

    final recentBazar = [...bazarEntries]
      ..sort(
        (a, b) => b.createdAt?.compareTo(a.createdAt ?? DateTime.now()) ?? 0,
      );
    for (final entry in recentBazar.take(5)) {
      final member = findMember(entry.memberId);
      if (member != null) {
        activities.add(
          _Activity(
            name: member.name ?? 'Unknown',
            action: 'Bazar expense',
            value: '\u09F3${entry.amount.toStringAsFixed(0)}',
            icon: LucideIcons.shoppingCart,
            color: AppColors.bazarColor,
            time: entry.createdAt ?? DateTime.now(),
          ),
        );
      }
    }

    activities.sort((a, b) => b.time.compareTo(a.time));
    return activities;
  }
}

// ════════════════════════════════════════════════════════
// Private Widgets
// ════════════════════════════════════════════════════════

/// Animated aurora gradient mesh background with 5 breathing orbs
/// and subtle grain/noise overlay
class _AuroraMesh extends StatelessWidget {
  const _AuroraMesh();

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: ColoredBox(
        color: context.background,
        child: Stack(
          children: [
            // Orb 1 — Large primary orb, top-left
            Positioned(
              top: -100,
              left: -80,
              child: _Orb(
                size: 320,
                color: AppColors.primary,
                opacity: 0.24,
                duration: const Duration(seconds: 8),
              ),
            ),
            // Orb 2 — Secondary cosmic blue, top-right
            Positioned(
              top: 40,
              right: -100,
              child: _Orb(
                size: 280,
                color: AppColors.secondary,
                opacity: 0.18,
                duration: const Duration(seconds: 7),
                delay: const Duration(seconds: 2),
              ),
            ),
            // Orb 3 — Accent violet, mid-left
            Positioned(
              top: 300,
              left: 40,
              child: _Orb(
                size: 220,
                color: AppColors.accent,
                opacity: 0.08,
                duration: const Duration(seconds: 10),
                delay: const Duration(seconds: 4),
              ),
            ),
            // Orb 4 — Cyan glow, center-right
            Positioned(
              top: 500,
              right: -40,
              child: _Orb(
                size: 180,
                color: AppColors.accentAlt,
                opacity: 0.06,
                duration: const Duration(seconds: 9),
                delay: const Duration(seconds: 1),
              ),
            ),
            // Orb 5 — Warm thermal, bottom
            Positioned(
              bottom: -60,
              left: -20,
              child: _Orb(
                size: 200,
                color: AppColors.accentWarm,
                opacity: 0.04,
                duration: const Duration(seconds: 12),
                delay: const Duration(seconds: 3),
              ),
            ),
            // Subtle grain/noise overlay
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withValues(alpha: 0.05),
                    ],
                  ),
                ),
              ),
            ),
            // Top vignette for depth
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    center: Alignment.topCenter,
                    radius: 1.5,
                    colors: [
                      Colors.transparent,
                      Colors.black.withValues(alpha: 0.12),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Breathing gradient orb for the aurora mesh
class _Orb extends StatelessWidget {
  final double size;
  final Color color;
  final double opacity;
  final Duration duration;
  final Duration delay;

  const _Orb({
    required this.size,
    required this.color,
    required this.opacity,
    required this.duration,
    this.delay = Duration.zero,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [
            color.withValues(alpha: opacity),
            color.withValues(alpha: opacity * 0.4),
            color.withValues(alpha: opacity * 0.1),
            color.withValues(alpha: 0),
          ],
          stops: const [0, 0.35, 0.65, 1],
        ),
      ),
    )
        .animate(onPlay: (c) => c.repeat(reverse: true))
        .scale(
          begin: const Offset(1, 1),
          end: const Offset(1.18, 1.18),
          duration: duration,
          curve: Curves.easeInOut,
          delay: delay,
        )
        .moveX(
          begin: 0,
          end: size * 0.03,
          duration: duration * 1.3,
          curve: Curves.easeInOut,
          delay: delay,
        );
  }
}

/// Quick action pill — floating glass control panel with gradient accent line
/// and glowing icon container
class _QuickActionPill extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  final int delay;

  const _QuickActionPill({
    required this.label,
    required this.icon,
    required this.color,
    required this.onTap,
    this.delay = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          HapticService.lightTap();
          onTap();
        },
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    color.withValues(alpha: 0.08),
                    color.withValues(alpha: 0.02),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                border: Border.all(color: color.withValues(alpha: 0.15)),
              ),
              child: Column(
                children: [
                  // Top accent gradient line
                  Container(
                    width: 24,
                    height: 2,
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          color.withValues(alpha: 0.0),
                          color.withValues(alpha: 0.6),
                          color.withValues(alpha: 0.0),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(1),
                    ),
                  ),
                  // Glowing icon container
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      gradient: RadialGradient(
                        colors: [
                          color.withValues(alpha: 0.25),
                          color.withValues(alpha: 0.06),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: color.withValues(alpha: 0.2),
                          blurRadius: 12,
                          spreadRadius: -4,
                        ),
                      ],
                    ),
                    child: Icon(icon, color: color, size: 20),
                  )
                      .animate(
                          onPlay: (c) => c.repeat(reverse: true))
                      .custom(
                        duration: 2500.ms,
                        curve: Curves.easeInOut,
                        builder: (context, value, child) =>
                            Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: color.withValues(
                                    alpha: 0.08 + value * 0.12),
                                blurRadius: 8 + value * 6,
                                spreadRadius: -3,
                              ),
                            ],
                          ),
                          child: child,
                        ),
                      ),
                  const Gap(10),
                  Text(
                    label,
                    style: AppTypography.labelMedium.copyWith(
                      color: color,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.3,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Module grid card with radial gradient icon halo and breathing glow
class _ModuleCard extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  final int delay;

  const _ModuleCard({
    required this.label,
    required this.icon,
    required this.color,
    required this.onTap,
    this.delay = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                color.withValues(alpha: 0.07),
                color.withValues(alpha: 0.02),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            border: Border.all(color: color.withValues(alpha: 0.12)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Breathing icon with radial glow
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    colors: [
                      color.withValues(alpha: 0.22),
                      color.withValues(alpha: 0.06),
                      color.withValues(alpha: 0.0),
                    ],
                    stops: const [0.0, 0.6, 1.0],
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: color.withValues(alpha: 0.12),
                      blurRadius: 12,
                      spreadRadius: -4,
                    ),
                  ],
                ),
                child: Icon(icon, color: color, size: 22),
              )
                  .animate(
                      onPlay: (c) => c.repeat(reverse: true))
                  .custom(
                    duration: Duration(
                        milliseconds: 2500 + (delay * 20)),
                    curve: Curves.easeInOut,
                    builder: (context, value, child) => Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: color.withValues(
                                alpha: 0.05 + value * 0.08),
                            blurRadius: 8 + value * 8,
                            spreadRadius: -3,
                          ),
                        ],
                      ),
                      child: child,
                    ),
                  ),
              const Gap(8),
              Text(
                label,
                style: AppTypography.labelSmall.copyWith(
                  color: context.textSecondary,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    )
        .animate(delay: Duration(milliseconds: 300 + delay))
        .fadeIn(duration: 400.ms)
        .scale(
          begin: const Offset(0.88, 0.88),
          curve: Curves.easeOutBack,
        );
  }
}

class _Activity {
  final String name;
  final String action;
  final String value;
  final IconData icon;
  final Color color;
  final DateTime time;

  _Activity({
    required this.name,
    required this.action,
    required this.value,
    required this.icon,
    required this.color,
    required this.time,
  });
}
