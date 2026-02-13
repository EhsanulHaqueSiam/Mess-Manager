import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lottie/lottie.dart';
import 'package:gap/gap.dart';

import 'package:mess_manager/core/theme/app_theme.dart';
import 'package:mess_manager/core/services/haptic_service.dart';

// ═══════════════════════════════════════════════════════════════════════════
// LOTTIE ANIMATIONS (Success, Error, Loading)
// ═══════════════════════════════════════════════════════════════════════════

class LottieSuccessAnimation extends StatelessWidget {
  final double size;
  final bool repeat;
  final VoidCallback? onComplete;

  const LottieSuccessAnimation({
    super.key,
    this.size = 120,
    this.repeat = false,
    this.onComplete,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Lottie.network(
        'https://lottie.host/2a7e7dc4-8b9a-4c9a-8c1b-1e8e7c8e8e8e/success.json',
        fit: BoxFit.contain,
        repeat: repeat,
        onLoaded: (_) => HapticService.success(),
        errorBuilder: (context, error, stackTrace) => Icon(
          Icons.check_circle,
          size: size * 0.6,
          color: AppColors.success,
        ),
      ),
    ).animate().scale(duration: 300.ms, curve: Curves.elasticOut);
  }
}

class LottieErrorAnimation extends StatelessWidget {
  final double size;
  final bool repeat;

  const LottieErrorAnimation({
    super.key,
    this.size = 120,
    this.repeat = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Lottie.network(
        'https://lottie.host/error-animation-placeholder/error.json',
        fit: BoxFit.contain,
        repeat: repeat,
        onLoaded: (_) => HapticService.warning(),
        errorBuilder: (context, error, stackTrace) =>
            Icon(Icons.error_outline, size: size * 0.6, color: AppColors.error),
      ),
    ).animate().shake(duration: 400.ms);
  }
}

class LottieLoadingAnimation extends StatelessWidget {
  final double size;
  final Color? color;

  const LottieLoadingAnimation({super.key, this.size = 80, this.color});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Lottie.network(
        'https://lottie.host/loading-animation-placeholder/loading.json',
        fit: BoxFit.contain,
        repeat: true,
        errorBuilder: (context, error, stackTrace) =>
            CircularProgressIndicator(
          color: color ?? AppColors.primary,
          strokeWidth: 3,
        ),
      ),
    );
  }
}

class LottieCelebrateAnimation extends StatelessWidget {
  final double size;

