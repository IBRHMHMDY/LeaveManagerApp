import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RestAllowanceStatsCard extends StatelessWidget {
  final int totalAvailable;
  final int totalConsumed;
  final int totalEarned;

  const RestAllowanceStatsCard({
    super.key,
    required this.totalAvailable,
    required this.totalConsumed,
    required this.totalEarned,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = colorScheme.brightness == Brightness.dark;

    return Container(
      margin: EdgeInsets.all(16.w),
      padding: EdgeInsets.symmetric(vertical: 20.h),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: colorScheme.primary.withAlpha(50), width: 1.5),
        boxShadow: [
          if (!isDark)
            BoxShadow(
              color: colorScheme.shadow.withAlpha(10),
              blurRadius: 10.r,
              offset: Offset(0, 4.h),
            ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _StatItem(title: 'الرصيد المتاح', value: totalAvailable, color: Colors.deepPurpleAccent),
          _buildDivider(colorScheme),
          _StatItem(title: 'الراحات المستهلكة', value: totalConsumed, color: Colors.orange.shade700),
          _buildDivider(colorScheme),
          _StatItem(title: 'الراحات المكتسبة', value: totalEarned, color: colorScheme.primary),
        ],
      ),
    );
  }

  Widget _buildDivider(ColorScheme colorScheme) {
    return Container(
      height: 40.h,
      width: 1.w,
      color: colorScheme.onSurface.withAlpha(30),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String title;
  final int value;
  final Color color;

  const _StatItem({required this.title, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 12.sp,
            fontWeight: FontWeight.w600,
            color: Theme.of(context).colorScheme.onSurface.withAlpha(180),
          ),
        ),
        SizedBox(height: 8.h),
        Text(
          '$value',
          style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.w900, color: color),
        ),
        Text(
          'أيام',
          style: TextStyle(fontSize: 10.sp, color: Theme.of(context).colorScheme.onSurface.withAlpha(120)),
        ),
      ],
    );
  }
}