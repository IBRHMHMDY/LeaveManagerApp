// lib/features/notifications/domain/usecases/delete_notification_usecase.dart
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:leave_manager/core/errors/failures.dart';
import 'package:leave_manager/core/usecases/base_usecase.dart';
import 'package:leave_manager/features/notifications/domain/repositories/notifications_repository.dart';

/// حالة استخدام لحذف إشعار محدد من قاعدة البيانات المحلية.
@lazySingleton
class DeleteNotificationUseCase implements BaseUseCase<Unit, int> {
  final NotificationsRepository repository;

  /// منشئ الكلاس.
  const DeleteNotificationUseCase(this.repository);

  @override
  Future<Either<Failure, Unit>> call(int notificationId) async {
    return await repository.deleteNotification(notificationId);
  }
}