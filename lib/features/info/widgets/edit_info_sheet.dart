import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:mess_manager/core/models/mess_info.dart';
import 'package:mess_manager/core/theme/app_theme.dart';
import 'package:mess_manager/features/info/providers/info_provider.dart';

class EditInfoSheet extends ConsumerStatefulWidget {
  const EditInfoSheet({super.key});

  @override
  ConsumerState<EditInfoSheet> createState() => _EditInfoSheetState();
}

class _EditInfoSheetState extends ConsumerState<EditInfoSheet> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  late TextEditingController _wifiController;
  late TextEditingController _wifiOffController;
  late TextEditingController _landlordNameController;
  late TextEditingController _landlordPhoneController;
  late TextEditingController _policeController;
  late TextEditingController _fireController;
  late TextEditingController _ambulanceController;
  late TextEditingController _gateCloseController;
  late TextEditingController _rule1Controller;
  late TextEditingController _rule2Controller;
  late TextEditingController _descoController;
  late TextEditingController _gasController;

  @override
  void initState() {
    super.initState();
    final info = ref.read(messInfoProvider);
    _wifiController = TextEditingController(text: info.wifiPassword);
    _wifiOffController = TextEditingController(text: info.wifiOffTime);
    _landlordNameController = TextEditingController(text: info.landlordName);
    _landlordPhoneController = TextEditingController(text: info.landlordPhone);
    _policeController = TextEditingController(text: info.policePhone);
    _fireController = TextEditingController(text: info.fireServicePhone);
    _ambulanceController = TextEditingController(text: info.ambulancePhone);
    _gateCloseController = TextEditingController(text: info.gateCloseTime);
    _rule1Controller = TextEditingController(text: info.rule1);
    _rule2Controller = TextEditingController(text: info.rule2);
    _descoController = TextEditingController(text: info.descoAccount);
    _gasController = TextEditingController(text: info.gasAccount);
  }

  @override
  void dispose() {
    _wifiController.dispose();
    _wifiOffController.dispose();
    _landlordNameController.dispose();
    _landlordPhoneController.dispose();
    _policeController.dispose();
    _fireController.dispose();
    _ambulanceController.dispose();
    _gateCloseController.dispose();
    _rule1Controller.dispose();
    _rule2Controller.dispose();
    _descoController.dispose();
    _gasController.dispose();
    super.dispose();
  }

  void _save() {
    if (_formKey.currentState!.validate()) {
      final newInfo = MessInfo(
        wifiPassword: _wifiController.text,
        wifiOffTime: _wifiOffController.text,
        landlordName: _landlordNameController.text,
        landlordPhone: _landlordPhoneController.text,
        policePhone: _policeController.text,
        fireServicePhone: _fireController.text,
        ambulancePhone: _ambulanceController.text,
        gateCloseTime: _gateCloseController.text,
        rule1: _rule1Controller.text,
        rule2: _rule2Controller.text,
        descoAccount: _descoController.text,
        gasAccount: _gasController.text,
      );

      ref.read(messInfoProvider.notifier).updateInfo(newInfo);
      Navigator.pop(context);

      // Show success
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Info updated successfully'),
          backgroundColor: AppColors.success,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
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
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.9,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            // Handle
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.borderDark,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const Gap(AppSpacing.lg),

            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Edit Mess Info',
                  style: AppTypography.headlineMedium.copyWith(
                    color: AppColors.textPrimaryDark,
                  ),
                ),
                TextButton(onPressed: _save, child: const Text('Save')),
              ],
            ),
            const Gap(AppSpacing.md),

            // Scrollable Content
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSection('WiFi', [
                      _buildTextField(
                        _wifiController,
                        'Password',
                        LucideIcons.wifi,
                      ),
                      _buildTextField(
                        _wifiOffController,
                        'Auto-Off Time',
                        LucideIcons.clock,
                      ),
                    ]),
                    _buildSection('Landlord', [
                      _buildTextField(
                        _landlordNameController,
                        'Name',
                        LucideIcons.user,
                      ),
                      _buildTextField(
                        _landlordPhoneController,
                        'Phone',
                        LucideIcons.phone,
                      ),
                    ]),
                    _buildSection('Rules', [
                      _buildTextField(
                        _gateCloseController,
                        'Gate Close Time',
                        LucideIcons.lock,
                      ),
                      _buildTextField(
                        _rule1Controller,
                        'Rule 1',
                        LucideIcons.alertCircle,
                      ),
                      _buildTextField(
                        _rule2Controller,
                        'Rule 2',
                        LucideIcons.alertCircle,
                      ),
                    ]),
                    _buildSection('Accounts', [
                      _buildTextField(
                        _descoController,
                        'DESCO Account',
                        LucideIcons.zap,
                      ),
                      _buildTextField(
                        _gasController,
                        'Gas Account',
                        LucideIcons.flame,
                      ),
                    ]),
                    _buildSection('Emergency', [
                      _buildTextField(
                        _policeController,
                        'Police Phone',
                        LucideIcons.shield,
                      ),
                      _buildTextField(
                        _fireController,
                        'Fire Phone',
                        LucideIcons.flame,
                      ),
                      _buildTextField(
                        _ambulanceController,
                        'Ambulance Phone',
                        LucideIcons.heartPulse,
                      ),
                    ]),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Text(
            title,
            style: AppTypography.titleSmall.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        ...children,
        const Gap(AppSpacing.md),
      ],
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label,
    IconData icon,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, size: 18, color: AppColors.textSecondaryDark),
        ),
        validator: (v) => v?.isEmpty == true ? 'Required' : null,
      ),
    );
  }
}
