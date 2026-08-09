// lib/core/utils/extenstions/theme_extension.dart
import 'package:flutter/material.dart';
import 'package:leave_manager/shared/themes/leave_colors.dart';

extension ThemeContextExtension on BuildContext {
  /// الوصول السريع للثيم الأساسي
  ThemeData get theme => Theme.of(this);

  /// الوصول السريع لـ ColorScheme
  ColorScheme get colorScheme => Theme.of(this).colorScheme;

  /// الوصول السريع لـ TextTheme المخصص (Cairo)
  TextTheme get textTheme => Theme.of(this).textTheme;

  /// الوصول السريع لألوان حالات الإجازات المخصصة
  LeaveColors get leaveColors => Theme.of(this).extension<LeaveColors>()!;

  /// التحقق من حالة الوضع (داكن/نهاري)
  bool get isDarkMode => Theme.of(this).brightness == Brightness.dark;
}