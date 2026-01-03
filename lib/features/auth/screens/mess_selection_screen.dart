import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import 'package:mess_manager/core/theme/app_theme.dart';
import 'package:mess_manager/core/router/app_router.dart';
import 'package:mess_manager/features/auth/providers/auth_provider.dart';

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
      appBar: AppBar(
        title: const Text('Select Mess'),
        actions: [
          TextButton(
            onPressed: () => ref
                .read(authProvider.notifier)
                .signOut()
                .then((_) => context.go(AppRoutes.login)),
            child: const Text('Logout'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome
            Text(
              'Hi, ${authState.user?.name ?? 'User'}! 👋',
              style: AppTypography.headlineMedium.copyWith(
                color: AppColors.textPrimaryDark,
              ),
            ),
            const Gap(AppSpacing.xs),
            Text(
              'Select a mess or create a new one',
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.textSecondaryDark,
              ),
            ),
            const Gap(AppSpacing.xl),

            // Available Messes
            if (messes.isNotEmpty) ...[
              Text(
                'Your Messes',
                style: AppTypography.labelMedium.copyWith(
                  color: AppColors.textSecondaryDark,
                ),
              ),
              const Gap(AppSpacing.sm),
              ...messes.asMap().entries.map((entry) {
                final mess = entry.value;
                return _buildMessCard(mess, entry.key);
              }),
              const Gap(AppSpacing.lg),
            ],

            // Join with Code
            Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: AppColors.cardDark,
                borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                border: Border.all(
                  color: AppColors.borderDark.withValues(alpha: 0.5),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(
                        LucideIcons.userPlus,
                        color: AppColors.primary,
                        size: 20,
                      ),
                      const Gap(AppSpacing.sm),
                      Text(
                        'Join Existing Mess',
                        style: AppTypography.titleSmall.copyWith(
                          color: AppColors.textPrimaryDark,
                        ),
                      ),
                    ],
                  ),
                  const Gap(AppSpacing.md),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _inviteCodeController,
                          textCapitalization: TextCapitalization.characters,
                          decoration: const InputDecoration(
                            hintText: 'Enter invite code',
                            isDense: true,
                          ),
                        ),
                      ),
                      const Gap(AppSpacing.sm),
                      ElevatedButton(
                        onPressed: _joinMess,
                        child: const Text('Join'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Gap(AppSpacing.lg),

            // Or Divider
            Row(
              children: [
                const Expanded(child: Divider()),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                  ),
                  child: Text(
                    'OR',
                    style: AppTypography.labelSmall.copyWith(
                      color: AppColors.textMutedDark,
                    ),
                  ),
                ),
                const Expanded(child: Divider()),
              ],
            ),
            const Gap(AppSpacing.lg),

            // Create New Mess
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () => _showCreateMessSheet(context),
                icon: const Icon(LucideIcons.plus, size: 18),
                label: const Text('Create New Mess'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                ),
              ),
            ),
            const Gap(AppSpacing.xl),

            // Skip / Continue to Default
            Center(
              child: TextButton(
                onPressed: _continueToDefault,
                child: Text(
                  'Continue with Default Mess',
                  style: AppTypography.labelMedium.copyWith(
                    color: AppColors.textMutedDark,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessCard(mess, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primary.withValues(alpha: 0.1),
            AppColors.primaryLight.withValues(alpha: 0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _selectMess(mess.id),
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                  ),
                  child: const Icon(LucideIcons.home, color: AppColors.primary),
                ),
                const Gap(AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        mess.name,
                        style: AppTypography.titleMedium.copyWith(
                          color: AppColors.textPrimaryDark,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        mess.address,
                        style: AppTypography.bodySmall.copyWith(
                          color: AppColors.textMutedDark,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  LucideIcons.chevronRight,
                  color: AppColors.textMutedDark,
                ),
              ],
            ),
          ),
        ),
      ),
    ).animate(delay: (80 * index).ms).fadeIn().slideX(begin: 0.03);
  }

  void _selectMess(String messId) async {
    await ref.read(authProvider.notifier).selectMess(messId);
    if (mounted) {
      context.go(AppRoutes.dashboard);
    }
  }

  void _joinMess() async {
    final code = _inviteCodeController.text.trim();
    if (code.isEmpty) return;

    try {
      await ref.read(authProvider.notifier).joinMess(code);
      if (mounted) {
        context.go(AppRoutes.dashboard);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Invalid invite code')));
      }
    }
  }

  void _continueToDefault() {
    context.go(AppRoutes.dashboard);
  }

  void _showCreateMessSheet(BuildContext context) {
    final nameController = TextEditingController();
    final addressController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: EdgeInsets.only(
          left: AppSpacing.lg,
          right: AppSpacing.lg,
          top: AppSpacing.lg,
          bottom: MediaQuery.of(context).viewInsets.bottom + AppSpacing.lg,
        ),
        decoration: BoxDecoration(
          color: AppColors.surfaceDark,
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(AppSpacing.radiusLg),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.borderDark,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const Gap(AppSpacing.lg),
            Text(
              'Create New Mess',
              style: AppTypography.headlineMedium.copyWith(
                color: AppColors.textPrimaryDark,
              ),
            ),
            const Gap(AppSpacing.lg),
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Mess Name',
                hintText: 'e.g., Area51, Bachelor Pad',
              ),
            ),
            const Gap(AppSpacing.md),
            TextField(
              controller: addressController,
              decoration: const InputDecoration(
                labelText: 'Address',
                hintText: 'Dhaka, Bangladesh',
              ),
            ),
            const Gap(AppSpacing.xl),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  if (nameController.text.trim().isEmpty) return;
                  await ref
                      .read(authProvider.notifier)
                      .createMess(
                        name: nameController.text.trim(),
                        address: addressController.text.trim(),
                      );
                  if (mounted) {
                    Navigator.pop(context);
                    this.context.go(AppRoutes.dashboard);
                  }
                },
                child: const Text('Create Mess'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
