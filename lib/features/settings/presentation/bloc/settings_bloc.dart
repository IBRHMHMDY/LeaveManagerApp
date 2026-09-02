import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:leave_manager/core/usecases/base_usecase.dart';
import 'package:leave_manager/core/utils/notifications/notification_service.dart';
import 'package:leave_manager/features/notifications/domain/usecases/schedule_all_holidays_usecase.dart';
import 'package:leave_manager/features/settings/domain/usecases/check_settings_exist_usecase.dart';
import 'package:leave_manager/features/settings/domain/usecases/get_settings_usecase.dart';
import 'package:leave_manager/features/settings/domain/usecases/save_settings_usecase.dart';
import 'package:leave_manager/features/settings/presentation/bloc/settings_event.dart';
import 'package:leave_manager/features/settings/presentation/bloc/settings_state.dart';

@injectable
class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final CheckSettingsExistUseCase checkSettingsExist;
  final GetSettingsUseCase getSettings;
  final SaveSettingsUseCase saveSettings;
  final ScheduleAllHolidaysUseCase scheduleAllHolidays;
  final NotificationService notificationService;

  SettingsBloc({
    required this.checkSettingsExist,
    required this.getSettings,
    required this.saveSettings,
    required this.scheduleAllHolidays,
    required this.notificationService,
  }) : super(SettingsInitial()) {
    
    on<CheckSettingsEvent>((event, emit) async {
      emit(SettingsLoading());
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
      
      // نستخدم await داخل الـ fold لضمان اكتمال العمليات غير المتزامنة
      await result.fold(
        (failure) async => emit(SettingsError(failure.message)), 
        (_) async {
          // إدارة الإشعارات بناءً على اختيار المستخدم
          if (event.settings.enableNotifications) {
            await scheduleAllHolidays(const NoParams());
          } else {
            // المسح الكلي للإشعارات المجدولة في حال قام المستخدم بإلغاء التفعيل
            await notificationService.cancelAllNotifications();
          }
          emit(SettingsSavedSuccess());
      });
    });
  }
}