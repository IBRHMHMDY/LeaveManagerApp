import 'package:leave_manager/core/database/app_database.dart';
import 'package:leave_manager/features/holidays/domain/entities/holiday_entity.dart';

extension HolidayMapper on HolidayModel {
  Holiday toDomain() {
    return Holiday(
      id: id,
      name: name,
      startDate: startDate,
      endDate: endDate,
      daysCount: daysCount,
    );
  }
}