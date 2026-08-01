import 'package:flutter/material.dart';
import '../../shared/themes/leave_status_colors.dart';

class AppColors {
  // --- الألوان الأساسية للعلامة التجارية ---
  static const Color primaryTeal = Color(0xFF008080); 
  static const Color secondaryCoral = Color(0xFFC8633F);

  // --- ألوان حالات الإجازات الأساسية ---
  static const Color regularLeave = Color(0xFF4CAF50);
  static const Color casualLeave = Color(0xFFFFA000);
  static const Color restAllowance = Color(0xFF7C4DFF);

  // --- ألوان المظهر الفاتح ---
  static const Color lightBackground = Color(0xFFF8F9FA);
  static const Color lightSurface = Colors.white;
  static const Color lightText = Color(0xFF212529);

  // --- ألوان المظهر الداكن ---
  static const Color darkBackground = Color(0xFF121212);
  static const Color darkSurface = Color(0xFF1E1E1E);
  static const Color darkText = Color(0xFFE0E0E0);

  // --- امتدادات الألوان للمظهر (Theme Extensions) ---
  static const LeaveStatusColors lightLeaveStatusColors = LeaveStatusColors(
    regular: regularLeave,
    casual: casualLeave,
    restAllowance: restAllowance,
  );

  static const LeaveStatusColors darkLeaveStatusColors = LeaveStatusColors(
    regular: Color(0xFF81C784), // درجة أفتح لتناسب الخلفية الداكنة
    casual: Color(0xFFFFB300),
    restAllowance: Color(0xFFB388FF),
  );
}