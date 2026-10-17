// lib/features/notifications/presentation/bloc/notifications_event.dart
import 'package:equatable/equatable.dart';
import 'package:leave_manager/features/notifications/domain/entities/app_notification_entity.dart';
import 'package:leave_manager/features/notifications/domain/entities/device_sync_params.dart';

/// الكلاس الأب لجميع أحداث ميزة الإشعارات وفق معايير AMD 2026.
abstract class NotificationsEvent extends Equatable {
  /// منشئ ثابت للحدث.
  const NotificationsEvent();

  @override
  List<Object?> get props => [];
}

/// حدث جلب كافة الإشعارات المحفوظة محلياً مع تحديث عداد غير المقروء.
class LoadNotificationsEvent extends NotificationsEvent {
  /// منشئ ثابت.
  const LoadNotificationsEvent();
}

/// حدث مزامنة بيانات الجهاز ورمز FCM مع خادم AppsNotifiersSystem.
class SyncDeviceTokenEvent extends NotificationsEvent {
  /// معاملات مزامنة الجهاز.
  final DeviceSyncParams params;

  /// منشئ ثابت يستقبل [params].
  const SyncDeviceTokenEvent(this.params);

  @override
  List<Object?> get props => [params];
}

/// حدث استقبال إشعار جديد أثناء عمل التطبيق لحفظه محلياً وتحديث الواجهة فوراً.
class ReceiveIncomingNotificationEvent extends NotificationsEvent {
  /// كيان الإشعار الوارد.
  final AppNotificationEntity notification;

  /// منشئ ثابت يستقبل [notification].
  const ReceiveIncomingNotificationEvent(this.notification);

  @override
  List<Object?> get props => [notification];
}

/// حدث تحديد إشعار معين كمقروء عند نقر المستخدم عليه.
class MarkNotificationReadEvent extends NotificationsEvent {
  /// المعرف المحلي للإشعار.
  final int notificationId;

  /// منشئ ثابت يستقبل [notificationId].
  const MarkNotificationReadEvent(this.notificationId);

  @override
  List<Object?> get props => [notificationId];
}

/// حدث تحديد جميع الإشعارات في السجل كمقروءة دفعة واحدة.
class MarkAllNotificationsReadEvent extends NotificationsEvent {
  /// منشئ ثابت.
  const MarkAllNotificationsReadEvent();
}

/// حدث حذف إشعار معين من السجل المحلي.
class DeleteNotificationItemEvent extends NotificationsEvent {
  /// المعرف المحلي للإشعار المراد حذفه.
  final int notificationId;

  /// منشئ ثابت يستقبل [notificationId].
  const DeleteNotificationItemEvent(this.notificationId);

  @override
  List<Object?> get props => [notificationId];
}

/// حدث مسح سجل الإشعارات بالكامل.
class ClearAllNotificationsEvent extends NotificationsEvent {
  /// منشئ ثابت.
  const ClearAllNotificationsEvent();
}