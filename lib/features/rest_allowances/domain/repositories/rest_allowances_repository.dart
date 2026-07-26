import 'package:dartz/dartz.dart';
import 'package:leave_manager/core/errors/failures.dart';
import 'package:leave_manager/features/rest_allowances/domain/entities/rest_allowance_entity.dart';

abstract class RestAllowancesRepository {
  /// جلب جميع سجلات بدلات الراحة (مكتسبة ومستهلكة)
  Future<Either<Failure, List<RestAllowance>>> getRestAllowances();
  
  /// إضافة سجل بدل راحة جديد (مكتسب أو مستهلك)
  Future<Either<Failure, Unit>> addRestAllowance(RestAllowance allowance);
  
  /// حذف سجل بدل راحة
  Future<Either<Failure, Unit>> deleteRestAllowance(int id);
}