import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class CustomEmptyState extends StatelessWidget {
  const CustomEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // عرض رسم متحرك باستخدام Lottie
          Lottie.asset(
            'assets/animations/empty_leaves.json', // تأكد من توفر هذا الملف في مجلد assets
            width: 200,
            height: 200,
            fit: BoxFit.contain,
            // في حالة عدم العثور على الملف، يتم عرض أيقونة احتياطية
            errorBuilder: (context, error, stackTrace) {
              return Icon(
                Icons.event_busy_outlined,
                size: 80,
                color: colorScheme.onSurface.withAlpha(50),
              );
            },
          ),
          const SizedBox(height: 24),
          Text(
            'لا توجد إجازات مسجلة حتى الآن',
            style: TextStyle(
              fontSize: 16,
              color: colorScheme.onSurface.withAlpha(150),
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'قم بإضافة إجازتك الأولى',
            style: TextStyle(
              fontSize: 14,
              color: colorScheme.onSurface.withAlpha(100),
            ),
          ),
        ],
      ),
    );
  }
}