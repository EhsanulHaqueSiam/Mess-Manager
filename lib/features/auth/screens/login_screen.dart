import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import 'package:mess_manager/core/theme/app_theme.dart';
import 'package:mess_manager/core/router/app_router.dart';
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
  bool _obscurePassword = true;

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
              const Gap(AppSpacing.xxl),

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
                    ),
                    const Gap(AppSpacing.lg),
                    Text(
                      'Mess Manager',
                      style: AppTypography.displayMedium.copyWith(
                        color: AppColors.textPrimaryDark,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const Gap(AppSpacing.xs),
                    Text(
                      'Manage your shared living expenses',
                      style: AppTypography.bodyMedium.copyWith(
                        color: AppColors.textMutedDark,
                      ),
                    ),
                  ],
                ),
              ),
              const Gap(AppSpacing.xxl),

              // Login Form
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Welcome back',
                      style: AppTypography.headlineMedium.copyWith(
                        color: AppColors.textPrimaryDark,
                      ),
                    ),
                    const Gap(AppSpacing.xs),
                    Text(
                      'Sign in to continue',
                      style: AppTypography.bodyMedium.copyWith(
                        color: AppColors.textSecondaryDark,
                      ),
                    ),
                    const Gap(AppSpacing.xl),

                    // Email
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        prefixIcon: const Icon(LucideIcons.mail, size: 20),
                        filled: true,
                        fillColor: AppColors.cardDark,
                      ),
                      validator: (v) {
                        if (v == null || v.isEmpty) return 'Email required';
                        if (!v.contains('@')) return 'Invalid email';
                        return null;
                      },
                    ),
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
                        filled: true,
                        fillColor: AppColors.cardDark,
                      ),
                      validator: (v) {
                        if (v == null || v.isEmpty) return 'Password required';
                        if (v.length < 6) return 'Min 6 characters';
                        return null;
                      },
                    ),
                    const Gap(AppSpacing.xl),

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
                            : const Text('Sign In'),
                      ),
                    ),
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
                    ),

                    // Skip for demo
                    const Gap(AppSpacing.md),
                    Center(
                      child: TextButton(
                        onPressed: _skipLogin,
                        child: Text(
                          'Skip for Demo',
                          style: AppTypography.labelMedium.copyWith(
                            color: AppColors.textMutedDark,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final success = await ref
        .read(authProvider.notifier)
        .signIn(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        );

    setState(() => _isLoading = false);

    if (success && mounted) {
      context.go(AppRoutes.messSelection);
    }
  }

  void _skipLogin() async {
    await ref
        .read(authProvider.notifier)
        .signIn(email: 'demo@messmanager.com', password: 'demo123');
    if (mounted) {
      context.go(AppRoutes.dashboard);
    }
  }
}
