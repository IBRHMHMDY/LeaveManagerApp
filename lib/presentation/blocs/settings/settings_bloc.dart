import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../domain/entities/settings.dart';
import '../../../domain/usecases/settings_usecases.dart';
import '../../../core/usecases/base_usecase.dart';

// --- Events ---
abstract class SettingsEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class CheckSettingsEvent extends SettingsEvent {}
class LoadSettingsEvent extends SettingsEvent {}
class SaveSettingsEvent extends SettingsEvent {
  final Settings settings;
  SaveSettingsEvent(this.settings);
  @override
  List<Object> get props => [settings];
}

// --- States ---
abstract class SettingsState extends Equatable {
  @override
  List<Object> get props => [];
}

class SettingsInitial extends SettingsState {}
class SettingsLoading extends SettingsState {}
class SettingsLoaded extends SettingsState {
  final Settings settings;
  SettingsLoaded(this.settings);
  @override
  List<Object> get props => [settings];
}
class SettingsNotFound extends SettingsState {} // يستخدم للتوجيه لشاشة الإعدادات
class SettingsSavedSuccess extends SettingsState {}
class SettingsError extends SettingsState {
  final String message;
  SettingsError(this.message);
  @override
  List<Object> get props => [message];
}

// --- BLoC ---
class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final CheckSettingsExistUseCase checkSettingsExist;
  final GetSettingsUseCase getSettings;
  final SaveSettingsUseCase saveSettings;

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
        (exists) => exists ? emit(SettingsInitial()) /* جاهز للتحميل */ : emit(SettingsNotFound()),
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