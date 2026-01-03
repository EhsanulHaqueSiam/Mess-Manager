import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:gap/gap.dart';
import 'package:mess_manager/core/theme/app_theme.dart';
import 'package:mess_manager/core/providers/members_provider.dart';
import 'package:mess_manager/features/bazar/providers/bazar_provider.dart';
import 'package:mess_manager/features/bazar/providers/bazar_list_provider.dart';
import 'package:mess_manager/features/bazar/widgets/add_bazar_sheet.dart';
import 'package:mess_manager/features/bazar/widgets/bazar_list_tab.dart';

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

  @override
  Widget build(BuildContext context) {
    final entries = ref.watch(bazarEntriesProvider);
    final members = ref.watch(membersProvider);
    final totalBazar = ref.watch(totalBazarProvider);
    final bazarByMember = ref.watch(bazarByMemberProvider);
    final pendingItemsCount = ref.watch(pendingItemsCountProvider);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Icon(
              LucideIcons.shoppingCart,
              color: AppColors.bazarColor,
              size: 22,
            ),
            const Gap(AppSpacing.sm),
            const Text('Bazar'),
          ],
        ),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            const Tab(
              icon: Icon(LucideIcons.receipt, size: 18),
              text: 'Entries',
            ),
            Tab(
              icon: Badge(
                isLabelVisible: pendingItemsCount > 0,
                label: Text(pendingItemsCount.toString()),
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
          // Entries Tab
          _buildEntriesTab(entries, members, totalBazar, bazarByMember),

          // Shopping List Tab
          const BazarListTab(),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddEntrySheet(context),
        icon: const Icon(LucideIcons.plus, size: 20),
        label: const Text('Add Entry'),
        backgroundColor: AppColors.bazarColor,
      ),
    );
  }

  void _showAddEntrySheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const AddBazarSheet(),
    );
  }

  Widget _buildEntriesTab(
    List entries,
    List members,
    double totalBazar,
    Map<String, double> bazarByMember,
  ) {
    // Sort entries by date (newest first)
    final sortedEntries = [...entries]
      ..sort((a, b) => b.date.compareTo(a.date));

    return CustomScrollView(
      slivers: [
        // Summary Card
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Total Bazar Card
                Container(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.bazarColor,
                        AppColors.bazarColor.withValues(alpha: 0.7),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.bazarColor.withValues(alpha: 0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(AppSpacing.sm),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(
                            AppSpacing.radiusSm,
                          ),
                        ),
                        child: const Icon(
                          LucideIcons.wallet,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                      const Gap(AppSpacing.md),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Total Bazar',
                            style: AppTypography.labelMedium.copyWith(
                              color: Colors.white.withValues(alpha: 0.8),
                            ),
                          ),
                          Text(
                            '৳${totalBazar.toStringAsFixed(0)}',
                            style: AppTypography.displaySmall.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      Text(
                        '${entries.length} entries',
                        style: AppTypography.labelSmall.copyWith(
                          color: Colors.white.withValues(alpha: 0.7),
                        ),
                      ),
                    ],
                  ),
                ).animate().fadeIn().slideY(begin: 0.1),
                const Gap(AppSpacing.lg),

                // Contribution per member
                Text(
                  'Contributions',
                  style: AppTypography.headlineSmall.copyWith(
                    color: AppColors.textPrimaryDark,
                  ),
                ),
                const Gap(AppSpacing.sm),
                ...members.map((member) {
                  final contribution = bazarByMember[member.id] ?? 0;
                  final percentage = totalBazar > 0
                      ? (contribution / totalBazar * 100)
                      : 0;
                  return Container(
                    margin: const EdgeInsets.only(bottom: AppSpacing.sm),
                    padding: const EdgeInsets.all(AppSpacing.sm),
                    decoration: BoxDecoration(
                      color: AppColors.cardDark,
                      borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 16,
                          backgroundColor: AppColors.bazarColor.withValues(
                            alpha: 0.2,
                          ),
                          child: Text(
                            member.name[0],
                            style: AppTypography.labelMedium.copyWith(
                              color: AppColors.bazarColor,
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
                              const Gap(2),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(2),
                                child: LinearProgressIndicator(
                                  value: percentage / 100,
                                  backgroundColor: AppColors.borderDark,
                                  valueColor: const AlwaysStoppedAnimation(
                                    AppColors.bazarColor,
                                  ),
                                  minHeight: 4,
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
                              style: AppTypography.labelMedium.copyWith(
                                color: AppColors.bazarColor,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              '${percentage.toStringAsFixed(0)}%',
                              style: AppTypography.labelSmall.copyWith(
                                color: AppColors.textMutedDark,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                }),
                const Gap(AppSpacing.lg),

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

        // Entries List
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              final entry = sortedEntries[index];
              final member = members.firstWhere(
                (m) => m.id == entry.memberId,
                orElse: () => members.first,
              );
              return _buildEntryCard(entry, member);
            }, childCount: sortedEntries.length),
          ),
        ),

        const SliverToBoxAdapter(child: Gap(AppSpacing.xxl * 2)),
      ],
    );
  }

  Widget _buildEntryCard(dynamic entry, dynamic member) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.cardDark,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        border: Border.all(color: AppColors.borderDark.withValues(alpha: 0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
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
                      _formatDate(entry.date),
                      style: AppTypography.labelSmall.copyWith(
                        color: AppColors.textMutedDark,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                '৳${entry.amount.toStringAsFixed(0)}',
                style: AppTypography.titleMedium.copyWith(
                  color: AppColors.bazarColor,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          if (entry.description != null && entry.description!.isNotEmpty) ...[
            const Gap(AppSpacing.sm),
            Text(
              entry.description!,
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.textSecondaryDark,
              ),
            ),
          ],
          if (entry.isItemized && entry.items.isNotEmpty) ...[
            const Gap(AppSpacing.sm),
            Wrap(
              spacing: AppSpacing.xs,
              runSpacing: AppSpacing.xs,
              children: entry.items.take(3).map<Widget>((item) {
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.sm,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.borderDark.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
                  ),
                  child: Text(
                    item.name,
                    style: AppTypography.labelSmall.copyWith(
                      color: AppColors.textSecondaryDark,
                    ),
                  ),
                );
              }).toList(),
            ),
            if (entry.items.length > 3)
              Padding(
                padding: const EdgeInsets.only(top: AppSpacing.xs),
                child: Text(
                  '+${entry.items.length - 3} more',
                  style: AppTypography.labelSmall.copyWith(
                    color: AppColors.textMutedDark,
                  ),
                ),
              ),
          ],
        ],
      ),
    );
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
}
