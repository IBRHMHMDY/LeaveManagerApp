// lib/features/app_updates/presentation/cubit/app_update_state.dart

import 'package:equatable/equatable.dart';
import 'package:leave_manager/features/app_updates/domain/entities/app_update_info.dart';

abstract class AppUpdateState extends Equatable {
  const AppUpdateState();

  @override
  List<Object?> get props => [];
}

class AppUpdateInitial extends AppUpdateState {}

class AppUpdateLoading extends AppUpdateState {}

class AppVersionLoaded extends AppUpdateState {
  final String version;
  const AppVersionLoaded({required this.version});

  @override
  List<Object?> get props => [version];
}

class AppUpdateAvailable extends AppUpdateState {
  final AppUpdateInfo updateInfo;
  const AppUpdateAvailable(this.updateInfo);

  @override
  List<Object?> get props => [updateInfo];
}

class AppUpdateError extends AppUpdateState {
  final String message;
  const AppUpdateError(this.message);

  @override
  List<Object?> get props => [message];
}