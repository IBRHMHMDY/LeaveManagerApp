// lib/features/notifications/domain/usecases/mark_all_notifications_as_read_usecase.dart
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:leave_manager/core/errors/failures.dart';
import 'package:leave_manager/core/usecases/base_usecase.dart';
import 'package:leave_manager/features/notifications/domain/repositories/notifications_repository.dart';

/// حالة استخدام لتحديد كافة الإشعارات في السجل كمقروءة.
@lazySingleton
class MarkAllNotificationsAsReadUseCase implements BaseUseCase<Unit, NoParams> {
  final NotificationsRepository repository;

  /// منشئ الكلاس.
  const MarkAllNotificationsAsReadUseCase(this.repository);

  @override
  Future<Either<Failure, Unit>> call(NoParams params) async {
    return await repository.markAllAsRead();
  }
}