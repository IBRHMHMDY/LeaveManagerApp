import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:leave_manager/core/errors/failures.dart';
import 'package:leave_manager/core/usecases/base_usecase.dart';
import 'package:leave_manager/features/rest_allowances/domain/entities/overtime_record_entity.dart';
import 'package:leave_manager/features/rest_allowances/domain/repositories/rest_allowances_repository.dart';

@lazySingleton
class GetOvertimeRecordsUseCase implements BaseUseCase<List<OvertimeRecord>, NoParams> {
  final RestAllowancesRepository repository;

  GetOvertimeRecordsUseCase(this.repository);

  @override
  Future<Either<Failure, List<OvertimeRecord>>> call(NoParams params) async {
    return await repository.getOvertimeRecords();
  }
}