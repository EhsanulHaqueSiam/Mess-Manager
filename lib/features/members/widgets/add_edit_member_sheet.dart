import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:mess_manager/core/models/member.dart';
import 'package:mess_manager/core/providers/members_provider.dart';
import 'package:mess_manager/core/theme/app_theme.dart';
import 'package:uuid/uuid.dart';

class AddEditMemberSheet extends ConsumerStatefulWidget {
  final Member? member;

  const AddEditMemberSheet({super.key, this.member});

  @override
  ConsumerState<AddEditMemberSheet> createState() => _AddEditMemberSheetState();
}

class _AddEditMemberSheetState extends ConsumerState<AddEditMemberSheet> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _allergenController;
  late MemberRole _selectedRole;
  late Set<RestrictionType> _selectedRestrictions;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.member?.name ?? '');
    _phoneController = TextEditingController(text: widget.member?.phone ?? '');
    _allergenController = TextEditingController();
    _selectedRole = widget.member?.role ?? MemberRole.member;

    // Initialize restrictions from existing preferences
    _selectedRestrictions = {};
    if (widget.member != null) {
      for (final pref in widget.member!.preferences) {
        _selectedRestrictions.add(pref.type);
        if (pref.type == RestrictionType.allergic && pref.allergen != null) {
          _allergenController.text = pref.allergen!;
        }
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _allergenController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.member != null;

    return Container(
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
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Handle
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

            // Title
            Text(
              isEditing ? 'Edit Member' : 'Add New Member',
              style: AppTypography.headlineMedium.copyWith(
                color: AppColors.textPrimaryDark,
              ),
            ),
            const Gap(AppSpacing.lg),

            // Name
            TextFormField(
              controller: _nameController,
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.textPrimaryDark,
              ),
              decoration: const InputDecoration(
                labelText: 'Name',
                prefixIcon: Icon(LucideIcons.user, size: 18),
              ),
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'Name is required' : null,
            ),
            const Gap(AppSpacing.md),

            // Phone
            TextFormField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.textPrimaryDark,
              ),
              decoration: const InputDecoration(
                labelText: 'Phone (Optional)',
                prefixIcon: Icon(LucideIcons.phone, size: 18),
              ),
            ),
            const Gap(AppSpacing.md),

            // Role Dropdown
            DropdownButtonFormField<MemberRole>(
              value: _selectedRole,
              dropdownColor: AppColors.cardDark,
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.textPrimaryDark,
              ),
              decoration: const InputDecoration(
                labelText: 'Role',
                prefixIcon: Icon(LucideIcons.shield, size: 18),
              ),
              items: MemberRole.values.map((role) {
                return DropdownMenuItem(
                  value: role,
                  child: Text(
                    role.name.toUpperCase(),
                    style: AppTypography.bodyMedium.copyWith(
                      color: AppColors.textPrimaryDark,
                    ),
                  ),
                );
              }).toList(),
              onChanged: (val) {
                if (val != null) setState(() => _selectedRole = val);
              },
            ),
            const Gap(AppSpacing.md),

            // Dietary Preferences
            Text(
              'Dietary Preferences',
              style: AppTypography.labelMedium.copyWith(
                color: AppColors.textSecondaryDark,
              ),
            ),
            const Gap(AppSpacing.sm),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _buildRestrictionChip(
                  RestrictionType.noBeef,
                  'No Beef',
                  LucideIcons.leafyGreen,
                ),
                _buildRestrictionChip(
                  RestrictionType.noPork,
                  'No Pork',
                  LucideIcons.ban,
                ),
                _buildRestrictionChip(
                  RestrictionType.vegetarian,
                  'Vegetarian',
                  LucideIcons.salad,
                ),
                _buildRestrictionChip(
                  RestrictionType.vegan,
                  'Vegan',
                  LucideIcons.vegan,
                ),
                _buildRestrictionChip(
                  RestrictionType.allergic,
                  'Allergic',
                  LucideIcons.alertTriangle,
                ),
              ],
            ),

            // Allergen field (only if allergic selected)
            if (_selectedRestrictions.contains(RestrictionType.allergic)) ...[
              const Gap(AppSpacing.sm),
              TextFormField(
                controller: _allergenController,
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.textPrimaryDark,
                ),
                decoration: const InputDecoration(
                  labelText: 'Allergens (e.g., Peanuts, Shellfish)',
                  prefixIcon: Icon(LucideIcons.alertCircle, size: 18),
                ),
              ),
            ],
            const Gap(AppSpacing.xl),

            // Save Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _isLoading ? null : _save,
                icon: _isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(LucideIcons.check, size: 18),
                label: Text(isEditing ? 'Update Member' : 'Add Member'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRestrictionChip(
    RestrictionType type,
    String label,
    IconData icon,
  ) {
    final isSelected = _selectedRestrictions.contains(type);
    return FilterChip(
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 14,
            color: isSelected ? Colors.white : AppColors.textSecondaryDark,
          ),
          const Gap(4),
          Text(label),
        ],
      ),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          if (selected) {
            _selectedRestrictions.add(type);
          } else {
            _selectedRestrictions.remove(type);
          }
        });
      },
      selectedColor: AppColors.warning,
      checkmarkColor: Colors.white,
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : AppColors.textPrimaryDark,
        fontSize: 12,
      ),
    );
  }

  List<FoodPreference> _buildPreferences() {
    return _selectedRestrictions.map((type) {
      return FoodPreference(
        type: type,
        allergen: type == RestrictionType.allergic
            ? _allergenController.text.trim()
            : null,
      );
    }).toList();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final name = _nameController.text.trim();
      final phone = _phoneController.text.trim();
      final preferences = _buildPreferences();

      if (widget.member != null) {
        // Edit mode
        final updated = widget.member!.copyWith(
          name: name,
          phone: phone.isNotEmpty ? phone : null,
          role: _selectedRole,
          preferences: preferences,
        );
        await ref.read(membersProvider.notifier).updateMember(updated);
      } else {
        // Add mode
        final newMember = Member(
          id: const Uuid().v4(),
          name: name,
          phone: phone.isNotEmpty ? phone : null,
          role: _selectedRole,
          preferences: preferences,
          joinedAt: DateTime.now(),
        );
        await ref.read(membersProvider.notifier).addMember(newMember);
      }

      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              widget.member != null ? 'Member updated' : 'Member added',
            ),
            backgroundColor: AppColors.success,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }
}
