// lib/features/notifications/data/repositories/notifications_repository_impl.dart

import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:leave_manager/core/errors/exceptions.dart';
import 'package:leave_manager/core/errors/failures.dart';
import 'package:leave_manager/core/network/network_info.dart';
import 'package:leave_manager/features/notifications/data/datasources/notifications_local_data_source.dart';
import 'package:leave_manager/features/notifications/data/datasources/notifications_remote_data_source.dart';
import 'package:leave_manager/features/notifications/data/models/device_sync_request_model.dart';
import 'package:leave_manager/features/notifications/data/models/notification_mapper.dart';
import 'package:leave_manager/features/notifications/domain/entities/app_notification_entity.dart';
import 'package:leave_manager/features/notifications/domain/entities/device_sync_params.dart';
import 'package:leave_manager/features/notifications/domain/repositories/notifications_repository.dart';

@LazySingleton(as: NotificationsRepository)
class NotificationsRepositoryImpl implements NotificationsRepository {
  final NotificationsRemoteDataSource _remoteDataSource;
  final NotificationsLocalDataSource _localDataSource;
  final NetworkInfo _networkInfo;

  const NotificationsRepositoryImpl(
    this._remoteDataSource,
    this._localDataSource,
    this._networkInfo,
  );

  @override
  Future<Either<Failure, Unit>> syncDeviceWithServer(DeviceSyncParams params) async {
    try {
      final syncFingerprint = '${params.fcmToken}_${params.appVersion}';
      if (!params.forceSync) {
        final lastSynced = await _localDataSource.getLastSyncedFcmToken();
        if (lastSynced == syncFingerprint) {
          return const Right(unit);
        }
      }

      if (!await _networkInfo.isConnected) {
        return const Left(NetworkFailure());
      }

      final requestModel = DeviceSyncRequestModel.fromDomain(params);
      await _remoteDataSource.syncDevice(requestModel);
      await _localDataSource.cacheSyncedFcmToken(syncFingerprint);
      
      return const Right(unit);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, statusCode: e.statusCode));
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return const Left(ServerFailure('حدث خطأ غير متوقع.'));
    }
  }

  @override
  Future<Either<Failure, Unit>> trackNotification({
    required String remoteId,
    required String event,
  }) async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      await _remoteDataSource.trackNotification(remoteId: remoteId, event: event);
      return const Right(unit);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, statusCode: e.statusCode));
    } catch (e) {
      return const Left(ServerFailure('حدث خطأ أثناء التتبع.'));
    }
  }

  @override
  Future<Either<Failure, Unit>> saveNotification(AppNotificationEntity notification) async {
    try {
      final companion = notification.toCompanion();
      await _localDataSource.insertNotification(companion);
      return const Right(unit);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    } catch (e) {
      return const Left(DatabaseFailure('حدث خطأ غير متوقع.'));
    }
  }

  @override
  Future<Either<Failure, List<AppNotificationEntity>>> getLocalNotifications() async {
    try {
      final models = await _localDataSource.getAllNotifications();
      final entities = models.map((model) => model.toDomain()).toList();
      return Right(entities);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    } catch (e) {
      return const Left(DatabaseFailure('حدث خطأ غير متوقع.'));
    }
  }

  @override
  Future<Either<Failure, int>> getUnreadCount() async {
    try {
      final count = await _localDataSource.getUnreadNotificationsCount();
      return Right(count);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    } catch (e) {
      return const Left(DatabaseFailure('حدث خطأ غير متوقع.'));
    }
  }

  @override
  Future<Either<Failure, Unit>> markAsRead(int id) async {
    try {
      await _localDataSource.markNotificationAsRead(id);
      return const Right(unit);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    } catch (e) {
      return const Left(DatabaseFailure('حدث خطأ غير متوقع.'));
    }
  }

  @override
  Future<Either<Failure, Unit>> markAllAsRead() async {
    try {
      await _localDataSource.markAllNotificationsAsRead();
      return const Right(unit);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    } catch (e) {
      return const Left(DatabaseFailure('حدث خطأ غير متوقع.'));
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteNotification(int id) async {
    try {
      await _localDataSource.deleteNotification(id);
      return const Right(unit);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    } catch (e) {
      return const Left(DatabaseFailure('حدث خطأ غير متوقع.'));
    }
  }

  @override
  Future<Either<Failure, Unit>> clearAllNotifications() async {
    try {
      await _localDataSource.clearAllNotifications();
      return const Right(unit);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    } catch (e) {
      return const Left(DatabaseFailure('حدث خطأ غير متوقع.'));
    }
  }
}