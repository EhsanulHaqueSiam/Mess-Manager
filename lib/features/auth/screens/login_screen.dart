import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
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
import 'package:mess_manager/core/database/isar_service.dart';
import 'package:mess_manager/core/models/member.dart';
import 'package:mess_manager/core/models/auth_user.dart';
import 'package:mess_manager/core/services/mock_data_service.dart';
import 'package:mess_manager/features/auth/providers/auth_provider.dart';

/// Login Screen - Uses AnimatedTextKit + GetWidget + VelocityX
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
          child: VStack(crossAlignment: CrossAxisAlignment.start, [
            24.heightBox,

            // Logo & Animated Welcome
            Center(
              child: VStack([
                // Logo
                GFCard(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  margin: EdgeInsets.zero,
                  gradient: LinearGradient(colors: AppColors.gradientPrimary),
                  borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                  elevation: 8,
                  content: const Icon(
                    LucideIcons.home,
                    color: Colors.white,
                    size: 48,
                  ),
                ).animate().scale(delay: 100.ms, duration: 400.ms),
                16.heightBox,

                // Animated Title with TypewriterAnimatedText
                AnimatedTextKit(
                  animatedTexts: [
                    TypewriterAnimatedText(
                      'Mess Manager',
                      textStyle: AppTypography.displayMedium.copyWith(
                        color: AppColors.textPrimaryDark,
                        fontWeight: FontWeight.w700,
                      ),
                      speed: 80.ms,
                    ),
                  ],
                  isRepeatingAnimation: false,
                  displayFullTextOnTap: true,
                ),
                4.heightBox,
                'Manage your shared living expenses'.text
                    .color(AppColors.textMutedDark)
                    .make()
                    .animate()
                    .fadeIn(delay: 300.ms),
              ]),
            ),
            24.heightBox,

            // ===== GOOGLE SIGN IN (Primary) =====
            _buildGoogleSignInButton()
                .animate()
                .fadeIn(delay: 400.ms)
                .slideY(begin: 0.1),
            16.heightBox,

            // Divider
            HStack([
              const Expanded(child: Divider(color: AppColors.borderDark)),
              'or continue with email'.text.xs
                  .color(AppColors.textMutedDark)
                  .make()
                  .px12(),
              const Expanded(child: Divider(color: AppColors.borderDark)),
            ]).animate().fadeIn(delay: 500.ms),
            16.heightBox,

            // Error Message
            if (_errorMessage != null) _buildErrorCard(),

            // Login Form
            Form(
              key: _formKey,
              child: VStack([
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
                12.heightBox,

                // Password
                TextFormField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    prefixIcon: const Icon(LucideIcons.lock, size: 20),
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
                16.heightBox,

                // Forgot Password
                Align(
                  alignment: Alignment.centerRight,
                  child: GFButton(
                    onPressed: _showForgotPassword,
                    text: 'Forgot Password?',
                    type: GFButtonType.transparent,
                    textColor: AppColors.primary,
                    size: GFSize.SMALL,
                  ),
                ),
                12.heightBox,

                // Login Button - Using GFPrimaryButton
                GFPrimaryButton(
                  text: 'Sign In with Email',
                  onPressed: _isLoading ? null : _login,
                  isLoading: _isLoading,
                ).animate().fadeIn(delay: 800.ms),
                16.heightBox,

                // Sign Up Link
                HStack(alignment: MainAxisAlignment.center, [
                  "Don't have an account? ".text
                      .color(AppColors.textSecondaryDark)
                      .make(),
                  GFButton(
                    onPressed: () => context.go(AppRoutes.signup),
                    text: 'Sign Up',
                    type: GFButtonType.transparent,
                    textColor: AppColors.primary,
                    size: GFSize.SMALL,
                  ),
                ]).animate().fadeIn(delay: 900.ms),
                12.heightBox,

                // Skip for demo (DEBUG MODE ONLY)
                if (kDebugMode)
                  Center(
                    child: GFButton(
                      onPressed: _skipLogin,
                      text: 'Continue as Guest (Demo)',
                      type: GFButtonType.transparent,
                      textColor: AppColors.textMutedDark,
                      size: GFSize.SMALL,
                    ),
                  ).animate().fadeIn(delay: 1000.ms),

                // === DEV MODE: Quick Role Testing ===
                if (kDebugMode) ...[
                  24.heightBox,
                  const Divider(color: AppColors.borderDark),
                  8.heightBox,
                  '🛠️ DEV MODE: Quick Login'.text.sm.bold
                      .color(AppColors.warning)
                      .make(),
                  8.heightBox,
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    alignment: WrapAlignment.center,
                    children: [
                      _buildDevRoleButton(
                        '👑 Super Admin',
                        MemberRole.superAdmin,
                      ),
                      _buildDevRoleButton('🔧 Admin', MemberRole.admin),
                      _buildDevRoleButton(
                        '🍽️ Meal Manager',
                        MemberRole.mealManager,
                      ),
                      _buildDevRoleButton('👤 Member', MemberRole.member),
                    ],
                  ),
                  8.heightBox,
                  'These buttons bypass login for testing'.text.xs
                      .color(AppColors.textMutedDark)
                      .italic
                      .make(),
                ],
              ]),
            ),
          ]),
        ),
      ),
    );
  }

  Widget _buildDevRoleButton(String label, MemberRole role) {
    return GFButton(
      onPressed: () => _devLoginAs(role),
      text: label,
      size: GFSize.SMALL,
      type: GFButtonType.outline,
      color: AppColors.warning,
    );
  }

  Future<void> _devLoginAs(MemberRole role) async {
    HapticService.buttonPress();

    // Create a dev user with the specified role
    final user = AuthUser(
      id: 'dev_${role.name}_${DateTime.now().millisecondsSinceEpoch}',
      email: '${role.name}@dev.test',
      name: 'Dev ${role.name.toUpperCase()}',
      createdAt: DateTime.now(),
    );

    // Save user and set role in member data
    IsarService.saveSetting('current_user', user.toJson());
    IsarService.saveSetting('current_user_role', role.index);

    // 🌱 Seed mock data for realistic testing
    await MockDataService.seedAll();

    await ref
        .read(authProvider.notifier)
        .signIn(email: user.email, password: 'dev123');

    if (mounted) {
      HapticService.success();
      context.go(AppRoutes.dashboard);
    }
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

  Widget _buildGoogleSignInButton() {
    return GFButton(
      onPressed: _isGoogleLoading ? null : _signInWithGoogle,
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
              'Continue with Google'.text
                  .color(AppColors.textPrimaryDark)
                  .make(),
            ]),
    );
  }

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

  void _showForgotPassword() {
    final emailController = TextEditingController(text: _emailController.text);
    HapticService.modalOpen();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surfaceDark,
        title: const Text('Reset Password'),
        content: VStack([
          const Text('Enter your email to receive a password reset link.'),
          12.heightBox,
          TextField(
            controller: emailController,
            decoration: const InputDecoration(
              labelText: 'Email',
              prefixIcon: Icon(LucideIcons.mail, size: 20),
            ),
          ),
        ]),
        actions: [
          GFButton(
            onPressed: () => Navigator.pop(context),
            text: 'Cancel',
            type: GFButtonType.transparent,
          ),
          GFButton(
            onPressed: () async {
              if (emailController.text.isNotEmpty) {
                final result = await AuthService.sendPasswordResetEmail(
                  emailController.text.trim(),
                );
                if (context.mounted) {
                  Navigator.pop(context);
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
            text: 'Send Reset Link',
            color: AppColors.primary,
          ),
        ],
      ),
    );
  }

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
