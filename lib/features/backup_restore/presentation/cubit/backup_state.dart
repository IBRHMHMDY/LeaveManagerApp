// lib/features/backup_restore/presentation/cubit/backup_state.dart
import 'package:equatable/equatable.dart';
import 'package:leave_manager/features/backup_restore/domain/entities/backup_metadata.dart';

abstract class BackupState extends Equatable {
  const BackupState();

  @override
  List<Object?> get props => [];
}

class BackupInitial extends BackupState {}

class BackupLoading extends BackupState {
  final String message;
  const BackupLoading(this.message);

  @override
  List<Object> get props => [message];
}

class BackupSuccess extends BackupState {
  final String message;
  const BackupSuccess(this.message);

  @override
  List<Object> get props => [message];
}

class BackupError extends BackupState {
  final String message;
  const BackupError(this.message);

  @override
  List<Object> get props => [message];
}

class BackupAuthStatus extends BackupState {
  final bool isSignedIn;
  final BackupMetadata? lastBackupMetadata;

  const BackupAuthStatus({
    required this.isSignedIn,
    this.lastBackupMetadata,
  });

  @override
  List<Object?> get props => [isSignedIn, lastBackupMetadata];
}