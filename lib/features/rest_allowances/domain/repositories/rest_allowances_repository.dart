import 'package:dartz/dartz.dart';
import 'package:leave_manager/core/errors/failures.dart';
import 'package:leave_manager/features/rest_allowances/domain/entities/rest_allowance_entity.dart';

abstract class RestAllowancesRepository {
  /// جلب جميع بدلات الراحة (مكتسبة ومستهلكة)
  Future<Either<Failure, List<RestAllowance>>> getRestAllowances();
  
  /// إضافة بدل راحة مكتسب جديد
  Future<Either<Failure, Unit>> addEarnedRest(DateTime earnedDate, String? notes);
  
  /// تسجيل استهلاك بدل راحة (طلب إجازة)
  Future<Either<Failure, Unit>> consumeRest(int id, DateTime consumedDate);
  
  /// حذف سجل بدل راحة
  Future<Either<Failure, Unit>> deleteRestAllowance(int id);
}