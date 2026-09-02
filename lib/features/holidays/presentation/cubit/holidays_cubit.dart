import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:leave_manager/core/usecases/base_usecase.dart';
import 'package:leave_manager/core/utils/financial_year_calculator.dart';
import 'package:leave_manager/features/holidays/domain/usecases/get_financial_year_holidays_usecase.dart';
import 'package:leave_manager/features/holidays/domain/usecases/get_upcoming_holiday_usecase.dart';
import 'package:leave_manager/features/holidays/domain/usecases/initialize_holidays_usecase.dart';
import 'package:leave_manager/features/notifications/domain/usecases/schedule_all_holidays_usecase.dart';
import 'package:leave_manager/features/settings/domain/usecases/get_settings_usecase.dart';
import 'holidays_state.dart';

@injectable
class HolidaysCubit extends Cubit<HolidaysState> {
  final InitializeHolidaysUseCase _initializeHolidays;
  final GetUpcomingHolidayUseCase _getUpcomingHoliday;
  final GetFinancialYearHolidaysUseCase _getFinancialYearHolidays;
  final GetSettingsUseCase _getSettings;
  final ScheduleAllHolidaysUseCase _scheduleAllHolidays;

  HolidaysCubit(
    this._initializeHolidays,
    this._getUpcomingHoliday,
    this._getFinancialYearHolidays,
    this._getSettings,
    this._scheduleAllHolidays,
  ) : super(HolidaysInitial());

  Future<void> loadHolidays() async {
    emit(HolidaysLoading());
    
    final initResult = await _initializeHolidays(const NoParams());
    
    await initResult.fold(
      (failure) async => emit(HolidaysError(failure.message)),
      (_) async {
        // التحقق من حالة الإعدادات لجدولة العطلات فوراً بعد تهيئتها بنجاح
        final settingsResult = await _getSettings(const NoParams());
        await settingsResult.fold(
          (f) async => null, 
          (settings) async {
            if (settings.enableNotifications) {
              await _scheduleAllHolidays(const NoParams());
            }
          }
        );

        // متابعة جلب العطلات لعرضها في واجهة المستخدم
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