// lib/features/rest_allowances/presentation/blocs/rest_allowances_state.dart
import 'package:equatable/equatable.dart';
import 'package:leave_manager/features/rest_allowances/domain/entities/overtime_record_entity.dart';
import 'package:leave_manager/features/rest_allowances/domain/entities/rest_allowance_entity.dart';

abstract class RestAllowancesState extends Equatable {
  const RestAllowancesState();
  
  @override
  List<Object?> get props => [];
}

class RestAllowancesInitial extends RestAllowancesState {}

class RestAllowancesLoading extends RestAllowancesState {}

class RestAllowancesLoaded extends RestAllowancesState {
  final List<OvertimeRecord> earnedAllowances; // قائمة العمل الإضافي
  final List<RestAllowance> consumedAllowances; // قائمة بدلات الراحة
  final int totalAvailableDays;
  final int totalConsumedDays;

  const RestAllowancesLoaded({
    required this.earnedAllowances,
    required this.consumedAllowances,
    required this.totalAvailableDays,
    required this.totalConsumedDays,
  });

  @override
  List<Object?> get props => [
        earnedAllowances,
        consumedAllowances,
        totalAvailableDays,
        totalConsumedDays,
      ];
}

class RestAllowancesError extends RestAllowancesState {
  final String message;
  
  const RestAllowancesError(this.message);
  
  @override
  List<Object?> get props => [message];
}

class RestAllowanceActionSuccess extends RestAllowancesState {
  final String message;
  
  const RestAllowanceActionSuccess(this.message);
  
  @override
  List<Object?> get props => [message];
}