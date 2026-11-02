// lib/core/services/push_notification_service.dart

import 'dart:async';
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:injectable/injectable.dart';
import 'package:leave_manager/core/di/injection_container.dart';
import 'package:leave_manager/core/router/app_router.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:leave_manager/features/notifications/data/models/notification_mapper.dart';
import 'package:leave_manager/features/notifications/domain/entities/app_notification_entity.dart';
import 'package:leave_manager/features/notifications/domain/entities/device_sync_params.dart';
import 'package:leave_manager/features/notifications/domain/usecases/save_notification_usecase.dart';
import 'package:leave_manager/features/notifications/presentation/bloc/notifications_bloc.dart';
import 'package:leave_manager/features/notifications/presentation/bloc/notifications_event.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

const String kHighImportanceChannelId = 'leave_manager_high_importance_channel';

@lazySingleton
class PushNotificationService {
  final SaveNotificationUseCase _saveNotification;
  final FlutterLocalNotificationsPlugin _localNotificationsPlugin = FlutterLocalNotificationsPlugin();

  final StreamController<AppNotificationEntity> _foregroundMessageController = StreamController<AppNotificationEntity>.broadcast();

  StreamSubscription<RemoteMessage>? _onMessageSubscription;
  StreamSubscription<RemoteMessage>? _onMessageOpenedAppSubscription;
  StreamSubscription<String>? _onTokenRefreshSubscription;

  bool _isInitialized = false;
  
  // حفظ مسار التوجيه عند قدوم الإشعار والتطبيق مغلق تماماً
  String? initialActionUrl;

  PushNotificationService(this._saveNotification);

  Stream<AppNotificationEntity> get onForegroundNotificationStream => _foregroundMessageController.stream;

  Future<void> initialize() async {
    if (_isInitialized) return;
    try {
      await _initLocalNotificationsChannel();

      final fcmToken = await FirebaseMessaging.instance.getToken();
      if (fcmToken != null) {
        _dispatchSyncEvent(fcmToken);
      }

      _onTokenRefreshSubscription = FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
        _dispatchSyncEvent(newToken);
      });

      _onMessageSubscription = FirebaseMessaging.onMessage.listen(_handleForegroundMessage);
      _onMessageOpenedAppSubscription = FirebaseMessaging.onMessageOpenedApp.listen(_handleNotificationTapFromBackground);

      // التقاط الإشعار المفتوح إذا كان التطبيق مغلقاً تماماً (Terminated)
      final initialMessage = await FirebaseMessaging.instance.getInitialMessage();
      if (initialMessage != null) {
        final entity = initialMessage.toDomainEntity().copyWith(isRead: true);
        await _saveNotification(entity);
        
        if (entity.remoteId != null) {
          sl<NotificationsBloc>().add(TrackNotificationStatusEvent(entity.remoteId!, 'OPENED'));
        }
        // تخزين المسار ليتم استخدامه لاحقاً بعد انتهاء الـ Splash
        initialActionUrl = entity.actionUrl;
      }

      _isInitialized = true;
    } catch (e) {
      debugPrint('Silent Push Init Error: $e');
    }
  }

  void _dispatchSyncEvent(String token) async {
    try {
      final osType = Platform.isIOS ? 'ios' : 'android';
      final appVersion = (await PackageInfo.fromPlatform()).version;
      
      final params = DeviceSyncParams(
        fcmToken: token,
        osType: osType,
        appVersion: appVersion,
        deviceModel: Platform.operatingSystemVersion,
      );
      
      sl<NotificationsBloc>().add(SyncDeviceTokenEvent(params));
    } catch (e) {
      debugPrint('Dispatch Sync Event Error: $e');
    }
  }

  Future<bool> requestNotificationPermissions() async {
    try {
      if (Platform.isAndroid) {
        final status = await Permission.notification.status;
        if (status.isDenied) {
          final result = await Permission.notification.request();
          if (!result.isGranted) return false;
        }
      }

      final settings = await FirebaseMessaging.instance.requestPermission(
        alert: true,
        badge: true,
        sound: true,
        provisional: false,
      );

      return settings.authorizationStatus == AuthorizationStatus.authorized ||
             settings.authorizationStatus == AuthorizationStatus.provisional;
    } catch (e, stackTrace) {
      debugPrint('Permission Request Error: $e\n$stackTrace');
      return false;
    }
  }

  Future<void> _initLocalNotificationsChannel() async {
    const androidSettings = AndroidInitializationSettings('@mipmap/launcher_icon');
    const iosSettings = DarwinInitializationSettings();
    const initSettings = InitializationSettings(android: androidSettings, iOS: iosSettings);

    await _localNotificationsPlugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        _navigateByActionUrl(response.payload);
      },
    );

    if (Platform.isAndroid) {
      const androidChannel = AndroidNotificationChannel(
        kHighImportanceChannelId,
        'إشعارات مدير إجازاتي الهامة',
        description: 'قناة مخصصة لاستقبال التنبيهات والتحديثات الإدارية.',
        importance: Importance.max,
        playSound: true,
        enableVibration: true,
      );

      await _localNotificationsPlugin
          .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(androidChannel);
    }
  }

  Future<void> _handleForegroundMessage(RemoteMessage message) async {
    final entity = message.toDomainEntity();
    if (!_foregroundMessageController.isClosed) {
      _foregroundMessageController.add(entity);
    }

    const androidDetails = AndroidNotificationDetails(
      kHighImportanceChannelId,
      'إشعارات مدير إجازاتي الهامة',
      channelDescription: 'قناة مخصصة لاستقبال التنبيهات والتحديثات الإدارية.',
      importance: Importance.max,
      priority: Priority.high,
      icon: '@mipmap/launcher_icon',
    );

    const notificationDetails = NotificationDetails(android: androidDetails);

    await _localNotificationsPlugin.show(
      entity.hashCode,
      entity.title,
      entity.body,
      notificationDetails,
      payload: entity.actionUrl,
    );
  }

  Future<void> _handleNotificationTapFromBackground(RemoteMessage message) async {
    final entity = message.toDomainEntity().copyWith(isRead: true);
    await _saveNotification(entity);

    if (entity.remoteId != null) {
      sl<NotificationsBloc>().add(TrackNotificationStatusEvent(entity.remoteId!, 'OPENED'));
    }

    if (!_foregroundMessageController.isClosed) {
      _foregroundMessageController.add(entity);
    }

    await _navigateByActionUrl(entity.actionUrl);
  }

  Future<void> _navigateByActionUrl(String? rawActionUrl) async {
    final actionUrl = rawActionUrl?.trim();
    if (actionUrl != null && actionUrl.isNotEmpty) {
      if (actionUrl.startsWith('/')) {
        AppRouter.router.push(actionUrl);
        return;
      } else {
        final uri = Uri.tryParse(actionUrl);
        if (uri != null) {
          await launchUrl(uri, mode: LaunchMode.externalApplication);
          return;
        }
      }
    }
    AppRouter.router.push(AppRouter.notifications);
  }

  @disposeMethod
  Future<void> dispose() async {
    await _onMessageSubscription?.cancel();
    await _onMessageOpenedAppSubscription?.cancel();
    await _onTokenRefreshSubscription?.cancel();
    _onMessageSubscription = null;
    _onMessageOpenedAppSubscription = null;
    _onTokenRefreshSubscription = null;
    _isInitialized = false;
  }
}