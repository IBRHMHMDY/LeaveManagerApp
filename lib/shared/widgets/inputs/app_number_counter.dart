// lib/shared/widgets/inputs/app_number_counter.dart
import 'package:flutter/material.dart';
import 'package:leave_manager/core/constants/app_spacing.dart';
import 'package:leave_manager/core/utils/extenstions/theme_extension.dart';

/// ويدجت عام لعداد أرقام (زيادة ونقصان) يدعم الحدود الدنيا والقصوى
class AppNumberCounter extends StatelessWidget {
  final String label;
  final int value;
  final ValueChanged<int> onChanged;
  final int min;
  final int max;

  const AppNumberCounter({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
    this.min = 0,
    this.max = 45,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: context.textTheme.titleMedium?.copyWith(
            color: context.colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 8,),
        Container(
          decoration: BoxDecoration(
            color: context.colorScheme.surfaceContainerHighest.withOpacity(0.3),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: context.colorScheme.outline.withOpacity(0.2),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // زر النقصان
              IconButton(
                icon: const Icon(Icons.remove_rounded),
                // تعطيل الزر إذا وصلنا للحد الأدنى
                onPressed: value > min ? () => onChanged(value - 1) : null,
                color: context.colorScheme.error,
                disabledColor: context.colorScheme.outlineVariant,
              ),
              
              // عرض الرقم الحالي
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
                child: SizedBox(
                  width: 20,
                  child: Text(
                    '$value',
                    textAlign: TextAlign.center,
                    style: context.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: context.colorScheme.primary,
                    ),
                  ),
                ),
              ),
              
              // زر الزيادة
              IconButton(
                icon: const Icon(Icons.add_rounded),
                // تعطيل الزر إذا وصلنا للحد الأقصى
                onPressed: value < max ? () => onChanged(value + 1) : null,
                color: context.colorScheme.primary,
                disabledColor: context.colorScheme.outlineVariant,
              ),
            ],
          ),
        ),
      ],
    );
  }
}