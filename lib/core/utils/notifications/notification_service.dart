// lib/core/utils/notifications/notification_service.dart
import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:injectable/injectable.dart';
import 'package:leave_manager/core/usecases/base_usecase.dart';
import 'package:leave_manager/core/utils/app_bootstrapper.dart';
import 'package:leave_manager/features/holidays/domain/entities/holiday_entity.dart';
import 'package:leave_manager/features/notifications/domain/usecases/get_notifications_usecase.dart';
import 'package:leave_manager/features/settings/domain/entities/settings_entity.dart';
import 'package:leave_manager/features/notifications/domain/usecases/save_notification_usecase.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

final StreamController<NotificationResponse> selectNotificationStream =
    StreamController<NotificationResponse>.broadcast();

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
  final GetNotificationsUseCase getNotifications;
  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  NotificationResponse? initialNotificationResponse;

  NotificationService(this.saveNotification, this.getNotifications);

  Future<void> init() async {
    tz.initializeTimeZones();
    String timeZoneId;
    try {
      final TimezoneInfo timeZoneInfo =
          await FlutterTimezone.getLocalTimezone();
      timeZoneId = timeZoneInfo.identifier;
    } catch (e) {
      timeZoneId = 'Africa/Cairo';
    }
    tz.setLocalLocation(tz.getLocation(timeZoneId));

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
      initialNotificationResponse =
          notificationAppLaunchDetails?.notificationResponse;
    }

    await _notificationsPlugin.initialize(
      settings: initSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        selectNotificationStream.add(response);
      },
      onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
    );
  }

  Future<void> requestPermissions() async {
    try {
      if (Platform.isAndroid) {
        final androidImplementation = _notificationsPlugin
            .resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin>();
        if (androidImplementation != null) {
          await androidImplementation.requestNotificationsPermission();
        }
        final isExactAlarmGranted =
            await Permission.scheduleExactAlarm.isGranted;
        if (!isExactAlarmGranted) {
          await Permission.scheduleExactAlarm.request();
        }
      } else if (Platform.isIOS) {
        final iosImplementation = _notificationsPlugin
            .resolvePlatformSpecificImplementation<
                IOSFlutterLocalNotificationsPlugin>();
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

  // التعديل هنا: دالة لجدولة العطلة القادمة فقط
  Future<void> scheduleUpcomingHolidayNotification({
    required Holiday? upcomingHoliday,
    required Settings settings,
  }) async {
    // إلغاء الجدولة إذا كانت الإشعارات معطلة أو لا توجد عطلة قادمة
    if (!settings.enableNotifications || upcomingHoliday == null) {
      await _notificationsPlugin.cancelAll(); // مسح أي جدولة سابقة
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

    // إلغاء كافة الإشعارات المجدولة مسبقاً لضمان وجود إشعار واحد فقط نشط
    await _notificationsPlugin.cancelAll();

    final int alertId = upcomingHoliday.id * 10;

    final alertDate = upcomingHoliday.startDate.subtract(
      Duration(days: settings.daysBeforeHolidayAlert),
    );

    final alertScheduleTime = tz.TZDateTime(
      tz.local,
      alertDate.year,
      alertDate.month,
      alertDate.day,
      targetHour,
      targetMinute,
    );

    const title = 'تذكير بعطلة قادمة';
    final body =
        'عطلة "${upcomingHoliday.name}" تبدأ بعد ${settings.daysBeforeHolidayAlert} أيام.';
    final payload = 'holiday_${upcomingHoliday.id}';

    if (alertScheduleTime.isAfter(now)) {
      // التحقق مما إذا كان الإشعار قد حُفظ مسبقاً
      bool isAlreadySaved = false;
      final result = await getNotifications(const NoParams());
      result.fold(
        (failure) => debugPrint('Error fetching notifications: ${failure.message}'),
        (notifications) => isAlreadySaved = notifications.any((n) => n.payload == payload),
      );

      if (!isAlreadySaved) {
        await saveNotification(
          SaveNotificationParams(title: title, body: body, payload: payload),
        );
      }

      await _notificationsPlugin.zonedSchedule(
        id: alertId,
        title: title,
        body: body,
        scheduledDate: alertScheduleTime,
        notificationDetails: const NotificationDetails(
          android: AndroidNotificationDetails(
            'holiday_alerts_channel',
            'تنبيهات العطلات',
            importance: Importance.max,
            priority: Priority.max,
            icon: '@mipmap/ic_launcher',
            groupKey: 'holiday_group',
          ),
        ),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        payload: payload,
      );
    }
  }
}