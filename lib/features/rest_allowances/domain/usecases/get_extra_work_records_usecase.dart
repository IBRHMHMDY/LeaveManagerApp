// lib/features/rest_allowances/domain/usecases/get_extra_work_records_usecase.dart
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:leave_manager/core/errors/failures.dart';
import 'package:leave_manager/core/usecases/base_usecase.dart';
import 'package:leave_manager/features/rest_allowances/domain/entities/extra_work_record_entity.dart';
import 'package:leave_manager/features/rest_allowances/domain/repositories/rest_allowances_repository.dart';

@lazySingleton
class GetExtraWorkRecordsUseCase implements BaseUseCase<List<ExtraWorkRecord>, NoParams> {
  final RestAllowancesRepository repository;

  GetExtraWorkRecordsUseCase(this.repository);

  @override
  Future<Either<Failure, List<ExtraWorkRecord>>> call(NoParams params) async {
    return await repository.getAllExtraWork();
  }
}