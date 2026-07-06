import 'package:equatable/equatable.dart';
import 'package:leave_manager/features/settings/domain/entities/settings_entity.dart';

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

class SettingsNotFound extends SettingsState {}

class SettingsSavedSuccess extends SettingsState {
  final String message;
  SettingsSavedSuccess(this.message);
}

class SettingsError extends SettingsState {
  final String message;
  SettingsError(this.message);
  @override
  List<Object> get props => [message];
}
