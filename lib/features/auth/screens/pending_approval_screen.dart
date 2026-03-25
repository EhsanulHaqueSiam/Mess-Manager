import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';

import 'package:mess_manager/core/theme/app_theme.dart';
import 'package:mess_manager/core/router/app_router.dart';
import 'package:mess_manager/core/services/haptic_service.dart';
import 'package:mess_manager/core/database/isar_service.dart';
import 'package:mess_manager/core/models/pending_approval.dart';
import 'package:mess_manager/features/auth/providers/auth_provider.dart';

/// Pending Approval Screen - Cosmic Bioluminescence Design
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
        if (approval.status == ApprovalStatus.approved) {
          HapticService.success();
          if (mounted) context.go(AppRoutes.dashboard);
        }
      } else {
        if (mounted) context.go(AppRoutes.dashboard);
      }
    }
    setState(() => _isChecking = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0E1A),
      body: Stack(
        children: [
          // Deep space background
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFF0A0E1A), Color(0xFF0D1520)],
                ),
              ),
            ),
          ),

          // Breathing orbs
          Positioned(
            top: 100, left: -30,
            child: Container(
              width: 200, height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(colors: [
                  (_currentStatus == ApprovalStatus.rejected
                      ? AppColors.error
                      : AppColors.primary)
                      .withValues(alpha: 0.10),
                  Colors.transparent,
                ]),
              ),
            ).animate(onPlay: (c) => c.repeat(reverse: true))
                .scaleXY(begin: 1.0, end: 1.2, duration: 4.seconds),
          ),
          Positioned(
            bottom: 120, right: -40,
            child: Container(
              width: 180, height: 180,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(colors: [
                  AppColors.accent.withValues(alpha: 0.06),
                  Colors.transparent,
                ]),
              ),
            ).animate(onPlay: (c) => c.repeat(reverse: true))
                .scaleXY(begin: 0.9, end: 1.1, duration: 5.seconds),
          ),

          // Main content
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.xl),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildStatusIcon(),
                    const Gap(AppSpacing.xl),
                    _buildTitle(),
                    const Gap(AppSpacing.md),
                    _buildDescription(),
                    const Gap(AppSpacing.xl),
                    if (_currentStatus == ApprovalStatus.pending ||
                        _currentStatus == null)
                      _buildRefreshButton(),
                    if (_currentStatus == ApprovalStatus.rejected)
                      _buildContactButton(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusIcon() {
    if (_currentStatus == ApprovalStatus.rejected) {
      return Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(colors: [
            AppColors.error.withValues(alpha: 0.12),
            AppColors.error.withValues(alpha: 0.02),
          ]),
          border: Border.all(color: AppColors.error.withValues(alpha: 0.15)),
        ),
        child: const Icon(LucideIcons.xCircle, size: 80, color: AppColors.error),
      ).animate().fadeIn().scale(begin: const Offset(0.8, 0.8));
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(colors: [
          AppColors.primary.withValues(alpha: 0.10),
          AppColors.primary.withValues(alpha: 0.02),
        ]),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.1)),
      ),
      child: SizedBox(
        width: 120, height: 120,
        child: Lottie.asset(
          'assets/lottie/loading.json',
          fit: BoxFit.contain,
          errorBuilder: (context, error, stack) => Icon(
            LucideIcons.hourglass,
            size: 80,
            color: AppColors.primary.withValues(alpha: 0.7),
          ),
        ),
      ),
    )
        .animate().fadeIn().scale(begin: const Offset(0.8, 0.8))
        .then()
        .animate(onPlay: (c) => c.repeat(reverse: true))
        .scaleXY(begin: 1.0, end: 1.03, duration: 2.seconds);
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
        color = Colors.white;
    }

    return Text(
      title,
      style: AppTypography.headlineSmall.copyWith(
        color: color,
        fontWeight: FontWeight.bold,
      ),
      textAlign: TextAlign.center,
    ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.2);
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

    return Text(
      description,
      style: TextStyle(color: Colors.white.withValues(alpha: 0.45)),
      textAlign: TextAlign.center,
    ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.2);
  }

  Widget _buildRefreshButton() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_isChecking)
              SizedBox(
                width: 16, height: 16,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: AppColors.primary.withValues(alpha: 0.5),
                ),
              )
            else
              Icon(LucideIcons.refreshCw, size: 16, color: Colors.white.withValues(alpha: 0.25)),
            const Gap(AppSpacing.sm),
            Text(
              'Auto-checking every 10 seconds',
              style: AppTypography.bodySmall.copyWith(
                color: Colors.white.withValues(alpha: 0.3),
              ),
            ),
          ],
        ).animate().fadeIn(delay: 600.ms),

        const Gap(AppSpacing.lg),

        GestureDetector(
          onTap: _isChecking ? null : () {
            HapticService.buttonPress();
            _checkStatus();
          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.04),
                  borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                  border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (_isChecking)
                      SizedBox(
                        width: 18, height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.primary),
                      )
                    else
                      const Icon(LucideIcons.refreshCw, size: 18, color: AppColors.primary),
                    const Gap(8),
                    Text(
                      _isChecking ? 'Checking...' : 'Check Status',
                      style: TextStyle(color: AppColors.primaryLight, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ).animate().fadeIn(delay: 700.ms),

        const Gap(AppSpacing.xl),

        GestureDetector(
          onTap: () {
            HapticService.buttonPress();
            ref.read(authProvider.notifier).signOut();
            context.go(AppRoutes.login);
          },
          child: Text(
            'Sign Out',
            style: TextStyle(color: Colors.white.withValues(alpha: 0.3)),
          ),
        ).animate().fadeIn(delay: 800.ms),
      ],
    );
  }

  Widget _buildContactButton() {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            HapticService.buttonPress();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Please contact your mess admin directly.')),
            );
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [AppColors.primary, Color(0xFF2A9D8F)]),
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
              boxShadow: [
                BoxShadow(color: AppColors.primary.withValues(alpha: 0.3), blurRadius: 12, offset: const Offset(0, 4)),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(LucideIcons.mail, size: 18, color: Colors.white),
                Gap(8),
                Text('Contact Admin', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
              ],
            ),
          ),
        ).animate().fadeIn(delay: 600.ms),

        const Gap(AppSpacing.lg),

        GestureDetector(
          onTap: () {
            HapticService.buttonPress();
            ref.read(authProvider.notifier).signOut();
            context.go(AppRoutes.login);
          },
          child: Text(
            'Sign Out & Try Again',
            style: TextStyle(color: Colors.white.withValues(alpha: 0.3)),
          ),
        ).animate().fadeIn(delay: 700.ms),
      ],
    );
  }
}
