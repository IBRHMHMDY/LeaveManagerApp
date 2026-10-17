// lib/features/notifications/domain/entities/app_notification_entity.dart
import 'package:equatable/equatable.dart';

/// كيان يمثل الإشعار داخل طبقة منطق الأعمال (Domain Layer).
/// يتبع مبدأ Immutable State ويستخدم [Equatable] للمقارنة القيمية وفق معايير AMD 2026.
class AppNotificationEntity extends Equatable {
  /// المعرف المحلي للإشعار في قاعدة البيانات.
  final int id;

  /// المعرف الفريد للإشعار القادم من الخادم أو FCM (لمنع التكرار).
  final String? remoteId;

  /// عنوان الإشعار.
  final String title;

  /// نص ومحتوى الإشعار.
  final String body;

  /// رابط الصورة المرفقة بالإشعار إن وجد.
  final String? imageUrl;

  /// مسار التوجيه الداخلي (Deep Link) أو الرابط الخارجي.
  final String? actionUrl;

  /// البيانات الإضافية المرفقة مع الإشعار بصيغة JSON String.
  final String? payloadJson;

  /// حالة قراءة الإشعار.
  final bool isRead;

  /// تاريخ ووقت استلام الإشعار.
  final DateTime receivedAt;

  /// منشئ ثابت (const constructor) لتحسين الأداء ومنع إعادة البناء غير الضرورية.
  const AppNotificationEntity({
    required this.id,
    this.remoteId,
    required this.title,
    required this.body,
    this.imageUrl,
    this.actionUrl,
    this.payloadJson,
    required this.isRead,
    required this.receivedAt,
  });

  /// إنشاء نسخة معدلة من الكيان مع الحفاظ على عدم قابلية التغيير (Immutability).
  AppNotificationEntity copyWith({
    int? id,
    String? remoteId,
    String? title,
    String? body,
    String? imageUrl,
    String? actionUrl,
    String? payloadJson,
    bool? isRead,
    DateTime? receivedAt,
  }) {
    return AppNotificationEntity(
      id: id ?? this.id,
      remoteId: remoteId ?? this.remoteId,
      title: title ?? this.title,
      body: body ?? this.body,
      imageUrl: imageUrl ?? this.imageUrl,
      actionUrl: actionUrl ?? this.actionUrl,
      payloadJson: payloadJson ?? this.payloadJson,
      isRead: isRead ?? this.isRead,
      receivedAt: receivedAt ?? this.receivedAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        remoteId,
        title,
        body,
        imageUrl,
        actionUrl,
        payloadJson,
        isRead,
        receivedAt,
      ];
}