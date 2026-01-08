import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:gap/gap.dart';

import 'package:mess_manager/core/theme/app_theme.dart';

/// Reusable form widgets using flutter_form_builder
///
/// Example usage:
/// ```dart
/// final formKey = GlobalKey<FormBuilderState>();
///
/// FormBuilder(
///   key: formKey,
///   child: Column(
///     children: [
///       AppFormTextField(name: 'name', label: 'Full Name', isRequired: true),
///       AppFormDropdown<String>(name: 'role', label: 'Role', options: roles),
///       AppFormDatePicker(name: 'date', label: 'Date'),
///       AppFormSwitch(name: 'active', label: 'Active'),
///     ],
///   ),
/// )
///
/// // Submit
/// if (formKey.currentState?.saveAndValidate() ?? false) {
///   final data = formKey.currentState!.value;
/// }
/// ```

/// Common input decoration for all form fields
InputDecoration appInputDecoration({
  required String label,
  String? hint,
  IconData? prefixIcon,
  Widget? suffix,
}) {
  return InputDecoration(
    labelText: label,
    hintText: hint,
    prefixIcon: prefixIcon != null ? Icon(prefixIcon, size: 20) : null,
    suffix: suffix,
    filled: true,
    fillColor: AppColors.cardDark,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      borderSide: BorderSide(color: AppColors.borderDark),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      borderSide: BorderSide(color: AppColors.borderDark),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      borderSide: const BorderSide(color: AppColors.primary, width: 2),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      borderSide: const BorderSide(color: AppColors.error),
    ),
    contentPadding: const EdgeInsets.symmetric(
      horizontal: AppSpacing.md,
      vertical: AppSpacing.md,
    ),
  );
}

/// Text Field
class AppFormTextField extends StatelessWidget {
  final String name;
  final String label;
  final String? hint;
  final IconData? prefixIcon;
  final bool isRequired;
  final bool isEmail;
  final bool isPhone;
  final bool isPassword;
  final int? minLength;
  final int? maxLength;
  final int maxLines;
  final TextInputType? keyboardType;
  final String? initialValue;

  const AppFormTextField({
    super.key,
    required this.name,
    required this.label,
    this.hint,
    this.prefixIcon,
    this.isRequired = false,
    this.isEmail = false,
    this.isPhone = false,
    this.isPassword = false,
    this.minLength,
    this.maxLength,
    this.maxLines = 1,
    this.keyboardType,
    this.initialValue,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: FormBuilderTextField(
        name: name,
        initialValue: initialValue,
        decoration: appInputDecoration(
          label: label,
          hint: hint,
          prefixIcon: prefixIcon,
        ),
        obscureText: isPassword,
        maxLines: isPassword ? 1 : maxLines,
        keyboardType:
            keyboardType ??
            (isEmail
                ? TextInputType.emailAddress
                : isPhone
                ? TextInputType.phone
                : TextInputType.text),
        validator: FormBuilderValidators.compose([
          if (isRequired) FormBuilderValidators.required(),
          if (isEmail) FormBuilderValidators.email(),
          if (minLength != null) FormBuilderValidators.minLength(minLength!),
          if (maxLength != null) FormBuilderValidators.maxLength(maxLength!),
        ]),
      ),
    );
  }
}

/// Number Field
class AppFormNumberField extends StatelessWidget {
  final String name;
  final String label;
  final String? hint;
  final IconData? prefixIcon;
  final bool isRequired;
  final num? min;
  final num? max;
  final num? initialValue;

  const AppFormNumberField({
    super.key,
    required this.name,
    required this.label,
    this.hint,
    this.prefixIcon,
    this.isRequired = false,
    this.min,
    this.max,
    this.initialValue,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: FormBuilderTextField(
        name: name,
        initialValue: initialValue?.toString(),
        decoration: appInputDecoration(
          label: label,
          hint: hint,
          prefixIcon: prefixIcon ?? LucideIcons.hash,
        ),
        keyboardType: TextInputType.number,
        valueTransformer: (value) => num.tryParse(value ?? ''),
        validator: FormBuilderValidators.compose([
          if (isRequired) FormBuilderValidators.required(),
          FormBuilderValidators.numeric(),
          if (min != null) FormBuilderValidators.min(min!),
          if (max != null) FormBuilderValidators.max(max!),
        ]),
      ),
    );
  }
}

/// Dropdown Field
class AppFormDropdown<T> extends StatelessWidget {
  final String name;
  final String label;
  final List<DropdownMenuItem<T>> items;
  final T? initialValue;
  final bool isRequired;
  final IconData? prefixIcon;

