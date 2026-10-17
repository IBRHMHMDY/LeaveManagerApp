// lib/features/notifications/domain/usecases/get_unread_notifications_count_usecase.dart
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:leave_manager/core/errors/failures.dart';
import 'package:leave_manager/core/usecases/base_usecase.dart';
import 'package:leave_manager/features/notifications/domain/repositories/notifications_repository.dart';

/// حالة استخدام لجلب عدد الإشعارات غير المقروءة.
@lazySingleton
class GetUnreadNotificationsCountUseCase implements BaseUseCase<int, NoParams> {
  final NotificationsRepository repository;

  /// منشئ الكلاس.
  const GetUnreadNotificationsCountUseCase(this.repository);

  @override
  Future<Either<Failure, int>> call(NoParams params) async {
    return await repository.getUnreadCount();
  }
}