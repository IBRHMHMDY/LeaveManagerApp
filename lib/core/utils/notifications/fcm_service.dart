// lib/core/utils/notifications/fcm_service.dart
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:leave_manager/core/di/injection_container.dart';
import 'package:leave_manager/features/notifications/domain/usecases/save_notification_usecase.dart';
import 'package:leave_manager/features/notifications/presentation/bloc/notifications_bloc.dart';
import 'package:leave_manager/features/notifications/presentation/bloc/notifications_event.dart';

/// الاستماع للإشعارات في الخلفية (Background)
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  
  // تهيئة حقن التبعيات لأن الخلفية تعمل في مساحة ذاكرة (Isolate) مستقلة
  if (!sl.isRegistered<SaveNotificationUseCase>()) {
    await configureDependencies();
  }

  final saveNotification = sl<SaveNotificationUseCase>();
  
  await saveNotification(
    SaveNotificationParams(
      title: message.notification?.title ?? 'إشعار إداري',
      body: message.notification?.body ?? '',
      payload: message.data['payload'],
    ),
  );
}

@lazySingleton
class FCMService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  // تم إزالة SaveNotificationUseCase من المُنشئ لكسر التبعية الدائرية

  Future<void> init() async {
    await _requestPermissions();

    // تسجيل مستمع الخلفية
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // الاستماع للإشعارات أثناء استخدام التطبيق (Foreground)
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      debugPrint("Foreground message received: ${message.messageId}");
      
      // جلب الـ UseCase ديناميكياً لكسر التبعية
      final saveNotification = sl<SaveNotificationUseCase>();
      
      final result = await saveNotification(
        SaveNotificationParams(
          title: message.notification?.title ?? 'إشعار إداري',
          body: message.notification?.body ?? '',
          payload: message.data['payload'],
        ),
      );

      // تحديث حالة الواجهة باستخدام BLoC في حال النجاح
      result.fold(
        (failure) => debugPrint('Error saving notification: ${failure.message}'),
        (_) {
          if (sl.isRegistered<NotificationsBloc>()) {
            sl<NotificationsBloc>().add(LoadNotificationsEvent());
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

  Future<void> _requestPermissions() async {
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