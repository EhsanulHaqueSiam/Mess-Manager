import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import 'package:mess_manager/core/theme/app_theme.dart';
import 'package:mess_manager/core/router/app_router.dart';
import 'package:mess_manager/core/services/auth_service.dart';
import 'package:mess_manager/core/services/haptic_service.dart';
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
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Gap(AppSpacing.xl),

              // Logo & Welcome
              Center(
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(AppSpacing.lg),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: AppColors.gradientPrimary,
                        ),
                        borderRadius: BorderRadius.circular(
                          AppSpacing.radiusLg,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withValues(alpha: 0.3),
                            blurRadius: 20,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: const Icon(
                        LucideIcons.home,
                        color: Colors.white,
                        size: 48,
                      ),
                    ).animate().scale(delay: 100.ms, duration: 400.ms),
                    const Gap(AppSpacing.lg),
                    Text(
                      'Mess Manager',
                      style: AppTypography.displayMedium.copyWith(
                        color: AppColors.textPrimaryDark,
                        fontWeight: FontWeight.w700,
                      ),
                    ).animate().fadeIn(delay: 200.ms),
                    const Gap(AppSpacing.xs),
                    Text(
                      'Manage your shared living expenses',
                      style: AppTypography.bodyMedium.copyWith(
                        color: AppColors.textMutedDark,
                      ),
                    ).animate().fadeIn(delay: 300.ms),
                  ],
                ),
              ),
              const Gap(AppSpacing.xl),

              // ============ GOOGLE SIGN IN (Primary) ============
              _buildGoogleSignInButton()
                  .animate()
                  .fadeIn(delay: 400.ms)
                  .slideY(begin: 0.1),
              const Gap(AppSpacing.lg),

              // Divider
              Row(
                children: [
                  const Expanded(child: Divider(color: AppColors.borderDark)),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md,
                    ),
                    child: Text(
                      'or continue with email',
                      style: AppTypography.labelSmall.copyWith(
                        color: AppColors.textMutedDark,
                      ),
                    ),
                  ),
                  const Expanded(child: Divider(color: AppColors.borderDark)),
                ],
              ).animate().fadeIn(delay: 500.ms),
              const Gap(AppSpacing.lg),

              // Error Message
              if (_errorMessage != null)
                Container(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    color: AppColors.error.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                    border: Border.all(
                      color: AppColors.error.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        LucideIcons.alertCircle,
                        color: AppColors.error,
                        size: 18,
                      ),
                      const Gap(AppSpacing.sm),
                      Expanded(
                        child: Text(
                          _errorMessage!,
                          style: AppTypography.bodySmall.copyWith(
                            color: AppColors.error,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(LucideIcons.x, size: 16),
                        onPressed: () => setState(() => _errorMessage = null),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(
                          minWidth: 24,
                          minHeight: 24,
                        ),
                      ),
                    ],
                  ),
                ).animate().shake(),

              // Login Form
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Email
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        prefixIcon: Icon(LucideIcons.mail, size: 20),
                      ),
                      validator: (v) {
                        if (v == null || v.isEmpty) return 'Email required';
                        if (!v.contains('@')) return 'Invalid email';
                        return null;
                      },
                    ).animate().fadeIn(delay: 600.ms),
                    const Gap(AppSpacing.md),

                    // Password
                    TextFormField(
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        prefixIcon: const Icon(LucideIcons.lock, size: 20),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? LucideIcons.eyeOff
                                : LucideIcons.eye,
                            size: 20,
                          ),
                          onPressed: () => setState(
                            () => _obscurePassword = !_obscurePassword,
                          ),
                        ),
                      ),
                      validator: (v) {
                        if (v == null || v.isEmpty) return 'Password required';
                        if (v.length < 6) return 'Min 6 characters';
                        return null;
                      },
                    ).animate().fadeIn(delay: 700.ms),
                    const Gap(AppSpacing.lg),

                    // Forgot Password
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: _showForgotPassword,
                        child: Text(
                          'Forgot Password?',
                          style: AppTypography.labelMedium.copyWith(
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ),
                    const Gap(AppSpacing.md),

                    // Login Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _login,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            vertical: AppSpacing.md,
                          ),
                        ),
                        child: _isLoading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text('Sign In with Email'),
                      ),
                    ).animate().fadeIn(delay: 800.ms),
                    const Gap(AppSpacing.lg),

                    // Sign Up Link
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Don't have an account? ",
                          style: AppTypography.bodyMedium.copyWith(
                            color: AppColors.textSecondaryDark,
                          ),
                        ),
                        TextButton(
                          onPressed: () => context.go(AppRoutes.signup),
                          child: const Text('Sign Up'),
                        ),
                      ],
                    ).animate().fadeIn(delay: 900.ms),

                    // Skip for demo
                    const Gap(AppSpacing.md),
                    Center(
                      child: TextButton(
                        onPressed: _skipLogin,
                        child: Text(
                          'Continue as Guest (Demo)',
                          style: AppTypography.labelMedium.copyWith(
                            color: AppColors.textMutedDark,
                          ),
                        ),
                      ),
                    ).animate().fadeIn(delay: 1000.ms),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Google Sign-In Button (handles both sign-in and sign-up automatically)
  Widget _buildGoogleSignInButton() {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        onPressed: _isGoogleLoading ? null : _signInWithGoogle,
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
          side: BorderSide(color: AppColors.borderDark.withValues(alpha: 0.5)),
          backgroundColor: AppColors.cardDark,
        ),
        child: _isGoogleLoading
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Google Logo
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4),
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
                  const Gap(AppSpacing.md),
                  Text(
                    'Continue with Google',
                    style: AppTypography.titleSmall.copyWith(
                      color: AppColors.textPrimaryDark,
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  /// Sign in with Google (creates account automatically if doesn't exist)
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
      // Google sign-in automatically creates account if doesn't exist
      context.go(AppRoutes.messSelection);
    } else if (mounted && result.error != null) {
      HapticService.error();
      setState(() => _errorMessage = result.error);
    }
  }

  /// Email/password login
  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    HapticService.buttonPress();
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final result = await AuthService.signInWithEmail(
      email: _emailController.text.trim(),
      password: _passwordController.text,
    );

    setState(() => _isLoading = false);

    if (result.isSuccess && mounted) {
      HapticService.success();
      context.go(AppRoutes.messSelection);
    } else if (mounted && result.error != null) {
      HapticService.error();
      setState(() => _errorMessage = result.error);
    }
  }

  /// Forgot password
  void _showForgotPassword() {
    final emailController = TextEditingController(text: _emailController.text);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surfaceDark,
        title: const Text('Reset Password'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Enter your email to receive a password reset link.'),
            const Gap(AppSpacing.md),
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
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (emailController.text.isNotEmpty) {
                final result = await AuthService.sendPasswordResetEmail(
                  emailController.text.trim(),
                );
                if (context.mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        result.isSuccess
                            ? 'Password reset email sent!'
                            : result.error ?? 'Failed to send email',
                      ),
                      backgroundColor: result.isSuccess
                          ? AppColors.success
                          : AppColors.error,
                    ),
                  );
                }
              }
            },
            child: const Text('Send Reset Link'),
          ),
        ],
      ),
    );
  }

  /// Skip login (demo mode)
  void _skipLogin() async {
    HapticService.buttonPress();
    await ref
        .read(authProvider.notifier)
        .signIn(email: 'demo@messmanager.com', password: 'demo123');
    if (mounted) {
      context.go(AppRoutes.dashboard);
    }
  }
}
