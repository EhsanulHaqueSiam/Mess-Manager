import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gap/gap.dart';
import 'package:lucide_icons/lucide_icons.dart';

import 'package:mess_manager/core/theme/app_theme.dart';
import 'package:mess_manager/core/services/haptic_service.dart';
import 'package:mess_manager/core/services/toast_service.dart';

// ═══════════════════════════════════════════════════════════════════════════
// GLASS CARD — True glassmorphism with refraction
// ═══════════════════════════════════════════════════════════════════════════

/// Premium glass card with backdrop blur, inner refraction border, and tinted shadow.
/// Use for hero sections, balance cards, and elevated content.
class GlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double blur;
  final double opacity;
  final VoidCallback? onTap;

  const GlassCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.blur = 16,
    this.opacity = 0.05,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Widget card = RepaintBoundary(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
          child: Container(
          padding: padding ?? const EdgeInsets.all(AppSpacing.lg),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
            color: Colors.white.withValues(alpha: opacity),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.08),
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF0A0F14).withValues(alpha: 0.4),
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          foregroundDecoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
            border: Border(
              top: BorderSide(
                color: Colors.white.withValues(alpha: 0.1),
                width: 1,
              ),
            ),
          ),
            child: child,
          ),
        ),
      ),
    );

    if (onTap != null) {
      card = _CardTappable(onTap: onTap!, child: card);
    }

    if (margin != null) {
      return Padding(padding: margin!, child: card);
    }
    return card;
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// BUTTONS
// ═══════════════════════════════════════════════════════════════════════════

/// Primary action button with optional shimmer for CTAs
class AppPrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool isLoading;
  final bool enableShimmer;

  const AppPrimaryButton({
    super.key,
    required this.text,
    this.onPressed,
    this.icon,
    this.isLoading = false,
    this.enableShimmer = false,
  });

  @override
  Widget build(BuildContext context) {
    final button = SizedBox(
      width: double.infinity,
      child: FilledButton(
        onPressed: isLoading
            ? null
            : () {
                HapticService.buttonPress();
                onPressed?.call();
              },
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.md,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          ),
          textStyle: AppTypography.labelLarge,
        ),
        child: isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (icon != null) ...[
                    Icon(icon, size: 18),
                    const Gap(8),
                  ],
                  Text(text),
                ],
              ),
      ),
    );

    if (enableShimmer && !isLoading) {
      return button
          .animate(onPlay: (c) => c.repeat())
          .shimmer(
            duration: 2.seconds,
            color: Colors.white.withValues(alpha: 0.3),
          );
    }

    return button;
  }
}

/// Secondary/outline button
class AppSecondaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final IconData? icon;
  final Color? color;

  const AppSecondaryButton({
    super.key,
    required this.text,
    this.onPressed,
    this.icon,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final c = color ?? AppColors.primary;
    return OutlinedButton(
      onPressed: () {
        HapticService.lightTap();
        onPressed?.call();
      },
      style: OutlinedButton.styleFrom(
        foregroundColor: c,
        side: BorderSide(color: c),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm + 2,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        ),
        textStyle: AppTypography.labelMedium,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 16, color: c),
            const Gap(6),
          ],
          Text(text),
        ],
      ),
    );
  }
}

/// Danger/destructive button
class AppDangerButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final IconData? icon;

  const AppDangerButton({
    super.key,
    required this.text,
    this.onPressed,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: () {
        HapticService.warning();
        onPressed?.call();
      },
      style: FilledButton.styleFrom(
        backgroundColor: AppColors.error,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm + 2,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 16),
            const Gap(6),
          ],
          Text(text),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// CARDS
// ═══════════════════════════════════════════════════════════════════════════

/// Premium themed card with glass refraction inner border — theme-aware
class AppCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final VoidCallback? onTap;
  final Color? color;
  final Color? borderColor;

  const AppCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.onTap,
    this.color,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    final bg = color ?? context.cardColor;
    final border = borderColor ?? context.borderColor.withValues(alpha: 0.3);

    final cardWidget = Container(
      padding: padding ?? const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        border: Border.all(color: border),
        boxShadow: context.isDark
            ? [
                BoxShadow(
                  color: const Color(0xFF0A0F14).withValues(alpha: 0.5),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
                BoxShadow(
                  color: Colors.white.withValues(alpha: 0.02),
                  blurRadius: 0,
                  spreadRadius: 0.5,
                ),
              ]
            : AppSpacing.shadowSm,
      ),
      foregroundDecoration: context.isDark
          ? BoxDecoration(
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
              border: Border(
                top: BorderSide(
                  color: Colors.white.withValues(alpha: 0.06),
                  width: 1,
                ),
              ),
            )
          : null,
      child: child,
    );

    if (onTap != null) {
      final tappable = _CardTappable(onTap: onTap!, child: cardWidget);
      if (margin != null) {
        return Padding(padding: margin!, child: tappable);
      }
      return tappable;
    }

    if (margin != null) {
      return Padding(padding: margin!, child: cardWidget);
    }
    return cardWidget;
  }
}

