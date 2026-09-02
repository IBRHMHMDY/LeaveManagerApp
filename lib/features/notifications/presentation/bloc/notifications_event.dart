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

class SendAndSaveInstantNotificationEvent extends NotificationsEvent {
  final int id;
  final String title;
  final String body;
  final String? payload;

  const SendAndSaveInstantNotificationEvent({
    required this.id,
    required this.title,
    required this.body,
    this.payload,
  });

  @override
  List<Object> get props => [id, title, body, ?payload];
}