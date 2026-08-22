import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:leave_manager/core/errors/failures.dart';
import 'package:leave_manager/core/usecases/base_usecase.dart';
import 'package:leave_manager/features/notifications/domain/repositories/notification_repository.dart';

class SaveNotificationParams {
  final String title;
  final String body;
  final String? payload;

  const SaveNotificationParams({
    required this.title,
    required this.body,
    this.payload,
  });
}

@lazySingleton
class SaveNotificationUseCase implements BaseUseCase<Unit, SaveNotificationParams> {
  final NotificationRepository repository;

  SaveNotificationUseCase(this.repository);

  @override
  Future<Either<Failure, Unit>> call(SaveNotificationParams params) async {
    return await repository.saveNotification(
      title: params.title,
      body: params.body,
      payload: params.payload,
    );
  }
}