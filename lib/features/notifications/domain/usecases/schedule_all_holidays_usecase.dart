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
        final List<Future<void>> futures = [];
        // 3. جدولة العطلات المستقبلية فقط
        for (var holiday in holidays) {
          // نحدد وقت الإشعار: الساعة 10:00 صباحاً في يوم العطلة
          final scheduledDate = DateTime(
            holiday.startDate.year,
            holiday.startDate.month,
            holiday.startDate.day,
            10, // الساعة 10 صباحاً
            0,
          );

          // نتحقق أن وقت الإشعار المجدول لم يمر بعد (مستقبلي)
          if (scheduledDate.isAfter(now)) {
            final payload =
                '{"type": "holiday_alert", "holidayId": "${holiday.id}"}';

            // 4. تمرير البيانات لخدمة الإشعارات للجدولة
            futures.add(
              notificationService.scheduleHolidayNotification(
                id: holiday.id,
                title: 'تذكير بعطله قادمة: ',
                body: 'تذكير بعطله ${holiday.name}!',
                scheduledDate: scheduledDate,
                payload: payload,
              ),
            );
            // 5. الحفظ المسبق (Pre-Save) في قاعدة البيانات بتاريخ مستقبلي
            await notificationRepository.saveNotification(
              title: 'تذكير بعطله قادمة: ',
              body: 'تذكير بعطله ${holiday.name}!',
              payload: payload,
              createdAt: scheduledDate,
            );
          }
        }
        await Future.wait(futures);
        return const Right(unit);
      });
    } catch (e, stackTrace) {
      debugPrint('Error scheduling holidays: $e\n$stackTrace');
      return Left(DatabaseFailure('حدث خطأ أثناء جدولة الإشعارات: $e'));
    }
  }
}
