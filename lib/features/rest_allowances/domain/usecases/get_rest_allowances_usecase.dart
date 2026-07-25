import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:leave_manager/core/errors/failures.dart';
import 'package:leave_manager/core/usecases/base_usecase.dart';
import 'package:leave_manager/features/rest_allowances/domain/entities/rest_allowance_entity.dart';
import 'package:leave_manager/features/rest_allowances/domain/repositories/rest_allowances_repository.dart';

@lazySingleton
class GetRestAllowancesUseCase implements BaseUseCase<List<RestAllowance>, NoParams> {
  final RestAllowancesRepository repository;

  GetRestAllowancesUseCase(this.repository);

  @override
  Future<Either<Failure, List<RestAllowance>>> call(NoParams params) async {
    return await repository.getRestAllowances();
  }
}