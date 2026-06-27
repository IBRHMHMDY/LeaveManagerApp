import 'package:flutter/material.dart';

class AppNotifications {
  // 1. إشعار النجاح
  static void showSuccess(BuildContext context, String message) {
    _showCustomSnackBar(
      context,
      message,
      title: 'عملية ناجحة',
      icon: Icons.check_circle_rounded,
      color: Colors.green.shade600,
      bgColor: Colors.green.shade50,
    );
  }

  // 2. إشعار الخطأ
  static void showError(BuildContext context, String message) {
    _showCustomSnackBar(
      context,
      message,
      title: 'عذراً',
      icon: Icons.error_rounded,
      color: Colors.red.shade600,
      bgColor: Colors.red.shade50,
    );
  }

  // 3. إشعار التنبيه/المعلومات
  static void showWarning(BuildContext context, String message) {
    _showCustomSnackBar(
      context,
      message,
      title: 'تنبيه',
      icon: Icons.warning_rounded,
      color: Colors.orange.shade600,
      bgColor: Colors.orange.shade50,
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
    // إخفاء أي إشعار سابق لتجنب التكدس
    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        elevation: 0,
        behavior: SnackBarBehavior.floating, // يجعله يطفو فوق الشاشة
        backgroundColor: Colors.transparent, // جعل الخلفية الأساسية شفافة
        margin: const EdgeInsets.only(bottom: 24, left: 16, right: 16),
        padding: EdgeInsets.zero,
        duration: const Duration(seconds: 6),
        content: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: color.withAlpha(20),
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
              BoxShadow(
                color: Colors.black.withAlpha(10),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
            // شريط جانبي أيمن ملون متوافق مع الواجهة العربية
            border: Border(
              right: BorderSide(color: color, width: 6),
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // الأيقونة داخل دائرة ملونة
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: bgColor, shape: BoxShape.circle),
                child: Icon(icon, color: color, size: 26),
              ),
              const SizedBox(width: 16),
              // النصوص
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        color: Colors.grey.shade900,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      message,
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 13.5,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}