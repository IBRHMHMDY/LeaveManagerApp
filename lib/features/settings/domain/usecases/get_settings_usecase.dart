import 'package:dartz/dartz.dart';
import 'package:leave_manager/core/errors/failures.dart';
import 'package:leave_manager/core/usecases/base_usecase.dart';
import 'package:leave_manager/features/settings/domain/entities/settings_entity.dart';
import 'package:leave_manager/features/settings/domain/repositories/settings_repository.dart';

class GetSettingsUseCase implements BaseUseCase<Settings, NoParams> {
  final SettingsRepository repository;
  GetSettingsUseCase(this.repository);

  @override
  Future<Either<Failure, Settings>> call(NoParams params) async {
    return await repository.getSettings();
  }
}