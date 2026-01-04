import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:getwidget/getwidget.dart';

import 'package:mess_manager/core/theme/app_theme.dart';
import 'package:mess_manager/core/models/meal.dart';
import 'package:mess_manager/core/router/app_router.dart';
import 'package:mess_manager/core/providers/members_provider.dart';
import 'package:mess_manager/core/services/haptic_service.dart';
import 'package:mess_manager/core/widgets/gf_components.dart';
import 'package:mess_manager/core/widgets/animated_widgets.dart';
import 'package:mess_manager/features/meals/providers/meals_provider.dart';
import 'package:mess_manager/features/meals/widgets/add_meal_sheet.dart';
import 'package:mess_manager/features/meals/widgets/bulk_meal_sheet.dart';
import 'package:mess_manager/features/meals/widgets/meal_schedule_tab.dart';
import 'package:mess_manager/features/balance/providers/balance_provider.dart';

/// Meals Screen - Uses GetWidget + VelocityX + flutter_animate
class MealsScreen extends ConsumerStatefulWidget {
  const MealsScreen({super.key});

  @override
  ConsumerState<MealsScreen> createState() => _MealsScreenState();
}

class _MealsScreenState extends ConsumerState<MealsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: [
          const Icon(
            LucideIcons.utensils,
            color: AppColors.mealColor,
            size: 22,
          ),
          const Gap(AppSpacing.sm),
          'Meals'.text.make(),
        ].hStack(),
        actions: [
          IconButton(
            onPressed: () {
              HapticService.lightTap();
              context.push(AppRoutes.vacation);
            },
            icon: const Icon(LucideIcons.calendarX, size: 20),
            tooltip: 'Cancel Meals',
          ),
          GFButton(
            onPressed: () {
              HapticService.buttonPress();
              _showBulkMealSheet(context);
            },
            icon: const Icon(
              LucideIcons.calendarDays,
              size: 18,
              color: AppColors.mealColor,
            ),
            text: 'Bulk',
            type: GFButtonType.transparent,
            textColor: AppColors.mealColor,
            size: GFSize.SMALL,
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(icon: Icon(LucideIcons.list, size: 18), text: 'Entries'),
            Tab(
              icon: Icon(LucideIcons.calendarDays, size: 18),
              text: 'Schedule',
            ),
          ],
          labelColor: AppColors.mealColor,
          unselectedLabelColor: AppColors.textSecondaryDark,
          indicatorColor: AppColors.mealColor,
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _EntriesTab(ref: ref),
          const MealScheduleTab(),
        ],
      ),
      floatingActionButton: _buildMealFAB(context),
    );
  }

  Widget _buildMealFAB(BuildContext context) {
    return FloatingActionButton.extended(
          onPressed: () {
            HapticService.buttonPress();
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              builder: (context) => const AddMealSheet(),
            );
          },
          icon: const Icon(LucideIcons.plus, size: 20),
          label: const Text('Add Meal'),
          backgroundColor: AppColors.mealColor,
        )
        .animate(onPlay: (c) => c.repeat())
        .shimmer(
          duration: 2.seconds,
          color: Colors.white.withValues(alpha: 0.15),
        );
  }

  void _showBulkMealSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const BulkMealSheet(),
    );
  }
}

/// Entries Tab - Uses GetWidget + VelocityX
class _EntriesTab extends StatelessWidget {
  final WidgetRef ref;

  const _EntriesTab({required this.ref});

  @override
  Widget build(BuildContext context) {
    final meals = ref.watch(mealsProvider);
    final members = ref.watch(membersProvider);
    final mealsByMember = ref.watch(mealsByMemberProvider);
    final mealRate = ref.watch(mealRateProvider);

    if (meals.isEmpty) {
      return EmptyStateWidget.noMeals(
        action: ShimmerCTAButton(
          text: 'Add First Meal',
          icon: LucideIcons.plus,
          onPressed: () {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              builder: (context) => const AddMealSheet(),
            );
          },
        ),
      );
    }

