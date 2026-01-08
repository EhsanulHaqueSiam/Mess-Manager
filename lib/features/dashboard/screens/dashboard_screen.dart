import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:getwidget/getwidget.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_layout_grid/flutter_layout_grid.dart';

import 'package:mess_manager/core/router/app_router.dart';
import 'package:mess_manager/core/theme/app_theme.dart';
import 'package:mess_manager/core/providers/members_provider.dart';
import 'package:mess_manager/core/providers/smart_suggestions_provider.dart';
import 'package:mess_manager/core/services/haptic_service.dart';
import 'package:mess_manager/core/widgets/gf_components.dart';
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

/// Dashboard Screen - Uses GetWidget + VelocityX + flutter_animate
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

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // Header
            SliverToBoxAdapter(
              child: VStack(crossAlignment: CrossAxisAlignment.start, [
                // Greeting Row
                HStack([
                  VStack(crossAlignment: CrossAxisAlignment.start, [
                    _getGreeting().text
                        .color(AppColors.textSecondaryDark)
                        .make()
                        .animate()
                        .fadeIn(duration: 300.ms)
                        .slideX(begin: -0.1),
                    4.heightBox,
                    'Area51 Mess'.text.xl2.bold
                        .color(AppColors.textPrimaryDark)
                        .make()
                        .animate()
                        .fadeIn(duration: 400.ms)
                        .slideX(begin: -0.1),
                  ]).expand(),
                  // Profile Row
                  HStack([
                    const TestModeSwitcher(),
                    8.widthBox,
                    if (daysSinceBazar != null) const ExpenseTimerWidget(),
                    8.widthBox,
                    _buildProfileAvatar(),
                  ]),
                ]),
                20.heightBox,

                // Balance Card
                _buildBalanceCard(context, currentBalance, summary),
                12.heightBox,

                // Smart Suggestions
                SmartSuggestionCard(
                  onAddMeal: () => _showAddMealSheet(context),
                  onAddBazar: () => _showAddBazarSheet(context),
                  onCheckList: () => context.go(AppRoutes.bazar),
                ),
                16.heightBox,

                // Notification Alerts
                NotificationAlertsArea(alerts: getSampleAlerts()),
                16.heightBox,

                // Quick Actions Header
                _sectionHeader(
                  LucideIcons.zap,
                  'Quick Actions',
                  AppColors.accentAlt,
                ),
                8.heightBox,
                _buildQuickActions(context),
                16.heightBox,

                // Feature Modules Header
                _sectionHeader(
                  LucideIcons.layoutGrid,
                  'Modules',
                  AppColors.secondary,
                ),
                8.heightBox,
                _buildFeatureGrid(context),
                16.heightBox,

                // Meal Rate Breakdown
                const MealRateBreakdownCard(),
                16.heightBox,

                // Recent Activity Header
                HStack([
                  _sectionHeader(
                    LucideIcons.activity,
                    'Recent Activity',
                    AppColors.primaryLight,
                  ).expand(),
                  TextButton(
                    onPressed: () {},
                    child: 'See all'.text.sm.color(AppColors.primary).make(),
                  ),
                ]),
              ]).p16(),
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

            const SliverToBoxAdapter(child: SizedBox(height: 100)),
          ],
        ),
      ),
      floatingActionButton: _buildSpeedDial(context, ref),
    );
  }

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

    // If user has no permissions, hide FAB entirely
    if (items.length <= 1) return const SizedBox.shrink();

    return SpeedDialFAB(items: items);
  }

  Widget _buildProfileAvatar() {
    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(colors: AppColors.gradientPrimary),
      ),
      child: GFAvatar(
        radius: 22,
        backgroundColor: AppColors.cardDark,
        child: const Icon(LucideIcons.user, color: AppColors.primary, size: 20),
      ),
    ).animate().scale(delay: 300.ms, duration: 400.ms);
  }

  Widget _sectionHeader(IconData icon, String title, Color color) {
    return HStack([
      Icon(icon, color: color, size: 18),
      8.widthBox,
      title.text.lg.bold.color(AppColors.textPrimaryDark).make(),
    ]);
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
      onTap: () {
        HapticService.lightTap();
        context.go(AppRoutes.balance);
      },
      child: GFCard(
        margin: EdgeInsets.zero,
        padding: const EdgeInsets.all(AppSpacing.lg),
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        gradient: LinearGradient(
          colors: [
            AppColors.primary,
            AppColors.primaryDark,
            AppColors.secondary,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        content: VStack([
          HStack([
            VStack(crossAlignment: CrossAxisAlignment.start, [
              HStack([
                Icon(
                  LucideIcons.wallet,
                  color: Colors.white.withValues(alpha: 0.8),
                  size: 16,
                ),
                4.widthBox,
                'Your Balance'.text.sm
                    .color(Colors.white.withValues(alpha: 0.8))
                    .make(),
              ]),
              8.heightBox,
              '${isPositive ? '+' : ''}৳${(balance?.balance ?? 0).toStringAsFixed(0)}'
                  .text
                  .xl4
                  .white
                  .extraBold
                  .make(),
            ]).expand(),
            // Status Badge
            GFBadge(
              text: isPositive ? 'Positive' : 'Owes',
              color: balanceColor.withValues(alpha: 0.2),
              textColor: balanceColor,
              shape: GFBadgeShape.pills,
              size: GFSize.SMALL,
            ),
          ]),
          16.heightBox,
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
          12.heightBox,
          HStack(alignment: MainAxisAlignment.spaceAround, [
            _statItem(
              LucideIcons.calculator,
              'Meal Rate',
              '৳${summary.mealRate.toStringAsFixed(0)}',
            ),
            _statItem(
              LucideIcons.utensils,
              'Your Meals',
              '${balance?.totalMeals.toStringAsFixed(0) ?? 0}',
            ),
            _statItem(LucideIcons.users, 'Members', '${summary.memberCount}'),
          ]),
        ]),
      ),
    ).animate().fadeIn(duration: 500.ms).scale(begin: const Offset(0.95, 0.95));
  }

  Widget _statItem(IconData icon, String label, String value) {
    return VStack([
      Icon(icon, color: Colors.white.withValues(alpha: 0.7), size: 18),
      4.heightBox,
      value.text.lg.white.bold.make(),
      label.text.xs.color(Colors.white.withValues(alpha: 0.7)).make(),
    ]);
  }

  Widget _buildQuickActions(BuildContext context) {
    return HStack([
      _actionCard(
        icon: LucideIcons.plus,
        label: 'Add Meal',
        color: AppColors.mealColor,
        onTap: () => _showAddMealSheet(context),
      ).expand(),
      8.widthBox,
      _actionCard(
        icon: LucideIcons.arrowLeftRight,
        label: 'Money',
        color: AppColors.accentWarm,
        onTap: () => context.go(AppRoutes.money),
      ).expand(),
      8.widthBox,
      _actionCard(
        icon: LucideIcons.partyPopper,
        label: 'Split',
        color: AppColors.secondary,
        onTap: () => _showPartySplitter(context),
      ).expand(),
    ]).animate().fadeIn(delay: 200.ms).slideY(begin: 0.1);
  }

  Widget _actionCard({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GFAppCard(
      color: color.withValues(alpha: 0.1),
      borderColor: color.withValues(alpha: 0.2),
      onTap: onTap,
      child: VStack([
        Container(
          padding: const EdgeInsets.all(AppSpacing.sm),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
          ),
          child: Icon(icon, color: color, size: 22),
        ),
        8.heightBox,
        label.text.sm.color(color).bold.center.make(),
      ]).py8(),
    );
  }

  Widget _buildFeatureGrid(BuildContext context) {
    final features = [
      _FeatureItem(
        LucideIcons.barChart3,
        'Analytics',
        AppColors.primaryLight,
        AppRoutes.analytics,
      ),
      _FeatureItem(
        LucideIcons.users,
        'Members',
        AppColors.accentAlt,
        AppRoutes.members,
      ),
      _FeatureItem(
        LucideIcons.palmtree,
        'Vacation',
        AppColors.moneyPositive,
        AppRoutes.vacation,
      ),
      _FeatureItem(
        LucideIcons.zap,
        'DESCO',
        AppColors.accentWarm,
        AppRoutes.desco,
      ),
      _FeatureItem(
        LucideIcons.moon,
        'Ramadan',
        AppColors.secondary,
        AppRoutes.ramadan,
      ),
      _FeatureItem(
        LucideIcons.receipt,
        'Settlement',
        AppColors.moneyNegative,
        AppRoutes.settlement,
      ),
      _FeatureItem(
        LucideIcons.clipboardList,
        'Duties',
        AppColors.info,
        AppRoutes.duties,
      ),
      _FeatureItem(
        LucideIcons.info,
        'Info',
        AppColors.textSecondaryDark,
        AppRoutes.info,
      ),
    ];

    // Bento layout using flutter_layout_grid
    return LayoutGrid(
      columnSizes: [1.fr, 1.fr, 1.fr, 1.fr],
      rowSizes: const [auto, auto],
      columnGap: AppSpacing.sm,
      rowGap: AppSpacing.sm,
      children: [
        // Analytics - 2 columns wide for emphasis
        _buildBentoCard(context, features[0], 0, colSpan: 2).withGridPlacement(
          columnStart: 0,
          columnSpan: 2,
          rowStart: 0,
          rowSpan: 1,
        ),
        _buildBentoCard(context, features[1], 1).withGridPlacement(
          columnStart: 2,
          columnSpan: 1,
          rowStart: 0,
          rowSpan: 1,
        ),
        _buildBentoCard(context, features[2], 2).withGridPlacement(
          columnStart: 3,
          columnSpan: 1,
          rowStart: 0,
          rowSpan: 1,
        ),
        _buildBentoCard(context, features[3], 3).withGridPlacement(
          columnStart: 0,
          columnSpan: 1,
          rowStart: 1,
          rowSpan: 1,
        ),
        _buildBentoCard(context, features[4], 4).withGridPlacement(
          columnStart: 1,
          columnSpan: 1,
          rowStart: 1,
          rowSpan: 1,
        ),
        // Settlement - 2 columns wide
        _buildBentoCard(context, features[5], 5, colSpan: 2).withGridPlacement(
          columnStart: 2,
          columnSpan: 2,
          rowStart: 1,
          rowSpan: 1,
        ),
      ],
    ).animate().fadeIn(delay: 250.ms).slideY(begin: 0.1);
  }

  Widget _buildBentoCard(
    BuildContext context,
    _FeatureItem feature,
    int index, {
    int colSpan = 1,
  }) {
    final isWide = colSpan > 1;
    return GFAppCard(
          color: feature.color.withValues(alpha: 0.08),
          borderColor: feature.color.withValues(alpha: 0.2),
          padding: const EdgeInsets.all(AppSpacing.md),
          onTap: () {
            HapticService.lightTap();
            context.go(feature.route);
          },
          child: isWide
              ? HStack([
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.sm),
                    decoration: BoxDecoration(
                      color: feature.color.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                    ),
                    child: Icon(feature.icon, color: feature.color, size: 24),
                  ),
                  12.widthBox,
                  VStack(crossAlignment: CrossAxisAlignment.start, [
                    feature.label.text.lg.color(feature.color).bold.make(),
                    'Tap to view'.text.xs.color(AppColors.textMutedDark).make(),
                  ]).expand(),
                  Icon(
                    LucideIcons.chevronRight,
                    color: feature.color,
                    size: 16,
                  ),
                ])
              : VStack(alignment: MainAxisAlignment.center, [
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.sm),
                    decoration: BoxDecoration(
                      color: feature.color.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                    ),
                    child: Icon(feature.icon, color: feature.color, size: 20),
                  ),
                  6.heightBox,
                  feature.label.text.sm.color(feature.color).bold.center.make(),
                ]),
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

    // Guard: Return empty list if no members to avoid .first crash
    if (members.isEmpty) return activities;

    // Add recent meals
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

    // Add recent bazar
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

    activities.sort((a, b) => b.time.compareTo(a.time));
    return activities;
  }

  Widget _buildActivityItem(
    BuildContext context,
    _Activity activity,
    int index,
  ) {
    return GFAppCard(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: HStack([
        // Icon
        GFAvatar(
          size: 36,
          backgroundColor: activity.color.withValues(alpha: 0.1),
          child: Icon(activity.icon, color: activity.color, size: 18),
        ),
        12.widthBox,
        // Content
        VStack(crossAlignment: CrossAxisAlignment.start, [
          HStack([
            activity.name.text.bold.color(AppColors.textPrimaryDark).make(),
            4.widthBox,
            Container(
              width: 3,
              height: 3,
              decoration: const BoxDecoration(
                color: AppColors.textMutedDark,
                shape: BoxShape.circle,
              ),
            ),
            4.widthBox,
            _formatTimeAgo(
              activity.time,
            ).text.xs.color(AppColors.textMutedDark).make(),
          ]),
          2.heightBox,
          activity.action.text.sm.color(AppColors.textSecondaryDark).make(),
        ]).expand(),
        // Value
        activity.value.text.bold.color(activity.color).make(),
      ]),
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

  _FeatureItem(this.icon, this.label, this.color, this.route);
}
