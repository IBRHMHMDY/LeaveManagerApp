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
    required String deviceId,
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
    required String deviceId,
  }) async {
    try {
      final response = await _dioClient.dio.get(
        ApiConstants.initConfig,
        queryParameters: {
          'app_version': currentVersion,
          'platform': osType,
          'device_id': deviceId,
        },
      );

      final statusCode = response.statusCode ?? 500;
      if (statusCode >= 200 && statusCode < 300 && response.data != null) {
        // فحص بنية الرد، إذا كان الباكند يُرجع البيانات داخل مفتاح 'data' أو مباشرة
        final responseData = response.data['data'] ?? response.data;
        return AppUpdateModel.fromJson(responseData);
      } else {
        throw ServerException('Failed to check updates', statusCode: statusCode);
      }
    } on DioException catch (dioError, stackTrace) {
      debugPrint('Dio Check Update Error: $dioError\n$stackTrace');
      throw ServerException.fromDioException(dioError);
    } catch (e, stackTrace) {
      debugPrint('Unexpected Check Update Error: $e\n$stackTrace');
      throw const ServerException('حدث خطأ غير متوقع أثناء فحص التحديثات.');
    }
  }
}