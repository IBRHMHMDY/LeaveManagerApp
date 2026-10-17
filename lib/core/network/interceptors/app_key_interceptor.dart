// lib/core/network/interceptors/app_key_interceptor.dart
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:leave_manager/core/constants/api_constants.dart';

/// Interceptor يقوم بحقن مفتاح التطبيق (X-App-Key) وترويسات JSON القياسية
/// تلقائياً في كل طلب صادر إلى نظام AppsNotifiersSystem.
@lazySingleton
class AppKeyInterceptor extends Interceptor {
  /// منشئ الكلاس.
  const AppKeyInterceptor();

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.headers.addAll({
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      ApiConstants.appKeyHeader: ApiConstants.appKey,
    });
    handler.next(options);
  }
}