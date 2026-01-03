import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:gap/gap.dart';
import 'package:mess_manager/core/theme/app_theme.dart';
import 'package:mess_manager/core/models/meal.dart';
import 'package:mess_manager/core/providers/members_provider.dart';
import 'package:mess_manager/features/meals/providers/meals_provider.dart';
import 'package:mess_manager/features/meals/widgets/add_meal_sheet.dart';
import 'package:mess_manager/features/meals/widgets/bulk_meal_sheet.dart';
import 'package:mess_manager/features/meals/widgets/meal_schedule_tab.dart';
import 'package:mess_manager/features/balance/providers/balance_provider.dart';

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
        title: Row(
          children: [
            const Icon(
              LucideIcons.utensils,
              color: AppColors.mealColor,
              size: 22,
            ),
            const Gap(AppSpacing.sm),
            const Text('Meals'),
          ],
        ),
        actions: [
          TextButton.icon(
            onPressed: () => _showBulkMealSheet(context),
            icon: const Icon(LucideIcons.calendarDays, size: 18),
            label: const Text('Bulk'),
            style: TextButton.styleFrom(foregroundColor: AppColors.mealColor),
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
          // Entries Tab
          _buildEntriesTab(),
          // Schedule Tab
          const MealScheduleTab(),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddMealSheet(context),
        icon: const Icon(LucideIcons.plus, size: 20),
        label: const Text('Add Meal'),
        backgroundColor: AppColors.mealColor,
      ),
    );
  }

  Widget _buildEntriesTab() {
    final meals = ref.watch(mealsProvider);
    final members = ref.watch(membersProvider);
    final mealsByMember = ref.watch(mealsByMemberProvider);
    final mealRate = ref.watch(mealRateProvider);

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
        // Summary Cards
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Stats Row
                Row(
                  children: [
                    Expanded(
                      child: _buildStatCard(
                        icon: LucideIcons.utensils,
                        label: 'Total Meals',
                        value: meals
                            .fold(0.0, (sum, m) => sum + m.count)
                            .toStringAsFixed(1),
                        color: AppColors.mealColor,
                      ),
                    ),
                    const Gap(AppSpacing.sm),
                    Expanded(
                      child: _buildStatCard(
                        icon: LucideIcons.calculator,
                        label: 'Meal Rate',
                        value: '৳${mealRate.toStringAsFixed(0)}',
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ).animate().fadeIn().slideY(begin: 0.1),
                const Gap(AppSpacing.lg),

                // Member Meal Summary
                Text(
                  'This Month',
                  style: AppTypography.headlineSmall.copyWith(
                    color: AppColors.textPrimaryDark,
                  ),
                ),
                const Gap(AppSpacing.sm),
                ...members.map((member) {
                  final mealCount = mealsByMember[member.id] ?? 0;
                  return _buildMemberMealRow(
                    name: member.name,
                    meals: mealCount,
                    cost: mealCount * mealRate,
                  );
                }),
                const Gap(AppSpacing.lg),

                // Recent Activity
                Text(
                  'Recent Entries',
                  style: AppTypography.headlineSmall.copyWith(
                    color: AppColors.textPrimaryDark,
                  ),
                ),
              ],
            ),
          ),
        ),

        // Meals List by Date
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

        const SliverToBoxAdapter(child: Gap(AppSpacing.xxl * 2)),
      ],
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

  Widget _buildMemberMealRow({
    required String name,
    required double meals,
    required double cost,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.cardDark,
        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
        border: Border.all(color: AppColors.borderDark.withValues(alpha: 0.5)),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 16,
            backgroundColor: AppColors.mealColor.withValues(alpha: 0.2),
            child: Text(
              name[0],
              style: AppTypography.labelMedium.copyWith(
                color: AppColors.mealColor,
              ),
            ),
          ),
          const Gap(AppSpacing.sm),
          Expanded(
            child: Text(
              name,
              style: AppTypography.titleSmall.copyWith(
                color: AppColors.textPrimaryDark,
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${meals.toStringAsFixed(1)} meals',
                style: AppTypography.labelMedium.copyWith(
                  color: AppColors.mealColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                '৳${cost.toStringAsFixed(0)}',
                style: AppTypography.labelSmall.copyWith(
                  color: AppColors.textSecondaryDark,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDateSection(DateTime date, List<Meal> meals, List members) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final dateOnly = DateTime(date.year, date.month, date.day);

    String dateLabel;
    if (dateOnly == today) {
      dateLabel = 'Today';
    } else if (dateOnly == yesterday) {
      dateLabel = 'Yesterday';
    } else {
      dateLabel = '${date.day}/${date.month}';
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
          child: Text(
            dateLabel,
            style: AppTypography.labelMedium.copyWith(
              color: AppColors.textSecondaryDark,
            ),
          ),
        ),
        ...meals.map((meal) {
          final member = members.firstWhere(
            (m) => m.id == meal.memberId,
            orElse: () => members.first,
          );
          return Container(
            margin: const EdgeInsets.only(bottom: AppSpacing.xs),
            padding: const EdgeInsets.all(AppSpacing.sm),
            decoration: BoxDecoration(
              color: AppColors.cardDark.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(AppSpacing.xs),
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
                const Gap(AppSpacing.sm),
                Expanded(
                  child: Text(
                    member.name,
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.textPrimaryDark,
                    ),
                  ),
                ),
                Text(
                  '${meal.count}',
                  style: AppTypography.labelMedium.copyWith(
                    color: AppColors.mealColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          );
        }),
        const Gap(AppSpacing.sm),
      ],
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

  void _showAddMealSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const AddMealSheet(),
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
