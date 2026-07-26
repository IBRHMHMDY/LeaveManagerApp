import 'package:equatable/equatable.dart';

abstract class RestAllowancesEvent extends Equatable {
  const RestAllowancesEvent();

  @override
  List<Object?> get props => [];
}

class LoadRestAllowancesEvent extends RestAllowancesEvent {}

class AddEarnedRestEvent extends RestAllowancesEvent {
  final DateTime startDate;
  final DateTime endDate;
  final String? notes;

  const AddEarnedRestEvent({
    required this.startDate,
    required this.endDate,
    this.notes,
  });

  @override
  List<Object?> get props => [startDate, endDate, notes];
}

class ConsumeRestEvent extends RestAllowancesEvent {
  final DateTime startDate;
  final DateTime endDate;
  final String? notes;
  final DateTime linkedEarnedDate;

  const ConsumeRestEvent({
    required this.startDate,
    required this.endDate,
    required this.linkedEarnedDate,
    this.notes,
  });

  @override
  List<Object?> get props => [startDate, endDate, notes, linkedEarnedDate];
}

class DeleteRestEvent extends RestAllowancesEvent {
  final int id;
  const DeleteRestEvent(this.id);

  @override
  List<Object?> get props => [id];
}
