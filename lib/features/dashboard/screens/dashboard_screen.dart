import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:mess_manager/core/theme/app_theme.dart';
import 'package:mess_manager/core/router/app_router.dart';
import 'package:mess_manager/core/providers/members_provider.dart';
import 'package:mess_manager/core/providers/smart_suggestions_provider.dart';
import 'package:mess_manager/features/meals/providers/meals_provider.dart';
import 'package:mess_manager/features/bazar/providers/bazar_provider.dart';
import 'package:mess_manager/features/balance/providers/balance_provider.dart';
import 'package:mess_manager/features/meals/widgets/add_meal_sheet.dart';
import 'package:mess_manager/features/bazar/widgets/add_bazar_sheet.dart';
import 'package:mess_manager/features/unified/widgets/add_entry_sheet.dart';
import 'package:mess_manager/shared/widgets/smart_suggestion_card.dart';

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

    // Recent activity (combine meals and bazar, sort by date)
    final activities = _buildActivityList(meals, bazarEntries, members);

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // Header
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Greeting
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                                  _getGreeting(),
                                  style: AppTypography.bodyMedium.copyWith(
                                    color: AppColors.textSecondaryDark,
                                  ),
                                )
                                .animate()
                                .fadeIn(duration: 300.ms)
                                .slideX(begin: -0.1),
                            const Gap(AppSpacing.xs),
                            Text(
                                  'Area51 Mess',
                                  style: AppTypography.displaySmall.copyWith(
                                    color: AppColors.textPrimaryDark,
                                  ),
                                )
                                .animate()
                                .fadeIn(duration: 400.ms)
                                .slideX(begin: -0.1),
                          ],
                        ),
                        // Profile Avatar with expense timer
                        Row(
                          children: [
                            if (daysSinceBazar != null)
                              const ExpenseTimerWidget(),
                            const Gap(AppSpacing.sm),
                            Container(
                              padding: const EdgeInsets.all(3),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: LinearGradient(
                                  colors: AppColors.gradientPrimary,
                                ),
                              ),
                              child: const CircleAvatar(
                                radius: 22,
                                backgroundColor: AppColors.cardDark,
                                child: Icon(
                                  LucideIcons.user,
                                  color: AppColors.primary,
                                  size: 20,
                                ),
                              ),
                            ).animate().scale(delay: 300.ms, duration: 400.ms),
                          ],
                        ),
                      ],
                    ),
                    const Gap(AppSpacing.xl),

                    // Balance Card
                    _buildBalanceCard(context, currentBalance, summary),
                    const Gap(AppSpacing.md),

                    // Smart Suggestions
                    SmartSuggestionCard(
                      onAddMeal: () => _showAddMealSheet(context),
                      onAddBazar: () => _showAddBazarSheet(context),
                      onCheckList: () => context.go(AppRoutes.bazar),
                    ),
                    const Gap(AppSpacing.lg),

                    // Quick Actions
                    Row(
                      children: [
                        const Icon(
                          LucideIcons.zap,
                          color: AppColors.accentAlt,
                          size: 18,
                        ),
                        const Gap(AppSpacing.sm),
                        Text(
                          'Quick Actions',
                          style: AppTypography.headlineSmall.copyWith(
                            color: AppColors.textPrimaryDark,
                          ),
                        ),
                      ],
                    ),
                    const Gap(AppSpacing.sm),
                    _buildQuickActions(context),
                    const Gap(AppSpacing.lg),

                    // Feature Modules Grid
                    Row(
                      children: [
                        Icon(
                          LucideIcons.layoutGrid,
                          color: AppColors.secondary,
                          size: 18,
                        ),
                        const Gap(AppSpacing.sm),
                        Text(
                          'Modules',
                          style: AppTypography.headlineSmall.copyWith(
                            color: AppColors.textPrimaryDark,
                          ),
                        ),
                      ],
                    ),
                    const Gap(AppSpacing.sm),
                    _buildFeatureGrid(context),
                    const Gap(AppSpacing.lg),

                    // Recent Activity Header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              LucideIcons.activity,
                              color: AppColors.primaryLight,
                              size: 18,
                            ),
                            const Gap(AppSpacing.sm),
                            Text(
                              'Recent Activity',
                              style: AppTypography.headlineSmall.copyWith(
                                color: AppColors.textPrimaryDark,
                              ),
                            ),
                          ],
                        ),
                        TextButton(
                          onPressed: () {},
                          child: Text(
                            'See all',
                            style: AppTypography.labelMedium.copyWith(
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Activity List
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) =>
                      _buildActivityItem(context, activities[index], index),
                  childCount: activities.length.clamp(0, 8),
                ),
              ),
            ),

            const SliverToBoxAdapter(child: Gap(AppSpacing.xxl)),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showUnifiedEntrySheet(context),
        icon: const Icon(LucideIcons.plus),
        label: const Text('Add'),
        backgroundColor: AppColors.primary,
      ),
    );
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning ☀️';
    if (hour < 17) return 'Good Afternoon 🌤️';
    if (hour < 21) return 'Good Evening 🌅';
    return 'Good Night 🌙';
  }

  Widget _buildBalanceCard(
    BuildContext context,
    MemberBalance? balance,
    BalanceSummary summary,
  ) {
    final isPositive = (balance?.balance ?? 0) >= 0;
    final balanceColor = isPositive
        ? AppColors.moneyPositive
        : AppColors.moneyNegative;

    return GestureDetector(
      onTap: () => context.go(AppRoutes.balance),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.primary,
              AppColors.primaryDark,
              AppColors.secondary,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.4),
              blurRadius: 24,
              offset: const Offset(0, 12),
              spreadRadius: -8,
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          LucideIcons.wallet,
                          color: Colors.white.withValues(alpha: 0.8),
                          size: 16,
                        ),
                        const Gap(AppSpacing.xs),
                        Text(
                          'Your Balance',
                          style: AppTypography.labelMedium.copyWith(
                            color: Colors.white.withValues(alpha: 0.8),
                          ),
                        ),
                      ],
                    ),
                    const Gap(AppSpacing.sm),
                    Text(
                      '${isPositive ? '+' : ''}৳${(balance?.balance ?? 0).toStringAsFixed(0)}',
                      style: AppTypography.displayLarge.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
                // Status Badge
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.sm + 4,
                    vertical: AppSpacing.xs + 2,
                  ),
                  decoration: BoxDecoration(
                    color: balanceColor.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
                    border: Border.all(
                      color: balanceColor.withValues(alpha: 0.5),
                    ),
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
                        style: AppTypography.labelSmall.copyWith(
                          color: balanceColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Gap(AppSpacing.lg),
            Container(
              height: 1,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.white.withValues(alpha: 0),
                    Colors.white.withValues(alpha: 0.3),
                    Colors.white.withValues(alpha: 0),
                  ],
                ),
              ),
            ),
            const Gap(AppSpacing.md),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem(
                  LucideIcons.calculator,
                  'Meal Rate',
                  '৳${summary.mealRate.toStringAsFixed(0)}',
                ),
                _buildStatItem(
                  LucideIcons.utensils,
                  'Your Meals',
                  '${balance?.totalMeals.toStringAsFixed(0) ?? 0}',
                ),
                _buildStatItem(
                  LucideIcons.users,
                  'Members',
                  '${summary.memberCount}',
                ),
              ],
            ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 500.ms).scale(begin: const Offset(0.95, 0.95));
  }

  Widget _buildStatItem(IconData icon, String label, String value) {
    return Column(
      children: [
        Icon(icon, color: Colors.white.withValues(alpha: 0.7), size: 18),
        const Gap(AppSpacing.xs),
        Text(
          value,
          style: AppTypography.titleMedium.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
        Text(
          label,
          style: AppTypography.labelSmall.copyWith(
            color: Colors.white.withValues(alpha: 0.7),
          ),
        ),
      ],
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _buildActionButton(
            icon: LucideIcons.plus,
            label: 'Add Meal',
            color: AppColors.mealColor,
            onTap: () => _showAddMealSheet(context),
          ),
        ),
        const Gap(AppSpacing.sm),
        Expanded(
          child: _buildActionButton(
            icon: LucideIcons.shoppingBag,
            label: 'Add Bazar',
            color: AppColors.bazarColor,
            onTap: () => _showAddBazarSheet(context),
          ),
        ),
        const Gap(AppSpacing.sm),
        Expanded(
          child: _buildActionButton(
            icon: LucideIcons.arrowLeftRight,
            label: 'Money',
            color: AppColors.accentWarm,
            onTap: () => context.go(AppRoutes.money),
          ),
        ),
      ],
    ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.1);
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        child: Container(
          padding: const EdgeInsets.symmetric(
            vertical: AppSpacing.md,
            horizontal: AppSpacing.sm,
          ),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            border: Border.all(color: color.withValues(alpha: 0.2)),
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(AppSpacing.sm),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                ),
                child: Icon(icon, color: color, size: 22),
              ),
              const Gap(AppSpacing.sm),
              Text(
                label,
                style: AppTypography.labelMedium.copyWith(
                  color: color,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureGrid(BuildContext context) {
    final features = [
      _FeatureItem(
        icon: LucideIcons.barChart3,
        label: 'Analytics',
        color: AppColors.primaryLight,
        route: AppRoutes.analytics,
      ),
      _FeatureItem(
        icon: LucideIcons.users,
        label: 'Members',
        color: AppColors.accentAlt,
        route: AppRoutes.members,
      ),
      _FeatureItem(
        icon: LucideIcons.palmtree,
        label: 'Vacation',
        color: AppColors.moneyPositive,
        route: AppRoutes.vacation,
      ),
      _FeatureItem(
        icon: LucideIcons.zap,
        label: 'DESCO',
        color: AppColors.accentWarm,
        route: AppRoutes.desco,
      ),
      _FeatureItem(
        icon: LucideIcons.moon,
        label: 'Ramadan',
        color: AppColors.secondary,
        route: AppRoutes.ramadan,
      ),
      _FeatureItem(
        icon: LucideIcons.receipt,
        label: 'Settlement',
        color: AppColors.moneyNegative,
        route: AppRoutes.settlement,
      ),
      _FeatureItem(
        icon: LucideIcons.clipboardList,
        label: 'Duties',
        color: AppColors.info,
        route: AppRoutes.duties,
      ),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: AppSpacing.sm,
        crossAxisSpacing: AppSpacing.sm,
        childAspectRatio: 1.1,
      ),
      itemCount: features.length,
      itemBuilder: (context, index) {
        final feature = features[index];
        return _buildFeatureCard(context, feature, index);
      },
    ).animate().fadeIn(delay: 250.ms).slideY(begin: 0.1);
  }

  Widget _buildFeatureCard(
    BuildContext context,
    _FeatureItem feature,
    int index,
  ) {
    return Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => context.go(feature.route),
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            child: Container(
              padding: const EdgeInsets.all(AppSpacing.sm),
              decoration: BoxDecoration(
                color: feature.color.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                border: Border.all(color: feature.color.withValues(alpha: 0.2)),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.sm),
                    decoration: BoxDecoration(
                      color: feature.color.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                    ),
                    child: Icon(feature.icon, color: feature.color, size: 20),
                  ),
                  const Gap(AppSpacing.xs),
                  Text(
                    feature.label,
                    style: AppTypography.labelSmall.copyWith(
                      color: feature.color,
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
        .animate(delay: (50 * index).ms)
        .fadeIn()
        .scale(begin: const Offset(0.9, 0.9));
  }

  List<_Activity> _buildActivityList(
    List meals,
    List bazarEntries,
    List members,
  ) {
    final activities = <_Activity>[];

    // Add recent meals (last 5)
    final recentMeals = [...meals]
      ..sort(
        (a, b) => b.createdAt?.compareTo(a.createdAt ?? DateTime.now()) ?? 0,
      );
    for (final meal in recentMeals.take(5)) {
      final member = members.firstWhere(
        (m) => m.id == meal.memberId,
        orElse: () => members.first,
      );
      activities.add(
        _Activity(
          name: member.name,
          action: 'Added meal',
          value: '${meal.count} meals',
          icon: LucideIcons.utensils,
          color: AppColors.mealColor,
          time: meal.createdAt ?? DateTime.now(),
        ),
      );
    }

    // Add recent bazar entries (last 5)
    final recentBazar = [...bazarEntries]
      ..sort(
        (a, b) => b.createdAt?.compareTo(a.createdAt ?? DateTime.now()) ?? 0,
      );
    for (final entry in recentBazar.take(5)) {
      final member = members.firstWhere(
        (m) => m.id == entry.memberId,
        orElse: () => members.first,
      );
      activities.add(
        _Activity(
          name: member.name,
          action: 'Bazar expense',
          value: '৳${entry.amount.toStringAsFixed(0)}',
          icon: LucideIcons.shoppingCart,
          color: AppColors.bazarColor,
          time: entry.createdAt ?? DateTime.now(),
        ),
      );
    }

    // Sort by time
    activities.sort((a, b) => b.time.compareTo(a.time));
    return activities;
  }

  Widget _buildActivityItem(
    BuildContext context,
    _Activity activity,
    int index,
  ) {
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
          // Icon Container
          Container(
            padding: const EdgeInsets.all(AppSpacing.sm + 2),
            decoration: BoxDecoration(
              color: activity.color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
            ),
            child: Icon(activity.icon, color: activity.color, size: 18),
          ),
          const Gap(AppSpacing.md),
          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      activity.name,
                      style: AppTypography.titleSmall.copyWith(
                        color: AppColors.textPrimaryDark,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Gap(AppSpacing.xs),
                    Container(
                      width: 3,
                      height: 3,
                      decoration: BoxDecoration(
                        color: AppColors.textMutedDark,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const Gap(AppSpacing.xs),
                    Text(
                      _formatTimeAgo(activity.time),
                      style: AppTypography.labelSmall.copyWith(
                        color: AppColors.textMutedDark,
                      ),
                    ),
                  ],
                ),
                const Gap(2),
                Text(
                  activity.action,
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textSecondaryDark,
                  ),
                ),
              ],
            ),
          ),
          // Amount
          Text(
            activity.value,
            style: AppTypography.titleSmall.copyWith(
              color: activity.color,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    ).animate(delay: (80 * index).ms).fadeIn().slideX(begin: 0.03);
  }

  String _formatTimeAgo(DateTime time) {
    final diff = DateTime.now().difference(time);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    return '${time.day}/${time.month}';
  }

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

  void _showUnifiedEntrySheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const AddEntrySheet(),
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

class _FeatureItem {
  final IconData icon;
  final String label;
  final Color color;
  final String route;

  _FeatureItem({
    required this.icon,
    required this.label,
    required this.color,
    required this.route,
  });
}
