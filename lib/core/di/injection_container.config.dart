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
import '../../features/settings/data/datasources/settings_local_data_source.dart'
    as _i599;
import '../../features/settings/data/repositories/settings_repository_impl.dart'
    as _i955;
import '../../features/settings/domain/repositories/settings_repository.dart'
    as _i674;
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
    gh.lazySingleton<_i599.SettingsLocalDataSource>(
      () => _i599.SettingsLocalDataSourceImpl(gh<_i982.AppDatabase>()),
    );
    gh.lazySingleton<_i1005.LeavesLocalDataSource>(
      () => _i1005.LeavesLocalDataSourceImpl(gh<_i982.AppDatabase>()),
    );
    gh.lazySingleton<_i674.SettingsRepository>(
      () => _i955.SettingsRepositoryImpl(gh<_i599.SettingsLocalDataSource>()),
    );
    gh.factory<_i202.ThemeCubit>(
      () => _i202.ThemeCubit(sharedPreferences: gh<_i460.SharedPreferences>()),
    );
    gh.lazySingleton<_i388.LeaveRepository>(
      () => _i408.LeaveRepositoryImpl(gh<_i1005.LeavesLocalDataSource>()),
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
      ),
    );
    gh.factory<_i9.HomeCubit>(
      () => _i9.HomeCubit(
        getSettings: gh<_i1029.GetSettingsUseCase>(),
        calculateBalances: gh<_i952.CalculateBalancesUseCase>(),
        getCurrentYearLeaves: gh<_i972.GetCurrentYearLeavesUseCase>(),
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
