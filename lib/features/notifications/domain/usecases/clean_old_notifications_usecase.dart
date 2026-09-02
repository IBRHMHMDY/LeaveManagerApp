import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:leave_manager/core/errors/failures.dart';
import 'package:leave_manager/core/usecases/base_usecase.dart';
import 'package:leave_manager/features/notifications/domain/repositories/notification_repository.dart';

@lazySingleton
class CleanOldNotificationsUseCase implements BaseUseCase<Unit, NoParams> {
  final NotificationRepository repository;

  CleanOldNotificationsUseCase(this.repository);

  @override
  Future<Either<Failure, Unit>> call(NoParams params) async {
    // تحديد العتبة الزمنية (قبل 30 يوماً من الآن)
    final threshold = DateTime.now().subtract(const Duration(days: 30));
    return await repository.deleteOldNotifications(threshold);
  }
}