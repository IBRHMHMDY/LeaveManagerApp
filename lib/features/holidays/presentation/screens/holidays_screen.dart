import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:leave_manager/features/holidays/presentation/cubit/holidays_cubit.dart';
import 'package:leave_manager/features/holidays/presentation/cubit/holidays_state.dart';
import 'package:intl/intl.dart';

class HolidaysScreen extends StatelessWidget {
  const HolidaysScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('العطلات الرسمية'), centerTitle: true),
      body: BlocBuilder<HolidaysCubit, HolidaysState>(
        builder: (context, state) {
          if (state is HolidaysLoading || state is HolidaysInitial) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is HolidaysError) {
            return Center(child: Text(state.message));
          }

          if (state is HolidaysLoaded) {
            final holidays = state.financialYearHolidays;

            if (holidays.isEmpty) {
              return Center(
                child: Text(
                  'لا توجد عطلات رسمية مسجلة للسنة المالية الحالية.',
                  style: TextStyle(fontSize: 16.sp),
                ),
              );
            }

            return ListView.builder(
              padding: EdgeInsets.all(16.w),
              itemCount: holidays.length,
              itemBuilder: (context, index) {
                final holiday = holidays[index];
                final isPast = holiday.endDate.isBefore(DateTime.now());

                return _buildHolidayCard(context, holiday, isPast);
              },
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildHolidayCard(BuildContext context, holiday, bool isPast) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = colorScheme.brightness == Brightness.dark;

    // استخدام ألوان باهتة للعطلات السابقة للدلالة البصرية
    final cardColor = isPast
        ? colorScheme.surfaceContainerHighest.withAlpha(100)
        : colorScheme.surface;
    final textColor = isPast
        ? colorScheme.onSurfaceVariant
        : colorScheme.onSurface;

    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: isDark ? Colors.white12 : colorScheme.outline.withAlpha(40),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  holiday.name,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                    decoration: isPast ? TextDecoration.lineThrough : null,
                  ),
                ),
                SizedBox(height: 6.h),
                Row(
                  children: [
                    Icon(
                      Icons.calendar_today_rounded,
                      size: 14.w,
                      color: colorScheme.onSurfaceVariant,
                    ),
                    SizedBox(width: 6.w),
                    Expanded(
                      child: Text(
                        _formatDateRange(holiday.startDate, holiday.endDate),
                        style: TextStyle(
                          fontSize: 13.sp,
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: isPast
                  ? Colors.grey.withAlpha(50)
                  : colorScheme.primary.withAlpha(30),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '${holiday.daysCount}',
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                    color: isPast ? Colors.grey : colorScheme.primary,
                  ),
                ),
                Text(
                  'أيام',
                  style: TextStyle(
                    fontSize: 11.sp,
                    color: isPast ? Colors.grey : colorScheme.primary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDateRange(DateTime start, DateTime end) {
    final format = DateFormat('d MMM yyyy', 'ar');
    if (start.isAtSameMomentAs(end)) {
      return format.format(start);
    }
    return '${format.format(start)} - ${format.format(end)}';
  }
}
