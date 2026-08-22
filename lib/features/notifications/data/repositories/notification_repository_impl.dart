import 'package:dartz/dartz.dart';
import 'package:drift/drift.dart';
import 'package:injectable/injectable.dart';
import 'package:leave_manager/core/database/app_database.dart';
import 'package:leave_manager/core/errors/exceptions.dart';
import 'package:leave_manager/core/errors/failures.dart';
import 'package:leave_manager/features/notifications/data/datasources/notifications_local_data_source.dart';
import 'package:leave_manager/features/notifications/data/models/notification_mapper.dart';
import 'package:leave_manager/features/notifications/domain/entities/notification_entity.dart';
import 'package:leave_manager/features/notifications/domain/repositories/notification_repository.dart';

@LazySingleton(as: NotificationRepository)
class NotificationRepositoryImpl implements NotificationRepository {
  final NotificationsLocalDataSource localDataSource;

  NotificationRepositoryImpl(this.localDataSource);

  @override
  Future<Either<Failure, Unit>> saveNotification({
    required String title,
    required String body,
    String? payload,
  }) async {
    try {
      final companion = NotificationsTableCompanion(
        title: Value(title),
        body: Value(body),
        payload: payload != null ? Value(payload) : const Value.absent(),
      );
      await localDataSource.saveNotification(companion);
      return const Right(unit);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<NotificationEntity>>> getNotifications() async {
    try {
      final models = await localDataSource.getNotifications();
      final entities = models.map((model) => model.toDomain()).toList();
      return Right(entities);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, Unit>> markAsRead(int id) async {
    try {
      await localDataSource.markAsRead(id);
      return const Right(unit);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, int>> getUnreadCount() async {
    try {
      final count = await localDataSource.getUnreadCount();
      return Right(count);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteNotification(int id) async {
    try {
      await localDataSource.deleteNotification(id);
      return const Right(unit);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    }
  }
}