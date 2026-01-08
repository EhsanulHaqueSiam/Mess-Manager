import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:mess_manager/core/theme/app_theme.dart';
import 'package:mess_manager/core/services/haptic_service.dart';
import 'package:mess_manager/core/services/toast_service.dart';

/// Pre-styled GetWidget components matching app theme
/// These provide consistent, ready-to-use components with proper theming

// ═══════════════════════════════════════════════════════════════════════════
// BUTTONS
// ═══════════════════════════════════════════════════════════════════════════

/// Primary action button with shimmer animation for CTAs
class GFPrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool isLoading;
  final bool enableShimmer;

  const GFPrimaryButton({
    super.key,
    required this.text,
    this.onPressed,
    this.icon,
    this.isLoading = false,
    this.enableShimmer = false,
  });

  @override
  Widget build(BuildContext context) {
    final button = GFButton(
      onPressed: isLoading
          ? null
          : () {
              HapticService.buttonPress();
              onPressed?.call();
            },
      text: text,
      icon: icon != null ? Icon(icon, color: Colors.white, size: 18) : null,
      color: AppColors.primary,
      textColor: Colors.white,
      shape: GFButtonShape.pills,
      size: GFSize.LARGE,
      blockButton: true,
      child: isLoading
          ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.white,
              ),
            )
          : null,
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
class GFSecondaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final IconData? icon;
  final Color? color;

  const GFSecondaryButton({
    super.key,
    required this.text,
    this.onPressed,
    this.icon,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return GFButton(
      onPressed: () {
        HapticService.lightTap();
        onPressed?.call();
      },
      text: text,
      icon: icon != null
          ? Icon(icon, color: color ?? AppColors.primary, size: 18)
          : null,
      type: GFButtonType.outline,
      color: color ?? AppColors.primary,
      shape: GFButtonShape.pills,
      size: GFSize.MEDIUM,
    );
  }
}