    // Group meals by date
    final mealsByDate = <DateTime, List<Meal>>{};
    for (final meal in meals) {
      final dateKey = DateTime(meal.date.year, meal.date.month, meal.date.day);
      mealsByDate[dateKey] = [...(mealsByDate[dateKey] ?? []), meal];
    }
    final sortedDates = mealsByDate.keys.toList()
      ..sort((a, b) => b.compareTo(a));

    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: VStack([
            // Stats Row
            HStack([
              _buildStatCard(
                icon: LucideIcons.utensils,
                label: 'Total Meals',
                value: meals
                    .fold(0.0, (sum, m) => sum + m.count)
                    .toStringAsFixed(1),
                color: AppColors.mealColor,
              ).expand(),
              8.widthBox,
              _buildStatCard(
                icon: LucideIcons.calculator,
                label: 'Meal Rate',
                value: '৳${mealRate.toStringAsFixed(0)}',
                color: AppColors.primary,
              ).expand(),
            ]).animate().fadeIn().slideY(begin: 0.1),
            16.heightBox,

            // Member Summary
            'This Month'.text.xl.bold.color(AppColors.textPrimaryDark).make(),
            8.heightBox,
            ...members.map(
              (member) => _buildMemberRow(
                member,
                mealsByMember[member.id] ?? 0,
                mealRate,
              ),
            ),
            16.heightBox,

            'Recent Entries'.text.xl.bold
                .color(AppColors.textPrimaryDark)
                .make(),
          ]).p16(),
        ),

        // Meals by Date
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              final date = sortedDates[index];
              final dateMeals = mealsByDate[date]!;
              return _buildDateSection(date, dateMeals, members);
            }, childCount: sortedDates.length),
          ),
        ),

        const SliverToBoxAdapter(child: Gap(100)),
      ],
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

  Widget _buildMemberRow(dynamic member, double mealCount, double mealRate) {
    final cost = mealCount * mealRate;

    return GFAppCard(
      child: HStack([
        GFMemberAvatar(
          name: member.name,
          size: 32,
          backgroundColor: AppColors.mealColor.withValues(alpha: 0.2),
        ),
        8.widthBox,
        member.name
            .toString()
            .text
            .color(AppColors.textPrimaryDark)
            .make()
            .expand(),
        VStack(crossAlignment: CrossAxisAlignment.end, [
          '${mealCount.toStringAsFixed(1)} meals'.text.sm
              .color(AppColors.mealColor)
              .bold
              .make(),
          '৳${cost.toStringAsFixed(0)}'.text.xs
              .color(AppColors.textSecondaryDark)
              .make(),
        ]),
      ]),
    ).pOnly(bottom: AppSpacing.sm);
  }

  Widget _buildDateSection(DateTime date, List<Meal> meals, List members) {
    final dateLabel = _formatDate(date);

    return VStack(crossAlignment: CrossAxisAlignment.start, [
      dateLabel.text.sm.color(AppColors.textSecondaryDark).make().py8(),
      ...meals.map((meal) {
        final member = members.firstWhere(
          (m) => m.id == meal.memberId,
          orElse: () => members.first,
        );
        return _buildMealRow(meal, member);
      }),
      8.heightBox,
    ]);
  }

  Widget _buildMealRow(Meal meal, dynamic member) {
    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: AppColors.cardDark.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
      ),
      child: HStack([
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: AppColors.mealColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Icon(
            _getMealIcon(meal.type),
            color: AppColors.mealColor,
            size: 14,
          ),
        ),
        8.widthBox,
        member.name
            .toString()
            .text
            .sm
            .color(AppColors.textPrimaryDark)
            .make()
            .expand(),
        '${meal.count}'.text.sm.color(AppColors.mealColor).bold.make(),
      ]),
    );
  }

  IconData _getMealIcon(MealType type) {
    switch (type) {
      case MealType.breakfast:
        return LucideIcons.sunrise;
      case MealType.lunch:
        return LucideIcons.sun;
      case MealType.dinner:
        return LucideIcons.moon;
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final dateOnly = DateTime(date.year, date.month, date.day);

    if (dateOnly == today) return 'Today';
    if (dateOnly == yesterday) return 'Yesterday';
    return '${date.day}/${date.month}';
  }
}
