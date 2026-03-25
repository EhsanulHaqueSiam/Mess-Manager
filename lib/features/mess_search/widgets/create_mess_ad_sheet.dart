import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gap/gap.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lucide_icons/lucide_icons.dart';

import 'package:mess_manager/core/models/mess_ad.dart';
import 'package:mess_manager/core/theme/app_theme.dart';
import 'package:mess_manager/core/services/haptic_service.dart';
import 'package:mess_manager/core/widgets/app_components.dart';
import 'package:mess_manager/features/mess_search/providers/mess_search_provider.dart';

/// Bottom sheet for creating a new mess advertisement.
class CreateMessAdSheet extends ConsumerStatefulWidget {
  const CreateMessAdSheet({super.key});

  static Future<void> show(BuildContext context) {
    HapticService.modalOpen();
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const CreateMessAdSheet(),
    );
  }

  @override
  ConsumerState<CreateMessAdSheet> createState() => _CreateMessAdSheetState();
}

class _CreateMessAdSheetState extends ConsumerState<CreateMessAdSheet> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _locationController = TextEditingController();
  final _contactController = TextEditingController();
  final _rentController = TextEditingController();
  int _membersNeeded = 1;
  final List<String> _imagePaths = [];
  final List<String> _selectedAmenities = [];
  final _picker = ImagePicker();

  static const _allAmenities = [
    'WiFi',
    'Gas',
    'Water',
    'AC',
    'Security',
    'Lift',
    'Generator',
    'Gym',
    'Parking',
    'Cook',
    'Laundry',
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    _contactController.dispose();
    _rentController.dispose();
    super.dispose();
  }

  Future<void> _pickImages() async {
    final images = await _picker.pickMultiImage(
      imageQuality: 70,
      maxWidth: 1200,
      maxHeight: 1200,
    );
    if (images.isNotEmpty) {
      setState(() {
        _imagePaths.addAll(images.map((f) => f.path));
      });
      HapticService.lightTap();
    }
  }

  void _removeImage(int index) {
    setState(() => _imagePaths.removeAt(index));
    HapticService.lightTap();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    if (_imagePaths.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Add at least one photo')),
      );
      return;
    }

    HapticService.success();
    final ad = MessAd(
      id: 'ad_${DateTime.now().millisecondsSinceEpoch}',
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      location: _locationController.text.trim(),
      contactNumber: _contactController.text.trim(),
      membersNeeded: _membersNeeded,
      rentPerPerson: double.tryParse(_rentController.text.trim()),
      imageUrls: _imagePaths,
      postedBy: 'current_user',
      postedByName: 'You',
      createdAt: DateTime.now(),
      amenities: _selectedAmenities,
    );

    ref.read(messSearchProvider.notifier).addAd(ad);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return ClipRRect(
      borderRadius: const BorderRadius.vertical(
        top: Radius.circular(AppSpacing.radiusXl),
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.92,
          ),
          decoration: BoxDecoration(
            color: const Color(0xFF0D1520).withValues(alpha: 0.95),
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(AppSpacing.radiusXl),
            ),
            border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
          ),
          child: Padding(
            padding: EdgeInsets.only(bottom: bottomInset),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Handle + title
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.lg, AppSpacing.md, AppSpacing.lg, 0,
                  ),
                  child: Column(
                    children: [
                      // Gradient handle
                      Container(
                        width: 36,
                        height: 4,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(2),
                          gradient: const LinearGradient(
                            colors: [AppColors.accent, AppColors.accentAlt],
                          ),
                        ),
                      ),
                      const Gap(AppSpacing.md),
                      Row(
                        children: [
                          Icon(LucideIcons.megaphone,
                              color: AppColors.accent, size: 20),
                          const Gap(AppSpacing.sm),
                          Text(
                            'Post mess ad',
                            style: AppTypography.headlineMedium.copyWith(
                              color: AppColors.textPrimaryDark,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const Gap(AppSpacing.md),

                // Scrollable form
                Flexible(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.lg,
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Image picker
                          _buildImagePicker(),
                          const Gap(AppSpacing.md),

                          AppInput(
                            label: 'Title',
                            hint: 'e.g. Sunny Corner Mess',
                            controller: _titleController,
                            prefixIcon: LucideIcons.home,
                            validator: (v) =>
                                v == null || v.trim().isEmpty ? 'Required' : null,
                          ),
                          const Gap(AppSpacing.md),

                          AppInput(
                            label: 'Description',
                            hint: 'Describe the living space, facilities...',
                            controller: _descriptionController,
                            maxLines: 3,
                            validator: (v) =>
                                v == null || v.trim().isEmpty ? 'Required' : null,
                          ),
                          const Gap(AppSpacing.md),

                          AppInput(
                            label: 'Location',
                            hint: 'e.g. Mirpur-10, Dhaka',
                            controller: _locationController,
                            prefixIcon: LucideIcons.mapPin,
                            validator: (v) =>
                                v == null || v.trim().isEmpty ? 'Required' : null,
                          ),
                          const Gap(AppSpacing.md),

                          AppInput(
                            label: 'Contact number',
                            hint: '+880 1XXX-XXXXXX',
                            controller: _contactController,
                            prefixIcon: LucideIcons.phone,
                            keyboardType: TextInputType.phone,
                            validator: (v) =>
                                v == null || v.trim().isEmpty ? 'Required' : null,
                          ),
                          const Gap(AppSpacing.md),

                          AppInput(
                            label: 'Rent per person (optional)',
                            hint: 'e.g. 5500',
                            controller: _rentController,
                            prefixIcon: LucideIcons.banknote,
                            keyboardType: TextInputType.number,
                          ),
                          const Gap(AppSpacing.lg),

                          // Members needed selector
                          _buildMembersSelector(),
                          const Gap(AppSpacing.lg),

                          // Amenities
                          _buildAmenitiesPicker(),
                          const Gap(AppSpacing.lg),

                          // Submit button
                          AppPrimaryButton(
                            text: 'Post ad',
                            icon: LucideIcons.send,
                            onPressed: _submit,
                          ),
                          const Gap(AppSpacing.xl),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildImagePicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Photos',
          style: AppTypography.labelMedium.copyWith(
            color: AppColors.textSecondaryDark,
          ),
        ),
        const Gap(AppSpacing.sm),
        SizedBox(
          height: 100,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              // Add button
              GestureDetector(
                onTap: _pickImages,
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                    border: Border.all(
                      color: AppColors.accent.withValues(alpha: 0.3),
                      width: 1.5,
                    ),
                    color: AppColors.accent.withValues(alpha: 0.05),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(LucideIcons.camera,
                          color: AppColors.accent, size: 24),
                      const Gap(4),
                      Text(
                        'Add',
                        style: AppTypography.labelSmall.copyWith(
                          color: AppColors.accent,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Thumbnails
              ..._imagePaths.asMap().entries.map((entry) {
                return Padding(
                  padding: const EdgeInsets.only(left: AppSpacing.sm),
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius:
                            BorderRadius.circular(AppSpacing.radiusMd),
                        child: Image.file(
                          File(entry.value),
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Positioned(
                        top: 4,
                        right: 4,
                        child: GestureDetector(
                          onTap: () => _removeImage(entry.key),
                          child: Container(
                            padding: const EdgeInsets.all(3),
                            decoration: BoxDecoration(
                              color: Colors.black.withValues(alpha: 0.6),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.close,
                              size: 14,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMembersSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Members needed',
          style: AppTypography.labelMedium.copyWith(
            color: AppColors.textSecondaryDark,
          ),
        ),
        const Gap(AppSpacing.sm),
        Row(
          children: List.generate(4, (i) {
            final count = i + 1;
            final label = count == 4 ? '4+' : '$count';
            final selected = _membersNeeded == count;
            return Expanded(
              child: GestureDetector(
                onTap: () {
                  HapticService.lightTap();
                  setState(() => _membersNeeded = count);
                },
                child: AnimatedContainer(
                  duration: 200.ms,
                  margin: EdgeInsets.only(right: i < 3 ? AppSpacing.sm : 0),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    borderRadius:
                        BorderRadius.circular(AppSpacing.radiusMd),
                    color: selected
                        ? AppColors.accent.withValues(alpha: 0.15)
                        : Colors.white.withValues(alpha: 0.05),
                    border: Border.all(
                      color: selected
                          ? AppColors.accent.withValues(alpha: 0.5)
                          : Colors.white.withValues(alpha: 0.07),
                    ),
                  ),
                  child: Column(
                    children: [
                      Text(
                        label,
                        style: AppTypography.headlineMedium.copyWith(
                          color: selected
                              ? AppColors.accent
                              : AppColors.textSecondaryDark,
                        ),
                      ),
                      Text(
                        count == 1 ? 'seat' : 'seats',
                        style: AppTypography.labelSmall.copyWith(
                          color: selected
                              ? AppColors.accent.withValues(alpha: 0.7)
                              : AppColors.textMutedDark,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildAmenitiesPicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Amenities',
          style: AppTypography.labelMedium.copyWith(
            color: AppColors.textSecondaryDark,
          ),
        ),
        const Gap(AppSpacing.sm),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _allAmenities.map((amenity) {
            final selected = _selectedAmenities.contains(amenity);
            return GestureDetector(
              onTap: () {
                HapticService.lightTap();
                setState(() {
                  if (selected) {
                    _selectedAmenities.remove(amenity);
                  } else {
                    _selectedAmenities.add(amenity);
                  }
                });
              },
              child: AnimatedContainer(
                duration: 200.ms,
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 7,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                  color: selected
                      ? AppColors.accentAlt.withValues(alpha: 0.15)
                      : Colors.white.withValues(alpha: 0.05),
                  border: Border.all(
                    color: selected
                        ? AppColors.accentAlt.withValues(alpha: 0.4)
                        : Colors.white.withValues(alpha: 0.08),
                  ),
                ),
                child: Text(
                  amenity,
                  style: AppTypography.labelMedium.copyWith(
                    color: selected
                        ? AppColors.accentAlt
                        : AppColors.textSecondaryDark,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
