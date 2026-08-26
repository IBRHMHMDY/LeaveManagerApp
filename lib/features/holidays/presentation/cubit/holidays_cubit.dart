// lib/features/holidays/presentation/cubit/holidays_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:leave_manager/core/usecases/base_usecase.dart';
import 'package:leave_manager/core/utils/financial_year_calculator.dart';
import 'package:leave_manager/features/holidays/domain/usecases/get_financial_year_holidays_usecase.dart';
import 'package:leave_manager/features/holidays/domain/usecases/get_upcoming_holiday_usecase.dart';
import 'package:leave_manager/features/holidays/domain/usecases/initialize_holidays_usecase.dart';
import 'holidays_state.dart';

@injectable
class HolidaysCubit extends Cubit<HolidaysState> {
  final InitializeHolidaysUseCase _initializeHolidays;
  final GetUpcomingHolidayUseCase _getUpcomingHoliday;
  final GetFinancialYearHolidaysUseCase _getFinancialYearHolidays;

  HolidaysCubit(
    this._initializeHolidays,
    this._getUpcomingHoliday,
    this._getFinancialYearHolidays,
  ) : super(HolidaysInitial());

  Future<void> loadHolidays() async {
    emit(HolidaysLoading());
    
    final initResult = await _initializeHolidays(const NoParams());
    
    initResult.fold(
      (failure) => emit(HolidaysError(failure.message)),
      (_) async {
        final today = DateTime.now();
        final params = DateRangeParams(
          start: FinancialYearCalculator.currentFinancialYearStart,
          end: FinancialYearCalculator.currentFinancialYearEnd,
        );
        
        final results = await Future.wait([
          _getUpcomingHoliday(today),
          _getFinancialYearHolidays(params),
        ]);

        final upcomingResult = results[0] as dynamic;
        final listResult = results[1] as dynamic;

        upcomingResult.fold(
          (failure) => emit(HolidaysError(failure.message)),
          (upcomingHoliday) {
            listResult.fold(
              (failure) => emit(HolidaysError(failure.message)),
              (holidaysList) {
                // تم إزالة استدعاء جدولة الإشعارات المحلية هنا
                emit(HolidaysLoaded(
                  upcomingHoliday: upcomingHoliday,
                  financialYearHolidays: holidaysList,
                ));
              },
            );
          },
        );
      },
    );
  }
}