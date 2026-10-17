// lib/features/notifications/domain/usecases/mark_notification_as_read_usecase.dart
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:leave_manager/core/errors/failures.dart';
import 'package:leave_manager/core/usecases/base_usecase.dart';
import 'package:leave_manager/features/notifications/domain/repositories/notifications_repository.dart';

/// حالة استخدام لتحديد إشعار واحد كمقروء عبر تمرير معرفه [notificationId].
@lazySingleton
class MarkNotificationAsReadUseCase implements BaseUseCase<Unit, int> {
  final NotificationsRepository repository;

  /// منشئ الكلاس.
  const MarkNotificationAsReadUseCase(this.repository);

  @override
  Future<Either<Failure, Unit>> call(int notificationId) async {
    return await repository.markAsRead(notificationId);
  }
}