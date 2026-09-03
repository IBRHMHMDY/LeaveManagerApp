import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:leave_manager/core/errors/failures.dart';
import 'package:leave_manager/features/backup_restore/data/datasources/local_backup_data_source.dart';
import 'package:leave_manager/features/backup_restore/domain/repositories/backup_repository.dart';
import 'package:leave_manager/core/database/app_database.dart';
import 'package:flutter/foundation.dart';

@LazySingleton(as: BackupRepository)
class BackupRepositoryImpl implements BackupRepository {
  final LocalBackupDataSource localDataSource;
  final AppDatabase appDatabase;

  BackupRepositoryImpl({
    required this.localDataSource,
    required this.appDatabase,
  });

  @override
  Future<Either<Failure, String>> backupToLocal() async {
    try {
      final path = await localDataSource.backupToLocal();
      return Right(path);
    } catch (e, stackTrace) {
      debugPrint('Local Backup Error: $e\n$stackTrace');
      return const Left(DatabaseFailure('فشل إنشاء النسخة الاحتياطية المحلية.'));
    }
  }

  @override
  Future<Either<Failure, Unit>> restoreFromLocal() async {
    try {
      await appDatabase.close(); 
      await localDataSource.restoreFromLocal();
      return const Right(unit);
    } catch (e, stackTrace) {
      debugPrint('Local Restore Error: $e\n$stackTrace');
      return Left(DatabaseFailure(e.toString().replaceAll('Exception:', '').trim()));
    }
  }

}