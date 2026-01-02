import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:gap/gap.dart';
import 'package:mess_manager/core/theme/app_theme.dart';
import 'package:mess_manager/core/models/ramadan.dart';
import 'package:mess_manager/core/providers/members_provider.dart';
import 'package:mess_manager/features/ramadan/providers/ramadan_provider.dart';

class RamadanScreen extends ConsumerStatefulWidget {
  const RamadanScreen({super.key});

  @override
  ConsumerState<RamadanScreen> createState() => _RamadanScreenState();
}

class _RamadanScreenState extends ConsumerState<RamadanScreen> {
  @override
  Widget build(BuildContext context) {
    final season = ref.watch(activeRamadanSeasonProvider);
    final balances = ref.watch(ramadanBalancesProvider);
    final mealRate = ref.watch(ramadanMealRateProvider);
    final members = ref.watch(membersProvider);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Icon(LucideIcons.moon, color: AppColors.primary, size: 22),
            const Gap(AppSpacing.sm),
            const Text('Ramadan'),
          ],
        ),
        actions: [
          if (season == null)
            TextButton.icon(
              onPressed: () => _showCreateSeasonSheet(context),
              icon: const Icon(LucideIcons.plus, size: 18),
              label: const Text('New Season'),
            ),
        ],
      ),
      body: season == null
          ? _buildNoSeasonState()
          : SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Season Info Card
                  _buildSeasonCard(season, mealRate),
                  const Gap(AppSpacing.lg),

                  // Quick Actions
                  _buildQuickActions(season),
                  const Gap(AppSpacing.lg),

                  // Today's Meals
                  _buildTodayMeals(season),
                  const Gap(AppSpacing.lg),

                  // Balances
                  Text(
                    'Balances',
                    style: AppTypography.headlineSmall.copyWith(
                      color: AppColors.textPrimaryDark,
                    ),
                  ),
                  const Gap(AppSpacing.sm),
                  ...balances.map((b) => _buildBalanceRow(b, members)),

                  const Gap(AppSpacing.lg),

                  // Credit/Debt Section
                  _buildCreditDebtSection(members),
                ],
              ),
            ),
      floatingActionButton: season != null
          ? FloatingActionButton.extended(
              onPressed: () => _showAddMealSheet(context, season),
              icon: const Icon(LucideIcons.utensils),
              label: const Text('Add Meal'),
              backgroundColor: AppColors.primary,
            )
          : null,
    );
  }

  Widget _buildCreditDebtSection(List members) {
    final creditDebts = ref.watch(ramadanCreditDebtProvider);
    final isSettled = ref.watch(isRamadanSettledProvider);
    final season =
        ref.watch(activeRamadanSeasonProvider) ??
        ref.watch(ramadanSeasonNeedingSettlementProvider);

    if (creditDebts.isEmpty && isSettled) {
      return Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: AppColors.success.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
          border: Border.all(color: AppColors.success.withValues(alpha: 0.3)),
        ),
        child: Row(
          children: [
            Icon(LucideIcons.checkCircle, color: AppColors.success, size: 20),
            const Gap(AppSpacing.sm),
            Text(
              'All balances settled!',
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.success,
              ),
            ),
            const Spacer(),
            if (season != null && !season.isSettled)
              TextButton(
                onPressed: () => _markSettled(season.id),
                child: const Text('Close Season'),
              ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Who Owes Whom',
          style: AppTypography.headlineSmall.copyWith(
            color: AppColors.textPrimaryDark,
          ),
        ),
        const Gap(AppSpacing.sm),
        ...creditDebts.map((cd) => _buildCreditDebtRow(cd, members)),
      ],
    );
  }

  Widget _buildCreditDebtRow(RamadanCreditDebt cd, List members) {
    final from = members.firstWhere(
      (m) => m.id == cd.fromMemberId,
      orElse: () => null,
    );
    final to = members.firstWhere(
      (m) => m.id == cd.toMemberId,
      orElse: () => null,
    );
    if (from == null || to == null) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.cardDark,
        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 16,
            backgroundColor: AppColors.error.withValues(alpha: 0.2),
            child: Text(
              from.name[0],
              style: TextStyle(color: AppColors.error, fontSize: 12),
            ),
          ),
          const Gap(AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${from.name} → ${to.name}',
                  style: AppTypography.titleSmall.copyWith(
                    color: AppColors.textPrimaryDark,
                  ),
                ),
                Text(
                  '৳${cd.amount.toStringAsFixed(0)}',
                  style: AppTypography.labelMedium.copyWith(
                    color: AppColors.warning,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(LucideIcons.checkCircle, color: AppColors.success),
            onPressed: () {
              // TODO: Mark as paid
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Payment recording coming soon')),
              );
            },
          ),
        ],
      ),
    );
  }

  void _markSettled(String seasonId) {
    ref.read(ramadanSeasonsProvider.notifier).markSeasonSettled(seasonId);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Ramadan season closed ✓'),
        backgroundColor: AppColors.success,
      ),
    );
  }

  Widget _buildNoSeasonState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(LucideIcons.moon, size: 64, color: AppColors.textMutedDark),
          const Gap(AppSpacing.lg),
          Text(
            'No Active Ramadan Season',
            style: AppTypography.titleLarge.copyWith(
              color: AppColors.textPrimaryDark,
            ),
          ),
          const Gap(AppSpacing.sm),
          Text(
            'Create a new season to start tracking',
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.textSecondaryDark,
            ),
          ),
          const Gap(AppSpacing.lg),
          ElevatedButton.icon(
            onPressed: () => _showCreateSeasonSheet(context),
            icon: const Icon(LucideIcons.plus, size: 18),
            label: const Text('Create Season'),
          ),
        ],
      ),
    );
  }

  Widget _buildSeasonCard(RamadanSeason season, double mealRate) {
    final daysLeft = season.endDate.difference(DateTime.now()).inDays;
    final totalDays = season.endDate.difference(season.startDate).inDays;
    final progress = 1 - (daysLeft / totalDays);

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary, AppColors.primary.withValues(alpha: 0.7)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(LucideIcons.moon, color: Colors.white, size: 24),
              const Gap(AppSpacing.sm),
              Text(
                'Ramadan ${season.year}',
                style: AppTypography.headlineSmall.copyWith(
                  color: Colors.white,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '$daysLeft days left',
                  style: AppTypography.labelSmall.copyWith(color: Colors.white),
                ),
              ),
            ],
          ),
          const Gap(AppSpacing.md),
          LinearProgressIndicator(
            value: progress.clamp(0, 1),
            backgroundColor: Colors.white.withValues(alpha: 0.3),
            valueColor: const AlwaysStoppedAnimation(Colors.white),
          ),
          const Gap(AppSpacing.md),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _statItem('Members', '${season.optedInMemberIds.length}'),
              _statItem('Meal Rate', '৳${mealRate.toStringAsFixed(1)}'),
              _statItem('Progress', '${(progress * 100).toInt()}%'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _statItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: AppTypography.titleMedium.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: AppTypography.labelSmall.copyWith(
            color: Colors.white.withValues(alpha: 0.8),
          ),
        ),
      ],
    );
  }

  Widget _buildQuickActions(RamadanSeason season) {
    return Row(
      children: [
        Expanded(
          child: _actionCard(
            icon: LucideIcons.sunrise,
            label: 'Sehri',
            color: AppColors.info,
            onTap: () => _quickAddMeal(season, RamadanMealType.sehri),
          ),
        ),
        const Gap(AppSpacing.sm),
        Expanded(
          child: _actionCard(
            icon: LucideIcons.sunset,
            label: 'Iftar',
            color: AppColors.warning,
            onTap: () => _quickAddMeal(season, RamadanMealType.iftar),
          ),
        ),
        const Gap(AppSpacing.sm),
        Expanded(
          child: _actionCard(
            icon: LucideIcons.shoppingCart,
            label: 'Bazar',
            color: AppColors.bazarColor,
            onTap: () => _showAddBazarSheet(context, season),
          ),
        ),
      ],
    );
  }

  Widget _actionCard({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 24),
            const Gap(AppSpacing.xs),
            Text(
              label,
              style: AppTypography.labelMedium.copyWith(color: color),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTodayMeals(RamadanSeason season) {
    final todayMeals = ref
        .watch(ramadanMealsProvider.notifier)
        .getMealsForDate(season.id, DateTime.now());

    final hasSehri = todayMeals.any((m) => m.type == RamadanMealType.sehri);
    final hasIftar = todayMeals.any((m) => m.type == RamadanMealType.iftar);

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.cardDark,
        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Today's Status",
            style: AppTypography.titleSmall.copyWith(
              color: AppColors.textPrimaryDark,
            ),
          ),
          const Gap(AppSpacing.sm),
          Row(
            children: [
              Expanded(
                child: _mealStatus(
                  'Sehri',
                  LucideIcons.sunrise,
                  hasSehri,
                  AppColors.info,
                ),
              ),
              const Gap(AppSpacing.sm),
              Expanded(
                child: _mealStatus(
                  'Iftar',
                  LucideIcons.sunset,
                  hasIftar,
                  AppColors.warning,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _mealStatus(String label, IconData icon, bool done, Color color) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: done ? color.withValues(alpha: 0.2) : AppColors.surfaceDark,
        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
        border: Border.all(color: done ? color : AppColors.borderDark),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            done ? LucideIcons.checkCircle : icon,
            color: done ? color : AppColors.textMutedDark,
            size: 18,
          ),
          const Gap(AppSpacing.xs),
          Text(
            label,
            style: AppTypography.labelMedium.copyWith(
              color: done ? color : AppColors.textMutedDark,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBalanceRow(RamadanBalance balance, List members) {
    final member = members.firstWhere(
      (m) => m.id == balance.memberId,
      orElse: () => null,
    );
    if (member == null) return const SizedBox.shrink();

    final isPositive = balance.balance >= 0;

    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.cardDark,
        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: AppColors.primary.withValues(alpha: 0.2),
            child: Text(
              member.name[0],
              style: AppTypography.labelMedium.copyWith(
                color: AppColors.primary,
              ),
            ),
          ),
          const Gap(AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  member.name,
                  style: AppTypography.titleSmall.copyWith(
                    color: AppColors.textPrimaryDark,
                  ),
                ),
                Text(
                  '${balance.totalMeals} meals • ৳${balance.totalBazar.toStringAsFixed(0)} bazar',
                  style: AppTypography.labelSmall.copyWith(
                    color: AppColors.textMutedDark,
                  ),
                ),
              ],
            ),
          ),
          Text(
            '${isPositive ? '+' : ''}৳${balance.balance.toStringAsFixed(0)}',
            style: AppTypography.titleMedium.copyWith(
              color: isPositive ? AppColors.success : AppColors.error,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  void _quickAddMeal(RamadanSeason season, RamadanMealType type) {
    final memberId = ref.read(currentMemberIdProvider);

    ref
        .read(ramadanMealsProvider.notifier)
        .addMeal(
          seasonId: season.id,
          memberId: memberId,
          date: DateTime.now(),
          type: type,
        );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '${type == RamadanMealType.sehri ? 'Sehri' : 'Iftar'} added ✓',
        ),
        backgroundColor: AppColors.success,
      ),
    );
  }

  void _showCreateSeasonSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const _CreateSeasonSheet(),
    );
  }

  void _showAddMealSheet(BuildContext context, RamadanSeason season) {
    // TODO: Implement full add meal sheet
  }

  void _showAddBazarSheet(BuildContext context, RamadanSeason season) {
    // TODO: Implement add bazar sheet
  }
}

