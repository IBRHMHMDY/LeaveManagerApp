import 'package:equatable/equatable.dart';

class RestAllowance extends Equatable {
  final int id;
  final DateTime earnedDate;
  final DateTime? consumedDate;
  final String? notes;

  const RestAllowance({
    required this.id,
    required this.earnedDate,
    this.consumedDate,
    this.notes,
  });

  /// ميزة مساعدة لمعرفة هل هذا البدل متاح (لم يُستهلك بعد) أم لا.
  bool get isAvailable => consumedDate == null;

  @override
  List<Object?> get props => [id, earnedDate, consumedDate, notes];
}