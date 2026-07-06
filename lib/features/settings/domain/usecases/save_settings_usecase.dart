import 'package:dartz/dartz.dart';
import 'package:leave_manager/core/errors/failures.dart';
import 'package:leave_manager/core/usecases/base_usecase.dart';
import 'package:leave_manager/features/settings/domain/entities/settings_entity.dart';
import 'package:leave_manager/features/settings/domain/repositories/settings_repository.dart';

class SaveSettingsUseCase implements BaseUseCase<Unit, Settings> {
  final SettingsRepository repository;
  SaveSettingsUseCase(this.repository);

  @override
  Future<Either<Failure, Unit>> call(Settings settings) async {
    return await repository.saveSettings(settings);
  }
}