import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTypography {
  /// بناء TextTheme مخصص يعتمد على خط Cairo
  static TextTheme getTheme(Color textColor) {
    return GoogleFonts.cairoTextTheme(
      TextTheme(
        displayLarge: TextStyle(fontSize: 32.sp, fontWeight: FontWeight.bold, color: textColor),
        displayMedium: TextStyle(fontSize: 28.sp, fontWeight: FontWeight.bold, color: textColor),
        displaySmall: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.bold, color: textColor),
        headlineLarge: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.bold, color: textColor),
        headlineMedium: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w600, color: textColor),
        headlineSmall: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w600, color: textColor),
        titleLarge: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold, color: textColor),
        titleMedium: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600, color: textColor),
        titleSmall: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w600, color: textColor),
        bodyLarge: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.normal, color: textColor),
        bodyMedium: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.normal, color: textColor),
        bodySmall: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.normal, color: textColor.withAlpha(180)),
        labelLarge: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold, color: textColor),
        labelMedium: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w600, color: textColor),
        labelSmall: TextStyle(fontSize: 11.sp, fontWeight: FontWeight.w600, color: textColor.withAlpha(150)),
      ),
    );
  }
}