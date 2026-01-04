import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:gap/gap.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:getwidget/getwidget.dart';

import 'package:mess_manager/core/theme/app_theme.dart';
import 'package:mess_manager/core/providers/members_provider.dart';
import 'package:mess_manager/core/services/haptic_service.dart';
import 'package:mess_manager/core/widgets/gf_components.dart';
import 'package:mess_manager/core/widgets/animated_widgets.dart';
import 'package:mess_manager/features/bazar/providers/bazar_provider.dart';
import 'package:mess_manager/features/bazar/providers/bazar_list_provider.dart';
import 'package:mess_manager/features/bazar/widgets/add_bazar_sheet.dart';
import 'package:mess_manager/features/bazar/widgets/bazar_list_tab.dart';

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
class _EntriesTab extends StatelessWidget {
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
  Widget build(BuildContext context) {
    if (entries.isEmpty) {
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

    final sortedEntries = [...entries]
      ..sort((a, b) => b.date.compareTo(a.date));

    return CustomScrollView(
      slivers: [
        // Summary Section
        SliverToBoxAdapter(
          child: VStack([
            _buildTotalCard(),
            16.heightBox,
            'Contributions'.text.xl.bold
                .color(AppColors.textPrimaryDark)
                .make(),
            8.heightBox,
            ...members.map((member) => _buildContributionRow(member)),
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
              final member = members.firstWhere(
                (m) => m.id == entry.memberId,
                orElse: () => members.first,
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
            '৳${totalBazar.toStringAsFixed(0)}'.text.xl3.white.bold.make(),
          ]),
          const Spacer(),
          '${entries.length} entries'.text.xs.white.make(),
        ],
      ),
    ).animate().fadeIn().slideY(begin: 0.1);
  }

  Widget _buildContributionRow(dynamic member) {
    final contribution = bazarByMember[member.id] ?? 0;
    final percentage = totalBazar > 0 ? (contribution / totalBazar * 100) : 0;

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
}
