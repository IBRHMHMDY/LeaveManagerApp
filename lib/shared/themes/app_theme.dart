// lib/shared/themes/app_theme.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_typography.dart';
import '../../core/constants/app_spacing.dart';

class AppTheme {
  // ==========================================
  // 1. الوضع النهاري (Light Theme)
  // ==========================================
  static ThemeData get lightTheme {
    const colorScheme = ColorScheme.light(
      primary: AppColors.primaryTealLight,
      surface: AppColors.lightSurface,
      surfaceContainerHighest: AppColors.lightSurfaceContainerHighest,
      surfaceContainer: AppColors.lightSurfaceContainer,
      onSurface: AppColors.lightText,
      onSurfaceVariant: Color(0xFF5F6368),
      error: Colors.redAccent,
      shadow: AppColors.lightShadow,
      outline: AppColors.lightOutline,
      outlineVariant: AppColors.lightOutlineVariant,
    );

    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: AppColors.lightBackground,
      colorScheme: colorScheme,
      textTheme: AppTypography.getTheme(AppColors.lightText),
      extensions: const [AppColors.lightLeaveStatusColors],
      
      // --- AppBar Theme ---
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        iconTheme: IconThemeData(color: colorScheme.onSurface),
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
        ),
      ),
      
      // --- NavigationBar Theme (Bottom Nav) ---
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: colorScheme.surface,
        elevation: 8,
        shadowColor: colorScheme.shadow.withOpacity(0.1),
        indicatorColor: colorScheme.primary.withOpacity(0.15),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: colorScheme.primary);
          }
          return TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: colorScheme.onSurfaceVariant);
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return IconThemeData(color: colorScheme.primary, size: 26);
          }
          return IconThemeData(color: colorScheme.onSurfaceVariant, size: 24);
        }),
      ),

      // --- Card Theme ---
      cardTheme: CardThemeData(
        color: AppColors.lightSurfaceContainerLow,
        elevation: 1, 
        shadowColor: colorScheme.shadow.withOpacity(0.1),
        shape: RoundedRectangleBorder(
          borderRadius: AppRadii.lg,
          side: BorderSide.none,
        ),
        margin: EdgeInsets.zero,
      ),
      
      // --- Dialog & AlertDialog Theme ---
      dialogTheme: DialogThemeData(
        backgroundColor: colorScheme.surface,
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: AppRadii.lg),
        titleTextStyle: AppTypography.getTheme(AppColors.lightText).titleLarge,
        contentTextStyle: AppTypography.getTheme(AppColors.lightText).bodyMedium,
      ),

      // --- Bottom Sheet Theme ---
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: colorScheme.surface,
        surfaceTintColor: Colors.transparent,
        elevation: 4,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
      ),
      
      // --- Input Decoration (Text Fields) ---
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colorScheme.surfaceContainerHighest,
        contentPadding: EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.md),
        border: OutlineInputBorder(borderRadius: AppRadii.md, borderSide: BorderSide.none),
        enabledBorder: OutlineInputBorder(borderRadius: AppRadii.md, borderSide: BorderSide.none),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppRadii.md,
          borderSide: BorderSide(color: colorScheme.primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: AppRadii.md,
          borderSide: BorderSide(color: colorScheme.error, width: 1.5),
        ),
      ),
      
      // --- Buttons Theme ---
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          shape: RoundedRectangleBorder(borderRadius: AppRadii.md),
          padding: EdgeInsets.symmetric(vertical: AppSpacing.md),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: colorScheme.primary,
          side: BorderSide(color: colorScheme.primary.withOpacity(0.5), width: 1.5),
          shape: RoundedRectangleBorder(borderRadius: AppRadii.md),
          padding: EdgeInsets.symmetric(vertical: AppSpacing.md, horizontal: AppSpacing.md),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: colorScheme.onSurfaceVariant,
          shape: RoundedRectangleBorder(borderRadius: AppRadii.md),
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: AppRadii.md),
      ),

      // --- ListTile & Switch Theme ---
      listTileTheme: ListTileThemeData(
        contentPadding: EdgeInsets.symmetric(horizontal: AppSpacing.md),
        shape: RoundedRectangleBorder(borderRadius: AppRadii.md),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return colorScheme.primary;
          return colorScheme.onSurfaceVariant;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return colorScheme.primary.withOpacity(0.3);
          return colorScheme.surfaceContainerHighest;
        }),
      ),
    );
  }

  // ==========================================
  // 2. الوضع الداكن (Dark Theme)
  // ==========================================
  static ThemeData get darkTheme {
    const colorScheme = ColorScheme.dark(
      primary: AppColors.primaryTealDark,
      surface: AppColors.darkSurface,
      surfaceContainerHighest: AppColors.darkSurfaceContainerHighest,
      surfaceContainer: AppColors.darkSurfaceContainer,
      onSurface: AppColors.darkText,
      onSurfaceVariant: Color(0xFFAAAEB4), 
      error: Colors.redAccent,
      shadow: AppColors.darkShadow,
      outline: AppColors.darkOutline,
      outlineVariant: AppColors.darkOutlineVariant,
    );

    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: AppColors.darkBackground,
      colorScheme: colorScheme,
      textTheme: AppTypography.getTheme(AppColors.darkText),
      extensions: const [AppColors.darkLeaveStatusColors],
      
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        iconTheme: IconThemeData(color: colorScheme.onSurface),
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
        ),
      ),
      
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: colorScheme.surface,
        elevation: 0, 
        indicatorColor: colorScheme.primary.withOpacity(0.2),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: colorScheme.primary);
          }
          return TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: colorScheme.onSurfaceVariant);
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return IconThemeData(color: colorScheme.primary, size: 26);
          }
          return IconThemeData(color: colorScheme.onSurfaceVariant, size: 24);
        }),
      ),

      cardTheme: CardThemeData(
        color: AppColors.darkSurfaceContainerLow,
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadii.lg,
          side: BorderSide(color: colorScheme.outline.withOpacity(0.3)),
        ),
        margin: EdgeInsets.zero,
      ),

      dialogTheme: DialogThemeData(
        backgroundColor: colorScheme.surfaceContainer,
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: AppRadii.lg),
        titleTextStyle: AppTypography.getTheme(AppColors.darkText).titleLarge,
        contentTextStyle: AppTypography.getTheme(AppColors.darkText).bodyMedium,
      ),
      
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: colorScheme.surfaceContainer,
        surfaceTintColor: Colors.transparent,
        elevation: 4,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
      ),
      
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colorScheme.surfaceContainerHighest,
        contentPadding: EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.md),
        border: OutlineInputBorder(borderRadius: AppRadii.md, borderSide: BorderSide.none),
        enabledBorder: OutlineInputBorder(borderRadius: AppRadii.md, borderSide: BorderSide.none),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppRadii.md,
          borderSide: BorderSide(color: colorScheme.primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: AppRadii.md,
          borderSide: BorderSide(color: colorScheme.error, width: 1.5),
        ),
      ),
      
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: colorScheme.primary,
          foregroundColor: AppColors.darkBackground,
          shape: RoundedRectangleBorder(borderRadius: AppRadii.md),
          padding: EdgeInsets.symmetric(vertical: AppSpacing.md),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: colorScheme.primary,
          side: BorderSide(color: colorScheme.primary.withOpacity(0.5), width: 1.5),
          shape: RoundedRectangleBorder(borderRadius: AppRadii.md),
          padding: EdgeInsets.symmetric(vertical: AppSpacing.md, horizontal: AppSpacing.md),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: colorScheme.onSurfaceVariant,
          shape: RoundedRectangleBorder(borderRadius: AppRadii.md),
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: colorScheme.primary,
        foregroundColor: AppColors.darkBackground,
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: AppRadii.md),
      ),
      
      listTileTheme: ListTileThemeData(
        contentPadding: EdgeInsets.symmetric(horizontal: AppSpacing.md),
        shape: RoundedRectangleBorder(borderRadius: AppRadii.md),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return colorScheme.primary;
          return colorScheme.onSurfaceVariant;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return colorScheme.primary.withOpacity(0.3);
          return colorScheme.surfaceContainerHighest;
        }),
      ),
    );
  }
}