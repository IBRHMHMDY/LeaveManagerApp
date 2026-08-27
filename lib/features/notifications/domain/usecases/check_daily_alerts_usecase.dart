// lib/features/notifications/domain/usecases/check_daily_alerts_usecase.dart
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:leave_manager/core/errors/failures.dart';
import 'package:leave_manager/core/usecases/base_usecase.dart';
import 'package:leave_manager/core/utils/enums/leave_type.dart';
import 'package:leave_manager/features/holidays/domain/repositories/holidays_repository.dart';
import 'package:leave_manager/features/leaves/domain/repositories/leave_repository.dart';
import 'package:leave_manager/features/notifications/domain/usecases/save_notification_usecase.dart';
import 'package:leave_manager/core/utils/notifications/notification_service.dart';

@lazySingleton
class CheckDailyAlertsUseCase implements BaseUseCase<Unit, NoParams> {
  final HolidaysRepository holidaysRepository;
  final LeaveRepository leaveRepository;
  final SaveNotificationUseCase saveNotification;
  final NotificationService notificationService;

  CheckDailyAlertsUseCase({
    required this.holidaysRepository,
    required this.leaveRepository,
    required this.saveNotification,
    required this.notificationService,
  });

  @override
  Future<Either<Failure, Unit>> call(NoParams params) async {
    try {
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final tomorrow = today.add(const Duration(days: 1));
      final endOfTomorrow = DateTime(tomorrow.year, tomorrow.month, tomorrow.day, 23, 59, 59);

      // 1. فحص العطلات الرسمية القادمة
      final holidayRes = await holidaysRepository.getUpcomingHoliday(today);
      holidayRes.fold(
        (failure) => null,
        (holiday) {
          if (holiday != null) {
            final hDate = DateTime(holiday.startDate.year, holiday.startDate.month, holiday.startDate.day);
            if (hDate.isAtSameMomentAs(today) || hDate.isAtSameMomentAs(tomorrow)) {
              final title = "عطلة قادمة: ${holiday.name}";
              final body = "تذكير: تبدأ العطلة ${hDate.isAtSameMomentAs(today) ? 'اليوم' : 'غداً'}.";
              _triggerAlert(title, body, '{"type": "holiday_alert", "holidayId": "${holiday.id}"}');
            }
          }
        },
      );

      // 2. فحص الإجازات المجدولة (اعتيادي / عارضة)
      final leavesRes = await leaveRepository.getLeavesBetweenDates(today, endOfTomorrow);
      leavesRes.fold(
        (failure) => null,
        (leaves) {
          for (var leave in leaves) {
            final lDate = DateTime(leave.startDate.year, leave.startDate.month, leave.startDate.day);
            if (lDate.isAtSameMomentAs(today) || lDate.isAtSameMomentAs(tomorrow)) {
              final leaveTypeName = leave.leaveType == LeaveType.regular ? 'اعتيادي' : 'عارضة';
              const title = "تذكير بإجازة مجدولة";
              final body = "تبدأ إجازتك ($leaveTypeName) ${lDate.isAtSameMomentAs(today) ? 'اليوم' : 'غداً'}. نتمنى لك وقتاً ممتعاً!";
              _triggerAlert(title, body, '{"type": "leave_alert"}');
            }
          }
        },
      );

      return const Right(unit);
    } catch (e) {
      // إرجاع الخطأ وظيفياً باستخدام Either
      return Left(ServerFailure('حدث خطأ أثناء فحص التنبيهات: $e'));
    }
  }

  /// دالة مساعدة لحفظ وإطلاق الإشعار
  Future<void> _triggerAlert(String title, String body, String payload) async {
    // حفظ الإشعار في قاعدة البيانات المحلية (Drift) ليظهر في شاشة الإشعارات
    await saveNotification(SaveNotificationParams(title: title, body: body, payload: payload));
    
    // إطلاق الإشعار عبر نظام التشغيل
    await notificationService.showNotification(
      id: DateTime.now().millisecondsSinceEpoch.remainder(100000), // توليد ID فريد
      title: title,
      body: body,
      payload: payload,
    );
  }
}