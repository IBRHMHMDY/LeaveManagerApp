import 'package:equatable/equatable.dart';
import 'package:leave_manager/features/holidays/domain/entities/holiday_entity.dart';

abstract class HolidaysState extends Equatable {
  const HolidaysState();

  @override
  List<Object?> get props => [];
}

class HolidaysInitial extends HolidaysState {}

class HolidaysLoading extends HolidaysState {}

class HolidaysLoaded extends HolidaysState {
  final Holiday? upcomingHoliday;
  final List<Holiday> financialYearHolidays;

  const HolidaysLoaded({
    required this.upcomingHoliday,
    required this.financialYearHolidays,
  });

  // وضعنا المتغيرات في props ليقوم Equatable بمقارنتها بشكل صحيح
  @override
  List<Object?> get props => [upcomingHoliday, financialYearHolidays];
}

class HolidaysError extends HolidaysState {
  final String message;

  const HolidaysError(this.message);

  @override
  List<Object> get props => [message];
}