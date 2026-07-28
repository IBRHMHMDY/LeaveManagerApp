import 'package:flutter/material.dart';

class AppColors {
  // الألوان الأساسية
  static const Color primaryTeal = Color(0xFF008080); // أزرق محيطي هادئ
  static const Color accentCoral = Color(0xFFC8633F); // برتقالي دافئ للتنبيهات والأزرار

  // ألوان الوضع النهاري (Light Mode)
  static const Color lightBackground = Color(0xFFF8F9FA); // رمادي فاتح جداً
  static const Color lightSurface = Colors.white; // البطاقات
  static const Color lightText = Color(0xFF212529); // نصوص داكنة

  // ألوان الوضع الليلي (Dark Mode)
  static const Color darkBackground = Color(0xFF121212); // أسود مطفي
  static const Color darkSurface = Color(0xFF1E1E1E); // بطاقات رمادية داكنة
  static const Color darkText = Color(0xFFE0E0E0); // نصوص فاتحة مريحة للعين

  // ألوان الإجازات
  static const Color regularLeaveColor = Color(0xFF4CAF50); // لون الإجازة الاعتيادية (أخضر)
  static const Color casualLeaveColor = Color(0xFFFFA000); // لون الإجازة العارضة (أصفر/برتقالي)
  static const Color restAllowances = Color(0xFF7C4DFF); // لون بدلات الراحه
}