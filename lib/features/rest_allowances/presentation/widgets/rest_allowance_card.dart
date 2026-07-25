import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:leave_manager/core/utils/extenstions/date_extension.dart';
import 'package:leave_manager/features/rest_allowances/domain/entities/rest_allowance_entity.dart';
import 'package:leave_manager/features/rest_allowances/presentation/blocs/rest_allowances_bloc.dart';
import 'package:leave_manager/features/rest_allowances/presentation/blocs/rest_allowances_event.dart';
import 'package:leave_manager/shared/widgets/confirm_delete_dialog.dart';

class RestAllowanceCard extends StatelessWidget {
  final RestAllowance allowance;
  final bool isEarnedTab;

  const RestAllowanceCard({
    super.key,
    required this.allowance,
    required this.isEarnedTab,
  });

  Future<void> _handleDelete(BuildContext context) async {
    // 1. نظهر الـ Dialog وننتظر إجابته (true = حذف، false = إلغاء)
    final bool? shouldDelete = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return ConfirmDeleteDialog(
          titleDialog: 'حذف سجل الراحة',
          contentDialog:
              'سيتم حذف هذا اليوم نهائياً، ولا يمكن التراجع عن هذا الإجراء. هل أنت متأكد من الحذف؟',
          // 2. نقوم فقط بإرجاع true لغلق الـ Dialog
          onPressedButton: () => dialogContext.pop(true),
        );
      },
    );

    // 3. التحقق من النتيجة والمتابعة إذا كانت الشاشة لا تزال مفتوحة
    if (shouldDelete == true && context.mounted) {
      context.read<RestAllowancesBloc>().add(DeleteRestEvent(allowance.id));
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = colorScheme.brightness == Brightness.dark;

    // تحديد اللون الأساسي بناءً على حالة الكارت (مكتسب أم مستهلك)
    final Color color = isEarnedTab ? Colors.deepPurpleAccent : colorScheme.primary;

    final displayDate = isEarnedTab
        ? allowance.earnedDate
        : (allowance.consumedDate ?? allowance.earnedDate);

    // تحديد نوع الراحة لعرضه في شريط العنوان (Badge)
    final String typeLabel = isEarnedTab ? 'راحة مكتسبة' : 'إجازة تعويضية';

    // استخدام Dismissible لدعم ميزة الحذف بالسحب (Swipe to delete) مثل الإجازات
    return Dismissible(
      key: ValueKey('rest_allowance_${allowance.id}'),
      direction: DismissDirection.endToStart,
      background: _DismissibleBackground(),
      confirmDismiss: (direction) async {
        bool? confirm = false;
        await showDialog(
          context: context,
          builder: (ctx) => ConfirmDeleteDialog(
            titleDialog: 'حذف سجل الراحة',
            contentDialog:
                'سيتم حذف هذا اليوم نهائياً، ولا يمكن التراجع عن هذا الإجراء. هل أنت متأكد من الحذف؟',
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
              // الشريط اللوني الجانبي (مثل CustomLeaveCard)
              Container(width: 6.w, color: color),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(16.w),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // التفاصيل الأساسية
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Badge نوع الراحة
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
                            
                            // سطر التاريخ
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
                                    displayDate.toFormatCurrentLocale(),
                                    style: TextStyle(
                                      fontSize: 13.5.sp,
                                      color: colorScheme.onSurface,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            
                            // سطر الملاحظات (يظهر فقط إذا كان هناك ملاحظات)
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
                      // أيقونة الحذف بدلاً من المربع الذي يعرض الأيام
                      IconButton(
                        onPressed: () => _handleDelete(context),
                        icon: Icon(
                          Icons.delete_outline_rounded,
                          color: Colors.red.shade400,
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

// واجهة السحب للحذف (Swipe to delete) مطابقة لتلك الموجودة في الإجازات
class _DismissibleBackground extends StatelessWidget {
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