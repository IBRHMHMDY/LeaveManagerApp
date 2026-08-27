import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:injectable/injectable.dart';
import 'package:leave_manager/core/utils/app_bootstrapper.dart';

/// Stream عالمي لالتقاط الـ Payload عند الضغط على الإشعار
final StreamController<NotificationResponse> selectNotificationStream =
    StreamController<NotificationResponse>.broadcast();

/// دالة للتعامل مع الضغط على الإشعار والتطبيق في الخلفية
@pragma('vm:entry-point')
Future<void> notificationTapBackground(NotificationResponse notificationResponse) async {
  await AppBootstrapper.init();
  debugPrint('Notification Tapped in Background: ${notificationResponse.payload}');
  selectNotificationStream.add(notificationResponse);
}

@lazySingleton
class NotificationService {
  final FlutterLocalNotificationsPlugin _notificationsPlugin = FlutterLocalNotificationsPlugin();
  
  NotificationResponse? initialNotificationResponse;

  /// تهيئة إعدادات الإشعارات المحلية
  Future<void> init() async {
    const AndroidInitializationSettings androidInitSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
        
    const DarwinInitializationSettings iosInitSettings = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    const InitializationSettings initSettings = InitializationSettings(
      android: androidInitSettings,
      iOS: iosInitSettings,
    );

    // التحقق مما إذا كان التطبيق قد فُتح عبر الضغط على إشعار
    final NotificationAppLaunchDetails? notificationAppLaunchDetails =
        await _notificationsPlugin.getNotificationAppLaunchDetails();

    if (notificationAppLaunchDetails?.didNotificationLaunchApp ?? false) {
      initialNotificationResponse = notificationAppLaunchDetails?.notificationResponse;
    }

    await _notificationsPlugin.initialize(
      settings: initSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        selectNotificationStream.add(response);
      },
      onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
    );
  }

  /// طلب صلاحيات النظام للإشعارات المحلية
  Future<void> requestPermissions() async {
    try {
      if (Platform.isAndroid) {
        final androidImplementation = _notificationsPlugin
            .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
        if (androidImplementation != null) {
          await androidImplementation.requestNotificationsPermission();
        }
      } else if (Platform.isIOS) {
        final iosImplementation = _notificationsPlugin
            .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>();
        await iosImplementation?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
      }
    } catch (e, stackTrace) {
      debugPrint('Error requesting permissions: $e\n$stackTrace');
    }
  }

  /// عرض إشعار مرئي في واجهة التطبيق
  Future<void> showNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      'leave_manager_high_importance_channel',
      'تنبيهات هامة',
      channelDescription: 'قناة مخصصة لتنبيهات الأرصدة والعطلات',
      importance: Importance.max,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const details = NotificationDetails(android: androidDetails, iOS: iosDetails);
    
    await _notificationsPlugin.show(
      id: id,
      title: title,
      body: body,
      notificationDetails: details,
      payload: payload,
    );
  }
}