// lib/features/app_updates/domain/repositories/app_updates_repository.dart

import 'package:dartz/dartz.dart';
import 'package:leave_manager/core/errors/failures.dart';
import 'package:leave_manager/features/app_updates/domain/entities/app_update_info.dart';

abstract class AppUpdatesRepository {
  Future<Either<Failure, AppUpdateInfo>> checkUpdate({
    required String currentVersion,
    required String osType,
    required String deviceId,
  });
}