/// Create Season Sheet
class _CreateSeasonSheet extends ConsumerStatefulWidget {
  const _CreateSeasonSheet();

  @override
  ConsumerState<_CreateSeasonSheet> createState() => _CreateSeasonSheetState();
}

class _CreateSeasonSheetState extends ConsumerState<_CreateSeasonSheet> {
  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now().add(const Duration(days: 30));
  final _yearController = TextEditingController(text: '1447');
  final Set<String> _selectedMembers = {};

  @override
  void initState() {
    super.initState();
    // Pre-select all members
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final members = ref.read(membersProvider);
      setState(() {
        _selectedMembers.addAll(members.map((m) => m.id));
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final members = ref.watch(membersProvider);

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.surfaceDark,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(AppSpacing.radiusLg),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.borderDark,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const Gap(AppSpacing.lg),
          Text(
            'Create Ramadan Season',
            style: AppTypography.headlineMedium.copyWith(
              color: AppColors.textPrimaryDark,
            ),
          ),
          const Gap(AppSpacing.lg),

          // Hijri Year
          TextField(
            controller: _yearController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Hijri Year',
              prefixIcon: Icon(LucideIcons.calendar, size: 18),
            ),
          ),
          const Gap(AppSpacing.md),

          // Date Range
          Row(
            children: [
              Expanded(
                child: _datePicker(
                  'Start',
                  _startDate,
                  (d) => setState(() => _startDate = d),
                ),
              ),
              const Gap(AppSpacing.sm),
              Expanded(
                child: _datePicker(
                  'End',
                  _endDate,
                  (d) => setState(() => _endDate = d),
                ),
              ),
            ],
          ),
          const Gap(AppSpacing.lg),

          // Opt-in Members
          Text(
            'Opt-in Members',
            style: AppTypography.labelMedium.copyWith(
              color: AppColors.textSecondaryDark,
            ),
          ),
          const Gap(AppSpacing.sm),
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: members.map((m) {
              final selected = _selectedMembers.contains(m.id);
              return FilterChip(
                selected: selected,
                label: Text(m.name),
                onSelected: (s) {
                  setState(() {
                    if (s) {
                      _selectedMembers.add(m.id);
                    } else {
                      _selectedMembers.remove(m.id);
                    }
                  });
                },
              );
            }).toList(),
          ),
          const Gap(AppSpacing.xl),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _create,
              icon: const Icon(LucideIcons.check, size: 18),
              label: const Text('Create Season'),
            ),
          ),
          const Gap(AppSpacing.lg),
        ],
      ),
    );
  }

  Widget _datePicker(
    String label,
    DateTime date,
    ValueChanged<DateTime> onChanged,
  ) {
    return GestureDetector(
      onTap: () async {
        final picked = await showDatePicker(
          context: context,
          initialDate: date,
          firstDate: DateTime.now().subtract(const Duration(days: 30)),
          lastDate: DateTime.now().add(const Duration(days: 120)),
        );
        if (picked != null) onChanged(picked);
      },
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: AppColors.cardDark,
          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
          border: Border.all(color: AppColors.borderDark),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: AppTypography.labelSmall.copyWith(
                color: AppColors.textMutedDark,
              ),
            ),
            const Gap(4),
            Text(
              '${date.day}/${date.month}/${date.year}',
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.textPrimaryDark,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _create() {
    if (_selectedMembers.isEmpty) return;

    ref
        .read(ramadanSeasonsProvider.notifier)
        .createSeason(
          startDate: _startDate,
          endDate: _endDate,
          hijriYear: int.tryParse(_yearController.text) ?? 1447,
          optedInMemberIds: _selectedMembers.toList(),
        );

    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Ramadan season created ✓'),
        backgroundColor: AppColors.success,
      ),
    );
  }
}
