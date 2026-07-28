// lib/shared/themes/theme_cubit.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

@injectable
class ThemeCubit extends Cubit<ThemeMode> {
  final SharedPreferences sharedPreferences;
  static const String _themeKey = 'is_dark_theme';

  ThemeCubit({required this.sharedPreferences}) : super(_getInitialTheme(sharedPreferences));

  static ThemeMode _getInitialTheme(SharedPreferences prefs) {
    final isDark = prefs.getBool(_themeKey);
    if (isDark == null) return ThemeMode.system; 
    return isDark ? ThemeMode.dark : ThemeMode.light;
  }

  // تم إزالة BuildContext 
  // الاعتماد على حالة الـ Cubit الحالية لتحديد السمة
  void toggleTheme() {
    final isCurrentlyDark = state == ThemeMode.dark;
    final newTheme = isCurrentlyDark ? ThemeMode.light : ThemeMode.dark;
    
    sharedPreferences.setBool(_themeKey, newTheme == ThemeMode.dark);
    emit(newTheme);
  }
}