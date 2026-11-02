// lib/features/app_updates/domain/usecases/check_update_usecase.dart

import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:leave_manager/core/errors/failures.dart';
import 'package:leave_manager/core/usecases/base_usecase.dart';
import 'package:leave_manager/features/app_updates/domain/entities/app_update_info.dart';
import 'package:leave_manager/features/app_updates/domain/repositories/app_updates_repository.dart';

class CheckUpdateParams {
  final String currentVersion;
  final String osType;
  final String deviceId;

  CheckUpdateParams({required this.currentVersion, required this.osType, required this.deviceId});
}

@lazySingleton
class CheckUpdateUseCase
    implements BaseUseCase<AppUpdateInfo, CheckUpdateParams> {
  final AppUpdatesRepository repository;

  const CheckUpdateUseCase(this.repository);

  @override
  Future<Either<Failure, AppUpdateInfo>> call(CheckUpdateParams params) async {
    return await repository.checkUpdate(
      currentVersion: params.currentVersion,
      osType: params.osType,
      deviceId: params.deviceId,
    );
  }
}
