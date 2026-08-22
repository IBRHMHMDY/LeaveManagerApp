import 'package:equatable/equatable.dart';

class NotificationEntity extends Equatable {
  final int id;
  final String title;
  final String body;
  final String? payload;
  final bool isRead;
  final DateTime createdAt;

  const NotificationEntity({
    required this.id,
    required this.title,
    required this.body,
    this.payload,
    required this.isRead,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [id, title, body, payload, isRead, createdAt];
}