import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:getwidget/getwidget.dart';

import 'package:mess_manager/core/theme/app_theme.dart';
import 'package:mess_manager/core/models/ramadan.dart';
import 'package:mess_manager/core/models/money_transaction.dart';
import 'package:mess_manager/core/providers/members_provider.dart';
import 'package:mess_manager/core/services/haptic_service.dart';
import 'package:mess_manager/core/widgets/gf_components.dart';
import 'package:mess_manager/features/ramadan/providers/ramadan_provider.dart';
import 'package:mess_manager/features/money/providers/money_provider.dart';

/// Ramadan Screen - Uses GetWidget + VelocityX + flutter_animate
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
        title: HStack([
          const Icon(LucideIcons.moon, color: AppColors.primary, size: 22),
          8.widthBox,
          'Ramadan'.text.make(),
        ]),
        actions: [
          if (season == null)
            TextButton.icon(
              onPressed: () => _showCreateSeasonSheet(context),
              icon: const Icon(LucideIcons.plus, size: 18),
              label: 'New Season'.text.make(),
            ),
        ],
      ),
      body: season == null
          ? _buildNoSeasonState()
          : SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: VStack(crossAlignment: CrossAxisAlignment.start, [
                // Season Info Card
                _buildSeasonCard(
                  season,
                  mealRate,
                ).animate().fadeIn().scale(begin: const Offset(0.95, 0.95)),
                16.heightBox,

                // Quick Actions
                _buildQuickActions(season),
                16.heightBox,

                // Today's Meals
                _buildTodayMeals(season),
                16.heightBox,

                // Balances
                'Balances'.text.xl.bold.color(AppColors.textPrimaryDark).make(),
                8.heightBox,
                ...balances.asMap().entries.map(
                  (e) => _buildBalanceRow(e.value, members, e.key),
                ),
                16.heightBox,

                // Credit/Debt Section
                _buildCreditDebtSection(members),
              ]),
            ),
      floatingActionButton: season != null
          ? FloatingActionButton.extended(
              onPressed: () => _showAddMealSheet(context, season),
              icon: const Icon(LucideIcons.utensils),
              label: 'Add Meal'.text.make(),
              backgroundColor: AppColors.primary,
            ).animate().scale(delay: 300.ms)
          : null,
    );
  }

  Widget _buildNoSeasonState() {
    return VStack(alignment: MainAxisAlignment.center, [
      const Icon(LucideIcons.moon, size: 64, color: AppColors.textMutedDark),
      16.heightBox,
      'No Active Ramadan Season'.text.xl
          .color(AppColors.textPrimaryDark)
          .center
          .make(),
      8.heightBox,
      'Create a new season to start tracking'.text
          .color(AppColors.textSecondaryDark)
          .center
          .make(),
      24.heightBox,
      GFPrimaryButton(
        text: 'Create Season',
        icon: LucideIcons.plus,
        onPressed: () => _showCreateSeasonSheet(context),
      ),
    ]).centered().animate().fadeIn();
  }

  Widget _buildSeasonCard(RamadanSeason season, double mealRate) {
    final daysLeft = season.endDate.difference(DateTime.now()).inDays;
    final totalDays = season.endDate.difference(season.startDate).inDays;
    final progress = 1 - (daysLeft / totalDays);

    return GFCard(
      margin: EdgeInsets.zero,
      padding: const EdgeInsets.all(AppSpacing.lg),
      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      gradient: LinearGradient(
        colors: [AppColors.primary, AppColors.primary.withValues(alpha: 0.7)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      content: VStack(crossAlignment: CrossAxisAlignment.start, [
        HStack([
          const Icon(LucideIcons.moon, color: Colors.white, size: 24),
          8.widthBox,
          'Ramadan ${season.year}'.text.xl.white.bold.make().expand(),
          GFBadge(
            text: '$daysLeft days left',
            color: Colors.white.withValues(alpha: 0.2),
            textColor: Colors.white,
            size: GFSize.SMALL,
            shape: GFBadgeShape.pills,
          ),
        ]),
        12.heightBox,
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: progress.clamp(0, 1).toDouble(),
            backgroundColor: Colors.white.withValues(alpha: 0.3),
            valueColor: const AlwaysStoppedAnimation(Colors.white),
            minHeight: 6,
          ),
        ),
        12.heightBox,
        HStack(alignment: MainAxisAlignment.spaceAround, [
          _statItem('Members', '${season.optedInMemberIds.length}'),
          _statItem('Meal Rate', '৳${mealRate.toStringAsFixed(1)}'),
          _statItem('Progress', '${(progress * 100).toInt()}%'),
        ]),
      ]),
    );
  }

  Widget _statItem(String label, String value) {
    return VStack([
      value.text.lg.white.bold.make(),
      label.text.xs.color(Colors.white.withValues(alpha: 0.8)).make(),
    ]);
  }

  Widget _buildQuickActions(RamadanSeason season) {
    return HStack([
      _actionCard(
        icon: LucideIcons.sunrise,
        label: 'Sehri',
        color: AppColors.info,
        onTap: () => _quickAddMeal(season, RamadanMealType.sehri),
      ).expand(),
      8.widthBox,
      _actionCard(
        icon: LucideIcons.sunset,
        label: 'Iftar',
        color: AppColors.warning,
        onTap: () => _quickAddMeal(season, RamadanMealType.iftar),
      ).expand(),
      8.widthBox,
      _actionCard(
        icon: LucideIcons.shoppingCart,
        label: 'Bazar',
        color: AppColors.bazarColor,
        onTap: () => _showAddBazarSheet(context, season),
      ).expand(),
    ]).animate(delay: 100.ms).fadeIn().slideY(begin: 0.05);
  }

  Widget _actionCard({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GFAppCard(
      color: color.withValues(alpha: 0.15),
      borderColor: color.withValues(alpha: 0.3),
      onTap: onTap,
      child: VStack([
        Icon(icon, color: color, size: 24),
        8.heightBox,
        label.text.sm.color(color).center.make(),
      ]).p8(),
    );
  }

  Widget _buildTodayMeals(RamadanSeason season) {
    final todayMeals = ref
        .watch(ramadanMealsProvider.notifier)
        .getMealsForDate(season.id, DateTime.now());
    final hasSehri = todayMeals.any((m) => m.type == RamadanMealType.sehri);
    final hasIftar = todayMeals.any((m) => m.type == RamadanMealType.iftar);

    return GFAppCard(
      child: VStack(crossAlignment: CrossAxisAlignment.start, [
        "Today's Status".text.bold.color(AppColors.textPrimaryDark).make(),
        8.heightBox,
        HStack([
          _mealStatus(
            'Sehri',
            LucideIcons.sunrise,
            hasSehri,
            AppColors.info,
          ).expand(),
          8.widthBox,
          _mealStatus(
            'Iftar',
            LucideIcons.sunset,
            hasIftar,
            AppColors.warning,
          ).expand(),
        ]),
      ]),
    ).animate(delay: 200.ms).fadeIn();
  }

  Widget _mealStatus(String label, IconData icon, bool done, Color color) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: done ? color.withValues(alpha: 0.2) : AppColors.surfaceDark,
        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
        border: Border.all(color: done ? color : AppColors.borderDark),
      ),
      child: HStack(alignment: MainAxisAlignment.center, [
        Icon(
          done ? LucideIcons.checkCircle : icon,
          color: done ? color : AppColors.textMutedDark,
          size: 18,
        ),
        4.widthBox,
        label.text.sm.color(done ? color : AppColors.textMutedDark).make(),
      ]),
    );
  }

  Widget _buildBalanceRow(RamadanBalance balance, List members, int index) {
    final member = members.firstWhere(
      (m) => m.id == balance.memberId,
      orElse: () => null,
    );
    if (member == null) return const SizedBox.shrink();

    final isPositive = balance.balance >= 0;

    return GFAppCard(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: HStack([
        GFMemberAvatar(
          name: member.name,
          size: 36,
          backgroundColor: AppColors.primary.withValues(alpha: 0.2),
        ),
        8.widthBox,
        VStack(crossAlignment: CrossAxisAlignment.start, [
          member.name.text.color(AppColors.textPrimaryDark).make(),
          '${balance.totalMeals} meals • ৳${balance.totalBazar.toStringAsFixed(0)} bazar'
              .text
              .xs
              .color(AppColors.textMutedDark)
              .make(),
        ]).expand(),
        '${isPositive ? '+' : ''}৳${balance.balance.toStringAsFixed(0)}'.text.lg
            .color(isPositive ? AppColors.success : AppColors.error)
            .bold
            .make(),
      ]),
    ).animate(delay: (60 * index).ms).fadeIn().slideX(begin: 0.02);
  }

  Widget _buildCreditDebtSection(List members) {
    final creditDebts = ref.watch(ramadanCreditDebtProvider);
    final isSettled = ref.watch(isRamadanSettledProvider);
    final season =
        ref.watch(activeRamadanSeasonProvider) ??
        ref.watch(ramadanSeasonNeedingSettlementProvider);

    if (creditDebts.isEmpty && isSettled) {
      return GFAppCard(
        color: AppColors.success.withValues(alpha: 0.1),
        borderColor: AppColors.success.withValues(alpha: 0.3),
        child: HStack([
          const Icon(
            LucideIcons.checkCircle,
            color: AppColors.success,
            size: 20,
          ),
          8.widthBox,
          'All balances settled!'.text.color(AppColors.success).make().expand(),
          if (season != null && !season.isSettled)
            GFSecondaryButton(
              text: 'Close Season',
              color: AppColors.success,
              onPressed: () => _markSettled(season.id),
            ),
        ]),
      );
    }

    return VStack(crossAlignment: CrossAxisAlignment.start, [
      'Who Owes Whom'.text.xl.bold.color(AppColors.textPrimaryDark).make(),
      8.heightBox,
      ...creditDebts.asMap().entries.map(
        (e) => _buildCreditDebtRow(e.value, members, e.key),
      ),
    ]);
  }

  Widget _buildCreditDebtRow(RamadanCreditDebt cd, List members, int index) {
    final from = members.firstWhere(
      (m) => m.id == cd.fromMemberId,
      orElse: () => null,
    );
    final to = members.firstWhere(
      (m) => m.id == cd.toMemberId,
      orElse: () => null,
    );
    if (from == null || to == null) return const SizedBox.shrink();

    return GFAppCard(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: HStack([
        GFMemberAvatar(
          name: from.name,
          size: 32,
          backgroundColor: AppColors.error.withValues(alpha: 0.2),
        ),
        8.widthBox,
        VStack(crossAlignment: CrossAxisAlignment.start, [
          '${from.name} → ${to.name}'.text
              .color(AppColors.textPrimaryDark)
              .make(),
          '৳${cd.amount.toStringAsFixed(0)}'.text.sm
              .color(AppColors.warning)
              .bold
              .make(),
        ]).expand(),
        GFIconButton(
          icon: const Icon(
            LucideIcons.checkCircle,
            color: AppColors.success,
            size: 20,
          ),
          type: GFButtonType.transparent,
          onPressed: () => _markRamadanPayment(cd),
        ),
      ]),
    ).animate(delay: (60 * index).ms).fadeIn().slideX(begin: 0.02);
  }

  void _markSettled(String seasonId) {
    ref.read(ramadanSeasonsProvider.notifier).markSeasonSettled(seasonId);
    showSuccessToast(context, 'Ramadan season closed ✓');
  }

  void _markRamadanPayment(RamadanCreditDebt cd) {
    HapticService.success();

    // Create a settled money transaction to record the payment
    final transaction = MoneyTransaction(
      id: 'ramadan_${DateTime.now().millisecondsSinceEpoch}',
      fromMemberId: cd.fromMemberId, // Debtor pays
      toMemberId: cd.toMemberId, // Creditor receives
      amount: cd.amount,
      description: 'Ramadan settlement',
      date: DateTime.now(),
      isSettled: true,
      settledAt: DateTime.now(),
    );

    ref.read(moneyTransactionsProvider.notifier).addTransaction(transaction);
    showSuccessToast(
      context,
      'Payment of ৳${cd.amount.toStringAsFixed(0)} recorded ✓',
    );
  }

  void _quickAddMeal(RamadanSeason season, RamadanMealType type) {
    HapticService.buttonPress();
    final memberId = ref.read(currentMemberIdProvider);

    ref
        .read(ramadanMealsProvider.notifier)
        .addMeal(
          seasonId: season.id,
          memberId: memberId,
          date: DateTime.now(),
          type: type,
        );

    showSuccessToast(
      context,
      '${type == RamadanMealType.sehri ? 'Sehri' : 'Iftar'} added ✓',
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
    HapticService.modalOpen();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _AddRamadanMealSheet(season: season),
    );
  }

  void _showAddBazarSheet(BuildContext context, RamadanSeason season) {
    HapticService.modalOpen();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _AddRamadanBazarSheet(season: season),
    );
  }
}

