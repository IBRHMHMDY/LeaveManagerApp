// lib/shared/widgets/custom_dropdown_field.dart
import 'package:flutter/material.dart';
import 'package:leave_manager/core/constants/app_spacing.dart';
import 'package:leave_manager/core/utils/extenstions/theme_extension.dart';

class CustomDropdownField<T> extends StatelessWidget {
  final T? value;
  final String label;
  final IconData prefixIcon;
  final Color? iconColor;
  final List<DropdownMenuItem<T>> items;
  final void Function(T?)? onChanged;

  const CustomDropdownField({
    super.key,
    required this.value,
    required this.label,
    required this.prefixIcon,
    required this.items,
    required this.onChanged,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: AppSpacing.md),
      child: DropdownButtonFormField<T>(
        value: value,
        dropdownColor: context.colorScheme.surface,
        // تم إزالة style المضمن ليرث التنسيق من AppTheme الافتراضي
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(
            prefixIcon, 
            color: iconColor ?? context.colorScheme.primary,
          ),
        ),
        items: items,
        onChanged: onChanged,
      ),
    );
  }
}