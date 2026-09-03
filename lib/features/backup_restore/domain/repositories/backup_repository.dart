// lib/features/backup_restore/domain/repositories/backup_repository.dart
import 'package:dartz/dartz.dart';
import 'package:leave_manager/core/errors/failures.dart';

abstract class BackupRepository {
  
  // --- النسخ الاحتياطي المحلي ---
  /// أخذ نسخة احتياطية محلية (ترجع مسار الملف)
  Future<Either<Failure, String>> backupToLocal();
  
  /// استعادة نسخة احتياطية من ملف محلي
  Future<Either<Failure, Unit>> restoreFromLocal();

}