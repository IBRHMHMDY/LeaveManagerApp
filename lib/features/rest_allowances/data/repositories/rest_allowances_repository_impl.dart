// lib/features/rest_allowances/data/repositories/rest_allowances_repository_impl.dart
import 'package:dartz/dartz.dart';
import 'package:drift/drift.dart';
import 'package:injectable/injectable.dart';
import 'package:leave_manager/core/database/app_database.dart';
import 'package:leave_manager/core/errors/exceptions.dart';
import 'package:leave_manager/core/errors/failures.dart';
import 'package:leave_manager/core/utils/enums/work_reason.dart';
import 'package:leave_manager/features/rest_allowances/data/datasources/rest_allowances_local_data_source.dart';
import 'package:leave_manager/features/rest_allowances/data/models/extra_work_mapper.dart';
import 'package:leave_manager/features/rest_allowances/domain/entities/extra_work_record_entity.dart';
import 'package:leave_manager/features/rest_allowances/domain/repositories/rest_allowances_repository.dart';

@LazySingleton(as: RestAllowancesRepository)
class RestAllowancesRepositoryImpl implements RestAllowancesRepository {
  final RestAllowancesLocalDataSource localDataSource;

  RestAllowancesRepositoryImpl(this.localDataSource);

  @override
  Future<Either<Failure, Unit>> addExtraWork(ExtraWorkRecord record) async {
    try {
      final companion = RestAllowancesTableCompanion(
        workReason: Value(record.workReason == WorkReason.holiday ? 0 : 1),
        workStartDate: Value(record.workStartDate),
        workEndDate: Value(record.workEndDate),
        daysCount: Value(record.daysCount),
        isUsed: Value(record.isUsed),
        holidayId: record.holidayId != null ? Value(record.holidayId) : const Value.absent(),
        notes: record.notes != null && record.notes!.isNotEmpty
            ? Value(record.notes)
            : const Value.absent(),
      );

      await localDataSource.addExtraWork(companion);
      return const Right(unit);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    } catch (e) {
      return const Left(DatabaseFailure('حدث خطأ غير متوقع أثناء الحفظ.'));
    }
  }

  @override
  Future<Either<Failure, List<ExtraWorkRecord>>> getAllExtraWork() async {
    try {
      final models = await localDataSource.getAllExtraWork();
      // تحويل النماذج باستخدام الـ Mapper
      final domainEntities = models.map((model) => model.toDomain()).toList();
      return Right(domainEntities);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    } catch (e) {
      return const Left(DatabaseFailure('حدث خطأ أثناء جلب السجلات.'));
    }
  }

  @override
  Future<Either<Failure, Unit>> useRestAllowance({
    required int id,
    required int usedDaysCount,
    required DateTime restStartDate,
    required DateTime restEndDate,
    String? notes,
  }) async {
    try {
      await localDataSource.useRestAllowance(
        id: id,
        usedDaysCount: usedDaysCount,
        restStartDate: restStartDate,
        restEndDate: restEndDate,
        notes: notes,
      );
      return const Right(unit);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    } catch (e) {
      return const Left(DatabaseFailure('فشل في تحويل الرصيد المتاح.'));
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteExtraWork(int id) async {
    try {
      await localDataSource.deleteExtraWork(id);
      return const Right(unit);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    } catch (e) {
      return const Left(DatabaseFailure('حدث خطأ أثناء محاولة الحذف.'));
    }
  }
}