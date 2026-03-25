import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:go_router/go_router.dart';
import 'package:gap/gap.dart';

import 'package:mess_manager/core/theme/app_theme.dart';
import 'package:mess_manager/core/router/app_router.dart';
import 'package:mess_manager/core/services/auth_service.dart';
import 'package:mess_manager/core/services/haptic_service.dart';
import 'package:mess_manager/core/widgets/app_components.dart';
import 'package:mess_manager/features/auth/providers/auth_provider.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _isGoogleLoading = false;
  bool _obscurePassword = true;
  String? _errorMessage;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // ── Cosmic Aurora Background ──
          const _CosmicBackground(),

          // ── Content ──
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  const Gap(48),

                  // ── Animated Logo ──
                  _buildCosmicLogo(),
                  const Gap(12),

                  // ── Title ──
                  Text(
                    'Mess Manager',
                    style: AppTypography.displayMedium.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.5,
                    ),
                  )
                      .animate()
                      .fadeIn(delay: 400.ms, duration: 600.ms)
                      .slideY(begin: 0.15),
                  const Gap(4),
                  Text(
                    'Manage your shared living expenses',
                    style: AppTypography.bodyMedium.copyWith(
                      color: Colors.white.withValues(alpha: 0.5),
                      letterSpacing: 0.3,
                    ),
                  ).animate().fadeIn(delay: 550.ms, duration: 500.ms),
                  const Gap(32),

                  // ── Glass Form Card ──
                  _buildGlassFormCard(),

                  const Gap(40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ────────────────────────────────────────────────────────────────
  // COSMIC LOGO
  // ────────────────────────────────────────────────────────────────

  Widget _buildCosmicLogo() {
    return Container(
      width: 88,
      height: 88,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: AppColors.gradientPrimary,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.5),
            blurRadius: 32,
            spreadRadius: 4,
          ),
          BoxShadow(
            color: AppColors.accentAlt.withValues(alpha: 0.2),
            blurRadius: 48,
            spreadRadius: 8,
          ),
        ],
      ),
      child: const Icon(LucideIcons.home, color: Colors.white, size: 40),
    )
        .animate()
        .scale(
          delay: 100.ms,
          duration: 600.ms,
          begin: const Offset(0.5, 0.5),
          curve: Curves.elasticOut,
        )
        .then()
        .animate(onPlay: (c) => c.repeat(reverse: true))
        .scaleXY(
          begin: 1.0,
          end: 1.04,
          duration: 3.seconds,
          curve: Curves.easeInOut,
        );
  }

  // ────────────────────────────────────────────────────────────────
  // GLASS FORM CARD
  // ────────────────────────────────────────────────────────────────

  Widget _buildGlassFormCard() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: AppSpacing.accentCard(accent: AppColors.primary, radius: 24),
          child: Column(
            children: [
              // ── Google Sign In ──
              _buildGoogleSignInButton()
                  .animate()
                  .fadeIn(delay: 600.ms)
                  .slideY(begin: 0.1),
              const Gap(20),

              // ── Divider ──
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 1,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.transparent,
                            Colors.white.withValues(alpha: 0.2),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    child: Text(
                      'or continue with email',
                      style: AppTypography.labelSmall.copyWith(
                        color: Colors.white.withValues(alpha: 0.4),
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      height: 1,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.white.withValues(alpha: 0.2),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ).animate().fadeIn(delay: 700.ms),
              const Gap(20),

              // ── Error ──
              if (_errorMessage != null) ...[
                _buildErrorCard(),
                const Gap(12),
              ],

              // ── Form ──
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    _buildGlassInput(
                      controller: _emailController,
                      label: 'Email',
                      icon: LucideIcons.mail,
                      keyboardType: TextInputType.emailAddress,
                      validator: (v) {
                        if (v == null || v.isEmpty) return 'Email required';
                        if (!v.contains('@')) return 'Invalid email';
                        return null;
                      },
                    ).animate().fadeIn(delay: 750.ms).slideX(begin: -0.05),
                    const Gap(14),

                    _buildGlassInput(
                      controller: _passwordController,
                      label: 'Password',
                      icon: LucideIcons.lock,
                      obscureText: _obscurePassword,
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword
                              ? LucideIcons.eyeOff
                              : LucideIcons.eye,
                          size: 18,
                          color: Colors.white.withValues(alpha: 0.4),
                        ),
                        onPressed: () =>
                            setState(() => _obscurePassword = !_obscurePassword),
                      ),
                      validator: (v) {
                        if (v == null || v.isEmpty) return 'Password required';
                        if (v.length < 6) return 'Min 6 characters';
                        return null;
                      },
                    ).animate().fadeIn(delay: 850.ms).slideX(begin: -0.05),
                    const Gap(8),

                    // Forgot Password
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: _showForgotPassword,
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                        ),
                        child: Text(
                          'Forgot Password?',
                          style: AppTypography.labelMedium.copyWith(
                            color: AppColors.accentAlt.withValues(alpha: 0.8),
                          ),
                        ),
                      ),
                    ),
                    const Gap(12),

                    // ── Sign In Button ──
                    _buildPrimaryButton()
                        .animate()
                        .fadeIn(delay: 950.ms)
                        .slideY(begin: 0.1),
                    const Gap(18),

                    // ── Sign Up ──
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Don't have an account? ",
                          style: AppTypography.bodyMedium.copyWith(
                            color: Colors.white.withValues(alpha: 0.4),
                          ),
                        ),
                        GestureDetector(
                          onTap: () => context.go(AppRoutes.signup),
                          child: Text(
                            'Sign Up',
                            style: AppTypography.labelLarge.copyWith(
                              color: AppColors.accentAlt,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ).animate().fadeIn(delay: 1050.ms),

                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ).animate().fadeIn(delay: 500.ms, duration: 600.ms).slideY(begin: 0.06);
  }

  // ────────────────────────────────────────────────────────────────
  // GLASS INPUT FIELD
  // ────────────────────────────────────────────────────────────────

  Widget _buildGlassInput({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    bool obscureText = false,
    Widget? suffixIcon,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      style: AppTypography.bodyMedium.copyWith(color: Colors.white),
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(
          color: Colors.white.withValues(alpha: 0.4),
          fontSize: 14,
        ),
        prefixIcon: Icon(icon, size: 18, color: AppColors.primaryLight),
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: Colors.white.withValues(alpha: 0.05),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(
            color: Colors.white.withValues(alpha: 0.1),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(
            color: Colors.white.withValues(alpha: 0.08),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(
            color: AppColors.primaryLight,
            width: 1.5,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(
            color: AppColors.error.withValues(alpha: 0.6),
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
      ),
    );
  }

  // ────────────────────────────────────────────────────────────────
  // PRIMARY SIGN IN BUTTON
  // ────────────────────────────────────────────────────────────────

  Widget _buildPrimaryButton() {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(26),
          gradient: const LinearGradient(
            colors: AppColors.gradientPrimary,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.4),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: ElevatedButton(
          onPressed: _isLoading ? null : _login,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(26),
            ),
          ),
          child: _isLoading
              ? const SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    color: Colors.white,
                  ),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(LucideIcons.logIn, size: 18, color: Colors.white),
                    const Gap(8),
                    Text(
                      'Sign In',
                      style: AppTypography.labelLarge.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    )
        .animate(onPlay: (c) => c.repeat())
        .shimmer(
          duration: 2500.ms,
          delay: 3.seconds,
          color: Colors.white.withValues(alpha: 0.08),
        );
  }

  // ────────────────────────────────────────────────────────────────
  // GOOGLE BUTTON
  // ────────────────────────────────────────────────────────────────

  Widget _buildGoogleSignInButton() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: OutlinedButton(
        onPressed: _isGoogleLoading ? null : _signInWithGoogle,
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: Colors.white.withValues(alpha: 0.12)),
          backgroundColor: Colors.white.withValues(alpha: 0.04),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        child: _isGoogleLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 26,
                    height: 26,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Center(
                      child: Text(
                        'G',
                        style: TextStyle(
                          color: Colors.blue.shade600,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  const Gap(12),
                  Text(
                    'Continue with Google',
                    style: AppTypography.labelLarge.copyWith(
                      color: Colors.white.withValues(alpha: 0.8),
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  // ────────────────────────────────────────────────────────────────
  // ERROR CARD
  // ────────────────────────────────────────────────────────────────

  Widget _buildErrorCard() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.error.withValues(alpha: 0.12),
        border: Border.all(color: AppColors.error.withValues(alpha: 0.3)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(LucideIcons.alertCircle, color: AppColors.error, size: 18),
          const Gap(10),
          Expanded(
            child: Text(
              _errorMessage!,
              style: AppTypography.bodySmall.copyWith(color: AppColors.error),
            ),
          ),
          GestureDetector(
            onTap: () => setState(() => _errorMessage = null),
            child: Icon(
              LucideIcons.x,
              size: 16,
              color: AppColors.error.withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    ).animate().shake(duration: 400.ms);
  }

  // ────────────────────────────────────────────────────────────────
  // AUTH ACTIONS
  // ────────────────────────────────────────────────────────────────

  Future<void> _signInWithGoogle() async {
    HapticService.buttonPress();
    setState(() {
      _isGoogleLoading = true;
      _errorMessage = null;
    });

    final result = await AuthService.signInWithGoogle();

    setState(() => _isGoogleLoading = false);

    if (result.isSuccess && mounted) {
      HapticService.success();
      context.go(AppRoutes.messSelection);
    } else if (mounted && result.error != null) {
      HapticService.error();
      setState(() => _errorMessage = result.error);
    }
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) {
      HapticService.bouncyError();
      return;
    }

    HapticService.buttonPress();
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final success = await ref.read(authProvider.notifier).signIn(
      email: _emailController.text.trim(),
      password: _passwordController.text,
    );

    setState(() => _isLoading = false);

    if (success && mounted) {
      HapticService.success();
      context.go(AppRoutes.messSelection);
    } else if (mounted) {
      HapticService.error();
      setState(() => _errorMessage = 'Invalid email or password');
    }
  }

  void _showForgotPassword() {
    final emailController = TextEditingController(text: _emailController.text);
    HapticService.modalOpen();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: ctx.surfaceColor,
        title: const Text('Reset Password'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Enter your email to receive a password reset link.'),
            const Gap(12),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                prefixIcon: Icon(LucideIcons.mail, size: 20),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () async {
              if (emailController.text.isNotEmpty) {
                final result = await AuthService.sendPasswordResetEmail(
                  emailController.text.trim(),
                );
                if (ctx.mounted) {
                  Navigator.pop(ctx);
                  if (result.isSuccess) {
                    showSuccessToast(context, 'Password reset email sent!');
                  } else {
                    showErrorToast(
                      context,
                      result.error ?? 'Failed to send email',
                    );
                  }
                }
              }
            },
            child: const Text('Send Reset Link'),
          ),
        ],
      ),
    );
  }

}

// ══════════════════════════════════════════════════════════════════
// COSMIC BACKGROUND — deep space aurora with floating orbs
// ══════════════════════════════════════════════════════════════════

class _CosmicBackground extends StatelessWidget {
  const _CosmicBackground();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF0A0E1A), // deep space
            Color(0xFF0D1B2A), // midnight blue
            Color(0xFF0F172A), // dark slate
          ],
        ),
      ),
      child: Stack(
        children: [
          // Top-right teal orb
          Positioned(
            top: -60,
            right: -40,
            child: _Orb(
              size: 260,
              color: AppColors.primary,
              opacity: 0.15,
              duration: 6.seconds,
            ),
          ),
          // Center-left violet orb
          Positioned(
            top: MediaQuery.of(context).size.height * 0.35,
            left: -80,
            child: _Orb(
              size: 200,
              color: AppColors.accent,
              opacity: 0.1,
              duration: 8.seconds,
              delay: 2.seconds,
            ),
          ),
          // Bottom-right cyan orb
          Positioned(
            bottom: -40,
            right: -30,
            child: _Orb(
              size: 180,
              color: AppColors.accentAlt,
              opacity: 0.08,
              duration: 7.seconds,
              delay: 1.seconds,
            ),
          ),
          // Subtle noise/grain overlay
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment.topCenter,
                  radius: 1.2,
                  colors: [
                    Colors.white.withValues(alpha: 0.02),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Orb extends StatelessWidget {
  final double size;
  final Color color;
  final double opacity;
  final Duration duration;
  final Duration delay;

  const _Orb({
    required this.size,
    required this.color,
    required this.opacity,
    required this.duration,
    this.delay = Duration.zero,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [
            color.withValues(alpha: opacity),
            color.withValues(alpha: opacity * 0.3),
            Colors.transparent,
          ],
          stops: const [0.0, 0.5, 1.0],
        ),
      ),
    )
        .animate(
          delay: delay,
          onPlay: (c) => c.repeat(reverse: true),
        )
        .scaleXY(
          begin: 0.85,
          end: 1.15,
          duration: duration,
          curve: Curves.easeInOut,
        );
  }
}
