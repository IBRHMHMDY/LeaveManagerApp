// lib/core/notifications/data/repositories/notification_repository_impl.dart
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:leave_manager/core/errors/failures.dart';
import 'package:leave_manager/core/utils/notification_service.dart';
import 'package:leave_manager/core/notifications/domain/repositories/notification_repository.dart';

@LazySingleton(as: NotificationRepository)
class NotificationRepositoryImpl implements NotificationRepository {
  final NotificationService notificationService;

  NotificationRepositoryImpl(this.notificationService);

  @override
  Future<Either<Failure, Unit>> initNotifications() async {
    try {
      await notificationService.init();
      return const Right(unit);
    } catch (e) {
      return const Left(ValidationFailure('فشل في تهيئة الإشعارات'));
    }
  }

  @override
  Future<Either<Failure, Unit>> requestPermissions() async {
    try {
      await notificationService.requestPermissions();
      return const Right(unit);
    } catch (e) {
      return const Left(ValidationFailure('فشل في طلب صلاحيات الإشعارات'));
    }
  }
}