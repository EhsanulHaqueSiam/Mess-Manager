import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:gap/gap.dart';
import 'package:mess_manager/core/theme/app_theme.dart';
import 'package:mess_manager/core/providers/smart_suggestions_provider.dart';

class SmartSuggestionCard extends ConsumerWidget {
  final VoidCallback? onAddMeal;
  final VoidCallback? onAddBazar;
  final VoidCallback? onCheckList;

  const SmartSuggestionCard({
    super.key,
    this.onAddMeal,
    this.onAddBazar,
    this.onCheckList,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final suggestion = ref.watch(smartSuggestionProvider);

    if (suggestion == null) return const SizedBox.shrink();

    final (color, icon) = switch (suggestion.type) {
      SuggestionType.bazarReminder => (
        AppColors.bazarColor,
        LucideIcons.shoppingCart,
      ),
      SuggestionType.noMealsToday => (
        AppColors.mealColor,
        LucideIcons.utensils,
      ),
      SuggestionType.weekendShopping => (
        AppColors.accentWarm,
        LucideIcons.calendarCheck,
      ),
      SuggestionType.monthlyReminder => (AppColors.info, LucideIcons.calendar),
      _ => (AppColors.primary, LucideIcons.sparkles),
    };

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.sm),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const Gap(AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  suggestion.title,
                  style: AppTypography.titleSmall.copyWith(
                    color: color,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  suggestion.message,
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textSecondaryDark,
                  ),
                ),
              ],
            ),
          ),
          if (suggestion.actionLabel != null)
            TextButton(
              onPressed: () => _handleAction(suggestion.type),
              style: TextButton.styleFrom(
                foregroundColor: color,
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm,
                  vertical: AppSpacing.xs,
                ),
              ),
              child: Text(suggestion.actionLabel!),
            ),
        ],
      ),
    );
  }

  void _handleAction(SuggestionType type) {
    switch (type) {
      case SuggestionType.bazarReminder:
        onAddBazar?.call();
        break;
      case SuggestionType.noMealsToday:
        onAddMeal?.call();
        break;
      case SuggestionType.weekendShopping:
        onCheckList?.call();
        break;
      default:
        break;
    }
  }
}

/// Expense timer showing days since last bazar
class ExpenseTimerWidget extends ConsumerWidget {
  const ExpenseTimerWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final daysSinceBazar = ref.watch(daysSinceLastBazarProvider);

    if (daysSinceBazar == null) {
      return const SizedBox.shrink();
    }

    final color = daysSinceBazar >= 5
        ? AppColors.error
        : daysSinceBazar >= 3
        ? AppColors.warning
        : AppColors.success;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(LucideIcons.timer, size: 12, color: color),
          const Gap(4),
          Text(
            '${daysSinceBazar}d ago',
            style: AppTypography.labelSmall.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
