import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:leave_manager/core/errors/failures.dart';
import 'package:leave_manager/core/utils/check_network_info.dart';
import 'package:leave_manager/features/backup_restore/data/datasources/local_backup_data_source.dart';
import 'package:leave_manager/features/backup_restore/data/datasources/remote_backup_data_source.dart';
import 'package:leave_manager/features/backup_restore/domain/entities/backup_metadata.dart';
import 'package:leave_manager/features/backup_restore/domain/repositories/backup_repository.dart';
import 'package:leave_manager/core/database/app_database.dart';
import 'package:flutter/foundation.dart';

@LazySingleton(as: BackupRepository)
class BackupRepositoryImpl implements BackupRepository {
  final LocalBackupDataSource localDataSource;
  final RemoteBackupDataSource remoteDataSource;
  final AppDatabase appDatabase;
  final CheckNetworkInfo networkInfo;

  BackupRepositoryImpl({
    required this.localDataSource,
    required this.remoteDataSource,
    required this.appDatabase,
    required this.networkInfo,
  });

  // // 💡 دالة مساعدة للتحقق من الإنترنت
  // Future<bool> _isConnected() async {
  //   final connectivityResult = await Connectivity().checkConnectivity();
  //   // في الإصدارات الحديثة (6.1+) ترجع قائمة، نتحقق إذا كانت تحتوي على none فقط
  //   if (connectivityResult.contains(ConnectivityResult.none) && connectivityResult.length == 1) {
  //     return false;
  //   }
  //   return true;
  // }

  @override
@override
  Future<Either<Failure, Unit>> signInWithGoogle() async {
    // 👈 استخدام الأداة المحقونة بدلاً من الدالة الداخلية
    if (!await networkInfo.isConnected) return const Left(ValidationFailure('يجب تشغيل شبكة الإنترنت أولاً.'));
    try {
      await remoteDataSource.signInWithGoogle();
      return const Right(unit);
    } catch (e, stackTrace) {
      debugPrint('SignIn Error: $e\n$stackTrace');
      return const Left(ValidationFailure('تعذر تسجيل الدخول بحساب Google.'));
    }
  }

  @override
  Future<Either<Failure, Unit>> signOutFromGoogle() async {
    if (!await networkInfo.isConnected) return const Left(ValidationFailure('يجب تشغيل شبكة الإنترنت أولاً.'));
    try {
      await remoteDataSource.signOutFromGoogle();
      return const Right(unit);
    } catch (e, stackTrace) {
      return const Left(ValidationFailure('تعذر تسجيل الخروج.'));
    }
  }

  @override
  Future<Either<Failure, bool>> isGoogleSignedIn() async {
    if (!await networkInfo.isConnected) return const Right(false); // نعتبره غير متصل سحابياً إذا لم يوجد إنترنت
    try {
      final isSignedIn = await remoteDataSource.isGoogleSignedIn();
      return Right(isSignedIn);
    } catch (e) {
      return const Left(ValidationFailure('خطأ في التحقق من حالة الدخول.'));
    }
  }

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

  @override
  Future<Either<Failure, Unit>> backupToCloud() async {
    if (!await networkInfo.isConnected) return const Left(ValidationFailure('يجب تشغيل شبكة الإنترنت أولاً.'));
    try {
      final dbFile = await localDataSource.getDatabaseFile();
      await remoteDataSource.backupToCloud(dbFile);
      return const Right(unit);
    } catch (e, stackTrace) {
      return const Left(DatabaseFailure('فشل رفع النسخة الاحتياطية إلى السحابة.'));
    }
  }

  @override
  Future<Either<Failure, Unit>> restoreFromCloud() async {
    if (!await networkInfo.isConnected) return const Left(ValidationFailure('يجب تشغيل شبكة الإنترنت أولاً.'));
    try {
      await appDatabase.close();
      final destinationFile = await localDataSource.getDatabaseFile();
      await remoteDataSource.restoreFromCloud(destinationFile);
      return const Right(unit);
    } catch (e, stackTrace) {
      return const Left(DatabaseFailure('فشل تنزيل واستعادة النسخة السحابية.'));
    }
  }

  @override
  Future<Either<Failure, BackupMetadata?>> getLastCloudBackupMetadata() async {
    if (!await networkInfo.isConnected) return const Right(null);
    try {
      final metadata = await remoteDataSource.getLastCloudBackupMetadata();
      return Right(metadata);
    } catch (e) {
      return const Left(ValidationFailure('تعذر جلب بيانات آخر نسخة احتياطية.'));
    }
  }
}