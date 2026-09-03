// lib/features/backup_restore/presentation/cubit/backup_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:leave_manager/core/usecases/base_usecase.dart';
import 'package:leave_manager/features/backup_restore/domain/usecases/local_backup_usecases.dart';
import 'backup_state.dart';

@injectable
class BackupCubit extends Cubit<BackupState> {
  final BackupToLocalUseCase _backupToLocal;
  final RestoreFromLocalUseCase _restoreFromLocal;

  BackupCubit(
    this._backupToLocal,
    this._restoreFromLocal,
  ) : super(BackupInitial());

  Future<void> createLocalBackup() async {
    emit(const BackupLoading('جاري إنشاء نسخة احتياطية محلية...'));
    final result = await _backupToLocal(const NoParams());
    
    result.fold(
      (failure) => emit(BackupError(failure.message)),
      (path) => emit(const BackupSuccess('تم إنشاء النسخة الاحتياطية بنجاح')),
    );
  }

  Future<void> restoreLocalBackup() async {
    emit(const BackupLoading('جاري استعادة النسخة الاحتياطية...'));
    final result = await _restoreFromLocal(const NoParams());
    
    result.fold(
      (failure) => emit(BackupError(failure.message)),
      (_) => emit(const BackupSuccess('تمت الاستعادة بنجاح.')),
    );
  }
}