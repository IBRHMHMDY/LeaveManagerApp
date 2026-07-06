import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/holiday_entity.dart';

abstract class HolidayRepository {
  /// جلب الإجازات الرسمية خلال فترة زمنية مخصصة لبلد معين
  Future<Either<Failure, List<Holiday>>> getHolidaysBetweenDates(DateTime start, DateTime end, String country);

  /// إضافة إجازة رسمية جديدة
  Future<Either<Failure, Unit>> addHoliday(Holiday holiday);

  /// حذف إجازة رسمية محددة
  Future<Either<Failure, Unit>> deleteHoliday(int id);

  /// مسح جميع الإجازات المسجلة لبلد معين (يُستخدم قبل دمج القائمة الجديدة)
  Future<Either<Failure, Unit>> clearHolidaysByCountry(String country);
}