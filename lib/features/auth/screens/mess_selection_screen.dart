import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:go_router/go_router.dart';
import 'package:gap/gap.dart';

import 'package:mess_manager/core/theme/app_theme.dart';
import 'package:mess_manager/core/router/app_router.dart';
import 'package:mess_manager/core/models/auth_user.dart';
import 'package:mess_manager/core/services/haptic_service.dart';
import 'package:mess_manager/core/widgets/app_components.dart';
import 'package:mess_manager/features/auth/providers/auth_provider.dart';

/// Mess Selection Screen - Cosmic Bioluminescence Design
class MessSelectionScreen extends ConsumerStatefulWidget {
  const MessSelectionScreen({super.key});

  @override
  ConsumerState<MessSelectionScreen> createState() =>
      _MessSelectionScreenState();
}

class _MessSelectionScreenState extends ConsumerState<MessSelectionScreen> {
  final _inviteCodeController = TextEditingController();

  @override
  void dispose() {
    _inviteCodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final messes = authState.availableMesses;

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

          // Accent orbs
          Positioned(
            top: -50, left: -40,
            child: Container(
              width: 180, height: 180,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(colors: [
                  AppColors.primary.withValues(alpha: 0.12),
                  Colors.transparent,
                ]),
              ),
            ).animate(onPlay: (c) => c.repeat(reverse: true))
                .scaleXY(begin: 1.0, end: 1.15, duration: 4.seconds),
          ),
          Positioned(
            bottom: 80, right: -60,
            child: Container(
              width: 200, height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(colors: [
                  AppColors.accentAlt.withValues(alpha: 0.08),
                  Colors.transparent,
                ]),
              ),
            ).animate(onPlay: (c) => c.repeat(reverse: true))
                .scaleXY(begin: 0.9, end: 1.1, duration: 5.seconds),
          ),

          // Main content
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header with logout
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Hi, ${authState.user?.name ?? 'User'}!',
                              style: AppTypography.headlineMedium.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const Gap(4),
                            Text(
                              'Select a mess or create a new one',
                              style: TextStyle(color: Colors.white.withValues(alpha: 0.4)),
                            ),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () async {
                          HapticService.mediumTap();
                          await ref.read(authProvider.notifier).signOut();
                          if (context.mounted) context.go(AppRoutes.login);
                        },
                        child: Text(
                          'Logout',
                          style: TextStyle(color: AppColors.error.withValues(alpha: 0.7), fontWeight: FontWeight.w500),
                        ),
                      ),
                    ],
                  ).animate().fadeIn(duration: 400.ms),
                  const Gap(28),

                  // Available Messes
                  if (messes.isNotEmpty) ...[
                    _buildSectionLabel('YOUR MESSES'),
                    const Gap(12),
                    ...messes.asMap().entries.map(
                          (entry) => _buildMessCard(entry.value, entry.key),
                        ),
                    const Gap(20),
                  ] else ...[
                    // Empty state — no messes yet
                    _buildEmptyMessPlaceholder(),
                    const Gap(20),
                  ],

                  // Join with Code
                  _buildSectionLabel('JOIN EXISTING MESS'),
                  const Gap(12),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: Container(
                        padding: const EdgeInsets.all(AppSpacing.lg),
                        decoration: AppSpacing.accentCard(accent: AppColors.primary, radius: AppSpacing.radiusLg),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 36, height: 36,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    gradient: RadialGradient(colors: [
                                      AppColors.primary.withValues(alpha: 0.3),
                                      AppColors.primary.withValues(alpha: 0.05),
                                    ]),
                                  ),
                                  child: const Icon(LucideIcons.userPlus, color: AppColors.primary, size: 18),
                                ),
                                const Gap(10),
                                Text('Join with Invite Code', style: TextStyle(color: Colors.white.withValues(alpha: 0.8), fontWeight: FontWeight.w600)),
                              ],
                            ),
                            const Gap(14),
                            Row(
                              children: [
                                Expanded(
                                  child: TextField(
                                    controller: _inviteCodeController,
                                    textCapitalization: TextCapitalization.characters,
                                    style: TextStyle(color: Colors.white.withValues(alpha: 0.9)),
                                    decoration: InputDecoration(
                                      hintText: 'Enter invite code',
                                      hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.25)),
                                      isDense: true,
                                      filled: true,
                                      fillColor: Colors.white.withValues(alpha: 0.03),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                                        borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.06)),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                                        borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.06)),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                                        borderSide: BorderSide(color: AppColors.primary.withValues(alpha: 0.5)),
                                      ),
                                    ),
                                  ),
                                ),
                                const Gap(10),
                                GestureDetector(
                                  onTap: _joinMess,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                                    decoration: BoxDecoration(
                                      gradient: const LinearGradient(colors: [AppColors.primary, Color(0xFF2A9D8F)]),
                                      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                                    ),
                                    child: const Text('Join', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.05),
                  const Gap(20),

                  // Divider
                  Row(
                    children: [
                      Expanded(child: Container(height: 1, decoration: BoxDecoration(gradient: LinearGradient(colors: [Colors.transparent, Colors.white.withValues(alpha: 0.08)])))),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text('OR', style: AppTypography.bodySmall.copyWith(color: Colors.white.withValues(alpha: 0.25))),
                      ),
                      Expanded(child: Container(height: 1, decoration: BoxDecoration(gradient: LinearGradient(colors: [Colors.white.withValues(alpha: 0.08), Colors.transparent])))),
                    ],
                  ).animate().fadeIn(delay: 400.ms),
                  const Gap(20),

                  // Create Mess
                  GestureDetector(
                    onTap: () => _showCreateMessSheet(context),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          decoration: AppSpacing.accentCard(accent: AppColors.primary, radius: AppSpacing.radiusMd),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(LucideIcons.plus, size: 18, color: AppColors.primaryLight),
                              const Gap(8),
                              Text('Create New Mess', style: TextStyle(color: AppColors.primaryLight, fontWeight: FontWeight.w600)),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ).animate().fadeIn(delay: 500.ms),
                  const Gap(24),

                  // Skip
                  Center(
                    child: GestureDetector(
                      onTap: _continueToDefault,
                      child: Text(
                        'Continue with Default Mess',
                        style: TextStyle(color: Colors.white.withValues(alpha: 0.3)),
                      ),
                    ),
                  ).animate().fadeIn(delay: 600.ms),
                  const Gap(32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyMessPlaceholder() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.lg),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.primary.withValues(alpha: 0.06),
                AppColors.accentAlt.withValues(alpha: 0.03),
              ],
            ),
            border: Border.all(
              color: AppColors.primary.withValues(alpha: 0.1),
            ),
          ),
          child: Column(
            children: [
              Container(
                width: 56, height: 56,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(colors: [
                    AppColors.primary.withValues(alpha: 0.2),
                    AppColors.primary.withValues(alpha: 0.04),
                  ]),
                ),
                child: const Icon(LucideIcons.home, color: AppColors.primary, size: 26),
              ),
              const Gap(14),
              Text(
                'No mess yet',
                style: AppTypography.titleMedium.copyWith(
                  color: Colors.white.withValues(alpha: 0.8),
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Gap(6),
              Text(
                'Create a new mess to manage shared meals and expenses, or join an existing one with an invite code.',
                textAlign: TextAlign.center,
                style: AppTypography.bodySmall.copyWith(
                  color: Colors.white.withValues(alpha: 0.35),
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ),
    ).animate().fadeIn(duration: 500.ms).slideY(begin: 0.05);
  }

  Widget _buildSectionLabel(String text) {
    return Row(
      children: [
        Container(
          width: 3, height: 14,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(2),
            gradient: const LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [AppColors.primary, AppColors.accentAlt]),
          ),
        ),
        const Gap(8),
        Text(text, style: AppTypography.bodySmall.copyWith(color: Colors.white.withValues(alpha: 0.4), fontWeight: FontWeight.w600, letterSpacing: 1.5, fontSize: 11)),
      ],
    );
  }

  Widget _buildMessCard(Mess mess, int index) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: GestureDetector(
        onTap: () => _selectMess(mess.id),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
            child: Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
                  AppColors.primary.withValues(alpha: 0.08),
                  AppColors.primary.withValues(alpha: 0.03),
                ]),
                borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                border: Border.all(color: AppColors.primary.withValues(alpha: 0.15)),
              ),
              child: Row(
                children: [
                  Container(
                    width: 44, height: 44,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(colors: [
                        AppColors.primary.withValues(alpha: 0.3),
                        AppColors.primary.withValues(alpha: 0.05),
                      ]),
                      border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
                    ),
                    child: const Icon(LucideIcons.home, color: AppColors.primary, size: 20),
                  ),
                  const Gap(12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(mess.name, style: TextStyle(color: Colors.white.withValues(alpha: 0.9), fontWeight: FontWeight.bold)),
                        Text(mess.address, style: AppTypography.bodySmall.copyWith(color: Colors.white.withValues(alpha: 0.35))),
                      ],
                    ),
                  ),
                  Icon(LucideIcons.chevronRight, color: Colors.white.withValues(alpha: 0.2), size: 18),
                ],
              ),
            ),
          ),
        ),
      ),
    ).animate(delay: (80 * index).ms).fadeIn().slideX(begin: 0.03);
  }

  void _selectMess(String messId) async {
    HapticService.buttonPress();
    await ref.read(authProvider.notifier).selectMess(messId);
    if (mounted) context.go(AppRoutes.dashboard);
  }

  void _joinMess() async {
    final code = _inviteCodeController.text.trim();
    if (code.isEmpty) return;
    HapticService.buttonPress();
    try {
      await ref.read(authProvider.notifier).joinMess(code);
      if (mounted) context.go(AppRoutes.dashboard);
    } catch (e) {
      if (mounted) showErrorToast(context, 'Invalid invite code');
    }
  }

  void _continueToDefault() {
    HapticService.lightTap();
    context.go(AppRoutes.dashboard);
  }

  void _showCreateMessSheet(BuildContext context) {
    final nameController = TextEditingController();
    final addressController = TextEditingController();

    AppSheet.show(
      context: context,
      title: 'Create New Mess',
      child: Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Mess Name', hintText: 'e.g., Area51, Bachelor Pad'),
            ),
            const Gap(12),
            TextField(
              controller: addressController,
              decoration: const InputDecoration(labelText: 'Address', hintText: 'Dhaka, Bangladesh'),
            ),
            const Gap(24),
            AppPrimaryButton(
              text: 'Create Mess',
              onPressed: () async {
                if (nameController.text.trim().isEmpty) return;
                HapticService.success();
                await ref.read(authProvider.notifier).createMess(
                      name: nameController.text.trim(),
                      address: addressController.text.trim(),
                    );
                if (context.mounted) {
                  Navigator.pop(context);
                  context.go(AppRoutes.dashboard);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
