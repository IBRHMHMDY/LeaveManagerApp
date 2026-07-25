import 'package:leave_manager/core/database/app_database.dart';
import 'package:leave_manager/features/rest_allowances/domain/entities/rest_allowance_entity.dart';

extension RestAllowanceMapper on RestAllowanceModel {
  RestAllowance toDomain() {
    return RestAllowance(
      id: id,
      earnedDate: earnedDate,
      consumedDate: consumedDate,
      notes: notes,
    );
  }
}