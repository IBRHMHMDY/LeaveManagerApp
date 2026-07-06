import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class SettingLangApp extends StatelessWidget {
  final ColorScheme colorScheme;
  const SettingLangApp({super.key, required this.colorScheme});
  @override
  Widget build(BuildContext context) {
    final currentLocale = context.locale;
    return ListTile(
      leading: Icon(Icons.language_rounded, color: colorScheme.primary),
      title: const Text(
        'لغة التطبيق',
        style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
      ),
      subtitle: Text(
        currentLocale.languageCode == 'ar'
            ? 'اللغة الحالية: العربية'
            : 'Current Language: English',
        style: TextStyle(
          fontSize: 12,
          color: colorScheme.onSurface.withAlpha(140),
        ),
      ),
      // وضع الـ Dropdown داخل حاوية (Container) منسقة
      trailing: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: colorScheme.outline.withAlpha(50)),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<Locale>(
            value: currentLocale,
            icon: Icon(
              Icons.arrow_drop_down_rounded,
              color: colorScheme.primary,
              size: 24,
            ),
            dropdownColor: colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            // منطق التبديل والحفظ التلقائي
            onChanged: (Locale? newLocale) async {
              if (newLocale != null && newLocale != currentLocale) {
                // تقوم هذه الدالة بتغيير اللغة، إعادة البناء، وحفظ الاختيار تلقائياً
                await context.setLocale(newLocale);
              }
            },
            items: const [
              DropdownMenuItem(
                value: Locale('ar', 'EG'),
                child: Text(
                  'العربية',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
              ),
              // DropdownMenuItem(
              //   value: Locale('en', 'US'),
              //   child: Text('English', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
