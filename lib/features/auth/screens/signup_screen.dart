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

class SignupScreen extends ConsumerStatefulWidget {
  const SignupScreen({super.key});

  @override
  ConsumerState<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _isGoogleLoading = false;
  bool _obscurePassword = true;
  String? _errorMessage;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(LucideIcons.arrowLeft),
          onPressed: () => context.go(AppRoutes.login),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Create Account',
                style: AppTypography.displaySmall.copyWith(
                  color: AppColors.textPrimaryDark,
                  fontWeight: FontWeight.w700,
                ),
              ).animate().fadeIn(),
              const Gap(AppSpacing.xs),
              Text(
                'Join your mess community',
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.textSecondaryDark,
                ),
              ).animate().fadeIn(delay: 100.ms),
              const Gap(AppSpacing.xl),

              // ============ GOOGLE SIGN UP (Primary) ============
              _buildGoogleSignUpButton()
                  .animate()
                  .fadeIn(delay: 200.ms)
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
                      'or sign up with email',
                      style: AppTypography.labelSmall.copyWith(
                        color: AppColors.textMutedDark,
                      ),
                    ),
                  ),
                  const Expanded(child: Divider(color: AppColors.borderDark)),
                ],
              ).animate().fadeIn(delay: 300.ms),
              const Gap(AppSpacing.lg),

              // Error Message
              if (_errorMessage != null)
                Container(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  margin: const EdgeInsets.only(bottom: AppSpacing.md),
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

              // Email Sign Up Form
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Name
                    TextFormField(
                      controller: _nameController,
                      textCapitalization: TextCapitalization.words,
                      decoration: const InputDecoration(
                        labelText: 'Full Name',
                        prefixIcon: Icon(LucideIcons.user, size: 20),
                      ),
                      validator: (v) {
                        if (v == null || v.isEmpty) return 'Name required';
                        return null;
                      },
                    ).animate().fadeIn(delay: 400.ms),
                    const Gap(AppSpacing.md),

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
                    ).animate().fadeIn(delay: 500.ms),
                    const Gap(AppSpacing.md),

                    // Phone
                    TextFormField(
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(
                        labelText: 'Phone (optional)',
                        prefixIcon: Icon(LucideIcons.phone, size: 20),
                      ),
                    ).animate().fadeIn(delay: 600.ms),
                    const Gap(AppSpacing.md),

                    // Password
                    TextFormField(
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        prefixIcon: const Icon(LucideIcons.lock, size: 20),
                        helperText: 'At least 6 characters',
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
                    const Gap(AppSpacing.xl),

                    // Sign Up Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _signUp,
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
                            : const Text('Create Account'),
                      ),
                    ).animate().fadeIn(delay: 800.ms),
                    const Gap(AppSpacing.lg),

                    // Terms
                    Center(
                      child: Text(
                        'By signing up, you agree to our Terms & Privacy Policy',
                        style: AppTypography.labelSmall.copyWith(
                          color: AppColors.textMutedDark,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ).animate().fadeIn(delay: 900.ms),
                    const Gap(AppSpacing.lg),

                    // Sign In Link
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Already have an account? ',
                          style: AppTypography.bodyMedium.copyWith(
                            color: AppColors.textSecondaryDark,
                          ),
                        ),
                        TextButton(
                          onPressed: () => context.go(AppRoutes.login),
                          child: const Text('Sign In'),
                        ),
                      ],
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

  /// Google Sign-Up Button (same as Sign-In - automatically creates account)
  Widget _buildGoogleSignUpButton() {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        onPressed: _isGoogleLoading ? null : _signUpWithGoogle,
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
                    'Sign up with Google',
                    style: AppTypography.titleSmall.copyWith(
                      color: AppColors.textPrimaryDark,
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  /// Sign up with Google (automatically creates account)
  Future<void> _signUpWithGoogle() async {
    HapticService.buttonPress();
    setState(() {
      _isGoogleLoading = true;
      _errorMessage = null;
    });

    final result = await AuthService.signInWithGoogle();

    setState(() => _isGoogleLoading = false);

    if (result.isSuccess && mounted) {
      HapticService.success();
      // Google auth automatically creates account
      context.go(AppRoutes.messSelection);
    } else if (mounted && result.error != null) {
      HapticService.error();
      setState(() => _errorMessage = result.error);
    }
  }

  /// Email/password sign up
  Future<void> _signUp() async {
    if (!_formKey.currentState!.validate()) return;

    HapticService.buttonPress();
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final result = await AuthService.signUpWithEmail(
      email: _emailController.text.trim(),
      password: _passwordController.text,
      displayName: _nameController.text.trim(),
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
}
