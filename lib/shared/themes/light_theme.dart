import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:leave_manager/core/constants/app_colors.dart';
import 'package:leave_manager/core/constants/app_spacing.dart';
import 'package:leave_manager/core/constants/app_typography.dart';

abstract final class LightTheme {
  static ThemeData get lightTheme {
    const colorScheme = ColorScheme.light(
      primary: AppColors.primaryTealLight,
      surface: AppColors.lightSurface,
      surfaceContainerHighest: AppColors.lightSurfaceContainerHighest,
      surfaceContainer: AppColors.lightSurfaceContainer,
      onSurface: Color(0xFF262728),
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
      extensions: const [AppColors.lightLeaveColors],

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
          systemNavigationBarColor: AppColors.lightSurface,
    systemNavigationBarIconBrightness: Brightness.dark,
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
            return TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: colorScheme.primary,
            );
          }
          return TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurfaceVariant,
          );
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
        color: AppColors.lightSurfaceContainerHighest,
        elevation: 1,
        shadowColor: colorScheme.shadow.withAlpha(10),
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.lg,
          side: BorderSide.none,
        ),
        margin: EdgeInsets.zero,
      ),

      // --- Dialog & AlertDialog Theme ---
      dialogTheme: DialogThemeData(
        backgroundColor: colorScheme.surface,
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: AppRadius.lg),
        titleTextStyle: AppTypography.getTheme(AppColors.lightText).titleLarge,
        contentTextStyle: AppTypography.getTheme(
          AppColors.lightText,
        ).bodyMedium,
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
        filled: false,
        fillColor: colorScheme.surfaceContainerHighest,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.md,
        ),
        border: OutlineInputBorder(
          borderRadius: AppRadius.md,
          borderSide: const BorderSide(color: AppColors.lightOutline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: AppRadius.md,
          borderSide: BorderSide(color: colorScheme.outline.withAlpha(40)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppRadius.md,
          borderSide: BorderSide(color: colorScheme.primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: AppRadius.md,
          borderSide: BorderSide(color: colorScheme.error, width: 1.5),
        ),
      ),

      // --- Buttons Theme ---
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          shape: RoundedRectangleBorder(borderRadius: AppRadius.md),
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: colorScheme.primary,
          side: BorderSide(
            color: colorScheme.primary,
            width: 1.5,
          ),
          shape: RoundedRectangleBorder(borderRadius: AppRadius.md),
          padding: const EdgeInsets.symmetric(
            vertical: AppSpacing.md,
            horizontal: AppSpacing.md,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: colorScheme.onSurfaceVariant,
          shape: RoundedRectangleBorder(borderRadius: AppRadius.md),
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: AppRadius.md),
      ),

      // --- ListTile & Switch Theme ---
      listTileTheme: ListTileThemeData(
        contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
        shape: RoundedRectangleBorder(borderRadius: AppRadius.md),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return colorScheme.primary;
          return colorScheme.onSurfaceVariant;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return colorScheme.primary.withAlpha(30);
          }
          return colorScheme.surfaceContainerHighest;
        }),
      ),
    );
  }
}
