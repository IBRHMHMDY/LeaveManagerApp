// lib/core/utils/notifications/notification_service.dart
import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:injectable/injectable.dart';
import 'package:leave_manager/core/utils/app_bootstrapper.dart';
import 'package:leave_manager/features/notifications/domain/usecases/get_notifications_usecase.dart';
import 'package:leave_manager/features/notifications/domain/usecases/save_notification_usecase.dart';

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

    // إلغاء أي إشعارات محلية مجدولة مسبقاً لتفادي التكرار مع FCM
    await _notificationsPlugin.cancelAll();
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
        // تم إزالة طلب صلاحية scheduleExactAlarm لعدم الحاجة إليها
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

  Future<void> showNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      'leave_manager_high_importance_channel',
      'تنبيهات هامة',
      channelDescription: 'هذه القناة مخصصة للإشعارات الهامة والعاجلة.',
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

    await _notificationsPlugin.show(id: id, title: title, body:body, notificationDetails: details, payload: payload);
  }
}