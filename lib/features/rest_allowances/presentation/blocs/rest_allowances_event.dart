// lib/features/rest_allowances/presentation/blocs/rest_allowances_event.dart
import 'package:equatable/equatable.dart';
import 'package:leave_manager/core/utils/enums/work_reason.dart';

abstract class RestAllowancesEvent extends Equatable {
  const RestAllowancesEvent();

  @override
  List<Object?> get props => [];
}

class LoadRestAllowancesEvent extends RestAllowancesEvent {}

class AddEarnedRestEvent extends RestAllowancesEvent {
  final DateTime startDate;
  final DateTime endDate;
  final WorkReason workReason;
  final String? notes;
  final int? holidayId;

  const AddEarnedRestEvent({
    required this.startDate,
    required this.endDate,
    required this.workReason,
    this.notes,
    this.holidayId
  });

  @override
  List<Object?> get props => [startDate, endDate, workReason, notes,holidayId];
}

class ConsumeRestEvent extends RestAllowancesEvent {
  final DateTime startDate;
  final DateTime endDate;
  final int overtimeId;
  final DateTime linkedOvertimeStartDate;
  final WorkReason workReason;
  final String? notes;

  const ConsumeRestEvent({
    required this.startDate,
    required this.endDate,
    required this.overtimeId,
    required this.linkedOvertimeStartDate,
    required this.workReason,
    this.notes,
  });

  @override
  List<Object?> get props => [
        startDate, 
        endDate, 
        overtimeId, 
        linkedOvertimeStartDate, 
        workReason, 
        notes
      ];
}

class DeleteOvertimeEvent extends RestAllowancesEvent {
  final int id;
  const DeleteOvertimeEvent(this.id);
  
  @override
  List<Object?> get props => [id];
}

class DeleteRestEvent extends RestAllowancesEvent {
  final int id;
  const DeleteRestEvent(this.id);
  
  @override
  List<Object?> get props => [id];
}