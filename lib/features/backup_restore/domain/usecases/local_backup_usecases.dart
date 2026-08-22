// lib/features/backup_restore/domain/usecases/local_backup_usecases.dart
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:leave_manager/core/errors/failures.dart';
import 'package:leave_manager/core/usecases/base_usecase.dart';
import 'package:leave_manager/features/backup_restore/domain/repositories/backup_repository.dart';

@lazySingleton
class BackupToLocalUseCase implements BaseUseCase<String, NoParams> {
  final BackupRepository repository;
  BackupToLocalUseCase(this.repository);

  @override
  Future<Either<Failure, String>> call(NoParams params) async {
    return await repository.backupToLocal();
  }
}

@lazySingleton
class RestoreFromLocalUseCase implements BaseUseCase<Unit, NoParams> {
  final BackupRepository repository;
  RestoreFromLocalUseCase(this.repository);

  @override
  Future<Either<Failure, Unit>> call(NoParams params) async {
    return await repository.restoreFromLocal();
  }
}