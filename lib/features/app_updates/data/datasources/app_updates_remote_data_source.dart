// lib/features/app_updates/data/datasources/app_updates_remote_data_source.dart

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:leave_manager/core/constants/api_constants.dart';
import 'package:leave_manager/core/errors/exceptions.dart';
import 'package:leave_manager/core/network/dio_client.dart';
import 'package:leave_manager/features/app_updates/data/models/app_update_model.dart';

abstract class AppUpdatesRemoteDataSource {
  Future<AppUpdateModel> checkUpdate({
    required String currentVersion,
    required String osType,
    required String deviceId
  });
}

@LazySingleton(as: AppUpdatesRemoteDataSource)
class AppUpdatesRemoteDataSourceImpl implements AppUpdatesRemoteDataSource {
  final DioClient _dioClient;

  const AppUpdatesRemoteDataSourceImpl(this._dioClient);

  @override
  Future<AppUpdateModel> checkUpdate({
    required String currentVersion,
    required String osType,
    required String deviceId
  }) async {
    try {
      final response = await _dioClient.dio.get(
        ApiConstants.checkUpdate,
        queryParameters: {
          'app_version': currentVersion,
          'os_type': osType,
          'device_id': deviceId,
        },
      );

      final statusCode = response.statusCode ?? 500;
      if (statusCode >= 200 && statusCode < 300 && response.data != null) {
        final data = response.data!['data'];
        
        if (data == null) {
          return const AppUpdateModel(
            updateRequired: false,
            forceUpdate: false,
            message: null,
            storeUrl: null,
          );
        }

        return AppUpdateModel.fromJson(data);
      } else {
        throw ServerException(
          'فشل التحقق من التحديثات',
          statusCode: statusCode,
        );
      }
    } on DioException catch (dioError, stackTrace) {
      debugPrint('Dio Check Update Error: $dioError\n$stackTrace');
      
      if (dioError.response?.statusCode == 500 || dioError.response?.statusCode == 404) {
         debugPrint('تجاوز خطأ الخادم، سيتم إكمال الإقلاع دون تحديثات.');
         return const AppUpdateModel(
           updateRequired: false,
           forceUpdate: false,
           message: null,
           storeUrl: null,
         );
      }

      // معالجة صريحة لأخطاء الاتصال والانقطاع
      if (dioError.type == DioExceptionType.connectionTimeout || 
          dioError.type == DioExceptionType.receiveTimeout ||
          dioError.type == DioExceptionType.connectionError) {
        throw const ServerException('انتهت مهلة الاتصال بالخادم، يرجى التحقق من جودة الإنترنت والمحاولة لاحقاً.');
      }

      throw ServerException.fromDioException(dioError);
    } catch (e, stackTrace) {
      debugPrint('Unexpected Check Update Error: $e\n$stackTrace');
      if (e is ServerException) rethrow;
      throw const ServerException('حدث خطأ غير متوقع أثناء فحص التحديثات.');
    }
  }
}