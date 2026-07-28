// lib/features/rest_allowances/data/models/extra_work_mapper.dart
import 'package:leave_manager/core/database/app_database.dart';
import 'package:leave_manager/core/utils/enums/work_reason.dart';
import 'package:leave_manager/features/rest_allowances/domain/entities/extra_work_record_entity.dart';

/// Extension لتحويل نموذج بيانات Drift إلى كيان Domain نظيف
extension ExtraWorkMapper on RestAllowanceModel {
  ExtraWorkRecord toDomain() {
    return ExtraWorkRecord(
      id: id,
      // تحويل الرقم المخزن في قاعدة البيانات إلى Enum
      workReason: workReason == 0 ? WorkReason.holiday : WorkReason.overtime,
      workStartDate: workStartDate,
      workEndDate: workEndDate,
      daysCount: daysCount,
      isUsed: isUsed,
      restStartDate: restStartDate,
      restEndDate: restEndDate,
      holidayId: holidayId,
      notes: notes,
    );
  }
}