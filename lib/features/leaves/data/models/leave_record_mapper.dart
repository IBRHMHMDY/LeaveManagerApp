import '../../domain/entities/leave_record_entity.dart';
import '../../../../core/utils/enums/leave_type.dart';
import '../../../../core/database/app_database.dart';



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