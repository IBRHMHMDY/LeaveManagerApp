// lib/features/settings/data/models/settings_mapper.dart
import 'package:leave_manager/core/database/app_database.dart';
import 'package:leave_manager/core/utils/enums/financial_year_type.dart';
import 'package:leave_manager/features/settings/domain/entities/settings_entity.dart';

extension SettingsMapper on SettingModel {
  Settings toDomain() {
    return Settings(
      id: id,
      employeeName: employeeName,
      jobTitle: jobTitle,
      totalRegularLeaves: totalRegularLeaves,
      totalCasualLeaves: totalCasualLeaves,
      totalSickLeaves: totalSickLeaves,
      financialYearType: financialYearType == 0
          ? FinancialYearType.calendarYear
          : FinancialYearType.fiscalYear,
    );
  }
}