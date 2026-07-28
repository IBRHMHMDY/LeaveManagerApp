// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:shared_preferences/shared_preferences.dart' as _i460;

import '../../features/holidays/data/datasources/holidays_local_data_source.dart'
    as _i828;
import '../../features/holidays/data/repositories/holidays_repository_impl.dart'
    as _i106;
import '../../features/holidays/domain/repositories/holidays_repository.dart'
    as _i171;
import '../../features/holidays/domain/usecases/get_financial_year_holidays_usecase.dart'
    as _i1053;
import '../../features/holidays/domain/usecases/get_upcoming_holiday_usecase.dart'
    as _i11;
import '../../features/holidays/domain/usecases/initialize_holidays_usecase.dart'
    as _i606;
import '../../features/holidays/presentation/cubit/holidays_cubit.dart'
    as _i120;
import '../../features/home/presentation/cubit/home_cubit.dart' as _i9;
import '../../features/leaves/data/datasources/leaves_local_data_source.dart'
    as _i1005;
import '../../features/leaves/data/repositories/leave_repository_impl.dart'
    as _i408;
import '../../features/leaves/domain/repositories/leave_repository.dart'
    as _i388;
import '../../features/leaves/domain/usecases/add_leave_usecase.dart' as _i442;
import '../../features/leaves/domain/usecases/calculate_balances_usecase.dart'
    as _i952;
import '../../features/leaves/domain/usecases/delete_leave_usecase.dart'
    as _i501;
import '../../features/leaves/domain/usecases/get_current_year_leaves_usecase.dart'
    as _i972;
import '../../features/leaves/presentation/blocs/leaves_bloc.dart' as _i562;
import '../../features/rest_allowances/data/datasources/rest_allowances_local_data_source.dart'
    as _i637;
import '../../features/rest_allowances/data/repositories/rest_allowances_repository_impl.dart'
    as _i657;
import '../../features/rest_allowances/domain/repositories/rest_allowances_repository.dart'
    as _i314;
import '../../features/rest_allowances/domain/usecases/add_overtime_usecase.dart'
    as _i426;
import '../../features/rest_allowances/domain/usecases/add_rest_usecase.dart'
    as _i486;
import '../../features/rest_allowances/domain/usecases/delete_overtime_usecase.dart'
    as _i236;
import '../../features/rest_allowances/domain/usecases/delete_rest_allowance_usecase.dart'
    as _i399;
import '../../features/rest_allowances/domain/usecases/get_overtime_records_usecase.dart'
    as _i538;
import '../../features/rest_allowances/domain/usecases/get_rest_allowances_usecase.dart'
    as _i285;
import '../../features/rest_allowances/presentation/blocs/rest_allowances_bloc.dart'
    as _i673;
import '../../features/settings/data/datasources/settings_local_data_source.dart'
    as _i599;
import '../../features/settings/data/repositories/settings_repository_impl.dart'
    as _i955;
import '../../features/settings/domain/repositories/settings_repository.dart'
    as _i674;
import '../../features/settings/domain/usecases/check_settings_exist_usecase.dart'
    as _i787;
import '../../features/settings/domain/usecases/check_settings_exit_usecase.dart'
    as _i643;
import '../../features/settings/domain/usecases/get_settings_usecase.dart'
    as _i1029;
import '../../features/settings/domain/usecases/reset_balances_usecase.dart'
    as _i7;
import '../../features/settings/domain/usecases/save_settings_usecase.dart'
    as _i109;
