import 'dart:async';
import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:injectable/injectable.dart';
import 'package:leave_manager/features/notifications/data/models/notification_mapper.dart';
import 'package:leave_manager/features/notifications/domain/entities/app_notification_entity.dart';
import 'package:permission_handler/permission_handler.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  debugPrint("Handling a background message: ${message.messageId}");
}

@LazySingleton()
class PushNotificationService {
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications = FlutterLocalNotificationsPlugin();
  
  // Stream الخاص بالإشعارات أثناء فتح التطبيق (Foreground)
  final _foregroundNotificationController = StreamController<AppNotificationEntity>.broadcast();
  Stream<AppNotificationEntity> get onForegroundNotificationStream => _foregroundNotificationController.stream;

  // Stream الخاص بالإشعارات التي تم فتحها من الخلفية (Background) - (تمت إضافته هنا)
  final _openedNotificationController = StreamController<AppNotificationEntity>.broadcast();
  Stream<AppNotificationEntity> get onNotificationOpenedStream => _openedNotificationController.stream;

  String? initialActionUrl;

  Future<void> initialize() async {
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    const androidInit = AndroidInitializationSettings('@mipmap/launcher_icon'); 
    const iosInit = DarwinInitializationSettings();
    const initSettings = InitializationSettings(android: androidInit, iOS: iosInit);

    await _localNotifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _handleLocalNotificationTap,
    );

    // 1. حالة التطبيق مغلق تماماً (Terminated) وتم فتحه من الإشعار
    final initialMessage = await _fcm.getInitialMessage();
    if (initialMessage != null) {
      final entity = initialMessage.toDomainEntity();
      initialActionUrl = entity.actionUrl;
    }

    // 2. حالة التطبيق في الخلفية (Background) وتم فتحه من الإشعار
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      final entity = message.toDomainEntity();
      _openedNotificationController.add(entity); // تمرير البيانات للـ BLoC
    });

    // 3. حالة التطبيق مفتوح ومستخدم حالياً (Foreground)
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      final entity = message.toDomainEntity();
      _foregroundNotificationController.add(entity);
      _showLocalNotification(message); 
    });
  }

  Future<bool> requestNotificationPermissions() async {
    final status = await Permission.notification.request();
    if (status.isGranted) return true;
    
    final settings = await _fcm.requestPermission(
      alert: true, 
      badge: true, 
      sound: true,
    );
    return settings.authorizationStatus == AuthorizationStatus.authorized;
  }

  Future<void> _showLocalNotification(RemoteMessage message) async {
    final notification = message.notification;
    if (notification == null) return;

    const androidDetails = AndroidNotificationDetails(
      'leave_manager_high_importance', 
      'إشعارات هامة',
      importance: Importance.max,
      priority: Priority.high,
      icon: '@mipmap/launcher_icon',
    );
    const iosDetails = DarwinNotificationDetails();
    const details = NotificationDetails(android: androidDetails, iOS: iosDetails);

    await _localNotifications.show(
      notification.hashCode,
      notification.title,
      notification.body,
      details,
      payload: jsonEncode(message.data),
    );
  }

  void _handleLocalNotificationTap(NotificationResponse response) {
    if (response.payload != null) {
      try {
        final data = jsonDecode(response.payload!);
        debugPrint("Local Notification Tapped with payload: $data");
        
        // إذا أردت معالجة النقر على الإشعار المحلي بنفس طريقة إشعارات Firebase، 
        // يمكنك تحويل الـ data إلى AppNotificationEntity وتمريرها عبر الـ Stream:
        // _openedNotificationController.add(AppNotificationEntity.fromJson(data));
      } catch (e) {
        debugPrint("Error parsing local notification payload: $e");
      }
    }
  }

  void dispose() {
    _foregroundNotificationController.close();
    _openedNotificationController.close(); // تم الإغلاق لتفادي تسرب الذاكرة
  }
}