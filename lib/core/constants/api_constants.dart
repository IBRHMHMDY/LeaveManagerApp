// lib/core/constants/api_constants.dart
import 'package:flutter_dotenv/flutter_dotenv.dart';

/// ثوابت الاتصال بنظام الإشعارات المركزي (AppsNotifiersSystem).
abstract final class ApiConstants {
  /// الرابط الأساسي للـ API من ملف البيئة.
  static String get baseUrl =>
      dotenv.env['BASE_URL'] ?? 'https://localhost/api/v1';

  /// مفتاح المصادقة الخاص بتطبيق Leave Manager.
  static String get appKey => dotenv.env['APP_KEY'] ?? '';

  /// اسم الترويسة المطلوبة في Middleware (VerifyAppKey) داخل نظام Laravel.
  static const String appKeyHeader = 'X-App-Key';

  /// نقطة النهاية لمزامنة بيانات الجهاز ورمز FCM.
  static const String syncDeviceEndpoint = '/devices/sync';

  /// نقطة النهاية للتحقق من تحديثات التطبيق.
  static const String checkUpdateEndpoint = '/updates/check';

  /// مهلة الاتصال والرد الافتراضية.
  static const Duration connectTimeout = Duration(seconds: 15);
  static const Duration receiveTimeout = Duration(seconds: 15);
}