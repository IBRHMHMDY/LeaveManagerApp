import 'package:get_it/get_it.dart';
import 'package:leave_manager/features/holidays/data/datasources/holidays_local_data_source.dart';
import 'package:leave_manager/features/holidays/data/repositories/holiday_repository_impl.dart';
import 'package:leave_manager/features/holidays/domain/repositories/holiday_repository.dart';
import 'package:leave_manager/features/holidays/domain/usecases/add_holiday_use_case.dart';
import 'package:leave_manager/features/holidays/domain/usecases/delete_holiday_use_case.dart';
import 'package:leave_manager/features/holidays/domain/usecases/get_holidays_use_case.dart';
import 'package:leave_manager/features/holidays/domain/usecases/seed_holidays_use_case.dart';
import 'package:leave_manager/features/holidays/presentation/bloc/holidays_bloc.dart';
import 'package:leave_manager/features/settings/domain/usecases/check_settings_exist_usecase.dart';
import 'package:leave_manager/features/settings/domain/usecases/get_settings_usecase.dart';
import 'package:leave_manager/features/settings/domain/usecases/reset_balance_usecase.dart';
import 'package:leave_manager/features/settings/domain/usecases/save_settings_usecase.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:leave_manager/core/database/app_database.dart';
import 'package:leave_manager/features/leaves/domain/usecases/delete_leave_usecase.dart';
import 'package:leave_manager/shared/themes/theme_cubit.dart';
import 'package:leave_manager/features/settings/data/datasources/settings_local_data_source.dart';
import 'package:leave_manager/features/leaves/data/datasources/leaves_local_data_source.dart';
import 'package:leave_manager/features/leaves/data/repositories/leave_repository_impl.dart';
import 'package:leave_manager/features/leaves/domain/repositories/leave_repository.dart';
import 'package:leave_manager/features/leaves/domain/usecases/add_leave_usecase.dart';
import 'package:leave_manager/features/leaves/domain/usecases/calculate_balances_usecase.dart';
import 'package:leave_manager/features/leaves/domain/usecases/get_current_year_leaves_usecase.dart';
import 'package:leave_manager/features/leaves/presentation/blocs/leaves_bloc.dart';
import 'package:leave_manager/features/settings/data/repositories/settings_repository_impl.dart';
import 'package:leave_manager/features/settings/domain/repositories/settings_repository.dart';
import 'package:leave_manager/features/settings/presentation/bloc/settings_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // --- Core Services (أضف هذا القسم) ---
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton<SharedPreferences>(() => sharedPreferences);
  
  // --- Database ---
  sl.registerLazySingleton<AppDatabase>(() => AppDatabase());

  // --- Data Sources ---
  sl.registerLazySingleton<LeavesLocalDataSource>(
    () => LeavesLocalDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<SettingsLocalDataSource>(
    () => SettingsLocalDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<HolidaysLocalDataSource>(() => HolidaysLocalDataSourceImpl(sl()));
  // --- BLoCs ---
  sl.registerFactory(() => ThemeCubit(sharedPreferences: sl()));
  sl.registerFactory(
    () => SettingsBloc(
      checkSettingsExist: sl(),
      getSettings: sl(),
      saveSettings: sl(),
      resetBalances: sl(),
      seedHolidays: sl(),
    ),
  );
  sl.registerFactory(
    () => LeavesBloc(
      calculateBalances: sl(),
      getCurrentYearLeaves: sl(),
      addLeave: sl(),
      resetLeaves: sl(),
      deleteLeave: sl(),
    ),
  );
  sl.registerFactory(
    () => HolidaysBloc(
      getHolidays: sl(),
      addHoliday: sl(),
      deleteHoliday: sl(),
    ),
  );
  // --- Repositories ---
  sl.registerLazySingleton<SettingsRepository>(
    () => SettingsRepositoryImpl(sl()),
  );
  sl.registerLazySingleton<LeaveRepository>(() => LeaveRepositoryImpl(sl()));
  sl.registerLazySingleton<HolidayRepository>(() => HolidayRepositoryImpl(sl()));
  // --- Use Cases ---
  sl.registerLazySingleton(() => CheckSettingsExistUseCase(sl()));
  sl.registerLazySingleton(() => GetSettingsUseCase(sl()));
  sl.registerLazySingleton(() => SaveSettingsUseCase(sl()));
  sl.registerLazySingleton(() => ResetBalancesUseCase(sl()));
  sl.registerLazySingleton(
    () => AddLeaveUseCase(calculateBalances: sl(), repository: sl()),
  );
  sl.registerLazySingleton(() => GetCurrentYearLeavesUseCase(sl()));
  sl.registerLazySingleton(
    () => CalculateBalancesUseCase(
      getSettingsUseCase: sl(),
      getCurrentYearLeavesUseCase: sl(),
    ),
  );
  sl.registerLazySingleton(() => DeleteLeaveUseCase(sl()));
  sl.registerLazySingleton(() => GetHolidaysUseCase(sl()));
  sl.registerLazySingleton(() => AddHolidayUseCase(sl()));
  sl.registerLazySingleton(() => DeleteHolidayUseCase(sl()));
  sl.registerLazySingleton(() => SeedHolidaysUseCase(sl()));

}
