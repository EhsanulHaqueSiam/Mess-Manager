import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:gap/gap.dart';

import 'package:mess_manager/core/theme/app_theme.dart';
import 'package:mess_manager/core/providers/members_provider.dart';
import 'package:mess_manager/core/providers/role_provider.dart';
import 'package:mess_manager/core/services/haptic_service.dart';
import 'package:mess_manager/core/services/export_service.dart';
import 'package:mess_manager/core/widgets/app_components.dart';
import 'package:mess_manager/core/widgets/animated_widgets.dart';
import 'package:mess_manager/features/bazar/providers/bazar_provider.dart';
import 'package:mess_manager/features/bazar/providers/bazar_list_provider.dart';
import 'package:mess_manager/features/bazar/widgets/add_bazar_sheet.dart';
import 'package:mess_manager/features/bazar/widgets/bazar_list_tab.dart';
import 'package:mess_manager/features/settlement/providers/settlement_provider.dart';
import 'package:mess_manager/features/balance/providers/balance_provider.dart';
import 'package:mess_manager/features/bazar/widgets/budget_card.dart';

/// Bazar Screen - Cosmic Bioluminescence Design
class BazarScreen extends ConsumerStatefulWidget {
  const BazarScreen({super.key});

  @override
  ConsumerState<BazarScreen> createState() => _BazarScreenState();
}

