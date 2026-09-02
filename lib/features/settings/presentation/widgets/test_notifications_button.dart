import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:leave_manager/core/utils/extenstions/theme_extension.dart';
import 'package:leave_manager/features/holidays/presentation/cubit/holidays_cubit.dart';
import 'package:leave_manager/features/holidays/presentation/cubit/holidays_state.dart';
import 'package:leave_manager/features/notifications/presentation/bloc/notifications_bloc.dart';
import 'package:leave_manager/features/notifications/presentation/bloc/notifications_event.dart';
import 'package:leave_manager/shared/widgets/widgets.dart';

class TestHolidayNotificationButton extends StatelessWidget {
  const TestHolidayNotificationButton({super.key});

  @override
  Widget build(BuildContext context) {
    return AppPrimaryButton(
      label: 'اختبار الاشعارات',
      icon: Icons.bug_report_rounded,
      backgroundColor: context.colorScheme.surface,
      foregroundColor: context.colorScheme.onSurface,
      onPressed: () {
        final holidaysState = context.read<HolidaysCubit>().state;
        int? holidayId;
        String holidayName = 'عطلة تجريبية';

        // جلب أول عطلة مسجلة لمحاكاة بيانات حقيقية
        if (holidaysState is HolidaysLoaded && holidaysState.financialYearHolidays.isNotEmpty) {
          final holiday = holidaysState.financialYearHolidays.first;
          holidayId = holiday.id;
          holidayName = holiday.name;
        }

        AppToast.showSuccess(context, 'سيتم إرسال إشعار العطلة بعد دقيقه واحده...');

        // تأخير لمدة دقيقه واحده لمحاكاة استلام الإشعار في وقت لاحق
        Future.delayed(const Duration(minutes: 1), () {
          // التحقق من أن الـ Widget ما زال متاحاً في شجرة المكونات (Memory Leak Prevention)
          if (!context.mounted) return;

          // بناء الـ Payload المطابق لـ NotificationFlowManager
          final payload = holidayId != null
              ? '{"type": "holiday_alert", "holidayId": "$holidayId"}'
              : null;

          // إرسال الإشعار
          context.read<NotificationsBloc>().add(
            SendAndSaveInstantNotificationEvent(
              id: 9999, // معرّف مؤقت للاختبار
              title: 'تذكير عطلة: $holidayName',
              body: 'هذا إشعار تجريبي يحاكي بدء عطلة فعلية اليوم. انقر لإدارة العطلة.',
              payload: payload,
            ),
          );
        });
      },
    );
  }
}