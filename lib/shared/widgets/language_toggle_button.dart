// lib/shared/widgets/language_toggle_button.dart
import 'package:flutter/material.dart';

/// زر تبديل اللغة (Clean Architecture - Dumb Widget)
class LanguageToggleButton extends StatelessWidget {
  final bool isArabic;
  final VoidCallback onToggle;

  const LanguageToggleButton({
    super.key,
    required this.isArabic,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return IconButton(
      tooltip: isArabic ? 'تغيير للإنجليزية' : 'التبديل للعربية',
      // 💡 الحل الجذري: مطابقة تصميم زر الثيم ليكونوا بنفس المظهر المتناسق
      style: IconButton.styleFrom(
        backgroundColor: colorScheme.primaryContainer,
        foregroundColor: colorScheme.primary,
      ),
      icon: const Icon(Icons.language_rounded),
      onPressed: onToggle,
    );
  }
}