class _BazarScreenState extends ConsumerState<BazarScreen>
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

  /// Show export options sheet (CSV/Excel)
  void _showExportOptions(BuildContext context) {
    HapticService.lightTap();
    try {
    final members = ref.read(membersProvider);
    final balances = ref.read(currentMonthBalancesProvider);
    final mealRate = ref.read(mealRateProvider);
    final totalBazar = ref.read(totalBazarProvider);
    final now = DateTime.now();

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => ClipRRect(
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(AppSpacing.radiusLg),
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFF0D1520).withValues(alpha: 0.95),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(AppSpacing.radiusLg),
              ),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.08),
              ),
            ),
            child: SafeArea(
              child: Wrap(
                children: [
                  // Handle bar
                  Center(
                    child: Container(
                      margin: const EdgeInsets.only(top: 12, bottom: 8),
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  ListTile(
                    leading: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            AppColors.success.withValues(alpha: 0.3),
                            AppColors.success.withValues(alpha: 0.05),
                          ],
                        ),
                      ),
                      child: const Icon(
                        LucideIcons.fileSpreadsheet,
                        color: AppColors.success,
                        size: 18,
                      ),
                    ),
                    title: Text(
                      'Export as Excel (XLSX)',
                      style: TextStyle(color: Colors.white.withValues(alpha: 0.9)),
                    ),
                    subtitle: Text(
                      'Detailed balance sheet',
                      style: TextStyle(color: Colors.white.withValues(alpha: 0.4)),
                    ),
                    onTap: () async {
                      Navigator.pop(context);
                      final xlsxBytes = ExportService.generateBalancesXlsx(
                        year: now.year,
                        month: now.month,
                        totalBazar: totalBazar,
                        mealRate: mealRate,
                        balances: balances,
                        members: members,
                      );
                      await ExportService.shareXlsx(
                        xlsxBytes,
                        'bazar_report_${now.year}_${now.month}.xlsx',
                      );
                      HapticService.success();
                    },
                  ),
                  ListTile(
                    leading: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            AppColors.info.withValues(alpha: 0.3),
                            AppColors.info.withValues(alpha: 0.05),
                          ],
                        ),
                      ),
                      child: const Icon(
                        LucideIcons.fileText,
                        color: AppColors.info,
                        size: 18,
                      ),
                    ),
                    title: Text(
                      'Export as CSV',
                      style: TextStyle(color: Colors.white.withValues(alpha: 0.9)),
                    ),
                    subtitle: Text(
                      'Simple comma-separated',
                      style: TextStyle(color: Colors.white.withValues(alpha: 0.4)),
                    ),
                    onTap: () async {
                      Navigator.pop(context);
                      final csv = ExportService.generateBalancesCsv(
                        balances: balances,
                        members: members,
                      );
                      await ExportService.shareCsv(
                        csv,
                        'bazar_report_${now.year}_${now.month}.csv',
                      );
                      HapticService.success();
                    },
                  ),
                  const Gap(AppSpacing.md),
                ],
              ),
            ),
          ),
        ),
      ),
    );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Export not available: $e'), backgroundColor: AppColors.error),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final entries = ref.watch(bazarEntriesProvider);
    final members = ref.watch(membersProvider);
    final totalBazar = ref.watch(totalBazarProvider);
    final bazarByMember = ref.watch(bazarByMemberProvider);
    final pendingItemsCount = ref.watch(pendingItemsCountProvider);

    return Scaffold(
      backgroundColor: const Color(0xFF0A0E1A),
      body: Stack(
        children: [
          // === Deep Space Background ===
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFF0A0E1A), Color(0xFF0D1520)],
                ),
              ),
            ),
          ),

          // Bazar-themed accent orb (warm green glow)
          Positioned(
            top: -40,
            right: -60,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppColors.bazarColor.withValues(alpha: 0.15),
                    AppColors.bazarColor.withValues(alpha: 0.02),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          // Secondary teal orb
          Positioned(
            bottom: 100,
            left: -40,
            child: Container(
              width: 160,
              height: 160,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppColors.primary.withValues(alpha: 0.08),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          // === Main Content ===
          SafeArea(
            child: NestedScrollView(
              headerSliverBuilder: (context, innerBoxIsScrolled) => [
                // Custom Header
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                    child: Row(
                      children: [
                        // Icon with gradient halo
                        Container(
                          width: 42,
                          height: 42,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: RadialGradient(
                              colors: [
                                AppColors.bazarColor.withValues(alpha: 0.3),
                                AppColors.bazarColor.withValues(alpha: 0.05),
                              ],
                            ),
                            border: Border.all(
                              color: AppColors.bazarColor.withValues(alpha: 0.2),
                            ),
                          ),
                          child: const Icon(
                            LucideIcons.shoppingCart,
                            color: AppColors.bazarColor,
                            size: 20,
                          ),
                        ),
                        const Gap(12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Bazar',
                                style: AppTypography.headlineMedium.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              Text(
                                '${entries.length} entries this month',
                                style: AppTypography.bodySmall.copyWith(
                                  color: Colors.white.withValues(alpha: 0.4),
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Export button
                        _buildGlassIconButton(
                          icon: LucideIcons.download,
                          onTap: () => _showExportOptions(context),
                        ),
                      ],
                    ).animate().fadeIn(duration: 500.ms).slideY(begin: -0.1),
                  ),
                ),

                // Glass Tab Bar
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                        child: Container(
                          height: 48,
                          decoration: AppSpacing.accentCard(
                            accent: AppColors.bazarColor,
                            radius: AppSpacing.radiusMd,
                          ),
                          child: TabBar(
                            controller: _tabController,
                            labelColor: Colors.white,
                            unselectedLabelColor:
                                Colors.white.withValues(alpha: 0.4),
                            indicatorSize: TabBarIndicatorSize.tab,
                            indicator: BoxDecoration(
                              borderRadius:
                                  BorderRadius.circular(AppSpacing.radiusMd - 2),
                              gradient: const LinearGradient(
                                colors: AppColors.gradientBazar,
                              ),
                            ),
                            dividerColor: Colors.transparent,
                            tabs: [
                              const Tab(
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(LucideIcons.receipt, size: 16),
                                    Gap(6),
                                    Text('Entries'),
                                  ],
                                ),
                              ),
                              Tab(
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Badge(
                                      label: pendingItemsCount > 0
                                          ? Text(
                                              pendingItemsCount.toString(),
                                              style: const TextStyle(fontSize: 9),
                                            )
                                          : null,
                                      isLabelVisible: pendingItemsCount > 0,
                                      backgroundColor: AppColors.warning,
                                      child: const Icon(
                                          LucideIcons.listTodo, size: 16),
                                    ),
                                    const Gap(6),
                                    const Text('Shopping List'),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ).animate().fadeIn(delay: 200.ms),
                ),
              ],
              body: TabBarView(
                controller: _tabController,
                children: [
                  _EntriesTab(
                    entries: entries,
                    members: members,
                    totalBazar: totalBazar,
                    bazarByMember: bazarByMember,
                  ),
                  const BazarListTab(),
                ],
              ),
            ),
          ),
        ],
      ),
      // FAB now in MainShell (global speed dial)
    );
  }

  Widget _buildGlassIconButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.06),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.08),
              ),
            ),
            child: Icon(icon, color: Colors.white.withValues(alpha: 0.7), size: 18),
          ),
        ),
      ),
    );
  }


}

