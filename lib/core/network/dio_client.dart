import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:leave_manager/core/constants/api_constants.dart';
import 'package:leave_manager/core/network/api_interceptor.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

@lazySingleton
class DioClient {
  final Dio dio;
  final ApiInterceptor apiInterceptor;

  DioClient(this.dio, this.apiInterceptor) {
    dio.options = BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      sendTimeout: const Duration(seconds: 15),
    );

    dio.interceptors.add(apiInterceptor);

    // تفعيل الـ Logger في وضع الـ Debug فقط لعدم استهلاك الموارد في الإنتاج
    assert(() {
      dio.interceptors.add(
        PrettyDioLogger(
          requestHeader: true,
          requestBody: true,
          responseBody: true,
          responseHeader: false,
          error: true,
          compact: true,
        ),
      );
      return true;
    }());
  }
}