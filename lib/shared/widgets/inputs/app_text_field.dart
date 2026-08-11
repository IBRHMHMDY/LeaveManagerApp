// lib/shared/widgets/inputs/app_text_field.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:leave_manager/core/constants/app_spacing.dart';

class AppTextField extends StatelessWidget {
  final String label;
  final IconData icon;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final TextEditingController? controller;
  final void Function(String)? onChanged; // إضافة onChanged للمزيد من المرونة
  final List<TextInputFormatter>? inputFormatters;
  
  const AppTextField({
    super.key,
    required this.label,
    required this.icon,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.controller,
    this.onChanged,
    this.inputFormatters,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        validator: validator,
        onChanged: onChanged,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
        ),
        inputFormatters: inputFormatters,
      ),
    );
  }
}