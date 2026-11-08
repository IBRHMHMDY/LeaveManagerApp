// lib/core/services/firebase_background_handler.dart

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:leave_manager/core/database/app_database.dart';
import 'package:leave_manager/features/notifications/data/models/notification_mapper.dart';
// استيراد الخدمات المطلوبة لتشغيل التتبع من الخلفية
import 'package:leave_manager/core/di/injection_container.dart';
import 'package:leave_manager/features/notifications/domain/usecases/track_notification_usecase.dart';

/// دالة مستقلة على مستوى الملف (Top-Level Function) لمعالجة الإشعارات في الخلفية
/// أو عندما يكون التطبيق مغلقاً تماماً (Terminated).
/// الوسم [@pragma('vm:entry-point')] إلزامي لمنع مترجم Dart (Tree-Shaking) من حذفها في وضع Release.
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  try {
    // 1. التأكد من تهيئة Firebase داخل الـ Isolate الخلفي المستقل
    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp();
    }
    
    // تهيئة الاعتماديات (DI) لتوفير الخدمات اللازمة للتتبع
    await configureDependencies();

    // 2. فتح اتصال مؤقت بقاعدة بيانات Drift لحفظ الإشعار ثم إغلاقه فوراً لمنع تسريب الذاكرة
    final db = AppDatabase();
    try {
      final entity = message.toDomainEntity();
      final companion = entity.toCompanion();

      // فحص عدم تكرار الإشعار عبر remoteId قبل الإدراج
      if (companion.remoteId.present && companion.remoteId.value != null) {
        final remoteIdValue = companion.remoteId.value!;
        final existing = await (db.select(db.notificationsTable)
              ..where((tbl) => tbl.remoteId.equals(remoteIdValue))
              ..limit(1))
            .getSingleOrNull();

        if (existing == null) {
          await db.into(db.notificationsTable).insert(companion);
          
          // إرسال حدث DELIVERED عند الاستلام في الـ Background/Terminated
          final trackNotification = sl<TrackNotificationUseCase>();
          await trackNotification(TrackNotificationParams(
            remoteId: remoteIdValue,
            event: 'DELIVERED',
          ));
        }
      } else {
        await db.into(db.notificationsTable).insert(companion);
      }
    } finally {
      // إغلاق اتصال قاعدة البيانات دائماً داخل الـ Background Isolate
      await db.close();
    }
  } catch (e, stackTrace) {
    debugPrint('Background Notification Handler Error: $e\n$stackTrace');
  }
}