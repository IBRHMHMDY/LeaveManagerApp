// lib/core/utils/notifications/notification_service.dart
import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:injectable/injectable.dart';
import 'package:leave_manager/core/utils/app_bootstrapper.dart';
import 'package:leave_manager/features/holidays/domain/entities/holiday_entity.dart';
import 'package:leave_manager/features/settings/domain/entities/settings_entity.dart';
import 'package:leave_manager/features/notifications/domain/usecases/save_notification_usecase.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

final StreamController<String?> selectNotificationStream =
    StreamController<String?>.broadcast();

@pragma('vm:entry-point')
Future<void> notificationTapBackground(
  NotificationResponse notificationResponse,
) async {
  await AppBootstrapper.init();
  debugPrint(
    'Notification Tapped in Background: ${notificationResponse.payload}',
  );
}

@lazySingleton
class NotificationService {
  final SaveNotificationUseCase saveNotification;
  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();
  String? initialPayload;

  NotificationService(this.saveNotification);

  Future<void> init() async {
    tz.initializeTimeZones();
    String timeZoneId;
    try {
      // تم إرجاع الكود الخاص بنسختك لتفادي خطأ TimezoneInfo
      final TimezoneInfo timeZoneInfo =
          await FlutterTimezone.getLocalTimezone();
      timeZoneId = timeZoneInfo.identifier;
    } catch (e) {
      timeZoneId = 'Africa/Cairo';
    }
    tz.setLocalLocation(tz.getLocation(timeZoneId));

    // تم التعديل: استخدام @mipmap/ic_launcher كأيقونة افتراضية لمنع الانهيار الصامت
    const AndroidInitializationSettings androidInitSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const DarwinInitializationSettings iosInitSettings =
        DarwinInitializationSettings(
          requestAlertPermission: false,
          requestBadgePermission: false,
          requestSoundPermission: false,
        );

    const InitializationSettings initSettings = InitializationSettings(
      android: androidInitSettings,
      iOS: iosInitSettings,
    );

    final NotificationAppLaunchDetails? notificationAppLaunchDetails =
        await _notificationsPlugin.getNotificationAppLaunchDetails();
    if (notificationAppLaunchDetails?.didNotificationLaunchApp ?? false) {
      initialPayload =
          notificationAppLaunchDetails?.notificationResponse?.payload;
    }

    await _notificationsPlugin.initialize(
      settings: initSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        selectNotificationStream.add(response.payload);
      },
      onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
    );
  }

  Future<void> requestPermissions() async {
    try {
      if (Platform.isAndroid) {
        final androidImplementation = _notificationsPlugin
            .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin
            >();
        if (androidImplementation != null) {
          await androidImplementation.requestNotificationsPermission();
        }
        final isExactAlarmGranted =
            await Permission.scheduleExactAlarm.isGranted;
        if (!isExactAlarmGranted) {
          await Permission.scheduleExactAlarm.request();
        }
      } else if (Platform.isIOS) {
        // تم إضافة طلب صلاحيات نظام iOS لتجنب تجاهلها
        final iosImplementation = _notificationsPlugin
            .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin
            >();
        await iosImplementation?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
      }
    } catch (e) {
      debugPrint('Error requesting permissions: $e');
    }
  }

  Future<void> cancelNotification(int id) async {
    await _notificationsPlugin.cancel(id: id);
  }

  Future<void> scheduleHolidayNotifications({
    required List<Holiday> holidays,
    required Settings settings,
  }) async {
    // 1. التحقق من تفعيل الإشعارات
    if (!settings.enableNotifications) {
      debugPrint('⚠️ الإشعارات مغلقة من الإعدادات.');
      return;
    }

    final now = tz.TZDateTime.now(tz.local);
    int targetHour = 10;
    int targetMinute = 0;

    try {
      final timeParts = settings.notificationTime.split(':');
      if (timeParts.isNotEmpty) targetHour = int.parse(timeParts[0]);
      if (timeParts.length > 1) targetMinute = int.parse(timeParts[1]);
    } catch (e) {
      debugPrint('Time Parsing Error: $e');
    }

    debugPrint(
      '⏳ جاري جدولة الإشعارات... التنبيه قبل: ${settings.daysBeforeHolidayAlert} أيام، الساعة: $targetHour:$targetMinute',
    );

    for (final holiday in holidays) {
      final int alertId = holiday.id * 10;
      await cancelNotification(alertId);

      // حساب التاريخ المستهدف بناءً على تاريخ العطلة ناقص الأيام المحددة
      final alertDate = holiday.startDate.subtract(
        Duration(days: settings.daysBeforeHolidayAlert),
      );

      // دمج التاريخ مع الساعة المحددة
      final alertScheduleTime = tz.TZDateTime(
        tz.local,
        alertDate.year,
        alertDate.month,
        alertDate.day,
        targetHour,
        targetMinute,
      );

      if (alertScheduleTime.isAfter(now)) {
        const title = 'تذكير بعطلة قادمة';
        final body =
            'عطلة "${holiday.name}" تبدأ بعد ${settings.daysBeforeHolidayAlert} أيام.';
        final payload = 'holiday_${holiday.id}';

        debugPrint(
          '✅ سيتم إطلاق إشعار العطلة "${holiday.name}" في هذا الوقت الدقيق: $alertScheduleTime',
        );

        await _notificationsPlugin.zonedSchedule(
          id: alertId,
          title: title,
          body: body,
          scheduledDate: alertScheduleTime,
          notificationDetails: const NotificationDetails(
            android: AndroidNotificationDetails(
              'holiday_alerts_channel',
              'إشعارات العطلات',
              importance: Importance.max, // رفع الأهمية للدرجة القصوى
              priority: Priority.max, // رفع الأولوية للدرجة القصوى
              icon: '@mipmap/ic_launcher',
              groupKey: 'holiday_group',
            ),
          ),
          // تم التحويل إلى Exact لضمان الانطلاق الفوري في نفس الدقيقة
          androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
          payload: payload,
        );
      } else {
        debugPrint(
          '❌ تجاهل: وقت الإشعار للعطلة "${holiday.name}" ($alertScheduleTime) قد مضى.',
        );
      }
    }
  }

  Future<void> showTestNotification(int holidayId) async {
    try {
      final now = tz.TZDateTime.now(tz.local);
      final scheduled = now.add(const Duration(seconds: 5));

      const title = 'إختبار الإشعارات';
      const body = 'هذا إشعار تجريبي للتأكد من عمل الخدمة.';
      final payload = 'holiday_$holidayId';

      await _notificationsPlugin.zonedSchedule(
        id: 999,
        title: title,
        body: body,
        scheduledDate: scheduled,
        notificationDetails: const NotificationDetails(
          android: AndroidNotificationDetails(
            'test_channel',
            'إختبار الإشعارات',
            importance: Importance.max,
            priority: Priority.high,
            icon: '@mipmap/ic_launcher', // استخدام الأيقونة الافتراضية
          ),
        ),
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        payload: payload,
      );

      await saveNotification(
        SaveNotificationParams(title: title, body: body, payload: payload),
      );
    } catch (e, stackTrace) {
      debugPrint('Error showing test notification: $e\n$stackTrace');
    }
  }
}