/// Entries Tab - Cosmic Design
class _EntriesTab extends ConsumerStatefulWidget {
  final List entries;
  final List members;
  final double totalBazar;
  final Map<String, double> bazarByMember;

  const _EntriesTab({
    required this.entries,
    required this.members,
    required this.totalBazar,
    required this.bazarByMember,
  });

  @override
  ConsumerState<_EntriesTab> createState() => _EntriesTabState();
}

class _EntriesTabState extends ConsumerState<_EntriesTab> {
  final _searchController = TextEditingController();
  String _searchQuery = '';

  // Advanced filters
  DateTimeRange? _dateRange;
  String? _selectedMemberId;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List get _filteredEntries {
    var filtered = widget.entries.toList();

    // Text search filter
    if (_searchQuery.isNotEmpty) {
      final query = _searchQuery.toLowerCase();
      filtered = filtered.where((entry) {
        final description = (entry.description ?? '').toLowerCase();
        final member = widget.members.cast<dynamic>().firstWhere(
          (m) => m.id == entry.memberId,
          orElse: () => null,
        );
        final memberName = member?.name?.toString().toLowerCase() ?? '';
        return description.contains(query) || memberName.contains(query);
      }).toList();
    }

    // Date range filter
    if (_dateRange != null) {
      filtered = filtered.where((entry) {
        final date = entry.date as DateTime;
        return date.isAfter(
              _dateRange!.start.subtract(const Duration(days: 1)),
            ) &&
            date.isBefore(_dateRange!.end.add(const Duration(days: 1)));
      }).toList();
    }

    // Member filter
    if (_selectedMemberId != null) {
      filtered = filtered
          .where((entry) => entry.memberId == _selectedMemberId)
          .toList();
    }

    return filtered;
  }

  bool get _hasActiveFilters => _dateRange != null || _selectedMemberId != null;

  void _clearAllFilters() {
    setState(() {
      _dateRange = null;
      _selectedMemberId = null;
      _searchQuery = '';
      _searchController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.entries.isEmpty) {
      return EmptyStateWidget.noBazar(
        action: ShimmerCTAButton(
          text: 'Add First Entry',
          icon: LucideIcons.plus,
          onPressed: () {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              builder: (context) => const AddBazarSheet(),
            );
          },
        ),
      );
    }

    final sortedEntries = [..._filteredEntries]
      ..sort((a, b) => b.date.compareTo(a.date));

    return RefreshIndicator(
      onRefresh: () async {
        HapticService.lightTap();
        ref.invalidate(bazarEntriesProvider);
        await Future.delayed(const Duration(milliseconds: 300));
      },
      color: AppColors.bazarColor,
      backgroundColor: const Color(0xFF0D1520),
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          // Budget Card
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.only(top: AppSpacing.md),
              child: BudgetCard(),
            ),
          ),

