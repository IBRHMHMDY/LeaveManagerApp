import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:leave_manager/core/errors/failures.dart';
import 'package:leave_manager/core/usecases/base_usecase.dart';
import 'package:leave_manager/features/notifications/domain/entities/notification_entity.dart';
import 'package:leave_manager/features/notifications/domain/repositories/notification_repository.dart';

@lazySingleton
class GetNotificationsUseCase implements BaseUseCase<List<NotificationEntity>, NoParams> {
  final NotificationRepository repository;

  GetNotificationsUseCase(this.repository);

  @override
  Future<Either<Failure, List<NotificationEntity>>> call(NoParams params) async {
    return await repository.getNotifications();
  }
}