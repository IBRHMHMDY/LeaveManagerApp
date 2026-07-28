// lib/features/rest_allowances/domain/entities/extra_work_record_entity.dart
import 'package:equatable/equatable.dart';
import 'package:leave_manager/core/utils/enums/work_reason.dart';

/// يمثل كيان العمل الإضافي والعطلات المدمج
class ExtraWorkRecord extends Equatable {
  final int id;
  final WorkReason workReason;
  final DateTime workStartDate;
  final DateTime workEndDate;
  final int daysCount;
  final bool isUsed;
  final DateTime? restStartDate;
  final DateTime? restEndDate;
  final int? holidayId;
  final String? notes;

  const ExtraWorkRecord({
    required this.id,
    required this.workReason,
    required this.workStartDate,
    required this.workEndDate,
    required this.daysCount,
    required this.isUsed,
    this.restStartDate,
    this.restEndDate,
    this.holidayId,
    this.notes,
  });

  @override
  List<Object?> get props => [
        id,
        workReason,
        workStartDate,
        workEndDate,
        daysCount,
        isUsed,
        restStartDate,
        restEndDate,
        holidayId,
        notes,
      ];
}