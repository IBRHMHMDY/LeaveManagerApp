// lib/features/settings/presentation/bloc/settings_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:leave_manager/core/usecases/base_usecase.dart';
import 'package:leave_manager/features/notifications/domain/usecases/subscribe_to_topic_usecase.dart';
import 'package:leave_manager/features/notifications/domain/usecases/unsubscribe_from_topic_usecase.dart';
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
  final SubscribeToTopicUseCase subscribeToTopic; // <-- إضافة UseCase
  final UnsubscribeFromTopicUseCase unsubscribeFromTopic; // <-- إضافة UseCase


  SettingsBloc({
    required this.checkSettingsExist,
    required this.getSettings,
    required this.saveSettings,
    required this.subscribeToTopic,
    required this.unsubscribeFromTopic,
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
      
      // 1. حفظ الإعدادات في قاعدة البيانات (Drift)
      final result = await saveSettings(event.settings);
      
      // 2. تحديث حالة اشتراك Firebase Topic بناءً على خيار المستخدم
      if (event.settings.enableNotifications) {
        await subscribeToTopic('holidays_alerts');
      } else {
        await unsubscribeFromTopic('holidays_alerts');
      }

      result.fold(
        (failure) => emit(SettingsError(failure.message)),
        (_) => emit(SettingsSavedSuccess()),
      );
    });
  }
}