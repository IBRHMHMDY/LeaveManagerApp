// lib/core/constants/app_colors.dart
import 'package:flutter/material.dart';
import 'package:leave_manager/shared/themes/leave_colors.dart';

class AppColors {
  // --- Primary Colors ---
  static const Color primaryTealLight = Color(0xFF008080);
  static const Color primaryTealDark = Color(0xFF4DB6AC);
  
  static const Color whatsappBGColor = Color(0xFF128c7e);
  static const Color whatsappFGColor = Color(0xFFFEFEFE);

  // --- Material 3 Surface Colors (Light) ---
  static const Color lightBackground = Color(0xFFF5F3F3);
  static const Color lightSurface = Color(0xFFFDFDFD);
  static const Color lightSurfaceContainerLow = Color(0xFFF5F5F5);
  static const Color lightSurfaceContainer = Color(0xFFEEEEEE);
  static const Color lightSurfaceContainerHighest = Color(0xFFE0E0E0);
  static const Color lightOutline = Color(0xFF767676);
  static const Color lightOutlineVariant = Color(0xFFE0E0E0);
  static const Color lightText = Color(0xFF212529);
  static const Color lightShadow = Color(0xFF000000);

  // --- Material 3 Surface Colors (Dark) ---
  static const Color darkBackground = Color(0xFF1D1D1D);
  static const Color darkSurface = Color(0xFF121212);
  static const Color darkSurfaceContainerLow = Color(0xFF1E1E1E);
  static const Color darkSurfaceContainer = Color(0xFF2A2A2A);
  static const Color darkSurfaceContainerHighest = Color(0xFF333333);
  static const Color darkOutline = Color(0xFF757575);
  static const Color darkOutlineVariant = Color(0xFF424242);
  static const Color darkText = Color(0xFFE0E0E0);
  static const Color darkShadow = Color(0xFF000000);

  // --- Leave Status Colors ---
  static const Color regularLeaveLight = Color(0xFF4CAF50);
  static const Color casualLeaveLight = Color(0xFFFFA200);
  static const Color restLight = Color(0xFF4F46E5);
  static const Color usedRestLight = Color(0xFF757474);

  static const Color regularLeaveDark = Color(0xFF81C784);
  static const Color casualLeaveDark = Color(0xFFFFB93F);
  static const Color restDark = Color(0xFFB388FF);
  static const Color usedRestDark = Color(0xFFBFBBBB);

  // --- Theme Extensions ---
  static const LeaveColors lightLeaveColors = LeaveColors(
    regular: regularLeaveLight,
    casual: casualLeaveLight,
    rest: restLight,
    usedRest: usedRestLight
  );

  static const LeaveColors darkLeaveSColors = LeaveColors(
    regular: regularLeaveDark,
    casual: casualLeaveDark,
    rest: restDark,
    usedRest: usedRestDark
  );
}
