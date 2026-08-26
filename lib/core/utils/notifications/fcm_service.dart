import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:leave_manager/core/di/injection_container.dart';
import 'package:leave_manager/core/utils/notifications/notification_service.dart';
import 'package:leave_manager/features/notifications/domain/usecases/save_notification_usecase.dart';
import 'package:leave_manager/features/notifications/presentation/bloc/notifications_bloc.dart';
import 'package:leave_manager/features/notifications/presentation/bloc/notifications_event.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  if (!sl.isRegistered<SaveNotificationUseCase>()) {
    await configureDependencies();
  }
  final saveNotification = sl<SaveNotificationUseCase>();
  await saveNotification(
    SaveNotificationParams(
      title: message.notification?.title ?? 'إشعار جديد',
      body: message.notification?.body ?? '',
      payload: message.data['payload'],
    ),
  );
}

@lazySingleton
class FCMService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> init() async {
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      debugPrint("Foreground message received: ${message.messageId}");
      
      final saveNotification = sl<SaveNotificationUseCase>();
      
      // 1. حفظ الإشعار في قاعدة البيانات (الكود الخاص بك)[cite: 2]
      final result = await saveNotification(
        SaveNotificationParams(
          title: message.notification?.title ?? 'بدون عنوان',
          body: message.notification?.body ?? '',
          payload: message.data['payload'],
        ),
      );

      result.fold(
        (failure) => debugPrint('Error saving notification: ${failure.message}'),
        (_) {
          // 2. تحديث عداد الإشعارات في الـ UI[cite: 2]
          if (sl.isRegistered<NotificationsBloc>()) {
            sl<NotificationsBloc>().add(LoadNotificationsEvent());
          }
          
          // 3. إضافة: إظهار الإشعار المرئي للمستخدم في الـ Foreground
          if (message.notification != null) {
            final localNotificationService = sl<NotificationService>();
            localNotificationService.showNotification(
              id: message.messageId.hashCode,
              title: message.notification!.title ?? 'إشعار جديد',
              body: message.notification!.body ?? '',
              payload: message.data['payload'],
            );
          }
        },
      );
    });

    try {
      final token = await _firebaseMessaging.getToken();
      debugPrint('FCM Token: $token');
    } catch (e) {
      debugPrint('Failed to get FCM token: $e');
    }
  }

  // ✅ تحويل الدالة إلى Public لكي نناديها متى شئنا
  Future<void> requestPermissions() async {
    final settings = await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
    );
    debugPrint('FCM Permission status: ${settings.authorizationStatus}');
  }

  Future<void> subscribeToTopic(String topic) async {
    await _firebaseMessaging.subscribeToTopic(topic);
  }

  Future<void> unsubscribeFromTopic(String topic) async {
    await _firebaseMessaging.unsubscribeFromTopic(topic);
  }
}