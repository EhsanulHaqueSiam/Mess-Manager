import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import 'package:mess_manager/core/services/haptic_service.dart';
import 'package:mess_manager/core/theme/app_theme.dart';

/// Premium Tappable Widget with micro-interactions
/// Provides scale, opacity, and haptic feedback on tap
class TappableScale extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final double scaleFactor;
  final bool enableHaptic;

  const TappableScale({
    super.key,
    required this.child,
    this.onTap,
    this.onLongPress,
    this.scaleFactor = 0.97,
    this.enableHaptic = true,
  });

  @override
  State<TappableScale> createState() => _TappableScaleState();
}

class _TappableScaleState extends State<TappableScale>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 100),
      reverseDuration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: widget.scaleFactor,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    if (!_isPressed) {
      _isPressed = true;
      _controller.forward();
      if (widget.enableHaptic) {
        HapticService.bouncyTap();
      }
    }
  }

  void _handleTapUp(TapUpDetails details) {
    if (_isPressed) {
      _isPressed = false;
      _controller.reverse();
    }
  }

  void _handleTapCancel() {
    if (_isPressed) {
      _isPressed = false;
      _controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: widget.onTap != null ? _handleTapDown : null,
      onTapUp: widget.onTap != null ? _handleTapUp : null,
      onTapCancel: widget.onTap != null ? _handleTapCancel : null,
      onTap: () {
        widget.onTap?.call();
      },
      onLongPressStart: widget.onLongPress != null
          ? (_) {
              if (widget.enableHaptic) HapticService.longPressStart();
            }
          : null,
      onLongPress: widget.onLongPress,
      onLongPressEnd: widget.onLongPress != null
          ? (_) {
              if (widget.enableHaptic) HapticService.longPressEnd();
            }
          : null,
      child: ScaleTransition(scale: _scaleAnimation, child: widget.child),
    );
  }
}

/// Bouncy Button with micro-animation
class BouncyButton extends StatefulWidget {
  final Widget child;
  final VoidCallback? onPressed;
  final Color? backgroundColor;
  final EdgeInsets? padding;
  final BorderRadius? borderRadius;

  const BouncyButton({
    super.key,
    required this.child,
    this.onPressed,
    this.backgroundColor,
    this.padding,
    this.borderRadius,
  });

  @override
  State<BouncyButton> createState() => _BouncyButtonState();
}

class _BouncyButtonState extends State<BouncyButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _animation = Tween<double>(
      begin: 1.0,
      end: 0.92,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {
        _controller.forward();
        HapticService.bouncyTap();
      },
      onTapUp: (_) {
        _controller.reverse();
        widget.onPressed?.call();
      },
      onTapCancel: () => _controller.reverse(),
      child: ScaleTransition(
        scale: _animation,
        child: Container(
          padding:
              widget.padding ??
              const EdgeInsets.symmetric(
                horizontal: AppSpacing.lg,
                vertical: AppSpacing.md,
              ),
          decoration: BoxDecoration(
            color: widget.backgroundColor ?? AppColors.primary,
            borderRadius:
                widget.borderRadius ??
                BorderRadius.circular(AppSpacing.radiusSm),
            boxShadow: [
              BoxShadow(
                color: (widget.backgroundColor ?? AppColors.primary).withValues(
                  alpha: 0.3,
                ),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: widget.child,
        ),
      ),
    );
  }
}

/// Glowing Icon Button with pulse animation
class GlowingIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final Color? color;
  final double size;
  final bool showGlow;

  const GlowingIconButton({
    super.key,
    required this.icon,
    this.onPressed,
    this.color,
    this.size = 24,
    this.showGlow = true,
  });

  @override
  Widget build(BuildContext context) {
    final iconColor = color ?? AppColors.primary;

    return TappableScale(
      onTap: () {
        HapticService.bouncyTap();
        onPressed?.call();
      },
      child:
          Container(
                padding: const EdgeInsets.all(AppSpacing.sm),
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                  boxShadow: showGlow
                      ? [
                          BoxShadow(
                            color: iconColor.withValues(alpha: 0.3),
                            blurRadius: 12,
                            spreadRadius: -2,
                          ),
                        ]
                      : null,
                ),
                child: Icon(icon, color: iconColor, size: size),
              )
              .animate(onPlay: (c) => c.repeat(reverse: true))
              .shimmer(
                delay: 2.seconds,
                duration: 1.5.seconds,
                color: iconColor.withValues(alpha: 0.1),
              ),
    );
  }
}

