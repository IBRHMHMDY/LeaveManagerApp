import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:leave_manager/core/usecases/base_usecase.dart';
import 'package:leave_manager/features/notifications/domain/usecases/delete_notification_usecase.dart';
import 'package:leave_manager/features/notifications/domain/usecases/get_notifications_usecase.dart';
import 'package:leave_manager/features/notifications/domain/usecases/get_unread_count_usecase.dart';
import 'package:leave_manager/features/notifications/domain/usecases/mark_notification_as_read_usecase.dart';
import 'notifications_event.dart';
import 'notifications_state.dart';

@injectable
class NotificationsBloc extends Bloc<NotificationsEvent, NotificationsState> {
  final GetNotificationsUseCase getNotifications;
  final MarkNotificationAsReadUseCase markAsRead;
  final DeleteNotificationUseCase deleteNotification;
  final GetUnreadCountUseCase getUnreadCount;

  NotificationsBloc({
    required this.getNotifications,
    required this.markAsRead,
    required this.deleteNotification,
    required this.getUnreadCount,
  }) : super(NotificationsInitial()) {
    on<LoadNotificationsEvent>(_onLoadNotifications);
    on<MarkNotificationAsReadEvent>(_onMarkAsRead);
    on<DeleteNotificationEvent>(_onDeleteNotification);
  }

  Future<void> _onLoadNotifications(
      LoadNotificationsEvent event, Emitter<NotificationsState> emit) async {
    emit(NotificationsLoading());
    await _fetchAndEmitData(emit);
  }

  Future<void> _onMarkAsRead(
      MarkNotificationAsReadEvent event, Emitter<NotificationsState> emit) async {
    // تحديث صامت بدون إرسال Loading لتفادي وميض الشاشة
    final result = await markAsRead(event.id);
    await result.fold(
      (failure) async => emit(NotificationsError(failure.message)),
      (_) async => await _fetchAndEmitData(emit),
    );
  }

  Future<void> _onDeleteNotification(
      DeleteNotificationEvent event, Emitter<NotificationsState> emit) async {
    final result = await deleteNotification(event.id);
    await result.fold(
      (failure) async => emit(NotificationsError(failure.message)),
      (_) async => await _fetchAndEmitData(emit),
    );
  }

  Future<void> _fetchAndEmitData(Emitter<NotificationsState> emit) async {
    final notificationsResult = await getNotifications(const NoParams());
    final countResult = await getUnreadCount(const NoParams());

    notificationsResult.fold(
      (failure) => emit(NotificationsError(failure.message)),
      (notifications) {
        countResult.fold(
          (failure) => emit(NotificationsError(failure.message)),
          (count) => emit(NotificationsLoaded(
            notifications: notifications,
            unreadCount: count,
          )),
        );
      },
    );
  }
}