// lib/core/errors/exceptions.dart
import 'package:dio/dio.dart';

/// استثناء خاص بأخطاء قاعدة البيانات المحلية (Drift).
class DatabaseException implements Exception {
  final String message;

  const DatabaseException(this.message);
}

/// استثناء خاص بأخطاء التحقق من صحة المدخلات.
class ValidationException implements Exception {
  final String message;

  const ValidationException(this.message);
}

/// استثناء خاص بأخطاء التخزين الآمن أو الكاش المحلي.
class CacheException implements Exception {
  final String message;

  const CacheException(this.message);
}

/// استثناء خاص بأخطاء الخادم (API) مع دعم تحويل أخطاء Dio تلقائياً.
class ServerException implements Exception {
  final String message;
  final int? statusCode;

  const ServerException(this.message, {this.statusCode});

  /// دالة مصنعية لتحويل [DioException] إلى رسالة خطأ عربية واضحة للمستخدم.
  factory ServerException.fromDioException(DioException dioError) {
    final statusCode = dioError.response?.statusCode;
    final responseData = dioError.response?.data;

    switch (dioError.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return ServerException(
          'انتهت مهلة الاتصال بالخادم، يرجى المحاولة لاحقاً.',
          statusCode: statusCode,
        );
      case DioExceptionType.connectionError:
        return ServerException(
          'تعذر الاتصال بالخادم، تحقق من اتصالك بالإنترنت.',
          statusCode: statusCode,
        );
      case DioExceptionType.badResponse:
        if (statusCode == 401 || statusCode == 403) {
          return ServerException(
            'مفتاح التطبيق غير صالح أو غير مصرح له بالوصول.',
            statusCode: statusCode,
          );
        }
        if (statusCode == 422 && responseData is Map<String, dynamic>) {
          final serverMessage = responseData['message'] as String?;
          return ServerException(
            serverMessage ?? 'البيانات المرسلة للخادم غير صالحة.',
            statusCode: statusCode,
          );
        }
        return ServerException(
          'حدث خطأ من الخادم (كود: ${statusCode ?? "غير معروف"}).',
          statusCode: statusCode,
        );
      case DioExceptionType.cancel:
        return ServerException(
          'تم إلغاء الطلب قبل اكتماله.',
          statusCode: statusCode,
        );
      case DioExceptionType.badCertificate:
      case DioExceptionType.unknown:
        return ServerException(
          'حدث خطأ غير متوقع أثناء الاتصال بالخادم.',
          statusCode: statusCode,
        );
      case DioExceptionType.transformTimeout:
        throw UnimplementedError();
    }
  }
}