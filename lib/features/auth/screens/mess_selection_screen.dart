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
import 'package:mess_manager/core/models/auth_user.dart';
import 'package:mess_manager/core/services/haptic_service.dart';
import 'package:mess_manager/core/widgets/gf_components.dart';
import 'package:mess_manager/features/auth/providers/auth_provider.dart';

/// Mess Selection Screen - Uses AnimatedTextKit + GetWidget + VelocityX
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
        title: 'Select Mess'.text.make(),
        actions: [
          GFButton(
            onPressed: () async {
              HapticService.mediumTap();
              await ref.read(authProvider.notifier).signOut();
              if (context.mounted) context.go(AppRoutes.login);
            },
            text: 'Logout',
            type: GFButtonType.transparent,
            textColor: AppColors.error,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: VStack(crossAlignment: CrossAxisAlignment.start, [
          // Welcome with AnimatedTextKit
          AnimatedTextKit(
            animatedTexts: [
              TypewriterAnimatedText(
                'Hi, ${authState.user?.name ?? 'User'}! 👋',
                textStyle: AppTypography.headlineMedium.copyWith(
                  color: AppColors.textPrimaryDark,
                ),
                speed: 60.ms,
              ),
            ],
            isRepeatingAnimation: false,
            displayFullTextOnTap: true,
          ),
          4.heightBox,
          'Select a mess or create a new one'.text
              .color(AppColors.textSecondaryDark)
              .make()
              .animate()
              .fadeIn(delay: 200.ms),
          24.heightBox,

          // Available Messes
          if (messes.isNotEmpty) ...[
            'Your Messes'.text.sm.color(AppColors.textSecondaryDark).make(),
            8.heightBox,
            ...messes.asMap().entries.map(
              (entry) => _buildMessCard(entry.value, entry.key),
            ),
            16.heightBox,
          ],

          // Join with Code
          GFAppCard(
            child: VStack(crossAlignment: CrossAxisAlignment.start, [
              HStack([
                const Icon(
                  LucideIcons.userPlus,
                  color: AppColors.primary,
                  size: 20,
                ),
                8.widthBox,
                'Join Existing Mess'.text
                    .color(AppColors.textPrimaryDark)
                    .make(),
              ]),
              12.heightBox,
              HStack([
                TextField(
                  controller: _inviteCodeController,
                  textCapitalization: TextCapitalization.characters,
                  decoration: const InputDecoration(
                    hintText: 'Enter invite code',
                    isDense: true,
                  ),
                ).expand(),
                8.widthBox,
                GFButton(
                  onPressed: _joinMess,
                  text: 'Join',
                  color: AppColors.primary,
                ),
              ]),
            ]),
          ),
          16.heightBox,

          // Or Divider
          HStack([
            const Expanded(child: Divider()),
            'OR'.text.xs.color(AppColors.textMutedDark).make().px12(),
            const Expanded(child: Divider()),
          ]),
          16.heightBox,

          // Create Mess
          GFSecondaryButton(
            text: 'Create New Mess',
            icon: LucideIcons.plus,
            onPressed: () => _showCreateMessSheet(context),
          ),
          24.heightBox,

          // Skip
          GFButton(
            onPressed: _continueToDefault,
            text: 'Continue with Default Mess',
            type: GFButtonType.transparent,
            textColor: AppColors.textMutedDark,
            fullWidthButton: true,
          ).centered(),
        ]),
      ),
    );
  }

  Widget _buildMessCard(Mess mess, int index) {
    return GFCard(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      padding: EdgeInsets.zero,
      gradient: LinearGradient(
        colors: [
          AppColors.primary.withValues(alpha: 0.1),
          AppColors.primaryLight.withValues(alpha: 0.05),
        ],
      ),
      border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      content: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _selectMess(mess.id),
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          child: HStack([
            GFAvatar(
              backgroundColor: AppColors.primary.withValues(alpha: 0.2),
              child: const Icon(LucideIcons.home, color: AppColors.primary),
            ),
            12.widthBox,
            VStack(crossAlignment: CrossAxisAlignment.start, [
              mess.name.text.color(AppColors.textPrimaryDark).bold.make(),
              mess.address.text.sm.color(AppColors.textMutedDark).make(),
            ]).expand(),
            const Icon(
              LucideIcons.chevronRight,
              color: AppColors.textMutedDark,
            ),
          ]).p16(),
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

    HapticService.modalOpen();
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
        decoration: const BoxDecoration(
          color: AppColors.surfaceDark,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppSpacing.radiusLg),
          ),
        ),
        child: VStack([
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.borderDark,
              borderRadius: BorderRadius.circular(2),
            ),
          ).centered(),
          16.heightBox,
          'Create New Mess'.text.xl.bold
              .color(AppColors.textPrimaryDark)
              .make()
              .wFull(context),
          16.heightBox,
          TextField(
            controller: nameController,
            decoration: const InputDecoration(
              labelText: 'Mess Name',
              hintText: 'e.g., Area51, Bachelor Pad',
            ),
          ),
          12.heightBox,
          TextField(
            controller: addressController,
            decoration: const InputDecoration(
              labelText: 'Address',
              hintText: 'Dhaka, Bangladesh',
            ),
          ),
          24.heightBox,
          GFPrimaryButton(
            text: 'Create Mess',
            onPressed: () async {
              if (nameController.text.trim().isEmpty) return;
              HapticService.success();
              await ref
                  .read(authProvider.notifier)
                  .createMess(
                    name: nameController.text.trim(),
                    address: addressController.text.trim(),
                  );
              if (context.mounted) {
                Navigator.pop(context);
                context.go(AppRoutes.dashboard);
              }
            },
          ),
        ]),
      ),
    );
  }
}
