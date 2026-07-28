import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:leave_manager/features/home/presentation/widgets/rest_allowances_button.dart';

class RestAllowanceStatsCard extends StatelessWidget {
  final int totalAvailableDays;
  final int totalConsumedDays;

  const RestAllowanceStatsCard({
    super.key,
    required this.totalAvailableDays,
    required this.totalConsumedDays,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = colorScheme.brightness == Brightness.dark;

    return Container(
      padding: EdgeInsets.symmetric(vertical: 20.h),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: colorScheme.primary.withAlpha(50),
          width: 1.5,
        ),
        boxShadow: [
          if (!isDark)
            BoxShadow(
              color: colorScheme.shadow.withAlpha(10),
              blurRadius: 10.r,
              offset: Offset(0, 4.h),
            ),
        ],
      ),
      child: Column(
        children: [
          Text(
            'بدلات الراحة',
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            ),
          ),
          SizedBox(height: 16.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _StatItem(
                title: 'الرصيد المتاح',
                value: totalAvailableDays,
                color: const Color(0xFF7C4DFF),
              ),
              _buildDivider(colorScheme),
              _StatItem(
                title: 'الرصيد المستهلك',
                value: totalConsumedDays,
                color: Colors.orange.shade700,
              ),
            ],
          ),
          SizedBox(height: 16.h),
          const Padding(
            padding: EdgeInsets.only(top: 12,left: 20,right: 20,bottom: 0),
            child: RestAllowancesButton(),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider(ColorScheme colorScheme) {
    return Container(
      height: 60.h,
      width: 1.w,
      color: colorScheme.onSurface.withAlpha(30),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String title;
  final int value;
  final Color color;

  const _StatItem({
    required this.title,
    required this.value,
    required this.color,
  });

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
          style: TextStyle(
            fontSize: 24.sp,
            fontWeight: FontWeight.w900,
            color: color,
          ),
        ),
        Text(
          'يوم',
          style: TextStyle(
            fontSize: 10.sp,
            color: Theme.of(context).colorScheme.onSurface.withAlpha(120),
          ),
        ),
      ],
    );
  }
}
