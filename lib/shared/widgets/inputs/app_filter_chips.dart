// lib/shared/widgets/inputs/app_filter_chips.dart
import 'package:flutter/material.dart';
import 'package:leave_manager/core/constants/app_spacing.dart';
import 'package:leave_manager/core/utils/extenstions/theme_extension.dart';

/// نموذج بيانات لتمثيل عنصر واحد داخل خيارات الفلترة
class AppFilterChipItem<T> {
  final T value;
  final String label;
  final IconData icon;

  const AppFilterChipItem({
    required this.value,
    required this.label,
    required this.icon,
  });
}

/// ويدجت عام (Generic) لإنشاء تبويبات متعددة الاستخدامات
class AppFilterChips<T> extends StatelessWidget {
  final T selectedValue;
  final ValueChanged<T> onChanged;
  final List<AppFilterChipItem<T>> items;

  const AppFilterChips({
    super.key,
    required this.selectedValue,
    required this.onChanged,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(AppSpacing.md),
      padding: const EdgeInsets.all(AppSpacing.xs),
      decoration: BoxDecoration(
        color: context.colorScheme.surfaceContainerHighest.withOpacity(0.3),
        borderRadius: AppRadius.lg,
      ),
      child: Row(
        children: items.map((item) {
          final isSelected = selectedValue == item.value;
          return Expanded(
            child: GestureDetector(
              onTap: () {
                if (!isSelected) onChanged(item.value);
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
                decoration: BoxDecoration(
                  color: isSelected ? context.colorScheme.primary : Colors.transparent,
                  borderRadius: AppRadius.md,
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: context.colorScheme.primary.withOpacity(0.15),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          )
                        ]
                      : [],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      item.icon,
                      size: 18,
                      color: isSelected 
                          ? context.colorScheme.onPrimary 
                          : context.colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(width: AppSpacing.xs),
                    Text(
                      item.label,
                      style: context.textTheme.labelLarge?.copyWith(
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                        color: isSelected 
                            ? context.colorScheme.onPrimary 
                            : context.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}