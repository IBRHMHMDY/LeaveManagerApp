// lib/features/backup_restore/presentation/cubit/backup_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:leave_manager/core/usecases/base_usecase.dart';
import 'package:leave_manager/features/backup_restore/domain/usecases/auth_google_usecases.dart';
import 'package:leave_manager/features/backup_restore/domain/usecases/cloud_backup_usecases.dart';
import 'package:leave_manager/features/backup_restore/domain/usecases/local_backup_usecases.dart';
import 'backup_state.dart';

@injectable
class BackupCubit extends Cubit<BackupState> {
  final SignInWithGoogleUseCase _signInWithGoogle;
  final SignOutFromGoogleUseCase _signOutFromGoogle;
  final IsGoogleSignedInUseCase _isGoogleSignedIn;
  final BackupToLocalUseCase _backupToLocal;
  final RestoreFromLocalUseCase _restoreFromLocal;
  final BackupToCloudUseCase _backupToCloud;
  final RestoreFromCloudUseCase _restoreFromCloud;
  final GetLastCloudBackupMetadataUseCase _getLastCloudBackupMetadata;

  BackupCubit(
    this._signInWithGoogle,
    this._signOutFromGoogle,
    this._isGoogleSignedIn,
    this._backupToLocal,
    this._restoreFromLocal,
    this._backupToCloud,
    this._restoreFromCloud,
    this._getLastCloudBackupMetadata,
  ) : super(BackupInitial());

  /// التحقق من حالة تسجيل الدخول وجلب بيانات آخر نسخة سحابية
  Future<void> checkAuthStatus() async {
    emit(const BackupLoading('جاري التحقق من الحساب...'));
    final authResult = await _isGoogleSignedIn(const NoParams());
    
    authResult.fold(
      (failure) => emit(BackupError(failure.message)),
      (isSignedIn) async {
        if (isSignedIn) {
          final metadataResult = await _getLastCloudBackupMetadata(const NoParams());
          metadataResult.fold(
            (failure) => emit(const BackupAuthStatus(isSignedIn: true)),
            (metadata) => emit(BackupAuthStatus(isSignedIn: true, lastBackupMetadata: metadata)),
          );
        } else {
          emit(const BackupAuthStatus(isSignedIn: false));
        }
      },
    );
  }

  Future<void> signIn() async {
    emit(const BackupLoading('جاري تسجيل الدخول...'));
    final result = await _signInWithGoogle(const NoParams());
    result.fold(
      (failure) => emit(BackupError(failure.message)),
      (_) => checkAuthStatus(),
    );
  }

  Future<void> signOut() async {
    emit(const BackupLoading('جاري تسجيل الخروج...'));
    final result = await _signOutFromGoogle(const NoParams());
    result.fold(
      (failure) => emit(BackupError(failure.message)),
      (_) => checkAuthStatus(),
    );
  }

  Future<void> createLocalBackup() async {
    emit(const BackupLoading('جاري إنشاء النسخة المحلية...'));
    final result = await _backupToLocal(const NoParams());
    result.fold(
      (failure) => emit(BackupError(failure.message)),
      (path) {
        emit(const BackupSuccess('تم حفظ النسخة المحليه بنجاح'));
        checkAuthStatus(); // العودة للحالة الأساسية
      },
    );
  }

  Future<void> restoreLocalBackup() async {
    emit(const BackupLoading('جاري استعادة البيانات المحلية...'));
    final result = await _restoreFromLocal(const NoParams());
    result.fold(
      (failure) => emit(BackupError(failure.message)),
      (_) {
        emit(const BackupSuccess('تم استعاده النسخه المحليه بنجاح. يجب إعادة تشغيل التطبيق لتطبيق التغييرات.'));
      },
    );
  }

  Future<void> createCloudBackup() async {
    emit(const BackupLoading('جاري الرفع إلى Google Drive...'));
    final result = await _backupToCloud(const NoParams());
    result.fold(
      (failure) => emit(BackupError(failure.message)),
      (_) {
        emit(const BackupSuccess('تم رفع النسخة الاحتياطية بنجاح.'));
        checkAuthStatus();
      },
    );
  }

  Future<void> restoreCloudBackup() async {
    emit(const BackupLoading('جاري التنزيل والاستعادة من Google Drive...'));
    final result = await _restoreFromCloud(const NoParams());
    result.fold(
      (failure) => emit(BackupError(failure.message)),
      (_) {
        emit(const BackupSuccess('تم استعاده النسخه السحابيه بنجاح. يجب إعادة تشغيل التطبيق لتطبيق التغييرات.'));
      },
    );
  }
}