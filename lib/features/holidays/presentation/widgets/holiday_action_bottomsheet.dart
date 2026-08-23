// lib/features/holidays/presentation/widgets/holiday_action_bottomsheet.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:leave_manager/core/constants/app_spacing.dart';
import 'package:leave_manager/core/router/app_router.dart';
import 'package:leave_manager/core/utils/enums/work_reason.dart';
import 'package:leave_manager/core/utils/extenstions/theme_extension.dart';
import 'package:leave_manager/features/holidays/domain/entities/holiday_entity.dart';
import 'package:leave_manager/features/rest_allowances/presentation/blocs/rest_allowances_bloc.dart';
import 'package:leave_manager/features/rest_allowances/presentation/blocs/rest_allowances_event.dart';
import 'package:leave_manager/features/rest_allowances/presentation/widgets/add_extra_work_bottomsheet.dart';
import 'package:leave_manager/shared/widgets/widgets.dart';

void showHolidayActionBottomSheet(BuildContext context, Holiday holiday) {
  AppBottomSheet.show(
    context: context,
    title: 'إجراءات العطلة: ${holiday.name}',
    icon: Icons.celebration_rounded,
    iconColor: context.colorScheme.primary,
    isScrollControlled: true,
    child: _HolidayActionForm(holiday: holiday, parentContext: context),
  );
}

class _HolidayActionForm extends StatelessWidget {
  final Holiday holiday;
  final BuildContext parentContext;
  
  const _HolidayActionForm({
    required this.holiday,
    required this.parentContext,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'ماذا تود أن تفعل في هذه العطلة؟',
            style: context.textTheme.titleMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.lg),

          // الخيار الأول: يوم عمل (إضافة الرصيد تلقائياً)
          AppPrimaryButton(
            label: 'إضافة كـ "يوم عمل"',
            icon: Icons.work_history_rounded,
            backgroundColor: context.colorScheme.primary,
            onPressed: () {
              // إضافة الرصيد إلى البدلات باستخدام السياق الآمن
              parentContext.read<RestAllowancesBloc>().add(
                AddExtraWorkEvent(
                  workStartDate: holiday.startDate,
                  workEndDate: holiday.endDate,
                  daysCount: holiday.daysCount,
                  workReason: WorkReason.holiday,
                  holidayId: holiday.id,
                ),
              );
              context.pop(); // إغلاق الـ BottomSheet
              parentContext.go(AppRouter.restAllowances); // الانتقال للشاشة المطلوبة
              // لا حاجة لـ AppToast هنا، الـ BLoC سيتكفل بالأمر
            },
          ),
          const SizedBox(height: AppSpacing.md),
          
          // الخيار الثاني: ترحيل العطلة (يفتح نافذة الترحيل مع تمرير العطلة)
          AppOutlinedButton(
            label: 'ترحيل العطلة',
            icon: Icons.edit_calendar_rounded,
            foregroundColor: context.colorScheme.primary,
            onPressed: () {
              context.pop(); // إغلاق النافذة الحالية
              parentContext.go(AppRouter.restAllowances); // الانتقال للشاشة المستهدفة
              
              // فتح نافذة الإضافة الجديدة بعد التأكد من الانتقال
              Future.delayed(const Duration(milliseconds: 300), () {
                if (parentContext.mounted) {
                  showAddExtraWorkBottomSheet(parentContext, initialHoliday: holiday);
                }
              });
            },
          ),
          const SizedBox(height: AppSpacing.md),

          // الخيار الثالث: يوم راحة (تجاهل)
          AppTextButton(
            label: 'يوم راحة (تجاهل)',
            icon: Icons.weekend_rounded,
            foregroundColor: context.colorScheme.onSurfaceVariant,
            onPressed: () {
              context.pop(); // إغلاق النافذة فقط (سيبقى الإشعار غير مقروء في DB)
            },
          ),
        ],
      ),
    );
  }
}