import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/leave_record_entity.dart';

abstract class LeaveRepository {
  /// إضافة إجازة جديدة
  Future<Either<Failure, Unit>> addLeave(LeaveRecord leave);
  
  /// جلب جميع الإجازات ضمن نطاق زمني معين (للسنة المالية)
  Future<Either<Failure, List<LeaveRecord>>> getLeavesBetweenDates(DateTime start, DateTime end);
}
