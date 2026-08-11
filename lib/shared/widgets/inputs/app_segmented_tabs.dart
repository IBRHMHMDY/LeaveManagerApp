// lib/shared/widgets/inputs/app_segmented_tabs.dart
import 'package:flutter/material.dart';
import 'package:leave_manager/core/constants/app_spacing.dart';
import 'package:leave_manager/core/utils/extenstions/theme_extension.dart';

/// نموذج بيانات لتمثيل عنصر واحد داخل التبويبات
class AppTabItem<T> {
  final T value;
  final String label;

  const AppTabItem({
    required this.value,
    required this.label,
  });
}

/// ويدجت عام لإنشاء تبويبات متجاورة قابلة لإعادة الاستخدام
class AppSegmentedTabs<T> extends StatelessWidget {
  final T selectedValue;
  final ValueChanged<T> onChanged;
  final List<AppTabItem<T>> tabs;

  const AppSegmentedTabs({
    super.key,
    required this.selectedValue,
    required this.onChanged,
    required this.tabs,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md, 
        vertical: AppSpacing.sm,
      ),
      child: Row(
        children: [
          for (int i = 0; i < tabs.length; i++) ...[
            Expanded(
              child: _AppTabButton(
                title: tabs[i].label,
                isActive: selectedValue == tabs[i].value,
                onTap: () {
                  if (selectedValue != tabs[i].value) {
                    onChanged(tabs[i].value);
                  }
                },
              ),
            ),
            // إضافة مسافة بين التبويبات باستثناء العنصر الأخير
            if (i < tabs.length - 1) const SizedBox(width: AppSpacing.sm),
          ],
        ],
      ),
    );
  }
}

/// ويدجت فرعي خاص برسم زر التبويب الواحد
class _AppTabButton extends StatelessWidget {
  final String title;
  final bool isActive;
  final VoidCallback onTap;

  const _AppTabButton({
    required this.title,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
        decoration: BoxDecoration(
          color: isActive 
              ? context.colorScheme.primaryContainer 
              : Colors.transparent,
          borderRadius: AppRadius.md,
        ),
        alignment: Alignment.center,
        child: Text(
          title,
          style: context.textTheme.titleMedium?.copyWith(
            color: isActive 
                ? context.colorScheme.onPrimary 
                : context.colorScheme.inverseSurface,
          ),
        ),
      ),
    );
  }
}