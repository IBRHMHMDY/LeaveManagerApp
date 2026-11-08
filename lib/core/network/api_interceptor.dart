import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:leave_manager/core/constants/api_constants.dart';

@lazySingleton
class ApiInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // إضافة المفتاح الأمني الأساسي لجميع الطلبات
    options.headers['X-App-Key'] = ApiConstants.appKey;
    options.headers['Accept'] = 'application/json';
    options.headers['Content-Type'] = 'application/json';
    
    super.onRequest(options, handler);
  }
}