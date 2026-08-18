// lib/core/utils/notification_service.dart
import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:injectable/injectable.dart';
import 'package:leave_manager/core/utils/app_bootstrapper.dart';
import 'package:leave_manager/features/holidays/domain/entities/holiday_entity.dart';
import 'package:leave_manager/features/settings/domain/entities/settings_entity.dart';
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
    'تم النقر على الإشعار في الخلفية: ${notificationResponse.payload}',
  );
}

@lazySingleton
class NotificationService {
  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();
  String? initialPayload;

  Future<void> init() async {
    tz.initializeTimeZones();
    String timeZoneId;
    try {
      final TimezoneInfo timeZoneInfo =
          await FlutterTimezone.getLocalTimezone();
      timeZoneId = timeZoneInfo.identifier;
    } catch (e) {
      debugPrint('فشل في جلب المنطقة الزمنية، جاري التحويل إلى Africa/Cairo');
      timeZoneId = 'Africa/Cairo';
    }
    tz.setLocalLocation(tz.getLocation(timeZoneId));

    const AndroidInitializationSettings androidInitSettings =
        AndroidInitializationSettings('@drawable/ic_notification');
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

  // 🛠️ تنظيف وتأمين دالة طلب الصلاحيات
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

        // 🛡️ الحل الجذري: طلب صلاحية الجدولة الدقيقة صراحة (لـ Android 13 و 14)
        final isExactAlarmGranted =
            await Permission.scheduleExactAlarm.isGranted;
        if (!isExactAlarmGranted) {
          await Permission.scheduleExactAlarm.request();
        }

        // 🛡️ استثناء التطبيق من قتل البطارية (Doze Mode) لضمان انطلاق الإشعار المجدول والتطبيق مغلق
        final isIgnoringBattery =
            await Permission.ignoreBatteryOptimizations.isGranted;
        if (!isIgnoringBattery) {
          await Permission.ignoreBatteryOptimizations.request();
        }
      } else if (Platform.isIOS) {}
    } catch (e) {
      debugPrint('خطأ عام أثناء طلب الصلاحيات: $e');
    }
  }

  Future<void> cancelAllNotifications() async {
    await _notificationsPlugin.cancelAll();
  }

  Future<void> scheduleHolidayNotifications({
    required List<Holiday> holidays,
    required Settings settings,
  }) async {
    await cancelAllNotifications();
    if (!settings.enableNotifications) return;

    final now = tz.TZDateTime.now(tz.local);
    for (final holiday in holidays) {
      final alertDate = holiday.startDate.subtract(
        Duration(days: settings.daysBeforeHolidayAlert),
      );
      final alertScheduleTime = tz.TZDateTime(
        tz.local,
        alertDate.year,
        alertDate.month,
        alertDate.day,
        10,
        0,
      );

      if (alertScheduleTime.isAfter(now)) {
        await _notificationsPlugin.zonedSchedule(
          id: holiday.id * 10,
          title: 'تذكير باقتراب عطلة',
          body:
              'تذكير: عطلة "${holiday.name}" تبدأ بعد ${settings.daysBeforeHolidayAlert} أيام.',
          scheduledDate: alertScheduleTime,
          notificationDetails: const NotificationDetails(
            android: AndroidNotificationDetails(
              'holiday_alerts_channel',
              'تنبيهات العطلات القادمة',
              importance: Importance.high,
              icon: 'ic_notification',
            ),
          ),
          androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        );
      }

      final actionScheduleTime = tz.TZDateTime(
        tz.local,
        holiday.startDate.year,
        holiday.startDate.month,
        holiday.startDate.day,
        10,
        0,
      );

      if (actionScheduleTime.isAfter(now)) {
        await _notificationsPlugin.zonedSchedule(
          id: holiday.id * 10 + 1,
          title: 'عطلة سعيدة!',
          body:
              'اليوم تبدأ عطلة "${holiday.name}". هل ترغب في تسجيلها كيوم عمل؟',
          scheduledDate: actionScheduleTime,
          notificationDetails: const NotificationDetails(
            android: AndroidNotificationDetails(
              'holiday_actions_channel',
              'إجراءات العطلات',
              importance: Importance.max,
              priority: Priority.high,
              icon: 'ic_notification',
            ),
          ),
          androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
          payload: 'holiday_${holiday.id}',
        );
      }
    }
  }

  Future<void> showTestNotification(int holidayId) async {
    try {
      final scheduled = tz.TZDateTime.now(
        tz.local,
      ).add(const Duration(seconds: 10));

      await _notificationsPlugin.zonedSchedule(
        id: 999,
        title: 'اختبار الاشعار',
        body: 'هذا الاشعار تجريبى فقط ، اضغط لفتح التطبيق',
        scheduledDate: scheduled,
        notificationDetails: const NotificationDetails(
          android: AndroidNotificationDetails(
            'test_channel',
            'Test',
            importance: Importance.max,
            priority: Priority.high,
            icon: 'ic_notification',
          ),
        ),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        payload: 'holiday_$holidayId',
      );
    } catch (e, stackTrace) {
      debugPrint('خطأ في إرسال الإشعار التجريبي: $e');
    }
  }
}
