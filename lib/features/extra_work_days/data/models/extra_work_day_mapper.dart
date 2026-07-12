import '../../../../core/database/app_database.dart';
import '../../domain/entities/extra_work_day_entity.dart';

extension ExtraWorkDayMapper on ExtraWorkDayModel {
  ExtraWorkDay toDomain() {
    return ExtraWorkDay(
      id: id,
      date: date,
      notes: notes,
    );
  }
}