import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

import 'package:mess_manager/core/theme/app_theme.dart';
import 'package:mess_manager/core/router/app_router.dart';
import 'package:mess_manager/core/services/haptic_service.dart';
import 'package:mess_manager/features/mess_search/providers/mess_search_provider.dart';
import 'package:mess_manager/features/mess_search/widgets/mess_ad_card.dart';
import 'package:mess_manager/features/mess_search/widgets/create_mess_ad_sheet.dart';

/// Screen for browsing mess advertisements.
class MessSearchScreen extends ConsumerStatefulWidget {
  const MessSearchScreen({super.key});

  @override
  ConsumerState<MessSearchScreen> createState() => _MessSearchScreenState();
}

class _MessSearchScreenState extends ConsumerState<MessSearchScreen> {
  final _searchController = TextEditingController();
  final _scrollController = ScrollController();

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ads = ref.watch(filteredMessAdsProvider);
    final filter = ref.watch(
      messSearchProvider.select((s) => s.filter),
    );

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            _buildHeader(context),

            // Search bar
            _buildSearchBar(),
            const Gap(AppSpacing.sm),

            // Filter chips
            _buildFilterBar(filter),
            const Gap(AppSpacing.sm),

            // Results count
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
              child: Row(
                children: [
                  Container(
                    width: 3,
                    height: 14,
                    decoration: BoxDecoration(
                      color: AppColors.accent,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const Gap(AppSpacing.sm),
                  Text(
                    '${ads.length} ${ads.length == 1 ? 'listing' : 'listings'}',
                    style: AppTypography.labelMedium.copyWith(
                      color: AppColors.textSecondaryDark,
                    ),
                  ),
                ],
              ),
            ),
            const Gap(AppSpacing.sm),

            // Ad cards list
            Expanded(
              child: ads.isEmpty
                  ? _buildEmptyState()
                  : ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.md,
                      ),
                      itemCount: ads.length,
                      itemBuilder: (context, index) {
                        final ad = ads[index];
                        return MessAdCard(
                          ad: ad,
                          onTap: () => context.push(
                            '${AppRoutes.messSearch}/${ad.id}',
                          ),
                        )
                            .animate()
                            .fadeIn(
                              duration: 300.ms,
                              delay: (index * 60).ms,
                            )
                            .slideY(
                              begin: 0.03,
                              end: 0,
                              duration: 300.ms,
                              delay: (index * 60).ms,
                              curve: Curves.easeOut,
                            );
                      },
                    ),
            ),
          ],
        ),
      ),

      // FAB to post new ad
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => CreateMessAdSheet.show(context),
        backgroundColor: AppColors.accent,
        foregroundColor: AppColors.backgroundDark,
        icon: const Icon(LucideIcons.plus, size: 18),
        label: Text(
          'Post ad',
          style: AppTypography.labelLarge.copyWith(
            color: AppColors.backgroundDark,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.md, AppSpacing.sm, AppSpacing.md, AppSpacing.sm,
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              HapticService.lightTap();
              context.pop();
            },
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: AppSpacing.glassTile(radius: AppSpacing.radiusSm),
              child: const Icon(
                LucideIcons.arrowLeft,
                color: AppColors.textPrimaryDark,
                size: 20,
              ),
            ),
          ),
          const Gap(AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Find a mess',
                  style: AppTypography.headlineLarge.copyWith(
                    color: AppColors.textPrimaryDark,
                  ),
                ),
                Text(
                  'Browse available rooms near you',
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textMutedDark,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      child: Container(
        decoration: AppSpacing.glassTile(radius: AppSpacing.radiusMd),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: 2,
        ),
        child: Row(
          children: [
            const Icon(
              LucideIcons.search,
              size: 18,
              color: AppColors.textMutedDark,
            ),
            const Gap(AppSpacing.sm),
            Expanded(
              child: TextField(
                controller: _searchController,
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.textPrimaryDark,
                ),
                decoration: InputDecoration(
                  hintText: 'Search by name or location...',
                  hintStyle: AppTypography.bodyMedium.copyWith(
                    color: AppColors.textMutedDark,
                  ),
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: const EdgeInsets.symmetric(vertical: 10),
                ),
                onChanged: (q) {
                  ref.read(messSearchProvider.notifier).setQuery(q);
                },
              ),
            ),
            if (_searchController.text.isNotEmpty)
              GestureDetector(
                onTap: () {
                  _searchController.clear();
                  ref.read(messSearchProvider.notifier).setQuery('');
                },
                child: const Icon(
                  LucideIcons.x,
                  size: 16,
                  color: AppColors.textMutedDark,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterBar(MessSearchFilter active) {
    final filters = [
      (MessSearchFilter.all, 'All', LucideIcons.layoutGrid),
      (MessSearchFilter.oneMember, '1 seat', LucideIcons.user),
      (MessSearchFilter.twoMembers, '2 seats', LucideIcons.users),
      (MessSearchFilter.threeOrMore, '3+ seats', LucideIcons.users),
    ];

    return SizedBox(
      height: 38,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
        separatorBuilder: (_, _) => const Gap(AppSpacing.sm),
        itemCount: filters.length,
        itemBuilder: (context, index) {
          final (filter, label, icon) = filters[index];
          final selected = active == filter;

          return GestureDetector(
            onTap: () {
              HapticService.lightTap();
              ref.read(messSearchProvider.notifier).setFilter(filter);
            },
            child: AnimatedContainer(
              duration: 200.ms,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                color: selected
                    ? AppColors.accent.withValues(alpha: 0.15)
                    : Colors.white.withValues(alpha: 0.05),
                border: Border.all(
                  color: selected
                      ? AppColors.accent.withValues(alpha: 0.4)
                      : Colors.white.withValues(alpha: 0.07),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    icon,
                    size: 14,
                    color: selected
                        ? AppColors.accent
                        : AppColors.textSecondaryDark,
                  ),
                  const Gap(6),
                  Text(
                    label,
                    style: AppTypography.labelMedium.copyWith(
                      color: selected
                          ? AppColors.accent
                          : AppColors.textSecondaryDark,
                      fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            LucideIcons.searchX,
            size: 48,
            color: AppColors.textMutedDark,
          ),
          const Gap(AppSpacing.md),
          Text(
            'No listings found',
            style: AppTypography.titleMedium.copyWith(
              color: AppColors.textSecondaryDark,
            ),
          ),
          const Gap(AppSpacing.xs),
          Text(
            'Try adjusting your search or filters',
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.textMutedDark,
            ),
          ),
        ],
      ),
    );
  }
}
