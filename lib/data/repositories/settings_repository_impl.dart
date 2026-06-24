import 'package:dartz/dartz.dart';
import 'package:drift/drift.dart';
import '../../core/errors/exceptions.dart';
import '../../core/errors/failures.dart';
import '../../domain/entities/settings.dart';
import '../../domain/repositories/settings_repository.dart';
import '../database/app_database.dart';
import '../datasources/local_data_source.dart';
import '../models/mappers.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  final LocalDataSource localDataSource;

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
}