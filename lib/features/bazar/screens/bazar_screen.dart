import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:gap/gap.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:getwidget/getwidget.dart';

import 'package:mess_manager/core/theme/app_theme.dart';
import 'package:mess_manager/core/providers/members_provider.dart';
import 'package:mess_manager/core/providers/role_provider.dart';
import 'package:mess_manager/core/services/haptic_service.dart';
import 'package:mess_manager/core/services/export_service.dart';
import 'package:mess_manager/core/widgets/gf_components.dart';
import 'package:mess_manager/core/widgets/animated_widgets.dart';
import 'package:mess_manager/features/bazar/providers/bazar_provider.dart';
import 'package:mess_manager/features/bazar/providers/bazar_list_provider.dart';
import 'package:mess_manager/features/bazar/widgets/add_bazar_sheet.dart';
import 'package:mess_manager/features/bazar/widgets/bazar_list_tab.dart';
import 'package:mess_manager/features/settlement/providers/settlement_provider.dart';
import 'package:mess_manager/features/balance/providers/balance_provider.dart';
import 'package:mess_manager/features/bazar/widgets/budget_card.dart';

/// Bazar Screen - Uses GetWidget + VelocityX + flutter_animate
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
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  /// Show export options sheet (CSV/Excel)
  void _showExportOptions(BuildContext context) {
    HapticService.lightTap();
    final members = ref.read(membersProvider);
    final balances = ref.read(currentMonthBalancesProvider);
    final mealRate = ref.read(mealRateProvider);
    final totalBazar = ref.read(totalBazarProvider);
    final now = DateTime.now();

    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surfaceDark,
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(
                LucideIcons.fileSpreadsheet,
                color: AppColors.success,
              ),
              title: const Text('Export as Excel (XLSX)'),
              subtitle: const Text('Detailed balance sheet'),
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
              leading: const Icon(LucideIcons.fileText, color: AppColors.info),
              title: const Text('Export as CSV'),
              subtitle: const Text('Simple comma-separated'),
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
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final entries = ref.watch(bazarEntriesProvider);
    final members = ref.watch(membersProvider);
    final totalBazar = ref.watch(totalBazarProvider);
    final bazarByMember = ref.watch(bazarByMemberProvider);
    final pendingItemsCount = ref.watch(pendingItemsCountProvider);

    return Scaffold(
      appBar: AppBar(
        title: [
          const Icon(
            LucideIcons.shoppingCart,
            color: AppColors.bazarColor,
            size: 22,
          ),
          const Gap(AppSpacing.sm),
          'Bazar'.text.make(),
        ].hStack(),
        actions: [
          GFIconButton(
            icon: const Icon(LucideIcons.download, size: 20),
            type: GFButtonType.transparent,
            onPressed: () => _showExportOptions(context),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            const Tab(
              icon: Icon(LucideIcons.receipt, size: 18),
              text: 'Entries',
            ),
            Tab(
              icon: GFBadge(
                text: pendingItemsCount > 0 ? pendingItemsCount.toString() : '',
                size: GFSize.SMALL,
                color: pendingItemsCount > 0
                    ? AppColors.warning
                    : Colors.transparent,
                child: const Icon(LucideIcons.listTodo, size: 18),
              ),
              text: 'Shopping List',
            ),
          ],
          labelColor: AppColors.bazarColor,
          unselectedLabelColor: AppColors.textSecondaryDark,
          indicatorColor: AppColors.bazarColor,
        ),
      ),
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
      floatingActionButton: _buildShimmerFAB(context),
    );
  }

  /// Shimmer FAB with animation for CTA
  Widget _buildShimmerFAB(BuildContext context) {
    return FloatingActionButton.extended(
          onPressed: () {
            HapticService.buttonPress();
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              builder: (context) => const AddBazarSheet(),
            );
          },
          icon: const Icon(LucideIcons.plus, size: 20),
          label: const Text('Add Entry'),
          backgroundColor: AppColors.bazarColor,
        )
        .animate(onPlay: (c) => c.repeat())
        .shimmer(
          duration: 2.seconds,
          color: Colors.white.withValues(alpha: 0.2),
        );
  }
}