// ==================== Add Ramadan Meal Sheet ====================

class _AddRamadanMealSheet extends ConsumerStatefulWidget {
  final RamadanSeason season;

  const _AddRamadanMealSheet({required this.season});

  @override
  ConsumerState<_AddRamadanMealSheet> createState() =>
      _AddRamadanMealSheetState();
}

class _AddRamadanMealSheetState extends ConsumerState<_AddRamadanMealSheet> {
  String? _selectedMemberId;
  RamadanMealType _mealType = RamadanMealType.iftar;
  double _portions = 1.0;
  int _guests = 0;

  @override
  void initState() {
    super.initState();
    _selectedMemberId = ref.read(currentMemberIdProvider);
  }

  @override
  Widget build(BuildContext context) {
    final members = ref.watch(membersProvider);

    return Container(
      padding: EdgeInsets.only(
        left: AppSpacing.lg,
        right: AppSpacing.lg,
        top: AppSpacing.lg,
        bottom: MediaQuery.of(context).viewInsets.bottom + AppSpacing.lg,
      ),
      decoration: const BoxDecoration(
        color: AppColors.surfaceDark,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppSpacing.radiusLg),
        ),
      ),
      child: VStack(crossAlignment: CrossAxisAlignment.start, [
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
        16.heightBox,
        'Add Ramadan Meal'.text.xl2.bold
            .color(AppColors.textPrimaryDark)
            .make(),
        16.heightBox,

        // Member Selector
        'Member'.text.sm.color(AppColors.textMutedDark).make(),
        8.heightBox,
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: members
              .map(
                (m) => ChoiceChip(
                  label: m.name.text.make(),
                  selected: _selectedMemberId == m.id,
                  onSelected: (_) => setState(() => _selectedMemberId = m.id),
                ),
              )
              .toList(),
        ),
        16.heightBox,

        // Meal Type
        'Meal Type'.text.sm.color(AppColors.textMutedDark).make(),
        8.heightBox,
        HStack([
          _mealTypeChip(RamadanMealType.sehri, LucideIcons.sunrise),
          8.widthBox,
          _mealTypeChip(RamadanMealType.iftar, LucideIcons.sunset),
        ]),
        16.heightBox,

        // Portions
        HStack([
          'Portions'.text.color(AppColors.textSecondaryDark).make().expand(),
          GFIconButton(
            icon: const Icon(LucideIcons.minus, size: 16),
            size: GFSize.SMALL,
            type: GFButtonType.outline,
            onPressed: () {
              if (_portions > 0.5) setState(() => _portions -= 0.5);
            },
          ),
          '${_portions}x'.text.lg.bold
              .color(AppColors.textPrimaryDark)
              .make()
              .pSymmetric(h: 12),
          GFIconButton(
            icon: const Icon(LucideIcons.plus, size: 16),
            size: GFSize.SMALL,
            type: GFButtonType.outline,
            onPressed: () => setState(() => _portions += 0.5),
          ),
        ]),
        12.heightBox,

        // Guests
        HStack([
          'Guests'.text.color(AppColors.textSecondaryDark).make().expand(),
          GFIconButton(
            icon: const Icon(LucideIcons.minus, size: 16),
            size: GFSize.SMALL,
            type: GFButtonType.outline,
            onPressed: () {
              if (_guests > 0) setState(() => _guests--);
            },
          ),
          '$_guests'.text.lg.bold
              .color(AppColors.textPrimaryDark)
              .make()
              .pSymmetric(h: 12),
          GFIconButton(
            icon: const Icon(LucideIcons.plus, size: 16),
            size: GFSize.SMALL,
            type: GFButtonType.outline,
            onPressed: () => setState(() => _guests++),
          ),
        ]),
        24.heightBox,

        GFPrimaryButton(
          text: 'Add Meal',
          icon: LucideIcons.check,
          onPressed: _submit,
        ),
        16.heightBox,
      ]),
    );
  }

  Widget _mealTypeChip(RamadanMealType type, IconData icon) {
    final isSelected = _mealType == type;
    final label = type == RamadanMealType.sehri ? 'Sehri' : 'Iftar';
    return ChoiceChip(
      label: HStack([
        Icon(
          icon,
          size: 16,
          color: isSelected ? Colors.white : AppColors.textPrimaryDark,
        ),
        6.widthBox,
        label.text
            .color(isSelected ? Colors.white : AppColors.textPrimaryDark)
            .make(),
      ]),
      selected: isSelected,
      onSelected: (_) => setState(() => _mealType = type),
    );
  }

  void _submit() {
    if (_selectedMemberId == null) {
      showErrorToast(context, 'Select a member');
      return;
    }

    HapticService.success();
    ref
        .read(ramadanMealsProvider.notifier)
        .addMeal(
          seasonId: widget.season.id,
          memberId: _selectedMemberId!,
          date: DateTime.now(),
          type: _mealType,
          count: _portions.toInt(),
          guestName: _guests > 0 ? 'Guest(s): $_guests' : null,
        );

    Navigator.pop(context);
    showSuccessToast(
      context,
      '${_mealType == RamadanMealType.sehri ? "Sehri" : "Iftar"} meal added ✓',
    );
  }
}