import '../../features/settings/presentation/bloc/settings_bloc.dart' as _i585;
import '../../shared/themes/theme_cubit.dart' as _i202;
import '../database/app_database.dart' as _i982;
import '../usecases/check_date_overlap_usecase.dart' as _i707;
import 'register_module.dart' as _i291;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  Future<_i174.GetIt> init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final registerModule = _$RegisterModule();
    await gh.factoryAsync<_i460.SharedPreferences>(
      () => registerModule.prefs,
      preResolve: true,
    );
    gh.lazySingleton<_i982.AppDatabase>(() => registerModule.appDatabase);
    gh.lazySingleton<_i828.HolidaysLocalDataSource>(
      () => _i828.HolidaysLocalDataSourceImpl(gh<_i982.AppDatabase>()),
    );
    gh.lazySingleton<_i599.SettingsLocalDataSource>(
      () => _i599.SettingsLocalDataSourceImpl(gh<_i982.AppDatabase>()),
    );
    gh.lazySingleton<_i1005.LeavesLocalDataSource>(
      () => _i1005.LeavesLocalDataSourceImpl(gh<_i982.AppDatabase>()),
    );
    gh.lazySingleton<_i637.RestAllowancesLocalDataSource>(
      () => _i637.RestAllowancesLocalDataSourceImpl(gh<_i982.AppDatabase>()),
    );
    gh.lazySingleton<_i314.RestAllowancesRepository>(
      () => _i657.RestAllowancesRepositoryImpl(
        gh<_i637.RestAllowancesLocalDataSource>(),
      ),
    );
    gh.lazySingleton<_i674.SettingsRepository>(
      () => _i955.SettingsRepositoryImpl(gh<_i599.SettingsLocalDataSource>()),
    );
    gh.factory<_i202.ThemeCubit>(
      () => _i202.ThemeCubit(sharedPreferences: gh<_i460.SharedPreferences>()),
    );
    gh.lazySingleton<_i171.HolidaysRepository>(
      () => _i106.HolidaysRepositoryImpl(gh<_i828.HolidaysLocalDataSource>()),
    );
    gh.lazySingleton<_i1053.GetFinancialYearHolidaysUseCase>(
      () => _i1053.GetFinancialYearHolidaysUseCase(
        gh<_i171.HolidaysRepository>(),
      ),
    );
    gh.lazySingleton<_i11.GetUpcomingHolidayUseCase>(
      () => _i11.GetUpcomingHolidayUseCase(gh<_i171.HolidaysRepository>()),
    );
    gh.lazySingleton<_i606.InitializeHolidaysUseCase>(
      () => _i606.InitializeHolidaysUseCase(gh<_i171.HolidaysRepository>()),
    );
    gh.lazySingleton<_i388.LeaveRepository>(
      () => _i408.LeaveRepositoryImpl(gh<_i1005.LeavesLocalDataSource>()),
    );
    gh.factory<_i120.HolidaysCubit>(
      () => _i120.HolidaysCubit(
        gh<_i606.InitializeHolidaysUseCase>(),
        gh<_i11.GetUpcomingHolidayUseCase>(),
        gh<_i1053.GetFinancialYearHolidaysUseCase>(),
      ),
    );
    gh.lazySingleton<_i236.DeleteOvertimeUseCase>(
      () => _i236.DeleteOvertimeUseCase(gh<_i314.RestAllowancesRepository>()),
    );
    gh.lazySingleton<_i399.DeleteRestAllowanceUseCase>(
      () => _i399.DeleteRestAllowanceUseCase(
        gh<_i314.RestAllowancesRepository>(),
      ),
    );
    gh.lazySingleton<_i538.GetOvertimeRecordsUseCase>(
      () =>
          _i538.GetOvertimeRecordsUseCase(gh<_i314.RestAllowancesRepository>()),
    );
    gh.lazySingleton<_i285.GetRestAllowancesUseCase>(
      () =>
          _i285.GetRestAllowancesUseCase(gh<_i314.RestAllowancesRepository>()),
    );
    gh.lazySingleton<_i707.CheckDateOverlapUseCase>(
      () => _i707.CheckDateOverlapUseCase(
        leaveRepository: gh<_i388.LeaveRepository>(),
        restAllowancesRepository: gh<_i314.RestAllowancesRepository>(),
        holidaysRepository: gh<_i171.HolidaysRepository>(),
      ),
    );
    gh.lazySingleton<_i426.AddOvertimeUseCase>(
      () => _i426.AddOvertimeUseCase(
        gh<_i314.RestAllowancesRepository>(),
        gh<_i707.CheckDateOverlapUseCase>(),
      ),
    );
    gh.lazySingleton<_i486.AddRestUseCase>(
      () => _i486.AddRestUseCase(
        gh<_i314.RestAllowancesRepository>(),
        gh<_i707.CheckDateOverlapUseCase>(),
      ),
    );
    gh.lazySingleton<_i787.CheckSettingsExistUseCase>(
      () => _i787.CheckSettingsExistUseCase(gh<_i674.SettingsRepository>()),
    );
    gh.lazySingleton<_i643.CheckSettingsExistUseCase>(
      () => _i643.CheckSettingsExistUseCase(gh<_i674.SettingsRepository>()),
    );
    gh.lazySingleton<_i1029.GetSettingsUseCase>(
      () => _i1029.GetSettingsUseCase(gh<_i674.SettingsRepository>()),
    );
    gh.lazySingleton<_i7.ResetBalancesUseCase>(
      () => _i7.ResetBalancesUseCase(gh<_i674.SettingsRepository>()),
    );
    gh.lazySingleton<_i109.SaveSettingsUseCase>(
      () => _i109.SaveSettingsUseCase(gh<_i674.SettingsRepository>()),
    );
    gh.factory<_i585.SettingsBloc>(
      () => _i585.SettingsBloc(
        checkSettingsExist: gh<_i643.CheckSettingsExistUseCase>(),
        getSettings: gh<_i1029.GetSettingsUseCase>(),
        saveSettings: gh<_i109.SaveSettingsUseCase>(),
      ),
    );
    gh.factory<_i673.RestAllowancesBloc>(
      () => _i673.RestAllowancesBloc(
        addOvertime: gh<_i426.AddOvertimeUseCase>(),
        addRest: gh<_i486.AddRestUseCase>(),
        getOvertimeRecords: gh<_i538.GetOvertimeRecordsUseCase>(),
        getRestAllowances: gh<_i285.GetRestAllowancesUseCase>(),
        deleteOvertime: gh<_i236.DeleteOvertimeUseCase>(),
        deleteRestAllowance: gh<_i399.DeleteRestAllowanceUseCase>(),
      ),
    );
    gh.lazySingleton<_i501.DeleteLeaveUseCase>(
      () => _i501.DeleteLeaveUseCase(gh<_i388.LeaveRepository>()),
    );
    gh.lazySingleton<_i972.GetCurrentYearLeavesUseCase>(
      () => _i972.GetCurrentYearLeavesUseCase(gh<_i388.LeaveRepository>()),
    );
    gh.lazySingleton<_i952.CalculateBalancesUseCase>(
      () => _i952.CalculateBalancesUseCase(
        getSettingsUseCase: gh<_i1029.GetSettingsUseCase>(),
        getCurrentYearLeavesUseCase: gh<_i972.GetCurrentYearLeavesUseCase>(),
      ),
    );
    gh.lazySingleton<_i442.AddLeaveUseCase>(
      () => _i442.AddLeaveUseCase(
        repository: gh<_i388.LeaveRepository>(),
        calculateBalances: gh<_i952.CalculateBalancesUseCase>(),
        checkDateOverlap: gh<_i707.CheckDateOverlapUseCase>(),
      ),
    );
    gh.factory<_i9.HomeCubit>(
      () => _i9.HomeCubit(
        getSettings: gh<_i1029.GetSettingsUseCase>(),
        calculateBalances: gh<_i952.CalculateBalancesUseCase>(),
        getCurrentYearLeaves: gh<_i972.GetCurrentYearLeavesUseCase>(),
        getRestAllowances: gh<_i285.GetRestAllowancesUseCase>(),
      ),
    );
    gh.factory<_i562.LeavesBloc>(
      () => _i562.LeavesBloc(
        calculateBalances: gh<_i952.CalculateBalancesUseCase>(),
        getCurrentYearLeaves: gh<_i972.GetCurrentYearLeavesUseCase>(),
        addLeave: gh<_i442.AddLeaveUseCase>(),
        resetLeaves: gh<_i7.ResetBalancesUseCase>(),
        deleteLeave: gh<_i501.DeleteLeaveUseCase>(),
      ),
    );
    return this;
  }
}

class _$RegisterModule extends _i291.RegisterModule {}
