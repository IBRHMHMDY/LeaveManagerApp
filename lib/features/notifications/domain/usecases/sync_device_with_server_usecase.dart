// lib/features/notifications/domain/usecases/sync_device_with_server_usecase.dart
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:leave_manager/core/errors/failures.dart';
import 'package:leave_manager/core/usecases/base_usecase.dart';
import 'package:leave_manager/features/notifications/domain/entities/device_sync_params.dart';
import 'package:leave_manager/features/notifications/domain/repositories/notifications_repository.dart';

/// حالة استخدام لمزامنة بيانات الجهاز ورمز FCM مع الخادم المركزي.
@lazySingleton
class SyncDeviceWithServerUseCase
    implements BaseUseCase<Unit, DeviceSyncParams> {
  final NotificationsRepository repository;

  /// منشئ الكلاس يستقبل [NotificationsRepository] عبر الحقن التلقائي.
  const SyncDeviceWithServerUseCase(this.repository);

  @override
  Future<Either<Failure, Unit>> call(DeviceSyncParams params) async {
    if (params.fcmToken.trim().isEmpty) {
      return const Left(
        ValidationFailure('رمز الإشعارات (FCM Token) غير صالح.'),
      );
    }
    return await repository.syncDeviceWithServer(params);
  }
}