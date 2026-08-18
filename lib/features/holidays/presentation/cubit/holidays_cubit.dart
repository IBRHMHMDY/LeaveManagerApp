// lib/features/holidays/presentation/cubit/holidays_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:leave_manager/core/usecases/base_usecase.dart';
import 'package:leave_manager/core/utils/financial_year_calculator.dart';
import 'package:leave_manager/core/utils/notification_service.dart';
import 'package:leave_manager/features/holidays/domain/usecases/get_financial_year_holidays_usecase.dart';
import 'package:leave_manager/features/holidays/domain/usecases/get_upcoming_holiday_usecase.dart';
import 'package:leave_manager/features/holidays/domain/usecases/initialize_holidays_usecase.dart';
import 'package:leave_manager/features/settings/domain/usecases/get_settings_usecase.dart';
import 'holidays_state.dart';

@injectable // Auto DI code generation[cite: 2]
class HolidaysCubit extends Cubit<HolidaysState> {
  final InitializeHolidaysUseCase _initializeHolidays;
  final GetUpcomingHolidayUseCase _getUpcomingHoliday;
  final GetFinancialYearHolidaysUseCase _getFinancialYearHolidays;
  final GetSettingsUseCase _getSettings;
  final NotificationService _notificationService;

  HolidaysCubit(
    this._initializeHolidays,
    this._getUpcomingHoliday,
    this._getFinancialYearHolidays,
    this._getSettings,
    this._notificationService,
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
          _getSettings(const NoParams()), // جلب الإعدادات الحالية لجدولة الإشعارات
        ]);

        final upcomingResult = results[0] as dynamic; 
        final listResult = results[1] as dynamic;
        final settingsResult = results[2] as dynamic;

        upcomingResult.fold(
          (failure) => emit(HolidaysError(failure.message)),
          (upcomingHoliday) {
            listResult.fold(
              (failure) => emit(HolidaysError(failure.message)),
              (holidaysList) {
                // تنفيذ الجدولة بعد نجاح جلب العطلات والإعدادات
                settingsResult.fold(
                  (failure) {}, // نتجاهل الخطأ هنا كي لا يتوقف تدفق التطبيق الأساسي
                  (settings) {
                    _notificationService.scheduleHolidayNotifications(
                      holidays: holidaysList,
                      settings: settings,
                    );
                  }
                );

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