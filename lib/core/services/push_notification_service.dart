// lib/core/services/push_notification_service.dart
import 'dart:async';
import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
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

/// الخدمة المركزية لإدارة إشعارات الدفع (FCM)، الصلاحيات، ومزامنة الجهاز مع الخادم.
/// ملتزمة بمعايير AMD 2026 في إدارة الـ Streams ومنع Memory Leaks.
@lazySingleton
class PushNotificationService {
  final SyncDeviceWithServerUseCase _syncDeviceWithServer;
  final SaveNotificationUseCase _saveNotification;

  /// بث داخلي لإبلاغ طبقة الـ Presentation (NotificationsBloc) بوصول إشعار جديد.
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

  /// Stream يستمع إليه [NotificationsBloc] لتحديث الواجهة فور وصول إشعار أثناء فتح التطبيق.
  Stream<AppNotificationEntity> get onForegroundNotificationStream =>
      _foregroundMessageController.stream;

  /// تهيئة مستمعات Firebase، طلب الصلاحيات، ومزامنة التوكن في الخلفية بدون حجب الواجهة.
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      // التحقق من أن Firebase مهيأ بنجاح قبل استدعاء FirebaseMessaging
      if (Firebase.apps.isEmpty) {
        debugPrint('PushNotificationService: Firebase is not initialized.');
        return;
      }

      final messaging = FirebaseMessaging.instance;

      // 1. طلب الصلاحيات (Android 13+ & iOS)
      final hasPermission = await _requestNotificationPermissions(messaging);
      if (!hasPermission) {
        debugPrint('PushNotificationService: Notification permission denied.');
        return;
      }

      // 2. إعداد خيارات العرض الأمامي لنظام iOS
      await messaging.setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );

      // 3. الاستماع للرسائل أثناء فتح التطبيق (Foreground)
      _onMessageSubscription = FirebaseMessaging.onMessage.listen(
        _handleForegroundMessage,
      );

      // 4. الاستماع لنقر المستخدم على الإشعار عندما يكون التطبيق في الخلفية (Background)
      _onMessageOpenedAppSubscription =
          FirebaseMessaging.onMessageOpenedApp.listen(
        _handleNotificationTapFromBackground,
      );

      // 5. التحقق مما إذا كان التطبيق قد فُتح من وضع الإغلاق التام (Terminated) عبر إشعار
      final initialMessage = await messaging.getInitialMessage();
      if (initialMessage != null) {
        await _handleNotificationTapFromBackground(initialMessage);
      }

      // 6. الاستماع لتجديد رمز الـ FCM تلقائياً ومزامنته مع AppsNotifiersSystem
      _onTokenRefreshSubscription = messaging.onTokenRefresh.listen(
        (newToken) => _syncTokenWithServer(newToken, forceSync: true),
      );

      // 7. جلب التوكن الحالي ومزامنته مع الخادم بصمت
      final currentToken = await messaging.getToken();
      if (currentToken != null && currentToken.isNotEmpty) {
        await _syncTokenWithServer(currentToken);
      }

      _isInitialized = true;
    } catch (e, stackTrace) {
      debugPrint('PushNotificationService Init Error: $e\n$stackTrace');
    }
  }

  /// طلب صلاحيات الإشعارات باستخدام permission_handler و FirebaseMessaging.
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

  /// معالجة الإشعار الوارد أثناء استخدام الموظف للتطبيق (Foreground).
  Future<void> _handleForegroundMessage(RemoteMessage message) async {
    final entity = message.toDomainEntity();
    if (!_foregroundMessageController.isClosed) {
      _foregroundMessageController.add(entity);
    }
  }

  /// معالجة نقر الموظف على الإشعار من شريط إشعارات النظام (Background / Terminated).
  Future<void> _handleNotificationTapFromBackground(
    RemoteMessage message,
  ) async {
    final entity = message.toDomainEntity().copyWith(isRead: true);
    await _saveNotification(entity);

    // تحديث الواجهة إذا كان التطبيق مفتوحاً في الخلفية
    if (!_foregroundMessageController.isClosed) {
      _foregroundMessageController.add(entity);
    }

    final actionUrl = entity.actionUrl?.trim();
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

    // التوجيه الافتراضي إلى شاشة سجل الإشعارات
    AppRouter.router.push('/notifications');
  }

  /// إغلاق جميع الـ Streams والاشتراكات لمنع تسريب الذاكرة (Memory Leaks) عند إعادة تشغيل التطبيق.
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