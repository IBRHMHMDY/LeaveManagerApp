import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:leave_manager/core/errors/failures.dart';
import 'package:leave_manager/core/usecases/base_usecase.dart';
import 'package:leave_manager/core/utils/financial_year_calculator.dart';
import 'package:leave_manager/core/utils/notifications/notification_service.dart';
import 'package:leave_manager/features/holidays/domain/repositories/holidays_repository.dart';
import 'package:leave_manager/features/notifications/domain/repositories/notification_repository.dart';

@lazySingleton
class ScheduleAllHolidaysUseCase implements BaseUseCase<Unit, NoParams> {
  final HolidaysRepository holidaysRepository;
  final NotificationService notificationService;
  final NotificationRepository notificationRepository;

  ScheduleAllHolidaysUseCase({
    required this.holidaysRepository,
    required this.notificationService,
    required this.notificationRepository,
  });

  @override
  Future<Either<Failure, Unit>> call(NoParams params) async {
    try {
      // 1. مسح جميع الإشعارات المجدولة مسبقاً لضمان عدم التكرار (Clean Slate)
      await notificationService.cancelAllNotifications();

      final now = DateTime.now();

      // جلب بداية ونهاية السنة المالية الحالية
      final start = FinancialYearCalculator.currentFinancialYearStart;
      final end = FinancialYearCalculator.currentFinancialYearEnd;

      // 2. استدعاء العطلات من طبقة البيانات (Repository)
      final holidaysResult = await holidaysRepository.getFinancialYearHolidays(
        start,
        end,
      );

      return holidaysResult.fold((failure) => Left(failure), (holidays) async {
        // 3. جدولة العطلات المستقبلية فقط
        for (var holiday in holidays) {
          // نحدد وقت الإشعار: الساعة 9:00 صباحاً في يوم العطلة
          final scheduledDate = DateTime(
            holiday.startDate.year,
            holiday.startDate.month,
            holiday.startDate.day,
            9, // الساعة 9 صباحاً
            0,
          );

          // نتحقق أن وقت الإشعار المجدول لم يمر بعد (مستقبلي)
          if (scheduledDate.isAfter(now)) {
            // بناء Payload متوافق مع NotificationFlowManager الخاص بك للتوجيه
            final payload =
                '{"type": "holiday_alert", "holidayId": "${holiday.id}"}';

            // 4. تمرير البيانات لخدمة الإشعارات للجدولة
            await notificationService.scheduleHolidayNotification(
              id: holiday.id, // استخدام معرّف العطلة كمعرّف للإشعار لتسهيل إدارته
              title: 'تذكير بعطلة: ${holiday.name}',
              body: 'تبدأ اليوم عطلة ${holiday.name}، اضغط هنا لاتخاذ قرار ؟!',
              scheduledDate: scheduledDate,
              payload: payload,
            );
            // 5. الحفظ المسبق (Pre-Save) في قاعدة البيانات بتاريخ مستقبلي
            await notificationRepository.saveNotification(
                title: 'تذكير عطلة: ${holiday.name}',
                body: 'لا تنسَ عطلتك القادمة ${holiday.name}. استمتع بوقتك!',
                payload: payload,
                createdAt: scheduledDate, // يضمن عدم ظهوره في شاشة الإشعارات قبل أوانه
              );
          }
        }
        return const Right(unit);
      });
    } catch (e, stackTrace) {
      debugPrint('Error scheduling holidays: $e\n$stackTrace');
      return Left(ServerFailure('حدث خطأ أثناء جدولة الإشعارات: $e'));
    }
  }
}
