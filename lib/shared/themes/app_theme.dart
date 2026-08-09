// lib/shared/themes/app_theme.dart
import 'package:flutter/material.dart';
import 'package:leave_manager/shared/themes/dark_theme.dart';
import 'package:leave_manager/shared/themes/light_theme.dart';

abstract final class AppTheme {
  static ThemeData get lightTheme => LightTheme.lightTheme;
  static ThemeData get darkTheme => DarkTheme.darkTheme;
}
