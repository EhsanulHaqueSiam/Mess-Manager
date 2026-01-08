import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';

import 'package:mess_manager/core/theme/app_theme.dart';
import 'package:mess_manager/core/router/app_router.dart';
import 'package:mess_manager/core/services/haptic_service.dart';
import 'package:mess_manager/core/database/isar_service.dart';
import 'package:mess_manager/core/database/collections/pending_approval_collection.dart';
import 'package:mess_manager/features/auth/providers/auth_provider.dart';

/// Pending Approval Screen - Shown to users waiting for admin approval
class PendingApprovalScreen extends ConsumerStatefulWidget {
  const PendingApprovalScreen({super.key});

  @override
  ConsumerState<PendingApprovalScreen> createState() =>
      _PendingApprovalScreenState();
}

class _PendingApprovalScreenState extends ConsumerState<PendingApprovalScreen> {
  Timer? _refreshTimer;
  bool _isChecking = false;
  ApprovalStatus? _currentStatus;

  @override
  void initState() {
    super.initState();
    _checkStatus();
    // Auto-check every 10 seconds
    _refreshTimer = Timer.periodic(const Duration(seconds: 10), (_) {
      _checkStatus();
    });
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    super.dispose();
  }

  Future<void> _checkStatus() async {
    if (_isChecking) return;
    setState(() => _isChecking = true);

    final user = ref.read(currentUserProvider);
    if (user != null) {
      final approval = IsarService.getPendingApprovalByEmail(user.email);
      if (approval != null) {
        setState(() {
          _currentStatus = approval.status;
          _isChecking = false;
        });

        // If approved, redirect to dashboard
        if (approval.status == ApprovalStatus.approved) {
          HapticService.success();
          if (mounted) {
            context.go(AppRoutes.dashboard);
          }
        }
      } else {
        // No approval record means user is fully approved
        if (mounted) {
          context.go(AppRoutes.dashboard);
        }
      }
    }
    setState(() => _isChecking = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Status-based icon/animation
                _buildStatusIcon(),
                const Gap(AppSpacing.xl),

                // Title
                _buildTitle(),
                const Gap(AppSpacing.md),

                // Description
                _buildDescription(),
                const Gap(AppSpacing.xl),

                // Refresh button
                if (_currentStatus == ApprovalStatus.pending ||
                    _currentStatus == null)
                  _buildRefreshButton(),

                // Rejected action
                if (_currentStatus == ApprovalStatus.rejected)
                  _buildContactButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatusIcon() {
    if (_currentStatus == ApprovalStatus.rejected) {
      return Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppColors.error.withValues(alpha: 0.1),
          shape: BoxShape.circle,
        ),
        child: const Icon(
          LucideIcons.xCircle,
          size: 80,
          color: AppColors.error,
        ),
      ).animate().fadeIn().scale(begin: const Offset(0.8, 0.8));
    }

    // Pending or checking - show loading animation
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.1),
        shape: BoxShape.circle,
      ),
      child: SizedBox(
        width: 120,
        height: 120,
        child: Lottie.asset(
          'assets/lottie/loading.json',
          fit: BoxFit.contain,
          errorBuilder: (context, error, stack) => const Icon(
            LucideIcons.hourglass,
            size: 80,
            color: AppColors.primary,
          ),
        ),
      ),
    ).animate().fadeIn().scale(begin: const Offset(0.8, 0.8));
  }

  Widget _buildTitle() {
    String title;
    Color color;

    switch (_currentStatus) {
      case ApprovalStatus.rejected:
        title = 'Request Rejected';
        color = AppColors.error;
        break;
      case ApprovalStatus.approved:
        title = 'Welcome!';
        color = AppColors.success;
        break;
      default:
        title = 'Awaiting Approval';
        color = AppColors.textPrimaryDark;
    }

    return title.text.xl2.bold
        .color(color)
        .makeCentered()
        .animate()
        .fadeIn(delay: 200.ms)
        .slideY(begin: 0.2);
  }

  Widget _buildDescription() {
    String description;

    switch (_currentStatus) {
      case ApprovalStatus.rejected:
        description =
            'Your request to join has been declined. Please contact the mess admin for more information.';
        break;
      case ApprovalStatus.approved:
        description = 'Your account has been approved! Redirecting...';
        break;
      default:
        description =
            'Your signup request is being reviewed by the mess admin. You\'ll be notified once approved.';
    }

    return description.text.center.gray500
        .make()
        .animate()
        .fadeIn(delay: 400.ms)
        .slideY(begin: 0.2);
  }

  Widget _buildRefreshButton() {
    return Column(
      children: [
        // Auto-refresh indicator
        HStack([
          if (_isChecking)
            const SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          else
            const Icon(
              LucideIcons.refreshCw,
              size: 16,
              color: AppColors.textMutedDark,
            ),
          const Gap(AppSpacing.sm),
          'Auto-checking every 10 seconds'.text.xs.gray500.make(),
        ]).animate().fadeIn(delay: 600.ms),

        const Gap(AppSpacing.lg),

        // Manual refresh button
        OutlinedButton.icon(
          onPressed: _isChecking
              ? null
              : () {
                  HapticService.buttonPress();
                  _checkStatus();
                },
          icon: _isChecking
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Icon(LucideIcons.refreshCw),
          label: Text(_isChecking ? 'Checking...' : 'Check Status'),
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.md,
            ),
          ),
        ).animate().fadeIn(delay: 700.ms),

        const Gap(AppSpacing.xl),

        // Sign out option
        TextButton(
          onPressed: () {
            HapticService.buttonPress();
            ref.read(authProvider.notifier).signOut();
            context.go(AppRoutes.login);
          },
          child: 'Sign Out'.text.color(AppColors.textMutedDark).make(),
        ).animate().fadeIn(delay: 800.ms),
      ],
    );
  }

  Widget _buildContactButton() {
    return Column(
      children: [
        ElevatedButton.icon(
          onPressed: () {
            HapticService.buttonPress();
            // Could open email or show contact info
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Please contact your mess admin directly.'),
              ),
            );
          },
          icon: const Icon(LucideIcons.mail),
          label: const Text('Contact Admin'),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.md,
            ),
          ),
        ).animate().fadeIn(delay: 600.ms),

        const Gap(AppSpacing.lg),

        TextButton(
          onPressed: () {
            HapticService.buttonPress();
            ref.read(authProvider.notifier).signOut();
            context.go(AppRoutes.login);
          },
          child: 'Sign Out & Try Again'.text
              .color(AppColors.textMutedDark)
              .make(),
        ).animate().fadeIn(delay: 700.ms),
      ],
    );
  }
}
