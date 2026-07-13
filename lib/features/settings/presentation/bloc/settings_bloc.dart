import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:leave_manager/core/usecases/base_usecase.dart';
import 'package:leave_manager/features/settings/domain/usecases/check_settings_exist_usecase.dart';
import 'package:leave_manager/features/settings/domain/usecases/get_settings_usecase.dart';
import 'package:leave_manager/features/settings/domain/usecases/reset_balance_usecase.dart';
import 'package:leave_manager/features/settings/domain/usecases/save_settings_usecase.dart';
import 'package:leave_manager/features/settings/presentation/bloc/settings_events.dart';
import '../../../../core/utils/financial_year_calculator.dart';
import '../../../rest_allowance/holidays/domain/usecases/seed_holidays_use_case.dart';
import 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final CheckSettingsExistUseCase checkSettingsExist;
  final GetSettingsUseCase getSettings;
  final ResetBalancesUseCase resetBalances;
  final SaveSettingsUseCase saveSettings;
  final SeedHolidaysUseCase seedHolidays;

  SettingsBloc({
    required this.checkSettingsExist,
    required this.getSettings,
    required this.resetBalances,
    required this.saveSettings,
    required this.seedHolidays,
  }) : super(SettingsInitial()) {
    on<CheckSettingsEvent>(_onCheckSettingsExist);
    on<LoadSettingsEvent>(_onLoadSettings);
    on<SaveSettingsEvent>(_onSaveSettings);
  }

  Future<void> _onCheckSettingsExist(CheckSettingsEvent event, Emitter<SettingsState> emit) async {
    emit(SettingsLoading());
    final result = await checkSettingsExist(const NoParams());
    result.fold(
      (failure) => emit(SettingsError(failure.message)),
      (exists) => exists ? emit(SettingsInitial()) : emit(SettingsNotFound()),
    );
  }

  Future<void> _onLoadSettings(LoadSettingsEvent event, Emitter<SettingsState> emit) async {
    emit(SettingsLoading());
    final result = await getSettings.call(const NoParams());
    result.fold(
      (failure) => emit(SettingsError(failure.message)),
      (settings) => emit(SettingsLoaded(settings)),
    );
  }

  Future<void> _onSaveSettings(SaveSettingsEvent event, Emitter<SettingsState> emit) async {
    emit(SettingsLoading());
    
    // 1. حفظ الإعدادات الأساسية
    final saveResult = await saveSettings(event.settings);
    
    await saveResult.fold(
      (failure) async => emit(SettingsError(failure.message)),
      (_) async {
        // 2. تحديث وتفريغ الإجازات الرسمية لتتطابق مع البلد الجديد المختار
        final currentYear = FinancialYearCalculator.currentFinancialYearStart.year;
        final seedResult = await seedHolidays(currentYear);
        
        seedResult.fold(
          (failure) => emit(SettingsError('تم الحفظ لكن فشل تحديث الإجازات: ${failure.message}')),
          (_) => emit(SettingsSavedSuccess('تم حفظ الإعدادات وتحديث قائمة الإجازات الرسمية بنجاح.')),
        );
      },
    );
  }
}