// lib/features/notifications/domain/repositories/notification_repository.dart
import 'package:dartz/dartz.dart';
import 'package:leave_manager/core/errors/failures.dart';
import 'package:leave_manager/features/notifications/domain/entities/notification_entity.dart';

abstract class NotificationRepository {
  Future<Either<Failure, Unit>> saveNotification({
    required String title,
    required String body,
    String? payload,
    DateTime? createdAt,
  });
  Future<Either<Failure, List<NotificationEntity>>> getNotifications();
  Future<Either<Failure, Unit>> markAsRead(int id);
  Future<Either<Failure, int>> getUnreadCount();
  Future<Either<Failure, Unit>> deleteNotification(int id);
  Future<Either<Failure, Unit>> deleteOldNotifications(DateTime threshold);
}