/// Animated Toggle Switch with haptic feedback
class HapticSwitch extends StatelessWidget {
  final bool value;
  final ValueChanged<bool>? onChanged;
  final Color? activeColor;

  const HapticSwitch({
    super.key,
    required this.value,
    this.onChanged,
    this.activeColor,
  });

  @override
  Widget build(BuildContext context) {
    return Switch(
      value: value,
      onChanged: (v) {
        HapticService.toggle();
        onChanged?.call(v);
      },
      activeTrackColor: (activeColor ?? AppColors.primary).withValues(
        alpha: 0.5,
      ),
      activeThumbColor: activeColor ?? AppColors.primary,
    );
  }
}

/// Animated List Item with slide and fade entrance
class AnimatedListItem extends StatelessWidget {
  final Widget child;
  final int index;
  final Duration delay;

  const AnimatedListItem({
    super.key,
    required this.child,
    this.index = 0,
    this.delay = const Duration(milliseconds: 50),
  });

  @override
  Widget build(BuildContext context) {
    return child
        .animate(delay: Duration(milliseconds: delay.inMilliseconds * index))
        .fadeIn(duration: 300.ms, curve: Curves.easeOut)
        .slideY(
          begin: 0.1,
          end: 0,
          duration: 300.ms,
          curve: Curves.easeOutCubic,
        );
  }
}

/// Shimmer Loading Placeholder
class ShimmerLoading extends StatelessWidget {
  final double width;
  final double height;
  final BorderRadius? borderRadius;

  const ShimmerLoading({
    super.key,
    this.width = double.infinity,
    this.height = 60,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: AppColors.cardDark,
            borderRadius:
                borderRadius ?? BorderRadius.circular(AppSpacing.radiusSm),
          ),
        )
        .animate(onPlay: (c) => c.repeat())
        .shimmer(
          duration: 1200.ms,
          color: AppColors.borderDark.withValues(alpha: 0.3),
        );
  }
}

/// Pulse Animation Wrapper
class PulseAnimation extends StatelessWidget {
  final Widget child;
  final bool animate;

  const PulseAnimation({super.key, required this.child, this.animate = true});

  @override
  Widget build(BuildContext context) {
    if (!animate) return child;
    return child
        .animate(onPlay: (c) => c.repeat(reverse: true))
        .scale(
          begin: const Offset(1.0, 1.0),
          end: const Offset(1.05, 1.05),
          duration: 800.ms,
          curve: Curves.easeInOut,
        );
  }
}

/// Success Checkmark Animation
class SuccessCheckmark extends StatelessWidget {
  final double size;
  final Color? color;

  const SuccessCheckmark({super.key, this.size = 48, this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: (color ?? AppColors.success).withValues(alpha: 0.2),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.check_rounded,
            color: color ?? AppColors.success,
            size: size * 0.6,
          ),
        )
        .animate()
        .scale(
          begin: const Offset(0.0, 0.0),
          end: const Offset(1.0, 1.0),
          duration: 400.ms,
          curve: Curves.elasticOut,
        )
        .then()
        .shake(hz: 2, duration: 300.ms);
  }
}

/// Floating Action Button with entrance animation
class AnimatedFAB extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final String? tooltip;

  const AnimatedFAB({
    super.key,
    required this.icon,
    this.onPressed,
    this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
          onPressed: () {
            HapticService.bouncyTap();
            onPressed?.call();
          },
          tooltip: tooltip,
          child: Icon(icon),
        )
        .animate()
        .scale(
          begin: const Offset(0.0, 0.0),
          end: const Offset(1.0, 1.0),
          duration: 300.ms,
          curve: Curves.elasticOut,
        )
        .fadeIn();
  }
}

/// Micro-interaction extension for any widget
extension MicroInteractionExtension on Widget {
  /// Add tap-to-scale micro-interaction
  Widget withTapScale({VoidCallback? onTap, double scale = 0.97}) {
    return TappableScale(onTap: onTap, scaleFactor: scale, child: this);
  }

  /// Add entrance animation
  Widget withEntrance({
    int index = 0,
    Duration delay = const Duration(milliseconds: 50),
  }) {
    return AnimatedListItem(index: index, delay: delay, child: this);
  }

  /// Add pulse animation
  Widget withPulse() {
    return PulseAnimation(child: this);
  }

  /// Add shimmer effect
  Widget withShimmer() {
    return animate(onPlay: (c) => c.repeat()).shimmer(
      duration: 1200.ms,
      color: AppColors.borderDark.withValues(alpha: 0.3),
    );
  }
}
