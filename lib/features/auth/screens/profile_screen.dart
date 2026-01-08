import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:go_router/go_router.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:getwidget/getwidget.dart';
import 'package:image_picker/image_picker.dart';

import 'package:mess_manager/core/theme/app_theme.dart';
import 'package:mess_manager/core/router/app_router.dart';
import 'package:mess_manager/core/services/auth_service.dart';
import 'package:mess_manager/core/services/haptic_service.dart';
import 'package:mess_manager/core/widgets/gf_components.dart';
import 'package:mess_manager/features/auth/providers/auth_provider.dart';

/// Profile Screen - Uses GetWidget + VelocityX + flutter_animate
class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _imagePicker = ImagePicker();
  bool _isLoading = false;
  bool _isEditing = false;
  String? _profileImagePath;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  void _loadUserData() {
    final user = AuthService.currentUser;
    if (user != null) {
      _nameController.text = user.displayName ?? '';
      _phoneController.text = user.phoneNumber ?? '';
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  /// Pick profile image from camera or gallery
  Future<void> _pickProfileImage() async {
    HapticService.lightTap();

    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      backgroundColor: AppColors.surfaceDark,
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(LucideIcons.camera, color: AppColors.primary),
              title: const Text('Take Photo'),
              onTap: () => Navigator.pop(context, ImageSource.camera),
            ),
            ListTile(
              leading: const Icon(LucideIcons.image, color: AppColors.primary),
              title: const Text('Choose from Gallery'),
              onTap: () => Navigator.pop(context, ImageSource.gallery),
            ),
          ],
        ),
      ),
    );

    if (source == null) return;

    try {
      final pickedFile = await _imagePicker.pickImage(
        source: source,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        setState(() => _profileImagePath = pickedFile.path);
        HapticService.success();
        if (mounted) showSuccessToast(context, 'Profile photo updated!');
      }
    } catch (e) {
      HapticService.error();
      if (mounted) showErrorToast(context, 'Failed to pick image');
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = AuthService.currentUser;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(LucideIcons.arrowLeft),
          onPressed: () => context.pop(),
        ),
        title: 'Profile'.text.make(),
        actions: [
          if (!_isEditing)
            GFIconButton(
              icon: const Icon(
                LucideIcons.pencil,
                size: 20,
                color: AppColors.primary,
              ),
              type: GFButtonType.transparent,
              onPressed: () {
                HapticService.lightTap();
                setState(() => _isEditing = true);
              },
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: VStack([
          // Profile Avatar
          Center(
            child: Stack(
              children: [
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: _profileImagePath == null
                        ? LinearGradient(colors: AppColors.gradientPrimary)
                        : null,
                    image: _profileImagePath != null
                        ? DecorationImage(
                            image: FileImage(File(_profileImagePath!)),
                            fit: BoxFit.cover,
                          )
                        : null,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.3),
                        blurRadius: 16,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: _profileImagePath == null
                      ? Center(
                          child: _getInitials(
                            user?.displayName ?? user?.email ?? 'U',
                          ).text.xl3.white.bold.make(),
                        )
                      : null,
                ).animate().scale(delay: 100.ms),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: GFIconButton(
                    icon: const Icon(
                      LucideIcons.camera,
                      size: 16,
                      color: Colors.white,
                    ),
                    size: GFSize.SMALL,
                    color: AppColors.primary,
                    shape: GFIconButtonShape.circle,
                    onPressed: _pickProfileImage,
                  ),
                ),
              ],
            ),
          ).animate().fadeIn(),
          24.heightBox,

          // User Info
          (user?.displayName ?? 'User').text.xl2.bold
              .color(AppColors.textPrimaryDark)
              .center
              .make(),
          4.heightBox,
          (user?.email ?? '').text.sm
              .color(AppColors.textSecondaryDark)
              .center
              .make(),
          24.heightBox,

          // Profile Form or Display
          if (_isEditing) ...[_buildEditForm()] else ...[_buildInfoCards(user)],
          32.heightBox,

          // Actions
          _buildActionButtons(),
        ]),
      ),
    );
  }

  Widget _buildEditForm() {
    return Form(
      key: _formKey,
      child: VStack([
        'Edit Profile'.text.lg.bold
            .color(AppColors.textPrimaryDark)
            .make()
            .wFull(context),
        16.heightBox,
        GFAppCard(
          child: VStack([
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Display Name',
                prefixIcon: Icon(LucideIcons.user, size: 18),
              ),
              validator: (v) => v?.isEmpty == true ? 'Name required' : null,
            ),
            16.heightBox,
            TextFormField(
              controller: _phoneController,
              decoration: const InputDecoration(
                labelText: 'Phone Number',
                prefixIcon: Icon(LucideIcons.phone, size: 18),
              ),
              keyboardType: TextInputType.phone,
            ),
          ]),
        ),
        24.heightBox,
        HStack([
          GFSecondaryButton(
            text: 'Cancel',
            onPressed: () {
              _loadUserData();
              setState(() => _isEditing = false);
            },
          ).expand(),
          16.widthBox,
          GFPrimaryButton(
            text: 'Save',
            isLoading: _isLoading,
            onPressed: _saveProfile,
          ).expand(),
        ]),
      ]),
    ).animate().fadeIn().slideY(begin: 0.05);
  }

  Widget _buildInfoCards(dynamic user) {
    return VStack([
      _buildInfoCard(
        icon: LucideIcons.mail,
        label: 'Email',
        value: user?.email ?? 'Not set',
        color: AppColors.primary,
      ).animate(delay: 100.ms).fadeIn().slideX(begin: 0.05),
      _buildInfoCard(
        icon: LucideIcons.phone,
        label: 'Phone',
        value: user?.phoneNumber ?? 'Not set',
        color: AppColors.info,
      ).animate(delay: 150.ms).fadeIn().slideX(begin: 0.05),
      _buildInfoCard(
        icon: LucideIcons.shieldCheck,
        label: 'Account Status',
        value: user?.emailVerified == true ? 'Verified' : 'Not Verified',
        color: user?.emailVerified == true
            ? AppColors.success
            : AppColors.warning,
      ).animate(delay: 200.ms).fadeIn().slideX(begin: 0.05),
      _buildInfoCard(
        icon: LucideIcons.calendar,
        label: 'Member Since',
        value: _formatDate(user?.metadata?.creationTime),
        color: AppColors.secondary,
      ).animate(delay: 250.ms).fadeIn().slideX(begin: 0.05),
    ]);
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return GFAppCard(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: HStack([
        GFAvatar(
          size: 40,
          backgroundColor: color.withValues(alpha: 0.15),
          child: Icon(icon, color: color, size: 18),
        ),
        12.widthBox,
        VStack(crossAlignment: CrossAxisAlignment.start, [
          label.text.xs.color(AppColors.textMutedDark).make(),
          value.text.color(AppColors.textPrimaryDark).bold.make(),
        ]).expand(),
      ]),
    );
  }

  Widget _buildActionButtons() {
    return VStack([
      'Account Actions'.text.lg.bold
          .color(AppColors.textPrimaryDark)
          .make()
          .wFull(context),
      12.heightBox,
      GFAppCard(
        onTap: _changePassword,
        child: HStack([
          const Icon(LucideIcons.key, color: AppColors.info, size: 20),
          12.widthBox,
          'Change Password'.text
              .color(AppColors.textPrimaryDark)
              .make()
              .expand(),
          const Icon(
            LucideIcons.chevronRight,
            color: AppColors.textMutedDark,
            size: 18,
          ),
        ]),
      ).animate(delay: 300.ms).fadeIn(),
      8.heightBox,
      GFAppCard(
        onTap: _verifyEmail,
        child: HStack([
          const Icon(LucideIcons.mailCheck, color: AppColors.success, size: 20),
          12.widthBox,
          'Verify Email'.text.color(AppColors.textPrimaryDark).make().expand(),
          const Icon(
            LucideIcons.chevronRight,
            color: AppColors.textMutedDark,
            size: 18,
          ),
        ]),
      ).animate(delay: 350.ms).fadeIn(),
      24.heightBox,
      GFDangerButton(
        text: 'Sign Out',
        icon: LucideIcons.logOut,
        onPressed: _signOut,
      ).animate(delay: 400.ms).fadeIn(),
      12.heightBox,
      GFButton(
        onPressed: _deleteAccount,
        text: 'Delete Account',
        type: GFButtonType.transparent,
        textColor: AppColors.error,
        icon: const Icon(LucideIcons.trash2, size: 16, color: AppColors.error),
        fullWidthButton: true,
      ).animate(delay: 450.ms).fadeIn(),
    ]);
  }

  String _getInitials(String name) {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name.isNotEmpty ? name[0].toUpperCase() : 'U';
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'Unknown';
    return '${date.day}/${date.month}/${date.year}';
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    HapticService.buttonPress();

    try {
      final name = _nameController.text.trim();
      final phone = _phoneController.text.trim();

      await AuthService.updateDisplayName(name);

      // Also save to local auth provider for persistence
      await ref
          .read(authProvider.notifier)
          .updateProfile(
            name: name,
            phone: phone.isNotEmpty ? phone : null,
            avatarUrl: _profileImagePath,
          );

      if (mounted) {
        showSuccessToast(context, 'Profile updated!');
        setState(() {
          _isEditing = false;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        showErrorToast(context, 'Failed to update profile');
        setState(() => _isLoading = false);
      }
    }
  }

  void _changePassword() async {
    HapticService.lightTap();
    final email = AuthService.currentUser?.email;
    if (email == null) {
      showErrorToast(context, 'No email associated with account');
      return;
    }
    try {
      await AuthService.sendPasswordResetEmail(email);
      if (mounted) showSuccessToast(context, 'Password reset email sent!');
    } catch (e) {
      if (mounted) showErrorToast(context, 'Failed to send reset email');
    }
  }

  void _verifyEmail() async {
    HapticService.lightTap();
    try {
      await AuthService.currentUser?.sendEmailVerification();
      if (mounted) showSuccessToast(context, 'Verification email sent!');
    } catch (e) {
      if (mounted) showErrorToast(context, 'Failed to send verification');
    }
  }

  void _signOut() async {
    HapticService.warning();
    await AuthService.signOut();
    if (mounted) context.go(AppRoutes.login);
  }

  void _deleteAccount() {
    HapticService.warning();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surfaceDark,
        title: 'Delete Account?'.text.color(AppColors.textPrimaryDark).make(),
        content:
            'This action cannot be undone. All your data will be permanently deleted.'
                .text
                .color(AppColors.textSecondaryDark)
                .make(),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: 'Cancel'.text.color(AppColors.textMutedDark).make(),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(ctx);
              try {
                await AuthService.deleteAccount();
                if (mounted) context.go(AppRoutes.login);
              } catch (e) {
                if (mounted)
                  showErrorToast(context, 'Failed to delete account');
              }
            },
            child: 'Delete'.text.color(AppColors.error).make(),
          ),
        ],
      ),
    );
  }
}
