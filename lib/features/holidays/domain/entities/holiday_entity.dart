import 'package:equatable/equatable.dart';

class Holiday extends Equatable {
  final int id;
  final String name;
  final DateTime startDate;
  final DateTime endDate;

  const Holiday({
    required this.id,
    required this.name,
    required this.startDate,
    required this.endDate,
  });

  @override
  List<Object?> get props => [id, name, startDate, endDate];
}