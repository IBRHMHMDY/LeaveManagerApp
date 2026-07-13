import 'package:dartz/dartz.dart';
import 'package:leave_manager/core/errors/failures.dart';
import 'package:leave_manager/features/rest_allowance/holidays/domain/entities/holiday_entity.dart';


abstract class HolidayRepository {
  /// جلب الإجازات الرسمية خلال فترة زمنية مخصصة لبلد معين
  Future<Either<Failure, List<Holiday>>> getHolidaysBetweenDates(DateTime start, DateTime end);

  /// إضافة إجازة رسمية جديدة
  Future<Either<Failure, Unit>> addHoliday(Holiday holiday);

  /// حذف إجازة رسمية محددة
  Future<Either<Failure, Unit>> deleteHoliday(int id);

  /// مسح جميع الإجازات المسجلة لبلد معين (يُستخدم قبل دمج القائمة الجديدة)
  Future<Either<Failure, Unit>> clearHolidays();
}