import 'package:equatable/equatable.dart';

class ExtraWorkDay extends Equatable {
  final int id;
  final DateTime date;
  final String? notes;

  const ExtraWorkDay({
    required this.id,
    required this.date,
    this.notes,
  });

  @override
  List<Object?> get props => [id, date, notes];
}