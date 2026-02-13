import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:go_router/go_router.dart';

import 'package:mess_manager/core/theme/app_theme.dart';
import 'package:mess_manager/core/services/haptic_service.dart';

// ═══════════════════════════════════════════════════════════════════════════
// APP BREADCRUMB
// Modern breadcrumb navigation using standard Flutter widgets
// ═══════════════════════════════════════════════════════════════════════════

/// Breadcrumb item data
class BreadcrumbItem {
  final String label;
  final String? route;
  final IconData? icon;

  const BreadcrumbItem({required this.label, this.route, this.icon});
}

/// App breadcrumb widget - displays navigation path
class AppBreadcrumb extends StatelessWidget {
  final List<BreadcrumbItem> items;
  final double iconSize;
  final EdgeInsets? padding;

  const AppBreadcrumb({
    super.key,
    required this.items,
    this.iconSize = 14,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (int index = 0; index < items.length; index++) ...[
              _buildBreadcrumbItem(context, items[index], index == items.length - 1),
              if (index < items.length - 1)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
                  child: Icon(
                    LucideIcons.chevronRight,
                    size: 14,
                    color: context.textMuted,
                  ),
                ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildBreadcrumbItem(BuildContext context, BreadcrumbItem item, bool isLast) {
    return GestureDetector(
      onTap: item.route != null && !isLast
          ? () {
              HapticService.lightTap();
              context.go(item.route!);
            }
          : null,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (item.icon != null) ...[
            Icon(
              item.icon,
              size: iconSize,
              color: isLast ? AppColors.primary : context.textMuted,
            ),
            const Gap(4),
          ],
          Text(
            item.label,
            style: TextStyle(
              fontSize: 13,
              color: isLast ? context.textPrimary : context.textMuted,
              fontWeight: isLast ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}

/// Quick factory for common breadcrumb patterns
extension AppBreadcrumbFactory on AppBreadcrumb {
  /// Settings sub-page breadcrumb
  static AppBreadcrumb settings(String currentPage) => AppBreadcrumb(
    items: [
      const BreadcrumbItem(label: 'Home', route: '/', icon: LucideIcons.home),
      const BreadcrumbItem(
        label: 'Settings',
        route: '/settings',
        icon: LucideIcons.settings,
      ),
      BreadcrumbItem(label: currentPage),
    ],
  );

  /// Feature sub-page breadcrumb
  static AppBreadcrumb feature(
    String feature,
    String currentPage,
    String featureRoute,
  ) => AppBreadcrumb(
    items: [
      const BreadcrumbItem(label: 'Home', route: '/', icon: LucideIcons.home),
      BreadcrumbItem(label: feature, route: featureRoute),
      BreadcrumbItem(label: currentPage),
    ],
  );
}
