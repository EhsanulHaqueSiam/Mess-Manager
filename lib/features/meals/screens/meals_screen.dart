import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import 'package:mess_manager/core/theme/app_theme.dart';
import 'package:mess_manager/core/models/meal.dart';
import 'package:mess_manager/core/router/app_router.dart';
import 'package:mess_manager/core/providers/members_provider.dart';
import 'package:mess_manager/core/services/haptic_service.dart';
import 'package:mess_manager/core/widgets/app_components.dart';
import 'package:mess_manager/core/widgets/animated_widgets.dart';
import 'package:mess_manager/features/meals/providers/meals_provider.dart';
import 'package:mess_manager/features/meals/widgets/add_meal_sheet.dart';
import 'package:mess_manager/features/meals/widgets/bulk_meal_sheet.dart';
import 'package:mess_manager/features/meals/widgets/meal_schedule_tab.dart';
import 'package:mess_manager/features/balance/providers/balance_provider.dart';
import 'package:mess_manager/core/providers/role_provider.dart';

/// Meals Screen — Cosmic Bioluminescence Design
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
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) HapticService.tabChanged();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // ── Subtle aurora background ──
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFF0D1520),
                    Color(0xFF0A0E1A),
                  ],
                ),
              ),
            ),
          ),
          // Meal-themed accent orb
          Positioned(
            top: -80,
            right: -60,
            child: Container(
              width: 220,
              height: 220,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppColors.mealColor.withValues(alpha: 0.12),
                    AppColors.mealColor.withValues(alpha: 0.03),
                    Colors.transparent,
                  ],
                ),
              ),
            )
                .animate(onPlay: (c) => c.repeat(reverse: true))
                .scaleXY(begin: 0.9, end: 1.1, duration: 5.seconds),
          ),

          // ── Content ──
          SafeArea(
            child: NestedScrollView(
              headerSliverBuilder: (context, innerBoxScrolled) => [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
                    child: _buildHeader(context),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                    child: _buildTabBar(),
                  ),
                ),
              ],
              body: TabBarView(
                controller: _tabController,
                children: [
                  _EntriesTab(ref: ref),
                  const MealScheduleTab(),
                ],
              ),
            ),
          ),
        ],
      ),
      // FAB now in MainShell (global speed dial)
    );
  }

  // ────────────────────────────────────────────────────────────────
  // HEADER
  // ────────────────────────────────────────────────────────────────

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        // Gradient icon halo
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: LinearGradient(
              colors: [
                AppColors.mealColor.withValues(alpha: 0.25),
                AppColors.mealColor.withValues(alpha: 0.08),
              ],
            ),
          ),
          child: const Icon(LucideIcons.utensils, color: AppColors.mealColor, size: 20),
        ),
        const Gap(12),
        Text(
          'Meals',
          style: AppTypography.headlineMedium.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
        const Spacer(),
        // Vacation button
        _glassIconButton(
          icon: LucideIcons.calendarX,
          onTap: () {
            HapticService.lightTap();
            context.push(AppRoutes.vacation);
          },
        ),
        const Gap(8),
        // Bulk button
        _glassActionChip(
          icon: LucideIcons.calendarDays,
          label: 'Bulk',
          color: AppColors.mealColor,
          onTap: () {
            HapticService.buttonPress();
            _showBulkMealSheet(context);
          },
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

  Widget _glassActionChip({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: color.withValues(alpha: 0.12),
          border: Border.all(color: color.withValues(alpha: 0.2)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14, color: color),
            const Gap(6),
            Text(
              label,
              style: AppTypography.labelSmall.copyWith(
                color: color,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ────────────────────────────────────────────────────────────────
  // TAB BAR
  // ────────────────────────────────────────────────────────────────

  Widget _buildTabBar() {
    return Container(
      height: 44,
      decoration: AppSpacing.accentCard(
        accent: AppColors.mealColor,
        radius: 12,
      ),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          gradient: const LinearGradient(colors: AppColors.gradientMeal),
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        dividerHeight: 0,
        labelPadding: EdgeInsets.zero,
        tabs: [
          Tab(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(LucideIcons.list, size: 16),
                const Gap(6),
                Text('Entries', style: AppTypography.labelMedium),
              ],
            ),
          ),
          Tab(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(LucideIcons.calendarDays, size: 16),
                const Gap(6),
                Text('Schedule', style: AppTypography.labelMedium),
              ],
            ),
          ),
        ],
        labelColor: Colors.white,
        unselectedLabelColor: Colors.white.withValues(alpha: 0.4),
      ),
    ).animate().fadeIn(delay: 100.ms);
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

// ══════════════════════════════════════════════════════════════════
// ENTRIES TAB
// ══════════════════════════════════════════════════════════════════

class _EntriesTab extends StatefulWidget {
  final WidgetRef ref;

  const _EntriesTab({required this.ref});

  @override
  State<_EntriesTab> createState() => _EntriesTabState();
}

class _EntriesTabState extends State<_EntriesTab> {
  String _searchQuery = '';
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  WidgetRef get ref => widget.ref;

  @override
  Widget build(BuildContext context) {
    final allMeals = ref.watch(mealsProvider);
    final members = ref.watch(membersProvider);
    final mealsByMember = ref.watch(mealsByMemberProvider);
    final mealRate = ref.watch(mealRateProvider);

    // Filter meals by search query (member name)
    final meals = _searchQuery.isEmpty
        ? allMeals
        : allMeals.where((meal) {
            if (members.isEmpty) return false;
            final member = members.cast<dynamic>().firstWhere(
              (m) => m.id == meal.memberId,
              orElse: () => null,
            );
            if (member == null) return false;
            return member.name.toString().toLowerCase().contains(
              _searchQuery.toLowerCase(),
            );
          }).toList();

    if (allMeals.isEmpty) {
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
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Search Bar ──
                _buildSearchBar(),
                const Gap(16),

                // ── Stat Cards ──
                Row(
                  children: [
                    Expanded(
                      child: _buildGlassStatCard(
                        icon: LucideIcons.utensils,
                        label: 'Total Meals',
                        value: allMeals
                            .fold(0.0, (sum, m) => sum + m.count)
                            .toStringAsFixed(1),
                        color: AppColors.mealColor,
                        delay: 150,
                      ),
                    ),
                    const Gap(10),
                    Expanded(
                      child: _buildGlassStatCard(
                        icon: LucideIcons.calculator,
                        label: 'Meal Rate',
                        value: '৳${mealRate.toStringAsFixed(0)}',
                        color: AppColors.primary,
                        delay: 200,
                      ),
                    ),
                  ],
                ),
                const Gap(20),

                // ── Member Summary ──
                _sectionLabel('This month'),
                const Gap(10),
                ...members.asMap().entries.map(
                  (entry) => _buildMemberRow(
                    context,
                    entry.value,
                    mealsByMember[entry.value.id] ?? 0,
                    mealRate,
                    entry.key,
                  ),
                ),
                const Gap(20),

                _sectionLabel('Recent entries'),
              ],
            ),
          ),
        ),

        // ── Meals by Date ──
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              final date = sortedDates[index];
              final dateMeals = mealsByDate[date]!;
              return _buildDateSection(context, date, dateMeals, members);
            }, childCount: sortedDates.length),
          ),
        ),

        const SliverToBoxAdapter(child: Gap(100)),
      ],
    );
  }

  // ────────────────────────────────────────────────────────────────
  // SEARCH BAR
  // ────────────────────────────────────────────────────────────────

  Widget _buildSearchBar() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: TextField(
          controller: _searchController,
          style: AppTypography.bodyMedium.copyWith(color: Colors.white),
          decoration: InputDecoration(
            hintText: 'Search by member name...',
            hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.25)),
            prefixIcon: Icon(
              LucideIcons.search,
              size: 18,
              color: Colors.white.withValues(alpha: 0.3),
            ),
            suffixIcon: _searchQuery.isNotEmpty
                ? IconButton(
                    icon: Icon(
                      LucideIcons.x,
                      size: 16,
                      color: Colors.white.withValues(alpha: 0.4),
                    ),
                    onPressed: () {
                      _searchController.clear();
                      setState(() => _searchQuery = '');
                    },
                  )
                : null,
            filled: true,
            fillColor: Colors.white.withValues(alpha: 0.05),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.08)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.06)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(
                color: AppColors.mealColor.withValues(alpha: 0.5),
              ),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
          ),
          onChanged: (value) => setState(() => _searchQuery = value),
        ),
      ),
    ).animate().fadeIn(delay: 100.ms);
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
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  gradient: LinearGradient(
                    colors: [
                      color.withValues(alpha: 0.35),
                      color.withValues(alpha: 0.15),
                    ],
                  ),
                ),
                child: Icon(icon, color: color, size: 17),
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
            color: AppColors.mealColor,
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
  // MEMBER ROW
  // ────────────────────────────────────────────────────────────────

  Widget _buildMemberRow(
    BuildContext context,
    dynamic member,
    double mealCount,
    double mealRate,
    int index,
  ) {
    final cost = mealCount * mealRate;

    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.white.withValues(alpha: 0.04),
              border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
            ),
            child: Row(
              children: [
                AppMemberAvatar(
                  name: member.name,
                  size: 34,
                  backgroundColor: AppColors.mealColor.withValues(alpha: 0.2),
                ),
                const Gap(10),
                Expanded(
                  child: Text(
                    member.name.toString(),
                    style: AppTypography.bodyMedium.copyWith(
                      color: Colors.white.withValues(alpha: 0.85),
                    ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '${mealCount.toStringAsFixed(1)} meals',
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.mealColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '৳${cost.toStringAsFixed(0)}',
                      style: AppTypography.labelSmall.copyWith(
                        color: Colors.white.withValues(alpha: 0.35),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    ).animate().fadeIn(delay: Duration(milliseconds: 250 + index * 40)).slideX(begin: 0.03);
  }

  // ────────────────────────────────────────────────────────────────
  // DATE SECTION
  // ────────────────────────────────────────────────────────────────

  Widget _buildDateSection(
    BuildContext context,
    DateTime date,
    List<Meal> meals,
    List members,
  ) {
    final dateLabel = _formatDate(date);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            children: [
              Container(
                width: 6,
                height: 6,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.mealColor.withValues(alpha: 0.5),
                ),
              ),
              const Gap(8),
              Text(
                dateLabel,
                style: AppTypography.labelMedium.copyWith(
                  color: Colors.white.withValues(alpha: 0.4),
                  letterSpacing: 0.5,
                ),
              ),
              const Gap(8),
              Expanded(
                child: Container(
                  height: 1,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.white.withValues(alpha: 0.08),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        ...meals.map((meal) {
          if (members.isEmpty) return const SizedBox.shrink();
          final member = members.cast<dynamic>().firstWhere(
            (m) => m.id == meal.memberId,
            orElse: () => null,
          );
          if (member == null) return const SizedBox.shrink();
          return _buildMealRow(context, meal, member);
        }),
        const Gap(4),
      ],
    );
  }

  // ────────────────────────────────────────────────────────────────
  // MEAL ROW
  // ────────────────────────────────────────────────────────────────

  Widget _buildMealRow(BuildContext context, Meal meal, dynamic member) {
    return Slidable(
      key: Key(meal.id),
      endActionPane: ActionPane(
        motion: const DrawerMotion(),
        children: [
          if (_canEditMeal(meal))
            SlidableAction(
              onPressed: (_) {
                HapticService.buttonPress();
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (ctx) => AddMealSheet(existingMeal: meal),
                );
              },
              backgroundColor: AppColors.info,
              foregroundColor: Colors.white,
              icon: LucideIcons.edit2,
              label: 'Edit',
              borderRadius: BorderRadius.circular(10),
            ),
          SlidableAction(
            onPressed: (_) async {
              final confirm =
                  await showDialog<bool>(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      backgroundColor: context.surfaceColor,
                      title: const Text('Delete Meal?'),
                      content: Text(
                        'Remove ${member.name}\'s ${meal.type.name} meal?',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(ctx, false),
                          child: const Text('Cancel'),
                        ),
                        ElevatedButton(
                          onPressed: () => Navigator.pop(ctx, true),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.error,
                          ),
                          child: const Text('Delete'),
                        ),
                      ],
                    ),
                  ) ??
                  false;
              if (confirm) {
                HapticService.itemDeleted();
                final deletedMeal = meal;
                ref.read(mealsProvider.notifier).removeMeal(meal.id);
                HapticService.undoAvailable();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('${member.name}\'s meal deleted'),
                    action: SnackBarAction(
                      label: 'Undo',
                      textColor: AppColors.accentWarm,
                      onPressed: () {
                        ref.read(mealsProvider.notifier).addMeal(deletedMeal);
                      },
                    ),
                    backgroundColor: context.cardColor,
                    duration: const Duration(seconds: 4),
                  ),
                );
              }
            },
            backgroundColor: AppColors.error,
            foregroundColor: Colors.white,
            icon: LucideIcons.trash2,
            label: 'Delete',
            borderRadius: BorderRadius.circular(10),
          ),
        ],
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 3),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.03),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.white.withValues(alpha: 0.04)),
        ),
        child: Row(
          children: [
            // Meal type icon with gradient halo
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                gradient: RadialGradient(
                  colors: [
                    _getMealTypeColor(meal.type).withValues(alpha: 0.2),
                    _getMealTypeColor(meal.type).withValues(alpha: 0.05),
                  ],
                ),
              ),
              child: Icon(
                _getMealIcon(meal.type),
                color: _getMealTypeColor(meal.type),
                size: 14,
              ),
            ),
            const Gap(10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    member.name.toString(),
                    style: AppTypography.bodySmall.copyWith(
                      color: Colors.white.withValues(alpha: 0.8),
                    ),
                  ),
                  Text(
                    meal.type.name,
                    style: AppTypography.labelSmall.copyWith(
                      color: _getMealTypeColor(meal.type).withValues(alpha: 0.6),
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: AppColors.mealColor.withValues(alpha: 0.12),
              ),
              child: Text(
                '${meal.count}',
                style: AppTypography.labelMedium.copyWith(
                  color: AppColors.mealColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getMealTypeColor(MealType type) {
    switch (type) {
      case MealType.breakfast:
        return AppColors.accentWarm;
      case MealType.lunch:
        return AppColors.mealColor;
      case MealType.dinner:
        return AppColors.accent;
    }
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

  /// Check if current user can edit this meal (admin or meal owner)
  bool _canEditMeal(Meal meal) {
    final isAdmin = ref.watch(isAdminProvider);
    final currentMemberId = ref.watch(currentMemberIdProvider);
    return isAdmin || meal.memberId == currentMemberId;
  }
}
