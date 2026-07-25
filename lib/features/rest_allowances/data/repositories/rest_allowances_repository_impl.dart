import 'package:dartz/dartz.dart';
import 'package:drift/drift.dart';
import 'package:injectable/injectable.dart';
import 'package:leave_manager/core/database/app_database.dart';
import 'package:leave_manager/core/errors/exceptions.dart';
import 'package:leave_manager/core/errors/failures.dart';
import 'package:leave_manager/features/rest_allowances/data/datasources/rest_allowances_local_data_source.dart';
import 'package:leave_manager/features/rest_allowances/data/models/rest_allowance_mapper.dart';
import 'package:leave_manager/features/rest_allowances/domain/entities/rest_allowance_entity.dart';
import 'package:leave_manager/features/rest_allowances/domain/repositories/rest_allowances_repository.dart';

@LazySingleton(as: RestAllowancesRepository)
class RestAllowancesRepositoryImpl implements RestAllowancesRepository {
  final RestAllowancesLocalDataSource localDataSource;

  RestAllowancesRepositoryImpl(this.localDataSource);

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
  Future<Either<Failure, Unit>> addEarnedRest(DateTime earnedDate, String? notes) async {
    try {
      final companion = RestAllowancesTableCompanion(
        earnedDate: Value(earnedDate),
        notes: notes != null && notes.isNotEmpty ? Value(notes) : const Value.absent(),
      );
      await localDataSource.addRestAllowance(companion);
      return const Right(unit);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, Unit>> consumeRest(int id, DateTime consumedDate) async {
    try {
      // هنا نقوم بتحديث السجل وإضافة تاريخ الاستهلاك
      final companion = RestAllowancesTableCompanion(
        id: Value(id),
        consumedDate: Value(consumedDate),
      );
      await localDataSource.updateRestAllowance(companion);
      return const Right(unit);
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