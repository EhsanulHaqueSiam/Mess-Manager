import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart' hide LucideIcons;
import 'package:velocity_x/velocity_x.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lucide_icons/lucide_icons.dart';

import 'package:mess_manager/core/theme/app_theme.dart';
import 'package:mess_manager/core/services/haptic_service.dart';

// ═══════════════════════════════════════════════════════════════════════════
// SHADCN UI COMPONENT WRAPPERS
// Clean, accessible, modern components following shadcn design patterns
// ═══════════════════════════════════════════════════════════════════════════

/// Modern dialog using shadcn styling
class AppDialog extends StatelessWidget {
  final String title;
  final String? description;
  final Widget? content;
  final List<Widget>? actions;
  final IconData? icon;
  final Color? iconColor;

  const AppDialog({
    super.key,
    required this.title,
    this.description,
    this.content,
    this.actions,
    this.icon,
    this.iconColor,
  });

  /// Show the dialog
  static Future<T?> show<T>({
    required BuildContext context,
    required String title,
    String? description,
    Widget? content,
    List<Widget>? actions,
    IconData? icon,
    Color? iconColor,
    bool barrierDismissible = true,
  }) {
    HapticService.modalOpen();
    return showDialog<T>(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (context) => AppDialog(
        title: title,
        description: description,
        content: content,
        actions: actions,
        icon: icon,
        iconColor: iconColor,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.surfaceDark,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with optional icon
            Row(
              children: [
                if (icon != null) ...[
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.sm),
                    decoration: BoxDecoration(
                      color: (iconColor ?? AppColors.primary).withValues(
                        alpha: 0.1,
                      ),
                      borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                    ),
                    child: Icon(
                      icon,
                      color: iconColor ?? AppColors.primary,
                      size: 20,
                    ),
                  ),
                  12.widthBox,
                ],
                Expanded(
                  child: title.text.xl.bold
                      .color(AppColors.textPrimaryDark)
                      .make(),
                ),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(
                    LucideIcons.x,
                    color: AppColors.textMutedDark,
                    size: 20,
                  ),
                ),
              ],
            ),

            if (description != null) ...[
              8.heightBox,
              description!.text.color(AppColors.textSecondaryDark).make(),
            ],

            if (content != null) ...[16.heightBox, content!],

            if (actions != null && actions!.isNotEmpty) ...[
              20.heightBox,
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: actions!
                    .map(
                      (action) => Padding(
                        padding: const EdgeInsets.only(left: AppSpacing.sm),
                        child: action,
                      ),
                    )
                    .toList(),
              ),
            ],
          ],
        ),
      ),
    ).animate().fadeIn(duration: 200.ms).scale(begin: const Offset(0.95, 0.95));
  }
}

/// Confirmation dialog with confirm/cancel actions
class AppConfirmDialog extends StatelessWidget {
  final String title;
  final String message;
  final String confirmText;
  final String cancelText;
  final Color? confirmColor;
  final IconData? icon;
  final bool isDangerous;

  const AppConfirmDialog({
    super.key,
    required this.title,
    required this.message,
    this.confirmText = 'Confirm',
    this.cancelText = 'Cancel',
    this.confirmColor,
    this.icon,
    this.isDangerous = false,
  });

  /// Show confirmation and return true if user confirms
  static Future<bool> show({
    required BuildContext context,
    required String title,
    required String message,
    String confirmText = 'Confirm',
    String cancelText = 'Cancel',
    Color? confirmColor,
    IconData? icon,
    bool isDangerous = false,
  }) async {
    final result = await AppDialog.show<bool>(
      context: context,
      title: title,
      description: message,
      icon:
          icon ??
          (isDangerous ? LucideIcons.alertTriangle : LucideIcons.helpCircle),
      iconColor: isDangerous ? AppColors.error : null,
      actions: [
        TextButton(
          onPressed: () {
            HapticService.lightTap();
            Navigator.pop(context, false);
          },
          child: cancelText.text.color(AppColors.textSecondaryDark).make(),
        ),
        ElevatedButton(
          onPressed: () {
            HapticService.buttonPress();
            Navigator.pop(context, true);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor:
                confirmColor ??
                (isDangerous ? AppColors.error : AppColors.primary),
          ),
          child: confirmText.text.white.make(),
        ),
      ],
    );
    return result ?? false;
  }

