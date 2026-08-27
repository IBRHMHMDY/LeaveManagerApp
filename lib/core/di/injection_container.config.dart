// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:connectivity_plus/connectivity_plus.dart' as _i895;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:shared_preferences/shared_preferences.dart' as _i460;

import '../../features/backup_restore/data/datasources/local_backup_data_source.dart'
    as _i776;
import '../../features/backup_restore/data/datasources/remote_backup_data_source.dart'
    as _i1030;
import '../../features/backup_restore/data/repositories/backup_repository_impl.dart'
    as _i819;
import '../../features/backup_restore/domain/repositories/backup_repository.dart'
    as _i137;
import '../../features/backup_restore/domain/usecases/auth_google_usecases.dart'
    as _i595;
import '../../features/backup_restore/domain/usecases/cloud_backup_usecases.dart'
    as _i685;
import '../../features/backup_restore/domain/usecases/local_backup_usecases.dart'
    as _i290;
import '../../features/backup_restore/presentation/cubit/backup_cubit.dart'
    as _i877;
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
import '../../features/layout/presentation/cubit/layout_cubit.dart' as _i917;
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
import '../../features/notifications/data/datasources/notifications_local_data_source.dart'
    as _i1034;
import '../../features/notifications/data/repositories/notification_repository_impl.dart'
    as _i361;
import '../../features/notifications/domain/repositories/notification_repository.dart'
    as _i367;
import '../../features/notifications/domain/usecases/check_daily_alerts_usecase.dart'
    as _i70;
import '../../features/notifications/domain/usecases/delete_notification_usecase.dart'
    as _i169;
import '../../features/notifications/domain/usecases/get_notifications_usecase.dart'
    as _i587;
import '../../features/notifications/domain/usecases/get_unread_count_usecase.dart'
    as _i85;
import '../../features/notifications/domain/usecases/mark_notification_as_read_usecase.dart'
    as _i889;
import '../../features/notifications/domain/usecases/save_notification_usecase.dart'
    as _i740;
import '../../features/notifications/presentation/bloc/notifications_bloc.dart'
    as _i1041;
import '../../features/rest_allowances/data/datasources/rest_allowances_local_data_source.dart'
    as _i637;
import '../../features/rest_allowances/data/repositories/rest_allowances_repository_impl.dart'
    as _i657;
import '../../features/rest_allowances/domain/repositories/rest_allowances_repository.dart'
    as _i314;
import '../../features/rest_allowances/domain/usecases/add_extra_work_usecase.dart'
    as _i693;
import '../../features/rest_allowances/domain/usecases/delete_extra_work_usecase.dart'
    as _i785;
import '../../features/rest_allowances/domain/usecases/get_extra_work_records_usecase.dart'
    as _i804;
