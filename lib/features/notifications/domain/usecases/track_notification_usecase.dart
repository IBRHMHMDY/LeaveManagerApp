// lib/features/notifications/domain/usecases/track_notification_usecase.dart

import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:leave_manager/core/errors/failures.dart';
import 'package:leave_manager/core/usecases/base_usecase.dart';
import 'package:leave_manager/features/notifications/domain/repositories/notifications_repository.dart';

class TrackNotificationParams {
  final String remoteId;
  final String event; // 'DELIVERED', 'OPENED', etc.

  TrackNotificationParams({required this.remoteId, required this.event});
}

@lazySingleton
class TrackNotificationUseCase implements BaseUseCase<Unit, TrackNotificationParams> {
  final NotificationsRepository repository;

  const TrackNotificationUseCase(this.repository);

  @override
  Future<Either<Failure, Unit>> call(TrackNotificationParams params) async {
    return await repository.trackNotification(
      remoteId: params.remoteId,
      event: params.event,
    );
  }
}