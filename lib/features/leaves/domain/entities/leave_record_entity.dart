import 'package:equatable/equatable.dart';
import '../../../../core/utils/enums/leave_type.dart';

class LeaveRecord extends Equatable {
  final int id;
  final LeaveType leaveType;
  final DateTime startDate;
  final DateTime endDate;
  final int daysCount;
  final String? notes;

  const LeaveRecord({
    required this.id,
    required this.leaveType,
    required this.startDate,
    required this.endDate,
    required this.daysCount,
    this.notes,
  });

  @override
  List<Object?> get props => [id, leaveType, startDate, endDate, daysCount, notes];
}