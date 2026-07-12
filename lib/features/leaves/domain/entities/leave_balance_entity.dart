import 'package:equatable/equatable.dart';

class LeaveBalance extends Equatable {
  final int remainingRegular;
  final int remainingCasual;
  final int remainingRestAllowances;

  const LeaveBalance({
    required this.remainingRegular,
    required this.remainingCasual,
    required this.remainingRestAllowances,
  });

  @override
  List<Object?> get props => [remainingRegular, remainingCasual, remainingRestAllowances];
}