  @override
  Widget build(BuildContext context) => const SizedBox.shrink();
}

/// Modern bottom sheet with shadcn styling
class AppSheet extends StatelessWidget {
  final String? title;
  final Widget child;
  final bool showHandle;
  final EdgeInsets? padding;

  const AppSheet({
    super.key,
    this.title,
    required this.child,
    this.showHandle = true,
    this.padding,
  });

  /// Show the bottom sheet
  static Future<T?> show<T>({
    required BuildContext context,
    String? title,
    required Widget child,
    bool showHandle = true,
    bool isScrollControlled = true,
    EdgeInsets? padding,
  }) {
    HapticService.modalOpen();
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: isScrollControlled,
      backgroundColor: Colors.transparent,
      builder: (context) => AppSheet(
        title: title,
        showHandle: showHandle,
        padding: padding,
        child: child,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? const EdgeInsets.all(AppSpacing.lg),
      decoration: const BoxDecoration(
        color: AppColors.surfaceDark,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppSpacing.radiusLg),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (showHandle)
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: AppSpacing.md),
                decoration: BoxDecoration(
                  color: AppColors.borderDark,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
          if (title != null) ...[
            title!.text.xl2.bold.color(AppColors.textPrimaryDark).make(),
            16.heightBox,
          ],
          child,
        ],
      ),
    );
  }
}

/// Input field with shadcn styling
class AppInput extends StatelessWidget {
  final String? label;
  final String? hint;
  final String? helperText;
  final TextEditingController? controller;
  final bool obscureText;
  final TextInputType? keyboardType;
  final IconData? prefixIcon;
  final Widget? suffix;
  final String? Function(String?)? validator;
  final ValueChanged<String>? onChanged;
  final int maxLines;

  const AppInput({
    super.key,
    this.label,
    this.hint,
    this.helperText,
    this.controller,
    this.obscureText = false,
    this.keyboardType,
    this.prefixIcon,
    this.suffix,
    this.validator,
    this.onChanged,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          label!.text.sm.color(AppColors.textSecondaryDark).make(),
          4.heightBox,
        ],
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          validator: validator,
          onChanged: onChanged,
          maxLines: maxLines,
          style: AppTypography.bodyMedium.copyWith(
            color: AppColors.textPrimaryDark,
          ),
          decoration: InputDecoration(
            hintText: hint,
            helperText: helperText,
            prefixIcon: prefixIcon != null ? Icon(prefixIcon, size: 18) : null,
            suffix: suffix,
            filled: true,
            fillColor: AppColors.cardDark,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
              borderSide: BorderSide(color: AppColors.borderDark),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
              borderSide: BorderSide(color: AppColors.borderDark),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
              borderSide: const BorderSide(color: AppColors.primary, width: 2),
            ),
          ),
        ),
      ],
    );
  }
}

/// Badge component with shadcn styling
class AppBadge extends StatelessWidget {
  final String text;
  final Color? color;
  final Color? textColor;
  final bool outline;

  const AppBadge({
    super.key,
    required this.text,
    this.color,
    this.textColor,
    this.outline = false,
  });

  factory AppBadge.success(String text) => AppBadge(
    text: text,
    color: AppColors.success.withValues(alpha: 0.1),
    textColor: AppColors.success,
  );

  factory AppBadge.warning(String text) => AppBadge(
    text: text,
    color: AppColors.warning.withValues(alpha: 0.1),
    textColor: AppColors.warning,
  );

  factory AppBadge.error(String text) => AppBadge(
    text: text,
    color: AppColors.error.withValues(alpha: 0.1),
    textColor: AppColors.error,
  );

  factory AppBadge.info(String text) => AppBadge(
    text: text,
    color: AppColors.info.withValues(alpha: 0.1),
    textColor: AppColors.info,
  );

  @override
  Widget build(BuildContext context) {
    final bgColor = color ?? AppColors.primary.withValues(alpha: 0.1);
    final fgColor = textColor ?? AppColors.primary;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: outline ? Colors.transparent : bgColor,
        border: outline ? Border.all(color: fgColor) : null,
        borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
      ),
      child: text.text.xs.color(fgColor).bold.make(),
    );
  }
}
