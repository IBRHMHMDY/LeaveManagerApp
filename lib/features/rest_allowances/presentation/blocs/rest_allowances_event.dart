// lib/features/rest_allowances/presentation/blocs/rest_allowances_event.dart
import 'package:equatable/equatable.dart';
import 'package:leave_manager/core/utils/enums/work_reason.dart';

abstract class RestAllowancesEvent extends Equatable {
  const RestAllowancesEvent();

  @override
  List<Object?> get props => [];
}

class LoadRestAllowancesEvent extends RestAllowancesEvent {}

class AddExtraWorkEvent extends RestAllowancesEvent {
  final DateTime workStartDate;
  final DateTime workEndDate;
  final int daysCount;
  final WorkReason workReason;
  final String? notes;
  final int? holidayId;

  const AddExtraWorkEvent({
    required this.workStartDate,
    required this.workEndDate,
    required this.daysCount,
    required this.workReason,
    this.notes,
    this.holidayId,
  });

  @override
  List<Object?> get props => [workStartDate, workEndDate, daysCount, workReason, notes, holidayId];
}

class ConsumeRestEvent extends RestAllowancesEvent {
  final int allowanceId;
  final DateTime restStartDate;
  final DateTime restEndDate;
  final int usedDaysCount;
  final String? notes;

  const ConsumeRestEvent({
    required this.allowanceId,
    required this.restStartDate,
    required this.restEndDate,
    required this.usedDaysCount,
    this.notes,
  });

  @override
  List<Object?> get props => [allowanceId, restStartDate, restEndDate, usedDaysCount, notes];
}

class DeleteExtraWorkEvent extends RestAllowancesEvent {
  final int id;

  const DeleteExtraWorkEvent(this.id);

  @override
  List<Object?> get props => [id];
}