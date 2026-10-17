// lib/features/notifications/domain/usecases/get_local_notifications_usecase.dart
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:leave_manager/core/errors/failures.dart';
import 'package:leave_manager/core/usecases/base_usecase.dart';
import 'package:leave_manager/features/notifications/domain/entities/app_notification_entity.dart';
import 'package:leave_manager/features/notifications/domain/repositories/notifications_repository.dart';

/// حالة استخدام لجلب قائمة الإشعارات المخزنة محلياً.
@lazySingleton
class GetLocalNotificationsUseCase
    implements BaseUseCase<List<AppNotificationEntity>, NoParams> {
  final NotificationsRepository repository;

  /// منشئ الكلاس.
  const GetLocalNotificationsUseCase(this.repository);

  @override
  Future<Either<Failure, List<AppNotificationEntity>>> call(
    NoParams params,
  ) async {
    return await repository.getLocalNotifications();
  }
}