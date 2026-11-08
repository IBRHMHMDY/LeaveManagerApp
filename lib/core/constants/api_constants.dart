import 'package:flutter_dotenv/flutter_dotenv.dart';

abstract final class ApiConstants {
  static String get baseUrl => dotenv.env['API_BASE_URL'] ?? 'https://apps.ibrahimhamdy.net/api/v1';
  static String get appKey => dotenv.env['APP_KEY'] ?? '';

  // Endpoints
  static const String initConfig = '/init-config';
  static const String syncDevice = '/devices/sync';
  static const String trackNotification = '/notifications/track';
  static const String holidays = '/holidays'; // تحسباً للمرحلة القادمة
}