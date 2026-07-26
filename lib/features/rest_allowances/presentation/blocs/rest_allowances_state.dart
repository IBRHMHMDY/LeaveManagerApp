import 'package:equatable/equatable.dart';
import 'package:leave_manager/features/rest_allowances/domain/entities/rest_allowance_entity.dart';

abstract class RestAllowancesState extends Equatable {
  const RestAllowancesState();

  @override
  List<Object?> get props => [];
}

class RestAllowancesInitial extends RestAllowancesState {}

class RestAllowancesLoading extends RestAllowancesState {}

class RestAllowancesLoaded extends RestAllowancesState {
  final List<RestAllowance> earnedAllowances;
  final List<RestAllowance> consumedAllowances;
  final int totalAvailableDays; // الرصيد المتاح 
  final int totalConsumedDays;  //الرصيد المستهلك 

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