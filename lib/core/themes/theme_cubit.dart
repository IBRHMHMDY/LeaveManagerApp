// lib/core/themes/theme_cubit.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ThemeCubit extends Cubit<ThemeMode> {
  // نبدأ بوضع النظام الافتراضي (System)
  ThemeCubit() : super(ThemeMode.system);

  // دالة للتبديل بين الوضعين بناءً على سطوع الشاشة الحالي
  void toggleTheme(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    emit(isDark ? ThemeMode.light : ThemeMode.dark);
  }
}