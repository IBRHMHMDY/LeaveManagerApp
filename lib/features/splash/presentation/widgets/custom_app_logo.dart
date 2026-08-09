// lib/app/splash/widgets/custom_app_logo.dart
import 'package:flutter/material.dart';
import 'package:leave_manager/core/utils/extenstions/theme_extension.dart';

class CustomAppLogo extends StatelessWidget {
  // تم إزالة BuildContext من الـ Constructor لعدم الحاجة إليه
  const CustomAppLogo({super.key});

  @override
  Widget build(BuildContext context) {
    // استخدام الـ Extension للحصول على colorScheme مباشرة
    final colorScheme = context.colorScheme;

    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            colorScheme.primary,
            colorScheme.primary.withOpacity(0.6), // استبدال withAlpha بـ withOpacity
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: colorScheme.primary.withOpacity(0.3),
            blurRadius: 30,
            offset: const Offset(0, 15),
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Icon(
            Icons.calendar_month_rounded,
            size: 60,
            color: colorScheme.onPrimary,
          ),
          Positioned(
            bottom: 25,
            right: 22,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: colorScheme.surface,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: colorScheme.shadow.withOpacity(0.1),
                    blurRadius: 4,
                  ),
                ],
              ),
              child: Icon(
                Icons.check_circle_rounded,
                size: 20,
                color: colorScheme.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}