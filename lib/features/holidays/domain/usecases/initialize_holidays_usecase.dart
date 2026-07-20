import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:leave_manager/core/errors/failures.dart';
import 'package:leave_manager/core/usecases/base_usecase.dart';
import 'package:leave_manager/features/holidays/domain/repositories/holidays_repository.dart';

@lazySingleton
class InitializeHolidaysUseCase implements BaseUseCase<Unit, NoParams> {
  final HolidaysRepository repository;

  InitializeHolidaysUseCase(this.repository);

  @override
  Future<Either<Failure, Unit>> call(NoParams params) async {
    return await repository.initializeHolidays();
  }
}