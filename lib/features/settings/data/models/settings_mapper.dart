import 'package:leave_manager/core/database/app_database.dart';
import 'package:leave_manager/features/settings/domain/entities/settings_entity.dart';

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