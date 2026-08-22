import 'dart:async';
import 'package:injectable/injectable.dart';
import 'package:leave_manager/core/router/app_router.dart';
import 'package:leave_manager/core/utils/notifications/notification_service.dart';

@lazySingleton
class NotificationFlowManager {
  final NotificationService _notificationService;
  StreamSubscription<String?>? _subscription;

  NotificationFlowManager(this._notificationService);

  void init() {
    _subscription?.cancel();

    if (_notificationService.initialPayload != null) {
      _handlePayload(_notificationService.initialPayload!);
      _notificationService.initialPayload = null;
    }

    _subscription = selectNotificationStream.stream.listen((String? payload) {
      if (payload != null) {
        _handlePayload(payload);
      }
    });
  }

  void _handlePayload(String payload) {
    AppRouter.router.push(AppRouter.notifications);
  }

  void dispose() {
    _subscription?.cancel();
  }
}