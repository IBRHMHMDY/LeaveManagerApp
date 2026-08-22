import 'package:leave_manager/core/database/app_database.dart';
import 'package:leave_manager/features/notifications/domain/entities/notification_entity.dart';

extension NotificationMapper on NotificationModel {
  NotificationEntity toDomain() {
    return NotificationEntity(
      id: id,
      title: title,
      body: body,
      payload: payload,
      isRead: isRead,
      createdAt: createdAt,
    );
  }
}