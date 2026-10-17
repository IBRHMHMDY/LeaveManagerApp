// lib/features/notifications/presentation/bloc/notifications_bloc.dart
import 'dart:async';
import 'package:dartz/dartz.dart';
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
import 'package:leave_manager/features/notifications/presentation/bloc/notifications_event.dart';
import 'package:leave_manager/features/notifications/presentation/bloc/notifications_state.dart';

/// BLoC لإدارة حالة الإشعارات، سجل التنبيهات المحلي، ومزامنة الجهاز مع الخادم.
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

  StreamSubscription<AppNotificationEntity>? _foregroundNotificationSubscription;

  /// منشئ الكلاس يستقبل كافة الـ UseCases وخدمة الإشعارات عبر الحقن التلقائي.
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
  })  : _syncDeviceWithServer = syncDeviceWithServer,
        _saveNotification = saveNotification,
        _getLocalNotifications = getLocalNotifications,
        _getUnreadCount = getUnreadCount,
        _markAsRead = markAsRead,
        _markAllAsRead = markAllAsRead,
        _deleteNotification = deleteNotification,
        _clearAllNotifications = clearAllNotifications,
        _pushNotificationService = pushNotificationService,
        super(const NotificationsInitial()) {
    on<LoadNotificationsEvent>(_onLoadNotifications);
    on<SyncDeviceTokenEvent>(_onSyncDeviceToken);
    on<ReceiveIncomingNotificationEvent>(_onReceiveIncomingNotification);
    on<MarkNotificationReadEvent>(_onMarkNotificationRead);
    on<MarkAllNotificationsReadEvent>(_onMarkAllNotificationsRead);
    on<DeleteNotificationItemEvent>(_onDeleteNotificationItem);
    on<ClearAllNotificationsEvent>(_onClearAllNotifications);

    // الاستماع للإشعارات الواردة أثناء فتح التطبيق
    _foregroundNotificationSubscription = _pushNotificationService
        .onForegroundNotificationStream
        .listen((notification) {
      add(ReceiveIncomingNotificationEvent(notification));
    });
  }

  /// معالجة جلب قائمة الإشعارات وعدد غير المقروء بالتوازي لتحسين الأداء.
  Future<void> _onLoadNotifications(
    LoadNotificationsEvent event,
    Emitter<NotificationsState> emit,
  ) async {
    if (state is! NotificationsLoaded) {
      emit(const NotificationsLoading());
    }

    final results = await Future.wait([
      _getLocalNotifications(const NoParams()),
      _getUnreadCount(const NoParams()),
    ]);

    final listResult =
        results[0] as Either<Failure, List<AppNotificationEntity>>;
    final countResult = results[1] as Either<Failure, int>;

    listResult.fold(
      (failure) => emit(NotificationsError(failure.message)),
      (notifications) {
        final unreadCount = countResult.getOrElse(() => 0);
        emit(
          NotificationsLoaded(
            notifications: List.unmodifiable(notifications),
            unreadCount: unreadCount,
          ),
        );
      },
    );
  }

  /// معالجة مزامنة الجهاز في الخلفية بصمت.
  Future<void> _onSyncDeviceToken(
    SyncDeviceTokenEvent event,
    Emitter<NotificationsState> emit,
  ) async {
    await _syncDeviceWithServer(event.params);
  }

  /// معالجة وصول إشعار جديد أثناء فتح التطبيق وحفظه ثم تحديث القائمة.
  Future<void> _onReceiveIncomingNotification(
    ReceiveIncomingNotificationEvent event,
    Emitter<NotificationsState> emit,
  ) async {
    final result = await _saveNotification(event.notification);
    result.fold(
      (failure) => emit(NotificationsError(failure.message)),
      (_) {
        if (!event.notification.isRead) {
          emit(IncomingNotificationAlertState(event.notification));
        }
        add(const LoadNotificationsEvent());
      },
    );
  }

  /// معالجة تحديد إشعار واحد كمقروء.
  Future<void> _onMarkNotificationRead(
    MarkNotificationReadEvent event,
    Emitter<NotificationsState> emit,
  ) async {
    final result = await _markAsRead(event.notificationId);
    result.fold(
      (failure) {
        emit(NotificationsError(failure.message));
        add(const LoadNotificationsEvent());
      },
      (_) => add(const LoadNotificationsEvent()),
    );
  }

  /// معالجة تحديد جميع الإشعارات كمقروءة.
  Future<void> _onMarkAllNotificationsRead(
    MarkAllNotificationsReadEvent event,
    Emitter<NotificationsState> emit,
  ) async {
    final result = await _markAllAsRead(const NoParams());
    result.fold(
      (failure) {
        emit(NotificationsError(failure.message));
        add(const LoadNotificationsEvent());
      },
      (_) {
        emit(
          const NotificationsActionSuccess(
            'تم تحديد جميع الإشعارات كمقروءة.',
          ),
        );
        add(const LoadNotificationsEvent());
      },
    );
  }

  /// معالجة حذف إشعار واحد من السجل.
  Future<void> _onDeleteNotificationItem(
    DeleteNotificationItemEvent event,
    Emitter<NotificationsState> emit,
  ) async {
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

  /// معالجة مسح سجل الإشعارات بالكامل.
  Future<void> _onClearAllNotifications(
    ClearAllNotificationsEvent event,
    Emitter<NotificationsState> emit,
  ) async {
    final result = await _clearAllNotifications(const NoParams());
    result.fold(
      (failure) {
        emit(NotificationsError(failure.message));
        add(const LoadNotificationsEvent());
      },
      (_) {
        emit(const NotificationsActionSuccess('تم مسح سجل الإشعارات بالكامل.'));
        add(const LoadNotificationsEvent());
      },
    );
  }

  /// إغلاق اشتراك الـ Stream حتماً عند إغلاق الـ BLoC لمنع تسريب الذاكرة (Memory Leak).
  @override
  Future<void> close() async {
    await _foregroundNotificationSubscription?.cancel();
    return super.close();
  }
}