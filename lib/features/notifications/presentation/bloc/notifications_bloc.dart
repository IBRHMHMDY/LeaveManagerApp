// lib/features/notifications/presentation/bloc/notifications_bloc.dart

import 'dart:async';
import 'package:dartz/dartz.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:leave_manager/core/errors/failures.dart';
import 'package:leave_manager/core/services/push_notification_service.dart';
import 'package:leave_manager/core/usecases/base_usecase.dart';
import 'package:leave_manager/features/notifications/domain/entities/app_notification_entity.dart';
import 'package:leave_manager/features/notifications/domain/usecases/clear_all_notifications_usecase.dart';
import 'package:leave_manager/features/notifications/domain/usecases/delete_notification_usecase.dart';
import 'package:leave_manager/features/notifications/domain/usecases/get_local_notifications_usecase.dart';
import 'package:leave_manager/features/notifications/domain/usecases/get_unread_notifications_count_usecase.dart';
import 'package:leave_manager/features/notifications/domain/usecases/mark_all_notifications_as_read_usecase.dart';
import 'package:leave_manager/features/notifications/domain/usecases/mark_notification_as_read_usecase.dart';
import 'package:leave_manager/features/notifications/domain/usecases/save_notification_usecase.dart';
import 'package:leave_manager/features/notifications/domain/usecases/sync_device_with_server_usecase.dart';
import 'package:leave_manager/features/notifications/domain/usecases/track_notification_usecase.dart';
import 'package:leave_manager/features/notifications/presentation/bloc/notifications_event.dart';
import 'package:leave_manager/features/notifications/presentation/bloc/notifications_state.dart';

@injectable
class NotificationsBloc extends Bloc<NotificationsEvent, NotificationsState> {
  final SyncDeviceWithServerUseCase _syncDeviceWithServer;
  final SaveNotificationUseCase _saveNotification;
  final GetLocalNotificationsUseCase _getLocalNotifications;
  final GetUnreadNotificationsCountUseCase _getUnreadCount;
  final MarkNotificationAsReadUseCase _markAsRead;
  final MarkAllNotificationsAsReadUseCase _markAllAsRead;
  final DeleteNotificationUseCase _deleteNotification;
  final ClearAllNotificationsUseCase _clearAllNotifications;
  final PushNotificationService _pushNotificationService;
  final TrackNotificationUseCase _trackNotification; // الـ UseCase الجديد

  StreamSubscription<AppNotificationEntity>? _foregroundNotificationSubscription;

  NotificationsBloc({
    required SyncDeviceWithServerUseCase syncDeviceWithServer,
    required SaveNotificationUseCase saveNotification,
    required GetLocalNotificationsUseCase getLocalNotifications,
    required GetUnreadNotificationsCountUseCase getUnreadCount,
    required MarkNotificationAsReadUseCase markAsRead,
    required MarkAllNotificationsAsReadUseCase markAllAsRead,
    required DeleteNotificationUseCase deleteNotification,
    required ClearAllNotificationsUseCase clearAllNotifications,
    required PushNotificationService pushNotificationService,
    required TrackNotificationUseCase trackNotification,
  }) : _syncDeviceWithServer = syncDeviceWithServer,
       _saveNotification = saveNotification,
       _getLocalNotifications = getLocalNotifications,
       _getUnreadCount = getUnreadCount,
       _markAsRead = markAsRead,
       _markAllAsRead = markAllAsRead,
       _deleteNotification = deleteNotification,
       _clearAllNotifications = clearAllNotifications,
       _pushNotificationService = pushNotificationService,
       _trackNotification = trackNotification,
       super(const NotificationsInitial()) {
    
    on<LoadNotificationsEvent>(_onLoadNotifications);
    on<SyncDeviceTokenEvent>(_onSyncDeviceToken);
    on<ReceiveIncomingNotificationEvent>(_onReceiveIncomingNotification);
    on<TrackNotificationStatusEvent>(_onTrackNotificationStatus);
    on<MarkNotificationReadEvent>(_onMarkNotificationRead);
    on<MarkAllNotificationsReadEvent>(_onMarkAllNotificationsRead);
    on<DeleteNotificationItemEvent>(_onDeleteNotificationItem);
    on<ClearAllNotificationsEvent>(_onClearAllNotifications);
    on<RequestNotificationPermissionEvent>(_onRequestNotificationPermission);

    _foregroundNotificationSubscription = _pushNotificationService
        .onForegroundNotificationStream
        .listen((notification) {
          add(ReceiveIncomingNotificationEvent(notification));
        });
  }

