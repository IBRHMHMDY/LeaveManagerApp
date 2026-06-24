import 'package:dartz/dartz.dart';
import 'package:vacation_tracker/core/errors/failures.dart';
import 'package:vacation_tracker/core/usecases/base_usecase.dart';
import 'package:vacation_tracker/domain/entities/settings.dart';
import 'package:vacation_tracker/domain/repositories/settings_repository.dart';


class CheckSettingsExistUseCase implements BaseUseCase<bool, NoParams> {
  final SettingsRepository repository;
  CheckSettingsExistUseCase(this.repository);

  @override
  Future<Either<Failure, bool>> call(NoParams params) async {
    return await repository.hasSettings();
  }
}

class GetSettingsUseCase implements BaseUseCase<Settings, NoParams> {
  final SettingsRepository repository;
  GetSettingsUseCase(this.repository);

  @override
  Future<Either<Failure, Settings>> call(NoParams params) async {
    return await repository.getSettings();
  }
}

class SaveSettingsUseCase implements BaseUseCase<Unit, Settings> {
  final SettingsRepository repository;
  SaveSettingsUseCase(this.repository);

  @override
  Future<Either<Failure, Unit>> call(Settings settings) async {
    return await repository.saveSettings(settings);
  }
}