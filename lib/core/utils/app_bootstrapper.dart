// lib/core/utils/app_bootstrapper.dart
import 'package:flutter/material.dart';
import 'package:leave_manager/core/di/injection_container.dart';

abstract final class AppBootstrapper {
  /// تهيئة خدمات التطبيق قبل تنفيذ runApp
  static Future<void> init() async {
    // 1. تهيئة طبقة الربط (Native)
    WidgetsFlutterBinding.ensureInitialized();
    // 2. تهيئة حقن الاعتماديات (DI)
    await configureDependencies();
  }
}
