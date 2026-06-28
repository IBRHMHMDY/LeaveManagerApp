// lib/core/widgets/language_toggle_button.dart
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class LanguageToggleButton extends StatelessWidget {
  const LanguageToggleButton({super.key});

  @override
  Widget build(BuildContext context) {
    // التحقق من اللغة الحالية
    final isArabic = context.locale.languageCode == 'ar';

    return IconButton(
      tooltip: isArabic ? 'Change to English' : 'التبديل للعربية',
      icon: Icon(
        Icons.language_rounded,
        color: Theme.of(context).colorScheme.onSurface,
      ),
      onPressed: () {
        // التبديل وتغيير لغة التطبيق بالكامل فوراً
        if (isArabic) {
          context.setLocale(const Locale('en', 'US'));
        } else {
          context.setLocale(const Locale('ar', 'EG'));
        }
      },
    );
  }
}