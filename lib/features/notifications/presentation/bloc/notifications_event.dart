import 'package:equatable/equatable.dart';

abstract class NotificationsEvent extends Equatable {
  const NotificationsEvent();

  @override
  List<Object> get props => [];
}

class LoadNotificationsEvent extends NotificationsEvent {}

class MarkNotificationAsReadEvent extends NotificationsEvent {
  final int id;
  const MarkNotificationAsReadEvent(this.id);

  @override
  List<Object> get props => [id];
}

class DeleteNotificationEvent extends NotificationsEvent {
  final int id;
  const DeleteNotificationEvent(this.id);

  @override
  List<Object> get props => [id];
}