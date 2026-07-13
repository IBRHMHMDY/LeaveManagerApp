import 'package:dartz/dartz.dart';
import 'package:leave_manager/core/errors/failures.dart';
import 'package:leave_manager/core/usecases/base_usecase.dart';
import 'package:leave_manager/features/rest_allowance/extra_work_days/domain/entities/extra_work_day_entity.dart';
import 'package:leave_manager/features/rest_allowance/extra_work_days/domain/repositories/extra_work_repository.dart';


class GetExtraWorkDaysUseCase implements BaseUseCase<List<ExtraWorkDay>, NoParams> {
  final ExtraWorkRepository repository;

  GetExtraWorkDaysUseCase(this.repository);

  @override
  Future<Either<Failure, List<ExtraWorkDay>>> call(NoParams params) async {
    return await repository.getExtraWorkDays();
  }
}