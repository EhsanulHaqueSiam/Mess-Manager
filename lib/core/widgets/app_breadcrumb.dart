import 'package:flutter/material.dart';
import 'package:flutter_breadcrumb/flutter_breadcrumb.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:go_router/go_router.dart';

import 'package:mess_manager/core/theme/app_theme.dart';
import 'package:mess_manager/core/services/haptic_service.dart';

// ═══════════════════════════════════════════════════════════════════════════
// APP BREADCRUMB
// Modern breadcrumb navigation using flutter_breadcrumb
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
      child: BreadCrumb(
        items: items.asMap().entries.map((entry) {
          final index = entry.key;
          final item = entry.value;
          final isLast = index == items.length - 1;

          return BreadCrumbItem(
            content: GestureDetector(
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
                      color: isLast
                          ? AppColors.primary
                          : AppColors.textMutedDark,
                    ),
                    4.widthBox,
                  ],
                  item.label.text.sm
                      .color(
                        isLast
                            ? AppColors.textPrimaryDark
                            : AppColors.textMutedDark,
                      )
                      .fontWeight(isLast ? FontWeight.w600 : FontWeight.normal)
                      .make(),
                ],
              ),
            ),
          );
        }).toList(),
        divider: Icon(
          LucideIcons.chevronRight,
          size: 14,
          color: AppColors.textMutedDark,
        ).pSymmetric(h: AppSpacing.xs),
        overflow: ScrollableOverflow(
          keepLastDivider: false,
          reverse: false,
          direction: Axis.horizontal,
        ),
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
