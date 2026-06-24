import '../../domain/entities/leave_record.dart';
import '../../domain/entities/leave_type.dart';
import '../../domain/entities/settings.dart';
import '../database/app_database.dart';

extension SettingsMapper on SettingModel {
  Settings toDomain() {
    return Settings(
      id: id,
      employeeName: employeeName,
      jobTitle: jobTitle,
      totalRegularLeaves: totalRegularLeaves,
      totalCasualLeaves: totalCasualLeaves,
    );
  }
}

extension LeaveRecordMapper on LeaveRecordModel {
  LeaveRecord toDomain() {
    return LeaveRecord(
      id: id,
      leaveType: leaveType == 0 ? LeaveType.regular : LeaveType.casual,
      startDate: startDate,
      endDate: endDate,
      daysCount: daysCount,
      notes: notes,
    );
  }
}