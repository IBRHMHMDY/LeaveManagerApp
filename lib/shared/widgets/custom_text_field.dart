// lib/shared/widgets/custom_text_field.dart
import 'package:flutter/material.dart';
import 'package:leave_manager/core/constants/app_spacing.dart';

class CustomTextField extends StatelessWidget {
  final String label;
  final IconData icon;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final TextEditingController? controller;

  const CustomTextField({
    super.key,
    required this.label,
    required this.icon,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: AppSpacing.md),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        validator: validator,
        // تم إزالة الأنماط الثابتة للسماح لـ AppTheme بتطبيق خطوط Cairo الموحدة
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
        ),
      ),
    );
  }
}