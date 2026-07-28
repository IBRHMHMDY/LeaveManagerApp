// lib/features/rest_allowances/data/repositories/rest_allowances_repository_impl.dart
import 'package:dartz/dartz.dart';
import 'package:drift/drift.dart';
import 'package:injectable/injectable.dart';
import 'package:leave_manager/core/database/app_database.dart';
import 'package:leave_manager/core/errors/exceptions.dart';
import 'package:leave_manager/core/errors/failures.dart';
import 'package:leave_manager/features/rest_allowances/data/datasources/rest_allowances_local_data_source.dart';
import 'package:leave_manager/features/rest_allowances/data/models/overtime_record_mapper.dart';
import 'package:leave_manager/features/rest_allowances/data/models/rest_allowance_mapper.dart';
import 'package:leave_manager/features/rest_allowances/domain/entities/overtime_record_entity.dart';
import 'package:leave_manager/features/rest_allowances/domain/entities/rest_allowance_entity.dart';
import 'package:leave_manager/features/rest_allowances/domain/repositories/rest_allowances_repository.dart';
import 'package:leave_manager/core/utils/enums/work_reason.dart';

@LazySingleton(as: RestAllowancesRepository)
class RestAllowancesRepositoryImpl implements RestAllowancesRepository {
  final RestAllowancesLocalDataSource localDataSource;

  RestAllowancesRepositoryImpl(this.localDataSource);

  // ==========================================
  // 1. عمليات العمل الإضافي (Overtime Records)
  // ==========================================

  @override
  Future<Either<Failure, Unit>> addOvertimeRecord(OvertimeRecord record) async {
    try {
      final companion = OvertimeRecordsTableCompanion(
        workReason: Value(record.workReason == WorkReason.holiday ? 0 : 1),
        startDate: Value(record.startDate),
        endDate: Value(record.endDate),
        daysCount: Value(record.daysCount),
        holidayId: Value(record.holidayId),
        isConsumed: Value(record.isConsumed),
        notes: record.notes != null && record.notes!.isNotEmpty 
            ? Value(record.notes) 
            : const Value.absent(),
      );
      await localDataSource.addOvertimeRecord(companion);
      return const Right(unit);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<OvertimeRecord>>> getOvertimeRecords() async {
    try {
      final models = await localDataSource.getOvertimeRecords();
      final domainEntities = models.map((model) => model.toDomain()).toList();
      return Right(domainEntities);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, Unit>> updateOvertimeConsumedStatus(int id, bool isConsumed) async {
    try {
      await localDataSource.updateOvertimeConsumedStatus(id, isConsumed);
      return const Right(unit);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteOvertimeRecord(int id) async {
    try {
      await localDataSource.deleteOvertimeRecord(id);
      return const Right(unit);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    }
  }

  // ==========================================
  // 2. عمليات بدلات الراحة (Rest Allowances)
  // ==========================================

  @override
  Future<Either<Failure, Unit>> addRestAllowance(RestAllowance allowance) async {
    try {
      final companion = RestAllowancesTableCompanion(
        // تحويل الـ Enum إلى Integer
        workReason: Value(allowance.workReason == WorkReason.holiday ? 0 : 1),
        overtimeId: Value(allowance.overtimeId),
        startDate: Value(allowance.startDate),
        endDate: Value(allowance.endDate),
        daysCount: Value(allowance.daysCount),
        notes: allowance.notes != null && allowance.notes!.isNotEmpty 
            ? Value(allowance.notes) 
            : const Value.absent(),
      );
      await localDataSource.addRestAllowance(companion);
      return const Right(unit);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message)); // استخدام dartz لمعالجة الأخطاء
    }
  }

  @override
  Future<Either<Failure, List<RestAllowance>>> getRestAllowances() async {
    try {
      final models = await localDataSource.getRestAllowances();
      final domainEntities = models.map((model) => model.toDomain()).toList();
      return Right(domainEntities);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteRestAllowance(int id) async {
    try {
      await localDataSource.deleteRestAllowance(id);
      return const Right(unit);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    }
  }
}