import 'package:dartz/dartz.dart';
import 'package:leave_manager/core/errors/failures.dart';
import 'package:leave_manager/core/usecases/base_usecase.dart';
import 'package:leave_manager/features/leaves/domain/repositories/leave_repository.dart';


class DeleteLeaveUseCase implements BaseUseCase<Unit, int> {
  final LeaveRepository repository;

  DeleteLeaveUseCase(this.repository);

  @override
  Future<Either<Failure, Unit>> call(int id) async {
    return await repository.deleteLeave(id);
  }
}