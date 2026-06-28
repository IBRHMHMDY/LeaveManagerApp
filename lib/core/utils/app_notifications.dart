// lib/core/utils/app_notifications.dart
import 'package:flutter/material.dart';

class AppNotifications {
  // 1. إشعار النجاح
  static void showSuccess(BuildContext context, String message) {
    final isDark = Theme.of(context).colorScheme.brightness == Brightness.dark;
    _showCustomSnackBar(
      context,
      message,
      title: 'عملية ناجحة',
      icon: Icons.check_circle_rounded,
      color: isDark ? Colors.green.shade400 : Colors.green.shade600,
      bgColor: isDark ? Colors.green.withAlpha(30) : Colors.green.shade50,
    );
  }

  // 2. إشعار الخطأ
  static void showError(BuildContext context, String message) {
    final isDark = Theme.of(context).colorScheme.brightness == Brightness.dark;
    _showCustomSnackBar(
      context,
      message,
      title: 'عذراً',
      icon: Icons.error_rounded,
      color: isDark ? Colors.red.shade400 : Colors.red.shade600,
      bgColor: isDark ? Colors.red.withAlpha(30) : Colors.red.shade50,
    );
  }

  // 3. إشعار التنبيه/المعلومات
  static void showWarning(BuildContext context, String message) {
    final isDark = Theme.of(context).colorScheme.brightness == Brightness.dark;
    _showCustomSnackBar(
      context,
      message,
      title: 'تنبيه',
      icon: Icons.warning_rounded,
      color: isDark ? Colors.orange.shade400 : Colors.orange.shade600,
      bgColor: isDark ? Colors.orange.withAlpha(30) : Colors.orange.shade50,
    );
  }

  // الويدجت الأساسي الذي يرسم الإشعار
  static void _showCustomSnackBar(
    BuildContext context,
    String message, {
    required String title,
    required IconData icon,
    required Color color,
    required Color bgColor,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = colorScheme.brightness == Brightness.dark;

    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        elevation: 0,
        behavior: SnackBarBehavior.floating, 
        backgroundColor: Colors.transparent, 
        margin: const EdgeInsets.only(bottom: 24, left: 16, right: 16),
        padding: EdgeInsets.zero,
        duration: const Duration(seconds: 6),
        content: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: isDark ? Colors.transparent : color.withAlpha(20),
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
              BoxShadow(
                color: isDark ? Colors.black.withAlpha(50) : Colors.black.withAlpha(10),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
            // التعديل هنا: إعطاء لون للحافة في الوضع النهاري بناءً على نوع الرسالة
            border: Border.all(
              color: isDark ? Colors.white12 : color.withAlpha(60),
              width: 1,
            ),
          ),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              PositionedDirectional(
                start: -16, top: -16, bottom: -16,
                child: Container(width: 6, color: color),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(color: bgColor, shape: BoxShape.circle),
                    child: Icon(icon, color: color, size: 26),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                            color: colorScheme.onSurface,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          message,
                          style: TextStyle(
                            color: colorScheme.onSurface.withAlpha(180),
                            fontSize: 13.5,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}