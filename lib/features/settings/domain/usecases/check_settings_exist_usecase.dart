import 'package:dartz/dartz.dart';
import 'package:leave_manager/core/errors/failures.dart';
import 'package:leave_manager/core/usecases/base_usecase.dart';
import 'package:leave_manager/features/settings/domain/repositories/settings_repository.dart';

class CheckSettingsExistUseCase implements BaseUseCase<bool, NoParams> {
  final SettingsRepository repository;
  CheckSettingsExistUseCase(this.repository);

  @override
  Future<Either<Failure, bool>> call(NoParams params) async {
    return await repository.hasSettings();
  }
}