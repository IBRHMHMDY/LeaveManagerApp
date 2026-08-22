// lib/core/utils/device/battery_optimization_service.dart
import 'package:disable_battery_optimization/disable_battery_optimization.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';


@lazySingleton
class BatteryOptimizationService {
  
  /// دالة للتحقق وطلب إيقاف تحسين البطارية وتفعيل التشغيل التلقائي
  Future<void> requestBatteryAndAutoStartPermissions() async {
    try {
      // 1. التحقق من أن "تحسين البطارية" معطل لتطبيقنا
      bool? isBatteryOptimizationDisabled = await DisableBatteryOptimization.isBatteryOptimizationDisabled;
      
      if (isBatteryOptimizationDisabled != true) {
        // فتح شاشة الإعدادات للمستخدم لتعطيل تحسين البطارية
        await DisableBatteryOptimization.showDisableBatteryOptimizationSettings();
      }

      // 2. التحقق من تفعيل "التشغيل التلقائي" (AutoStart) 
      // خطوة حيوية جداً لهواتف MIUI و ColorOS لضمان بقاء الإشعارات
      bool? isAutoStartEnabled = await DisableBatteryOptimization.isAutoStartEnabled;
      
      if (isAutoStartEnabled != true) {
        // فتح شاشة الإعدادات للمستخدم لتفعيل التشغيل التلقائي
        await DisableBatteryOptimization.showEnableAutoStartSettings(
          "تفعيل التشغيل التلقائي", 
          "يرجى تفعيل التشغيل التلقائي لتطبيق 'مدير إجازاتي' لضمان إرسال إشعارات العطلات في وقتها حتى وإن كان التطبيق مغلقاً."
        );
      }
    } catch (e, stackTrace) {
      // طباعة الخطأ في وضع الـ Debug فقط لتفادي الانهيار إذا كان الجهاز غير مدعوم
      debugPrint('Battery Optimization Error: $e\n$stackTrace');
    }
  }
}