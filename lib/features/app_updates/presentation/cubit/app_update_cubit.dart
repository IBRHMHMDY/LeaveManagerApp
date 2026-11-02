// lib/features/app_updates/presentation/cubit/app_update_cubit.dart

import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:leave_manager/core/services/device_identity_service.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:leave_manager/features/app_updates/domain/usecases/check_update_usecase.dart';
import 'app_update_state.dart';

@injectable
class AppUpdateCubit extends Cubit<AppUpdateState> {
  final CheckUpdateUseCase _checkUpdateUseCase;
  final DeviceIdentityService _deviceIdentityService;
  
  AppUpdateCubit(this._checkUpdateUseCase, this._deviceIdentityService) : super(AppUpdateInitial());

  // دالة مخصصة لجلب رقم الإصدار فقط (لعرضه في الإعدادات)
  Future<void> fetchVersionOnly() async {
    emit(AppUpdateLoading());
    final packageInfo = await PackageInfo.fromPlatform();
    emit(AppVersionLoaded(version: packageInfo.version));
  }

  // دالة فحص التحديثات من الخادم
  Future<void> checkForUpdates() async {
    emit(AppUpdateLoading());
    final packageInfo = await PackageInfo.fromPlatform();
    final osType = Platform.isAndroid ? 'android' : 'ios';
    final deviceId = await _deviceIdentityService.getDeviceId();

    final result = await _checkUpdateUseCase(
      CheckUpdateParams(currentVersion: packageInfo.version, osType: osType, deviceId: deviceId),
    );

    result.fold(
      (failure) {
        // نرسل الخطأ أولاً
        emit(AppUpdateError(failure.message));
        // ثم نرسل رقم الإصدار كحالة نهائية حتى لا يتعطل واجهة المستخدم
        emit(AppVersionLoaded(version: packageInfo.version));
      },
      (updateInfo) {
        if (updateInfo.updateRequired) {
          emit(AppUpdateAvailable(updateInfo));
        } else {
          emit(AppVersionLoaded(version: packageInfo.version));
        }
      },
    );
  }
}