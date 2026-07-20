import 'package:dartz/dartz.dart';
import 'package:drift/drift.dart';
import 'package:injectable/injectable.dart';
import 'package:leave_manager/core/database/app_database.dart';
import 'package:leave_manager/core/errors/exceptions.dart';
import 'package:leave_manager/core/errors/failures.dart';
import 'package:leave_manager/features/settings/data/datasources/settings_local_data_source.dart';
import 'package:leave_manager/features/settings/data/models/settings_mapper.dart';
import 'package:leave_manager/features/settings/domain/entities/settings_entity.dart';
import 'package:leave_manager/features/settings/domain/repositories/settings_repository.dart';

@LazySingleton(as: SettingsRepository)
class SettingsRepositoryImpl implements SettingsRepository {
  final SettingsLocalDataSource localDataSource;

  SettingsRepositoryImpl(this.localDataSource);

  @override
  Future<Either<Failure, bool>> hasSettings() async {
    try {
      final result = await localDataSource.hasSettings();
      return Right(result);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, Settings>> getSettings() async {
    try {
      final settingModel = await localDataSource.getSettings();
      return Right(settingModel.toDomain());
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, Unit>> saveSettings(Settings settings) async {
    try {
      final companion = SettingsTableCompanion(
        id: const Value(1), // تثبيت الـ ID لضمان وجود سجل واحد فقط
        employeeName: Value(settings.employeeName),
        jobTitle: Value(settings.jobTitle),
        totalRegularLeaves: Value(settings.totalRegularLeaves),
        totalCasualLeaves: Value(settings.totalCasualLeaves),
      );
      
      await localDataSource.saveSettings(companion);
      return const Right(unit);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, Unit>> resetBalances() async {
    try {
      await localDataSource.resetBalances();
      return const Right(unit);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    }
  }
}