// lib/core/utils/notifications/timezone_service.dart
import 'package:flutter/foundation.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:injectable/injectable.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

@lazySingleton
class TimezoneService {
  Future<void> init() async {
    try {
      tz.initializeTimeZones();
      
      // 1. استقبال الكائن TimezoneInfo بدلاً من String
      final tzInfo = await FlutterTimezone.getLocalTimezone();
      
      // 2. استخراج الاسم النصي للمنطقة الزمنية (عادة يكون عبر الخاصية .name أو .timezone)
      // إذا كانت المكتبة تعتمد override لـ toString()، يمكنك استخدام tzInfo.toString()
      final String timeZoneName = tzInfo.identifier; 
      debugPrint('local timezone: $timeZoneName');
      tz.setLocalLocation(tz.getLocation(timeZoneName));
      
    } catch (e, stackTrace) {
      // معالجة الأخطاء لتجنب توقف التطبيق
      debugPrint('Failed to set local timezone: $e\n$stackTrace');
      tz.setLocalLocation(tz.getLocation('UTC')); 
      debugPrint('local timezone: UTC');
    }
  }
}