  const AppFormDropdown({
    super.key,
    required this.name,
    required this.label,
    required this.items,
    this.initialValue,
    this.isRequired = false,
    this.prefixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: FormBuilderDropdown<T>(
        name: name,
        initialValue: initialValue,
        decoration: appInputDecoration(label: label, prefixIcon: prefixIcon),
        items: items,
        validator: isRequired ? FormBuilderValidators.required() : null,
      ),
    );
  }
}

/// Date Picker
class AppFormDatePicker extends StatelessWidget {
  final String name;
  final String label;
  final DateTime? initialValue;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final bool isRequired;

  const AppFormDatePicker({
    super.key,
    required this.name,
    required this.label,
    this.initialValue,
    this.firstDate,
    this.lastDate,
    this.isRequired = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: FormBuilderDateTimePicker(
        name: name,
        initialValue: initialValue,
        inputType: InputType.date,
        format: null, // Uses locale default
        decoration: appInputDecoration(
          label: label,
          prefixIcon: LucideIcons.calendar,
        ),
        firstDate: firstDate ?? DateTime(2020),
        lastDate: lastDate ?? DateTime(2030),
        validator: isRequired ? FormBuilderValidators.required() : null,
      ),
    );
  }
}

/// Switch Field
class AppFormSwitch extends StatelessWidget {
  final String name;
  final String label;
  final String? subtitle;
  final bool initialValue;

  const AppFormSwitch({
    super.key,
    required this.name,
    required this.label,
    this.subtitle,
    this.initialValue = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: FormBuilderSwitch(
        name: name,
        initialValue: initialValue,
        title: VStack(crossAlignment: CrossAxisAlignment.start, [
          label.text.semiBold.make(),
          if (subtitle != null) subtitle!.text.xs.gray500.make(),
        ]),
        decoration: const InputDecoration(border: InputBorder.none),
        activeColor: AppColors.primary,
      ),
    );
  }
}

/// Radio Group
class AppFormRadioGroup<T> extends StatelessWidget {
  final String name;
  final String label;
  final List<FormBuilderFieldOption<T>> options;
  final T? initialValue;
  final bool isRequired;

  const AppFormRadioGroup({
    super.key,
    required this.name,
    required this.label,
    required this.options,
    this.initialValue,
    this.isRequired = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          label.text.semiBold.make(),
          const Gap(AppSpacing.sm),
          FormBuilderRadioGroup<T>(
            name: name,
            initialValue: initialValue,
            options: options,
            decoration: const InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.zero,
            ),
            validator: isRequired ? FormBuilderValidators.required() : null,
            activeColor: AppColors.primary,
          ),
        ],
      ),
    );
  }
}

/// Checkbox Group
class AppFormCheckboxGroup<T> extends StatelessWidget {
  final String name;
  final String label;
  final List<FormBuilderFieldOption<T>> options;
  final List<T>? initialValue;
  final bool isRequired;

  const AppFormCheckboxGroup({
    super.key,
    required this.name,
    required this.label,
    required this.options,
    this.initialValue,
    this.isRequired = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          label.text.semiBold.make(),
          const Gap(AppSpacing.sm),
          FormBuilderCheckboxGroup<T>(
            name: name,
            initialValue: initialValue,
            options: options,
            decoration: const InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.zero,
            ),
            validator: isRequired
                ? FormBuilderValidators.minLength(
                    1,
                    errorText: 'Select at least one option',
                  )
                : null,
            activeColor: AppColors.primary,
          ),
        ],
      ),
    );
  }
}

/// Amount Field (with currency prefix)
class AppFormAmountField extends StatelessWidget {
  final String name;
  final String label;
  final bool isRequired;
  final num? min;
  final num? max;
  final num? initialValue;

  const AppFormAmountField({
    super.key,
    required this.name,
    required this.label,
    this.isRequired = false,
    this.min,
    this.max,
    this.initialValue,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: FormBuilderTextField(
        name: name,
        initialValue: initialValue?.toString(),
        decoration: InputDecoration(
          labelText: label,
          prefixText: '৳ ',
          prefixStyle: TextStyle(
            color: AppColors.textPrimaryDark,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
          filled: true,
          fillColor: AppColors.cardDark,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            borderSide: BorderSide(color: AppColors.borderDark),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            borderSide: BorderSide(color: AppColors.borderDark),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            borderSide: const BorderSide(
              color: AppColors.moneyPositive,
              width: 2,
            ),
          ),
        ),
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        valueTransformer: (value) => double.tryParse(value ?? ''),
        validator: FormBuilderValidators.compose([
          if (isRequired) FormBuilderValidators.required(),
          FormBuilderValidators.numeric(),
          if (min != null) FormBuilderValidators.min(min!),
          if (max != null) FormBuilderValidators.max(max!),
        ]),
      ),
    );
  }
}
