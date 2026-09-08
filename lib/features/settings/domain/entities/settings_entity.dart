// lib/features/settings/domain/entities/settings_entity.dart
import 'package:equatable/equatable.dart';
import 'package:leave_manager/core/utils/enums/financial_year_type.dart';

class Settings extends Equatable {
  final int id;
  final String employeeName;
  final String jobTitle;
  final int totalRegularLeaves;
  final int totalCasualLeaves;
  final int totalSickLeaves;
  final FinancialYearType financialYearType;

  const Settings({
    required this.id,
    required this.employeeName,
    required this.jobTitle,
    required this.totalRegularLeaves,
    required this.totalCasualLeaves,
    required this.totalSickLeaves,
    required this.financialYearType,
  });

  @override
  List<Object?> get props => [
    id,
    employeeName,
    jobTitle,
    totalRegularLeaves,
    totalCasualLeaves,
    totalSickLeaves,
    financialYearType,
  ];
}
