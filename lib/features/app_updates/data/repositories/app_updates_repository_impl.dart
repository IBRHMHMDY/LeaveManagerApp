// lib/features/app_updates/data/repositories/app_updates_repository_impl.dart

import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:leave_manager/core/errors/exceptions.dart';
import 'package:leave_manager/core/errors/failures.dart';
import 'package:leave_manager/core/network/network_info.dart';
import 'package:leave_manager/features/app_updates/data/datasources/app_updates_remote_data_source.dart';
import 'package:leave_manager/features/app_updates/domain/entities/app_update_info.dart';
import 'package:leave_manager/features/app_updates/domain/repositories/app_updates_repository.dart';

@LazySingleton(as: AppUpdatesRepository)
class AppUpdatesRepositoryImpl implements AppUpdatesRepository {
  final AppUpdatesRemoteDataSource _remoteDataSource;
  final NetworkInfo _networkInfo;

  const AppUpdatesRepositoryImpl(this._remoteDataSource, this._networkInfo);

  @override
  Future<Either<Failure, AppUpdateInfo>> checkUpdate({
    required String currentVersion,
    required String osType,
    required String deviceId,
  }) async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      final remoteData = await _remoteDataSource.checkUpdate(
        currentVersion: currentVersion,
        osType: osType,
        deviceId: deviceId,
      );
      return Right(remoteData);
    } on ServerException catch (e, stackTrace) {
      debugPrint('Repo CheckUpdate ServerException: ${e.message}\n$stackTrace');
      return Left(ServerFailure(e.message, statusCode: e.statusCode));
    } catch (e, stackTrace) {
      debugPrint('Repo CheckUpdate Unknown Error: $e\n$stackTrace');
      return const Left(ServerFailure('حدث خطأ غير متوقع.'));
    }
  }
}