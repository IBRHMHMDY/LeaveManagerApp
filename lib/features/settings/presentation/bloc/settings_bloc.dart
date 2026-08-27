// lib/features/settings/presentation/bloc/settings_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:leave_manager/core/usecases/base_usecase.dart';
import 'package:leave_manager/features/settings/domain/usecases/check_settings_exist_usecase.dart';
import 'package:leave_manager/features/settings/domain/usecases/get_settings_usecase.dart';
import 'package:leave_manager/features/settings/domain/usecases/save_settings_usecase.dart';
import 'package:leave_manager/features/settings/presentation/bloc/settings_event.dart';
import 'package:leave_manager/features/settings/presentation/bloc/settings_state.dart';
import 'package:workmanager/workmanager.dart';

@injectable
class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final CheckSettingsExistUseCase checkSettingsExist;
  final GetSettingsUseCase getSettings;
  final SaveSettingsUseCase saveSettings;

  // تعريف اسم المهمة الثابت لاستخدامه في التسجيل والإلغاء
  static const String dailySyncTaskName =
      "com.ibrahimhamdy.leavemanager.dailyAlertsTask";

  SettingsBloc({
    required this.checkSettingsExist,
    required this.getSettings,
    required this.saveSettings,
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
      result.fold((failure) => emit(SettingsError(failure.message)), (_) {
        // 2. إدارة مهام WorkManager بناءً على تفضيل الإشعارات
        if (event.settings.enableNotifications) {
          // تسجيل مهمة تعمل كل 24 ساعة
          Workmanager().registerPeriodicTask(
            "daily_alerts_task_id_1", // معرّف فريد للمهمة
            dailySyncTaskName,
            frequency: const Duration(hours: 24),
            initialDelay: const Duration(
              minutes: 15,
            ), // تأخير بسيط للتشغيل الأول
            constraints: Constraints(
              networkType:
                  NetworkType.notRequired, // لا نحتاج لإنترنت (Offline-First)
              requiresBatteryNotLow: true, // الحفاظ على بطارية المستخدم
            ),
          existingWorkPolicy: ExistingPeriodicWorkPolicy.replace, // تجنب تكرار المهمة
          );
          Workmanager().registerPeriodicTask(
            "test_daily_alerts",
            SettingsBloc.dailySyncTaskName,
            frequency: const Duration(
              minutes: 15,
            ), // أقل مدة يسمح بها النظام للمهام الدورية
            initialDelay: const Duration(
              seconds: 10,
            ), // سيعمل بعد 10 ثوانٍ من الحفظ
          );
        } else {
          // إلغاء المهمة المجدولة إذا قام المستخدم بإغلاق الإشعارات
          Workmanager().cancelByUniqueName(dailySyncTaskName);
        }

        emit(SettingsSavedSuccess());
      });
    });
  }
}
