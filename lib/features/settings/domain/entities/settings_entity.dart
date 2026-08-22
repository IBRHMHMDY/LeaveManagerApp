// lib/features/settings/domain/entities/settings_entity.dart
import 'package:equatable/equatable.dart';

class Settings extends Equatable {
  final int id;
  final String employeeName;
  final String jobTitle;
  final int totalRegularLeaves;
  final int totalCasualLeaves;
  final bool enableNotifications;
  final int daysBeforeHolidayAlert;
  final String notificationTime;

  const Settings({
    required this.id,
    required this.employeeName,
    required this.jobTitle,
    required this.totalRegularLeaves,
    required this.totalCasualLeaves,
    // --- الحقول الجديدة بقيم افتراضية لتفادي أخطاء الـ null ---
    this.enableNotifications = true,
    this.daysBeforeHolidayAlert = 2,
    this.notificationTime = '10:00',
  });

  @override
  List<Object?> get props => [
    id,
    employeeName,
    jobTitle,
    totalRegularLeaves,
    totalCasualLeaves,
    enableNotifications, // إضافة الخصائص الجديدة هنا
    daysBeforeHolidayAlert,
    notificationTime
  ];
}
