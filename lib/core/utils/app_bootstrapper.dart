// lib/core/utils/app_bootstrapper.dart
import 'package:flutter/material.dart';
import 'package:leave_manager/core/di/injection_container.dart';
import 'package:leave_manager/core/utils/notifications/notification_service.dart';

abstract final class AppBootstrapper {
  /// دالة التهيئة المركزية التي سيتم استدعاؤها في الـ Main والـ Background Isolate
  static Future<void> init() async {
    // 1. ربط محرك Flutter بالواجهة الأصلية (Native)
    WidgetsFlutterBinding.ensureInitialized();

    // 2. تهيئة حقن التبعيات (DI) عبر get_it و injectable
    // حماية إضافية: نتحقق من عدم تهيئتها مسبقاً لتفادي أخطاء الذاكرة
    if (!sl.isRegistered<NotificationService>()) {
      await configureDependencies();
    }

    // 3. تهيئة الخدمات الأساسية المطلوبة قبل بدء الواجهة الرسومية
    await sl<NotificationService>().init();
    
    // يمكنك إضافة أي خدمات أخرى هنا مستقبلاً (مثل Firebase, Hive, SharedPreferences)
  }
}