// lib/features/notifications/data/repositories/notifications_repository_impl.dart
import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
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

/// التنفيذ الفعلي لمستودع الإشعارات وفق معمارية Clean Architecture (AMD 2026).
/// يحتوي حصرياً على كتل try/catch لتحويل الـ Exceptions إلى Failures.
@LazySingleton(as: NotificationsRepository)
class NotificationsRepositoryImpl implements NotificationsRepository {
  final NotificationsRemoteDataSource _remoteDataSource;
  final NotificationsLocalDataSource _localDataSource;
  final NetworkInfo _networkInfo;

  /// منشئ الكلاس يستقبل مصادر البيانات وفاحص الشبكة عبر الحقن التلقائي.
  const NotificationsRepositoryImpl(
    this._remoteDataSource,
    this._localDataSource,
    this._networkInfo,
  );

  @override
  Future<Either<Failure, Unit>> syncDeviceWithServer(
    DeviceSyncParams params,
  ) async {
    try {
      // 1. التحقق مما إذا كان التوكن والإصدار قد تمت مزامنتهما مسبقاً لتجنب طلبات الشبكة الزائدة
      final syncFingerprint = '${params.fcmToken}_${params.appVersion}';
      if (!params.forceSync) {
        final lastSynced = await _localDataSource.getLastSyncedFcmToken();
        if (lastSynced == syncFingerprint) {
          return const Right(unit);
        }
      }

      // 2. التحقق من توفر اتصال بالإنترنت
      if (!await _networkInfo.isConnected) {
        return const Left(NetworkFailure());
      }

      // 3. إرسال الطلب إلى نظام AppsNotifiersSystem
      final requestModel = DeviceSyncRequestModel.fromDomain(params);
      await _remoteDataSource.syncDevice(requestModel);

      // 4. تخزين بصمة المزامنة في التخزين الآمن بعد النجاح
      await _localDataSource.cacheSyncedFcmToken(syncFingerprint);

      return const Right(unit);
    } on ServerException catch (e, stackTrace) {
      debugPrint('Repo ServerException: ${e.message}\n$stackTrace');
      return Left(ServerFailure(e.message, statusCode: e.statusCode));
    } on CacheException catch (e, stackTrace) {
      debugPrint('Repo CacheException: ${e.message}\n$stackTrace');
      return Left(CacheFailure(e.message));
    } catch (e, stackTrace) {
      debugPrint('Repo Unknown Sync Error: $e\n$stackTrace');
      return const Left(ServerFailure('حدث خطأ غير متوقع أثناء مزامنة الجهاز.'));
    }
  }

  @override
  Future<Either<Failure, Unit>> saveNotification(
    AppNotificationEntity notification,
  ) async {
    try {
      final companion = notification.toCompanion();
      await _localDataSource.insertNotification(companion);
      return const Right(unit);
    } on DatabaseException catch (e, stackTrace) {
      debugPrint('Repo SaveNotification Error: ${e.message}\n$stackTrace');
      return Left(DatabaseFailure(e.message));
    } catch (e, stackTrace) {
      debugPrint('Repo SaveNotification Unknown Error: $e\n$stackTrace');
      return const Left(DatabaseFailure('تعذر حفظ الإشعار محلياً.'));
    }
  }

  @override
  Future<Either<Failure, List<AppNotificationEntity>>>
      getLocalNotifications() async {
    try {
      final models = await _localDataSource.getAllNotifications();
      final entities = models.map((model) => model.toDomain()).toList();
      return Right(entities);
    } on DatabaseException catch (e, stackTrace) {
      debugPrint('Repo GetNotifications Error: ${e.message}\n$stackTrace');
      return Left(DatabaseFailure(e.message));
    } catch (e, stackTrace) {
      debugPrint('Repo GetNotifications Unknown Error: $e\n$stackTrace');
      return const Left(DatabaseFailure('تعذر جلب قائمة الإشعارات.'));
    }
  }

  @override
  Future<Either<Failure, int>> getUnreadCount() async {
    try {
      final count = await _localDataSource.getUnreadNotificationsCount();
      return Right(count);
    } on DatabaseException catch (e, stackTrace) {
      debugPrint('Repo GetUnreadCount Error: ${e.message}\n$stackTrace');
      return Left(DatabaseFailure(e.message));
    } catch (e, stackTrace) {
      debugPrint('Repo GetUnreadCount Unknown Error: $e\n$stackTrace');
      return const Left(DatabaseFailure('تعذر جلب عدد الإشعارات غير المقروءة.'));
    }
  }

  @override
  Future<Either<Failure, Unit>> markAsRead(int id) async {
    try {
      await _localDataSource.markNotificationAsRead(id);
      return const Right(unit);
    } on DatabaseException catch (e, stackTrace) {
      debugPrint('Repo MarkAsRead Error: ${e.message}\n$stackTrace');
      return Left(DatabaseFailure(e.message));
    } catch (e, stackTrace) {
      debugPrint('Repo MarkAsRead Unknown Error: $e\n$stackTrace');
      return const Left(DatabaseFailure('تعذر تحديث حالة قراءة الإشعار.'));
    }
  }

  @override
  Future<Either<Failure, Unit>> markAllAsRead() async {
    try {
      await _localDataSource.markAllNotificationsAsRead();
      return const Right(unit);
    } on DatabaseException catch (e, stackTrace) {
      debugPrint('Repo MarkAllAsRead Error: ${e.message}\n$stackTrace');
      return Left(DatabaseFailure(e.message));
    } catch (e, stackTrace) {
      debugPrint('Repo MarkAllAsRead Unknown Error: $e\n$stackTrace');
      return const Left(DatabaseFailure('تعذر تحديث كافة الإشعارات كمقروءة.'));
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteNotification(int id) async {
    try {
      await _localDataSource.deleteNotification(id);
      return const Right(unit);
    } on DatabaseException catch (e, stackTrace) {
      debugPrint('Repo DeleteNotification Error: ${e.message}\n$stackTrace');
      return Left(DatabaseFailure(e.message));
    } catch (e, stackTrace) {
      debugPrint('Repo DeleteNotification Unknown Error: $e\n$stackTrace');
      return const Left(DatabaseFailure('تعذر حذف الإشعار.'));
    }
  }

  @override
  Future<Either<Failure, Unit>> clearAllNotifications() async {
    try {
      await _localDataSource.clearAllNotifications();
      return const Right(unit);
    } on DatabaseException catch (e, stackTrace) {
      debugPrint('Repo ClearAll Error: ${e.message}\n$stackTrace');
      return Left(DatabaseFailure(e.message));
    } catch (e, stackTrace) {
      debugPrint('Repo ClearAll Unknown Error: $e\n$stackTrace');
      return const Left(DatabaseFailure('تعذر مسح سجل الإشعارات.'));
    }
  }
}