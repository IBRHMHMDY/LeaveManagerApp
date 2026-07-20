import 'package:equatable/equatable.dart';

class Holiday extends Equatable {
  final int id;
  final String name;
  final DateTime startDate;
  final DateTime endDate;
  final int daysCount;

  const Holiday({
    required this.id,
    required this.name,
    required this.startDate,
    required this.endDate,
    required this.daysCount,
  });

  int get daysLeft {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final holidayDate = DateTime(startDate.year, startDate.month, startDate.day);
    
    return holidayDate.difference(today).inDays;
  }

  @override
  List<Object> get props => [id, name, startDate, endDate, daysCount];
}