/// Danger/destructive button
class GFDangerButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final IconData? icon;

  const GFDangerButton({
    super.key,
    required this.text,
    this.onPressed,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return GFButton(
      onPressed: () {
        HapticService.warning();
        onPressed?.call();
      },
      text: text,
      icon: icon != null ? Icon(icon, color: Colors.white, size: 18) : null,
      color: AppColors.error,
      textColor: Colors.white,
      shape: GFButtonShape.pills,
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// CARDS
// ═══════════════════════════════════════════════════════════════════════════

/// Themed card with app styling
class GFAppCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final VoidCallback? onTap;
  final Color? color;
  final Color? borderColor;

  const GFAppCard({
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
    final card = GFCard(
      color: color ?? AppColors.cardDark,
      padding: padding ?? const EdgeInsets.all(AppSpacing.md),
      margin: EdgeInsets.zero,
      elevation: 0,
      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      border: Border.all(
        color: borderColor ?? AppColors.borderDark.withValues(alpha: 0.5),
      ),
      content: onTap != null
          ? GestureDetector(
              onTap: () {
                HapticService.lightTap();
                onTap?.call();
              },
              child: child,
            )
          : child,
    );

    if (margin != null) {
      return Padding(padding: margin!, child: card);
    }
    return card;
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// AVATARS
// ═══════════════════════════════════════════════════════════════════════════

/// Member avatar with initials fallback
class GFMemberAvatar extends StatelessWidget {
  final String name;
  final String? imageUrl;
  final double size;
  final Color? backgroundColor;

  const GFMemberAvatar({
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
    return GFAvatar(
      size: size,
      backgroundColor:
          backgroundColor ?? AppColors.primary.withValues(alpha: 0.2),
      backgroundImage: imageUrl != null ? NetworkImage(imageUrl!) : null,
      child: imageUrl == null
          ? Text(
              _initials,
              style: AppTypography.labelMedium.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
              ),
            )
          : null,
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// LIST TILES
// ═══════════════════════════════════════════════════════════════════════════

/// Themed list tile with consistent styling
class GFAppListTile extends StatelessWidget {
  final String title;
  final String? subtitle;
  final IconData? icon;
  final Widget? leading;
  final Widget? trailing;
  final VoidCallback? onTap;
  final Color? iconColor;

  const GFAppListTile({
    super.key,
    required this.title,
    this.subtitle,
    this.icon,
    this.leading,
    this.trailing,
    this.onTap,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return GFListTile(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      color: AppColors.cardDark,
      avatar:
          leading ??
          (icon != null
              ? Container(
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
                    size: 18,
                  ),
                )
              : null),
      title: Text(
        title,
        style: AppTypography.titleSmall.copyWith(
          color: AppColors.textPrimaryDark,
        ),
      ),
      subTitle: subtitle != null
          ? Text(
              subtitle!,
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.textSecondaryDark,
              ),
            )
          : null,
      icon: trailing,
      onTap: onTap != null
          ? () {
              HapticService.lightTap();
              onTap?.call();
            }
          : null,
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// LOADING STATES
// ═══════════════════════════════════════════════════════════════════════════

/// Shimmer loading placeholder
class GFShimmerLoader extends StatelessWidget {
  final double height;
  final double? width;
  final BorderRadius? borderRadius;

  const GFShimmerLoader({
    super.key,
    this.height = 50,
    this.width,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return GFShimmer(
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: AppColors.cardDark,
          borderRadius:
              borderRadius ?? BorderRadius.circular(AppSpacing.radiusMd),
        ),
      ),
    );
  }
}

/// Card shimmer loader
class GFCardShimmer extends StatelessWidget {
  final int count;

  const GFCardShimmer({super.key, this.count = 3});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(
        count,
        (i) => Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.sm),
          child: GFShimmer(
            child: Container(
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.cardDark,
                borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// BADGES & CHIPS
// ═══════════════════════════════════════════════════════════════════════════

/// Status badge
class GFStatusBadge extends StatelessWidget {
  final String text;
  final Color color;
  final bool outlined;

  const GFStatusBadge({
    super.key,
    required this.text,
    this.color = AppColors.primary,
    this.outlined = false,
  });

  factory GFStatusBadge.success(String text) =>
      GFStatusBadge(text: text, color: AppColors.moneyPositive);

  factory GFStatusBadge.warning(String text) =>
      GFStatusBadge(text: text, color: AppColors.warning);

  factory GFStatusBadge.error(String text) =>
      GFStatusBadge(text: text, color: AppColors.error);

  factory GFStatusBadge.info(String text) =>
      GFStatusBadge(text: text, color: AppColors.info);

  @override
  Widget build(BuildContext context) {
    return GFBadge(
      text: text,
      color: outlined ? Colors.transparent : color,
      textColor: outlined ? color : Colors.white,
      size: GFSize.SMALL,
      shape: GFBadgeShape.pills,
      border: outlined ? BorderSide(color: color) : BorderSide.none,
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// TOASTS (Using toastification package)
// ═══════════════════════════════════════════════════════════════════════════

/// Show toast notification (deprecated - use ToastService directly)
void showGFToast(BuildContext context, String message, {bool isError = false}) {
  if (isError) {
    ToastService.error(context, message: message);
  } else {
    ToastService.info(context, message: message);
  }
}

/// Show success toast
void showSuccessToast(BuildContext context, String message) {
  HapticService.success();
  ToastService.success(context, message: message);
}

/// Show error toast
void showErrorToast(BuildContext context, String message) {
  HapticService.error();
  ToastService.error(context, message: message);
}

/// Show info toast
void showInfoToast(BuildContext context, String message) {
  HapticService.lightTap();
  ToastService.info(context, message: message);
}

/// Show warning toast
void showWarningToast(BuildContext context, String message) {
  HapticService.warning();
  ToastService.warning(context, message: message);
}
