import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:go_router/go_router.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:getwidget/getwidget.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

import 'package:mess_manager/core/theme/app_theme.dart';
import 'package:mess_manager/core/router/app_router.dart';
import 'package:mess_manager/core/services/auth_service.dart';
import 'package:mess_manager/core/services/haptic_service.dart';
import 'package:mess_manager/core/widgets/gf_components.dart';
import 'package:mess_manager/features/auth/providers/auth_provider.dart';

/// Signup Screen - Uses AnimatedTextKit + GetWidget + VelocityX
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
          child: VStack(crossAlignment: CrossAxisAlignment.start, [
            // Animated Title
            AnimatedTextKit(
              animatedTexts: [
                TypewriterAnimatedText(
                  'Create Account',
                  textStyle: AppTypography.displaySmall.copyWith(
                    color: AppColors.textPrimaryDark,
                    fontWeight: FontWeight.w700,
                  ),
                  speed: 60.ms,
                ),
              ],
              isRepeatingAnimation: false,
              displayFullTextOnTap: true,
            ),
            4.heightBox,
            'Join your mess community'.text
                .color(AppColors.textSecondaryDark)
                .make()
                .animate()
                .fadeIn(delay: 100.ms),
            24.heightBox,

            // Google Sign Up
            _buildGoogleSignUpButton()
                .animate()
                .fadeIn(delay: 200.ms)
                .slideY(begin: 0.1),
            16.heightBox,

            // Divider
            HStack([
              const Expanded(child: Divider(color: AppColors.borderDark)),
              'or sign up with email'.text.xs
                  .color(AppColors.textMutedDark)
                  .make()
                  .px12(),
              const Expanded(child: Divider(color: AppColors.borderDark)),
            ]).animate().fadeIn(delay: 300.ms),
            16.heightBox,

            // Error Message
            if (_errorMessage != null) _buildErrorCard(),

            // Form
            Form(
              key: _formKey,
              child: VStack([
                TextFormField(
                  controller: _nameController,
                  textCapitalization: TextCapitalization.words,
                  decoration: const InputDecoration(
                    labelText: 'Full Name',
                    prefixIcon: Icon(LucideIcons.user, size: 20),
                  ),
                  validator: (v) =>
                      v == null || v.isEmpty ? 'Name required' : null,
                ).animate().fadeIn(delay: 400.ms),
                12.heightBox,

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
                12.heightBox,

                TextFormField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                    labelText: 'Phone (optional)',
                    prefixIcon: Icon(LucideIcons.phone, size: 20),
                  ),
                ).animate().fadeIn(delay: 600.ms),
                12.heightBox,

                TextFormField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    prefixIcon: const Icon(LucideIcons.lock, size: 20),
                    helperText: 'At least 6 characters',
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword ? LucideIcons.eyeOff : LucideIcons.eye,
                        size: 20,
                      ),
                      onPressed: () =>
                          setState(() => _obscurePassword = !_obscurePassword),
                    ),
                  ),
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'Password required';
                    if (v.length < 6) return 'Min 6 characters';
                    return null;
                  },
                ).animate().fadeIn(delay: 700.ms),
                24.heightBox,

                // Sign Up Button
                GFPrimaryButton(
                  text: 'Create Account',
                  onPressed: _isLoading ? null : _signUp,
                  isLoading: _isLoading,
                ).animate().fadeIn(delay: 800.ms),
                16.heightBox,

                // Terms
                'By signing up, you agree to our Terms & Privacy Policy'.text.xs
                    .color(AppColors.textMutedDark)
                    .center
                    .make()
                    .animate()
                    .fadeIn(delay: 900.ms),
                16.heightBox,

                // Sign In Link
                HStack(alignment: MainAxisAlignment.center, [
                  'Already have an account? '.text
                      .color(AppColors.textSecondaryDark)
                      .make(),
                  GFButton(
                    onPressed: () => context.go(AppRoutes.login),
                    text: 'Sign In',
                    type: GFButtonType.transparent,
                    textColor: AppColors.primary,
                    size: GFSize.SMALL,
                  ),
                ]).animate().fadeIn(delay: 1000.ms),
              ]),
            ),
          ]),
        ),
      ),
    );
  }

  Widget _buildErrorCard() {
    return GFCard(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      padding: const EdgeInsets.all(AppSpacing.md),
      color: AppColors.error.withValues(alpha: 0.1),
      border: Border.all(color: AppColors.error.withValues(alpha: 0.3)),
      borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
      content: HStack([
        const Icon(LucideIcons.alertCircle, color: AppColors.error, size: 18),
        8.widthBox,
        _errorMessage!.text.sm.color(AppColors.error).make().expand(),
        GFIconButton(
          icon: const Icon(LucideIcons.x, size: 16, color: AppColors.error),
          type: GFButtonType.transparent,
          size: GFSize.SMALL,
          onPressed: () => setState(() => _errorMessage = null),
        ),
      ]),
    ).animate().shake();
  }

  Widget _buildGoogleSignUpButton() {
    return GFButton(
      onPressed: _isGoogleLoading ? null : _signUpWithGoogle,
      fullWidthButton: true,
      size: GFSize.LARGE,
      type: GFButtonType.outline,
      color: AppColors.borderDark,
      child: _isGoogleLoading
          ? const GFLoader(type: GFLoaderType.circle, size: 20)
          : HStack(alignment: MainAxisAlignment.center, [
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
              12.widthBox,
              'Sign up with Google'.text
                  .color(AppColors.textPrimaryDark)
                  .make(),
            ]),
    );
  }

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
      context.go(AppRoutes.messSelection);
    } else if (mounted && result.error != null) {
      HapticService.error();
      setState(() => _errorMessage = result.error);
    }
  }

  Future<void> _signUp() async {
    if (!_formKey.currentState!.validate()) return;

    HapticService.buttonPress();
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    // Use authProvider to create pending approval request
    final success = await ref
        .read(authProvider.notifier)
        .signUp(
          email: _emailController.text.trim(),
          password: _passwordController.text,
          name: _nameController.text.trim(),
          phone: _phoneController.text.trim().isEmpty
              ? null
              : _phoneController.text.trim(),
        );

    setState(() => _isLoading = false);

    if (success && mounted) {
      HapticService.success();
      // Redirect to pending approval screen instead of direct access
      context.go(AppRoutes.pendingApproval);
    } else if (mounted) {
      HapticService.error();
      setState(() => _errorMessage = 'Signup failed. Please try again.');
    }
  }
}
