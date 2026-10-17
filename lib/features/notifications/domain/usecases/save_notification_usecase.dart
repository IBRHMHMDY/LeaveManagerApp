// lib/features/notifications/domain/usecases/save_notification_usecase.dart
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:leave_manager/core/errors/failures.dart';
import 'package:leave_manager/core/usecases/base_usecase.dart';
import 'package:leave_manager/features/notifications/domain/entities/app_notification_entity.dart';
import 'package:leave_manager/features/notifications/domain/repositories/notifications_repository.dart';

/// حالة استخدام لحفظ إشعار جديد في قاعدة البيانات المحلية.
@lazySingleton
class SaveNotificationUseCase
    implements BaseUseCase<Unit, AppNotificationEntity> {
  final NotificationsRepository repository;

  /// منشئ الكلاس.
  const SaveNotificationUseCase(this.repository);

  @override
  Future<Either<Failure, Unit>> call(AppNotificationEntity notification) async {
    return await repository.saveNotification(notification);
  }
}