/// Entries Tab - Uses VelocityX and GetWidget
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

    return CustomScrollView(
      slivers: [
        // Budget Card
        const SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.only(top: AppSpacing.md),
            child: BudgetCard(),
          ),
        ),

        // Search Bar
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: _searchController,
                  onChanged: (value) => setState(() => _searchQuery = value),
                  decoration: InputDecoration(
                    hintText: 'Search entries...',
                    prefixIcon: const Icon(LucideIcons.search, size: 20),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(LucideIcons.x, size: 18),
                            onPressed: () {
                              _searchController.clear();
                              setState(() => _searchQuery = '');
                            },
                          )
                        : null,
                    filled: true,
                    fillColor: AppColors.cardDark,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const Gap(AppSpacing.sm),
                // Filter chips
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      // Date range filter
                      FilterChip(
                        label: Text(
                          _dateRange != null
                              ? '${_dateRange!.start.day}/${_dateRange!.start.month} - ${_dateRange!.end.day}/${_dateRange!.end.month}'
                              : 'Date Range',
                        ),
                        selected: _dateRange != null,
                        onSelected: (_) => _showDateRangePicker(),
                        avatar: const Icon(LucideIcons.calendar, size: 16),
                        selectedColor: AppColors.bazarColor.withValues(
                          alpha: 0.2,
                        ),
                        checkmarkColor: AppColors.bazarColor,
                      ),
                      const Gap(AppSpacing.sm),
                      // Member filter
                      FilterChip(
                        label: Text(
                          _selectedMemberId != null
                              ? widget.members
                                    .firstWhere(
                                      (m) => m.id == _selectedMemberId,
                                      orElse: () => widget.members.first,
                                    )
                                    .name
                                    .toString()
                              : 'All Members',
                        ),
                        selected: _selectedMemberId != null,
                        onSelected: (_) => _showMemberPicker(),
                        avatar: const Icon(LucideIcons.user, size: 16),
                        selectedColor: AppColors.bazarColor.withValues(
                          alpha: 0.2,
                        ),
                        checkmarkColor: AppColors.bazarColor,
                      ),
                      if (_hasActiveFilters) ...[
                        const Gap(AppSpacing.sm),
                        ActionChip(
                          label: const Text('Clear All'),
                          avatar: const Icon(LucideIcons.x, size: 16),
                          onPressed: _clearAllFilters,
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        // Summary Section
        SliverToBoxAdapter(
          child: VStack([
            _buildTotalCard(),
            16.heightBox,
            'Contributions'.text.xl.bold
                .color(AppColors.textPrimaryDark)
                .make(),
            8.heightBox,
            ...widget.members.map((member) => _buildContributionRow(member)),
            16.heightBox,
            'Recent Entries'.text.xl.bold
                .color(AppColors.textPrimaryDark)
                .make(),
          ]).p16(),
        ),

        // Entries List
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              final entry = sortedEntries[index];
              final member = widget.members.firstWhere(
                (m) => m.id == entry.memberId,
                orElse: () => widget.members.first,
              );
              return _buildEntryCard(entry, member, index);
            }, childCount: sortedEntries.length),
          ),
        ),

        const SliverToBoxAdapter(child: Gap(100)),
      ],
    );
  }

  Widget _buildTotalCard() {
    return GFCard(
      padding: const EdgeInsets.all(AppSpacing.lg),
      margin: EdgeInsets.zero,
      elevation: 4,
      gradient: LinearGradient(
        colors: [
          AppColors.bazarColor,
          AppColors.bazarColor.withValues(alpha: 0.7),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      content: Row(
        children: [
          GFAvatar(
            backgroundColor: Colors.white.withValues(alpha: 0.2),
            child: const Icon(LucideIcons.wallet, color: Colors.white),
          ),
          const Gap(AppSpacing.md),
          VStack(crossAlignment: CrossAxisAlignment.start, [
            'Total Bazar'.text.sm.white.make(),
            '৳${widget.totalBazar.toStringAsFixed(0)}'.text.xl3.white.bold
                .make(),
          ]),
          const Spacer(),
          '${widget.entries.length} entries'.text.xs.white.make(),
        ],
      ),
    ).animate().fadeIn().slideY(begin: 0.1);
  }

  Widget _buildContributionRow(dynamic member) {
    final contribution = widget.bazarByMember[member.id] ?? 0;
    final percentage = widget.totalBazar > 0
        ? (contribution / widget.totalBazar * 100)
        : 0;

    return GFAppCard(
      padding: const EdgeInsets.all(AppSpacing.sm),
      child: Row(
        children: [
          GFMemberAvatar(
            name: member.name,
            size: 32,
            backgroundColor: AppColors.bazarColor.withValues(alpha: 0.2),
          ),
          const Gap(AppSpacing.sm),
          Expanded(
            child: VStack(crossAlignment: CrossAxisAlignment.start, [
              member.name
                  .toString()
                  .text
                  .sm
                  .color(AppColors.textPrimaryDark)
                  .make(),
              2.heightBox,
              GFProgressBar(
                percentage: percentage / 100,
                lineHeight: 4,
                backgroundColor: AppColors.borderDark,
                progressBarColor: AppColors.bazarColor,
              ),
            ]),
          ),
          const Gap(AppSpacing.sm),
          VStack(crossAlignment: CrossAxisAlignment.end, [
            '৳${contribution.toStringAsFixed(0)}'.text.sm
                .color(AppColors.bazarColor)
                .bold
                .make(),
            '${percentage.toStringAsFixed(0)}%'.text.xs
                .color(AppColors.textMutedDark)
                .make(),
          ]),
        ],
      ),
    ).pOnly(bottom: AppSpacing.sm);
  }

  Widget _buildEntryCard(dynamic entry, dynamic member, int index) {
    // Check if user can edit this entry (admin or entry owner)
    final isAdmin = ref.watch(isAdminProvider);
    final currentMemberId = ref.watch(currentMemberIdProvider);
    final canEdit = isAdmin || entry.memberId == currentMemberId;

    return GFAppCard(
          child: VStack(crossAlignment: CrossAxisAlignment.start, [
            HStack([
              Container(
                padding: const EdgeInsets.all(AppSpacing.sm),
                decoration: BoxDecoration(
                  color: AppColors.bazarColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                ),
                child: Icon(
                  entry.isItemized ? LucideIcons.list : LucideIcons.receipt,
                  color: AppColors.bazarColor,
                  size: 18,
                ),
              ),
              const Gap(AppSpacing.sm),
              VStack(crossAlignment: CrossAxisAlignment.start, [
                member.name
                    .toString()
                    .text
                    .color(AppColors.textPrimaryDark)
                    .bold
                    .make(),
                _formatDate(
                  entry.date,
                ).text.xs.color(AppColors.textMutedDark).make(),
              ]).expand(),
              // Edit button (for admin or entry owner)
              if (canEdit)
                IconButton(
                  icon: const Icon(
                    LucideIcons.edit2,
                    size: 16,
                    color: AppColors.textMutedDark,
                  ),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  onPressed: () {
                    HapticService.buttonPress();
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (ctx) => AddBazarSheet(existingEntry: entry),
                    );
                  },
                ),
              const Gap(AppSpacing.sm),
              '৳${entry.amount.toStringAsFixed(0)}'.text.lg
                  .color(AppColors.bazarColor)
                  .bold
                  .make(),
            ]),
            if (entry.description != null && entry.description!.isNotEmpty) ...[
              8.heightBox,
              entry.description!.text.sm
                  .color(AppColors.textSecondaryDark)
                  .make(),
            ],
            if (entry.isItemized && entry.items.isNotEmpty) ...[
              8.heightBox,
              Wrap(
                spacing: 4,
                runSpacing: 4,
                children: entry.items.take(3).map<Widget>((item) {
                  return GFBadge(
                    text: item.name,
                    color: AppColors.borderDark.withValues(alpha: 0.5),
                    textColor: AppColors.textSecondaryDark,
                    size: GFSize.SMALL,
                    shape: GFBadgeShape.pills,
                  );
                }).toList(),
              ),
              if (entry.items.length > 3)
                '+${entry.items.length - 3} more'.text.xs
                    .color(AppColors.textMutedDark)
                    .make()
                    .pOnly(top: 4),
            ],
          ]),
        )
        .pOnly(bottom: AppSpacing.sm)
        .animate(delay: (50 * index).ms)
        .fadeIn()
        .slideX(begin: 0.03);
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
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.dark(
            primary: AppColors.bazarColor,
            surface: AppColors.surfaceDark,
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
      backgroundColor: AppColors.surfaceDark,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(
                LucideIcons.users,
                color: AppColors.bazarColor,
              ),
              title: const Text('All Members'),
              selected: _selectedMemberId == null,
              onTap: () {
                setState(() => _selectedMemberId = null);
                Navigator.pop(ctx);
              },
            ),
            const Divider(),
            ...widget.members.map(
              (member) => ListTile(
                leading: CircleAvatar(
                  backgroundColor: AppColors.bazarColor.withValues(alpha: 0.2),
                  child: Text(
                    member.name.toString()[0].toUpperCase(),
                    style: const TextStyle(color: AppColors.bazarColor),
                  ),
                ),
                title: Text(member.name.toString()),
                selected: _selectedMemberId == member.id,
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
    );
  }
}