/// Tappable card wrapper with scale + haptic feedback
class _CardTappable extends StatefulWidget {
  final VoidCallback onTap;
  final Widget child;

  const _CardTappable({required this.onTap, required this.child});

  @override
  State<_CardTappable> createState() => _CardTappableState();
}

class _CardTappableState extends State<_CardTappable>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      duration: const Duration(milliseconds: 80),
      reverseDuration: const Duration(milliseconds: 120),
      vsync: this,
    );
    _scale = Tween(begin: 1.0, end: 0.975).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _ctrl.forward(),
      onTapUp: (_) {
        _ctrl.reverse();
        HapticService.lightTap();
        widget.onTap();
      },
      onTapCancel: () => _ctrl.reverse(),
      child: ScaleTransition(scale: _scale, child: widget.child),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// AVATARS
// ═══════════════════════════════════════════════════════════════════════════

/// Member avatar with initials fallback
class AppMemberAvatar extends StatelessWidget {
  final String name;
  final String? imageUrl;
  final double size;
  final Color? backgroundColor;

  const AppMemberAvatar({
    super.key,
    required this.name,
    this.imageUrl,
    this.size = 40,
    this.backgroundColor,
  });

  String get _initials {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name.isNotEmpty ? name[0].toUpperCase() : '?';
  }

  @override
  Widget build(BuildContext context) {
    final bgColor =
        backgroundColor ?? AppColors.primary.withValues(alpha: 0.2);
    final radius = size * 0.28;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(radius),
        image: imageUrl != null
            ? DecorationImage(
                image: NetworkImage(imageUrl!), fit: BoxFit.cover)
            : null,
      ),
      child: imageUrl == null
          ? Center(
              child: Text(
                _initials,
                style: AppTypography.labelMedium.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: size * 0.35,
                ),
              ),
            )
          : null,
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// BADGES
// ═══════════════════════════════════════════════════════════════════════════

/// Status badge with pill shape
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
        borderRadius: BorderRadius.circular(AppSpacing.radiusXs),
      ),
      child: Text(
        text,
        style: AppTypography.labelSmall.copyWith(
          color: fgColor,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// DIALOGS
// ═══════════════════════════════════════════════════════════════════════════

/// Modern dialog — theme-aware
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
      backgroundColor: context.surfaceColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                if (icon != null) ...[
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.sm),
                    decoration: BoxDecoration(
                      color: (iconColor ?? AppColors.primary)
                          .withValues(alpha: 0.1),
                      borderRadius:
                          BorderRadius.circular(AppSpacing.radiusSm),
                    ),
                    child: Icon(
                      icon,
                      color: iconColor ?? AppColors.primary,
                      size: 20,
                    ),
                  ),
                  const Gap(12),
                ],
                Expanded(
                  child: Text(
                    title,
                    style: AppTypography.titleLarge.copyWith(
                      color: context.textPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Icon(
                    LucideIcons.x,
                    color: context.textMuted,
                    size: 20,
                  ),
                ),
              ],
            ),
            if (description != null) ...[
              const Gap(8),
              Text(
                description!,
                style: AppTypography.bodyMedium.copyWith(
                  color: context.textSecondary,
                ),
              ),
            ],
            if (content != null) ...[const Gap(16), content!],
            if (actions != null && actions!.isNotEmpty) ...[
              const Gap(20),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: actions!
                    .map((action) => Padding(
                          padding:
                              const EdgeInsets.only(left: AppSpacing.sm),
                          child: action,
                        ))
                    .toList(),
              ),
            ],
          ],
        ),
      ),
    ).animate().fadeIn(duration: 200.ms).scale(
          begin: const Offset(0.95, 0.95),
        );
  }
}