  const LottieCelebrateAnimation({super.key, this.size = 200});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Lottie.network(
        'https://lottie.host/confetti-placeholder/confetti.json',
        fit: BoxFit.contain,
        repeat: false,
        errorBuilder: (_, __, ___) => const SizedBox.shrink(),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// EMPTY STATES
// ═══════════════════════════════════════════════════════════════════════════

class EmptyStateWidget extends StatelessWidget {
  final String title;
  final String? subtitle;
  final IconData? icon;
  final String? lottieAsset;
  final String? lottieUrl;
  final Widget? action;

  const EmptyStateWidget({
    super.key,
    required this.title,
    this.subtitle,
    this.icon,
    this.lottieAsset,
    this.lottieUrl,
    this.action,
  });

  factory EmptyStateWidget.noData({
    String title = 'No Data Yet',
    String? subtitle,
    Widget? action,
  }) {
    return EmptyStateWidget(
      title: title,
      subtitle: subtitle ?? 'Start adding items to see them here',
      icon: Icons.inbox_outlined,
      action: action,
    );
  }

  factory EmptyStateWidget.noMeals({Widget? action}) {
    return EmptyStateWidget(
      title: 'No Meals Today',
      subtitle: 'Tap + to add your meal count',
      icon: Icons.restaurant_outlined,
      action: action,
    );
  }

  factory EmptyStateWidget.noBazar({Widget? action}) {
    return EmptyStateWidget(
      title: 'No Bazar Entries',
      subtitle: 'Add your shopping expenses',
      icon: Icons.shopping_bag_outlined,
      action: action,
    );
  }

  factory EmptyStateWidget.error({
    String title = 'Something Went Wrong',
    String? subtitle,
    VoidCallback? onRetry,
  }) {
    return EmptyStateWidget(
      title: title,
      subtitle: subtitle ?? 'Please try again',
      icon: Icons.error_outline,
      action: onRetry != null
          ? TextButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            )
          : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (lottieAsset != null || lottieUrl != null)
              SizedBox(
                height: 150,
                width: 150,
                child: lottieAsset != null
                    ? Lottie.asset(lottieAsset!)
                    : Lottie.network(lottieUrl!),
              )
            else if (icon != null)
              Container(
                padding: const EdgeInsets.all(AppSpacing.lg),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 48, color: AppColors.primary),
              ).animate().scale(duration: 400.ms, curve: Curves.easeOut),
            const Gap(AppSpacing.lg),
            Text(
              title,
              style: AppTypography.headlineSmall.copyWith(
                color: context.textPrimary,
              ),
              textAlign: TextAlign.center,
            ).animate().fadeIn(delay: 100.ms),
            if (subtitle != null) ...[
              const Gap(AppSpacing.sm),
              Text(
                subtitle!,
                style: AppTypography.bodyMedium.copyWith(
                  color: context.textMuted,
                ),
                textAlign: TextAlign.center,
              ).animate().fadeIn(delay: 200.ms),
            ],
            if (action != null) ...[
              const Gap(AppSpacing.lg),
              action!
                  .animate()
                  .fadeIn(delay: 300.ms)
                  .scale(begin: const Offset(0.9, 0.9)),
            ],
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// ANIMATED TEXT (flutter_animate based — replaces animated_text_kit)
// ═══════════════════════════════════════════════════════════════════════════

/// Welcome text with fade-in animation (replaces AnimatedTextKit typewriter)
class AnimatedWelcomeText extends StatelessWidget {
  final String greeting;
  final String name;

  const AnimatedWelcomeText({
    super.key,
    this.greeting = 'Welcome back,',
    required this.name,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          greeting,
          style: AppTypography.bodyMedium.copyWith(
            color: context.textSecondary,
          ),
        ),
        Text(
          name,
          style: AppTypography.headlineLarge.copyWith(
            color: context.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ).animate().fadeIn(duration: 400.ms).slideX(begin: -0.05),
      ],
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// MONEY TEXT
// ═══════════════════════════════════════════════════════════════════════════

class MoneyText extends StatelessWidget {
  final double amount;
  final bool useSign;
  final TextStyle? style;

  const MoneyText({
    super.key,
    required this.amount,
    this.useSign = false,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    final isPositive = amount >= 0;
    final color = useSign
        ? (isPositive ? AppColors.moneyPositive : AppColors.moneyNegative)
        : context.textPrimary;

    final sign = useSign && isPositive ? '+' : '';
    final text = '$sign৳${amount.abs().toStringAsFixed(0)}';

    return Text(
      text,
      style: (style ?? AppTypography.titleMedium).copyWith(
        color: color,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// SHIMMER CTA BUTTON
// ═══════════════════════════════════════════════════════════════════════════

class ShimmerCTAButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool enableShimmer;

  const ShimmerCTAButton({
    super.key,
    required this.text,
    this.onPressed,
    this.icon,
    this.enableShimmer = true,
  });

  @override
  Widget build(BuildContext context) {
    final button = ElevatedButton.icon(
      onPressed: onPressed,
      icon: icon != null ? Icon(icon, size: 18) : const SizedBox.shrink(),
      label: Text(text),
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
        ),
      ),
    );

    if (enableShimmer) {
      return button
          .animate(onPlay: (c) => c.repeat())
          .shimmer(
            duration: 2.seconds,
            color: Colors.white.withValues(alpha: 0.2),
          );
    }

    return button;
  }
}