// ==================== Add Ramadan Bazar Sheet ====================

class _AddRamadanBazarSheet extends ConsumerStatefulWidget {
  final RamadanSeason season;

  const _AddRamadanBazarSheet({required this.season});

  @override
  ConsumerState<_AddRamadanBazarSheet> createState() =>
      _AddRamadanBazarSheetState();
}

class _AddRamadanBazarSheetState extends ConsumerState<_AddRamadanBazarSheet> {
  final _itemController = TextEditingController();
  final _amountController = TextEditingController();
  String? _selectedMemberId;

  @override
  void initState() {
    super.initState();
    _selectedMemberId = ref.read(currentMemberIdProvider);
  }

  @override
  Widget build(BuildContext context) {
    final members = ref.watch(membersProvider);

    return Container(
      padding: EdgeInsets.only(
        left: AppSpacing.lg,
        right: AppSpacing.lg,
        top: AppSpacing.lg,
        bottom: MediaQuery.of(context).viewInsets.bottom + AppSpacing.lg,
      ),
      decoration: const BoxDecoration(
        color: AppColors.surfaceDark,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppSpacing.radiusLg),
        ),
      ),
      child: VStack(crossAlignment: CrossAxisAlignment.start, [
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
        16.heightBox,
        'Add Ramadan Bazar'.text.xl2.bold
            .color(AppColors.textPrimaryDark)
            .make(),
        16.heightBox,

        // Member Selector
        'Paid By'.text.sm.color(AppColors.textMutedDark).make(),
        8.heightBox,
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: members
              .map(
                (m) => ChoiceChip(
                  label: m.name.text.make(),
                  selected: _selectedMemberId == m.id,
                  onSelected: (_) => setState(() => _selectedMemberId = m.id),
                ),
              )
              .toList(),
        ),
        16.heightBox,

        // Item Description
        TextField(
          controller: _itemController,
          decoration: const InputDecoration(
            labelText: 'Item Description',
            hintText: 'e.g., Dates, Fruits, Iftar items',
            prefixIcon: Icon(LucideIcons.shoppingBag, size: 18),
          ),
        ),
        12.heightBox,

        // Amount
        TextField(
          controller: _amountController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'Amount (৳)',
            hintText: '0',
            prefixIcon: Icon(LucideIcons.banknote, size: 18),
          ),
        ),
        24.heightBox,

