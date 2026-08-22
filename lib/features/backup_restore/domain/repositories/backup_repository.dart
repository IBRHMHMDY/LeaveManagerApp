// lib/features/backup_restore/domain/repositories/backup_repository.dart
import 'package:dartz/dartz.dart';
import 'package:leave_manager/core/errors/failures.dart';
import 'package:leave_manager/features/backup_restore/domain/entities/backup_metadata.dart';

abstract class BackupRepository {
  // --- مصادقة Google ---
  /// تسجيل الدخول بحساب جوجل
  Future<Either<Failure, Unit>> signInWithGoogle();
  
  /// تسجيل الخروج من حساب جوجل
  Future<Either<Failure, Unit>> signOutFromGoogle();
  
  /// التحقق مما إذا كان المستخدم مسجل الدخول بالفعل
  Future<Either<Failure, bool>> isGoogleSignedIn();

  // --- النسخ الاحتياطي المحلي ---
  /// أخذ نسخة احتياطية محلية (ترجع مسار الملف)
  Future<Either<Failure, String>> backupToLocal();
  
  /// استعادة نسخة احتياطية من ملف محلي
  Future<Either<Failure, Unit>> restoreFromLocal();

  // --- النسخ الاحتياطي السحابي (Google Drive) ---
  /// رفع قاعدة البيانات إلى Google Drive
  Future<Either<Failure, Unit>> backupToCloud();
  
  /// تنزيل واستعادة قاعدة البيانات من Google Drive
  Future<Either<Failure, Unit>> restoreFromCloud();
  
  /// جلب بيانات آخر نسخة احتياطية مرفوعة على السحابة
  Future<Either<Failure, BackupMetadata?>> getLastCloudBackupMetadata();
}