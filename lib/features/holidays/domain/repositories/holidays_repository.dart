import 'package:dartz/dartz.dart';
import 'package:leave_manager/core/errors/failures.dart';
import 'package:leave_manager/features/holidays/domain/entities/holiday_entity.dart';

abstract class HolidaysRepository {
  /// التأكد من وجود العطلات، وإلا يتم جلبها من ملف JSON
  Future<Either<Failure, Unit>> initializeHolidays();
  
  /// جلب العطلة القادمة (أو الحالية) بناءً على تاريخ اليوم
  Future<Either<Failure, Holiday?>> getUpcomingHoliday(DateTime today);
  
  /// جلب قائمة العطلات ضمن نطاق زمني محدد (للسنة المالية)
  Future<Either<Failure, List<Holiday>>> getFinancialYearHolidays(DateTime start, DateTime end);
}