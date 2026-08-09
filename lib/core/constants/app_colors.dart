// lib/core/constants/app_colors.dart
import 'package:flutter/material.dart';
import '../../shared/themes/leave_colors.dart';

class AppColors {
  // --- Primary Colors ---
  static const Color primaryTealLight = Color(0xFF008080);
  static const Color primaryTealDark = Color(0xFF4DB6AC); 
  static const Color whatsappColor = Color(0xFF25D366);

  // --- Material 3 Surface Colors (Light) ---
  // تم تعريف الدرجات صراحة لتجنب استخدام withAlpha()
  static const Color lightBackground = Color(0xFFFDFDFD); 
  static const Color lightSurface = Color(0xFFFDFDFD); 
  static const Color lightSurfaceContainerLow = Color(0xFFF5F5F5); 
  static const Color lightSurfaceContainer = Color(0xFFEEEEEE); 
  static const Color lightSurfaceContainerHighest = Color(0xFFE0E0E0); 
  static const Color lightOutline = Color(0xFFBDBDBD);
  static const Color lightOutlineVariant = Color(0xFFE0E0E0);
  static const Color lightText = Color(0xFF212529);
  static const Color lightShadow = Color(0xFF000000);

  // --- Material 3 Surface Colors (Dark) ---
  static const Color darkBackground = Color(0xFF121212);
  static const Color darkSurface = Color(0xFF121212); 
  static const Color darkSurfaceContainerLow = Color(0xFF1E1E1E);
  static const Color darkSurfaceContainer = Color(0xFF2A2A2A);
  static const Color darkSurfaceContainerHighest = Color(0xFF333333);
  static const Color darkOutline = Color(0xFF757575);
  static const Color darkOutlineVariant = Color(0xFF424242);
  static const Color darkText = Color(0xFFE0E0E0);
  static const Color darkShadow = Color(0xFF000000);

  // --- Leave Status Colors ---
  static const Color regularLeave = Color(0xFF4CAF50);
  static const Color casualLeave = Color(0xFFFFA000);
  static const Color restAllowance = Color(0xFF7C4DFF);

  // --- Theme Extensions ---
  static const LeaveColors lightLeaveColors = LeaveColors(
    regular: regularLeave,
    casual: casualLeave,
    restAllowance: restAllowance,
  );

  static const LeaveColors darkLeaveSColors = LeaveColors(
    regular: Color(0xFF81C784), 
    casual: Color(0xFFFFB300),
    restAllowance: Color(0xFFB388FF),
  );
}