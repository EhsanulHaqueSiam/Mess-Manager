import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:mess_manager/core/theme/app_theme.dart';

/// Toast Service - Centralized toast notifications using toastification
class ToastService {
  static const Duration _defaultDuration = Duration(seconds: 3);

  /// Show success toast
  static void success(
    BuildContext context, {
    required String message,
    String? title,
    Duration? duration,
  }) {
    toastification.show(
      context: context,
      type: ToastificationType.success,
      style: ToastificationStyle.flatColored,
      title: title != null ? Text(title) : null,
      description: Text(message),
      icon: const Icon(LucideIcons.checkCircle2),
      autoCloseDuration: duration ?? _defaultDuration,
      alignment: Alignment.bottomCenter,
      primaryColor: AppColors.success,
      backgroundColor: AppColors.cardDark,
      foregroundColor: AppColors.textPrimaryDark,
      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.2),
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ],
    );
  }

  /// Show error toast
  static void error(
    BuildContext context, {
    required String message,
    String? title,
    Duration? duration,
  }) {
    toastification.show(
      context: context,
      type: ToastificationType.error,
      style: ToastificationStyle.flatColored,
      title: title != null ? Text(title) : null,
      description: Text(message),
      icon: const Icon(LucideIcons.xCircle),
      autoCloseDuration: duration ?? _defaultDuration,
      alignment: Alignment.bottomCenter,
      primaryColor: AppColors.error,
      backgroundColor: AppColors.cardDark,
      foregroundColor: AppColors.textPrimaryDark,
      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
    );
  }

  /// Show warning toast
  static void warning(
    BuildContext context, {
    required String message,
    String? title,
    Duration? duration,
  }) {
    toastification.show(
      context: context,
      type: ToastificationType.warning,
      style: ToastificationStyle.flatColored,
      title: title != null ? Text(title) : null,
      description: Text(message),
      icon: const Icon(LucideIcons.alertTriangle),
      autoCloseDuration: duration ?? _defaultDuration,
      alignment: Alignment.bottomCenter,
      primaryColor: AppColors.warning,
      backgroundColor: AppColors.cardDark,
      foregroundColor: AppColors.textPrimaryDark,
      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
    );
  }

  /// Show info toast
  static void info(
    BuildContext context, {
    required String message,
    String? title,
    Duration? duration,
  }) {
    toastification.show(
      context: context,
      type: ToastificationType.info,
      style: ToastificationStyle.flatColored,
      title: title != null ? Text(title) : null,
      description: Text(message),
      icon: const Icon(LucideIcons.info),
      autoCloseDuration: duration ?? _defaultDuration,
      alignment: Alignment.bottomCenter,
      primaryColor: AppColors.info,
      backgroundColor: AppColors.cardDark,
      foregroundColor: AppColors.textPrimaryDark,
      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
    );
  }

  /// Show loading toast (with progress indicator)
  static ToastificationItem loading(
    BuildContext context, {
    required String message,
    String? title,
  }) {
    return toastification.show(
      context: context,
      type: ToastificationType.info,
      style: ToastificationStyle.flatColored,
      title: title != null ? Text(title) : null,
      description: Text(message),
      icon: const SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          color: AppColors.primary,
        ),
      ),
      autoCloseDuration: null, // Manual dismiss
      alignment: Alignment.bottomCenter,
      primaryColor: AppColors.primary,
      backgroundColor: AppColors.cardDark,
      foregroundColor: AppColors.textPrimaryDark,
      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
    );
  }

  /// Dismiss a specific toast
  static void dismiss(ToastificationItem item) {
    toastification.dismiss(item);
  }

  /// Dismiss all toasts
  static void dismissAll() {
    toastification.dismissAll();
  }
}
