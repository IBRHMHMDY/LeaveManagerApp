import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/base_usecase.dart';
import '../repositories/extra_work_repository.dart';

class DeleteExtraWorkDayParams extends Equatable {
  final int id;

  const DeleteExtraWorkDayParams({required this.id});

  @override
  List<Object?> get props => [id];
}

class DeleteExtraWorkDayUseCase implements BaseUseCase<Unit, DeleteExtraWorkDayParams> {
  final ExtraWorkRepository repository;

  DeleteExtraWorkDayUseCase(this.repository);

  @override
  Future<Either<Failure, Unit>> call(DeleteExtraWorkDayParams params) async {
    return await repository.deleteExtraWorkDay(params.id);
  }
}