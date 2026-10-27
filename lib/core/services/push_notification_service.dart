// lib/core/services/push_notification_service.dart
import 'dart:async';
import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:injectable/injectable.dart';
import 'package:leave_manager/core/router/app_router.dart';
import 'package:leave_manager/core/utils/AppVersions/app_version_service.dart';
import 'package:leave_manager/features/notifications/data/models/notification_mapper.dart';
import 'package:leave_manager/features/notifications/domain/entities/app_notification_entity.dart';
import 'package:leave_manager/features/notifications/domain/entities/device_sync_params.dart';
import 'package:leave_manager/features/notifications/domain/usecases/save_notification_usecase.dart';
import 'package:leave_manager/features/notifications/domain/usecases/sync_device_with_server_usecase.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

/// معرف قناة الإشعارات عالية الأهمية (يجب أن يطابق القيمة في AndroidManifest.xml).
const String kHighImportanceChannelId =
    'leave_manager_high_importance_channel';

/// الخدمة المركزية لإدارة إشعارات الدفع (FCM)، القنوات المحلية، ومزامنة الجهاز.
/// ملتزمة بمعايير وثيقة AMD 2026 في إدارة الـ Streams ومنع Memory Leaks.
@lazySingleton
class PushNotificationService {
  final SyncDeviceWithServerUseCase _syncDeviceWithServer;
  final SaveNotificationUseCase _saveNotification;
  final FlutterLocalNotificationsPlugin _localNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  final StreamController<AppNotificationEntity> _foregroundMessageController =
      StreamController<AppNotificationEntity>.broadcast();

  StreamSubscription<RemoteMessage>? _onMessageSubscription;
  StreamSubscription<RemoteMessage>? _onMessageOpenedAppSubscription;
  StreamSubscription<String>? _onTokenRefreshSubscription;

  bool _isInitialized = false;

  /// منشئ الكلاس يستقبل حالات الاستخدام عبر الحقن التلقائي للتبعيات (DI).
  PushNotificationService(
    this._syncDeviceWithServer,
    this._saveNotification,
  );

  /// Stream يستمع إليه [NotificationsBloc] لتحديث الواجهة فور وصول إشعار.
  Stream<AppNotificationEntity> get onForegroundNotificationStream =>
      _foregroundMessageController.stream;

  /// تهيئة القنوات المحلية، مستمعات Firebase، طلب الصلاحيات، ومزامنة الـ Token.
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      if (Firebase.apps.isEmpty) {
        debugPrint('PushNotificationService: Firebase is not initialized.');
        return;
      }

      final messaging = FirebaseMessaging.instance;

      // 1. طلب الصلاحيات أولاً (Android 13+ & iOS)
      final hasPermission = await _requestNotificationPermissions(messaging);
      if (!hasPermission) {
        debugPrint('PushNotificationService: Notification permission denied.');
        return;
      }

      // 2. تهيئة قناة الإشعارات المحلية للأندرويد و iOS
      await _initLocalNotificationsChannel();

      // 3. إعداد خيارات العرض الأمامي لنظام iOS
      await messaging.setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );

      // 4. الاستماع للرسائل أثناء فتح التطبيق (Foreground)
      _onMessageSubscription = FirebaseMessaging.onMessage.listen(
        _handleForegroundMessage,
      );

      // 5. الاستماع لنقر المستخدم على الإشعار من الخلفية (Background)
      _onMessageOpenedAppSubscription =
          FirebaseMessaging.onMessageOpenedApp.listen(
        _handleNotificationTapFromBackground,
      );

      // 6. التحقق مما إذا كان التطبيق قد فُتح من وضع الإغلاق التام (Terminated)
      final initialMessage = await messaging.getInitialMessage();
      if (initialMessage != null) {
        await _handleNotificationTapFromBackground(initialMessage);
      }

      // 7. الاستماع لتجديد رمز الـ FCM تلقائياً ومزامنته مع الخادم
      _onTokenRefreshSubscription = messaging.onTokenRefresh.listen(
        (newToken) => _syncTokenWithServer(newToken, forceSync: true),
      );

      // 8. جلب التوكن الحالي ومزامنته مع الخادم
      final currentToken = await messaging.getToken();
      if (currentToken != null && currentToken.isNotEmpty) {
        debugPrint('FCM Device Token: $currentToken');
        await _syncTokenWithServer(currentToken, forceSync: true);
      }

      _isInitialized = true;
    } catch (e, stackTrace) {
      debugPrint('PushNotificationService Init Error: $e\n$stackTrace');
    }
  }

  /// إنشاء قناة إشعارات عالية الأهمية على نظام Android لضمان ظهور التنبيه وصوته.
  Future<void> _initLocalNotificationsChannel() async {
    const androidSettings =
        AndroidInitializationSettings('@mipmap/launcher_icon');
    const iosSettings = DarwinInitializationSettings();
    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

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
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(androidChannel);
    }
  }

  /// طلب صلاحيات الإشعارات للنظام.
  Future<bool> _requestNotificationPermissions(
    FirebaseMessaging messaging,
  ) async {
    try {
      if (Platform.isAndroid) {
        final status = await Permission.notification.status;
        if (status.isDenied) {
          final result = await Permission.notification.request();
          if (!result.isGranted) return false;
        }
      }

      final settings = await messaging.requestPermission(
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

  /// إرسال رمز FCM وبيانات الإصدار والنظام إلى خادم AppsNotifiersSystem.
  Future<void> _syncTokenWithServer(
    String token, {
    bool forceSync = false,
  }) async {
    try {
      final appVersion = await AppVersionService.getVersionOnly();
      final osType = Platform.isIOS ? 'ios' : 'android';

      final params = DeviceSyncParams(
        fcmToken: token,
        osType: osType,
        appVersion: appVersion,
        deviceModel: Platform.operatingSystemVersion,
        forceSync: forceSync,
      );

      await _syncDeviceWithServer(params);
    } catch (e, stackTrace) {
      debugPrint('Token Sync Error: $e\n$stackTrace');
    }
  }

  /// معالجة الإشعار الوارد أثناء فتح التطبيق وإظهار إشعار محلي في شريط النظام أيضاً.
  Future<void> _handleForegroundMessage(RemoteMessage message) async {
    final entity = message.toDomainEntity();
    if (!_foregroundMessageController.isClosed) {
      _foregroundMessageController.add(entity);
    }

    // إظهار إشعار فعلي في شريط الهاتف العلوي حتى لو كان التطبيق مفتوحاً
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

  /// معالجة نقر الموظف على الإشعار من الخلفية (Background / Terminated).
  Future<void> _handleNotificationTapFromBackground(
    RemoteMessage message,
  ) async {
    final entity = message.toDomainEntity().copyWith(isRead: true);
    await _saveNotification(entity);

    if (!_foregroundMessageController.isClosed) {
      _foregroundMessageController.add(entity);
    }

    await _navigateByActionUrl(entity.actionUrl);
  }

  /// توجيه المستخدم بناءً على الرابط المرفق في الإشعار عبر GoRouter.
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

  /// إغلاق جميع الـ Streams والاشتراكات لمنع تسريب الذاكرة (Memory Leaks).
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