// lib/core/utils/app_bootstrapper.dart
import 'package:flutter/material.dart';
import 'package:leave_manager/core/di/injection_container.dart';
import 'package:leave_manager/core/utils/notifications/notification_service.dart';
import 'package:leave_manager/core/utils/notifications/timezone_service.dart';

abstract final class AppBootstrapper {
  /// تهيئة خدمات التطبيق قبل تنفيذ runApp
  static Future<void> init() async {
    // 1. تهيئة طبقة الربط (Native)
    WidgetsFlutterBinding.ensureInitialized();

    // 2. تهيئة حقن الاعتماديات (DI)
    if (!sl.isRegistered<NotificationService>()) {
      await configureDependencies();
    }
    await sl<TimezoneService>().init();
    // 3. تهيئة خدمة الإشعارات المحلية
    await sl<NotificationService>().init();
  }
}
