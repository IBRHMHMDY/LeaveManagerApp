import 'package:equatable/equatable.dart';

abstract class ExtraWorkEvent extends Equatable {
  const ExtraWorkEvent();

  @override
  List<Object?> get props => [];
}

class GetExtraWorkDaysEvent extends ExtraWorkEvent {}

class AddExtraWorkDayEvent extends ExtraWorkEvent {
  final DateTime date;
  final String? notes;

  const AddExtraWorkDayEvent({required this.date, this.notes});

  @override
  List<Object?> get props => [date, notes];
}

class DeleteExtraWorkDayEvent extends ExtraWorkEvent {
  final int id;

  const DeleteExtraWorkDayEvent(this.id);

  @override
  List<Object?> get props => [id];
}