import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:leave_manager/core/errors/failures.dart';
import 'package:leave_manager/core/usecases/base_usecase.dart';
import 'package:leave_manager/core/utils/notifications/notification_service.dart';
import 'package:leave_manager/features/notifications/domain/repositories/notification_repository.dart';

class ShowAndSaveNotificationParams {
  final int id;
  final String title;
  final String body;
  final String? payload;

  const ShowAndSaveNotificationParams({
    required this.id,
    required this.title,
    required this.body,
    this.payload,
  });
}

@lazySingleton
class ShowAndSaveNotificationUseCase implements BaseUseCase<Unit, ShowAndSaveNotificationParams> {
  final NotificationService notificationService;
  final NotificationRepository repository;

  ShowAndSaveNotificationUseCase({
    required this.notificationService,
    required this.repository,
  });

  @override
  Future<Either<Failure, Unit>> call(ShowAndSaveNotificationParams params) async {
    try {
      // 1. عرض الإشعار الفوري للمستخدم (على مستوى نظام التشغيل OS)
      await notificationService.showNotification(
        id: params.id,
        title: params.title,
        body: params.body,
        payload: params.payload,
      );

      // 2. حفظ الإشعار في قاعدة البيانات ليظهر في شاشة الإشعارات
      return await repository.saveNotification(
        title: params.title,
        body: params.body,
        payload: params.payload,
      );
    } catch (e) {
      return Left(ServerFailure('حدث خطأ أثناء عرض وحفظ الإشعار: $e'));
    }
  }
}