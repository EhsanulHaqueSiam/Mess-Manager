import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:go_router/go_router.dart';
import 'package:gap/gap.dart';
import 'package:image_picker/image_picker.dart';

import 'package:mess_manager/core/theme/app_theme.dart';
import 'package:mess_manager/core/router/app_router.dart';
import 'package:mess_manager/core/services/auth_service.dart';
import 'package:mess_manager/core/services/haptic_service.dart';
import 'package:mess_manager/core/widgets/app_components.dart';
import 'package:mess_manager/features/auth/providers/auth_provider.dart';

/// Profile Screen - Cosmic Bioluminescence Design
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

  Future<void> _pickProfileImage() async {
    HapticService.modalOpen();

    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => ClipRRect(
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(AppSpacing.radiusLg),
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFF0D1520).withValues(alpha: 0.95),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(AppSpacing.radiusLg),
              ),
              border: Border.all(color: AppColors.primaryLight.withValues(alpha: 0.18)),
            ),
            child: SafeArea(
              child: Wrap(
                children: [
                  Center(
                    child: Container(
                      margin: const EdgeInsets.only(top: 12, bottom: 8),
                      width: 40, height: 4,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  ListTile(
                    leading: Container(
                      width: 36, height: 36,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(colors: [
                          AppColors.primary.withValues(alpha: 0.3),
                          AppColors.primary.withValues(alpha: 0.05),
                        ]),
                      ),
                      child: const Icon(LucideIcons.camera, color: AppColors.primary, size: 18),
                    ),
                    title: Text('Take Photo', style: TextStyle(color: Colors.white.withValues(alpha: 0.9))),
                    onTap: () => Navigator.pop(context, ImageSource.camera),
                  ),
                  ListTile(
                    leading: Container(
                      width: 36, height: 36,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(colors: [
                          AppColors.accentAlt.withValues(alpha: 0.3),
                          AppColors.accentAlt.withValues(alpha: 0.05),
                        ]),
                      ),
                      child: const Icon(LucideIcons.image, color: AppColors.accentAlt, size: 18),
                    ),
                    title: Text('Choose from Gallery', style: TextStyle(color: Colors.white.withValues(alpha: 0.9))),
                    onTap: () => Navigator.pop(context, ImageSource.gallery),
                  ),
                  const Gap(AppSpacing.md),
                ],
              ),
            ),
          ),
        ),
      ),
    );

    if (source == null) return;

    try {
      final pickedFile = await _imagePicker.pickImage(
        source: source, maxWidth: 512, maxHeight: 512, imageQuality: 85,
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
      backgroundColor: const Color(0xFF0A0E1A),
      body: Stack(
        children: [
          // Deep space background
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter, end: Alignment.bottomCenter,
                  colors: [Color(0xFF0A0E1A), Color(0xFF0D1520)],
                ),
              ),
            ),
          ),

          // Accent orbs
          Positioned(
            top: -40, right: -60,
            child: Container(
              width: 180, height: 180,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(colors: [
                  AppColors.accent.withValues(alpha: 0.10),
                  Colors.transparent,
                ]),
              ),
            ).animate(onPlay: (c) => c.repeat(reverse: true))
                .scaleXY(begin: 1.0, end: 1.15, duration: 4.seconds),
          ),
          Positioned(
            bottom: 100, left: -50,
            child: Container(
              width: 160, height: 160,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(colors: [
                  AppColors.primary.withValues(alpha: 0.08),
                  Colors.transparent,
                ]),
              ),
            ).animate(onPlay: (c) => c.repeat(reverse: true))
                .scaleXY(begin: 0.9, end: 1.1, duration: 5.seconds),
          ),

          // Main content
          SafeArea(
            child: Column(
              children: [
                // Header
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 8, 20, 0),
                  child: Row(
                    children: [
                      IconButton(
                        icon: Icon(LucideIcons.arrowLeft, color: Colors.white.withValues(alpha: 0.7)),
                        onPressed: () => context.pop(),
                      ),
                      Text(
                        'Profile',
                        style: AppTypography.headlineMedium.copyWith(
                          color: Colors.white, fontWeight: FontWeight.w700,
                        ),
                      ),
                      const Spacer(),
                      if (!_isEditing)
                        GestureDetector(
                          onTap: () {
                            HapticService.lightTap();
                            setState(() => _isEditing = true);
                          },
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: AppColors.primary.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(LucideIcons.pencil, size: 14, color: AppColors.primary),
                                    const Gap(4),
                                    Text('Edit', style: TextStyle(color: AppColors.primary, fontSize: 13, fontWeight: FontWeight.w600)),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ).animate().fadeIn(duration: 400.ms),
                ),

                // Scrollable content
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    child: Column(
                      children: [
                        // Profile Avatar
                        Center(
                          child: Stack(
                            children: [
                              Container(
                                width: 100, height: 100,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: _profileImagePath == null
                                      ? LinearGradient(colors: AppColors.gradientPrimary)
                                      : null,
                                  image: _profileImagePath != null
                                      ? DecorationImage(image: FileImage(File(_profileImagePath!)), fit: BoxFit.cover)
                                      : null,
                                  border: Border.all(color: AppColors.primary.withValues(alpha: 0.3), width: 2),
                                  boxShadow: [
                                    BoxShadow(color: AppColors.primary.withValues(alpha: 0.3), blurRadius: 20),
                                  ],
                                ),
                                child: _profileImagePath == null
                                    ? Center(
                                        child: Text(
                                          _getInitials(user?.displayName ?? user?.email ?? 'U'),
                                          style: AppTypography.headlineMedium.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
                                        ),
                                      )
                                    : null,
                              ),
                              Positioned(
                                bottom: 0, right: 0,
                                child: GestureDetector(
                                  onTap: _pickProfileImage,
                                  child: Container(
                                    width: 32, height: 32,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: AppColors.primary,
                                      border: Border.all(color: const Color(0xFF0A0E1A), width: 2),
                                    ),
                                    child: const Icon(LucideIcons.camera, size: 14, color: Colors.white),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ).animate().fadeIn().scale(begin: const Offset(0.9, 0.9)),
                        const Gap(20),

                        Text(
                          user?.displayName ?? 'User',
                          style: AppTypography.headlineSmall.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                        const Gap(4),
                        Text(
                          user?.email ?? '',
                          style: AppTypography.bodySmall.copyWith(color: Colors.white.withValues(alpha: 0.4)),
                          textAlign: TextAlign.center,
                        ),
                        const Gap(28),

                        if (_isEditing) ...[_buildEditForm()] else ...[_buildInfoCards(user)],
                        const Gap(32),
                        _buildActionButtons(),
                        const Gap(32),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEditForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          _buildSectionLabel('EDIT PROFILE'),
          const Gap(12),
          ClipRRect(
            borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                padding: const EdgeInsets.all(AppSpacing.lg),
                decoration: AppSpacing.accentCard(accent: AppColors.primaryLight, radius: AppSpacing.radiusLg),
                child: Column(
                  children: [
                    TextFormField(
                      controller: _nameController,
                      style: TextStyle(color: Colors.white.withValues(alpha: 0.9)),
                      decoration: InputDecoration(
                        labelText: 'Display Name',
                        labelStyle: TextStyle(color: Colors.white.withValues(alpha: 0.4)),
                        prefixIcon: Icon(LucideIcons.user, size: 18, color: Colors.white.withValues(alpha: 0.3)),
                        filled: true, fillColor: Colors.white.withValues(alpha: 0.03),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(AppSpacing.radiusMd), borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.06))),
                        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(AppSpacing.radiusMd), borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.06))),
                        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(AppSpacing.radiusMd), borderSide: BorderSide(color: AppColors.primary.withValues(alpha: 0.5))),
                      ),
                      validator: (v) => v?.isEmpty == true ? 'Name required' : null,
                    ),
                    const Gap(14),
                    TextFormField(
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      style: TextStyle(color: Colors.white.withValues(alpha: 0.9)),
                      decoration: InputDecoration(
                        labelText: 'Phone Number',
                        labelStyle: TextStyle(color: Colors.white.withValues(alpha: 0.4)),
                        prefixIcon: Icon(LucideIcons.phone, size: 18, color: Colors.white.withValues(alpha: 0.3)),
                        filled: true, fillColor: Colors.white.withValues(alpha: 0.03),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(AppSpacing.radiusMd), borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.06))),
                        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(AppSpacing.radiusMd), borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.06))),
                        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(AppSpacing.radiusMd), borderSide: BorderSide(color: AppColors.primary.withValues(alpha: 0.5))),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const Gap(20),
          Row(
            children: [
              Expanded(
                child: AppSecondaryButton(
                  text: 'Cancel',
                  onPressed: () {
                    _loadUserData();
                    setState(() => _isEditing = false);
                  },
                ),
              ),
              const Gap(16),
              Expanded(
                child: AppPrimaryButton(
                  text: 'Save',
                  isLoading: _isLoading,
                  onPressed: _saveProfile,
                ),
              ),
            ],
          ),
        ],
      ),
    ).animate().fadeIn().slideY(begin: 0.05);
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

  Widget _buildInfoCards(dynamic user) {
    return Column(
      children: [
        _buildGlassInfoCard(icon: LucideIcons.mail, label: 'Email', value: user?.email ?? 'Not set', color: AppColors.primary, delay: 100),
        _buildGlassInfoCard(icon: LucideIcons.phone, label: 'Phone', value: user?.phoneNumber ?? 'Not set', color: AppColors.info, delay: 150),
        _buildGlassInfoCard(icon: LucideIcons.shieldCheck, label: 'Account Status', value: user?.emailVerified == true ? 'Verified' : 'Not Verified', color: user?.emailVerified == true ? AppColors.success : AppColors.warning, delay: 200),
        _buildGlassInfoCard(icon: LucideIcons.calendar, label: 'Member Since', value: _formatDate(user?.metadata?.creationTime), color: AppColors.secondary, delay: 250),
      ],
    );
  }

  Widget _buildGlassInfoCard({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
    required int delay,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
          child: Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: AppSpacing.accentCard(accent: AppColors.primaryLight, radius: AppSpacing.radiusMd),
            child: Row(
              children: [
                Container(
                  width: 40, height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(colors: [color.withValues(alpha: 0.25), color.withValues(alpha: 0.04)]),
                    border: Border.all(color: color.withValues(alpha: 0.15)),
                  ),
                  child: Icon(icon, color: color, size: 18),
                ),
                const Gap(12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(label, style: AppTypography.bodySmall.copyWith(color: Colors.white.withValues(alpha: 0.35), fontSize: 11)),
                      Text(value, style: TextStyle(color: Colors.white.withValues(alpha: 0.9), fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ).animate(delay: delay.ms).fadeIn().slideX(begin: 0.05);
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        _buildSectionLabel('ACCOUNT ACTIONS'),
        const Gap(12),
        _buildGlassActionTile(icon: LucideIcons.key, label: 'Change Password', color: AppColors.info, onTap: _changePassword, delay: 300),
        _buildGlassActionTile(icon: LucideIcons.mailCheck, label: 'Verify Email', color: AppColors.success, onTap: _verifyEmail, delay: 350),
        const Gap(16),
        // Sign Out
        GestureDetector(
          onTap: _signOut,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: AppSpacing.accentCard(accent: AppColors.error, radius: AppSpacing.radiusMd),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(LucideIcons.logOut, size: 18, color: AppColors.error.withValues(alpha: 0.8)),
                    const Gap(8),
                    Text('Sign Out', style: TextStyle(color: AppColors.error.withValues(alpha: 0.8), fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
            ),
          ),
        ).animate(delay: 400.ms).fadeIn(),
        const Gap(12),
        TextButton(
          onPressed: _deleteAccount,
          child: Text('Delete Account', style: TextStyle(color: AppColors.error.withValues(alpha: 0.5), fontSize: 13)),
        ).animate(delay: 450.ms).fadeIn(),
      ],
    );
  }

  Widget _buildGlassActionTile({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
    required int delay,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: GestureDetector(
        onTap: onTap,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
            child: Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: AppSpacing.accentCard(accent: AppColors.primaryLight, radius: AppSpacing.radiusMd),
              child: Row(
                children: [
                  Container(
                    width: 36, height: 36,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(colors: [color.withValues(alpha: 0.25), color.withValues(alpha: 0.04)]),
                    ),
                    child: Icon(icon, color: color, size: 16),
                  ),
                  const Gap(12),
                  Expanded(child: Text(label, style: TextStyle(color: Colors.white.withValues(alpha: 0.8)))),
                  Icon(LucideIcons.chevronRight, size: 16, color: Colors.white.withValues(alpha: 0.2)),
                ],
              ),
            ),
          ),
        ),
      ),
    ).animate(delay: delay.ms).fadeIn();
  }

  String _getInitials(String name) {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
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
      await ref.read(authProvider.notifier).updateProfile(name: name, phone: phone.isNotEmpty ? phone : null, avatarUrl: _profileImagePath);
      if (mounted) {
        showSuccessToast(context, 'Profile updated!');
        setState(() { _isEditing = false; _isLoading = false; });
      }
    } catch (e) {
      if (mounted) { showErrorToast(context, 'Failed to update profile'); setState(() => _isLoading = false); }
    }
  }

  void _changePassword() async {
    HapticService.lightTap();
    final email = AuthService.currentUser?.email;
    if (email == null) { showErrorToast(context, 'No email associated with account'); return; }
    try {
      await AuthService.sendPasswordResetEmail(email);
      if (mounted) showSuccessToast(context, 'Password reset email sent!');
    } catch (e) { if (mounted) showErrorToast(context, 'Failed to send reset email'); }
  }

  void _verifyEmail() async {
    HapticService.lightTap();
    try {
      await AuthService.currentUser?.sendEmailVerification();
      if (mounted) showSuccessToast(context, 'Verification email sent!');
    } catch (e) { if (mounted) showErrorToast(context, 'Failed to send verification'); }
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
        backgroundColor: const Color(0xFF0D1520),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
          side: BorderSide(color: Colors.white.withValues(alpha: 0.08)),
        ),
        title: Text('Delete Account?', style: TextStyle(color: Colors.white.withValues(alpha: 0.9))),
        content: Text('This action cannot be undone. All your data will be permanently deleted.', style: TextStyle(color: Colors.white.withValues(alpha: 0.5))),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: Text('Cancel', style: TextStyle(color: Colors.white.withValues(alpha: 0.4)))),
          TextButton(
            onPressed: () async {
              Navigator.pop(ctx);
              try { await AuthService.deleteAccount(); if (mounted) context.go(AppRoutes.login); }
              catch (e) { if (mounted) showErrorToast(context, 'Failed to delete account'); }
            },
            child: const Text('Delete', style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );
  }
}
