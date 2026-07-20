import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:leave_manager/core/errors/failures.dart';
import 'package:leave_manager/core/usecases/base_usecase.dart';
import 'package:leave_manager/features/settings/domain/repositories/settings_repository.dart';

@lazySingleton
class ResetBalancesUseCase implements BaseUseCase<Unit, NoParams> {
  final SettingsRepository repository;

  ResetBalancesUseCase(this.repository);

  @override
  Future<Either<Failure, Unit>> call(NoParams params) async {
    return await repository.resetBalances();
  }
}