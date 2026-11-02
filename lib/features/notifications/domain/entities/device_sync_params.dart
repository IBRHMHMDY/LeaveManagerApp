// lib/features/notifications/domain/entities/device_sync_params.dart
import 'package:equatable/equatable.dart';

/// كيان يمثل البيانات المطلوبة لمزامنة جهاز المستخدم مع نظام AppsNotifiersSystem.
/// يتطابق مع متطلبات DeviceRegistrationDTO في الخادم.
class DeviceSyncParams extends Equatable {
  /// رمز الإشعارات الخاص بالجهاز من Firebase Cloud Messaging.
  final String fcmToken;

  /// نوع نظام التشغيل ('android' أو 'ios').
  final String osType;

  /// إصدار التطبيق الحالي (مثال: '1.4.0').
  final String appVersion;

  /// معرف الجهاز الفريد
  final String deviceId;

  /// اسم أو طراز الجهاز (اختياري).
  final String? deviceModel;

  /// إجبار المزامنة مع الخادم حتى لو لم يتغير الـ Token محلياً.
  final bool forceSync;

  /// منشئ ثابت لكائن معاملات المزامنة.
  const DeviceSyncParams({
    required this.fcmToken,
    required this.osType,
    required this.appVersion,
    required this.deviceId,
    this.deviceModel,
    this.forceSync = false,
  });

  @override
  List<Object?> get props => [
        fcmToken,
        osType,
        appVersion,
        deviceId,
        deviceModel,
        forceSync,
      ];
}