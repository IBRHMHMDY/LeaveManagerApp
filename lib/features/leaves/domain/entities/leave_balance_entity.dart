import 'package:equatable/equatable.dart';

class LeaveBalance extends Equatable {
  final int remainingRegular;
  final int remainingCasual;

  const LeaveBalance({
    required this.remainingRegular,
    required this.remainingCasual,
  });

  @override
  List<Object?> get props => [remainingRegular, remainingCasual];
}