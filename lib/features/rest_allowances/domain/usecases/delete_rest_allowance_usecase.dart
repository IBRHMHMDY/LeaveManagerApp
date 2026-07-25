import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:leave_manager/core/errors/failures.dart';
import 'package:leave_manager/core/usecases/base_usecase.dart';
import 'package:leave_manager/features/rest_allowances/domain/repositories/rest_allowances_repository.dart';

@lazySingleton
class DeleteRestAllowanceUseCase implements BaseUseCase<Unit, int> {
  final RestAllowancesRepository repository;

  DeleteRestAllowanceUseCase(this.repository);

  @override
  Future<Either<Failure, Unit>> call(int id) async {
    return await repository.deleteRestAllowance(id);
  }
}