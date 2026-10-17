// lib/features/notifications/data/models/notification_mapper.dart
import 'dart:convert';
import 'package:drift/drift.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:leave_manager/core/database/app_database.dart';
import 'package:leave_manager/features/notifications/domain/entities/app_notification_entity.dart';

/// Extension لتحويل نموذج قاعدة بيانات Drift [NotificationModel] إلى كيان [AppNotificationEntity].
extension NotificationModelMapper on NotificationModel {
  /// تحويل سجل قاعدة البيانات المحلية إلى كيان Domain نقي.
  AppNotificationEntity toDomain() {
    return AppNotificationEntity(
      id: id,
      remoteId: remoteId,
      title: title,
      body: body,
      imageUrl: imageUrl,
      actionUrl: actionUrl,
      payloadJson: payloadJson,
      isRead: isRead,
      receivedAt: receivedAt,
    );
  }
}

/// Extension لتحويل كيان [AppNotificationEntity] إلى [NotificationsTableCompanion] للإدراج في Drift.
extension NotificationEntityMapper on AppNotificationEntity {
  /// تجهيز الكيان للحفظ داخل جدول NotificationsTable في قاعدة البيانات المحلية.
  NotificationsTableCompanion toCompanion() {
    return NotificationsTableCompanion(
      remoteId: remoteId != null ? Value(remoteId) : const Value.absent(),
      title: Value(title),
      body: Value(body),
      imageUrl: imageUrl != null ? Value(imageUrl) : const Value.absent(),
      actionUrl: actionUrl != null ? Value(actionUrl) : const Value.absent(),
      payloadJson:
          payloadJson != null ? Value(payloadJson) : const Value.absent(),
      isRead: Value(isRead),
      receivedAt: Value(receivedAt),
    );
  }
}

/// Extension لتحويل رسالة Firebase الواردة [RemoteMessage] إلى كيان [AppNotificationEntity].
extension RemoteMessageMapper on RemoteMessage {
  /// استخراج العنوان، المحتوى، الصورة، وبيانات التوجيه من رسالة FCM.
  AppNotificationEntity toDomainEntity() {
    final notificationTitle =
        notification?.title ?? data['title']?.toString() ?? 'إشعار جديد';
    final notificationBody =
        notification?.body ?? data['body']?.toString() ?? '';

    final image = notification?.android?.imageUrl ??
        notification?.apple?.imageUrl ??
        data['image']?.toString() ??
        data['image_url']?.toString();

    final action = data['action_url']?.toString() ??
        data['route']?.toString() ??
        data['url']?.toString();

    final encodedPayload = data.isNotEmpty ? jsonEncode(data) : null;

    return AppNotificationEntity(
      id: 0,
      remoteId: messageId ?? data['notification_id']?.toString(),
      title: notificationTitle,
      body: notificationBody,
      imageUrl: image,
      actionUrl: action,
      payloadJson: encodedPayload,
      isRead: false,
      receivedAt: sentTime ?? DateTime.now(),
    );
  }
}