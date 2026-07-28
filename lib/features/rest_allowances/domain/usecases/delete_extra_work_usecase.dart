// lib/features/rest_allowances/domain/usecases/delete_extra_work_usecase.dart
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:leave_manager/core/errors/failures.dart';
import 'package:leave_manager/core/usecases/base_usecase.dart';
import 'package:leave_manager/features/rest_allowances/domain/repositories/rest_allowances_repository.dart';

@lazySingleton
class DeleteExtraWorkUseCase implements BaseUseCase<Unit, int> {
  final RestAllowancesRepository repository;

  DeleteExtraWorkUseCase(this.repository);

  @override
  Future<Either<Failure, Unit>> call(int id) async {
    return await repository.deleteExtraWork(id);
  }
}