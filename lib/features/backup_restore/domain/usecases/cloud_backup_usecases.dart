// lib/features/backup_restore/domain/usecases/cloud_backup_usecases.dart
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:leave_manager/core/errors/failures.dart';
import 'package:leave_manager/core/usecases/base_usecase.dart';
import 'package:leave_manager/features/backup_restore/domain/entities/backup_metadata.dart';
import 'package:leave_manager/features/backup_restore/domain/repositories/backup_repository.dart';

@lazySingleton
class BackupToCloudUseCase implements BaseUseCase<Unit, NoParams> {
  final BackupRepository repository;
  BackupToCloudUseCase(this.repository);

  @override
  Future<Either<Failure, Unit>> call(NoParams params) async {
    return await repository.backupToCloud();
  }
}

@lazySingleton
class RestoreFromCloudUseCase implements BaseUseCase<Unit, NoParams> {
  final BackupRepository repository;
  RestoreFromCloudUseCase(this.repository);

  @override
  Future<Either<Failure, Unit>> call(NoParams params) async {
    return await repository.restoreFromCloud();
  }
}

@lazySingleton
class GetLastCloudBackupMetadataUseCase implements BaseUseCase<BackupMetadata?, NoParams> {
  final BackupRepository repository;
  GetLastCloudBackupMetadataUseCase(this.repository);

  @override
  Future<Either<Failure, BackupMetadata?>> call(NoParams params) async {
    return await repository.getLastCloudBackupMetadata();
  }
}