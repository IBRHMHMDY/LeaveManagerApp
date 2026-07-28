// lib/features/rest_allowances/presentation/widgets/rest_allowance_card.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:leave_manager/core/utils/extenstions/date_extension.dart';
import 'package:leave_manager/core/utils/enums/work_reason.dart';
import 'package:leave_manager/features/rest_allowances/domain/entities/rest_allowance_entity.dart';
import 'package:leave_manager/features/rest_allowances/presentation/blocs/rest_allowances_bloc.dart';
import 'package:leave_manager/features/rest_allowances/presentation/blocs/rest_allowances_event.dart';
import 'package:leave_manager/shared/widgets/confirm_delete_dialog.dart';

class RestAllowanceCard extends StatelessWidget {
  final RestAllowance allowance;

  const RestAllowanceCard({
    super.key,
    required this.allowance,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = colorScheme.brightness == Brightness.dark;

    // الكيان RestAllowance يمثل دائماً بدلات الراحة (الرصيد المستهلك)
    final Color color = Colors.orange.shade700;
    final String typeLabel = allowance.workReason == WorkReason.holiday 
        ? 'بدل راحة (عن عطلة)' 
        : 'بدل راحة (عن إضافي)';

    return Dismissible(
      key: ValueKey('rest_allowance_${allowance.id}'),
      direction: DismissDirection.endToStart,
      background: const _DismissibleBackground(), // تم استخدام const لتحسين الأداء
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
        context.read<RestAllowancesBloc>().add(DeleteRestEvent(allowance.id));
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 14.h),
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: isDark ? Colors.black.withAlpha(60) : colorScheme.shadow.withAlpha(15),
              blurRadius: 10.r,
              offset: Offset(0, 4.h),
            ),
          ],
          border: Border.all(
            color: isDark ? Colors.white12 : Colors.transparent,
            width: 1.w,
          ),
        ),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(width: 6.w, color: color),
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
                              decoration: BoxDecoration(
                                color: color.withAlpha(20),
                                borderRadius: BorderRadius.circular(20.r),
                              ),
                              child: Text(
                                typeLabel,
                                style: TextStyle(
                                  color: color,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12.sp,
                                ),
                              ),
                            ),
                            SizedBox(height: 12.h),
                            Row(
                              children: [
                                Icon(
                                  Icons.calendar_today_rounded,
                                  size: 16.w,
                                  color: colorScheme.onSurfaceVariant,
                                ),
                                SizedBox(width: 8.w),
                                Expanded(
                                  child: Text(
                                    allowance.startDate.isAtSameMomentAs(allowance.endDate)
                                        ? allowance.startDate.toFormatCurrentLocale()
                                        : '${allowance.startDate.toFormatCurrentLocale()}  -  ${allowance.endDate.toFormatCurrentLocale()}',
                                    style: TextStyle(
                                      fontSize: 13.5.sp,
                                      color: colorScheme.onSurface,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            // تم إزالة الكود القديم الخاص بـ isConsumed لعدم الحاجة إليه هنا
                            if (allowance.notes != null && allowance.notes!.isNotEmpty) ...[
                              SizedBox(height: 10.h),
                              Container(
                                padding: EdgeInsets.all(10.w),
                                decoration: BoxDecoration(
                                  color: colorScheme.surfaceContainerHighest.withAlpha(80),
                                  borderRadius: BorderRadius.circular(10.r),
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Icon(
                                      Icons.notes_rounded,
                                      size: 14.w,
                                      color: colorScheme.onSurfaceVariant,
                                    ),
                                    SizedBox(width: 6.w),
                                    Expanded(
                                      child: Text(
                                        allowance.notes!,
                                        style: TextStyle(
                                          color: colorScheme.onSurfaceVariant,
                                          fontSize: 12.sp,
                                          height: 1.4,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                      SizedBox(width: 16.w),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
                            decoration: BoxDecoration(
                              color: color.withAlpha(15),
                              borderRadius: BorderRadius.circular(12.r),
                              border: Border.all(color: color.withAlpha(30)),
                            ),
                            child: Column(
                              children: [
                                Text(
                                  '${allowance.daysCount}',
                                  style: TextStyle(color: color, fontWeight: FontWeight.w900, fontSize: 20.sp, height: 1.1),
                                ),
                                Text(
                                  'يوم',
                                  style: TextStyle(color: color, fontSize: 10.sp, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ],
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

class _DismissibleBackground extends StatelessWidget {
  const _DismissibleBackground(); // استخدام const لتقليل إعادة البناء (Rebuilds)

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 14.h),
      decoration: BoxDecoration(
        color: Colors.red.shade600,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.red.withAlpha(40),
            blurRadius: 8.r,
            offset: Offset(0, 4.h),
          )
        ],
      ),
      alignment: AlignmentDirectional.centerEnd,
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.delete_sweep_rounded, color: Colors.white, size: 28.w),
          SizedBox(height: 4.h),
          Text(
            'حذف',
            style: TextStyle(
              color: Colors.white,
              fontSize: 12.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}