        GFPrimaryButton(
          text: 'Add Bazar Entry',
          icon: LucideIcons.check,
          onPressed: _submit,
        ),
        16.heightBox,
      ]),
    );
  }

  void _submit() {
    final amount = double.tryParse(_amountController.text) ?? 0;
    if (_selectedMemberId == null) {
      showErrorToast(context, 'Select a member');
      return;
    }
    if (_itemController.text.isEmpty) {
      showErrorToast(context, 'Enter item description');
      return;
    }
    if (amount <= 0) {
      showErrorToast(context, 'Enter valid amount');
      return;
    }

    HapticService.success();
    ref
        .read(ramadanBazarProvider.notifier)
        .addBazar(
          seasonId: widget.season.id,
          memberId: _selectedMemberId!,
          amount: amount,
          description: _itemController.text,
        );

    Navigator.pop(context);
    showSuccessToast(context, 'Bazar entry added ✓');
  }
}

// ==================== Create Season Sheet ====================

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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final members = ref.read(membersProvider);
      setState(() => _selectedMembers.addAll(members.map((m) => m.id)));
    });
  }

  @override
  Widget build(BuildContext context) {
    final members = ref.watch(membersProvider);

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: const BoxDecoration(
        color: AppColors.surfaceDark,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppSpacing.radiusLg),
        ),
      ),
      child: VStack(crossAlignment: CrossAxisAlignment.start, [
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
        16.heightBox,
        'Create Ramadan Season'.text.xl2
            .color(AppColors.textPrimaryDark)
            .make(),
        16.heightBox,

        // Hijri Year
        TextField(
          controller: _yearController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'Hijri Year',
            prefixIcon: Icon(LucideIcons.calendar, size: 18),
          ),
        ),
        12.heightBox,

        // Date Range
        HStack([
          _datePicker(
            'Start',
            _startDate,
            (d) => setState(() => _startDate = d),
          ).expand(),
          8.widthBox,
          _datePicker(
            'End',
            _endDate,
            (d) => setState(() => _endDate = d),
          ).expand(),
        ]),
        16.heightBox,

        // Opt-in Members
        'Opt-in Members'.text.sm.color(AppColors.textSecondaryDark).make(),
        8.heightBox,
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: members.map((m) {
            final selected = _selectedMembers.contains(m.id);
            return FilterChip(
              selected: selected,
              label: m.name.text.make(),
              onSelected: (s) {
                HapticService.selectionTick();
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
        24.heightBox,

        GFPrimaryButton(
          text: 'Create Season',
          icon: LucideIcons.check,
          onPressed: _create,
        ),
        16.heightBox,
      ]),
    );
  }

  Widget _datePicker(
    String label,
    DateTime date,
    ValueChanged<DateTime> onChanged,
  ) {
    return GestureDetector(
      onTap: () async {
        HapticService.lightTap();
        final picked = await showDatePicker(
          context: context,
          initialDate: date,
          firstDate: DateTime.now().subtract(const Duration(days: 30)),
          lastDate: DateTime.now().add(const Duration(days: 120)),
        );
        if (picked != null) onChanged(picked);
      },
      child: GFAppCard(
        child: VStack(crossAlignment: CrossAxisAlignment.start, [
          label.text.xs.color(AppColors.textMutedDark).make(),
          4.heightBox,
          '${date.day}/${date.month}/${date.year}'.text
              .color(AppColors.textPrimaryDark)
              .make(),
        ]),
      ),
    );
  }

  void _create() {
    if (_selectedMembers.isEmpty) {
      showErrorToast(context, 'Select at least one member');
      return;
    }

    HapticService.success();
    ref
        .read(ramadanSeasonsProvider.notifier)
        .createSeason(
          startDate: _startDate,
          endDate: _endDate,
          hijriYear: int.tryParse(_yearController.text) ?? 1447,
          optedInMemberIds: _selectedMembers.toList(),
        );

    Navigator.of(context).pop();
    showSuccessToast(context, 'Ramadan season created ✓');
  }
}
