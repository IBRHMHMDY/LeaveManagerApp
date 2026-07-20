// lib/shared/themes/app_theme.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart'; // استيراد المكتبة
import 'app_colors.dart';

class AppTheme {
  static const String fontFamily = 'Cairo';

  // --- إعدادات النصوص المتجاوبة (Responsive TextTheme) ---
  // قمنا بفصلها لسهولة إعادة الاستخدام في الوضعين الفاتح والمظلم
  static TextTheme _buildResponsiveTextTheme(Color textColor) {
    return TextTheme(
      headlineLarge: TextStyle(fontSize: 32.sp, fontWeight: FontWeight.bold, color: textColor),
      headlineMedium: TextStyle(fontSize: 28.sp, fontWeight: FontWeight.bold, color: textColor),
      headlineSmall: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.bold, color: textColor),
      
      titleLarge: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.w600, color: textColor),
      titleMedium: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600, color: textColor),
      titleSmall: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600, color: textColor),
      
      bodyLarge: TextStyle(fontSize: 16.sp, color: textColor),
      bodyMedium: TextStyle(fontSize: 14.sp, color: textColor),
      bodySmall: TextStyle(fontSize: 12.sp, color: textColor.withAlpha(180)),
      
      labelLarge: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500, color: textColor),
      labelMedium: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w500, color: textColor),
      labelSmall: TextStyle(fontSize: 11.sp, fontWeight: FontWeight.w500, color: textColor.withAlpha(150)),
    ).apply(fontFamily: fontFamily); // تطبيق الخط الافتراضي على كافة النصوص
  }

  // --- الثيم النهاري (Light Theme) ---
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      fontFamily: fontFamily,
      scaffoldBackgroundColor: AppColors.lightBackground,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primaryTeal,
        brightness: Brightness.light,
        surface: AppColors.lightSurface,
        onSurface: AppColors.lightText,
        primaryContainer: AppColors.primaryTeal.withAlpha(20),
        onPrimaryContainer: AppColors.primaryTeal,
      ),
      // حقن النصوص المتجاوبة هنا
      textTheme: _buildResponsiveTextTheme(AppColors.lightText),
      
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.lightBackground,
        elevation: 0,
        centerTitle: false,
        iconTheme: const IconThemeData(color: AppColors.lightText),
        titleTextStyle: TextStyle(
          color: AppColors.lightText,
          fontSize: 20.sp, // متجاوب
          fontWeight: FontWeight.bold,
          fontFamily: fontFamily,
        ),
      ),
      
      // إعدادات الأزرار الافتراضية
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          minimumSize: Size(double.infinity, 50.h), // ارتفاع متجاوب
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r), // حواف متجاوبة
          ),
          textStyle: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold, fontFamily: fontFamily),
        ),
      ),
      
      // إعدادات حقول الإدخال الافتراضية
      inputDecorationTheme: InputDecorationTheme(
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h), // مسافات متجاوبة
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        labelStyle: TextStyle(fontSize: 14.sp), // حجم نص الـ label
      ),

      // إعدادات شريط التنقل
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: AppColors.lightSurface,
        elevation: 0,
        indicatorColor: AppColors.primaryTeal.withAlpha(40),
        labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return TextStyle(
              fontSize: 13.sp, // متجاوب
              fontWeight: FontWeight.bold,
              color: AppColors.primaryTeal,
              fontFamily: fontFamily,
            );
          }
          return TextStyle(
            fontSize: 12.sp, // متجاوب
            fontWeight: FontWeight.w500,
            color: AppColors.lightText.withAlpha(150),
            fontFamily: fontFamily,
          );
        }),
      ),
    );
  }

  // --- الثيم الليلي (Dark Theme) ---
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      fontFamily: fontFamily,
      scaffoldBackgroundColor: AppColors.darkBackground,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primaryTeal,
        brightness: Brightness.dark,
        surface: AppColors.darkSurface,
        onSurface: AppColors.darkText,
        primaryContainer: AppColors.primaryTeal.withAlpha(40),
        onPrimaryContainer: Colors.white,
      ),
      // حقن النصوص المتجاوبة هنا
      textTheme: _buildResponsiveTextTheme(AppColors.darkText),
      
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.darkBackground,
        elevation: 0,
        centerTitle: false,
        iconTheme: const IconThemeData(color: AppColors.darkText),
        titleTextStyle: TextStyle(
          color: AppColors.darkText,
          fontSize: 20.sp, // متجاوب
          fontWeight: FontWeight.bold,
          fontFamily: fontFamily,
        ),
      ),

       // إعدادات الأزرار الافتراضية للوضع الليلي
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          minimumSize: Size(double.infinity, 50.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
          textStyle: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold, fontFamily: fontFamily),
        ),
      ),
      
      // إعدادات حقول الإدخال للوضع الليلي
      inputDecorationTheme: InputDecorationTheme(
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: const BorderSide(color: Colors.white24),
        ),
        labelStyle: TextStyle(fontSize: 14.sp),
      ),

      // إعدادات شريط التنقل
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: AppColors.darkSurface,
        elevation: 0,
        indicatorColor: AppColors.primaryTeal.withAlpha(40),
        labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return TextStyle(
              fontSize: 13.sp, // متجاوب
              fontWeight: FontWeight.bold,
              color: AppColors.primaryTeal,
              fontFamily: fontFamily,
            );
          }
          return TextStyle(
            fontSize: 12.sp, // متجاوب
            fontWeight: FontWeight.w500,
            color: AppColors.darkText.withAlpha(150),
            fontFamily: fontFamily,
          );
        }),
      ),
    );
  }
}