import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:leave_manager/core/router/app_router.dart';
import 'package:leave_manager/core/utils/extenstions/date_extension.dart';
import 'package:leave_manager/core/utils/extenstions/string_extension.dart';
import 'package:leave_manager/features/holidays/domain/entities/holiday_entity.dart';

class UpcomingHolidayCard extends StatelessWidget {
  final Holiday? upcomingHoliday;

  const UpcomingHolidayCard({super.key, this.upcomingHoliday});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = colorScheme.brightness == Brightness.dark;

    return InkWell(
      onTap: () {
        context.push(AppRouter.holidays);
      },
      borderRadius: BorderRadius.circular(16.r),
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: isDark ? Colors.white12 : colorScheme.primary.withAlpha(50),
            width: 1.w,
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
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer.withAlpha(150),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.celebration_rounded,
                color: colorScheme.primary,
                size: 28.w,
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (upcomingHoliday != null) ...[
                    Text(
                      upcomingHoliday!.name,
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      upcomingHoliday!.startDate.toHolidayFormat(),
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ] else ...[
                    Text(
                      'لا توجد عطلات قادمة قريباً',
                      style: TextStyle(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onSurface,
                      ),
                    ),
                  ],
                  SizedBox(height: 8.h,),
                  if (upcomingHoliday != null)
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                          decoration: BoxDecoration(
                            color: colorScheme.primary.withAlpha(20),
                            borderRadius: BorderRadius.circular(20.r),
                          ),
                          child: Text(
                            upcomingHoliday!.daysLeft.remainingDaysText,
                            style: TextStyle(
                              fontSize: 11.sp,
                              fontWeight: FontWeight.bold,
                              color: colorScheme.primary,
                            ),
                          ),
                        ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              color: colorScheme.onSurfaceVariant.withAlpha(100),
              size: 20.w,
            ),
          ],
        ),
      ),
    );
  }
}
