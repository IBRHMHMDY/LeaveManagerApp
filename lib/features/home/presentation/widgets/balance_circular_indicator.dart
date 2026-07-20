// lib/features/home/presentation/widgets/balance_circular_indicator.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BalanceCircularIndicator extends StatelessWidget {
  final String title;
  final int remaining;
  final int total;
  final Color color;

  const BalanceCircularIndicator({
    super.key,
    required this.title,
    required this.remaining,
    required this.total,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final double progress = total > 0 ? (remaining / total) : 0;
    final isDark = Theme.of(context).colorScheme.brightness == Brightness.dark;

    return Card(
      elevation: isDark ? 0 : 4,
      shadowColor: isDark ? Colors.transparent : color.withAlpha(50),
      color: Theme.of(context).colorScheme.surface,
      shape: RoundedRectangleBorder(
        side: BorderSide(
          color: isDark ? color.withAlpha(100) : color,
          width: 1.w,
        ),
        // استخدام .r للزوايا الدائرية
        borderRadius: BorderRadius.circular(20.r), 
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 24.h, horizontal: 16.w),
        child: Column(
          children: [
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                // نستخدم .sp هنا لأن هذا النص لا يعتمد على الـ Theme الافتراضي بالكامل
                fontSize: 18.sp, 
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            SizedBox(height: 20.h),
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  // استخدام .w للحفاظ على التناسب الدائري (دائماً نستخدم نفس المحور للقطر)
                  width: 110.w,
                  height: 110.w,
                  child: CircularProgressIndicator(
                    value: progress,
                    strokeWidth: 10.w,
                    backgroundColor: color.withAlpha(50),
                    color: color,
                    strokeCap: StrokeCap.round,
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '$remaining',
                      style: TextStyle(
                        fontSize: 28.sp, // أحجام النصوص متجاوبة
                        fontWeight: FontWeight.w900,
                        color: color,
                      ),
                    ),
                    Text(
                      '/ $total',
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}