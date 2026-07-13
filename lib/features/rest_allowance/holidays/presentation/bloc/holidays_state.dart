import 'package:equatable/equatable.dart';
import '../../domain/entities/holiday_entity.dart';

abstract class HolidaysState extends Equatable {
  const HolidaysState();
  
  @override
  List<Object> get props => [];
}

class HolidaysInitial extends HolidaysState {}

class HolidaysLoading extends HolidaysState {}

class HolidaysLoaded extends HolidaysState {
  final List<Holiday> holidays;
  final Holiday? upcomingHoliday;

  const HolidaysLoaded({required this.holidays, this.upcomingHoliday});

  @override
  List<Object> get props => [
    holidays, 
    if (upcomingHoliday != null) upcomingHoliday!
  ];
}

class HolidayOperationSuccess extends HolidaysState {
  final String message;

  const HolidayOperationSuccess(this.message);

  @override
  List<Object> get props => [message];
}

class HolidaysError extends HolidaysState {
  final String message;

  const HolidaysError(this.message);

  @override
  List<Object> get props => [message];
}