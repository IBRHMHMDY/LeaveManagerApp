// lib/core/utils/app_bootstrapper.dart
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:leave_manager/firebase_options.dart'; // تأكد من مسار الملف المولد
import 'package:leave_manager/core/di/injection_container.dart';
import 'package:leave_manager/core/utils/notifications/notification_service.dart';
import 'package:leave_manager/core/utils/notifications/fcm_service.dart';

abstract final class AppBootstrapper {
  /// التهيئة الأساسية للتطبيق قبل دالة runApp
  static Future<void> init() async {
    // 1. تهيئة بيئة فلاتر (Native)
    WidgetsFlutterBinding.ensureInitialized();

    // 2. تهيئة Firebase باستخدام الخيارات المولدة للمنصة الحالية
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    // 3. تهيئة حقن التبعيات (DI)
    if (!sl.isRegistered<NotificationService>()) {
      await configureDependencies();
    }

    // 4. تهيئة خدمات الإشعارات (المحلية والسحابية)
    await sl<NotificationService>().init();
    await sl<FCMService>().init(); // <-- إضافة تهيئة خدمة FCM هنا
  }
}