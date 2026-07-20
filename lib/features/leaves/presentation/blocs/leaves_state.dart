import 'package:equatable/equatable.dart';
import 'package:leave_manager/features/leaves/domain/entities/leave_balance_entity.dart';
import 'package:leave_manager/features/leaves/domain/entities/leave_record_entity.dart';

abstract class LeavesState extends Equatable {
  @override
  List<Object> get props => [];
}

class LeavesInitial extends LeavesState {}

class LeavesLoading extends LeavesState {}

class LeavesLoaded extends LeavesState {
  final LeaveBalance balance;
  final List<LeaveRecord> currentYearLeaves;

  LeavesLoaded({required this.balance, required this.currentYearLeaves});

  @override
  List<Object> get props => [balance, currentYearLeaves];
}

class LeaveAddedSuccess extends LeavesState {}

class LeavesError extends LeavesState {
  final String message;
  LeavesError(this.message);
  @override
  List<Object> get props => [message];
}

class LeavesResetSuccess extends LeavesState {}

class LeaveDeletedSuccess extends LeavesState {}