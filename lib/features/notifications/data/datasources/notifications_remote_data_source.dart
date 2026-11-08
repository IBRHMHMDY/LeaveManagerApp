import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:leave_manager/core/constants/api_constants.dart';
import 'package:leave_manager/core/errors/exceptions.dart';
import 'package:leave_manager/core/network/dio_client.dart';
import 'package:leave_manager/features/notifications/data/models/device_sync_request_model.dart';
import 'package:leave_manager/core/services/device_identity_service.dart';
import 'package:leave_manager/core/di/injection_container.dart';

abstract class NotificationsRemoteDataSource {
  Future<void> syncDevice(DeviceSyncRequestModel requestModel);
  Future<void> trackNotification({
    required String remoteId,
    required String event,
  });
}

@LazySingleton(as: NotificationsRemoteDataSource)
class NotificationsRemoteDataSourceImpl implements NotificationsRemoteDataSource {
  final DioClient _dioClient;

  const NotificationsRemoteDataSourceImpl(this._dioClient);

  @override
  Future<void> syncDevice(DeviceSyncRequestModel requestModel) async {
    try {
      final response = await _dioClient.dio.post(
        ApiConstants.syncDevice,
        data: requestModel.toJson(), // يتضمن: fcm_token, os_type, app_version, device_id, device_model
      );

      final statusCode = response.statusCode ?? 500;
      if (statusCode < 200 || statusCode >= 300) {
        throw ServerException('Failed to sync device', statusCode: statusCode);
      }
    } on DioException catch (dioError, stackTrace) {
      debugPrint('Dio Sync Device Error: $dioError\n$stackTrace');
      throw ServerException.fromDioException(dioError);
    } catch (e, stackTrace) {
      debugPrint('Unexpected Sync Device Error: $e\n$stackTrace');
      if (e is ServerException) rethrow;
      throw const ServerException('حدث خطأ غير متوقع أثناء مزامنة الجهاز.');
    }
  }

  @override
  Future<void> trackNotification({
    required String remoteId,
    required String event,
  }) async {
    try {
      final deviceId = await sl<DeviceIdentityService>().getDeviceId();
      final response = await _dioClient.dio.post(
        ApiConstants.trackNotification,
        data: {
          'notification_id': remoteId, 
          'event': event, // 'OPENED' or 'DELIVERED'
          'device_id': deviceId, 
        },
      );

      final statusCode = response.statusCode ?? 500;
      if (statusCode < 200 || statusCode >= 300) {
        throw ServerException('Failed to track notification', statusCode: statusCode);
      }
    } on DioException catch (dioError) {
      debugPrint('Dio Track Notification Error: $dioError');
      throw ServerException.fromDioException(dioError);
    } catch (e) {
      debugPrint('Unexpected Track Notification Error: $e');
      throw const ServerException('حدث خطأ غير متوقع أثناء تتبع الإشعار.');
    }
  }
}