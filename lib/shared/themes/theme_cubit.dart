// lib/core/themes/theme_cubit.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

@injectable
class ThemeCubit extends Cubit<ThemeMode> {
  final SharedPreferences sharedPreferences;
  static const String _themeKey = 'is_dark_theme';

  // 1. تحديد الثيم المبدئي فور تهيئة الـ Cubit بناءً على القيمة المحفوظة
  ThemeCubit({required this.sharedPreferences}) : super(_getInitialTheme(sharedPreferences));

  static ThemeMode _getInitialTheme(SharedPreferences prefs) {
    final isDark = prefs.getBool(_themeKey);
    if (isDark == null) return ThemeMode.system; // الوضع الافتراضي
    return isDark ? ThemeMode.dark : ThemeMode.light;
  }

  // 2. التبديل وحفظ الحالة الجديدة
  void toggleTheme(BuildContext context) {
    final isCurrentlyDark = Theme.of(context).brightness == Brightness.dark;
    
    final newTheme = isCurrentlyDark ? ThemeMode.light : ThemeMode.dark;
    
    // حفظ الخيار في ذاكرة الجهاز
    sharedPreferences.setBool(_themeKey, newTheme == ThemeMode.dark);
    
    // تحديث الواجهة
    emit(newTheme);
  }
}