          // Glass Search Bar
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                      child: TextField(
                        controller: _searchController,
                        onChanged: (value) =>
                            setState(() => _searchQuery = value),
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.9),
                        ),
                        decoration: InputDecoration(
                          hintText: 'Search entries...',
                          hintStyle: TextStyle(
                            color: Colors.white.withValues(alpha: 0.3),
                          ),
                          prefixIcon: Icon(
                            LucideIcons.search,
                            size: 20,
                            color: Colors.white.withValues(alpha: 0.4),
                          ),
                          suffixIcon: _searchQuery.isNotEmpty
                              ? IconButton(
                                  icon: Icon(
                                    LucideIcons.x,
                                    size: 18,
                                    color: Colors.white.withValues(alpha: 0.4),
                                  ),
                                  onPressed: () {
                                    _searchController.clear();
                                    setState(() => _searchQuery = '');
                                  },
                                )
                              : null,
                          filled: true,
                          fillColor: Colors.white.withValues(alpha: 0.04),
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(AppSpacing.radiusMd),
                            borderSide: BorderSide(
                              color: Colors.white.withValues(alpha: 0.06),
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(AppSpacing.radiusMd),
                            borderSide: BorderSide(
                              color: Colors.white.withValues(alpha: 0.06),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(AppSpacing.radiusMd),
                            borderSide: BorderSide(
                              color:
                                  AppColors.bazarColor.withValues(alpha: 0.4),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const Gap(AppSpacing.sm),
                  // Filter chips
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _buildGlassFilterChip(
                          label: _dateRange != null
                              ? '${_dateRange!.start.day}/${_dateRange!.start.month} - ${_dateRange!.end.day}/${_dateRange!.end.month}'
                              : 'Date Range',
                          icon: LucideIcons.calendar,
                          isSelected: _dateRange != null,
                          onTap: _showDateRangePicker,
                        ),
                        const Gap(AppSpacing.sm),
                        _buildGlassFilterChip(
                          label: _selectedMemberId != null &&
                                  widget.members.isNotEmpty
                              ? (widget.members
                                        .cast<dynamic>()
                                        .firstWhere(
                                          (m) => m.id == _selectedMemberId,
                                          orElse: () => null,
                                        )
                                        ?.name
                                        ?.toString() ??
                                    'Unknown')
                              : 'All Members',
                          icon: LucideIcons.user,
                          isSelected: _selectedMemberId != null,
                          onTap: _showMemberPicker,
                        ),
                        if (_hasActiveFilters) ...[
                          const Gap(AppSpacing.sm),
                          GestureDetector(
                            onTap: _clearAllFilters,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.error.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color:
                                      AppColors.error.withValues(alpha: 0.2),
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    LucideIcons.x,
                                    size: 14,
                                    color:
                                        AppColors.error.withValues(alpha: 0.8),
                                  ),
                                  const Gap(4),
                                  Text(
                                    'Clear',
                                    style: AppTypography.bodySmall.copyWith(
                                      color: AppColors.error
                                          .withValues(alpha: 0.8),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ).animate().fadeIn(delay: 300.ms),
          ),

          // Total Bazar Card
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
              child: _buildTotalCard(context),
            ),
          ),

          // Contributions Section
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
              child: _buildSectionLabel('CONTRIBUTIONS'),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
              child: Column(
                children: widget.members
                    .asMap()
                    .entries
                    .map((e) => _buildContributionRow(context, e.value, e.key))
                    .toList(),
              ),
            ),
          ),

          // Recent Entries Section
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
              child: _buildSectionLabel('RECENT ENTRIES'),
            ),
          ),

          // Entries List
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                final entry = sortedEntries[index];
                if (widget.members.isEmpty) return const SizedBox.shrink();
                final member = widget.members.cast<dynamic>().firstWhere(
                  (m) => m.id == entry.memberId,
                  orElse: () => null,
                );
                if (member == null) return const SizedBox.shrink();
                return _buildEntryCard(context, entry, member, index);
              }, childCount: sortedEntries.length),
            ),
          ),

          const SliverToBoxAdapter(child: Gap(100)),
        ],
      ),
    );
  }

  Widget _buildSectionLabel(String text) {
    return Row(
      children: [
        Container(
          width: 3,
          height: 14,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(2),
            gradient: const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [AppColors.bazarColor, AppColors.primary],
            ),
          ),
        ),
        const Gap(8),
        Text(
          text,
          style: AppTypography.bodySmall.copyWith(
            color: Colors.white.withValues(alpha: 0.4),
            fontWeight: FontWeight.w600,
            letterSpacing: 1.5,
            fontSize: 11,
          ),
        ),
      ],
    );
  }

  Widget _buildGlassFilterChip({
    required String label,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.bazarColor.withValues(alpha: 0.15)
              : Colors.white.withValues(alpha: 0.04),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? AppColors.bazarColor.withValues(alpha: 0.3)
                : Colors.white.withValues(alpha: 0.08),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 14,
              color: isSelected
                  ? AppColors.bazarColor
                  : Colors.white.withValues(alpha: 0.4),
            ),
            const Gap(6),
            Text(
              label,
              style: AppTypography.bodySmall.copyWith(
                color: isSelected
                    ? AppColors.bazarColor
                    : Colors.white.withValues(alpha: 0.5),
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTotalCard(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.lg),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.bazarColor.withValues(alpha: 0.2),
                AppColors.bazarColor.withValues(alpha: 0.08),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
            border: Border.all(
              color: AppColors.bazarColor.withValues(alpha: 0.2),
            ),
          ),
          child: Row(
            children: [
              // Icon with gradient halo
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      AppColors.bazarColor.withValues(alpha: 0.3),
                      AppColors.bazarColor.withValues(alpha: 0.05),
                    ],
                  ),
                  border: Border.all(
                    color: AppColors.bazarColor.withValues(alpha: 0.2),
                  ),
                ),
                child: const Icon(
                  LucideIcons.wallet,
                  color: AppColors.bazarColor,
                  size: 22,
                ),
              ),
              const Gap(AppSpacing.md),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Total Bazar',
                    style: AppTypography.bodySmall.copyWith(
                      color: Colors.white.withValues(alpha: 0.5),
                    ),
                  ),
                  TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0, end: widget.totalBazar),
                    duration: const Duration(milliseconds: 1200),
                    curve: Curves.easeOutCubic,
                    builder: (context, value, _) => Text(
                      '৳${value.toStringAsFixed(0)}',
                      style: AppTypography.headlineLarge.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'JetBrains Mono',
                      ),
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.06),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.08),
                  ),
                ),
                child: Text(
                  '${widget.entries.length} entries',
                  style: AppTypography.bodySmall.copyWith(
                    color: Colors.white.withValues(alpha: 0.5),
                    fontSize: 11,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.05);
  }

  Widget _buildContributionRow(
      BuildContext context, dynamic member, int index) {
    final contribution = widget.bazarByMember[member.id] ?? 0;
    final percentage =
        widget.totalBazar > 0 ? (contribution / widget.totalBazar * 100) : 0;

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
          child: Container(
            padding: const EdgeInsets.all(AppSpacing.sm + 2),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.03),
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.05),
              ),
            ),
            child: Row(
              children: [
                // Avatar with glow ring
                Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.bazarColor.withValues(alpha: 0.3),
                    ),
                  ),
                  child: AppMemberAvatar(
                    name: member.name,
                    size: 32,
                    backgroundColor:
                        AppColors.bazarColor.withValues(alpha: 0.15),
                  ),
                ),
                const Gap(AppSpacing.sm),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        member.name.toString(),
                        style: AppTypography.bodySmall.copyWith(
                          color: Colors.white.withValues(alpha: 0.9),
                        ),
                      ),
                      const SizedBox(height: 4),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(3),
                        child: LinearProgressIndicator(
                          value:
                              (percentage / 100).clamp(0.0, 1.0).toDouble(),
                          minHeight: 4,
                          backgroundColor: Colors.white.withValues(alpha: 0.06),
                          valueColor: const AlwaysStoppedAnimation<Color>(
                            AppColors.bazarColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const Gap(AppSpacing.sm),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '৳${contribution.toStringAsFixed(0)}',
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.bazarColor,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'JetBrains Mono',
                      ),
                    ),
                    Text(
                      '${percentage.toStringAsFixed(0)}%',
                      style: AppTypography.bodySmall.copyWith(
                        color: Colors.white.withValues(alpha: 0.3),
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    ).animate(delay: (500 + 60 * index).ms).fadeIn().slideX(begin: 0.03);
  }

  Widget _buildEntryCard(
    BuildContext context,
    dynamic entry,
    dynamic member,
    int index,
  ) {
    // Check if user can edit this entry (admin or entry owner)
    final isAdmin = ref.watch(isAdminProvider);
    final currentMemberId = ref.watch(currentMemberIdProvider);
    final canEdit = isAdmin || entry.memberId == currentMemberId;

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
          child: Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.03),
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.05),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    // Type icon with gradient halo
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.circular(AppSpacing.radiusSm),
                        gradient: RadialGradient(
                          colors: [
                            AppColors.bazarColor.withValues(alpha: 0.2),
                            AppColors.bazarColor.withValues(alpha: 0.03),
                          ],
                        ),
                        border: Border.all(
                          color:
                              AppColors.bazarColor.withValues(alpha: 0.15),
                        ),
                      ),
                      child: Icon(
                        entry.isItemized
                            ? LucideIcons.list
                            : LucideIcons.receipt,
                        color: AppColors.bazarColor,
                        size: 16,
                      ),
                    ),
                    const Gap(AppSpacing.sm),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            member.name.toString(),
                            style: AppTypography.bodyMedium.copyWith(
                              color: Colors.white.withValues(alpha: 0.9),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            _formatDate(entry.date),
                            style: AppTypography.bodySmall.copyWith(
                              color: Colors.white.withValues(alpha: 0.3),
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Edit button
                    if (canEdit)
                      GestureDetector(
                        onTap: () {
                          HapticService.buttonPress();
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                            builder: (ctx) =>
                                AddBazarSheet(existingEntry: entry),
                          );
                        },
                        child: Container(
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withValues(alpha: 0.04),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.06),
                            ),
                          ),
                          child: Icon(
                            LucideIcons.edit2,
                            size: 13,
                            color: Colors.white.withValues(alpha: 0.4),
                          ),
                        ),
                      ),
                    const Gap(AppSpacing.sm),
                    // Amount
                    Text(
                      '৳${entry.amount.toStringAsFixed(0)}',
                      style: AppTypography.titleMedium.copyWith(
                        color: AppColors.bazarColor,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'JetBrains Mono',
                      ),
                    ),
                  ],
                ),
                if (entry.description != null &&
                    entry.description!.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(
                    entry.description!,
                    style: AppTypography.bodySmall.copyWith(
                      color: Colors.white.withValues(alpha: 0.5),
                    ),
                  ),
                ],
                if (entry.isItemized && entry.items.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 4,
                    runSpacing: 4,
                    children: entry.items.take(3).map<Widget>((item) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.bazarColor.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color:
                                AppColors.bazarColor.withValues(alpha: 0.12),
                          ),
                        ),
                        child: Text(
                          item.name,
                          style: AppTypography.bodySmall.copyWith(
                            color: Colors.white.withValues(alpha: 0.5),
                            fontSize: 10,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  if (entry.items.length > 3)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        '+${entry.items.length - 3} more',
                        style: AppTypography.bodySmall.copyWith(
                          color: Colors.white.withValues(alpha: 0.3),
                          fontSize: 10,
                        ),
                      ),
                    ),
                ],
              ],
            ),
          ),
        ),
      ),
    ).animate(delay: (50 * index).ms).fadeIn().slideX(begin: 0.03);
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final dateOnly = DateTime(date.year, date.month, date.day);

    if (dateOnly == today) return 'Today';
    if (dateOnly == yesterday) return 'Yesterday';

    final diff = today.difference(dateOnly).inDays;
    if (diff < 7) return '$diff days ago';

    return '${date.day}/${date.month}';
  }

  /// Show date range picker dialog
  Future<void> _showDateRangePicker() async {
    HapticService.lightTap();
    final now = DateTime.now();
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(now.year - 1),
      lastDate: now.add(const Duration(days: 1)),
      initialDateRange:
          _dateRange ??
          DateTimeRange(
            start: now.subtract(const Duration(days: 30)),
            end: now,
          ),
      builder: (pickerContext, child) => Theme(
        data: Theme.of(pickerContext).copyWith(
          colorScheme: ColorScheme.dark(
            primary: AppColors.bazarColor,
            surface: const Color(0xFF0D1520),
          ),
        ),
        child: child!,
      ),
    );
    if (picked != null) {
      setState(() => _dateRange = picked);
    }
  }

  /// Show member picker dialog
  void _showMemberPicker() {
    HapticService.lightTap();
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => ClipRRect(
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(AppSpacing.radiusLg),
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFF0D1520).withValues(alpha: 0.95),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(AppSpacing.radiusLg),
              ),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.08),
              ),
            ),
            child: SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Handle bar
                  Center(
                    child: Container(
                      margin: const EdgeInsets.only(top: 12, bottom: 8),
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  ListTile(
                    leading: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            AppColors.bazarColor.withValues(alpha: 0.2),
                            AppColors.bazarColor.withValues(alpha: 0.03),
                          ],
                        ),
                      ),
                      child: const Icon(
                        LucideIcons.users,
                        color: AppColors.bazarColor,
                        size: 18,
                      ),
                    ),
                    title: Text(
                      'All Members',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.9),
                      ),
                    ),
                    selected: _selectedMemberId == null,
                    selectedTileColor:
                        AppColors.bazarColor.withValues(alpha: 0.05),
                    onTap: () {
                      setState(() => _selectedMemberId = null);
                      Navigator.pop(ctx);
                    },
                  ),
                  Divider(
                    color: Colors.white.withValues(alpha: 0.06),
                    height: 1,
                  ),
                  ...widget.members.map(
                    (member) => ListTile(
                      leading: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color:
                                AppColors.bazarColor.withValues(alpha: 0.2),
                          ),
                        ),
                        child: CircleAvatar(
                          radius: 16,
                          backgroundColor:
                              AppColors.bazarColor.withValues(alpha: 0.15),
                          child: Text(
                            member.name.toString()[0].toUpperCase(),
                            style: const TextStyle(
                              color: AppColors.bazarColor,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      title: Text(
                        member.name.toString(),
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.9),
                        ),
                      ),
                      selected: _selectedMemberId == member.id,
                      selectedTileColor:
                          AppColors.bazarColor.withValues(alpha: 0.05),
                      onTap: () {
                        setState(() => _selectedMemberId = member.id);
                        Navigator.pop(ctx);
                      },
                    ),
                  ),
                  const Gap(AppSpacing.lg),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
