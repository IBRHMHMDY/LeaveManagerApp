import 'package:equatable/equatable.dart';
import 'package:leave_manager/features/rest_allowances/domain/entities/rest_allowance_entity.dart';
import 'package:leave_manager/features/settings/domain/entities/settings_entity.dart';
import 'package:leave_manager/features/leaves/domain/entities/leave_balance_entity.dart';
import 'package:leave_manager/features/leaves/domain/entities/leave_record_entity.dart';

abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object> get props => [];
}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  final Settings settings;
  final LeaveBalance balance;
  final List<LeaveRecord> currentMonthLeaves;
  final List<RestAllowance> currentMonthRestAllowances;

  const HomeLoaded({
    required this.settings,
    required this.balance,
    required this.currentMonthLeaves,
    required this.currentMonthRestAllowances
  });

  @override
  List<Object> get props => [settings, balance, currentMonthLeaves, currentMonthRestAllowances];
}

class HomeError extends HomeState {
  final String message;

  const HomeError(this.message);

  @override
  List<Object> get props => [message];
}