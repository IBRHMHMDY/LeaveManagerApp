import 'package:equatable/equatable.dart';

abstract class RestAllowancesEvent extends Equatable {
  const RestAllowancesEvent();

  @override
  List<Object?> get props => [];
}

/// حدث تحميل بدلات الراحة وفرزها
class LoadRestAllowancesEvent extends RestAllowancesEvent {}

/// حدث إضافة يوم كسب راحة جديد
class AddEarnedRestEvent extends RestAllowancesEvent {
  final DateTime earnedDate;
  final String? notes;

  const AddEarnedRestEvent({required this.earnedDate, this.notes});

  @override
  List<Object?> get props => [earnedDate, notes];
}

/// حدث استهلاك بدل راحة (طلب إجازة)
class ConsumeRestEvent extends RestAllowancesEvent {
  final int id;
  final DateTime consumedDate;

  const ConsumeRestEvent({required this.id, required this.consumedDate});

  @override
  List<Object?> get props => [id, consumedDate];
}

/// حدث حذف سجل راحة (سواء كان مكتسباً أو مستهلكاً)
class DeleteRestEvent extends RestAllowancesEvent {
  final int id;

  const DeleteRestEvent(this.id);

  @override
  List<Object?> get props => [id];
}