// lib/features/notifications/domain/usecases/subscribe_to_topic_usecase.dart
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:leave_manager/core/errors/failures.dart';
import 'package:leave_manager/core/usecases/base_usecase.dart';
import 'package:leave_manager/features/notifications/domain/repositories/notification_repository.dart';

@lazySingleton
class SubscribeToTopicUseCase implements BaseUseCase<Unit, String> {
  final NotificationRepository repository;

  SubscribeToTopicUseCase(this.repository);

  @override
  Future<Either<Failure, Unit>> call(String topic) async {
    return await repository.subscribeToTopic(topic);
  }
}