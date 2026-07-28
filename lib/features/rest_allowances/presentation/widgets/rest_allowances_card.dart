// lib/features/rest_allowances/presentation/widgets/rest_allowances_card.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:leave_manager/core/utils/enums/work_reason.dart';
import 'package:leave_manager/core/utils/extenstions/date_extension.dart'; // 🔹 استدعاء الـ Extension
import 'package:leave_manager/features/holidays/domain/entities/holiday_entity.dart';
import 'package:leave_manager/features/holidays/presentation/cubit/holidays_cubit.dart';
import 'package:leave_manager/features/holidays/presentation/cubit/holidays_state.dart';
import 'package:leave_manager/features/rest_allowances/domain/entities/extra_work_record_entity.dart';
import 'package:leave_manager/features/rest_allowances/presentation/blocs/rest_allowances_bloc.dart';
import 'package:leave_manager/features/rest_allowances/presentation/blocs/rest_allowances_event.dart';
import 'package:leave_manager/shared/widgets/confirm_delete_dialog.dart';

class RestAllowancesCard extends StatelessWidget {
  final ExtraWorkRecord extrawork;

  const RestAllowancesCard({super.key, required this.extrawork});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = colorScheme.brightness == Brightness.dark;

    // تغيير لون الكارت بناءً على حالة الاستهلاك
    final Color cardColor = extrawork.isUsed ? Colors.orange.shade700 : Colors.deepPurpleAccent;

    return Dismissible(
      key: ValueKey('extrawork_${extrawork.id}'),
      direction: DismissDirection.endToStart,
      background: Container(
        margin: EdgeInsets.only(bottom: 14.h),
        decoration: BoxDecoration(color: Colors.red.shade600, borderRadius: BorderRadius.circular(16.r)),
        alignment: AlignmentDirectional.centerEnd,
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Icon(Icons.delete_sweep_rounded, color: Colors.white, size: 28.w),
      ),
      confirmDismiss: (direction) async {
        bool confirm = false;
        await showDialog(
          context: context,
          builder: (ctx) => ConfirmDeleteDialog(
            titleDialog: 'تأكيد الحذف',
            contentDialog: 'هل أنت متأكد من حذف هذا السجل؟',
            onPressedButton: () {
              confirm = true;
              ctx.pop();
            },
          ),
        );
        return confirm;
      },
      onDismissed: (direction) {
        context.read<RestAllowancesBloc>().add(DeleteExtraWorkEvent(extrawork.id));
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 14.h),
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            if (!isDark) BoxShadow(color: colorScheme.shadow.withAlpha(15), blurRadius: 10.r, offset: Offset(0, 4.h)),
          ],
          border: Border.all(color: isDark ? Colors.white12 : Colors.transparent, width: 1.w),
        ),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(width: 6.w, color: cardColor),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(16.w),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        // 🔹 الاستماع لحالة العطلات للوصول لاسم المناسبة
                        child: BlocBuilder<HolidaysCubit, HolidaysState>(
                          builder: (context, holidayState) {
                            Holiday? associatedHoliday;
                            
                            // البحث عن العطلة المرتبطة في حالة وجود holidayId
                            if (extrawork.holidayId != null && holidayState is HolidaysLoaded) {
                              try {
                                associatedHoliday = holidayState.financialYearHolidays.firstWhere(
                                  (h) => h.id == extrawork.holidayId,
                                );
                              } catch (_) {
                                associatedHoliday = null;
                              }
                            }

                            String pillText = '';
                            String subtitleText = '';
                            
                            // 🔹 استخدام الـ Extension النظيف هنا
                            final workDateShort = extrawork.workStartDate.toDateRangeString(extrawork.workEndDate, short: true);
                            final workDateFull = extrawork.workStartDate.toDateRangeString(extrawork.workEndDate, short: false);

                            if (extrawork.isUsed) {
                              final restStart = extrawork.restStartDate ?? extrawork.workStartDate;
                              final restEnd = extrawork.restEndDate ?? extrawork.workEndDate;
                              // 🔹 استخدام الـ Extension
                              final restDateShort = restStart.toDateRangeString(restEnd, short: true);
                              
                              pillText = '$restDateShort بدل راحه عن $workDateShort';
                              
                              if (extrawork.workReason == WorkReason.holiday) {
                                if (associatedHoliday != null) {
                                  // 🔹 استخدام الـ Extension لتاريخ العطلة
                                  final holidayDateFull = associatedHoliday.startDate.toDateRangeString(associatedHoliday.endDate, short: false);
                                  subtitleText = '${associatedHoliday.name} $holidayDateFull';
                                } else {
                                  subtitleText = 'يوم عمل فى عطله $workDateFull';
                                }
                              } else {
                                subtitleText = 'يوم عمل اضافى';
                              }
                            } else {
                              if (extrawork.workReason == WorkReason.holiday) {
                                if (associatedHoliday != null) {
                                  pillText = 'يوم عمل فى عطله (${associatedHoliday.name})';
                                } else {
                                  pillText = 'يوم عمل فى عطله';
                                }
                              } else {
                                pillText = 'يوم عمل اضافى';
                              }
                              subtitleText = workDateFull;
                            }

                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                                  decoration: BoxDecoration(color: cardColor.withAlpha(20), borderRadius: BorderRadius.circular(20.r)),
                                  child: Text(
                                    pillText,
                                    style: TextStyle(color: cardColor, fontWeight: FontWeight.bold, fontSize: 12.sp),
                                  ),
                                ),
                                SizedBox(height: 12.h),
                                Row(
                                  children: [
                                    Icon(Icons.calendar_today_rounded, size: 16.w, color: colorScheme.onSurfaceVariant),
                                    SizedBox(width: 8.w),
                                    Expanded(
                                      child: Text(
                                        subtitleText,
                                        style: TextStyle(
                                          fontSize: 13.5.sp,
                                          color: colorScheme.onSurface,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            );
                          }
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
                        decoration: BoxDecoration(color: cardColor.withAlpha(15), borderRadius: BorderRadius.circular(12.r)),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('${extrawork.daysCount}', style: TextStyle(color: cardColor, fontWeight: FontWeight.w900, fontSize: 20.sp)),
                            Text('يوم', style: TextStyle(color: cardColor, fontSize: 10.sp, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}