  Future<void> _onLoadNotifications(LoadNotificationsEvent event, Emitter<NotificationsState> emit) async {
    if (state is! NotificationsLoaded) {
      emit(const NotificationsLoading());
    }
    final results = await Future.wait([
      _getLocalNotifications(const NoParams()),
      _getUnreadCount(const NoParams()),
    ]);
    final listResult = results[0] as Either<Failure, List<AppNotificationEntity>>;
    final countResult = results[1] as Either<Failure, int>;

    listResult.fold((failure) => emit(NotificationsError(failure.message)), (notifications) {
      final unreadCount = countResult.getOrElse(() => 0);
      emit(NotificationsLoaded(
        notifications: List.unmodifiable(notifications),
        unreadCount: unreadCount,
      ));
    });
  }

  Future<void> _onSyncDeviceToken(SyncDeviceTokenEvent event, Emitter<NotificationsState> emit) async {
    await _syncDeviceWithServer(event.params);
  }

  Future<void> _onReceiveIncomingNotification(ReceiveIncomingNotificationEvent event, Emitter<NotificationsState> emit) async {
    final result = await _saveNotification(event.notification);
    result.fold((failure) => emit(NotificationsError(failure.message)), (_) {
      if (!event.notification.isRead) {
        emit(IncomingNotificationAlertState(event.notification));
      }
      // تتبع الاستلام (DELIVERED) إذا كان يحتوي على remoteId
      if (event.notification.remoteId != null) {
        add(TrackNotificationStatusEvent(event.notification.remoteId!, 'DELIVERED'));
      }
      add(const LoadNotificationsEvent());
    });
  }

  Future<void> _onTrackNotificationStatus(TrackNotificationStatusEvent event, Emitter<NotificationsState> emit) async {
    // تعمل بصمت (Fire and Forget) حتى لا تقاطع الـ UI
    await _trackNotification(TrackNotificationParams(remoteId: event.remoteId, event: event.event));
  }

  Future<void> _onMarkNotificationRead(MarkNotificationReadEvent event, Emitter<NotificationsState> emit) async {
    final result = await _markAsRead(event.notificationId);
    result.fold((failure) {
      emit(NotificationsError(failure.message));
      add(const LoadNotificationsEvent());
    }, (_) => add(const LoadNotificationsEvent()));
  }

  Future<void> _onMarkAllNotificationsRead(MarkAllNotificationsReadEvent event, Emitter<NotificationsState> emit) async {
    final result = await _markAllAsRead(const NoParams());
    result.fold(
      (failure) {
        emit(NotificationsError(failure.message));
        add(const LoadNotificationsEvent());
      },
      (_) {
        emit(const NotificationsActionSuccess('تم تعيين الكل كمقروء.'));
        add(const LoadNotificationsEvent());
      },
    );
  }

  Future<void> _onDeleteNotificationItem(DeleteNotificationItemEvent event, Emitter<NotificationsState> emit) async {
    final result = await _deleteNotification(event.notificationId);
    result.fold(
      (failure) {
        emit(NotificationsError(failure.message));
        add(const LoadNotificationsEvent());
      },
      (_) {
        emit(const NotificationsActionSuccess('تم حذف الإشعار بنجاح.'));
        add(const LoadNotificationsEvent());
      },
    );
  }

  Future<void> _onClearAllNotifications(ClearAllNotificationsEvent event, Emitter<NotificationsState> emit) async {
    final result = await _clearAllNotifications(const NoParams());
    result.fold(
      (failure) {
        emit(NotificationsError(failure.message));
        add(const LoadNotificationsEvent());
      },
      (_) {
        emit(const NotificationsActionSuccess('تم مسح جميع الإشعارات.'));
        add(const LoadNotificationsEvent());
      },
    );
  }

  Future<void> _onRequestNotificationPermission(RequestNotificationPermissionEvent event, Emitter<NotificationsState> emit) async {
    try {
      final isGranted = await _pushNotificationService.requestNotificationPermissions();
      if (!isGranted) {
        emit(const NotificationPermissionDeniedState('الرجاء تفعيل الإشعارات من إعدادات النظام لضمان استقبال التنبيهات المهمة.'));
      }
    } catch (e) {
      debugPrint('Permission Request Error: $e');
    }
  }

  @override
  Future<void> close() async {
    await _foregroundNotificationSubscription?.cancel();
    return super.close();
  }
}