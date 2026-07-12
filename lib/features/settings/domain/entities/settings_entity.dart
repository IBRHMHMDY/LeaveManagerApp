import 'package:equatable/equatable.dart';

class Settings extends Equatable {
  final int id; 
  final String employeeName;
  final String jobTitle;
  final int totalRegularLeaves;
  final int totalCasualLeaves;


  const Settings({
    required this.id,
    required this.employeeName,
    required this.jobTitle,
    required this.totalRegularLeaves,
    required this.totalCasualLeaves,

  });

  @override
  List<Object?> get props => [
        id,
        employeeName,
        jobTitle,
        totalRegularLeaves,
        totalCasualLeaves,
      ];
}