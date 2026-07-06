import 'package:equatable/equatable.dart';

class Holiday extends Equatable {
  final int id;
  final String name;
  final DateTime startDate;
  final DateTime endDate;
  final String country; // تمت إضافة حقل البلد

  const Holiday({
    required this.id,
    required this.name,
    required this.startDate,
    required this.endDate,
    required this.country,
  });

  @override
  List<Object?> get props => [id, name, startDate, endDate, country];
}