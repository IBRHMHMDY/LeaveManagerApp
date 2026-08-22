import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:leave_manager/core/errors/failures.dart';
import 'package:leave_manager/core/usecases/base_usecase.dart';
import 'package:leave_manager/features/notifications/domain/repositories/notification_repository.dart';

@lazySingleton
class MarkNotificationAsReadUseCase implements BaseUseCase<Unit, int> {
  final NotificationRepository repository;

  MarkNotificationAsReadUseCase(this.repository);

  @override
  Future<Either<Failure, Unit>> call(int id) async {
    return await repository.markAsRead(id);
  }
}