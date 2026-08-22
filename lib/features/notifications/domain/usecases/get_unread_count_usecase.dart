import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:leave_manager/core/errors/failures.dart';
import 'package:leave_manager/core/usecases/base_usecase.dart';
import 'package:leave_manager/features/notifications/domain/repositories/notification_repository.dart';

@lazySingleton
class GetUnreadCountUseCase implements BaseUseCase<int, NoParams> {
  final NotificationRepository repository;

  GetUnreadCountUseCase(this.repository);

  @override
  Future<Either<Failure, int>> call(NoParams params) async {
    return await repository.getUnreadCount();
  }
}