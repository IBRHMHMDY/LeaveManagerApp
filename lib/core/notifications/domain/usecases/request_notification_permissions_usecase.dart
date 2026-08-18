// lib/core/notifications/domain/usecases/request_notification_permissions_usecase.dart
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:leave_manager/core/errors/failures.dart';
import 'package:leave_manager/core/usecases/base_usecase.dart';
import 'package:leave_manager/core/notifications/domain/repositories/notification_repository.dart';

@lazySingleton
class RequestNotificationPermissionsUseCase implements BaseUseCase<Unit, NoParams> {
  final NotificationRepository repository;
  RequestNotificationPermissionsUseCase(this.repository);

  @override
  Future<Either<Failure, Unit>> call(NoParams params) async {
    return await repository.requestPermissions();
  }
}