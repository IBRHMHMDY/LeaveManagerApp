import 'package:get_it/get_it.dart';
import 'package:vacation_tracker/data/repositories/leave_repository_impl.dart';
import 'package:vacation_tracker/data/repositories/settings_repository_impl.dart';
import 'data/database/app_database.dart';
import 'data/datasources/local_data_source.dart';

import 'domain/repositories/leave_repository.dart';
import 'domain/repositories/settings_repository.dart';
import 'domain/usecases/add_leave_usecase.dart';
import 'domain/usecases/calculate_balances_usecase.dart';
import 'domain/usecases/get_current_year_leaves_usecase.dart';
import 'domain/usecases/settings_usecases.dart';
import 'presentation/blocs/leaves/leaves_bloc.dart';
import 'presentation/blocs/settings/settings_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // --- BLoCs ---
  sl.registerFactory(() => SettingsBloc(
        checkSettingsExist: sl(),
        getSettings: sl(),
        saveSettings: sl(),
      ));
  sl.registerFactory(() => LeavesBloc(
        calculateBalances: sl(),
        getCurrentYearLeaves: sl(),
        addLeave: sl(),
      ));

  // --- Use Cases ---
  sl.registerLazySingleton(() => CheckSettingsExistUseCase(sl()));
  sl.registerLazySingleton(() => GetSettingsUseCase(sl()));
  sl.registerLazySingleton(() => SaveSettingsUseCase(sl()));
  sl.registerLazySingleton(() => AddLeaveUseCase(sl()));
  sl.registerLazySingleton(() => GetCurrentYearLeavesUseCase(sl()));
  sl.registerLazySingleton(() => CalculateBalancesUseCase(
        getSettingsUseCase: sl(),
        getCurrentYearLeavesUseCase: sl(),
      ));

  // --- Repositories ---
  sl.registerLazySingleton<SettingsRepository>(() => SettingsRepositoryImpl(sl()));
  sl.registerLazySingleton<LeaveRepository>(() => LeaveRepositoryImpl(sl()));

  // --- Data Sources ---
  sl.registerLazySingleton<LocalDataSource>(() => LocalDataSourceImpl(sl()));

  // --- Database ---
  sl.registerLazySingleton<AppDatabase>(() => AppDatabase());
}