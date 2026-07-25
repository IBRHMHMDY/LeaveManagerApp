import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BuildEmptyState extends StatelessWidget {
  const BuildEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
     final colorScheme = Theme.of(context).colorScheme;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.event_busy_rounded, size: 60.w, color: colorScheme.onSurface.withAlpha(50)),
        SizedBox(height: 16.h),
        Text(
          'لا يوجد رصيد راحة مكتسب!',
          style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold, color: colorScheme.onSurface),
        ),
        SizedBox(height: 8.h),
        Text(
          'عليك تسجيل كسب راحة أولاً لتتمكن من طلب إجازة تعويضية.',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 14.sp, color: colorScheme.onSurface.withAlpha(150)),
        ),
        SizedBox(height: 24.h),
      ],
    );
  }
}