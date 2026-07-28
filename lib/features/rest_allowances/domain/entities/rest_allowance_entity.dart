// lib/features/rest_allowances/domain/entities/rest_allowance_entity.dart
import 'package:equatable/equatable.dart';
import 'package:leave_manager/core/utils/enums/work_reason.dart';

/// يمثل كيان يوم الراحة المستهلك كبدل عن عمل إضافي أو عطلة
class RestAllowance extends Equatable {
  final int id;
  final WorkReason workReason;
  final int overtimeId; // للربط بالرصيد الأساسي
  final DateTime startDate;
  final DateTime endDate;
  final int daysCount;
  final String? notes;

  const RestAllowance({
    required this.id,
    required this.workReason,
    required this.overtimeId,
    required this.startDate,
    required this.endDate,
    required this.daysCount,
    this.notes,
  });

  @override
  List<Object?> get props => [id, workReason, overtimeId, startDate, endDate, daysCount, notes];
}