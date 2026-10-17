// lib/features/notifications/data/datasources/notifications_remote_data_source.dart
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:leave_manager/core/constants/api_constants.dart';
import 'package:leave_manager/core/errors/exceptions.dart';
import 'package:leave_manager/core/network/dio_client.dart';
import 'package:leave_manager/features/notifications/data/models/device_sync_request_model.dart';

/// العقد البرمجي لمصدر البيانات البعيد الخاص بمزامنة الجهاز مع الخادم.
abstract class NotificationsRemoteDataSource {
  /// إرسال بيانات الجهاز ورمز FCM إلى نقطة النهاية في نظام AppsNotifiersSystem.
  Future<void> syncDevice(DeviceSyncRequestModel requestModel);
}

/// التنفيذ الفعلي لمصدر البيانات البعيد باستخدام [DioClient].
@LazySingleton(as: NotificationsRemoteDataSource)
class NotificationsRemoteDataSourceImpl
    implements NotificationsRemoteDataSource {
  final DioClient _dioClient;

  /// منشئ الكلاس يستقبل [DioClient] عبر الحقن التلقائي للتبعيات.
  const NotificationsRemoteDataSourceImpl(this._dioClient);

  @override
  Future<void> syncDevice(DeviceSyncRequestModel requestModel) async {
    try {
      final response = await _dioClient.dio.post<Map<String, dynamic>>(
        ApiConstants.syncDeviceEndpoint,
        data: requestModel.toJson(),
      );

      final statusCode = response.statusCode ?? 500;
      if (statusCode < 200 || statusCode >= 300) {
        throw ServerException(
          'فشلت مزامنة الجهاز مع الخادم.',
          statusCode: statusCode,
        );
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
}