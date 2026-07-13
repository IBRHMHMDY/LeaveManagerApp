import 'package:equatable/equatable.dart';
import '../../domain/entities/holiday_entity.dart';

abstract class HolidaysEvent extends Equatable {
  const HolidaysEvent();

  @override
  List<Object> get props => [];
}

class LoadHolidaysEvent extends HolidaysEvent {}
class AddHolidayEvent extends HolidaysEvent {
  final Holiday holiday;

  const AddHolidayEvent(this.holiday);

  @override
  List<Object> get props => [holiday];
}

class DeleteHolidayEvent extends HolidaysEvent {
  final int id;

  const DeleteHolidayEvent(this.id);

  @override
  List<Object> get props => [id];
}