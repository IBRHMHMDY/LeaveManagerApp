// lib/core/notifications/domain/repositories/notification_repository.dart
import 'package:dartz/dartz.dart';
import 'package:leave_manager/core/errors/failures.dart';

abstract class NotificationRepository {
  Future<Either<Failure, Unit>> initNotifications();
  Future<Either<Failure, Unit>> requestPermissions();
}