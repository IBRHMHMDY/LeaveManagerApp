// lib/features/settings/presentation/bloc/settings_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:leave_manager/core/usecases/base_usecase.dart';
import 'package:leave_manager/features/settings/domain/usecases/check_settings_exist_usecase.dart';
import 'package:leave_manager/features/settings/domain/usecases/get_settings_usecase.dart';
import 'package:leave_manager/features/settings/domain/usecases/save_settings_usecase.dart';
import 'package:leave_manager/core/notifications/domain/usecases/init_notifications_usecase.dart';
import 'package:leave_manager/core/notifications/domain/usecases/request_notification_permissions_usecase.dart';
import 'package:leave_manager/features/settings/presentation/bloc/settings_event.dart';
import 'package:leave_manager/features/settings/presentation/bloc/settings_state.dart';

@injectable
class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final CheckSettingsExistUseCase checkSettingsExist;
  final GetSettingsUseCase getSettings;
  final SaveSettingsUseCase saveSettings;
  
  // 🆕 تم إضافة الـ UseCases الخاصة بالإشعارات
  final InitNotificationsUseCase initNotifications;
  final RequestNotificationPermissionsUseCase requestPermissions;

  SettingsBloc({
    required this.checkSettingsExist,
    required this.getSettings,
    required this.saveSettings,
    required this.initNotifications,
    required this.requestPermissions,
  }) : super(SettingsInitial()) {
    
    on<CheckSettingsEvent>((event, emit) async {
      emit(SettingsLoading());

      // ⚡ دمج عملية تهيئة الإشعارات أثناء فحص الإعدادات 
      await initNotifications(const NoParams());
      await requestPermissions(const NoParams());

      final result = await checkSettingsExist(const NoParams());
      result.fold(
        (failure) => emit(SettingsError(failure.message)),
        (exists) => exists ? emit(SettingsExists()) : emit(SettingsNotFound()),
      );
    });

    on<LoadSettingsEvent>((event, emit) async {
      emit(SettingsLoading());
      final result = await getSettings(const NoParams());
      result.fold(
        (failure) => emit(SettingsError(failure.message)),
        (settings) => emit(SettingsLoaded(settings)),
      );
    });

    on<SaveSettingsEvent>((event, emit) async {
      emit(SettingsLoading());
      final result = await saveSettings(event.settings);
      result.fold(
        (failure) => emit(SettingsError(failure.message)),
        (_) => emit(SettingsSavedSuccess()),
      );
    });
  }
}