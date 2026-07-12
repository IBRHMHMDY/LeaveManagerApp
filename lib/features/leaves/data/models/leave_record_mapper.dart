import '../../domain/entities/leave_record_entity.dart';
import '../../../../core/utils/enums/leave_type.dart';
import '../../../../core/database/app_database.dart';

extension LeaveRecordMapper on LeaveRecordModel {
  LeaveRecord toDomain() {
    LeaveType mappedType;
    if (leaveType == 0) {
      mappedType = LeaveType.regular;
    } else if (leaveType == 1) {
      mappedType = LeaveType.casual;
    } else {
      mappedType = LeaveType.restAllowance; // 2: بدل راحة
    }

    return LeaveRecord(
      id: id,
      leaveType: mappedType,
      startDate: startDate,
      endDate: endDate,
      daysCount: daysCount,
      notes: notes,
    );
  }
}