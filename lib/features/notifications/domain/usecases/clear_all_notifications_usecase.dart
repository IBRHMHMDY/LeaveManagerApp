// lib/features/notifications/domain/usecases/clear_all_notifications_usecase.dart
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:leave_manager/core/errors/failures.dart';
import 'package:leave_manager/core/usecases/base_usecase.dart';
import 'package:leave_manager/features/notifications/domain/repositories/notifications_repository.dart';

/// حالة استخدام لمسح جميع الإشعارات المحفوظة محلياً.
@lazySingleton
class ClearAllNotificationsUseCase implements BaseUseCase<Unit, NoParams> {
  final NotificationsRepository repository;

  /// منشئ الكلاس.
  const ClearAllNotificationsUseCase(this.repository);

  @override
  Future<Either<Failure, Unit>> call(NoParams params) async {
    return await repository.clearAllNotifications();
  }
}