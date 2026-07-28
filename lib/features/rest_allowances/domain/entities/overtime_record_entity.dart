// lib/features/rest_allowances/domain/entities/overtime_record_entity.dart
import 'package:equatable/equatable.dart';
import 'package:leave_manager/core/utils/enums/work_reason.dart';

/// يمثل كيان العمل الإضافي أو العطلة الرسمية التي تم العمل بها
class OvertimeRecord extends Equatable {
  final int id;
  final WorkReason workReason;
  final DateTime startDate;
  final DateTime endDate;
  final int daysCount;
  final bool isConsumed;
  final String? notes;
  final int? holidayId;

  const OvertimeRecord({
    required this.id,
    required this.workReason,
    required this.startDate,
    required this.endDate,
    required this.daysCount,
    required this.isConsumed,
    this.notes,
    this.holidayId,
  });

  @override
  List<Object?> get props => [id, workReason, startDate, endDate, daysCount, isConsumed, notes, holidayId];
}