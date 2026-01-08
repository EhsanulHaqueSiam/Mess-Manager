import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:getwidget/getwidget.dart';

import 'package:mess_manager/core/theme/app_theme.dart';
import 'package:mess_manager/core/router/app_router.dart';

/// Custom 404 Error Screen - Branded page for invalid routes
class ErrorScreen extends StatelessWidget {
  final GoException? error;

  const ErrorScreen({super.key, this.error});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.xl),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Animated 404 illustration
                _buildErrorIcon()
                    .animate(onPlay: (c) => c.repeat(reverse: true))
                    .moveY(begin: 0, end: -10, duration: 1500.ms),

                const SizedBox(height: AppSpacing.xl),

                // Error Code
                '404'.text.xl3.bold
                    .color(AppColors.error)
                    .letterSpacing(8)
                    .make()
                    .animate()
                    .fadeIn(delay: 200.ms)
                    .slideY(begin: 0.2),

                const SizedBox(height: AppSpacing.sm),

                // Title
                'Page Not Found'.text.xl.bold
                    .color(AppColors.textPrimaryDark)
                    .make()
                    .animate()
                    .fadeIn(delay: 300.ms),

                const SizedBox(height: AppSpacing.md),

                // Description
                'The page you\'re looking for doesn\'t exist or has been moved.'
                    .text
                    .center
                    .color(AppColors.textSecondaryDark)
                    .make()
                    .animate()
                    .fadeIn(delay: 400.ms),

                if (error != null) ...[
                  const SizedBox(height: AppSpacing.md),
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    decoration: BoxDecoration(
                      color: AppColors.error.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                      border: Border.all(
                        color: AppColors.error.withValues(alpha: 0.3),
                      ),
                    ),
                    child: error
                        .toString()
                        .text
                        .xs
                        .color(AppColors.error)
                        .make(),
                  ).animate().fadeIn(delay: 500.ms),
                ],

                const SizedBox(height: AppSpacing.xl),

                // Action buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GFButton(
                      onPressed: () => context.go(AppRoutes.dashboard),
                      text: 'Go Home',
                      icon: const Icon(
                        LucideIcons.home,
                        color: Colors.white,
                        size: 18,
                      ),
                      color: AppColors.primary,
                      size: GFSize.LARGE,
                    ),
                    const SizedBox(width: AppSpacing.md),
                    GFButton(
                      onPressed: () {
                        if (context.canPop()) {
                          context.pop();
                        } else {
                          context.go(AppRoutes.dashboard);
                        }
                      },
                      text: 'Go Back',
                      icon: const Icon(LucideIcons.arrowLeft, size: 18),
                      type: GFButtonType.outline,
                      color: AppColors.textSecondaryDark,
                      size: GFSize.LARGE,
                    ),
                  ],
                ).animate().fadeIn(delay: 600.ms).slideY(begin: 0.2),

                const SizedBox(height: AppSpacing.xl),

                // Helpful links
                'Quick Links'.text.sm.bold
                    .color(AppColors.textMutedDark)
                    .make(),
                const SizedBox(height: AppSpacing.sm),
                Wrap(
                  spacing: AppSpacing.sm,
                  runSpacing: AppSpacing.sm,
                  alignment: WrapAlignment.center,
                  children: [
                    _buildQuickLink(
                      context,
                      'Meals',
                      AppRoutes.meals,
                      LucideIcons.utensils,
                    ),
                    _buildQuickLink(
                      context,
                      'Bazar',
                      AppRoutes.bazar,
                      LucideIcons.shoppingBag,
                    ),
                    _buildQuickLink(
                      context,
                      'Balance',
                      AppRoutes.balance,
                      LucideIcons.wallet,
                    ),
                    _buildQuickLink(
                      context,
                      'Settings',
                      AppRoutes.settings,
                      LucideIcons.settings,
                    ),
                  ],
                ).animate().fadeIn(delay: 700.ms),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildErrorIcon() {
    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        color: AppColors.error.withValues(alpha: 0.1),
        shape: BoxShape.circle,
        border: Border.all(
          color: AppColors.error.withValues(alpha: 0.3),
          width: 2,
        ),
      ),
      child: const Icon(
        LucideIcons.alertTriangle,
        size: 56,
        color: AppColors.error,
      ),
    );
  }

  Widget _buildQuickLink(
    BuildContext context,
    String label,
    String route,
    IconData icon,
  ) {
    return GFButton(
      onPressed: () => context.go(route),
      text: label,
      icon: Icon(icon, size: 14, color: AppColors.textSecondaryDark),
      type: GFButtonType.transparent,
      textColor: AppColors.textSecondaryDark,
      size: GFSize.SMALL,
    );
  }
}
