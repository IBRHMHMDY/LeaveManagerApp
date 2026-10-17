// lib/features/notifications/data/models/device_sync_request_model.dart
import 'package:equatable/equatable.dart';
import 'package:leave_manager/features/notifications/domain/entities/device_sync_params.dart';

/// نموذج البيانات (Data Model) المسؤول عن تحويل بيانات مزامنة الجهاز إلى JSON
/// لإرسالها إلى نقطة النهاية (SyncDeviceController) في نظام AppsNotifiersSystem.
class DeviceSyncRequestModel extends Equatable {
  /// رمز الإشعارات الخاص بـ Firebase Cloud Messaging.
  final String fcmToken;

  /// نوع نظام التشغيل ('android' أو 'ios').
  final String osType;

  /// رقم إصدار التطبيق الحالي.
  final String appVersion;

  /// طراز أو اسم الجهاز (اختياري).
  final String? deviceModel;

  /// منشئ ثابت (const constructor) وفق معايير AMD 2026.
  const DeviceSyncRequestModel({
    required this.fcmToken,
    required this.osType,
    required this.appVersion,
    this.deviceModel,
  });

  /// دالة مصنعية لتحويل كيان الـ Domain [DeviceSyncParams] إلى [DeviceSyncRequestModel].
  factory DeviceSyncRequestModel.fromDomain(DeviceSyncParams params) {
    return DeviceSyncRequestModel(
      fcmToken: params.fcmToken,
      osType: params.osType,
      appVersion: params.appVersion,
      deviceModel: params.deviceModel,
    );
  }

  /// تحويل النموذج إلى خريطة JSON متوافقة مع قواعد التحقق في Laravel Backend.
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'fcm_token': fcmToken,
      'os_type': osType,
      'app_version': appVersion,
      if (deviceModel != null && deviceModel!.trim().isNotEmpty)
        'device_model': deviceModel,
    };
  }

  @override
  List<Object?> get props => [fcmToken, osType, appVersion, deviceModel];
}