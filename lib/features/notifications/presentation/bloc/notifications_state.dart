// lib/features/notifications/presentation/bloc/notifications_state.dart
import 'package:equatable/equatable.dart';
import 'package:leave_manager/features/notifications/domain/entities/app_notification_entity.dart';

/// الكلاس الأب لجميع حالات ميزة الإشعارات وفق معايير AMD 2026.
abstract class NotificationsState extends Equatable {
  /// منشئ ثابت للحالة.
  const NotificationsState();

  @override
  List<Object?> get props => [];
}

/// الحالة الابتدائية قبل تحميل الإشعارات.
class NotificationsInitial extends NotificationsState {
  /// منشئ ثابت.
  const NotificationsInitial();
}

/// حالة جاري تحميل سجل الإشعارات.
class NotificationsLoading extends NotificationsState {
  /// منشئ ثابت.
  const NotificationsLoading();
}

/// حالة نجاح تحميل الإشعارات مع الاحتفاظ بعدد الإشعارات غير المقروءة.
class NotificationsLoaded extends NotificationsState {
  /// قائمة الإشعارات غير القابلة للتعديل المباشر (Immutable List).
  final List<AppNotificationEntity> notifications;

  /// إجمالي عدد الإشعارات غير المقروءة لعرضها في شارة الجرس (Badge).
  final int unreadCount;

  /// منشئ ثابت يستقبل قائمة الإشعارات وعدد غير المقروء.
  const NotificationsLoaded({
    required this.notifications,
    required this.unreadCount,
  });

  @override
  List<Object?> get props => [notifications, unreadCount];
}

/// حالة نجاح تنفيذ إجراء فرعي (مثل حذف إشعار أو تحديد الكل كمقروء) لعرض AppToast.
class NotificationsActionSuccess extends NotificationsState {
  /// رسالة النجاح الموجهة للمستخدم.
  final String message;

  /// منشئ ثابت يستقبل [message].
  const NotificationsActionSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

/// حالة وصول إشعار فوري أثناء فتح التطبيق (Foreground) لعرض تنبيه للمستخدم.
class IncomingNotificationAlertState extends NotificationsState {
  /// الإشعار الوارد حديثاً.
  final AppNotificationEntity notification;

  /// منشئ ثابت يستقبل [notification].
  const IncomingNotificationAlertState(this.notification);

  @override
  List<Object?> get props => [notification];
}

/// حالة حدوث خطأ أثناء التعامل مع الإشعارات.
class NotificationsError extends NotificationsState {
  /// رسالة الخطأ الواضحة للمستخدم.
  final String message;

  /// منشئ ثابت يستقبل [message].
  const NotificationsError(this.message);

  @override
  List<Object?> get props => [message];
}