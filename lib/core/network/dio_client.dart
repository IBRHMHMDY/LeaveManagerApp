// lib/core/network/dio_client.dart
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:leave_manager/core/constants/api_constants.dart';
import 'package:leave_manager/core/network/interceptors/app_key_interceptor.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

/// العميل المركزي للشبكة المسؤول عن إعداد Dio وربط الـ Interceptors.
@lazySingleton
class DioClient {
  final Dio _dio;

  /// يقوم بتهيئة إعدادات Dio الأساسية وإضافة المسجلات في وضع الـ Debug فقط.
  DioClient(AppKeyInterceptor appKeyInterceptor)
      : _dio = Dio(
          BaseOptions(
            baseUrl: ApiConstants.baseUrl,
            connectTimeout: ApiConstants.connectTimeout,
            receiveTimeout: ApiConstants.receiveTimeout,
            responseType: ResponseType.json,
          ),
        ) {
    _dio.interceptors.add(appKeyInterceptor);

    if (kDebugMode) {
      _dio.interceptors.add(
        PrettyDioLogger(
          requestHeader: true,
          requestBody: true,
          responseBody: true,
          responseHeader: false,
          error: true,
          compact: true,
        ),
      );
    }
  }

  /// إرجاع نسخة Dio المهيأة للاستخدام في طبقة DataSources.
  Dio get dio => _dio;
}