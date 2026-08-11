// lib/shared/widgets/inputs/app_dropdown_field.dart
import 'package:flutter/material.dart';
import 'package:leave_manager/core/utils/extenstions/theme_extension.dart';

class AppDropdownField<T> extends StatelessWidget {
  final T? value;
  final String label;
  final IconData prefixIcon;
  final List<DropdownMenuItem<T>> items;
  final void Function(T?)? onChanged;
  final Color? iconColor;

  const AppDropdownField({
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
    return DropdownButtonFormField<T>(
      initialValue: value,
      dropdownColor: context.colorScheme.surface,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(
          prefixIcon,
          color: iconColor ?? context.colorScheme.primary,
        ),
      ),
      items: items,
      onChanged: onChanged,
    );
  }
}