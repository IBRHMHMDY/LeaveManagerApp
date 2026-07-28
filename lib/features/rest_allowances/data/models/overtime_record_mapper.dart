// lib/features/rest_allowances/data/models/overtime_record_mapper.dart
import 'package:leave_manager/core/database/app_database.dart';
import 'package:leave_manager/features/rest_allowances/domain/entities/overtime_record_entity.dart';
import 'package:leave_manager/core/utils/enums/work_reason.dart';

extension OvertimeRecordMapper on OvertimeRecordModel {
  /// تحويل نموذج قاعدة البيانات إلى كيان المجال (Domain Entity)
  OvertimeRecord toDomain() {
    return OvertimeRecord(
      id: id,
      workReason: workReason == 0 ? WorkReason.holiday : WorkReason.overtime,
      startDate: startDate,
      endDate: endDate,
      daysCount: daysCount,
      isConsumed: isConsumed,
      notes: notes,
      holidayId: holidayId,
    );
  }
}