/// Confirmation dialog with confirm/cancel
class AppConfirmDialog {
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
      icon: icon ??
          (isDangerous
              ? LucideIcons.alertTriangle
              : LucideIcons.helpCircle),
      iconColor: isDangerous ? AppColors.error : null,
      actions: [
        TextButton(
          onPressed: () {
            HapticService.lightTap();
            Navigator.pop(context, false);
          },
          child: Text(
            cancelText,
            style: TextStyle(color: context.textSecondary),
          ),
        ),
        FilledButton(
          onPressed: () {
            HapticService.buttonPress();
            Navigator.pop(context, true);
          },
          style: FilledButton.styleFrom(
            backgroundColor: confirmColor ??
                (isDangerous ? AppColors.error : AppColors.primary),
          ),
          child: Text(confirmText),
        ),
      ],
    );
    return result ?? false;
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// BOTTOM SHEET
// ═══════════════════════════════════════════════════════════════════════════

/// Modern bottom sheet — theme-aware
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
      decoration: BoxDecoration(
        color: context.isDark ? const Color(0xFF0D1520) : context.surfaceColor,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppSpacing.radiusXl),
        ),
        border: context.isDark
            ? const Border(
                top: BorderSide(
                  color: Color(0x0FFFFFFF),
                  width: 1,
                ),
              )
            : null,
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0A0F14).withValues(alpha: 0.5),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (showHandle)
            Center(
              child: Container(
                width: 48,
                height: 4,
                margin: const EdgeInsets.only(bottom: AppSpacing.md),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.white.withValues(alpha: 0.1),
                      Colors.white.withValues(alpha: 0.2),
                      Colors.white.withValues(alpha: 0.1),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
          if (title != null) ...[
            Text(
              title!,
              style: AppTypography.headlineSmall.copyWith(
                color: context.textPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Gap(16),
          ],
          child,
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// INPUT
// ═══════════════════════════════════════════════════════════════════════════

/// Input field with focus glow — theme-aware
class AppInput extends StatefulWidget {
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
  State<AppInput> createState() => _AppInputState();
}

class _AppInputState extends State<AppInput> {
  bool _focused = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null) ...[
          Text(
            widget.label!,
            style: AppTypography.labelMedium.copyWith(
              color: _focused ? AppColors.primary : context.textSecondary,
            ),
          ),
          const Gap(4),
        ],
        AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
            boxShadow: _focused
                ? [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.15),
                      blurRadius: 8,
                      spreadRadius: -2,
                    ),
                  ]
                : [],
          ),
          child: Focus(
            onFocusChange: (hasFocus) => setState(() => _focused = hasFocus),
            child: TextFormField(
              controller: widget.controller,
              obscureText: widget.obscureText,
              keyboardType: widget.keyboardType,
              validator: widget.validator,
              onChanged: widget.onChanged,
              maxLines: widget.maxLines,
              style: AppTypography.bodyMedium.copyWith(
                color: context.textPrimary,
              ),
              decoration: InputDecoration(
                hintText: widget.hint,
                helperText: widget.helperText,
                prefixIcon: widget.prefixIcon != null
                    ? Icon(widget.prefixIcon, size: 18)
                    : null,
                suffix: widget.suffix,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// SHIMMER / LOADING
// ═══════════════════════════════════════════════════════════════════════════

/// Shimmer loading placeholder — theme-aware
class AppShimmerLoader extends StatelessWidget {
  final double height;
  final double? width;
  final BorderRadius? borderRadius;

  const AppShimmerLoader({
    super.key,
    this.height = 50,
    this.width,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: context.cardColor,
        borderRadius:
            borderRadius ?? BorderRadius.circular(AppSpacing.radiusMd),
      ),
    )
        .animate(onPlay: (c) => c.repeat())
        .shimmer(duration: 1200.ms, color: context.borderColor);
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// TOASTS (Using toastification — these are kept as convenience wrappers)
// ═══════════════════════════════════════════════════════════════════════════

void showSuccessToast(BuildContext context, String message) {
  HapticService.success();
  ToastService.success(context, message: message);
}

void showErrorToast(BuildContext context, String message) {
  HapticService.error();
  ToastService.error(context, message: message);
}

void showInfoToast(BuildContext context, String message) {
  HapticService.lightTap();
  ToastService.info(context, message: message);
}

void showWarningToast(BuildContext context, String message) {
  HapticService.warning();
  ToastService.warning(context, message: message);
}
