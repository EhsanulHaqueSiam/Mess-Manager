/// App Sheet - Consistent Themed Bottom Sheets
///
/// Provides a unified bottom sheet wrapper that ensures:
/// - Dark mode consistency across all sheets
/// - Consistent styling and animations
/// - Accessibility support
/// - Easy migration from raw showModalBottomSheet
library;

import 'package:flutter/material.dart';
import 'package:mess_manager/core/theme/app_theme.dart';

/// Consistent bottom sheet wrapper for the app
class AppSheet extends StatelessWidget {
  final Widget child;
  final String? title;
  final bool showHandle;
  final bool useSafeArea;
  final EdgeInsets padding;
  final double? maxHeight;

  const AppSheet({
    super.key,
    required this.child,
    this.title,
    this.showHandle = true,
    this.useSafeArea = true,
    this.padding = const EdgeInsets.fromLTRB(16, 0, 16, 16),
    this.maxHeight,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    Widget content = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (showHandle) _buildHandle(isDark),
        if (title != null) _buildTitle(context, isDark),
        Flexible(
          child: Padding(padding: padding, child: child),
        ),
      ],
    );

    if (useSafeArea) {
      content = SafeArea(child: content);
    }

    if (maxHeight != null) {
      content = ConstrainedBox(
        constraints: BoxConstraints(maxHeight: maxHeight!),
        child: content,
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: content,
    );
  }

  Widget _buildHandle(bool isDark) {
    return Center(
      child: Container(
        margin: const EdgeInsets.only(top: 12, bottom: 8),
        width: 40,
        height: 4,
        decoration: BoxDecoration(
          color: isDark
              ? Colors.white.withValues(alpha: 0.3)
              : Colors.grey.withValues(alpha: 0.4),
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );
  }

  Widget _buildTitle(BuildContext context, bool isDark) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      child: Text(
        title!,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: isDark ? AppColors.textPrimaryDark : Colors.grey.shade900,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}

/// Show a consistent bottom sheet
Future<T?> showAppSheet<T>({
  required BuildContext context,
  required Widget child,
  String? title,
  bool showHandle = true,
  bool useSafeArea = true,
  bool isScrollControlled = true,
  bool enableDrag = true,
  bool isDismissible = true,
  double? maxHeight,
  EdgeInsets padding = const EdgeInsets.fromLTRB(16, 0, 16, 16),
}) {
  return showModalBottomSheet<T>(
    context: context,
    isScrollControlled: isScrollControlled,
    enableDrag: enableDrag,
    isDismissible: isDismissible,
    backgroundColor: Colors.transparent,
    builder: (context) => AppSheet(
      title: title,
      showHandle: showHandle,
      useSafeArea: useSafeArea,
      maxHeight: maxHeight,
      padding: padding,
      child: child,
    ),
  );
}

/// Show a fullscreen sheet (e.g., for complex forms)
Future<T?> showFullScreenSheet<T>({
  required BuildContext context,
  required Widget child,
  String? title,
}) {
  return showAppSheet(
    context: context,
    child: child,
    title: title,
    maxHeight: MediaQuery.of(context).size.height * 0.9,
    isScrollControlled: true,
  );
}

/// Show a confirmation sheet with actions
Future<bool?> showConfirmSheet({
  required BuildContext context,
  required String title,
  required String message,
  String confirmText = 'Confirm',
  String cancelText = 'Cancel',
  Color? confirmColor,
  bool isDanger = false,
}) async {
  final isDark = Theme.of(context).brightness == Brightness.dark;

  final result = await showAppSheet<bool>(
    context: context,
    title: title,
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          message,
          style: TextStyle(
            color: isDark ? AppColors.textSecondaryDark : Colors.grey.shade600,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 24),
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text(cancelText),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context, true),
                style: ElevatedButton.styleFrom(
                  backgroundColor: isDanger
                      ? AppColors.error
                      : (confirmColor ?? AppColors.primary),
                ),
                child: Text(confirmText),
              ),
            ),
          ],
        ),
      ],
    ),
  );

  return result;
}

/// Show an action sheet with multiple options
Future<T?> showActionSheet<T>({
  required BuildContext context,
  required List<ActionSheetItem<T>> actions,
  String? title,
}) {
  return showAppSheet<T>(
    context: context,
    title: title,
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (final action in actions)
          ListTile(
            leading: action.icon != null ? Icon(action.icon) : null,
            title: Text(action.label),
            subtitle: action.subtitle != null ? Text(action.subtitle!) : null,
            onTap: () => Navigator.pop(context, action.value),
            tileColor: Colors.transparent,
          ),
        const SizedBox(height: 8),
      ],
    ),
  );
}

/// Action sheet item
class ActionSheetItem<T> {
  final T value;
  final String label;
  final String? subtitle;
  final IconData? icon;

  const ActionSheetItem({
    required this.value,
    required this.label,
    this.subtitle,
    this.icon,
  });
}