import '../../features/rest_allowances/domain/usecases/use_rest_allowance_usecase.dart'
    as _i474;
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
import '../utils/check_network_info.dart' as _i496;
import '../utils/notifications/notification_flow_manager.dart' as _i292;
import '../utils/notifications/notification_permission_manager.dart' as _i276;
import '../utils/notifications/notification_service.dart' as _i1043;
import '../utils/share_service.dart' as _i518;
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
    gh.factory<_i917.LayoutCubit>(() => _i917.LayoutCubit());
    gh.lazySingleton<_i982.AppDatabase>(() => registerModule.appDatabase);
    gh.lazySingleton<_i895.Connectivity>(() => registerModule.connectivity);
    gh.lazySingleton<_i1043.NotificationService>(
      () => _i1043.NotificationService(),
    );
    gh.lazySingleton<_i518.ShareService>(() => _i518.ShareService());
    gh.lazySingleton<_i828.HolidaysLocalDataSource>(
      () => _i828.HolidaysLocalDataSourceImpl(gh<_i982.AppDatabase>()),
    );
    gh.lazySingleton<_i1030.RemoteBackupDataSource>(
      () => _i1030.RemoteBackupDataSourceImpl(),
    );
    gh.lazySingleton<_i776.LocalBackupDataSource>(
      () => _i776.LocalBackupDataSourceImpl(),
    );
    gh.lazySingleton<_i1034.NotificationsLocalDataSource>(
      () => _i1034.NotificationsLocalDataSourceImpl(gh<_i982.AppDatabase>()),
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
    gh.lazySingleton<_i496.CheckNetworkInfo>(
      () => _i496.CheckNetworkInfoImpl(gh<_i895.Connectivity>()),
    );
    gh.lazySingleton<_i674.SettingsRepository>(
      () => _i955.SettingsRepositoryImpl(gh<_i599.SettingsLocalDataSource>()),
    );
    gh.factory<_i202.ThemeCubit>(
      () => _i202.ThemeCubit(sharedPreferences: gh<_i460.SharedPreferences>()),
    );
    gh.lazySingleton<_i292.NotificationFlowManager>(
      () => _i292.NotificationFlowManager(gh<_i1043.NotificationService>()),
    );
    gh.lazySingleton<_i171.HolidaysRepository>(
      () => _i106.HolidaysRepositoryImpl(gh<_i828.HolidaysLocalDataSource>()),
    );
    gh.lazySingleton<_i137.BackupRepository>(
      () => _i819.BackupRepositoryImpl(
        localDataSource: gh<_i776.LocalBackupDataSource>(),
        remoteDataSource: gh<_i1030.RemoteBackupDataSource>(),
        appDatabase: gh<_i982.AppDatabase>(),
        networkInfo: gh<_i496.CheckNetworkInfo>(),
      ),
    );
    gh.lazySingleton<_i595.SignInWithGoogleUseCase>(
      () => _i595.SignInWithGoogleUseCase(gh<_i137.BackupRepository>()),
    );
    gh.lazySingleton<_i595.SignOutFromGoogleUseCase>(
      () => _i595.SignOutFromGoogleUseCase(gh<_i137.BackupRepository>()),
    );
    gh.lazySingleton<_i595.IsGoogleSignedInUseCase>(
      () => _i595.IsGoogleSignedInUseCase(gh<_i137.BackupRepository>()),
    );
    gh.lazySingleton<_i685.BackupToCloudUseCase>(
      () => _i685.BackupToCloudUseCase(gh<_i137.BackupRepository>()),
    );
    gh.lazySingleton<_i685.RestoreFromCloudUseCase>(
      () => _i685.RestoreFromCloudUseCase(gh<_i137.BackupRepository>()),
    );
    gh.lazySingleton<_i685.GetLastCloudBackupMetadataUseCase>(
      () =>
          _i685.GetLastCloudBackupMetadataUseCase(gh<_i137.BackupRepository>()),
    );
    gh.lazySingleton<_i290.BackupToLocalUseCase>(
      () => _i290.BackupToLocalUseCase(gh<_i137.BackupRepository>()),
    );
    gh.lazySingleton<_i290.RestoreFromLocalUseCase>(
      () => _i290.RestoreFromLocalUseCase(gh<_i137.BackupRepository>()),
    );
    gh.lazySingleton<_i276.NotificationPermissionManager>(
      () =>
          _i276.NotificationPermissionManager(gh<_i1043.NotificationService>()),
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
    gh.lazySingleton<_i367.NotificationRepository>(
      () => _i361.NotificationRepositoryImpl(
        localDataSource: gh<_i1034.NotificationsLocalDataSource>(),
      ),
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
    gh.lazySingleton<_i785.DeleteExtraWorkUseCase>(
      () => _i785.DeleteExtraWorkUseCase(gh<_i314.RestAllowancesRepository>()),
    );
    gh.lazySingleton<_i804.GetExtraWorkRecordsUseCase>(
      () => _i804.GetExtraWorkRecordsUseCase(
        gh<_i314.RestAllowancesRepository>(),
      ),
    );
    gh.lazySingleton<_i707.CheckDateOverlapUseCase>(
      () => _i707.CheckDateOverlapUseCase(
        leaveRepository: gh<_i388.LeaveRepository>(),
        restAllowancesRepository: gh<_i314.RestAllowancesRepository>(),
        holidaysRepository: gh<_i171.HolidaysRepository>(),
      ),
    );
    gh.lazySingleton<_i693.AddExtraWorkUseCase>(
      () => _i693.AddExtraWorkUseCase(
        gh<_i314.RestAllowancesRepository>(),
        gh<_i707.CheckDateOverlapUseCase>(),
      ),
    );
    gh.lazySingleton<_i474.UseRestAllowanceUseCase>(
      () => _i474.UseRestAllowanceUseCase(
        gh<_i314.RestAllowancesRepository>(),
        gh<_i707.CheckDateOverlapUseCase>(),
      ),
    );
    gh.lazySingleton<_i787.CheckSettingsExistUseCase>(
      () => _i787.CheckSettingsExistUseCase(gh<_i674.SettingsRepository>()),
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
    gh.factory<_i877.BackupCubit>(
      () => _i877.BackupCubit(
        gh<_i595.SignInWithGoogleUseCase>(),
        gh<_i595.SignOutFromGoogleUseCase>(),
        gh<_i595.IsGoogleSignedInUseCase>(),
        gh<_i290.BackupToLocalUseCase>(),
        gh<_i290.RestoreFromLocalUseCase>(),
        gh<_i685.BackupToCloudUseCase>(),
        gh<_i685.RestoreFromCloudUseCase>(),
        gh<_i685.GetLastCloudBackupMetadataUseCase>(),
      ),
    );
    gh.lazySingleton<_i501.DeleteLeaveUseCase>(
      () => _i501.DeleteLeaveUseCase(gh<_i388.LeaveRepository>()),
    );
    gh.lazySingleton<_i972.GetCurrentYearLeavesUseCase>(
      () => _i972.GetCurrentYearLeavesUseCase(gh<_i388.LeaveRepository>()),
    );
    gh.factory<_i673.RestAllowancesBloc>(
      () => _i673.RestAllowancesBloc(
        getExtraWorkRecords: gh<_i804.GetExtraWorkRecordsUseCase>(),
        addExtraWork: gh<_i693.AddExtraWorkUseCase>(),
        useRestAllowance: gh<_i474.UseRestAllowanceUseCase>(),
        deleteExtraWork: gh<_i785.DeleteExtraWorkUseCase>(),
      ),
    );
    gh.lazySingleton<_i169.DeleteNotificationUseCase>(
      () => _i169.DeleteNotificationUseCase(gh<_i367.NotificationRepository>()),
    );
    gh.lazySingleton<_i587.GetNotificationsUseCase>(
      () => _i587.GetNotificationsUseCase(gh<_i367.NotificationRepository>()),
    );
    gh.lazySingleton<_i85.GetUnreadCountUseCase>(
      () => _i85.GetUnreadCountUseCase(gh<_i367.NotificationRepository>()),
    );
    gh.lazySingleton<_i889.MarkNotificationAsReadUseCase>(
      () => _i889.MarkNotificationAsReadUseCase(
        gh<_i367.NotificationRepository>(),
      ),
    );
    gh.lazySingleton<_i740.SaveNotificationUseCase>(
      () => _i740.SaveNotificationUseCase(gh<_i367.NotificationRepository>()),
    );
    gh.lazySingleton<_i952.CalculateBalancesUseCase>(
      () => _i952.CalculateBalancesUseCase(
        getSettingsUseCase: gh<_i1029.GetSettingsUseCase>(),
        getCurrentYearLeavesUseCase: gh<_i972.GetCurrentYearLeavesUseCase>(),
      ),
    );
    gh.factory<_i9.HomeCubit>(
      () => _i9.HomeCubit(
        getSettings: gh<_i1029.GetSettingsUseCase>(),
        calculateBalances: gh<_i952.CalculateBalancesUseCase>(),
        getCurrentYearLeaves: gh<_i972.GetCurrentYearLeavesUseCase>(),
        getExtraWorkRecords: gh<_i804.GetExtraWorkRecordsUseCase>(),
      ),
    );
    gh.factory<_i585.SettingsBloc>(
      () => _i585.SettingsBloc(
        checkSettingsExist: gh<_i787.CheckSettingsExistUseCase>(),
        getSettings: gh<_i1029.GetSettingsUseCase>(),
        saveSettings: gh<_i109.SaveSettingsUseCase>(),
      ),
    );
    gh.lazySingleton<_i442.AddLeaveUseCase>(
      () => _i442.AddLeaveUseCase(
        repository: gh<_i388.LeaveRepository>(),
        calculateBalances: gh<_i952.CalculateBalancesUseCase>(),
        checkDateOverlap: gh<_i707.CheckDateOverlapUseCase>(),
      ),
    );
    gh.lazySingleton<_i70.CheckDailyAlertsUseCase>(
      () => _i70.CheckDailyAlertsUseCase(
        holidaysRepository: gh<_i171.HolidaysRepository>(),
        leaveRepository: gh<_i388.LeaveRepository>(),
        saveNotification: gh<_i740.SaveNotificationUseCase>(),
        notificationService: gh<_i1043.NotificationService>(),
      ),
    );
    gh.factory<_i1041.NotificationsBloc>(
      () => _i1041.NotificationsBloc(
        getNotifications: gh<_i587.GetNotificationsUseCase>(),
        markAsRead: gh<_i889.MarkNotificationAsReadUseCase>(),
        deleteNotification: gh<_i169.DeleteNotificationUseCase>(),
        getUnreadCount: gh<_i85.GetUnreadCountUseCase>(),
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
