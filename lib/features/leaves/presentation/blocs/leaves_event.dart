import 'package:equatable/equatable.dart';
import 'package:leave_manager/features/leaves/domain/entities/leave_record_entity.dart';

abstract class LeavesEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LoadBalancesAndLeavesEvent extends LeavesEvent {}

class AddNewLeaveEvent extends LeavesEvent {
  final LeaveRecord leave;
  AddNewLeaveEvent(this.leave);
  @override
  List<Object> get props => [leave];
}

class ResetAllLeavesEvent extends LeavesEvent {}

class DeleteLeaveEvent extends LeavesEvent {
  final int leaveId;
  DeleteLeaveEvent(this.leaveId);
  @override
  List<Object> get props => [leaveId];
}