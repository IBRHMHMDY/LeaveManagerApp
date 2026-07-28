// lib/features/rest_allowances/domain/repositories/rest_allowances_repository.dart
import 'package:dartz/dartz.dart';
import 'package:leave_manager/core/errors/failures.dart';
import 'package:leave_manager/features/rest_allowances/domain/entities/overtime_record_entity.dart';
import 'package:leave_manager/features/rest_allowances/domain/entities/rest_allowance_entity.dart';

abstract class RestAllowancesRepository {
  // عمليات العمل الإضافي
  Future<Either<Failure, Unit>> addOvertimeRecord(OvertimeRecord record);
  Future<Either<Failure, List<OvertimeRecord>>> getOvertimeRecords();
  Future<Either<Failure, Unit>> updateOvertimeConsumedStatus(int id, bool isConsumed);
  Future<Either<Failure, Unit>> deleteOvertimeRecord(int id);

  // عمليات بدلات الراحة
  Future<Either<Failure, Unit>> addRestAllowance(RestAllowance allowance);
  Future<Either<Failure, List<RestAllowance>>> getRestAllowances();
  Future<Either<Failure, Unit>> deleteRestAllowance(int id);
}