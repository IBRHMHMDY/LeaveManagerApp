// lib/features/notifications/domain/repositories/notifications_repository.dart
import 'package:dartz/dartz.dart';
import 'package:leave_manager/core/errors/failures.dart';
import 'package:leave_manager/features/notifications/domain/entities/app_notification_entity.dart';
import 'package:leave_manager/features/notifications/domain/entities/device_sync_params.dart';

/// العقد البرمجي (Interface) لمستودع الإشعارات في طبقة الـ Domain.
/// جميع الدوال ترجع [Either<Failure, T>] للتعامل الوظيفي مع الأخطاء وفق وثيقة AMD 2026.
abstract class NotificationsRepository {
  /// مزامنة بيانات الجهاز ورمز FCM مع خادم AppsNotifiersSystem.
  Future<Either<Failure, Unit>> syncDeviceWithServer(DeviceSyncParams params);

  /// حفظ إشعار جديد وارد من Firebase في قاعدة البيانات المحلية (Drift).
  Future<Either<Failure, Unit>> saveNotification(
    AppNotificationEntity notification,
  );

  /// جلب جميع الإشعارات المحفوظة محلياً مرتبة من الأحدث إلى الأقدم.
  Future<Either<Failure, List<AppNotificationEntity>>> getLocalNotifications();

  /// الحصول على عدد الإشعارات غير المقروءة لعرضها في شارة التنبيه (Badge).
  Future<Either<Failure, int>> getUnreadCount();

  /// تحديد إشعار معين كمقروء بواسطة معرفه المحلي [id].
  Future<Either<Failure, Unit>> markAsRead(int id);

  /// تحديد جميع الإشعارات المحفوظة كمقروءة دفعة واحدة.
  Future<Either<Failure, Unit>> markAllAsRead();

  /// حذف إشعار معين من السجل المحلي بواسطة معرفه [id].
  Future<Either<Failure, Unit>> deleteNotification(int id);

  /// مسح سجل الإشعارات المحلي بالكامل.
  Future<Either<Failure, Unit>> clearAllNotifications();
}