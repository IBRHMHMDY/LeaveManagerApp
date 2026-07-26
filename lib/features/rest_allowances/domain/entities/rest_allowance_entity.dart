import 'package:equatable/equatable.dart';

class RestAllowance extends Equatable {
  final int id;
  // نوع الحركة: 0 = بدل راحة مكتسب (Earned)، 1 = استهلاك بدل راحة (Consumed)
  final int type;
  final DateTime startDate;
  final DateTime endDate;
  final DateTime? linkedEarnedDate;
  final int daysCount;
  final String? notes;

  const RestAllowance({
    required this.id,
    required this.type,
    required this.startDate,
    required this.endDate,
    required this.daysCount,
    this.linkedEarnedDate,
    this.notes,
  });

  /// دالة مساعدة لمعرفة ما إذا كان السجل هو إضافة رصيد (مكتسب)
  bool get isEarned => type == 0;

  /// دالة مساعدة لمعرفة ما إذا كان السجل هو استهلاك من الرصيد
  bool get isConsumed => type == 1;

  @override
  List<Object?> get props => [id, type, startDate, endDate, linkedEarnedDate, daysCount, notes];
}
