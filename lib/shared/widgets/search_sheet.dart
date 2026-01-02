import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:gap/gap.dart';
import 'package:mess_manager/core/theme/app_theme.dart';
import 'package:mess_manager/core/providers/search_provider.dart';

class SearchSheet extends ConsumerStatefulWidget {
  const SearchSheet({super.key});

  @override
  ConsumerState<SearchSheet> createState() => _SearchSheetState();
}

class _SearchSheetState extends ConsumerState<SearchSheet> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _focusNode.requestFocus();
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final results = ref.watch(searchResultsProvider);
    final query = ref.watch(searchQueryProvider);

    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: BoxDecoration(
        color: AppColors.surfaceDark,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(AppSpacing.radiusLg),
        ),
      ),
      child: Column(
        children: [
          // Handle
          const Gap(AppSpacing.sm),
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
          const Gap(AppSpacing.md),

          // Search Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            child: TextField(
              controller: _controller,
              focusNode: _focusNode,
              onChanged: (value) {
                ref.read(searchQueryProvider.notifier).setQuery(value);
              },
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.textPrimaryDark,
              ),
              decoration: InputDecoration(
                hintText: 'Search members, bazar, items...',
                prefixIcon: const Icon(LucideIcons.search, size: 20),
                suffixIcon: query.isNotEmpty
                    ? IconButton(
                        icon: const Icon(LucideIcons.x, size: 18),
                        onPressed: () {
                          _controller.clear();
                          ref.read(searchQueryProvider.notifier).clear();
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
          ),
          const Gap(AppSpacing.md),

          // Results
          Expanded(
            child: query.isEmpty
                ? _buildEmptyState()
                : results.isEmpty
                ? _buildNoResults()
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md,
                    ),
                    itemCount: results.length,
                    itemBuilder: (context, index) =>
                        _buildResultItem(results[index]),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(LucideIcons.search, size: 48, color: AppColors.textMutedDark),
          const Gap(AppSpacing.md),
          Text(
            'Search anything',
            style: AppTypography.titleMedium.copyWith(
              color: AppColors.textSecondaryDark,
            ),
          ),
          Text(
            'Members, bazar items, expenses...',
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.textMutedDark,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoResults() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(LucideIcons.searchX, size: 48, color: AppColors.textMutedDark),
          const Gap(AppSpacing.md),
          Text(
            'No results found',
            style: AppTypography.titleMedium.copyWith(
              color: AppColors.textSecondaryDark,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultItem(SearchResult result) {
    final (icon, color) = switch (result.type) {
      SearchResultType.member => (LucideIcons.user, AppColors.primary),
      SearchResultType.meal => (LucideIcons.utensils, AppColors.mealColor),
      SearchResultType.bazar => (
        LucideIcons.shoppingCart,
        AppColors.bazarColor,
      ),
      SearchResultType.shoppingItem => (
        LucideIcons.listTodo,
        AppColors.accentWarm,
      ),
    };

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
          Container(
            padding: const EdgeInsets.all(AppSpacing.sm),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
            ),
            child: Icon(icon, color: color, size: 18),
          ),
          const Gap(AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  result.title,
                  style: AppTypography.titleSmall.copyWith(
                    color: AppColors.textPrimaryDark,
                  ),
                ),
                Text(
                  result.subtitle,
                  style: AppTypography.labelSmall.copyWith(
                    color: AppColors.textSecondaryDark,
                  ),
                ),
              ],
            ),
          ),
          if (result.amount != null)
            Text(
              '৳${result.amount!.toStringAsFixed(0)}',
              style: AppTypography.labelMedium.copyWith(
                color: color,
                fontWeight: FontWeight.w600,
              ),
            ),
        ],
      ),
    );
  }
}
