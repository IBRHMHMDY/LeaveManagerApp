import 'package:equatable/equatable.dart';
import 'package:leave_manager/features/settings/domain/entities/settings_entity.dart';

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