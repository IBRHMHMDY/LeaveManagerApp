import 'package:equatable/equatable.dart';

class Settings extends Equatable {
  final int id; 
  final String employeeName;
  final String jobTitle;
  final int totalRegularLeaves;
  final int totalCasualLeaves;
  final String selectedCountry; // تمت إضافة حقل البلد المختار

  const Settings({
    required this.id,
    required this.employeeName,
    required this.jobTitle,
    required this.totalRegularLeaves,
    required this.totalCasualLeaves,
    this.selectedCountry = 'مصر', // القيمة الافتراضية
  });

  @override
  List<Object?> get props => [
        id,
        employeeName,
        jobTitle,
        totalRegularLeaves,
        totalCasualLeaves,
        selectedCountry,
      ];
}