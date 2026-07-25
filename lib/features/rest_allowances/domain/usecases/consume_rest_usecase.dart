import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:leave_manager/core/errors/failures.dart';
import 'package:leave_manager/core/usecases/base_usecase.dart';
import 'package:leave_manager/features/rest_allowances/domain/repositories/rest_allowances_repository.dart';

class ConsumeRestParams {
  final int id;
  final DateTime consumedDate;
  ConsumeRestParams({required this.id, required this.consumedDate});
}

@lazySingleton
class ConsumeRestUseCase implements BaseUseCase<Unit, ConsumeRestParams> {
  final RestAllowancesRepository repository;

  ConsumeRestUseCase(this.repository);

  @override
  Future<Either<Failure, Unit>> call(ConsumeRestParams params) async {
    return await repository.consumeRest(params.id, params.consumedDate);
  }
}