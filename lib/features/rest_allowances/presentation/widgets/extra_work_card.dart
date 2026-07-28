// lib/features/rest_allowances/presentation/widgets/extra_work_card.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:leave_manager/core/utils/extenstions/date_extension.dart';
import 'package:leave_manager/core/utils/enums/work_reason.dart';
import 'package:leave_manager/features/rest_allowances/domain/entities/extra_work_record_entity.dart';
import 'package:leave_manager/features/rest_allowances/presentation/blocs/rest_allowances_bloc.dart';
import 'package:leave_manager/features/rest_allowances/presentation/blocs/rest_allowances_event.dart';
import 'package:leave_manager/shared/widgets/confirm_delete_dialog.dart';

class ExtraWorkCard extends StatelessWidget {
  final ExtraWorkRecord record;
  const ExtraWorkCard({super.key, required this.record});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = colorScheme.brightness == Brightness.dark;
    
    // الألوان تتغير بناءً على حالة السجل (متاح أم مستهلك)
    final Color cardColor = record.isUsed ? Colors.orange.shade700 : Colors.deepPurpleAccent;
    final String typeLabel = record.workReason == WorkReason.holiday ? 'عطلة رسمية' : 'عمل إضافي';
    
    // التواريخ المعروضة (إذا كان مستهلكاً نعرض تواريخ الراحة، وإلا تواريخ العمل)
    final DateTime displayStart = record.isUsed && record.restStartDate != null ? record.restStartDate! : record.workStartDate;
    final DateTime displayEnd = record.isUsed && record.restEndDate != null ? record.restEndDate! : record.workEndDate;

    return Dismissible(
      key: ValueKey('extrawork_${record.id}'),
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
            contentDialog: 'هل أنت متأكد من حذف هذا السجل نهائياً؟',
            onPressedButton: () {
              confirm = true;
              ctx.pop();
            },
          ),
        );
        return confirm;
      },
      onDismissed: (direction) {
        context.read<RestAllowancesBloc>().add(DeleteExtraWorkEvent(record.id));
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
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                              decoration: BoxDecoration(color: cardColor.withAlpha(20), borderRadius: BorderRadius.circular(20.r)),
                              child: Text(
                                record.isUsed ? 'بدل راحة ($typeLabel)' : typeLabel, 
                                style: TextStyle(color: cardColor, fontWeight: FontWeight.bold, fontSize: 12.sp)
                              ),
                            ),
                            SizedBox(height: 12.h),
                            Row(
                              children: [
                                Icon(Icons.calendar_today_rounded, size: 16.w, color: colorScheme.onSurfaceVariant),
                                SizedBox(width: 8.w),
                                Expanded(
                                  child: Text(
                                    displayStart.isAtSameMomentAs(displayEnd)
                                        ? displayStart.toFormatCurrentLocale()
                                        : '${displayStart.toFormatCurrentLocale()} - ${displayEnd.toFormatCurrentLocale()}',
                                    style: TextStyle(
                                      fontSize: 13.5.sp,
                                      color: colorScheme.onSurface,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            if (record.notes != null && record.notes!.isNotEmpty) ...[
                              SizedBox(height: 10.h),
                              Text(record.notes!, style: TextStyle(color: colorScheme.onSurfaceVariant, fontSize: 12.sp)),
                            ],
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
                        decoration: BoxDecoration(color: cardColor.withAlpha(15), borderRadius: BorderRadius.circular(12.r)),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('${record.daysCount}', style: TextStyle(color: cardColor, fontWeight: FontWeight.w900, fontSize: 20.sp)),
                            Text('أيام', style: TextStyle(color: cardColor, fontSize: 10.sp, fontWeight: FontWeight.bold)),
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