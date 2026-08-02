// lib/app/splash/widgets/custom_app_logo_icon.dart
import 'package:flutter/material.dart';
import 'package:leave_manager/core/utils/extenstions/theme_extension.dart';

class CustomAppLogoIcon extends StatelessWidget {
  // تم تنظيف الـ Constructor
  const CustomAppLogoIcon({super.key});

  @override
  Widget build(BuildContext context) {
    // استخدام الـ Extension
    final colorScheme = context.colorScheme;

    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            colorScheme.primary,
            colorScheme.primary.withOpacity(0.6),
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
            size: 30,
            color: colorScheme.onPrimary,
          ),
          Positioned(
            bottom: 10,
            right: 12,
            child: Container(
              padding: const EdgeInsets.all(2),
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
                size: 12,
                color: colorScheme.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}